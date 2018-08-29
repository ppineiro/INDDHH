(function() {

    function ParserIn() {
        //private//

        this.setup();
    }
    
    //static public//
    
    
    var element = facilis.extend(ParserIn, {});
    
    /*
        element.BaseClassSetup=element.setup;
    */
    element.setup = function() {
        this.parsedXML=null;
        this.toParseXML=null;

        this.workflowProcessName=null;
        this.mainWorkflowProcessId=null;

        this.workflowProcessObj=null;
        this.processAction = "";

    };
    
    

    ParserIn.performers = [];
	ParserIn.artifacts = [];
	ParserIn.datastores = [];

    element.parse=function(node) {
        this.workflowProcessName = "";
        toParseXML = node;
        if (!node.firstElementChild) {
            return null;
        }
        node = node.firstElementChild;
        var artifacts;
        var associations;
        var messageFlows;
        var i;
		
		//Levantamos los datastores
		for (i = 0; i < node.children.length; i++ ) {
			if (node.children[i].localName == "DataStores") {
				this.parseDataStores(node.children[i], this.datastores);
				break;
			}
		}
		
        for (i = 0; i < node.children.length; i++ ) {
            if (node.children[i].localName == "Pools") {
                this.parsePools(node.children[i]);
            }
            if (node.children[i].localName=="Artifacts") {
                this.artifacts = this.parseArtifacts(node.children[i]);
            }
            if (node.children[i].localName=="Associations") {
                this.associations = this.parseAssociations(node.children[i]);
            }
            if (node.children[i].localName == "MessageFlows") {
                this.messageFlows = this.parseMessageFlows(node.children[i]);
            }
            if (node.children[i].localName == "Participants") {
                var Participants = node.children[i];
                for (var p = 0; p < Participants.children.length; p++ ) {
                    var Participant=Participants.children[p]
                    ParserIn.addParticipant(Participant.getAttribute("Id"), Participant.getAttribute("Name"));
                }
            }
        }


        var subElements = facilis.parsers.ParseInUtils.getSubNode(this.parsedXML, "subElements");
        if(!subElements){
            subElements = this.parsedXML.ownerDocument.createElement("subElements");
            this.parsedXML.appendChild(subElements);
        }
        if(this.artifacts){
            i = 0;
            for (i = 0; i < this.artifacts.length; i++ ) {
                if (facilis.View.importDisconnectedArtifacts || (!facilis.View.importDisconnectedArtifacts && this.artifactHasValidAssociation(this.artifacts[i], this.associations))) {
                    this.parsedXML.appendChild(this.artifacts[i]);
                }
            }
        }
        if (this.associations) {
            i = 0;
            for (i = 0; i < this.associations.length; i++ ) {
                this.parsedXML.appendChild(this.associations[i]);
            }
        }
        if (this.messageFlows) {
            i = 0;
            for (i = 0; i < this.messageFlows.length; i++ ) {
                this.parsedXML.appendChild(this.messageFlows[i]);
            }
        }
        return this.parsedXML;
    }

    element.artifactHasValidAssociation=function(artifact, associations) {
        if(associations && artifact.getAttribute("name")=="dataobject"){
            for (var i = 0; i < associations.length; i++ ) {
                var association = associations[i];
                if (association.getAttribute("startid") == artifact.getAttribute("id") || association.getAttribute("endid") == artifact.getAttribute("id")) {
                    return true;
                }
            }
        }else if (artifact.getAttribute("name") != "dataobject") {
            return true;
        }
        return false;
    }

    element.parsePools=function(poolsXML) {
        var pools = new Array();
        var mainPool;
        var i;
        //if (View.getInstance().offline) {
        //if(false){
            var noMainPool = true;
            var mainPoolNode;

            var newPools=facilis.parsers.ParseInUtils.getParsedNode("<Pools></Pools>");
            var backPool;
            var fakePool;

            for (i = 0; i < poolsXML.children.length; i++ ) {
                mainPool = poolsXML.children[i].getAttribute("MainPool");
                //var BoundaryVisible = poolsXML.children[i].getAttribute("BoundaryVisible");
                if (mainPool == "true") {
                    mainPoolNode = poolsXML.children[i];
                    noMainPool = false;
                }
            }
            
            if (!noMainPool) {
                if (mainPoolNode.getAttribute("BoundaryVisible") == "true") {
                    backPool = facilis.parsers.ParseInUtils.getParsedNode("<Pool></Pool>");
                    fakePool = mainPoolNode.cloneNode(true);
                    backPool.setAttribute("MainPool", "true");
                    mainPoolNode.setAttribute("MainPool","false");
                    fakePool.setAttribute("Process", "");
                    newPools.appendChild(backPool);
                    newPools.appendChild(fakePool);
                    poolsXML = newPools;
                }else{
                    var wfprocesses = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "WorkflowProcesses");
                    var poolsToId = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "Pools");
                    var poolIds = new Object();
                    for (var po = 0; po < poolsToId.children.length; po++ ) {
                        poolIds[poolsToId.children[po].getAttribute("Process")]=true;
                    }
                    var auxName = "";
                    for (var w = 0; w < wfprocesses.children.length; w++ ) {
                        if ((wfprocesses.children[w].getAttribute("Id") == mainPoolNode.getAttribute("Process")) && wfprocesses.children[w].getAttribute("Name")) {
                            mainPoolNode.setAttribute("Name", wfprocesses.children[w].getAttribute("Name"));
                        }
                        var obj;
                        var o;
                        if (wfprocesses.children[w].getAttribute("Name") && facilis.parsers.ParseInUtils.getSubNode(wfprocesses.children[w], "Activities") ) {
                            this.workflowProcessName = wfprocesses.children[w].getAttribute("Name");
                            obj = null;
                            o = 0;
                            for (o = 0; o < wfprocesses.children[w].children.length; o++ ) {
                                if (wfprocesses.children[w].children[o].localName == "Object") {
                                    //obj = wfprocesses.children[w].children[o];
                                    obj = wfprocesses.children[w];
                                    break;
                                }
                            }
                            if (obj) {
                                //workflowProcessObj = obj.cloneNode(true);
                                //obj.removeNode();
                                this.workflowProcessObj = obj;
                            }
                        }
                        if (this.workflowProcessName != "") {
                            break;
                        }
                        if (wfprocesses.children[w].getAttribute("Name") && poolIds[wfprocesses.children[w].getAttribute("Name")]) {
                            auxName = wfprocesses.children[w].getAttribute("Name");
                            if(!obj){
                                for (o = 0; o < wfprocesses.children[w].children.length; o++ ) {
                                    if (wfprocesses.children[w].children[o].localName == "Object") {
                                        //obj = wfprocesses.children[w].children[o];
                                        obj = wfprocesses.children[w];
                                        break;
                                    }
                                }
                            }
                            if (obj) {
                                //workflowProcessObj = obj.cloneNode(true);
                                //obj.removeNode();
                                this.workflowProcessObj = obj;
                            }
                        }
                        if (wfprocesses.children[w].getAttribute("ProAction")) {
                            this.processAction = wfprocesses.children[w].getAttribute("ProAction");
                        }
                    }
                    if (this.workflowProcessName == "" && auxName!="") {
                        this.workflowProcessName = auxName;
                    }
                    if (!mainPoolNode.getAttribute("Name")) {
                        mainPoolNode.setAttribute("Name", this.workflowProcessName);
                    }
                    if (this.workflowProcessObj) {
                        //mainPoolNode.appendChild(workflowProcessObj);
                        var toAdd = this.removeWFNodes(this.workflowProcessObj);
                        //for (var t = 0; t < toAdd.length; t++ ) {
                        var counter = 0;
                        //while (counter < 5 || toAdd.length > 0) {
                        while (toAdd.length > 0) {
                            //mainPoolNode.appendChild(toAdd[t]);
                            mainPoolNode.appendChild(toAdd[0]);
                            toAdd.splice(0, 1);
                            counter++;
                        }
                    }
                }
            }else{
                i = 0;
                for (i = 0; i < poolsXML.children.length; i++ ) {
                    var BoundaryVisible = poolsXML.children[i].getAttribute("BoundaryVisible");
                    if (BoundaryVisible == "false") {
                        mainPoolNode = poolsXML.children[i];
                        break;
                    }
                }
                if (!mainPoolNode) {
                    mainPoolNode = poolsXML.children[0];
                }
                mainPoolNode.setAttribute("MainPool", "true");
                noMainPool = false;
            }

        //}
        mainPool = "false";

        for (i = 0; i < poolsXML.children.length; i++ ) {
            var p;
            if(mainPool=="false"){
                mainPool = poolsXML.children[i].getAttribute("MainPool")+"";
                if(mainPool!="true"){
                    mainPool = (poolsXML.children[i].getAttribute("BoundaryVisible") == "false").toString();
                }
            }
            if (mainPool == "true") {
                p = this.getElementParser("back");
                p.setParsedNode(facilis.ElementAttributeController.getInstance().getElementAttributes("back"));
            }else {
                p = this.getElementParser("pool");
                p.setParsedNode(facilis.ElementAttributeController.getInstance().getElementAttributes("pool"));
            }
            var pool = p.parse(poolsXML.children[i]);
            //var visible = poolsXML.children[i].getAttribute("BoundaryVisible");
            if (mainPool=="true") {
                this.parsedXML = pool;
                mainPool = "ready";
            }else {
                pools.push(pool);
            }
            
        }
        var subElements = facilis.parsers.ParseInUtils.getSubNode(this.parsedXML, "subElements");
        if (!subElements) {
            subElements = this.parsedXML.ownerDocument.createElement("subElements");
            this.parsedXML.appendChild(subElements);
        }
        i = 0;
        for (i = 0; i < pools.length; i++ ) {
            subElements.appendChild(pools[i]);
            this.parseWorkflow(pools[i]);
        }
        this.parsedXML.appendChild(subElements);
        if(pools.length == 0) {
            //Parseo normal del workflow
            this.parseWorkflow(this.parsedXML);
        } else {
            //Fuerzo a parsear al workflow principal				
            this.parseWorkflowProEvents(this.parsedXML);				
            this.parseWorkflowProForms(this.parsedXML);
        }
        if(this.parsedXML){
            if(this.workflowProcessName) {
                facilis.parsers.ParseInUtils.setSubNodeValue(this.parsedXML.firstElementChild, "name",this.workflowProcessName);
            }
            if (this.processAction) {
                facilis.parsers.ParseInUtils.setSubNodeValue(this.parsedXML.firstElementChild, "protype",this.processAction);
            }
        }
    }

    element.removeWFNodes=function(node) {
        var toRemove = new Array();
        var toReturn = new Array();
        var removable = { };
        removable["ApiaProEvents"] = true;
        removable["Object"] = true;
        var i = 0;
        for (i = 0; i < node.children.length; i++ ) {
            if (removable[node.children[i].localName]) {
                toRemove.push(node.children[i]);
            }
        }
        i = 0;
        for (i = 0; i < toRemove.length; i++ ) {
            toReturn.push(toRemove[i].cloneNode(true));
            toRemove[i].parentNode.removeChild(toRemove[i]);
        }
        return toReturn;
    }

    element.parseWorkflow=function(pool) {
        var workflows = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "WorkflowProcesses");
        var workflow;
        //var activitySets = .ownerDocument.createElement("activitySets");

        for (var i = 0; i < workflows.children.length; i++) {
            //var id = workflows.children[i].getAttribute("ProId");

            var id = workflows.children[i].getAttribute("Id");
            if (id == pool.getAttribute("process")) {
                workflow = workflows.children[i];
                break;
            }/* else {
                //Recabar informacion de Activities y Transitions de este workflowprocess
            }*/
        }
            
        if (workflow) {
            var p = new facilis.parsers.input.WorkflowProcess();
            p.setParsedNode(pool);
            p.parse(workflow);
            this.parseSubElements(workflow, pool);

            
        }


    }

    element.parseWorkflowProForms=function(pool) {
        //trace("parseWorkflowProForms: " + pool);
        

        var workflows = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "WorkflowProcesses");

        var apiaProForms = null;

        for (var i = 0; i < workflows.children.length && apiaProForms == null; i++) {
            //var wf = workflows.children[i];
            var p = new facilis.parsers.input.WorkflowProcess();
            p.setParsedNode(pool);
            p.toParseNode = workflows.children[i];
            //trace("pool seteado");
            p.getDocumentation();

            //trace("documentacion parseada");
            
        }

    }

    element.parseWorkflowProEvents=function(pool) {
        var workflows = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "WorkflowProcesses");
        var workflow;
        //var activitySets = .ownerDocument.createElement("activitySets");			
        var apiaProEvents = null;
        for (var i = 0; i < workflows.children.length && apiaProEvents == null; i++) {
            var wf = workflows.children[i];
            for (var j = 0; j < wf.children.length && apiaProEvents == null; j++) {
                //trace("wf.children[j].localName: " + wf.children[j].localName);
                if(wf.children[j].localName == "ApiaProEvents") {
                    apiaProEvents = wf.children[j];
                }
            }
        }
        if (apiaProEvents) {
            //trace("Voy a invocar a workflow.parseEvents con pool: " + pool);
            var p = new WorkflowProcess();
            p.setParsedNode(pool);
            p.parseLaneEvents(apiaProEvents);
            //parseSubElements(workflow, pool);
        }
    }

    element.parseSubElements=function(xml, node) {
        if(xml && node){
            var subElements = facilis.parsers.ParseInUtils.getSubNode(node, "subElements");
            var activitySets = node.ownerDocument.createElement("activitySets");
            if(!subElements){
                subElements = node.ownerDocument.createElement("subElements");
                node.appendChild(subElements);
            }
            var i = 0;
            for (i = 0; i < xml.children.length; i++ ) {
                if (xml.children[i].localName=="Activities") {
                    this.parseActivities(subElements, xml.children[i]);
                }
                if (xml.children[i].localName=="Transitions") {
                    this.parseTransitions(subElements, xml.children[i]);
                }
                if (xml.children[i].localName == "ActivitySets") {
                    this.parseActivitySets(activitySets, xml.children[i]);
                }
				if (xml.children[i].localName=="DataInputOutputs") {
					this.parseDataInputOutputs(xml.children[i], this.artifacts);
				}
				if (xml.children[i].localName=="DataStoreReferences") {
					this.parseDataStoreReferences(xml.children[i], this.artifacts);
				}

            }
            i = 0;
            for (i = activitySets.children.length-1; i >= 0; i-- ) {
                var id = activitySets.children[i].getAttribute("id");
                for (var u = 0; u < subElements.children.length; u++ ) {
                    if (subElements.children[u].getAttribute("id") == id) {
                        if (activitySets.children[i]) {
                            subElements.children[u].appendChild(activitySets.children[i]);
                            break;
                        }
                    }
                }
            }
        }
    }

    element.parseActivities=function(pool, activities) {
        for (var i = 0; i < activities.children.length;i++ ) {
            if (activities.children[i]) {
                var type = this.getElementType(activities.children[i]);
                var p = this.getElementParser(type);
                p.setParsedNode(facilis.ElementAttributeController.getInstance().getElementAttributes(type));
                var activityXML = p.parse(activities.children[i]);
                pool.appendChild(activityXML);
            }
        }
    }

    element.parseTransitions=function(pool,transitions) {
        for (var i = 0; i < transitions.children.length;i++ ) {
            if (transitions.children[i]) {
                var type = this.getElementType(transitions.children[i]);
                var p = this.getElementParser(type);
                p.setParsedNode(facilis.ElementAttributeController.getInstance().getElementAttributes(type));
                var activityXML = p.parse(transitions.children[i]);
                pool.appendChild(activityXML);
            }
        }
    }

    element.parseActivitySets=function(pool,activitySets){
        for (var i = 0; i < activitySets.children.length;i++ ) {
            if (activitySets.children[i]) {
                var activitySet = pool.ownerDocument.createElement("subElements");
                activitySet.setAttribute("id", activitySets.children[i].getAttribute("Id"));
                pool.appendChild(activitySet);
                this.parseActivitySet(activitySet,activitySets.children[i]);
            }
        }
    }

    element.parseActivitySet=function(pool,activitySet) {
        /*for (var i = 0; i < activitySet.children.length;i++ ) {
            if (activitySet.children[i]) {
                if (activitySet.children[i].nodeName == "Activities") {
                    parseActivities(pool, activitySet.children[i]);
                }
                if (activitySet.children[i].nodeName=="Transitions") {
                    parseTransitions(pool, activitySet.children[i]);
                }
            }
        }*/
        this.parseSubElements(activitySet,pool);
    }
	
	element.parseDataStores=function(datas, datas_array) {

		for (var i = 0; i < datas.children.length; i++ ) {
			var datas_XML = datas.children[i];
			if (datas_XML) {
				var type = this.getElementType(datas_XML);
				var p = this.getElementParser(type);
				p.setParsedNode(facilis.ElementAttributeController.getInstance().getElementAttributes(type));
				var datastoreXML = p.parse(datas_XML);
				datas_array.push(datastoreXML);
			}
		}
	}

    element.parseArtifacts=function(artifacts) {
        var arts = new Array();
        for (var i = 0; i < artifacts.children.length;i++ ) {
            if (artifacts.children[i]) {
                var type = this.getElementType(artifacts.children[i]);
                var p = this.getElementParser(type);
                p.setParsedNode(facilis.ElementAttributeController.getInstance().getElementAttributes(type));
                var artifactXML = p.parse(artifacts.children[i]);
                arts.push(artifactXML);
            }
        }
        return arts;
    }

	element.parseDataInputOutputs=function(datainout, arts) {
		for (var i = 0; i < datainout.children.length;i++ ) {
			if (datainout.children[i]) {
				var type = this.getElementType(datainout.children[i]);
				var p = this.getElementParser(type);
				p.setParsedNode(facilis.ElementAttributeController.getInstance().getElementAttributes(type));
				var artifactXML = p.parse(datainout.children[i]);
				arts.push(artifactXML);
			}
		}
	}

	/**
	 * TODO: Donde van los datastores en el xml de memoria???? son hijos de artifacts?
	 * @param	datastore
	 * @param	dstores
	 */
	element.parseDataStoreReferences=function(datastore, dstores) {
		//var arts = new Array();
		for (var i = 0; i < datastore.children.length;i++ ) {
			if (datastore.children[i]) {
				var type = this.getElementType(datastore.children[i]);
				var p = this.getElementParser(type);
				p.setParsedNode(facilis.ElementAttributeController.getInstance().getElementAttributes(type));
				var datastoreXML = p.parse(datastore.children[i]);

				var datastoreref = datastore.children[i].getAttribute("DataStoreRef");
				var state = datastore.children[i].getAttribute("State");

				var j 
				for (j = 0; j < datastoreXML.children[0].children.length; j++ ) {
					if (datastoreXML.children[0].children[j].getAttribute("name") == "state") {
						datastoreXML.children[0].children[j].setAttribute("value", state);
						break;
					}
				}

				for (j = 0; j < this.datastores.length; j++ ) {
					if (this.datastores[j].getAttribute("id") == "datastoreref") {
						var attributes = this.datastores[j].children[0].children;
						for (var k = 0; k < attributes.length; k++ ) {
							if (attributes[k].getAttribute("name") == "documentation" || attributes[k].getAttribute("name") == "name" || attributes[k].getAttribute("name") == "capacity" || attributes[k].getAttribute("name") == "isUnlimited" ) {
								//Ponerle el valor y copiar los hijos del atributo
								for (var l = 0; l < datastoreXML.children[0].children.length; l++) {
									if (datastoreXML.children[0].children[l].getAttribute("name") == attributes[k].getAttribute("name")) {
										datastoreXML.children[0].children[l].getAttribute("value", attributes[k].getAttribute("value"));
										for (var m = 0; m < attributes[k].children.length; m++ ) {
											datastoreXML.children[0].children[l].appendChild(attributes[k].children[m].cloneNode(true));
										}
										break;
									}
								}
							}
						}
						break;
					}
				}

				dstores.push(datastoreXML);
			}
		}
		//return arts;
	}
	
    element.parseAssociations=function(associations) {
        var ass = new Array();
        var type = "association";
        for (var i = 0; i < associations.children.length;i++ ) {
            if (associations.children[i]) {
                var p = this.getElementParser(type);
                p.setParsedNode(facilis.ElementAttributeController.getInstance().getElementAttributes(type));
                var associationXML = p.parse(associations.children[i]);
                ass.push(associationXML);
            }
        }
        return ass;
    }

    element.parseMessageFlows=function(mFlows) {
        var flows = new Array();
        var type = "mflow";
        for (var i = 0; i < mFlows.children.length;i++ ) {
            if (mFlows.children[i]) {
                var p = this.getElementParser(type);
                p.setParsedNode(facilis.ElementAttributeController.getInstance().getElementAttributes(type));
                var flowXML = p.parse(mFlows.children[i]);
                flows.push(flowXML);
            }
        }
        return flows;
    }

    element.getElementParser=function(type) {
        var className = "";
        var outPackage= "facilis.parsers.input."
        switch (type){
            case "task":
            className = "Task";
            break;
            case "csubflow":
            className = "Subflow";
            break;
            case "esubflow":
            className = "Subflow";
            break;
            case "startevent":
            className = "Event";
            break;
            case "middleevent":
            className = "Event";
            break;
            case "endevent":
            className = "Event";
            break;
            case "gateway":
            className = "Gateway";
            break;
            case "pool":
            className = "Pool";
            break;
            case "group":
            className = "Artifact";
            break;
            case "swimlane":
            className = "Lane";
            break;
            case "textannotation":
            className = "Artifact";
            break;
            case "dataobject":
			case "datainput":
			case "dataoutput":
            className = "Artifact";
            break;
			case "datastore":
			className = "Artifact";
			break;
            case "back":
            className = "Back";
            break;
            case "association":
            className = "Association";
            break;
            case "mflow":
            className = "Transition";
            break;
            case "sflow":
            className = "Transition";
            break;
            case "activityset":
            className = "ActivitySet";
            break;
        }

        //return (LibraryManager.getInstance().getInstancedObject(outPackage+className) );
        return eval("new "+outPackage+className+"()")
    }

    element.getElementType=function(node) {
        if (facilis.parsers.ParseInUtils.getSubNode(node,"Task")) {
            return "task";
        }else if (facilis.parsers.ParseInUtils.getSubNode(node, "BPMNEvent") || facilis.parsers.ParseInUtils.getSubNode(node, "Event")) {
            var event=(facilis.parsers.ParseInUtils.getSubNode(node, "BPMNEvent"))?(facilis.parsers.ParseInUtils.getSubNode(node, "BPMNEvent")):(facilis.parsers.ParseInUtils.getSubNode(node, "Event"))
            var type = event.firstElementChild.localName;
            return ((type == "StartEvent")?"startevent": (type == "IntermediateEvent")? "middleevent" : "endevent"  );
        }else if (facilis.parsers.ParseInUtils.getSubNode(node,"Route") || facilis.parsers.ParseInUtils.getSubNode(node,"Gateway")) {
            return "gateway";
        }else if (facilis.parsers.ParseInUtils.getSubNode(node, "BlockActivity") || facilis.parsers.ParseInUtils.getSubNode(node, "SubFlow")) {
            var NodeGraphicsInfo = facilis.parsers.ParseInUtils.getSubNode(node, "NodeGraphicsInfo");
            if (NodeGraphicsInfo.getAttribute("Expanded") == "true") {
                return "esubflow";
            }else{
                return "csubflow";
            }
        }else if ( node.localName=="Transition") {
            return "sflow";
		} else if ( node.localName == "DataInput") {
			return "datainput"
		} else if ( node.localName == "DataOutput") {
			return "dataoutput"
		//} else if ( node.localName == "DataInput" || node.localName == "DataOutput") {
		//	return "dataobject"
		} else if ( node.localName == "DataStore") {				
			return "datastore";
		} else if ( node.localName == "DataStoreReferences" || node.localName == "DataStoreReference" || node.localName == "DataStores" || node.localName == "DataStore") {
			return "datastore";
		}else if (node.getAttribute("ArtifactType")) {
            var artifactType=node.getAttribute("ArtifactType");
			
			if (artifactType == "DataObject")
				return "dataobject";
			else if (artifactType == "Group")
				return "group";
			else
				return "textannotation";
            //return (artifactType == "DataObject")?"dataobject":((artifactType == "Group")?"group":"textannotation");
        }else if (facilis.parsers.ParseInUtils.getSubNode(node,"Implementation"))  {
            facilis.parsers.ParseInUtils.getSubNode(node, "Implementation").firstElementChild.localName == "No";
            return "task";
        }else if ( node.localName=="Lane") {
            return "swimlane";
        }
    }


    ParserIn.addParticipant=function(id,name) {
        for (var i = 0; i < ParserIn.performers.length; i++ ) {
            if (ParserIn.performers[i].id == id) {
                return;
            }
        }
        if (name == null || name == "") {
            name = id;
            //id = null;
        }
        ParserIn.performers.push( { id:id, name:name } );
    }

    ParserIn.getParticipantByName=function(name) {
        for (var i = 0; i < ParserIn.performers.length; i++ ) {
            if (ParserIn.performers[i].name==name) {
                return ParserIn.performers[i];
            }
        }
        return null;
    }

    ParserIn.getParticipantById=function(id) {
        for (var i = 0; i < ParserIn.performers.length; i++ ) {
            if (ParserIn.performers[i].id==id) {
                return ParserIn.performers[i];
            }
        }
        return null;
    }

    ParserIn.getParticipantByIdOrName=function(id) {
        for (var i = 0; i < ParserIn.performers.length; i++ ) {
            if (ParserIn.performers[i].id==id) {
                return ParserIn.performers[i];
            }
            if (ParserIn.performers[i].name==id) {
                return ParserIn.performers[i];
            }
        }
        return null;
    }
    


    facilis.parsers.ParserIn = facilis.promote(ParserIn, "Object");
    
    
    facilis.parsers.ParseInUtils={};
    
    facilis.parsers.ParseInUtils.getParsedNode=function(xmlStr) {
        
        //var xmlString = (new XMLSerializer()).serializeToString(xmlStr);
         var doc=   ( new window.DOMParser() ).parseFromString(xmlStr, "text/xml");
        return doc.firstElementChild;
    }

    facilis.parsers.ParseInUtils.getSubNodeValue=function(n,name) {
        var node = getSubNode(n, name);
        if (node && node.setAttribute("value", "" && node.getAttribute("value")) != undefined && node.getAttribute("value") != "undefined") {
            return node.getAttribute("value");
        }
        return null;
    }

    facilis.parsers.ParseInUtils.setSubNodeValue=function(n, name, value) {
        if(value){
            var node = facilis.parsers.ParseInUtils.getSubNode(n, name);
            if (node) {
                node.setAttribute("value",value);
            }
        }
    }

    facilis.parsers.ParseInUtils.getSubNode=function(n, name) {
        name=(name||"");
        if(n && n.children){
            for (var i = 0; i < n.children.length; i++ ) {
                if (((n.children[i]).getAttribute("name")||"").toLowerCase()==name.toLowerCase() ||
                    ((n.children[i]).nodeName||"").toLowerCase()==name.toLowerCase() ||
                    ((n.children[i]).localName||"").toLowerCase()==name.toLowerCase()) {
                    return (n.children[i]);
                }
            }
            i = 0;
            for (i = 0; i < n.children.length; i++ ) {
                var subNode = facilis.parsers.ParseInUtils.getSubNode((n.children[i]), name);
                if (subNode) {
                    return subNode;
                }
            }
        }
        return null;
    }
    
    
}());

(function() {

    function ElementParser() {
        this.parsedNode=null;
		this.toParseNode=null;
        
        this.parseFunctions = [];
        this.parseFunctions.push(this.getId);
        this.parseFunctions.push(this.getName);
        this.parseFunctions.push(this.getDocumentation);
        this.parseFunctions.push(this.parseCategories);
        this.parseFunctions.push(this.parseDataFields);
        //this.parseFunctions.push(this.parseProperties);
        this.parseFunctions.push(this.parseUserAttributes);
        this.parseFunctions.push(this.getNodeGraphicsInfo);
    }
    
    //static public//
    
    
    var element = facilis.extend(ElementParser, {});

    element.getNodeGraphicsInfo=function() {
        var NodeGraphicsInfos = this.getToParseSubNode("NodeGraphicsInfos");
        var NodeGraphicsInfo;
        if (NodeGraphicsInfos && NodeGraphicsInfos.firstElementChild) {
            NodeGraphicsInfo = NodeGraphicsInfos.firstElementChild;
            this.parseNodeGraphicsInfo(NodeGraphicsInfo);
        }else {
            NodeGraphicsInfo = this.getToParseSubNode("NodeGraphicsInfo");
            if(NodeGraphicsInfo){
                this.parseNodeGraphicsInfo(NodeGraphicsInfo);
            }
        }
    }

    element.parseNodeGraphicsInfo=function(NodeGraphicsInfo) {
        var width = NodeGraphicsInfo.getAttribute("Width");
        var height = NodeGraphicsInfo.getAttribute("Height");
        var x = 0;
        var y = 0;
        if (NodeGraphicsInfo.firstElementChild) {
            x = NodeGraphicsInfo.firstElementChild.getAttribute("XCoordinate");
            y = NodeGraphicsInfo.firstElementChild.getAttribute("YCoordinate");
        }
        this.parsedNode.setAttribute("x", (x?x:"0"));
        this.parsedNode.setAttribute("y", (y?y:"0"));
        this.parsedNode.setAttribute("width", (width?width:"0"));
        this.parsedNode.setAttribute("height", (height?height:"0"));
        var shape = NodeGraphicsInfo.getAttribute("Shape");
        if (shape) {
            this.parsedNode.setAttribute("shape", shape);
        }
        this.getColor(NodeGraphicsInfo);
    }

    element.getColor=function(NodeGraphicsInfo) {
        var fillColor = NodeGraphicsInfo.getAttribute("FillColor");
        if(fillColor){
            var bpmnNode = this.parsedNode.firstElementChild;
            var colorFill = facilis.parsers.ParseInUtils.getSubNode(bpmnNode, "colorFill");
            if (colorFill) {
                colorFill.setAttribute("value", fillColor);
            }
        }
    }

    element.getName=function() {
        var name = this.toParseNode.getAttribute("Name");
        if(this.parsedNode && name){
            var grp=this.parsedNode.children[0];
            for (var i = 0; i < grp.children.length; i++ ) {
                if (grp.children[i].getAttribute("name")=="name" || grp.children[i].getAttribute("name")=="nameChooser") {
                    grp.children[i].setAttribute("value", name);
                }
            }
        }
    }

    element.getId=function() {
        var id = this.toParseNode.getAttribute("Id");
        if (id != null) {
            this.parsedNode.setAttribute("id", id);
        }
    }

    element.parse=function(node) {
        this.toParseNode = node;
        return this.startParse();
    }

    element.setParsedNode=function(node) {
        this.parsedNode = node;
    }

    element.getToParseSubNode=function(name,fromNode){
        return facilis.parsers.ParseInUtils.getSubNode((fromNode||this.toParseNode), name);
    }

    element.getParsedSubNode=function(name){
        return facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, name);
    }

    element.getToParseSubNodeValue=function(name){
        return facilis.parsers.ParseInUtils.getSubNodeValue(this.toParseNode, name);
    }

    element.getParsedSubNodeValue=function(name){
        return facilis.parsers.ParseInUtils.getSubNodeValue(parsedNode, name);
    }

    element.callParseFunctions=function() {
        for (var i = 0; i < this.parseFunctions.length;i++ ) {
            this.parseFunctions[i].apply(this);
            //(this.parseFunctions[i])();
        }
    }

    element.startParse=function() { 
        this.callParseFunctions();
        return this.parsedNode;
    }

    element.getParsedNode=function(xmlStr) {
        return facilis.parsers.ParseInUtils.getParsedNode(xmlStr);
    }

    element.setParsedSubNodeValue=function(name, value) {
        var node= this.getParsedSubNode(name);
        if (node) {
            node.setAttribute("value", value);
        }
    }

    element.getData=function(node){
        return facilis.parsers.ParseInUtils.getSubNode(node, "data");
    }

    element.getDocumentation=function() {
        var ObjectTag;
        for (var i = 0; i < this.toParseNode.children.length; i++ ) {				
            if (this.toParseNode.children[i].localName == "Object") {
                ObjectTag = this.toParseNode.children[i];
            }
        }
        var Documentation;
        if(ObjectTag){
            Documentation = facilis.parsers.ParseInUtils.getSubNode(ObjectTag, "Documentation");
        }
        if (!Documentation) {
            i = 0;
            for (i = 0; i < this.toParseNode.children.length; i++ ) {
                if (this.toParseNode.children[i].localName=="Documentation") {
                    Documentation = this.toParseNode.children[i];
                    break;
                }
            }
        }
        var documentation = null;
        var forms = null;
        var events = null;
        var title = null;
        if (this.parsedNode.firstElementChild) {
            i = 0;
            for (i = 0; i < this.parsedNode.firstElementChild.children.length; i++ ) {
                if (this.parsedNode.firstElementChild.children[i].getAttribute("name") == "documentation") {
                    documentation = this.parsedNode.firstElementChild.children[i];
                }
                if (this.parsedNode.firstElementChild.children[i].getAttribute("name") == "forms") {
                    forms = this.parsedNode.firstElementChild.children[i];
                }
                if (this.parsedNode.firstElementChild.children[i].getAttribute("name") == "events") {
                    events = this.parsedNode.firstElementChild.children[i];
                }
                if (this.parsedNode.firstElementChild.children[i].getAttribute("name") == "title") {
                    title = this.parsedNode.firstElementChild.children[i];
                }
            }
        }
        if (Documentation) {
            if (forms || events || title) {
                this.parseAdvancedDocumentation(Documentation,documentation,forms,events,title);
            }else {
                this.parseDocumentationNode(Documentation, documentation);
            }
        }
    }

    element.parseDocumentationNode=function(Documentation, documentation) {
        if (documentation && Documentation && Documentation.firstElementChild) {
            var first = Documentation.firstElementChild.textContent;
            if ( (first.indexOf("&lt;forms") >= 0 || first.indexOf("&lt;events") >= 0 || first.indexOf("&lt;documentation") >= 0 || first.indexOf("&lt;title") >= 0) ||
                (first.indexOf("<forms") >= 0 || first.indexOf("<events") >= 0 || first.indexOf("<documentation") >= 0 || first.indexOf("<title") >= 0)
               ) {
                var parsedXML = "<aux>" + first + "</aux>";
                var auxNode = facilis.parsers.ParseInUtils.getParsedNode(parsedXML);
                Documentation = this.parsedNode.ownerDocument.createElement("Documentation");
                for (var x = 0; x < auxNode.children.length; x++ ) {
                    var cloned = auxNode.children[x].cloneNode(true);
                    if (cloned.nodeName == "documentation") {
                        Documentation.appendChild(this.parsedNode.ownerDocument.createTextNode(cloned.textContent));
                        break;
                    }
                }
            }else if(Documentation.firstElementChild && Documentation.textContent){
                var description= Documentation.firstElementChild.textContent;
                //description = description.split("\n").join("");
                if (description && documentation) {
                    if (documentation.firstElementChild && documentation.firstElementChild.nodeName=="values") {
                        documentation.removeChild(documentation.firstElementChild);
                    }
                    var values = documentation.ownerDocument.createElement("values");
                    var value = documentation.ownerDocument.createElement("value");
                    var val = documentation.ownerDocument.createTextNode(description);
                    value.appendChild(val);
                    value.setAttribute("value", description);
                    values.appendChild(value);
                    documentation.appendChild(values);
                    //documentation.appendChild(facilis.parsers.ParseInUtils.getParsedNode("<values><value value = \"" + description + "\" >" + description + "</value></values>"));
                    documentation.setAttribute("value", description);
                }
            }
        }
    }

    element.parseAdvancedDocumentation=function(Documentation, documentation, formsNode, eventsNode, titleNode) {
        if (!Documentation.firstChild) {
            return;
        }

        var first = (Documentation.firstChild.wholeText ||  Documentation.firstChild.textContent);
        var doc;
        var forms;
        var events;
        var title; 
		var quote_unescaped = false;
        if (first.indexOf("&amp;lt;")>=0) {
            first = first.split("&amp;lt;").join("&lt;");
            first = first.split("&amp;gt;").join("&gt;");
            first = first.split("&amp;quot;").join("&quot;");
			first = first.split("&amp;amp;").join("&amp;");
            first = first.split(" = ").join("=");
            //Documentation.firstChild.removeNode();
            Documentation.firstChild.nodeValue = first;
			quote_unescaped = true;
        }

        if (first.indexOf("&lt;forms")>=0 || first.indexOf("&lt;events")>=0 || first.indexOf("&lt;documentation")>=0 || first.indexOf("&lt;title")>=0) {
            //var parsedXML = "<aux>" + Documentation.firstChild.outerHTML + "</aux>";

            /*first = first.split("&lt;").join("<");
            first = first.split("&gt;").join(">");
            first = first.split("&quot;").join("\"");*/

            first = first.split("&lt;events&gt;").join("<events>");
            first = first.split("&lt;forms&gt;").join("<forms>");
            first = first.split("&lt;documentation&gt;").join("<documentation>");
            first = first.split("&lt;title&gt;").join("<title>");

            //Elementos de forms y events
            first = first.split("&lt;event").join("<event");
            first = first.split("&lt;form").join("<form");

            //Atributos de forms
            first = first.split("&lt;attribute").join("<attribute");
			
			if (first.indexOf("<documentation>") >= 0) {
					
				var documentation_split = first.split("<documentation>");
				var documentation_split2;

				var first_aux;
				if (documentation_split.length > 1) {
					//habia algo adelante, lo escapeo
					documentation_split[0] = documentation_split[0].split("&quot;").join("\"");
					documentation_split[0] = documentation_split[0].split("&amp;").join("&");

					documentation_split2 = documentation_split[1].split("</documentation>");
					first_aux = documentation_split[0];
				} else {
					documentation_split2 = documentation_split[0].split("</documentation>");
				}

				if (!quote_unescaped)
					first_aux += "<documentation>" + documentation_split2[0].split("&amp;quot;").join("&quot;").split("&amp;gt;").join("&gt;");
				else 
					first_aux += "<documentation>" + documentation_split2[0];

				first_aux += "</documentation>";

				if (documentation_split2.length > 1) {
					//habia algo despues, lo escapeo
					documentation_split2[1] = documentation_split2[1].split("&quot;").join("\"");
					documentation_split2[1] = documentation_split2[1].split("&amp;").join("&");

					first_aux += documentation_split2[1];
				}

				first = first_aux;

			} else {
				first = first.split("&quot;").join("\"");
				first = first.split("&amp;").join("&");
			}
			

            first = first.split("&lt;/events&gt;").join("</events>");
            first = first.split("&lt;/forms&gt;").join("</forms>");
            first = first.split("&lt;/documentation&gt;").join("</documentation>");
            first = first.split("&lt;/title&gt;").join("</title>");

            //Elements de forms y events
            first = first.split("&lt;/event").join("</event");
            first = first.split("&lt;/form").join("</form");

            //Atributos de forms
            first = first.split("&lt;/attribute").join("</attribute");

            first = first.split("&gt;").join(">");

            first = first.split("&quot;").join("\"");

        }
        
        var parsedXMLStr = "<aux>" + first + "</aux>";

        var auxNode = facilis.parsers.ParseInUtils.getParsedNode(parsedXMLStr);
        Documentation = this.parsedNode.ownerDocument.createElement("Documentation");
        for (var x = 0; x < auxNode.children.length; x++ ) {
            var cloned = auxNode.children[x].cloneNode(true);
            Documentation.appendChild(cloned);
            if (cloned.nodeName == "documentation") {
                doc = cloned;
            }
            if (cloned.nodeName == "forms") {
                forms = cloned;
            }
            if (cloned.nodeName == "events") {
                events = cloned;
            }
            if (cloned.nodeName == "title") {
                title = cloned;
            }
        }

        /*var this.parsedNode= facilis.parsers.ParseInUtils.getSubNode(documentation, "documentation");
        var parsedForms= facilis.parsers.ParseInUtils.getSubNode(documentation, "forms");
        var parsedEvents= facilis.parsers.ParseInUtils.getSubNode(documentation, "events");*/
        var parsedForms = formsNode;
        var parsedEvents = eventsNode;
        var parsedDoc = documentation;
        var values;
        var value;
        var i = 0;
        var docStr;

        if (doc && doc.firstChild) {
            docStr = doc.firstChild.textContent;
            //docStr = docStr.split("\n").join("");
        }else if (!doc) {
            if(Documentation.firstChild && Documentation.firstChild.nodeName!="forms" && Documentation.firstChild.nodeName!="events" && Documentation.firstChild.nodeName!="title"){
                var description= Documentation.firstChild.outerHTML;
                //docStr = description.split("\n").join("");
            }
        }

        if (docStr && parsedDoc) {
            values = parsedDoc.ownerDocument.createElement("values");
            value = parsedDoc.ownerDocument.createElement("value");
            documentation.setAttribute("value", docStr);
            value.setAttribute("value", docStr);
            value.appendChild(parsedDoc.ownerDocument.createTextNode(docStr));
            values.appendChild(value);
            parsedDoc.appendChild(values);
        }

        if (forms && parsedForms) {

            var formsData = facilis.parsers.ParseInUtils.getSubNode(parsedForms, "data");
            values = this.getFormValues(forms, formsData);
            if (this.parsedNode.getAttribute("name") == "back") {
                for (var f = 0; f < values.children.length; f++ ) {
                    var id = parseInt(values.children[f].firstElementChild.getAttribute("value"));
                    facilis.controller.FormResources.getInstance().addResource(values.children[f], id);
                }
            }else{
                parsedForms.appendChild(values);
            }
        }

        if (events && parsedEvents) {
            this.parseEventElements(parsedEvents, events);
        }
        if (title && titleNode) {
            titleNode.setAttribute("value", title.getAttribute("value"));
        }
    }

    element.getFormValues=function(forms,formsData) {
        //var fDoc= facilis.parsers.ParseInUtils.getSubNode(formsData, "doc");
        //var stepData= facilis.parsers.ParseInUtils.getSubNode(fDoc, "data");

        if (formsData.firstElementChild.getAttribute("name") != "step") {
            return this.getProcessForms(forms, formsData);
        }

        var stepData = formsData;
        var stepValues = this.parsedNode.ownerDocument.createElement("values");

        var stepFormsData = stepData.children[1].firstElementChild;

        var stepsObj = new Object();
        var step = {order:0,pforms:new Array(),eforms:new Array()};
        stepsObj["1"] = step;
        var i;

        if (forms.firstElementChild && !forms.firstElementChild.nodeName) {
            forms = facilis.parsers.ParseInUtils.getParsedNode("<forms>"+forms.firstElementChild.outerHTML+"</forms>");
        }

        for (i = 0; i < forms.children.length; i++ ) {
            var form = forms.children[i];
            if (!form.nodeName) {
                form=facilis.parsers.ParseInUtils.getParsedNode(form);
            }
            if (form.getAttribute("frmStepId")) {
                if (stepsObj[form.getAttribute("frmStepId")]) {
                    step = stepsObj[form.getAttribute("frmStepId")];
                }else {
                    step = { order:parseInt(form.getAttribute("frmStepId")),pforms:new Array(),eforms:new Array() };
                    stepsObj[form.getAttribute("frmStepId")]=step;
                }
            }
            var frmOrder = i;
            if (form.getAttribute("frmOrder")) {
                frmOrder = parseInt(form.getAttribute("frmOrder"));
            }
            var frmType = form.getAttribute("frmType");
            if(frmType=="P"){
                step.pforms.push( { order:frmOrder, form:form } );
            }else {
                step.eforms.push( { order:frmOrder, form:form } );
            }
        }

        var stepArray = new Array();
        for (var stepNum in stepsObj) {
            stepArray.push(stepsObj[stepNum]);
        }

        stepArray.sort(function(a, b) {
                    if (parseInt(a.order) == parseInt(b.order)) {
                        return parseInt(a.frmOrder)-parseInt(b.frmOrder);
                    }
                    return (parseInt(a.order) - parseInt(b.order));
                } );
        
        i = 0;

        for (i = 0; i < stepArray.length; i++ ) {
            var stepValue = stepData.cloneNode(true);
            stepValue.nodeName = "value";
            stepValues.appendChild(stepValue);
            var stepEFormsValues = this.parsedNode.ownerDocument.createElement("values");
            var stepPFormsValues = this.parsedNode.ownerDocument.createElement("values");
            //stepValue.children[1].appendChild(stepPFormsValues);
            //stepValue.children[2].appendChild(stepEFormsValues);
			for (var j = 0; j < stepValue.children.length; j++) {
				if (stepValue.children[j].getAttribute("name") == "stepformse" || stepValue.children[j].getAttribute("name") == "entityforms") {
					stepValue.children[j].appendChild(stepEFormsValues);
					console.log("stepformse en ElementParser.as");
				} else if (stepValue.children[j].getAttribute("name") == "stepformsp" || stepValue.children[j].getAttribute("name") == "processforms") {
					stepValue.children[j].appendChild(stepPFormsValues);
					console.log("stepformsp en ElementParser.as");
				}
			}
			
			var formsArr = stepArray[i].eforms;
            formsArr.sort(function(a, b) {
                    if (parseInt(a.order) == parseInt(b.order)) {
                        return parseInt(a.frmOrder)-parseInt(b.frmOrder);
                    }
                    return (parseInt(a.order) - parseInt(b.order));
                } );
            var f = 0;
            var frmValue;
            for (f = 0; f < formsArr.length; f++ ) {
                frmValue = this.getFormValue(formsArr[f].form, stepFormsData);
                if (frmValue) {
                    stepEFormsValues.appendChild(frmValue);
                }
            }
            formsArr = stepArray[i].pforms;
            formsArr.sort(function(a, b) {
                    if (parseInt(a.order) == parseInt(b.order)) {
                        return parseInt(a.frmOrder)-parseInt(b.frmOrder);
                    }
                    return (parseInt(a.order) - parseInt(b.order));
                } );
            f = 0;
            for (f = 0; f < formsArr.length; f++ ) {
                frmValue = this.getFormValue(formsArr[f].form, stepFormsData);
                if (frmValue) {
                    stepPFormsValues.appendChild(frmValue);
                }
            }
        }
        return stepValues;
    }

    element.getProcessForms=function(forms, formsData) {

        var values = this.parsedNode.ownerDocument.createElement("values");
        /*
        if (forms.firstElementChild && !forms.firstElementChild.nodeName) {				
            //trace("get parsed node: " + "<forms>"+forms.toString()+"</forms>");
            forms = facilis.parsers.ParseInUtils.getParsedNode("<forms>"+forms.firstElementChild.outerHTML+"</forms>");

        }
        */
        for (var i = 0; i < forms.children.length; i++ ) {
            values.appendChild(this.getFormValue(forms.children[i], formsData));
        }
        return values;
    }

    element.getFormValue=function(form, formsData,addNoExist) {
        if(!(form.getAttribute("name")=="undefined" && form.getAttribute("description")=="undefined") /*|| forms.children.length!=3*/){
            var value = formsData.cloneNode(true);
            var formId = (((form.getAttribute("frmId") + "") != "undefined")?form.getAttribute("frmId"):"");
            var formName = (((form.getAttribute("frmName") + "") != "undefined")?form.getAttribute("frmName"):"");
            var formDesc = (((form.getAttribute("frmTitle") + "") != "undefined")?form.getAttribute("frmTitle"):"");
            if (formName=="" && form.getAttribute("name")) {
                formName = (((form.getAttribute("name") + "") != "undefined")?form.getAttribute("name"):"");
            }
            if (formDesc=="" && form.attributes.description) {
                formDesc = (((form.attributes.description + "") != "undefined")?form.attributes.description:"");
            }
            facilis.parsers.ParseInUtils.setSubNodeValue(value, "formId", formId);
            facilis.parsers.ParseInUtils.setSubNodeValue(value, "formName", formName);
            facilis.parsers.ParseInUtils.setSubNodeValue(value, "formDesc", formDesc);
            var evts=facilis.parsers.ParseInUtils.getSubNode(form, "events");
            if (evts) {
                var frmEvents = facilis.parsers.ParseInUtils.getSubNode(value, "frmEvents");
                if (frmEvents) {
                    parseEventElements(frmEvents, evts);
                }
            }
            value.nodeName = "value";
            var fDoc = facilis.parsers.ParseInUtils.getSubNode(value, "doc");
            if(fDoc){
                var docData = fDoc.firstElementChild;
                var fDocValues = this.parsedNode.ownerDocument.createElement("values");
                fDoc.appendChild(fDocValues);
                for (var d = 0; d < form.children.length; d++ ) {
                    if(form.children[d].nodeName=="attribute" || form.children[d].nodeName=="documentation"){
                    var dValue = docData.cloneNode(true);
                    dValue.nodeName = "value";
                    //if (form.children[d].getAttribute("name") != "" || form.children[d].getAttribute("description") != "" || form.children[d].getAttribute("rules") != "") {
                        if (!form.children[d].getAttribute("attName") && form.children[d].getAttribute("name")) {
                            form.children[d].setAttribute("attName", form.children[d].getAttribute("name"));
                        }
                        if (!form.children[d].getAttribute("attLabel") && form.children[d].getAttribute("description")) {
                            form.children[d].setAttribute("attLabel", form.children[d].getAttribute("description"));
                        }
                        if (!form.children[d].getAttribute("regExp") && form.children[d].getAttribute("rules")) {
                            form.children[d].setAttribute("regExp", form.children[d].getAttribute("rules"));
                        }
                        fDocValues.appendChild(dValue);
                        facilis.parsers.ParseInUtils.setSubNodeValue(dValue, "fname", form.children[d].getAttribute("attName"));
                        facilis.parsers.ParseInUtils.setSubNodeValue(dValue, "description", form.children[d].getAttribute("attLabel"));
                        facilis.parsers.ParseInUtils.setSubNodeValue(dValue, "tooltip", form.children[d].getAttribute("attTooltip"));
                        facilis.parsers.ParseInUtils.setSubNodeValue(dValue, "datatype", form.children[d].getAttribute("datatype"));
                        facilis.parsers.ParseInUtils.setSubNodeValue(dValue, "fieldtype", this.getFieldType(form.children[d].getAttribute("fieldtype")));
                        facilis.parsers.ParseInUtils.setSubNodeValue(dValue, "rules", form.children[d].getAttribute("regExp"));
                        facilis.parsers.ParseInUtils.setSubNodeValue(dValue, "grid", form.children[d].getAttribute("grid"));
                    //}
                    }
                }
            }
            if(formId=="" && addNoExist){
                var frmAdded = addFormResource(form);
                value.firstElementChild.setAttribute("value", frmAdded.getAttribute("resourceId"));
            }
            return value;
        }
        return null;
    }

    element.addFormResource=function(form){
        var mainXML = facilis.View.getInstance().getMainProcessData();
        var forms = facilis.parsers.ParseInUtils.getSubNode(mainXML, "forms");
        var data = forms.firstElementChild.cloneNode(true);
        var parsedForm = this.getFormValue(form, data, false);
        if (parsedForm.children.length > 1) {
            if (!facilis.controller.FormResources.getInstance().checkExists(parsedForm.children[1].getAttribute("value"))) {
                parsedForm = facilis.controller.FormResources.getInstance().addResource(parsedForm);					
            } else {
                parsedForm.setAttribute("resourceId", facilis.controller.FormResources.getInstance().getExistingId(parsedForm.children[1].getAttribute("value")));
            }
        } else {				
            parsedForm = facilis.controller.FormResources.getInstance().addResource(parsedForm);
        }
        parsedForm.firstElementChild.setAttribute("value", parsedForm.getAttribute("resourceId"));
        return parsedForm;
    }

    element.getFieldType=function(type) {
        var t = "";
        switch (type){
            case "Radio":
            t = "Radio Button";
            break;
            case "TextArea":
            t = "Text Area";
            break;
            case "FileInput":
            t = "File Input";
            break;
            case "Listbox":
            t = "ListBox";
            break;
            case "Checkbox":
            t = "CheckBox";
            break;
            case "Combobox":
            t = "ComboBox";
            break;
            default:
            t = type;
            break;
        }
        if (t == "Input" || t == "ComboBox" || t == "ListBox" || t == "CheckBox" || t == "Radio Button" || t == "Text Area" || t == "File Input" || t == "Editor" || t == "Password") {
            //return t;
        }else{
            t="Input";
        }
        return t;
    }

    element.parseEventElements=function(parsedEvents,events) {
        var eventsData = facilis.parsers.ParseInUtils.getSubNode(parsedEvents, "data");
        var values = this.parsedNode.ownerDocument.createElement("values");
        parsedEvents.appendChild(values);
        if (events.firstElementChild && !events.firstElementChild.nodeName) {
            events = facilis.parsers.ParseInUtils.getParsedNode("<events>"+events.firstElementChild.outerHTML+"</events>");
        }
        for (var i=0; i < events.children.length; i++ ) {
            var event = events.children[i];
            if(!(event.getAttribute("name")=="undefined" && event.getAttribute("description")=="undefined")){
                var value = eventsData.cloneNode(true);
                if (!event.getAttribute("busClaName") && event.getAttribute("action")) {
                    event.setAttribute("busClaName", event.getAttribute("action"));
                }
                if (!event.getAttribute("evtName") && event.getAttribute("name")) {
                    event.setAttribute("evtName", event.getAttribute("name"));
                }
                facilis.parsers.ParseInUtils.setSubNodeValue(value, "evtName", ((event.getAttribute("evtName")!="undefined")?event.getAttribute("evtName"):""));
                facilis.parsers.ParseInUtils.setSubNodeValue(value, "clsName", ((event.getAttribute("busClaName")!= "undefined")?event.getAttribute("busClaName"):""));
                facilis.parsers.ParseInUtils.setSubNodeValue(value, "clsDesc", ((event.getAttribute("busClaDesc")!= "undefined")?event.getAttribute("busClaDesc"):""));
                value.nodeName = "value";
                values.appendChild(value);
            }
        }
    }

    element.parseCategories=function() {
        var categories = this.getParsedSubNode("categories");
        if (categories) {
            var ObjectTag = this.getToParseSubNode("Object");
            var Categories = facilis.parsers.ParseInUtils.getSubNode(ObjectTag, "Categories");
            if(Categories){
                parseCategoriesNode(Categories, categories);
            }
        }
    }

    element.parseCategoriesNode=function(Categories,categories) {
        var values = this.parsedNode.ownerDocument.createElement("values");
        parseSubCategories(Categories, values);
        categories.appendChild(values);
    }

    element.parseSubCategories=function(Categories,parent) {
        for (var i = 0; i < Categories.children.length;i++ ) {
            var category = getCategoryNode(Categories.children[i]);
            if (category) {
                parent.appendChild(category);
            }
        }
    }

    element.getCategoryNode=function(Category) {
        var value = this.parsedNode.ownerDocument.createElement("value");
        var level = this.parsedNode.ownerDocument.createElement("level");
        level.setAttribute("id", Category.getAttribute("CategoryId"));
        level.setAttribute("value", Category.getAttribute("Name"));
        level.setAttribute("type", "label");
        value.appendChild(level);
        if(Category.children.length>0){
            var children = this.parsedNode.ownerDocument.createElement("children");
            value.appendChild(children);
            parseSubCategories(Category, children);
        }
        return value;
    }

    element.parseProperties=function() {
        var Properties = this.getToParseSubNode("Properties");
        var properties = this.getParsedSubNode("properties");
        parsePropertiesNode(Properties, properties);
    }

    element.parsePropertiesNode=function(Properties,properties) {
        if (properties && Properties) {
            var data = this.getData(properties);
            var values = this.parsedNode.ownerDocument.createElement("values");
            properties.appendChild(values);
            for (var i = 0; i < Properties.children.length; i++ ) {
                var Property = Properties.children[i];
                var value= data.cloneNode(true);
                value.nodeName = "value";
                //var nodes= facilis.parsers.ParseInUtils.getSubNode(value, "values");
                var nodes= value;
                for (var u = 0; u < nodes.children.length; u++) {
                    if (nodes.children[u].getAttribute("name")=="name") {
                        nodes.children[u].setAttribute("value", Property.getAttribute("Name"));
                    }else if (nodes.children[u].getAttribute("name") == "id") {
                        nodes.children[u].setAttribute("value", Property.getAttribute("PropertyId"));
                    }else if (nodes.children[u].getAttribute("name") == "propertytype") {
                        nodes.children[u].setAttribute("value", Property.getAttribute("PropertyType"));
                    }else if (nodes.children[u].getAttribute("name") == "value") {
                        nodes.children[u].setAttribute("value", Property.getAttribute("Type"));
                    }else if (nodes.children[u].getAttribute("name") == "type") {
                        nodes.children[u].setAttribute("value", Property.getAttribute("Value"));
                    }else if (nodes.children[u].getAttribute("name") == "correlation") {
                        nodes.children[u].setAttribute("value", Property.getAttribute("Correlation"));
                    }else if (nodes.children[u].getAttribute("name") == "uk") {
                        nodes.children[u].setAttribute("value", Property.getAttribute("UK"));
                    }else if (nodes.children[u].getAttribute("name") == "multivalued") {
                        nodes.children[u].setAttribute("value", Property.getAttribute("Multivalued"));
                    }else if (nodes.children[u].getAttribute("name") == "index") {
                        nodes.children[u].setAttribute("value", Property.getAttribute("Index"));
                    }
                }
                values.appendChild(value);
            }
        }
    }


    element.parseDataFields=function() {
        var DataFields= this.getToParseSubNode("DataFields");
        var properties= this.getParsedSubNode("properties");
        this.parseDataFieldsNode(DataFields, properties);
    }

    element.parseDataFieldsNode=function(DataFields,properties) {
        if (properties && DataFields) {
            var data= this.getData(properties);
            var values= this.parsedNode.ownerDocument.createElement("values");
            properties.appendChild(values);
            for (var i = 0; i < DataFields.children.length; i++ ) {
                var DataField= DataFields.children[i];
                var value= data.cloneNode(true);
                value.nodeName = "value";
                //var nodes= facilis.parsers.ParseInUtils.getSubNode(value, "values");
                var nodes= value;
                for (var u = 0; u < nodes.children.length; u++) {
                    if (nodes.children[u].getAttribute("name")=="name") {
                        nodes.children[u].setAttribute("value", DataField.getAttribute("Name"));
                    }else if (nodes.children[u].getAttribute("name") == "value") {
                        nodes.children[u].setAttribute("value", DataField.getAttribute("Type"));
                    }else if (nodes.children[u].getAttribute("name") == "type") {
                        nodes.children[u].setAttribute("value", DataField.getAttribute("Value"));
                    }else if (nodes.children[u].getAttribute("name") == "correlation") {
                        nodes.children[u].setAttribute("value", DataField.getAttribute("Correlation"));
                    }else if (nodes.children[u].getAttribute("name") == "uk") {
                        nodes.children[u].setAttribute("value", DataField.getAttribute("UK"));
                    }else if (nodes.children[u].getAttribute("name") == "multivalued") {
                        nodes.children[u].setAttribute("value", DataField.getAttribute("Multivalued"));
                    }else if (nodes.children[u].getAttribute("name") == "index") {
                        nodes.children[u].setAttribute("value", DataField.getAttribute("Index"));
                    }
                }
                values.appendChild(value);
            }
        }
    }

    element.parseUserAttributes=function() {
        var ExtendedAttributes= this.getToParseSubNode("ExtendedAttributes");
        if(ExtendedAttributes){
            var userproperties;
            for (var u = 0; u < this.parsedNode.children.length;u++ ) {
                if (this.parsedNode.children[u].getAttribute("id") == "userproperties") {
                    userproperties = this.parsedNode.children[u];
                }
            }
            if (userproperties) {
                var userattributes= facilis.parsers.ParseInUtils.getSubNode(userproperties, "userattributes");
                if(userattributes){
                    var data= this.getData(userattributes);
                    var values= this.parsedNode.ownerDocument.createElement("values");
                    for (var i = 0; i < ExtendedAttributes.children.length;i++ ) {
                        var value= data.cloneNode(true);
                        facilis.parsers.ParseInUtils.setSubNodeValue(value, "name", ExtendedAttributes.children[i].getAttribute("Name"));
                        facilis.parsers.ParseInUtils.setSubNodeValue(value, "value", ExtendedAttributes.children[i].getAttribute("Value"));
                        facilis.parsers.ParseInUtils.setSubNodeValue(value, "type", ExtendedAttributes.children[i].getAttribute("Type"));
                        values.appendChild(value);
                    }
                    userattributes.appendChild(values);
                }
            }
        }
    }

    element.getSubElements=function() {
        for (var i = 0; i < this.parsedNode.children.length; i++ ) {
            if (this.parsedNode.children[i].nodeName=="subElements") {
                return this.parsedNode.children[i];
            }
        }
        var subElements= this.parsedNode.ownerDocument.createElement("subElements");
        this.parsedNode.appendChild(subElements);
        return subElements;
    }

    


    facilis.parsers.input.ElementParser = facilis.promote(ElementParser, "Object");
    
}());


(function() {

    function Activity() {
        this.ElementParser_constructor();
        this.parseFunctions.push(this.getElementType);
        this.parseFunctions.push(this.parseAssignments);
        this.parseFunctions.push(this.parsePerformers);
        this.parseFunctions.push(this.parseProEleId);
        
    }
    
    var element = facilis.extend(Activity, facilis.parsers.input.ElementParser);

    element.startParse=function() {
        this.callParseFunctions();
        return this.parsedNode;
    }

    element.getElementType=function() {
        var type = this.toParseNode.getAttribute("name");
        if (type=="gateway") {
            this.parsedNode.setAttribute("ElementType", "G");
        }else if (type=="task") {
            this.parsedNode.setAttribute("ElementType", "T");
        }else if (type=="csubflow" || type=="esubflow") {
            this.parsedNode.setAttribute("ElementType", "S");
        }else if (type=="startevent" || type=="middleevent" || type == "endevent") {
            this.parsedNode.setAttribute("ElementType", "E");
        }
    }


    element.parseAssignments=function() {
        var Assignments = this.getToParseSubNode("Assignments");
        var assignments = this.getParsedSubNode("assignments");
        this.parseAssignmentsNode(Assignments, assignments);
    }

    element.parseAssignmentsNode=function(Assignments,assignments) {
        if(Assignments && assignments){
            var data = this.getData(assignments);
            var values = this.parsedNode.ownerDocument.createElement( "values");
            assignments.appendChild(values);
            for (var i = 0; i < Assignments.children.length; i++ ) {
                var value = data.cloneNode(true);
                value.nodeName = "value";
                getAssignment(Assignments.children[i], value);
                values.appendChild(value);
            }
        }
    }

    element.getAssignment=function(Assignment, assignment ) {
        var from = facilis.parsers.ParseInUtils.getSubNode(assignment, "from");
        var to = facilis.parsers.ParseInUtils.getSubNode(assignment, "to");

        var Expression = facilis.parsers.ParseInUtils.getSubNode(Assignment, "Expression");
        var Target = facilis.parsers.ParseInUtils.getSubNode(Assignment, "Target");

        var values = facilis.parsers.ParseInUtils.getSubNode(to,"values");
        for (var i = 0; i < values.children.length; i++ ) {
            var name = values.children[i].getAttribute("name");
            if (name=="name") {
                values.children[i].setAttribute("value", Target.getAttribute("Name"));
            }
            if (name=="type") {
                values.children[i].setAttribute("value", Target.getAttribute("Type"));
            }
            if (name=="value") {
                values.children[i].setAttribute("value", Target.getAttribute("Value"));
            }
            if (name=="correlation") {
                values.children[i].setAttribute("value", Target.getAttribute("Correlation"));
            }
            if (name=="targettype") {
                values.children[i].setAttribute("value", Target.getAttribute("TargetType"));
            }
            if (name=="index") {
                values.children[i].setAttribute("value", Target.getAttribute("Index"));
            }
        }

        if(Expression.firstElementChild){
            facilis.parsers.ParseInUtils.setSubNodeValue(from, "expressionbody", Expression.firstElementChild.nodeValue);
        }

        facilis.parsers.ParseInUtils.setSubNodeValue(assignment, "assigntime", Assignment.getAttribute("AssignTime"));

    }

    element.parsePerformers=function() {
        var Performers = this.getToParseSubNode("Performers");
        if (!Performers) {
            var Performer = this.getToParseSubNode("Performer");
            if (Performer) {
                Performers = this.parsedNode.ownerDocument.createElement( "Performers");
                Performers.appendChild(Performer);
            }
        }
        var performers = this.getParsedSubNode("performers");
        this.parsePerformersNode(Performers,performers);

    }

    element.parsePerformersNode=function(Performers, performers) {
        if (performers && performers.getAttribute("type") == "text" ){
            if(Performers && Performers.firstElementChild && Performers.firstElementChild.firstElementChild) {
                performers.setAttribute("value", Performers.firstElementChild.firstElementChild.nodeValue);
            }
        }else if (performers && Performers) {
            var data = this.getData(performers);
            var values = this.parsedNode.ownerDocument.createElement( "values");
            for (var i = 0; i < Performers.children.length; i++ ) {
                var value = data.cloneNode(true);
                value.nodeName = "value";
                values.appendChild(value);
                var Performer = Performers.children[i];
                var perfName = Performer.getAttribute("PerfName");
                var perfId = Performer.getAttribute("PerfId");
                /*if (!perfName && Performer.firstElementChild) {
                    perfName = Performer.firstElementChild.nodeValue;
                }*/
                if (!perfId && Performer.firstElementChild) {
                    perfId = Performer.firstElementChild.nodeValue;
                    var participant = facilis.parsers.ParserIn.getParticipantByIdOrName(perfId);
                    if (participant) {
                        perfId = participant.id;
                    }
                }
                if (!perfName) {
                    var p=facilis.parsers.ParserIn.getParticipantById(perfId);
                    if (p) {
                        perfName = p.name;
                    }
                }
                var Documentation = facilis.parsers.ParseInUtils.getSubNode(Performer,"Documentation");
                var documentation = facilis.parsers.ParseInUtils.getSubNode(value, "documentation");
                if (Documentation && documentation) {
                    parseDocumentationNode(Documentation, documentation);
                }
                facilis.parsers.ParseInUtils.setSubNodeValue(value, "perfid", perfId);
                facilis.parsers.ParseInUtils.setSubNodeValue(value, "perfname", perfName);
                var cond = facilis.parsers.ParseInUtils.getSubNode(value, "condition");
                if (cond && Performer.getAttribute("ProElePerfEvalCond")) {
                    var condValues = this.parsedNode.ownerDocument.createElement( "values");
                    var condValue = this.parsedNode.ownerDocument.createElement( "value");
                    var condVal = this.parsedNode.ownerDocument.createTextNode( Performer.getAttribute("ProElePerfEvalCond"));
                    condValue.appendChild(condVal);
                    condValues.appendChild(condValue);
                    cond.appendChild(condValues);
                }
                var doc = facilis.parsers.ParseInUtils.getSubNode(value, "documentation");
                if (doc && Performer.getAttribute("ConditionDoc")) {
                    var docValues = this.parsedNode.ownerDocument.createElement( "values");
                    var docValue = this.parsedNode.ownerDocument.createElement( "value");
                    var docVal = this.parsedNode.ownerDocument.createTextNode( Performer.getAttribute("ConditionDoc"));
                    docValue.appendChild(docVal);
                    docValues.appendChild(docValue);
                    doc.appendChild(docValues);
                }
                if (perfName=="busClass") {
                    value.removeNode();
                }
            }
            performers.appendChild(values);
        }
    }

    element.parseWebServiceCatchNode=function(WebServiceCatchNode,messagecatch) {
        parseCatchWs(WebServiceCatchNode,messagecatch);
    }

    element.parseCatchWs=function(WebServiceMapping, messagecatch) {
        if(WebServiceMapping.firstElementChild){
            parseWs(WebServiceMapping.firstElementChild, messagecatch);
        }
    }

    element.parseWs=function(webservice, messagecatch) {
        //var value = data.cloneNode(true);
        var value = messagecatch.firstElementChild;
        var wsName = value.children[0];
        wsName.setAttribute("value", webservice.getAttribute("ws_method_name"));
        var pAtts = value.children[1];
        var pValues = this.parsedNode.ownerDocument.createElement( "values");
        pAtts.appendChild(pValues);
        var eAtts = value.children[2];
        var eValues = this.parsedNode.ownerDocument.createElement( "values");
        eAtts.appendChild(eValues);
        for (var i = 0; i < webservice.children.length; i++ ) {
            var fValue;
            if (webservice.children[i].getAttribute("attribute_type") == "E") {
                fValue = this.getData(eAtts).cloneNode(true);
                eValues.appendChild(fValue);
            }else {
                fValue = this.getData(pAtts).cloneNode(true);
                pValues.appendChild(fValue);
            }
            fValue.nodeName = "value";
            facilis.parsers.ParseInUtils.setSubNodeValue(fValue, "id", webservice.children[i].getAttribute("attribute_id"));
            facilis.parsers.ParseInUtils.setSubNodeValue(fValue, "name", webservice.children[i].getAttribute("name"));
            facilis.parsers.ParseInUtils.setSubNodeValue(fValue, "uk", (webservice.children[i].getAttribute("attribute_uk")=="T").toString());
            facilis.parsers.ParseInUtils.setSubNodeValue(fValue, "multivalued", (webservice.children[i].getAttribute("multivalued")=="T").toString());

        }
    }

    element.parseEvents=function(Events, bussinesClasses) {
        if (bussinesClasses) {
            var data = this.getData(bussinesClasses);
            var values = this.parsedNode.ownerDocument.createElement( "values");
            if (Events) {
                for (var i = 0; i < Events.children.length; i++ ) {
                    var value = data.cloneNode(true);
                    value.nodeName = "value";
                    if(!Events.children[i].getAttribute("WS") || (Events.children[i].getAttribute("WS")=="false")){
                        var event = parseEventClass(Events.children[i], value);
                        if(event){
                            values.appendChild(event);
                        }
                    }
                }
                bussinesClasses.appendChild(values);
            }
        }
    }

    element.parseEventClass=function(event,value) {
        if (event.getAttribute("BusClaName") == "BPMNAutoComplete") {
            return null;
        }
        facilis.parsers.ParseInUtils.getSubNode(value, "evtid").setAttribute("value",event.getAttribute("EvtId"));
        facilis.parsers.ParseInUtils.getSubNode(value, "clsid").setAttribute("value",event.getAttribute("BusClaId"));
        facilis.parsers.ParseInUtils.getSubNode(value, "evtname").setAttribute("value",event.getAttribute("EvtName"));
        facilis.parsers.ParseInUtils.getSubNode(value, "clsname").setAttribute("value", event.getAttribute("BusClaName"));
        setSkipCondition(facilis.parsers.ParseInUtils.getSubNode(value, "skipcondition"),event.getAttribute("SkipCond"));

        var binding = this.getParsedSubNode("binding");

        parseBindings(facilis.parsers.ParseInUtils.getSubNode(event, "BusClaParBindings"), facilis.parsers.ParseInUtils.getSubNode(value, "binding"));

        return value;
    }

    element.setSkipCondition=function(conditionNode, condition) {
        var values = this.parsedNode.ownerDocument.createElement( "values");
        var value = this.parsedNode.ownerDocument.createElement( "value");
        value.setAttribute("value", condition);
        values.appendChild(value);
        value.appendChild(this.parsedNode.ownerDocument.createTextNode( condition));
        conditionNode.appendChild(values);
        conditionNode.setAttribute("value", value.getAttribute("value"));
    }

    element.parseBindings=function(BusClaParBindings, node) {
        var data = this.getData(node);
        var values = this.parsedNode.ownerDocument.createElement( "values");
        if (BusClaParBindings) {
            for (var i = 0; i < BusClaParBindings.children.length; i++ ) {
                var value = data.cloneNode(true);
                value.nodeName = "value";
                values.appendChild(value);
                facilis.parsers.ParseInUtils.getSubNode(value, "id").setAttribute("value", BusClaParBindings.children[i].getAttribute("BusClaParId"));
                facilis.parsers.ParseInUtils.getSubNode(value, "param").setAttribute("value", BusClaParBindings.children[i].getAttribute("BusClaParName"));
                facilis.parsers.ParseInUtils.getSubNode(value, "type").setAttribute("value", BusClaParBindings.children[i].getAttribute("BusClaParType"));
                facilis.parsers.ParseInUtils.getSubNode(value, "value").setAttribute("value", (BusClaParBindings.children[i].getAttribute("BusClaParBndValue"))?BusClaParBindings.children[i].getAttribute("BusClaParBndValue"):"");
                facilis.parsers.ParseInUtils.getSubNode(value, "attribute").setAttribute("value", (BusClaParBindings.children[i].getAttribute("AttName"))?BusClaParBindings.children[i].getAttribute("AttName"):"");
                facilis.parsers.ParseInUtils.getSubNode(value, "attribute").getAttribute("atttype") = (((BusClaParBindings.children[i].getAttribute("BusClaParBndType") + "") ) == "P")?"process":"entity";
                facilis.parsers.ParseInUtils.getSubNode(value, "attributeid").setAttribute("value", (BusClaParBindings.children[i].getAttribute("AttId"))?BusClaParBindings.children[i].getAttribute("AttId"):"");
				facilis.parsers.ParseInUtils.getSubNode(value, "attributetooltip").setAttribute("value", (BusClaParBindings.children[i].getAttribute("AttTooltip")) ? BusClaParBindings.children[i].getAttribute("AttTooltip") : "");
            }
            node.appendChild(values);
        }
    }


    element.parseWebServiceThrowNode=function(WebServiceThrow, messagethrow) {
        parseThrowWs(messagethrow);

    }

    element.parseThrowWs=function(messagethrow) {
        var bussinessclasses = facilis.parsers.ParseInUtils.getSubNode(messagethrow, "wsclasses");
        var data = this.getData(bussinessclasses);
        var ApiaTskEvents = this.getToParseSubNode("ApiaEvents");
        var values = this.parsedNode.ownerDocument.createElement( "values");
        if (ApiaTskEvents && (ApiaTskEvents.children.length > 0) && bussinessclasses) {
            for (var i = 0; i < ApiaTskEvents.children.length; i++ ) {
                var value = data.cloneNode(true);
                value.nodeName = "value";
                var ApiaTskEvent = parseWsEventClass(ApiaTskEvents.children[i], value);
                if (ApiaTskEvents.children[i].getAttribute("WS") && ApiaTskEvents.children[i].getAttribute("WS") == "true" && ApiaTskEvents.children[i].getAttribute("BusClaId") != "102") {
                    values.appendChild(ApiaTskEvent);
                }
            }
            bussinessclasses.appendChild(values);
        }
    }

    element.parseWsEventClass=function(ApiaTskEvent,value) {

        facilis.parsers.ParseInUtils.getSubNode(value, "evtid").setAttribute("value",ApiaTskEvent.getAttribute("EvtId"));
        facilis.parsers.ParseInUtils.getSubNode(value, "clsid").setAttribute("value",ApiaTskEvent.getAttribute("BusClaId"));
        facilis.parsers.ParseInUtils.getSubNode(value, "evtname").setAttribute("value",ApiaTskEvent.getAttribute("EvtName"));
        facilis.parsers.ParseInUtils.getSubNode(value, "clsname").setAttribute("value", ApiaTskEvent.getAttribute("BusClaName"));

        var binding = this.getParsedSubNode("binding");

        parseWsBindings(facilis.parsers.ParseInUtils.getSubNode(ApiaTskEvent, "BusClaParBindings"), facilis.parsers.ParseInUtils.getSubNode(value, "binding"));

        return value;
    }

    element.parseWsBindings=function(BusClaParBindings, node) {
        var data = this.getData(node);
        var values = this.parsedNode.ownerDocument.createElement( "values");
        if (BusClaParBindings) {
            for (var i = 0; i < BusClaParBindings.children.length; i++ ) {
                var value = data.cloneNode(true);
                value.nodeName = "value";
                values.appendChild(value);
                facilis.parsers.ParseInUtils.setSubNodeValue(value, "id" , BusClaParBindings.children[i].getAttribute("BusClaParId"));
                facilis.parsers.ParseInUtils.setSubNodeValue(value, "param" , BusClaParBindings.children[i].getAttribute("BusClaParName"));
                facilis.parsers.ParseInUtils.setSubNodeValue(value, "type" , BusClaParBindings.children[i].getAttribute("BusClaParType"));
                facilis.parsers.ParseInUtils.setSubNodeValue(value, "value", BusClaParBindings.children[i].getAttribute("BusClaParBndValue"));
                if(facilis.parsers.ParseInUtils.getSubNode(value, "attribute")){
                    facilis.parsers.ParseInUtils.getSubNode(value, "attribute").setAttribute("value", (BusClaParBindings.children[i].getAttribute("AttName"))?BusClaParBindings.children[i].getAttribute("AttName"):"");
                    facilis.parsers.ParseInUtils.getSubNode(value, "attribute").getAttribute("atttype") = (((BusClaParBindings.children[i].getAttribute("BusClaParBndType") + "") ) == "P")?"process":"entity";
                }
                facilis.parsers.ParseInUtils.setSubNodeValue(value, "attributeid",(BusClaParBindings.children[i].getAttribute("AttId"))?BusClaParBindings.children[i].getAttribute("AttId"):"");
                facilis.parsers.ParseInUtils.setSubNodeValue(value, "uk",BusClaParBindings.children[i].getAttribute("UK"));
                facilis.parsers.ParseInUtils.setSubNodeValue(value, "multivalued" ,BusClaParBindings.children[i].getAttribute("Multivalued"));
            }
            node.appendChild(values);
        }
    }


    element.getWsPublications=function() {
        var WsPublications = this.getToParseSubNode("WsPublications");
        if (WsPublications) {
            var webservices = this.getParsedSubNode("webservices");
            var data = this.getData(webservices);
            var values = this.parsedNode.ownerDocument.createElement( "values");
            if (data) {
                for (var i = 0; i < WsPublications.children.length; i++ ) {
                    var WsPublication = WsPublications.children[i];
                    var value = data.cloneNode(true);
                    value.nodeName = "value";
                    facilis.parsers.ParseInUtils.getSubNode(value, "wsname").setAttribute("value", WsPublication.getAttribute("WsName"));
                    var WsPublicationAttributes = facilis.parsers.ParseInUtils.getSubNode(WsPublication, "WsPublicationAttributes");
                    var entAtts = facilis.parsers.ParseInUtils.getSubNode(value, "entityattributes");
                    var pcsAtts = facilis.parsers.ParseInUtils.getSubNode(value, "processattributes");
                    if (WsPublicationAttributes){
                        var entAttsValues = this.parsedNode.ownerDocument.createElement( "values");
                        var pcsAttsValues = this.parsedNode.ownerDocument.createElement( "values");
                        entAtts.appendChild(entAttsValues);
                        pcsAtts.appendChild(pcsAttsValues);
                        var attData = this.getData(entAtts);

                        for (var u = 0; u < WsPublicationAttributes.children.length; u++ ) {
                            var val = parseWSAttribute(attData,WsPublicationAttributes.children[u]);
                        }

                    }
                }
            }
        }
    }

    element.parseWSAttribute=function(dataXML, WsPublicationAttribute) {
        var value = dataXML.cloneNode(true);
        if(WsPublicationAttribute){
            for (var i = 0; i < WsPublicationAttribute.children.length; i++ ) {
                /*var value = values.children[i];
                var WsPublicationAttribute = this.parsedNode.ownerDocument.createElement( "WsPublicationAttribute");
                WsPublicationAttributes.appendChild(WsPublicationAttribute);
                WsPublicationAttribute.setAttribute("WsAttType", type);
                for (var u = 0; u < value.children.length; u++ ) {
                    var name = value.children[u].getAttribute("name");
                    var val = value.children[u].getAttribute("value");
                    if(val){
                        if (name=="id") {
                            WsPublicationAttribute.setAttribute("AttId", val);
                        }else if (name=="name") {
                            WsPublicationAttribute.setAttribute("AttName", val);
                        }else if (name=="unique") {
                            WsPublicationAttribute.setAttribute("WsAttUk", val);
                        }else if (name=="multiple") {
                            WsPublicationAttribute.setAttribute("Multivaluated", val);
                        }
                    }
                }*/
            }
        }
    }

    element.parseProEleId=function() {
        var ProEleId = this.toParseNode.getAttribute("Id");
        /*var ProEleId = this.toParseNode.getAttribute("ProId");
        if (!ProEleId) {
            ProEleId = this.toParseNode.getAttribute("Id");
        }*/
        if (ProEleId) {
            this.parsedNode.setAttribute("proeleid", ProEleId);
        }
    }
    
    
    facilis.parsers.input.Activity = facilis.promote(Activity, "ElementParser");
    
}());


(function() {

    function ActivityElement() {
        this.Activity_constructor();
        this.parseFunctions.push(this.getLoopType);
    }
    
    var element = facilis.extend(ActivityElement, facilis.parsers.input.Activity);
    
    element.getLoopType=function() {
        var loop = this.getToParseSubNode("Loop");
        if (loop && loop.attributes.LoopType) {
            var loopType = loop.attributes.LoopType;
            this.setParsedSubNodeValue("looptype", loopType);
            var std = loop.firstElementChild;
            if (loopType == "Standard") {
                var testTime = std.attributes.TestTime;
                var loopmaximum = std.attributes.LoopMaximum;
                var loopcounter = std.attributes.LoopCounter;
                this.setParsedSubNodeValue("testTime", testTime);
                this.setParsedSubNodeValue("loopmaximum", loopmaximum);
                this.setParsedSubNodeValue("loopcounter", loopcounter);
                var loopcondition = this.getParsedSubNode("loopcondition");
                var loopdocumentation = this.getParsedSubNode("loopdocumentation");
                if (loopcondition && std.attributes.LoopCondition) {
                    var loopCValues = this.parsedNode.ownerDocument.createElement( "values");
                    var loopCValue = this.parsedNode.ownerDocument.createElement( "value");
                    var loopCValNode = this.parsedNode.ownerDocument.createTextNode( std.attributes.LoopCondition);
                    loopCValue.appendChild(loopCValNode);
                    loopCValue.attributes.value = std.attributes.LoopCondition;
                    loopCValues.appendChild(loopCValue);
                    loopcondition.appendChild(loopCValues);
                    loopcondition.attributes.value = std.attributes.LoopCondition;
                }
                if(loopdocumentation && std.attributes.ConditionDoc){
                    var loopCDValues = this.parsedNode.ownerDocument.createElement( "values");
                    var loopCDValue = this.parsedNode.ownerDocument.createElement( "value");
                    var loopCDValNode = this.parsedNode.ownerDocument.createTextNode( std.attributes.ConditionDoc);
                    loopCDValue.appendChild(loopCDValNode);
                    loopCDValue.attributes.value = std.attributes.ConditionDoc;
                    loopCDValues.appendChild(loopCDValue);
                    loopdocumentation.appendChild(loopCDValues);
                }
            }else if (loopType == "MultiInstance") {
                var LoopMultiInstance = facilis.parsers.ParseInUtils.getSubNode(loop, "LoopMultiInstance");
                if (LoopMultiInstance) {
                    var mi_condition = this.getParsedSubNode("mi_condition");
                    if (LoopMultiInstance.attributes.MultiplierAttId) {
                        var id = this.parsedNode.ownerDocument.createElement( "level");
                        var name = this.parsedNode.ownerDocument.createElement( "level");
                        id.attributes.name = "id";
                        name.attributes.name = "name";
                        id.attributes.value = LoopMultiInstance.attributes.MultiplierAttId;
                        name.attributes.value = LoopMultiInstance.attributes.MultiplierAttName;
                        var values = this.parsedNode.ownerDocument.createElement( "values");
                        var value = this.parsedNode.ownerDocument.createElement( "value");
                        value.appendChild(id);
                        value.appendChild(name);
                        values.appendChild(value);
                        mi_condition.appendChild(values);
                        mi_condition.attributes.value = LoopMultiInstance.attributes.MultiplierAttName;
                    }else {
                        if(LoopMultiInstance.attributes["MI_Condition"] && Utils.isNumeric(LoopMultiInstance.attributes["MI_Condition"])){
                            this.setParsedSubNodeValue("mi_condition", LoopMultiInstance.attributes["MI_Condition"]);
                        }
                    }
                    var mi_ordering = this.getParsedSubNode("mi_ordering");
                    if(mi_ordering && LoopMultiInstance.attributes.MI_Ordering){
                        mi_ordering.attributes.value = LoopMultiInstance.attributes.MI_Ordering;
                    }
                }
            }
        }
    }

    facilis.parsers.input.ActivityElement = facilis.promote(ActivityElement, "Activity");
    
}());




(function() {

    function Artifact() {
        this.ElementParser_constructor();
        this.parseFunctions.push(this.getTextAnnotation);
        this.parseFunctions.push(this.getState);
        this.parseFunctions.push(this.getName);
		this.parseFunctions.push(this.getIsCollection);
		this.parseFunctions.push(this.getCapacity);
		this.parseFunctions.push(this.getIsUnlimited);
    }
    
    //static public//
    
    
    var element = facilis.extend(Artifact, facilis.parsers.input.ElementParser);
    
    element.startParse=function(){
        this.callParseFunctions();
        return this.parsedNode;
    }

    element.getTextAnnotation=function() {
        var textannotation = this.toParseNode.attributes.TextAnnotation;
        if (textannotation) {
            this.setParsedSubNodeValue("text",textannotation);
        }
    }

    element.getName=function() {
        if (this.toParseNode.attributes.Name) {
            var name = this.toParseNode.attributes.Name;
            if (name != null) {
                this.setParsedSubNodeValue("name",name);
            }
        }
    }

    element.getState=function() {
        if (this.toParseNode.firstElementChild) {
            var DataObject = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "DataObject");
            if(DataObject){
                var state = DataObject.attributes.State;
                if (state != null) {
                    this.setParsedSubNodeValue("state",state);
                }
            }
        }
    }
	
	element.getIsCollection=function() {
		if (this.toParseNode.firstElementChild) {
			var DataObject;
			if (this.toParseNode.nodeName.indexOf("DataInput") >= 0) {
				DataObject = this.toParseNode;
			/*} else if (toParseNode.nodeName.indexOf("DataOutput") >= 0) {
				DataObject = toParseNode;*/
			} else {
				DataObject = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "DataObject");
			}
			if(DataObject){
				var isCollection = DataObject.getAttribute("IsCollection");
				if (isCollection != null) {
					this.setParsedSubNodeValue("isCollection", isCollection);
				}
			}
		}
	}
	/*
	element.getDataObjectType=function() {
		if (toParseNode.firstElementChild) {
			if (toParseNode.nodeName.indexOf("DataInput") >= 0) {
				setParsedSubNodeValue("dataobjectType", "Input");
			} else if (toParseNode.nodeName.indexOf("DataOutput") >= 0) {
				setParsedSubNodeValue("dataobjectType", "Output");
			} else {
				setParsedSubNodeValue("dataobjectType", "None");
			}
		}
	}
	*/
	element.getCapacity=function() {
		var capacity = this.toParseNode.getAttribute("Capacity");
		if (capacity) {
			this.setParsedSubNodeValue("capacity", capacity);
		}
	}

	element.getIsUnlimited=function() {
		var isUnlimited = this.toParseNode.getAttribute("IsUnlimited");
		if (isUnlimited) {
			this.setParsedSubNodeValue("isUnlimited", isUnlimited);
		}
	}


    facilis.parsers.input.Artifact = facilis.promote(Artifact, "ElementParser");
    
}());

(function() {

    function Line() {
        this.ElementParser_constructor();
        this.parseFunctions.push(this.getStartEnd);
        this.parseFunctions.push(this.getVertexes);
    }
    
    var element = facilis.extend(Line, facilis.parsers.input.ElementParser);
    
    element.startParse=function(){
        this.callParseFunctions();
        return this.parsedNode;
    }


    element.getStartEnd=function() {
        var startid = this.toParseNode.getAttribute("From");
        var endid = this.toParseNode.getAttribute("To");
        if (!startid) {
            startid = this.toParseNode.getAttribute("Source");
        }
        if (!endid) {
            endid = this.toParseNode.getAttribute("Target");
        }
        this.parsedNode.setAttribute("startid", startid);
        this.parsedNode.setAttribute("endid", endid);
    }

    element.getVertexes=function() {
        var ConnectorGraphicsInfo= this.getToParseSubNode("ConnectorGraphicsInfo");
        if(ConnectorGraphicsInfo){
            ConnectorGraphicsInfo= ConnectorGraphicsInfo.cloneNode(true);
            //ConnectorGraphicsInfo.nodeName = "vertex";
            var vertex=this.parsedNode.ownerDocument.createElement("vertex");
            for(var i=0;i<ConnectorGraphicsInfo.children.length;i++)
                vertex.appendChild(ConnectorGraphicsInfo.children[i].cloneNode(true));
            
            this.parsedNode.appendChild(vertex);
        }
    }


    facilis.parsers.input.Line = facilis.promote(Line, "ElementParser");
    
}());


(function() {

    function Association() {
        this.Line_constructor();
        this.parseFunctions.push(this.getDirection);
    }
    
    //static public//
    
    
    var element = facilis.extend(Association, facilis.parsers.input.Line);
    
    element.getDirection=function() {
        this.setParsedSubNodeValue("direction", this.toParseNode.getAttribute("AssociationDirection"));
        if (this.toParseNode.getAttribute("AssociationDirection") == "To") {
            this.toParseNode.setAttribute("AssociationDirection", "From");
            var startid = this.parsedNode.getAttribute("startid");
            var endid = this.parsedNode.getAttribute("endid");
            this.parsedNode.setAttribute("startid", endid);
            this.parsedNode.setAttribute("endid", startid);
        }
    }


    facilis.parsers.input.Association = facilis.promote(Association, "Line");
    
}());

(function() {

    function Lane() {
        this.ElementParser_constructor();
        
    }
    
    var element = facilis.extend(Lane, facilis.parsers.input.ElementParser);

    facilis.parsers.input.Lane = facilis.promote(Lane, "ElementParser");
    
}());

(function() {

    function Gateway() {
        this.ElementParser_constructor();
        this.Route;
        this.parseFunctions.push(this.getRoute);
        this.parseFunctions.push(this.getInstantiate);
        this.parseFunctions.push(this.getExclusiveType);
        this.parseFunctions.push(this.getMarkerVisible);
        this.parseFunctions.push(this.getIncomingCondition);
        this.parseFunctions.push(this.getOutgoingCondition);
        this.parseFunctions.push(this.parseExecutionType);
    }
    
    //static public//
    
    
    var element = facilis.extend(Gateway, facilis.parsers.input.ElementParser);
    
    element.getRoute=function() {
        Route = this.getToParseSubNode("Route");
        if (!Route) {
            Route = this.getToParseSubNode("Gateway");
        }
        if (Route) {
            var gatewaytype = Route.getAttribute("GatewayType");
            if (facilis.View.getInstance().offline) {
                if (gatewaytype=="AND") {
                    gatewaytype = "Parallel";
                }
                if (gatewaytype=="XOR") {
                    gatewaytype = "Exclusive";
                }
                if (gatewaytype=="OR") {
                    gatewaytype = "Inclusive";
                }
            }
            if (gatewaytype) {
                this.setParsedSubNodeValue("gatewaytype",gatewaytype);
            }
        }
    }

    element.getInstantiate=function() {
        if(Route && Route.attributes.Instantiate){
            this.setParsedSubNodeValue("instantiate",Route.getAttribute("Instantiate"));
        }
    }

    element.getExclusiveType=function() {
        if(Route && Route.attributes.ExclusiveType){
            this.setParsedSubNodeValue("exclusivetype",Route.getAttribute("ExclusiveType"));
        }
    }

    element.getMarkerVisible=function() {
        if(Route && Route.attributes.MarkerVisible){
            this.setParsedSubNodeValue("markervisible",Route.getAttribute("MarkerVisible"));
        }
    }

    element.getIncomingCondition=function() {
        var conditionNode = this.getParsedSubNode("incomingcondition");
        if (Route && Route.attributes.IncomingCondition){
            var values = this.parsedNode.ownerDocument.createElement( "values");
            var value = this.parsedNode.ownerDocument.createElement( "value");
            value.attributes.value = Route.getAttribute("IncomingCondition");
            value.appendChild(this.parsedNode.ownerDocument.createTextNode( Route.getAttribute("IncomingCondition")));
            values.appendChild(value);
            conditionNode.appendChild(values);
        }
    }

    element.getOutgoingCondition=function() {
        var conditionNode = this.getParsedSubNode("outgoingcondition");
        if (Route && Route.attributes.OutgoingCondition){
            var values = this.parsedNode.ownerDocument.createElement( "values");
            var value = this.parsedNode.ownerDocument.createElement( "value");
            value.setAttribute("value", Route.getAttribute("OutgoingCondition"));
            value.appendChild(this.parsedNode.ownerDocument.createTextNode( Route.getAttribute("OutgoingCondition")));
            values.appendChild(value);
            conditionNode.appendChild(values);
        }
    }

    element.parseExecutionType=function() {
        var executiontype = this.getParsedSubNode("executiontype");
        if (executiontype) {
            executiontype.attributes.value = Route.getAttribute("ExecutionType");
        }
    }


    facilis.parsers.input.Gateway = facilis.promote(Gateway, "ElementParser");
    
}());

(function() {

    function Pool() {
        this.Activity_constructor();
        this.parseFunctions.push(this.getProcess);
			this.parseFunctions.push(this.getBoundary);
			this.parseFunctions.push(this.getLanes);
			this.parseFunctions.push(this.parseParticipant);
    }
    
    var element = facilis.extend(Pool, facilis.parsers.input.Activity);
    
    element.getLanes=function() {
        if(this.toParseNode.attributes.BoundaryVisible!="false"){
            for (var i = 0; i < this.toParseNode.children.length; i++ ) {
                if (this.toParseNode.children[i].localName=="Lanes") {
                    this.parseLanes(this.toParseNode.children[i]);
                }
            }
        }
    }

    element.getProcess=function() {
        var process = this.toParseNode.getAttribute("Process");
        if (process != null) {
            this.parsedNode.setAttribute("process", process);
        }
    }

    element.getBoundary=function() {
        var BoundaryVisible = this.toParseNode.attributes.BoundaryVisible;
        if (BoundaryVisible=="false") {
            this.parsedNode.attributes.visible = "false";
        }
        if (BoundaryVisible != null) {
            this.setParsedSubNodeValue("boundaryvisible", BoundaryVisible);
        }else {
            this.setParsedSubNodeValue("boundaryvisible", "true");
        }
    }

    element.parseLanes=function(Lanes ) {
        var pin = new facilis.parsers.ParserIn();
        var subElements = this.getSubElements();
        for (var i=0; i < Lanes.children.length;i++ ) {
            var p = pin.getElementParser("swimlane");
            p.setParsedNode(facilis.ElementAttributeController.getInstance().getElementAttributes("swimlane"));
            var lane = p.parse(Lanes.children[i]);
            subElements.appendChild(lane);
        }
    }


    element.parseParticipant=function() {
        var participantref = this.getToParseSubNode("participantref");
        if (participantref && this.toParseNode.attributes.Participant) {
            var valuesStr = "<values><value value=\"" + this.toParseNode.attributes.Participant + "\"><level name=\"name\" value=\"" + this.toParseNode.attributes.Participant + "\" /></value></values>";
            var values = getParsedNode(valuesStr);
            participantref.appendChild(values);
            participantref.attributes.value = this.toParseNode.attributes.Participant;
        }
    }

    
    facilis.parsers.input.Pool = facilis.promote(Pool, "Activity");
    
}());



(function() {

    function Subflow() {
        this.ActivityElement_constructor();
        this.parseFunctions.push(this.getImplementation);
        this.parseFunctions.push(this.getIsTransaction);
        this.parseFunctions.push(this.getBlockActivity);
        this.parseFunctions.push(this.getIsExpanded);
        this.parseFunctions.push(this.getExecution);
        this.parseFunctions.push(this.getDataMappings);
        this.parseFunctions.push(this.parseSkipFirstTask);
        this.parseFunctions.push(this.getPrcName);
        this.parseFunctions.push(this.getFormsRef);
        this.parseFunctions.push(this.getEntity);
    }
    
    var element = facilis.extend(Subflow, facilis.parsers.input.ActivityElement);
    
    
    element.getImplementation=function() {
        /*var strNode = "<Implementation><Task>";
        var type = this.getToParseSubNodeValue("taskType");
        if (type.attributes.value!="") {
            strNode+="<"+type.attributes.value+" />"
        }
        strNode += "</Task></Implementation>";
        var implementationNode = getParsedNode(strNode);
        this.this.parsedNode.appendChild(implementationNode);*/
    }

    element.getIsTransaction=function() {
        var IsATransaction = this.toParseNode.getAttribute("IsATransaction");
        if (IsATransaction!="false") {
            this.setParsedSubNodeValue("transaction", IsATransaction);
            var Transaction = this.getToParseSubNode("Transaction");
            if (Transaction) {
                this.setParsedSubNodeValue("transactionid", Transaction.attributes.Id.value );
            }
        }
    }

    element.getIsAdhoc=function() {
        var adhoc = this.toParseNode.attributes.AdHoc.value;
        if (adhoc!="false") {
            this.setParsedSubNodeValue("adhoc",adhoc);
            var adhocordering = this.toParseNode.attributes.AdHocOrdering.value;
            if(adhocordering){
                this.setParsedSubNodeValue("adhocordering", adhocordering);
            }
        }
    }

    element.getBlockActivity=function() {
        var BlockActivity = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "BlockActivity");
        if (BlockActivity) {
            var ActivitySetId = BlockActivity.attributes.ActivitySetId.value;
            var processref = this.getParsedSubNode("name");
            if (processref) {
                var values = processref.children[1];
                if (values && values.firstElementChild) {
                    values = values.firstElementChild;
                    for (var i = 0; i < values.children.length; i++ ) {
                        if (values.children[i].attributes.name.value == "id") {
                            values.children[i].attributes.value.value=ActivitySetId;
                        }
                        if (values.children[i].attributes.name.value == "name") {
                            values.children[i].attributes.value.value = processref.attributes.value.value;
                            values.attributes.value.value=processref.attributes.value.value;
                        }
                    }
                }
            }
        }
    }

    element.getIsExpanded=function() {
        var NodeGraphicsInfo = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "NodeGraphicsInfo");
        if(NodeGraphicsInfo){
            var expanded = NodeGraphicsInfo.getAttribute("Expanded");
            if (expanded == "true") {
                this.parsedNode.attributes.expanded.value = expanded;
                if(NodeGraphicsInfo.attributes.ExpandedWidth.value && NodeGraphicsInfo.attributes.ExpandedHeight.value){
                    this.parsedNode.attributes.width.value = NodeGraphicsInfo.attributes.ExpandedWidth.value;
                    this.parsedNode.attributes.height.value = NodeGraphicsInfo.attributes.ExpandedHeight.value;
                }
            }
        }
    }

    element.getExecution=function() {
        var SubFlow = this.getToParseSubNode("SubFlow");
        if (SubFlow) {
            if(SubFlow.getAttribute("ApiaExecution")=="MAP"){
                var processtype = this.setParsedSubNodeValue("subprocesstype", "Embedded");
            }else {
                this.setParsedSubNodeValue("subprocesstype", "Reusable");
                var exec = SubFlow.getAttribute("ApiaExecution");
                if (exec && (exec.indexOf("_SKIP") > 0) ) {
                    exec = exec.split("_")[0];
                }
                this.setParsedSubNodeValue("execution", exec);
            }
        }
    }


    element.getDataMappings=function() {
        var DataMappings = this.getToParseSubNode("DataMappings");
        var datamappings = this.getParsedSubNode("datamappings");
        if(DataMappings && datamappings){
            var input = facilis.parsers.ParseInUtils.getSubNode(datamappings, "inputmaps");
            var inData = this.getData(input);
            var inValues = this.parsedNode.ownerDocument.createElement( "values");
            input.appendChild(inValues);

            var out = facilis.parsers.ParseInUtils.getSubNode(datamappings, "outputmaps");
            var outData = this.getData(out);
            var outValues = this.parsedNode.ownerDocument.createElement( "values");
            out.appendChild(outValues);
            var value;
            for (var i = 0 ; i < DataMappings.children.length; i++ ) {
                var DataMapping = DataMappings.children[i];
                if (DataMapping.attributes.Direction.value == "IN") {
                    value= inData.cloneNode(true);
                    value.nodeName = "value";
                    inValues.appendChild(value);
                    facilis.parsers.ParseInUtils.setSubNodeValue(value, "inputmap", DataMapping.attributes.TestValue.value);
                }else {
                    value= outData.cloneNode(true);
                    value.nodeName = "value";
                    outValues.appendChild(value);
                    facilis.parsers.ParseInUtils.setSubNodeValue(value, "outputmap", DataMapping.attributes.TestValue.value);
                }
            }
        }
    }

    element.parseSkipFirstTask=function() {
        var SubFlow = this.getToParseSubNode("SubFlow");
        if (SubFlow) {
            facilis.parsers.ParseInUtils.setSubNodeValue(this.parsedNode, "skipfirsttask", SubFlow.getAttribute("SkipFirstTask"));
        }
    }

    element.getPrcName=function() {
        var SubFlow = this.getToParseSubNode("SubFlow");
        facilis.parsers.ParseInUtils.setSubNodeValue(this.parsedNode, "name", this.toParseNode.getAttribute("Name"));
        if (SubFlow) {
            var nameXPDL = SubFlow.getAttribute("Name");
            if (nameXPDL.indexOf(".xpdl") > 0) {
                facilis.parsers.ParseInUtils.setSubNodeValue(this.parsedNode, "filename", nameXPDL);
            }
            var processref = facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "name");
            if (processref) {
                var oldValues=facilis.parsers.ParseInUtils.getSubNode(processref, "values");
                if (oldValues) {
                    oldValues.removeNode();
                }
                var values = this.parsedNode.ownerDocument.createElement( "values");
                values.setAttribute("value", this.toParseNode.getAttribute("Name"));
                var value = facilis.parsers.ParseInUtils.getParsedNode("<value value=\"" + this.toParseNode.getAttribute("Name") + "\"><level name=\"id\" type=\"label\" value=\"" + SubFlow.attributes.Id.value + "\" /><level name=\"name\" type=\"label\" value=\"" + this.toParseNode.getAttribute("Name") + "\" /></value>");
                values.appendChild(value);
                processref.attributes.value.value = this.toParseNode.getAttribute("Name");
                processref.appendChild(values);
            }
        }
    }

    element.getEntity=function() {
        var SubFlow = this.getToParseSubNode("SubFlow");
        if (SubFlow) {
            var entity = facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "entity");
            if (entity && SubFlow.attributes.ProEleAttBusEntName.value && SubFlow.attributes.ProEleAttBusEntId.value) {
                var values = this.parsedNode.ownerDocument.createElement( "values");
                var value = facilis.parsers.ParseInUtils.getParsedNode("<value value=\"" + SubFlow.attributes.ProEleAttBusEntName.value + "\"><level name=\"id\" type=\"label\" value=\"" + SubFlow.attributes.ProEleAttBusEntId.value + "\" /><level name=\"name\" type=\"label\" value=\"" + SubFlow.attributes.ProEleAttBusEntName.value + "\" /></value>");
                values.appendChild(value);
                entity.setAttribute("value", SubFlow.attributes.ProEleAttBusEntName.value);
                entity.appendChild(values);
            }
        }
    }

    element.getFormsRef=function() {
        var processforms = this.getParsedSubNode("processforms");
        var entityforms = this.getParsedSubNode("entityforms");
        if (processforms && entityforms) {
            var FormsRef = this.getToParseSubNode("FormsRef");
            var pData = this.getData(processforms);
            var eData = this.getData(entityforms);
            var eValues = this.parsedNode.ownerDocument.createElement( "values");
            var pValues = this.parsedNode.ownerDocument.createElement( "values");
            processforms.appendChild(pValues);
            entityforms.appendChild(eValues);
            var eForms = new Array();
            var pForms = new Array();
            var order;
            if (FormsRef) {
                for (var u = 0; u < FormsRef.children.length; u++ ) {
                    if (FormsRef.children[u].attributes.FrmType.value == "E") {
                        order = parseInt(FormsRef.children[u].attributes.ProEleFrmOrder.value);
                        var eValue = parseFormRef(FormsRef.children[u], eData);
                        eForms.push( { order:order, data:eValue } );
                        //eValues.appendChild(eValue);
                    }else {
                        order = parseInt(FormsRef.children[u].attributes.ProEleFrmOrder.value);
                        var pValue = parseFormRef(FormsRef.children[u], pData);
                        pForms.push( { order:order, data:pValue } );
                        //pValues.appendChild(pValue);
                    }
                }
                eForms.sortOn("order", Array.NUMERIC);
                pForms.sortOn("order", Array.NUMERIC);
                for (var e = 0; e < eForms.length; e++ ) {
                    eValues.appendChild(eForms[e].data);
                }
                for (var p = 0; p < pForms.length; p++ ) {
                    pValues.appendChild(pForms[p].data);
                }
            }
        }
    }

    element.parseFormRef=function(form, data) {
        var value = data.cloneNode(true);

        value.nodeName = "value";
        facilis.parsers.ParseInUtils.setSubNodeValue(value, "id", form.attributes.FrmId.value);
        facilis.parsers.ParseInUtils.setSubNodeValue(value, "name", form.attributes.FrmName.value);
        facilis.parsers.ParseInUtils.setSubNodeValue(value, "readonly", form.attributes.ProEleFrmReadOnly.value);
        facilis.parsers.ParseInUtils.setSubNodeValue(value, "multiple", form.attributes.ProEleFrmMultiply.value);
        if (form.attributes.ProEleFrmEvalCond.value) {
            var condVals= this.parsedNode.ownerDocument.createElement( "values");
            var condVal = this.parsedNode.ownerDocument.createElement( "value");
            condVals.appendChild(condVal);
            condVal.appendChild(this.parsedNode.ownerDocument.createTextNode( form.attributes.ProEleFrmEvalCond.value));
            var condNode = facilis.parsers.ParseInUtils.getSubNode(value, "condition");
            if(condNode){
                condNode.appendChild(condVals);
            }
        }
        if (form.attributes.ConditionDoc.value) {
            var docVals= this.parsedNode.ownerDocument.createElement( "values");
            var docVal = this.parsedNode.ownerDocument.createElement( "value");
            docVals.appendChild(docVal);
            docVal.appendChild(this.parsedNode.ownerDocument.createTextNode( form.attributes.ConditionDoc.value));
            var docNode = facilis.parsers.ParseInUtils.getSubNode(value, "documentation");
            if(docNode){
                docNode.appendChild(docVals);
            }
        }

        return value;
    }

    facilis.parsers.input.Subflow = facilis.promote(Subflow, "ActivityElement");
    
}());

(function() {

    function Back() {
        this.Activity_constructor();
        this.parseFunctions.push(this.getProcess);
        this.parseFunctions.push(this.getBoundary);
        this.parseFunctions.push(this.getLanes);
        this.parseFunctions.push(this.parseBack);
        this.parseFunctions.push(this.getProcesClasses);
    }
    
    var element = facilis.extend(Back, facilis.parsers.input.Activity);

    element.getLanes=function() {
        for (var i = 0; i < this.toParseNode.children.length; i++ ) {
            if (this.toParseNode.children[i].nodeName=="Lanes") {
                this.parseLanes(this.toParseNode.children[i]);
            }
        }
    }

    element.getProcess=function() {
        var process = this.toParseNode.getAttribute("Process");
        if (process != null) {
            this.parsedNode.setAttribute("process", process);
        }
    }

    element.getBoundary=function() {
        var BoundaryVisible = this.toParseNode.attributes.BoundaryVisible;
        if (BoundaryVisible != null) {
            this.setParsedSubNodeValue("boundaryvisible", BoundaryVisible);
        }else {
            this.setParsedSubNodeValue("boundaryvisible", "true");
        }
    }

    element.parseLanes=function(Lanes ) {
        var pin = new facilis.parsers.ParserIn();
        var subElements = this.getSubElements();

        for (var i=0; i < Lanes.children.length;i++ ) {
            var p = pin.getElementParser("swimlane");
            p.setParsedNode(facilis.ElementAttributeController.getInstance().getElementAttributes("swimlane"));
            var lane = p.parse(Lanes.children[i]);
            subElements.appendChild(lane);
        }
    }

    element.parseBack=function() {
        if(this.toParseNode && this.toParseNode.parentNode && this.toParseNode.parentNode.parentNode){
            var toParseXML = this.toParseNode.parentNode.parentNode;
            var bpd = facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "bpd");
            if (bpd) {
                facilis.parsers.ParseInUtils.setSubNodeValue(bpd, "id", toParseXML.attributes.Id.value);
                facilis.parsers.ParseInUtils.setSubNodeValue(bpd, "name",toParseXML.attributes.Name.value);
                facilis.parsers.ParseInUtils.setSubNodeValue(bpd, "language", toParseXML.attributes.Language.value);

                var RedefinableHeader = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "RedefinableHeader");
                if (RedefinableHeader) {
                    facilis.parsers.ParseInUtils.setSubNodeValue(bpd, "version", RedefinableHeader.attributes.Version.value);
                    facilis.parsers.ParseInUtils.setSubNodeValue(bpd, "author", RedefinableHeader.attributes.Author.value);
                }

                //facilis.parsers.ParseInUtils.setSubNodeValue(bpd, "querylanguage",querylanguage);
                //facilis.parsers.ParseInUtils.setSubNodeValue(bpd, "documentation",documentation);

                var Created = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "Created");
                if (Created) {
                    facilis.parsers.ParseInUtils.setSubNodeValue(bpd, "creationdate",Created.attributes.CreationDate.value);
                }
                var ModificationDate = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "ModificationDate");
                if (ModificationDate) {
                    facilis.parsers.ParseInUtils.setSubNodeValue(bpd, "modificationdate",ModificationDate.attributes.Date.value);
                }
            }
            var process = facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "process");
            if (process) {
                var processtype = facilis.parsers.ParseInUtils.getSubNodeValue(process, "processtype");
                var performers = facilis.parsers.ParseInUtils.getSubNode(process, "performers");
                var properties = facilis.parsers.ParseInUtils.getSubNode(process, "properties");

                facilis.parsers.ParseInUtils.setSubNodeValue(process, "processtype", toParseXML.attributes.ProcessType.value);

                var Performers = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "Performers");
                if (Performers) {
                    parsePerformers(Performers, performers);
                }
                var Properties = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "Properties");
                if (Properties) {
                    parsePropertiesNode(Properties, properties);
                }

            }
        }
    }


    element.parsePerformers=function(Performers, performers) {
        var data = this.getData(performers);
        var values = this.parsedNode.ownerDocument.createElement( "values");
        if (Performers) {
            for (var i = 0; i < Performers.children.length; i++ ) {
                var value = data.cloneNode(true);
                value.nodeName = "value";
                values.appendChild(value);
                var Performer = Performers.children[i];
                facilis.parsers.ParseInUtils.getSubNode(value, "perfid").attributes.value = Performer.attributes.PerfId;
                facilis.parsers.ParseInUtils.getSubNode(value, "perfname").attributes.value = Performer.attributes.PerfName;
                var cond = facilis.parsers.ParseInUtils.getSubNode(value, "condition");
                if (cond) {
                    var condValues = this.parsedNode.ownerDocument.createElement( "values");
                    var condValue = this.parsedNode.ownerDocument.createElement( "value");
                    var condVal = this.parsedNode.ownerDocument.createTextNode( Performer.attributes.ProElePerfEvalCond);
                    condValue.appendChild(condVal);
                    condValues.appendChild(condValue);
                    cond.appendChild(condValues);
                }
            }
            performers.appendChild(values);
        }
    }


    element.getProcesClasses=function() {
        var proEvents = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "ApiaProEvents");
        if (proEvents) {
            var classes = facilis.parsers.ParseInUtils.getSubNode(parsedNode, "bussinessclasses");
            parseEvents(proEvents,classes);
        }
    }
    
    facilis.parsers.input.Back = facilis.promote(Back, "Activity");
    
}());


(function() {

    function Event() {
        this.Activity_constructor();
        this.parseFunctions.push(this.getAttached);
        this.parseFunctions.push(this.getEvent);
        this.parseFunctions.push(this.getTrigger);
        this.parseFunctions.push(this.getTriggerElement);
    }
    
    var element = facilis.extend(Event, facilis.parsers.input.Activity);
    
    
    element.getEvent=function() {
        var name = this.toParseNode.getAttribute("name");
        var Event = (this.getToParseSubNode("BPMNEvent"))?this.getToParseSubNode("BPMNEvent"):this.getToParseSubNode("Event");
        var val= Event.firstElementChild.localName;
        var evtType = ((val=="StartEvent")?"startevent": (val=="IntermediateEvent")? "middleevent" : "endevent"  );
        this.parsedNode.setAttribute("name", evtType);
    }

    element.getTrigger=function() {
        var event = (this.getToParseSubNode("BPMNEvent"))?this.getToParseSubNode("BPMNEvent"):this.getToParseSubNode("Event");
        var eventType = (event.firstElementChild.getAttribute("Trigger"))?event.firstElementChild.getAttribute("Trigger"):"";
        if (event.firstElementChild.getAttribute("Result")) {
            eventType = event.firstElementChild.getAttribute("Result");
        }
        this.setParsedSubNodeValue("eventdetailtype", eventType);
    }

    element.getTriggerElement=function() {
        var TriggerMultiple = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "TriggerMultiple");
        var TriggerResultMessage = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "TriggerResultMessage");
        var TriggerTimer = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "TriggerTimer");
        var TriggerConditional = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "TriggerConditional");
        var TriggerResultSignal = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "TriggerResultSignal");
        var ResultError = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "ResultError");
        var TriggerResultCompensation = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "TriggerResultCompensation");
        if (TriggerMultiple) {
            this.parseMultipleTrigger(TriggerMultiple, facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "multiple"));
        }else if(TriggerResultMessage){
            this.parseMessageTrigger(TriggerResultMessage, facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "message"));
        }else if(TriggerTimer){
            this.parseTimerTrigger(TriggerTimer, facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "timer"));
        }else if(TriggerConditional){
            this.parseConditionalTrigger(TriggerConditional, facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "conditional"));
        }else if(TriggerResultSignal){
            this.parseConditionalTrigger(TriggerResultSignal, facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "signal"));
        }else if(ResultError){
            this.parseErrorTrigger(ResultError, facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "error"));
        }else if(TriggerResultCompensation){
            this.parseCompensationTrigger(TriggerResultCompensation, facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "compensation"));
        }
    }

    element.getAttached=function() {
        var IntermediateEvent = this.getToParseSubNode("IntermediateEvent");
        if (IntermediateEvent && (IntermediateEvent.getAttribute("IsAttached") == "true" || IntermediateEvent.getAttribute("Target"))) {
            this.parsedNode.setAttribute("target", IntermediateEvent.getAttribute("Target"));
            this.parsedNode.setAttribute("isattached", "true");
        }else if (IntermediateEvent) {
            this.parsedNode.firstElementChild.firstElementChild.setAttribute("value", "FALSE");
        }
    }



    element.parseMessageTrigger=function(TriggerResultMessage, trigger) {
        var WebServiceThrow;
        var WebServiceMapping;
        if (TriggerResultMessage) {
            facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "name", TriggerResultMessage.getAttribute("Name"));
            facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "implementation", this.toParseNode.getAttribute("Implementation"));
            if (trigger && this.parsedNode.getAttribute("name") == "middleevent" ) {
                trigger.setAttribute("disabled", "false");
                //WebServiceThrow = facilis.parsers.ParseInUtils.getSubNode(TriggerResultMessage, "WebServiceThrow");
                var messagethrow = facilis.parsers.ParseInUtils.getSubNode(trigger, "outmessageref");
                var messagecatch = facilis.parsers.ParseInUtils.getSubNode(trigger, "inmessageref");
                WebServiceMapping = facilis.parsers.ParseInUtils.getSubNode(TriggerResultMessage, "WebServiceMapping");
                if (WebServiceMapping) {
                    if(messagethrow){
                        messagethrow.setAttribute("disabled", "true");
                    }
                    parseWebServiceCatchNode(WebServiceMapping, messagecatch);
                    facilis.parsers.ParseInUtils.setSubNodeValue(trigger,"catchthrow", "CATCH");
                }else {
                    if(messagecatch){
                        messagecatch.setAttribute("disabled", "true");
                    }
                    facilis.parsers.ParseInUtils.setSubNodeValue(trigger,"catchthrow", "THROW");
                    parseWebServiceThrowNode(null, messagethrow);
                }
                if (TriggerResultMessage.getAttribute("CatchThrow")) {
                    facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "catchthrow", (TriggerResultMessage.getAttribute("CatchThrow")+"").toUpperCase());
                }
            }else if (!trigger && this.parsedNode.getAttribute("name") == "middleevent" ) {
                facilis.parsers.ParseInUtils.setSubNodeValue(this.parsedNode, "catchthrow", (TriggerResultMessage.getAttribute("CatchThrow")+"").toUpperCase());
            }else if (this.parsedNode.getAttribute("name") == "endevent") {
                WebServiceThrow = facilis.parsers.ParseInUtils.getSubNode(TriggerResultMessage, "WebServiceThrow");
                parseWebServiceThrowNode(null, trigger);
            }else {
                WebServiceMapping = facilis.parsers.ParseInUtils.getSubNode(TriggerResultMessage, "WebServiceMapping");
                //var msgcatch = facilis.parsers.ParseInUtils.getSubNode(trigger, "message");
                if (WebServiceMapping) {
                    parseWebServiceCatchNode(WebServiceMapping, trigger);
                }
            }

        }
    }

    element.parseTimerTrigger=function(TriggerTimer, trigger) {
        if (TriggerTimer) {
            var timeDate = TriggerTimer.getAttribute("TimeDate");
            var endDate = TriggerTimer.getAttribute("EndDate");
            facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "initdate", timeDate);
            facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "enddate", endDate);

            var timerattribute = facilis.parsers.ParseInUtils.getSubNode(trigger, "timerattribute");
            if (timerattribute && timerattribute.firstElementChild && timerattribute.firstElementChild.firstElementChild) {
                timerattribute.firstElementChild.firstElementChild.setAttribute("value", TriggerTimer.getAttribute("TimerAttName"));
                facilis.parsers.ParseInUtils.setSubNodeValue(timerattribute, "name", TriggerTimer.getAttribute("TimerAttName"));
                facilis.parsers.ParseInUtils.setSubNodeValue(timerattribute, "id", TriggerTimer.getAttribute("TimerAttId"));
                timerattribute.setAttribute("value", TriggerTimer.getAttribute("TimerAttName"));
                facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "timerattributetype", TriggerTimer.getAttribute("TimerAttType"));
            }
            facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "value", TriggerTimer.getAttribute("TimeCycle"));
            facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "unit", TriggerTimer.getAttribute("TimeUnit"));
        }
    }

    element.parseConditionalTrigger=function(TriggerConditional, trigger) {
        if (TriggerConditional) {
            facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "name", TriggerConditional.getAttribute("Name"));
            var Expression = facilis.parsers.ParseInUtils.getSubNode(TriggerConditional, "Expression");
            if (Expression) {
                facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "expressionbody", Expression.firstElementChild.nodeValue);
            }
        }
    }

    element.parseSignalTrigger=function(TriggerResultSignal, trigger) {
        if (TriggerResultSignal) {
            facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "name", TriggerResultSignal.getAttribute("Name"));
        }
    }

    element.parseMultipleTrigger=function(TriggerMultiple, trigger) {
        
        var message = facilis.parsers.ParseInUtils.getSubNode(trigger, "multimessage");
        var timer = facilis.parsers.ParseInUtils.getSubNode(trigger, "multitimer");
        var values;
        if (TriggerMultiple) {
            for (var i = 0; i < TriggerMultiple.children.length; i++ ) {
                if (TriggerMultiple.children[i].nodeName == "TriggerResultMessage") {
                    parseMessageTrigger(TriggerMultiple.children[i], message);
                }else if (TriggerMultiple.children[i].nodeName == "TriggerTimer") {
                    parseTimerTrigger(TriggerMultiple.children[i], timer);
                }
            }
        }
    }

    element.parseErrorTrigger=function(ResultError, trigger) {
        if (ResultError) {
            facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "errorcode", ResultError.getAttribute("ErrorCode"));
        }
    }

    element.parseCompensationTrigger=function(TriggerResultCompensation, trigger) {
        if (TriggerResultCompensation) {
            var activitytype = TriggerResultCompensation.getAttribute("ActivityType");
            facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "activitytype", activitytype);
            if(activitytype=="Task"){
                facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "activityreftask", TriggerResultCompensation.getAttribute("ActivityId"));
            }else {
                facilis.parsers.ParseInUtils.setSubNodeValue(trigger, "activityrefsubproc", TriggerResultCompensation.getAttribute("ActivityId"));
            }
        }
    }

    element.parseMultiCompensationTrigger=function(TriggerResultCompensation, trigger) {
        if (TriggerResultCompensation) {
            trigger = facilis.parsers.ParseInUtils.getSubNode(trigger, "activityref");
            var values = this.parsedNode.ownerDocument.createElement( "values");
            var valueStr = "<value value=\"" + TriggerResultCompensation.getAttribute("ActivityId") + "\"><level name=\"name\" value=\"" + TriggerResultCompensation.getAttribute("ActivityId") + "\" /><level name=\"type\" value=\"" + TriggerResultCompensation.getAttribute("ActivityType") + "\" /></value>"
            trigger.setAttribute("value", TriggerResultCompensation.getAttribute("ActivityId"));
            var value = facilis.parsers.ParseInUtils.getParsedNode(valueStr);
            values.appendChild(value);
            trigger.appendChild(values);
        }
    }
    

    facilis.parsers.input.Event = facilis.promote(Event, "Activity");
    
}());

(function() {

    function Task() {
        this.ActivityElement_constructor();
        this.parseFunctions.push(this.getType);
        this.parseFunctions.push(this.getFormsRef);
        //this.parseFunctions.push(this.getApiaTskPools);
        this.parseFunctions.push(this.getRoleRef);
        this.parseFunctions.push(this.getApiaTskEvents);
        this.parseFunctions.push(this.getApiaTskStates);
        this.parseFunctions.push(this.getTaskService);
        this.parseFunctions.push(this.getTaskUser);
        this.parseFunctions.push(this.getTaskSend);
        this.parseFunctions.push(this.getTaskReceive);
        this.parseFunctions.push(this.getTaskName);
        this.parseFunctions.push(this.getApiaHighlightComments);
        this.parseFunctions.push(this.getTaskSchedule);
        this.parseFunctions.push(this.getSkipCondition);
        this.parseFunctions.push(this.getProEleId);
    }
    
    var element = facilis.extend(Task, facilis.parsers.input.ActivityElement);

    element.getType=function () {
        var implementation = this.getToParseSubNode("Implementation");
        if (implementation && implementation.firstElementChild && implementation.firstElementChild.firstElementChild) {
            var taskType = implementation.firstElementChild.firstElementChild.localName;
            this.setParsedSubNodeValue("taskType", taskType.split("Task")[1]);
        }else {
            this.setParsedSubNodeValue("taskType", "None");
        }
    }

    element.getFormsRef=function () {
        var steps = this.getParsedSubNode("steps");
        if(steps){
            var FormsRef = this.getToParseSubNode("FormsRef");
            if (FormsRef && FormsRef.firstElementChild && FormsRef.firstElementChild.nodeName != "Step") {
                var FormsRefClone = this.parsedNode.ownerDocument.createElement( "FormsRef");
                var forms = new Array();
                for (var i = 0; i < FormsRef.children.length; i++ ) {
                    var stepId = FormsRef.children[i].getAttribute("ProEleFrmStepId");
                    var frmOrder = FormsRef.children[i].getAttribute("ProEleFrmOrder");
                    forms.push( {order:stepId, frmOrder:frmOrder, form:FormsRef.children[i].cloneNode(true)} );
                }
                //forms.sortOn("order", Array.NUMERIC);
                forms.sort(function(a, b) {
                    if (parseInt(a.order) == parseInt(b.order)) {
                        return parseInt(a.frmOrder)-parseInt(b.frmOrder);
                    }
                    return (parseInt(a.order) - parseInt(b.order));
                } );
                var actual = null;
				var acutalStep = 0;
                i = 0;
                for (i = 0; i < forms.length; i++ ) {
                    if (actual != forms[i].order) {
						
						//Agregar huecos de steps
						for (var j = acutalStep + 1; j < forms[i].order; j++) {
							FormsRefClone.appendChild(this.parsedNode.ownerDocument.createElement("Step"));
						}

						acutalStep = parseInt(forms[i].order);

						//Agregar step actual
						
                        actual = forms[i].order;
                        var Step = this.parsedNode.ownerDocument.createElement( "Step");
                        FormsRefClone.appendChild(Step);
                    }
                    Step.appendChild(forms[i].form);
                }
                if (FormsRefClone.children.length > 0) {
                    FormsRef = FormsRefClone;
                }
            }
            var data = this.getData(steps);
            var values = this.parsedNode.ownerDocument.createElement( "values");
            steps.appendChild(values);
            if (FormsRef) {
                for (var u = 0; u < FormsRef.children.length; u++ ) {
                    var value = parseStep(FormsRef.children[u], data);
                    values.appendChild(value);
                }
            }
        }
    }

    element.parseStep=function (step, data) {
		var i;
        var value = data.cloneNode(true);			
		var pForms;
		var eForms;
		for (i = 0; i < value.children.length; i++ ) {
			console.log( i + ": " + value.children[i].toString());
			if (value.children[i].getAttribute("Name") == "stepformse" || value.children[i].getAttribute("name") == "entityforms") {
				eForms =  value.children[i];
				console.log("stepformse en Task");
			} else if (value.children[i].getAttribute("Name") == "stepformsp"|| value.children[i].getAttribute("name") == "processforms") {
				pForms =  value.children[i];
				console.log("stepformsp en Task");
			}
		}
		//var pForms = value.children[1];
        //var pValues = this.parsedNode.ownerDocument.createElement( "values");
        pForms.appendChild(pValues);
        var eForms = value.children[2];
        var eValues = this.parsedNode.ownerDocument.createElement( "values");
        eForms.appendChild(eValues);
        value.nodeName = "value";
        for (var i = 0; i < step.children.length; i++ ) {
            var fValue;
            if (step.children[i].getAttribute("FrmType") == "E") {
                fValue = this.getData(eForms).cloneNode(true);
                eValues.appendChild(fValue);
            }else {
                fValue = this.getData(pForms).cloneNode(true);
                pValues.appendChild(fValue);
            }
            fValue.nodeName = "value";
            facilis.parsers.ParseInUtils.setSubNodeValue(fValue, "id", step.children[i].getAttribute("FrmId"));
            facilis.parsers.ParseInUtils.setSubNodeValue(fValue, "name", step.children[i].getAttribute("FrmName"));
            facilis.parsers.ParseInUtils.setSubNodeValue(fValue, "readonly", step.children[i].getAttribute("ProEleFrmReadOnly"));
            facilis.parsers.ParseInUtils.setSubNodeValue(fValue, "multiple", step.children[i].getAttribute("ProEleFrmMultiply"));
            if (step.children[i].getAttribute("ProEleFrmEvalCond")) {
                var condVals= this.parsedNode.ownerDocument.createElement( "values");
                var condVal = this.parsedNode.ownerDocument.createElement( "value");
                condVals.appendChild(condVal);
                condVal.appendChild(this.parsedNode.ownerDocument.createTextNode( step.children[i].getAttribute("ProEleFrmEvalCond")));
                var condNode = facilis.parsers.ParseInUtils.getSubNode(fValue, "condition");
                if(condNode){
                    condNode.appendChild(condVals);
                }
            }
            if (step.children[i].getAttribute("ConditionDoc")) {
                var docVals= this.parsedNode.ownerDocument.createElement( "values");
                var docVal = this.parsedNode.ownerDocument.createElement( "value");
                docVals.appendChild(docVal);
                docVal.appendChild(this.parsedNode.ownerDocument.createTextNode( step.children[i].getAttribute("ConditionDoc")));
                var docNode = facilis.parsers.ParseInUtils.getSubNode(fValue, "documentation");
                if(docNode){
                    docNode.appendChild(docVals);
                }
            }
        }
        return value;
    }

    element.getApiaTskPools=function () {
        var groups = this.getParsedSubNode("groups");
        var data = this.getData(groups);
        var ApiaTskPools = this.getToParseSubNode("ApiaTskPools");
        var values = this.parsedNode.ownerDocument.createElement("values");
        groups.appendChild(values);

        if (ApiaTskPools) {
            for (var u = 0; u < ApiaTskPools.children.length; u++ ) {
                var value = data.cloneNode(true);
                value.nodeName = "value";
                values.appendChild(value);
                facilis.parsers.ParseInUtils.getSubNode(value, "id").setAttribute("value",ApiaTskPools.children[u].getAttribute("PoolId"));
                facilis.parsers.ParseInUtils.getSubNode(value, "name").setAttribute("value",ApiaTskPools.children[u].getAttribute("PoolName"));
                if (ApiaTskPools.children[u].getAttribute("ProElePoolEvalCond")) {
                    var condVals= this.parsedNode.ownerDocument.createElement( "values");
                    var condVal = this.parsedNode.ownerDocument.createElement( "value");
                    condVals.appendChild(condVal);
                    condVal.appendChild(ApiaTskPools.children[u].firstElementChild.cloneNode(true));
                    facilis.parsers.ParseInUtils.getSubNode(value, "condition").appendChild(condVals);
                }
            }
        }
    }

    element.getApiaTskStates=function () {
        var taskstates = this.getParsedSubNode("taskstates");
        if(taskstates){
            var data = this.getData(taskstates);
            var ApiaTskStates = this.getToParseSubNode("ApiaTskStates");
            var values = this.parsedNode.ownerDocument.createElement( "values");
            if(ApiaTskStates){
                for (var i = 0; i < ApiaTskStates.children.length; i++ ) {
                    var value = data.cloneNode(true);
                    value.nodeName = "value";
                    var ApiaTskState = parseApiaTskState(ApiaTskStates.children[i],value);
                    values.appendChild(ApiaTskState);
                }
                taskstates.appendChild(values);
            }
        }
    }

    element.parseApiaTskState=function (ApiaTskState, value) {
        facilis.parsers.ParseInUtils.getSubNode(value, "evtid").setAttribute("value",ApiaTskState.getAttribute("EvtId"));
        facilis.parsers.ParseInUtils.getSubNode(value, "clsid").setAttribute("value",ApiaTskState.getAttribute("EntStaId"));
        facilis.parsers.ParseInUtils.getSubNode(value, "evtname").setAttribute("value",ApiaTskState.getAttribute("EvtName"));
        facilis.parsers.ParseInUtils.getSubNode(value, "clsname").setAttribute("value", ApiaTskState.getAttribute("StaName"));
        if (ApiaTskState.getAttribute("ProEleBusEntStaEvalCond") && ApiaTskState.getAttribute("ProEleBusEntStaEvalCond")!="") {
            var cond = ApiaTskState.getAttribute("ProEleBusEntStaEvalCond");
            var condVals= this.parsedNode.ownerDocument.createElement( "values");
            var condVal = this.parsedNode.ownerDocument.createElement( "value");
            condVals.appendChild(condVal);
            condVal.appendChild(this.parsedNode.ownerDocument.createTextNode( cond));
            var condNode = facilis.parsers.ParseInUtils.getSubNode(value, "condition");
            if(condNode){
                condNode.appendChild(condVals);
            }

        }
        if (ApiaTskState.getAttribute("ConditionDoc") && ApiaTskState.getAttribute("ConditionDoc")!="") {
            var doc = ApiaTskState.getAttribute("ConditionDoc");
            var docVals= this.parsedNode.ownerDocument.createElement( "values");
            var docVal = this.parsedNode.ownerDocument.createElement( "value");
            docVals.appendChild(docVal);
            docVal.appendChild(this.parsedNode.ownerDocument.createTextNode( doc));
            var docNode = facilis.parsers.ParseInUtils.getSubNode(value, "documentation");
            if(docNode){
                docNode.appendChild(docVals);
            }
        }

        return value;
    }

    element.getApiaTskEvents=function () {
        var bussinessclasses = this.getParsedSubNode("bussinessclasses");
        if (bussinessclasses) {
            var ApiaTskEvents = this.getToParseSubNode("ApiaEvents");
            parseEvents(ApiaTskEvents,bussinessclasses);
        }
    }

    element.getRoleRef=function () {
        var role = this.getParsedSubNode("role");
        var RoleRef = this.getToParseSubNode("RoleRef");

        if (RoleRef && role) {
            var values = this.parsedNode.ownerDocument.createElement( "values");
            var value = this.parsedNode.ownerDocument.createElement( "value");
            values.appendChild(value);
            role.appendChild(values);
            var name = this.parsedNode.ownerDocument.createElement( "name");
            var id = this.parsedNode.ownerDocument.createElement( "id");
            name.setAttribute("name", "name");
            id.setAttribute("name", "id");
            value.appendChild(id);
            value.appendChild(name);
            id.setAttribute("value", RoleRef.getAttribute("RoleId"));
            name.setAttribute("value", RoleRef.getAttribute("RoleName"));
            value.setAttribute("value", RoleRef.getAttribute("RoleName"));
            role.setAttribute("value", RoleRef.getAttribute("RoleName"));
        }
    }


    element.getValues=function (node) {
        for (var i = 0;i< node.children.length; i++ ) {
            if (node.children[i].nodeName=="values") {
                return node.children[i];
            }
        }
    }


    element.getTaskService=function () {
        var taskservice = this.getParsedSubNode("service");
        var TaskService = this.getToParseSubNode("TaskService");
        if (TaskService && taskservice) {

            var MessageIn = facilis.parsers.ParseInUtils.getSubNode(TaskService, "MessageIn");
            var MessageOut = facilis.parsers.ParseInUtils.getSubNode(TaskService, "MessageOut");

            var messagein = facilis.parsers.ParseInUtils.getSubNode(taskservice, "inmessageref");
            var messageout = facilis.parsers.ParseInUtils.getSubNode(taskservice, "outmessageref");

            getMessage(MessageIn, messagein);
            getMessage(MessageOut, messageout);

            var WebServiceMapping = facilis.parsers.ParseInUtils.getSubNode(TaskService, "WebServiceMapping");
            if (WebServiceMapping/*WebServiceCatchNode*/) {
                parseWebServiceCatchNode(WebServiceMapping, messagein);
            }

            parseWebServiceThrowNode(null, messageout);

        }
    }
    element.getTaskReceive=function () {
        var taskreceive = this.getParsedSubNode("receive");
        var TaskReceive = this.getToParseSubNode("TaskReceive");
        if (TaskReceive && taskreceive) {
            var message = facilis.parsers.ParseInUtils.getSubNode(taskreceive, "messageref");
            var Message = facilis.parsers.ParseInUtils.getSubNode(TaskReceive, "Message");

            //var WebServiceCatchNode = facilis.parsers.ParseInUtils.getSubNode(TaskService, "WebServiceCatch");
            var WebServiceMapping = facilis.parsers.ParseInUtils.getSubNode(TaskReceive, "WebServiceMapping");
            if (WebServiceMapping/*WebServiceCatchNode*/) {
                //parseWebServiceCatchNode(WebServiceCatchNode, messagein);
                parseWebServiceCatchNode(WebServiceMapping, message);
            }

            getMessage(Message, message);
            facilis.parsers.ParseInUtils.setSubNodeValue(taskreceive, "instantiate", TaskReceive.getAttribute("Instantiate"));
        }
    }
    element.getTaskSend=function () {
        var tasksend = this.getParsedSubNode("send");
        var TaskSend = this.getToParseSubNode("TaskSend");
        if (TaskSend && tasksend) {
            var message = facilis.parsers.ParseInUtils.getSubNode(tasksend, "messageref");
            var Message = facilis.parsers.ParseInUtils.getSubNode(TaskSend, "Message");

            var WebServiceMapping = facilis.parsers.ParseInUtils.getSubNode(TaskSend, "WebServiceMapping");
            if (WebServiceMapping/*WebServiceCatchNode*/) {
                parseWebServiceCatchNode(WebServiceMapping, message);
            }

            //var messageout = facilis.parsers.ParseInUtils.getSubNode(tasksend, "outmessageref");
            var messageout = facilis.parsers.ParseInUtils.getSubNode(tasksend, "messageref");
            parseWebServiceThrowNode(null, messageout);

            getMessage(Message, message);
            facilis.parsers.ParseInUtils.setSubNodeValue(tasksend, "instantiate", TaskSend.getAttribute("Instantiate"));
        }

    }
    element.getTaskUser=function () {
        var taskuser = this.getParsedSubNode("user");
        var TaskUser = this.getToParseSubNode("TaskUser");
        if (taskuser && TaskUser) {
            var MessageIn = facilis.parsers.ParseInUtils.getSubNode(TaskUser, "MessageIn");
            var MessageOut = facilis.parsers.ParseInUtils.getSubNode(TaskUser, "MessageOut");

            var messagein = facilis.parsers.ParseInUtils.getSubNode(taskuser, "inmessageref");
            var messageout = facilis.parsers.ParseInUtils.getSubNode(taskuser, "outmessageref");

            getMessage(MessageIn, messagein);
            getMessage(MessageOut, messageout);

            var WebServiceMapping = facilis.parsers.ParseInUtils.getSubNode(TaskUser, "WebServiceMapping");
            if (WebServiceMapping/*WebServiceCatchNode*/) {
                parseWebServiceCatchNode(WebServiceMapping, messagein);
            }

            parseWebServiceThrowNode(null, messageout);
        }
    }
    element.getTaskManual=function () {
        /*var taskmanual = this.getToParseSubNode("manual");
        if (taskmanual) {
            var TaskManual = this.parsedNode.ownerDocument.createElement( "TaskManual");
        }*/
    }


    element.getMessage=function (Message, message) {
        if(Message){
            facilis.parsers.ParseInUtils.setSubNodeValue(message, "name", Message.getAttribute("Name"));
            var properties = facilis.parsers.ParseInUtils.getSubNode(message, "properties");
            var Properties = facilis.parsers.ParseInUtils.getSubNode(Message , "Properties");
            parsePropertiesNode(Properties, properties);
        }
    }

    element.getTaskName=function () {
        facilis.parsers.ParseInUtils.setSubNodeValue(this.parsedNode, "name", this.toParseNode.getAttribute("Name"));
        facilis.parsers.ParseInUtils.setSubNodeValue(this.parsedNode, "nameChooser", this.toParseNode.getAttribute("Name"));
        TaskNode = this.getToParseSubNode("Task");
        if (TaskNode && TaskNode.getAttribute("TskName")) {
            //facilis.parsers.ParseInUtils.setSubNodeValue(this.parsedNode, "name", TaskNode.getAttribute("TskName"));
            var tsk_title = TaskNode.getAttribute("TskTitle") ? TaskNode.getAttribute("TskTitle") : TaskNode.getAttribute("TskName");
			var tsk_name = TaskNode.getAttribute("TskName");
			facilis.parsers.ParseInUtils.setSubNodeValue(parsedNode, "name", tsk_title);
			facilis.parsers.ParseInUtils.setSubNodeValue(parsedNode, "tname", tsk_name);

			facilis.parsers.ParseInUtils.setSubNodeValue(parsedNode, "nameChooser", TaskNode.getAttribute("TskName"));
			
			var values = "<values><value value=\""+TaskNode.getAttribute("TskName")+"\"><level name=\"id\" value=\"" + TaskNode.getAttribute("TskId") + "\" /><level name=\"name\" value=\"" + tsk_name + "\" /><level name=\"label\" value=\"" + tsk_title + "\" /></value></values>"
			var valuesNode = facilis.parsers.ParseInUtils.getParsedNode(values);
			var chooser = facilis.parsers.ParseInUtils.getSubNode(parsedNode, "nameChooser");
			chooser.getAttribute("value") = TaskNode.getAttribute("TskName");
			if (chooser) {
                chooser.setAttribute("value", TaskNode.getAttribute("TskName"));
                var oldValues=facilis.parsers.ParseInUtils.getSubNode(chooser, "values");
                if (oldValues) {
                    oldValues.removeNode();
                }
                chooser.appendChild(valuesNode);
            }
        }
    }

    element.getApiaHighlightComments=function () {
        var highlightcomments = this.getParsedSubNode("highlightcomments");
        if (TaskNode && highlightcomments) {
             highlightcomments.setAttribute("value", TaskNode.getAttribute("highlight_comments"));
        }
    }

    element.getTaskSchedule=function () {
        var scheduledTask = this.getParsedSubNode("scheduledTask");
        //var TASK_SCHEDULER = this.getToParseSubNode("TASK_SCHEDULER");
        var TASK_SCHEDULER = TaskNode;
        if (scheduledTask && TASK_SCHEDULER) {
            scheduledTask = scheduledTask.firstElementChild.firstElementChild;
            for (var i = 0; i < scheduledTask.children.length; i++ ) {
                if (scheduledTask.children[i].getAttribute("name")=="tsk_sch_id" && TASK_SCHEDULER.getAttribute("TskSchId")) {
                    scheduledTask.children[i].setAttribute("value",TASK_SCHEDULER.getAttribute("TskSchId"));
                }
                if (scheduledTask.children[i].getAttribute("name")=="asgn_type" && TASK_SCHEDULER.getAttribute("AsignType")) {
                    scheduledTask.children[i].setAttribute("value",TASK_SCHEDULER.getAttribute("AsignType"));
                }
                if (scheduledTask.children[i].getAttribute("name")=="active_tsk_id" && TASK_SCHEDULER.getAttribute("ActiveTskId")) {
                    scheduledTask.children[i].setAttribute("value",TASK_SCHEDULER.getAttribute("ActiveTskId"));
                }
                if (scheduledTask.children[i].getAttribute("name")=="active_prc_id" && TASK_SCHEDULER.getAttribute("ActivePrcId")) {
                    scheduledTask.children[i].setAttribute("value",TASK_SCHEDULER.getAttribute("ActivePrcId"));
                }
                if (scheduledTask.children[i].getAttribute("name")=="active_prc_name" && TASK_SCHEDULER.getAttribute("ActivePrcName")) {
                    scheduledTask.children[i].setAttribute("value",TASK_SCHEDULER.getAttribute("ActivePrcName"));
                }
            }
        }
    }

    element.getSkipCondition=function () {
        var conditionNode = this.getParsedSubNode("skipcondition");
        if (TaskNode.getAttribute("SkipTskCond")) {
            var values = this.parsedNode.ownerDocument.createElement( "values");
            var value = this.parsedNode.ownerDocument.createElement( "value");
            var skipCondition = TaskNode.getAttribute("SkipTskCond") + "";
            value.setAttribute("value", skipCondition);
            values.appendChild(value);
            value.appendChild(this.parsedNode.ownerDocument.createTextNode( skipCondition));
            conditionNode.appendChild(values);
            conditionNode.setAttribute("value", value.getAttribute("value"));
        }
    }

    element.getProEleId=function () {
        var proeleid = this.getParsedSubNode("proeleid");
        if (proeleid) {
            if(this.toParseNode.getAttribute("ProEleId")) {
                proeleid.setAttribute("value", this.toParseNode.getAttribute("ProEleId"));
            }else {
                proeleid.setAttribute("value", this.toParseNode.getAttribute("Id"));
            }
        }
    }
    
    facilis.parsers.input.Task = facilis.promote(Task, "ActivityElement");
    
}());


(function() {

    function WorkflowProcess() {
        this.Activity_constructor();
    }
     
    
    var element = facilis.extend(WorkflowProcess, facilis.parsers.input.Activity);

    
    element.startParse=function(){  
        this.getWorkflowProcess();
        this.getDocumentation();
        this.getProcesClasses();
    }
        
    element.getWorkflowProcess=function() {
        var toParseXML = facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "processref");
        if(toParseXML){
            var name = facilis.parsers.ParseInUtils.setSubNodeValue(toParseXML, "name", this.toParseNode.getAttribute("Name"));
            var performers = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "performers");
            var properties = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "properties");
            var assignments = facilis.parsers.ParseInUtils.getSubNode(toParseXML, "assignments");

            var Performers = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "Performers");
            var Properties = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "Properties");
            var Assignments = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "Assignments");

            this.parsePerformersNode(this.Performers,this.performers);
            this.parsePropertiesNode(this.Properties,this.properties);
            this.parseAssignmentsNode(this.Assignments, this.assignments);

        }
        var Participants = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "Participants");
        this.parseParticipants(Participants);

    }

    element.parseParticipants=function(Participants) {
        if (Participants) {
            for (var i = 0; i < Participants.children.length; i++ ) {
                var Participant=Participants.children[i]
                facilis.parsers.ParserIn.addParticipant(Participant.attributes.Id.value, Participant.attributes.Name.value);
            }
        }

    }

    element.getProcesClasses=function() {
        var proEvents = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "ApiaProEvents");
        if (proEvents) {
            var classes = facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "bussinessclasses");
            parseEvents(proEvents,classes);
        }
    }

    element.parseLaneEvents=function(proEvents) {
        if (proEvents) {
            var classes = facilis.parsers.ParseInUtils.getSubNode(this.parsedNode, "bussinessclasses");
            parseEvents(proEvents,classes);
        }
    }

    facilis.parsers.input.WorkflowProcess = facilis.promote(WorkflowProcess, "Activity");
    
}());



(function() {

    function Transition() {
        this.Line_constructor();
        
        this.parseFunctions.push(this.parseCondition);
        this.parseFunctions.push(this.parseType);
        this.parseFunctions.push(this.parseExecutionOrder);
    }
    
    var element = facilis.extend(Transition, facilis.parsers.input.Line);

    element.parseCondition=function() {
        var Condition = this.getToParseSubNode("Condition");
        if (Condition && Condition.getAttribute("Type")) {
            this.setParsedSubNodeValue("conditiontype", Condition.getAttribute("Type"));
        }
        var conditionNode = this.getParsedSubNode("conditionexpression");
        var Expression = facilis.parsers.ParseInUtils.getSubNode(Condition, "Expression");
        if (conditionNode && Expression && Expression.firstElementChild) {
            var values = this.parsedNode.ownerDocument.createElement( "values");
            var value = this.parsedNode.ownerDocument.createElement( "value");
            value.getAttribute("value") = Expression.firstElementChild.toString();
            value.appendChild(Expression.firstElementChild.cloneNode(true));
            values.appendChild(value);
            conditionNode.appendChild(values);
        }

        var docNode = this.getParsedSubNode("conditiondocumentation");
        var ConditionDoc = this.toParseNode.getAttribute("ConditionDoc");
        if (!ConditionDoc) {
            var obj = facilis.parsers.ParseInUtils.getSubNode(this.toParseNode, "Object");
            if (!obj) {
                obj = this.toParseNode;
            }
            for (var i = 0; i < obj.children.length; i++ ) {
                if (obj.children[i].localName=="Documentation" && obj.children[i].firstElementChild) {
                    ConditionDoc = obj.children[i].firstElementChild.nodeValue;
                    break;
                }
            }
        }
        if (docNode && ConditionDoc) {
            var docValues = getParsedNode("<values><value value=\"" + ConditionDoc + "\">" + ConditionDoc + "</value></values>");
            docNode.appendChild(docValues);
        }


    }

    element.parseType=function() {
        var type = this.getParsedSubNode("apiatype");
        if (type) {
            /*if(.getAttribute("LoopBack")=="true"){
                type.getAttribute("value") = "Loopback";
            }
            if (.getAttribute("TakeNext") == "true") {
                type.getAttribute("value") = "Wizard";
            }*/
            if(this.toParseNode.getAttribute("Type")=="L"){
                type.setAttribute("value","Loopback");
            }else if (this.toParseNode.getAttribute("Type") == "W") {
                type.setAttribute("value","Wizard");
            }else if (this.toParseNode.getAttribute("Type") == "N") {
                type.setAttribute("value","None");
            }
        }
    }

    element.parseExecutionOrder=function() {
        var executiontype = this.getParsedSubNode("executionorder");
        if (executiontype && this.toParseNode.getAttribute("ExecutionOrder")) {
            executiontype.getAttribute("value") = this.toParseNode.getAttribute("ExecutionOrder");

        }
    }
    
    facilis.parsers.input.Transition = facilis.promote(Transition, "Line");
    
}());


