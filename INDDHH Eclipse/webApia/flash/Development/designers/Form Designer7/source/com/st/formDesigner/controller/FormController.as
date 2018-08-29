



import com.st.formDesigner.model.FormModel;
import com.st.formDesigner.view.FormView;
import com.qlod.LoaderClass;


class com.st.formDesigner.controller.FormController{

	// Internal properties
	private var __model:FormModel;
	private var __view:FormView;
	
	private var xmlLoader:LoaderClass;
	private var def_XML:XML;	//xml-in definition
	
	
	function FormController(root:MovieClip){
		// Create an instance of the Model
		__model = new FormModel();
		// Create an instance of the View
		__view = new FormView(root,this,__model);
		
		xmlLoader = new LoaderClass();
		//xmlLoader.clear();
		xmlLoader.setMinSteps(3);
		
		// Reset yourself
		reset();
	};
	
	
	//Resets the Model by calling reset() on it
	public function reset():Void {
		__model.reset();
	};
	
	
	public function getFormDefinition():Void{
		var tmp = this;
			def_XML = new XML();
			def_XML.ignoreWhite = true;
			
		var xmlDef_listener = new Object();
			xmlDef_listener.onLoadStart = function(loaderObj){
				trace("\nLOADING DEF XML:" + loaderObj.getUrl());
			};
			xmlDef_listener.onLoadProgress = function(loaderObj){
				var p = loaderObj.getPercent();
				if(p.isNaN()){}else{/*trace("\nDEF LOADING:" + Math.round(p))*/;}
			};
			xmlDef_listener.onTimeout = function(loaderObj){
				//trace("\nDEF TIMEOUT");
			};
			xmlDef_listener.onLoadComplete = function(success,loaderObj){
				trace("\nDEF LOADED\n");
				//trace("onLoadComplete" + loaderObj.getTargetObj());
				//xmlProcess = new XmlProcessParser(tmpModel);
				//xmlProcess.parseProcess(loaderObj.getTargetObj());
				tmp.parseFormDefinition(loaderObj.getTargetObj());
			};
		xmlLoader.load(def_XML,_global.FORM_DEFINITION_XML, xmlDef_listener);
	};
	
	
	private function parseFormDefinition(oXML:XML):Void{
		var x:XML = oXML;
		var frm_events_array:Array = [];
		var frm_prop_array:Array = [];
		
		for(var e = 0; e < x.firstChild.childNodes.length;e++) {
			var currentNode = x.firstChild.childNodes[e];
			with (currentNode){
				//-------------------------------------------
				//FORM_EVENT [eventos del formulario]
				//-------------------------------------------
				if(nodeName == "EVENTS"){
					for(var j in childNodes ){
						//get EVENT element
						var p_events = new Object();
							p_events.event_id = childNodes[j].attributes.event_id;
							p_events.event_name = childNodes[j].attributes.event_name;
							p_events.class_id = childNodes[j].attributes.class_id;
							p_events.class_name = childNodes[j].attributes.class_name;
							p_events.bnd_id = childNodes[j].attributes.bnd_id;
							p_events.order= childNodes[j].attributes.order;							
							p_events.binding = new Array();
							
						for(var h in childNodes[j].childNodes){
							//get BINDINGS elements
							var p_bind = new Object();
								p_bind.param_id = childNodes[j].childNodes[h].attributes.param_id;
								p_bind.param_name = childNodes[j].childNodes[h].attributes.param_name;
								p_bind.param_type = childNodes[j].childNodes[h].attributes.param_type;
								p_bind.att_id = childNodes[j].childNodes[h].attributes.att_id;
								p_bind.att_name = childNodes[j].childNodes[h].attributes.att_name;
								p_bind.att_type = childNodes[j].childNodes[h].attributes.att_type;
								p_bind.value = childNodes[j].childNodes[h].firstChild.nodeValue;
							p_events.binding.push(p_bind);
						}
						frm_events_array.push(p_events);
						}
					frm_events_array.sortOn("order");
				}
				
				
				//-------------------------------------------
				//FORM_PROPERTY [propiedades del formulario]
				//-------------------------------------------
				if(nodeName == "FORM_PROPERTY"){
					//<FORM_PROPERTY prpId="3" type="N" value="3"/>
					var frm_prpObj = new Object();
						frm_prpObj.prpId = parseInt(attributes.prpId);
						frm_prpObj.type = attributes.type;
						frm_prpObj.value =attributes.value;
					//myXMLSocket.send (">>> prop id: "+ frm_prpObj.prpId + "\n");
					frm_prop_array.push(frm_prpObj);
				}
				//------------------------------------
				//FORM_FIELD [elementos del formulario]
				//------------------------------------
				if(nodeName == "FORM_FIELD"){
					if(attributes.fieldType == "14"){
						////////////////////
						//GRID ELEMENT
						///////////////////
						var grid_field:Object = this.getFORM_FIELD(x.firstChild.childNodes[e]);
						var grid_childrenElementsColl:Array = new Array();
						for(var w=0; w < x.firstChild.childNodes[e].childNodes.length; w++){
							var currNode:XMLNode = x.firstChild.childNodes[e].childNodes[w];
							if(currNode.nodeName == "FORM_FIELD_CHILD"){
								var currEle:Object = this.getFORM_FIELD(currNode);
								grid_childrenElementsColl.push(currEle);
							}							
						}
						grid_childrenElementsColl.sortOn("posGrid_x",Array.NUMERIC);
						this.addFormGridElement(
								grid_field.fieldId,
								grid_field.fieldLabel,
								grid_field.fieldType,
								grid_field.attId,
								grid_field.attName,
								grid_field.posGrid_x,
								grid_field.posGrid_y,
								grid_field.prp_Array,
								grid_field.evt_Array,								
								grid_childrenElementsColl);
						
					}else{
						////////////////////////////////
						//ALL OTHER ELEMENTS
						////////////////////////////////
					if(attributes.fieldType == "1"){
						var field:Object = this.getFORM_FIELD(x.firstChild.childNodes[e]);
						this.addFormInputElement(field.fieldId,
											field.fieldLabel,
											field.fieldType,
											field.attId,
											field.attName,
											field.posGrid_x,
											field.posGrid_y,
											field.prp_Array,
											field.evt_Array,
											field.bnd_Array
											);
					}else{
						var field:Object = this.getFORM_FIELD(x.firstChild.childNodes[e]);
						this.addFormElement(field.fieldId,
											field.fieldLabel,
											field.fieldType,
											field.attId,
											field.attName,
											field.posGrid_x,
											field.posGrid_y,
											field.prp_Array,
											field.evt_Array
											);
						}
					}
				}
			}
			//add FRM EVENTS array
			//this.scrollPane.content["frm"].evt_Array = frm_events_array;
			this.setFormEvents(frm_events_array);
			
			//add FRM PROPERTY array
			//this.scrollPane.content["frm"].prp_Array = frm_prop_array;
			this.setFormProperties(frm_prop_array);
			

		}
		
		
		flashIsReady();
		
	};
	
	
	public function getFORM_FIELD(oXMLNode:XMLNode):Object{
		var formFieldAttributes:Object = {};
		var properties_Array:Array = new Array();
		var events_Array:Array = new Array();
		var entbnd_Array:Array=new Array();
		
		formFieldAttributes.fieldId = parseInt(oXMLNode.attributes.fieldId);
		formFieldAttributes.fieldLabel = oXMLNode.attributes.fieldLabel;
		formFieldAttributes.fieldType = parseInt(oXMLNode.attributes.fieldType);
		if(!(oXMLNode.attributes.attId=="null" ||
			oXMLNode.attributes.attId=="undefined"||
			oXMLNode.attributes.attId==""||
			oXMLNode.attributes.attId==undefined)){
		formFieldAttributes.attId = parseInt(oXMLNode.attributes.attId);
		}else{
			formFieldAttributes.attId=undefined;
		}
		formFieldAttributes.attName = oXMLNode.attributes.attName;
		formFieldAttributes.posGrid_x = parseInt(oXMLNode.attributes.x);
		formFieldAttributes.posGrid_y = parseInt(oXMLNode.attributes.y);
		
		
		//CHILD ELEMENTS OF FORM_FIELD
		for(var d=0;d < oXMLNode.childNodes.length;d++){

			if(oXMLNode.childNodes[d].nodeName == "ENTITY_BINDING"){
				var p_bind = new Object();
				p_bind.entity_id = oXMLNode.childNodes[d].attributes.entityId;
				p_bind.mapping = new Array();
				for(var j in oXMLNode.childNodes[d].childNodes){
					//get BINDINGS elements
					var p_mapping = new Object();
					p_mapping.ent_att = oXMLNode.childNodes[d].childNodes[j].attributes.ent_att;
					p_mapping.frm_att = oXMLNode.childNodes[d].childNodes[j].attributes.frm_att;
					p_mapping.att_name = oXMLNode.childNodes[d].childNodes[j].attributes.att_name;
					p_bind.mapping.push(p_mapping);
				}
				entbnd_Array.push(p_bind);
			}
		
			if(oXMLNode.childNodes[d].nodeName == "PROPERTY"){
				//GET FORM_FIELD PROPERTY ELEMENT
				var propertyNode = oXMLNode.childNodes[d];
				var prpObj = new Object();
					prpObj.prpId = parseInt(propertyNode.attributes.prpId);
					prpObj.value = propertyNode.attributes.value;
					prpObj.type = propertyNode.attributes.type;
					properties_Array.push(prpObj);
			}
			
			// <EVENTS> TAG
			if(oXMLNode.childNodes[d].nodeName == "EVENTS"){
				var thisNode = oXMLNode.childNodes[d];
				for(var j in thisNode.childNodes){
					//get EVENT element
					var p_events = new Object();
						p_events.event_id = thisNode.childNodes[j].attributes.event_id;
						p_events.event_name = thisNode.childNodes[j].attributes.event_name;
						p_events.class_id = thisNode.childNodes[j].attributes.class_id;
						p_events.class_name = thisNode.childNodes[j].attributes.class_name;
						p_events.bnd_id = thisNode.childNodes[j].attributes.bnd_id;
						p_events.order= thisNode.childNodes[j].attributes.order;						
						p_events.binding = new Array();
						
					for(var h in thisNode.childNodes[j].childNodes){
						//get BINDINGS elements
						var p_bind = new Object();
							p_bind.param_id = thisNode.childNodes[j].childNodes[h].attributes.param_id;
							p_bind.param_name = thisNode.childNodes[j].childNodes[h].attributes.param_name;
							p_bind.param_type = thisNode.childNodes[j].childNodes[h].attributes.param_type;
							p_bind.att_id = thisNode.childNodes[j].childNodes[h].attributes.att_id;
							p_bind.att_name = thisNode.childNodes[j].childNodes[h].attributes.att_name;
							p_bind.att_type = thisNode.childNodes[j].childNodes[h].attributes.att_type;
							p_bind.value = thisNode.childNodes[j].childNodes[h].firstChild.nodeValue;
						
						p_events.binding.push(p_bind);
					}
					events_Array.push(p_events);
				}
				events_Array.sortOn("order");
			}
		}
		
		formFieldAttributes.evt_Array = events_Array;
		formFieldAttributes.prp_Array = properties_Array;
		formFieldAttributes.bnd_Array = entbnd_Array;
		
		return formFieldAttributes;
	};

	function flashIsReady(){
		_global.isLoaded=true;
		fscommand("isReady");
	};
	
	////////////////////////////////////////////////////////////////////
	// 
	////////////////////////////////////////////////////////////////////
	
	public function addFormInputElement(fieldId:Number,fieldLabel:String,fieldType:Number,attId:Number,attName:String,gridX:Number,gridY:Number,prp_Array:Array,evt_Array:Array,bnd_Array:Array):Void{
		__model.addInputElement(fieldId,
						   fieldLabel,
						   fieldType,
						   attId,
						   attName,
						   gridX,
						   gridY,
						   prp_Array,
						   evt_Array,
						   bnd_Array
						   );
		for(var w=0;w<prp_Array.length;w++){
			var id:Number = prp_Array[w].prpId;
			var type:String = prp_Array[w].type;
			var value:String = prp_Array[w].value;
			 __model.setElementProperty(fieldId,id,type,value);
		}
	}
	public function addFormElement(fieldId:Number,fieldLabel:String,fieldType:Number,attId:Number,attName:String,gridX:Number,gridY:Number,prp_Array:Array,evt_Array:Array):Void{
		__model.addElement(fieldId,
						   fieldLabel,
						   fieldType,
						   attId,
						   attName,
						   gridX,
						   gridY,
						   prp_Array,
						   evt_Array
						   );
		/////////////////////////////////////////
		//init element properties
		/////////////////////////////////////////
		for(var w=0;w<prp_Array.length;w++){
			var id:Number = prp_Array[w].prpId;
			var type:String = prp_Array[w].type;
			var value:String = prp_Array[w].value;
			 __model.setElementProperty(fieldId,id,type,value);
		}
		
		
	};
	
	public function addFormGridElement(fieldId:Number,fieldLabel:String,fieldType:Number,attId:Number,attName:String,gridX:Number,gridY:Number,prp_Array:Array,evt_Array:Array,gridChildren:Array):Void{
		__model.addGridElement(fieldId,
						   fieldLabel,
						   fieldType,
						   attId,
						   attName,
						   gridX,
						   gridY,
						   prp_Array,
						   evt_Array,
						   gridChildren);
		
		
		/////////////////////////////////////////
		//init element properties
		/////////////////////////////////////////
		
		for(var f=0;f<gridChildren.length;f++){
			for(var w=0;w<gridChildren[f].prp_Array.length;w++){
				var id:Number = gridChildren[f].prp_Array[w].prpId;
				var type:String = gridChildren[f].prp_Array[w].type;
				var value:String = gridChildren[f].prp_Array[w].value;
				// __model.setElementProperty(fieldId,id,type,value);
				  __model.setGridColElementProperty(fieldId,gridChildren[f].fieldId,id,type,value);
			}
		}
	};
	
	
	public function addColToGrid(gridFieldId:Number,fieldType:Number){
		__model.addColToGridElement(gridFieldId,fieldType)
	};
	public function removeColFromGrid(gridFieldId:Number){
		//__model.removeColToGridElement(gridFieldId)
	};
	
	public function setElementAttribute(fieldId:Number,attId:Number,attLabel:String,attName:String){
		__model.setAttribute(fieldId,attId,attLabel,attName);
	};
	
	public function setColAttribute(fieldId:Number,attId:Number,attLabel:String,attName:String,gridId:Number){
		__model.setColAttribute(gridId,fieldId,attId,attLabel,attName);
	};
	
	public function updateElementEvents(fieldId:Number,evtArr:Array){
		__model.setElementEvts(fieldId,evtArr);
	};

	public function updateEntityBinds(fieldId:Number,entBndArr:Array){
		__model.setEntityBinds(fieldId,entBndArr);
	};
	
	public function setFormProperties(prpArray:Array){
		__model.setFormProperties(prpArray);
	};

	public function getFormProperties(prpArray:Array){
		__model.setFormProperties(prpArray);
	};
	
	public function setFormEvents(frmEvtsArray:Array){
		__model.setFormEvts(frmEvtsArray);
	};
	
	public function updateGridElementEvents(gridFieldId:Number,fieldId:Number,evtArr:Array){
		__model.setGridElementEvts(gridFieldId,fieldId,evtArr);
	};
	
	
	
	

	////////////////////////////////////////////////////////////////
	///	OUTPUT XML
	////////////////////////////////////////////////////////////////
	function getOutputXML():XML{
		var myXML = new XML();
			myXML.ignoreWhite = true;
			myXML.xmlDecl="<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>";
			//myXML.docTypeDecl = "<!DOCTYPE PROCESS_DEFINITION SYSTEM \"\\stsdesa01\Documentacion\ST\DOGMA\XML\process\process.dtd\">";
		var FORM_LAYOUT = myXML.createElement("FORM_LAYOUT");
		
		var formElements:Object = __model.getAllElements();
		//ITERATE FORM ELEMENTS
		 for(var e in formElements) {
			var fieldId = formElements[e].fieldId;
			var fieldLabel = formElements[e].fieldLabel;
			var fieldType = formElements[e].fieldType;
			var attId = formElements[e].attId;
			var attName = formElements[e].attName;
			var gridX = formElements[e].gridX;
			var gridY = formElements[e].gridY;
			var prp_Array = formElements[e].prp_Array;
			var evt_Array = formElements[e].evt_Array;
			var bnd_Array = formElements[e].bnd_Array;
			
			var FORM_FIELD = myXML.createElement("FORM_FIELD");
				FORM_FIELD.attributes.fieldId = fieldId;
				FORM_FIELD.attributes.fieldLabel = fieldLabel;
				FORM_FIELD.attributes.fieldType = fieldType;
				FORM_FIELD.attributes.x = gridX;
				FORM_FIELD.attributes.y = gridY;
				if(attId!=null && attId!=undefined && attId!=""){
					FORM_FIELD.attributes.attId = attId;
				}
				FORM_FIELD.attributes.attName = attName;

				
//				if(fieldType != 5 && fieldType != 7 && fieldType != 8){
				
					//all elements except label,button,subtitle can have att
					
				
				
				if(fieldType==1){
					for(var g=0;g<bnd_Array.length;g++){
						var ENTITY_BINDING = myXML.createElement("ENTITY_BINDING");
						ENTITY_BINDING.attributes.entityId=bnd_Array[g].entity_id;
						if(bnd_Array[g].mapping.length>0){
						for(var e=0;e < bnd_Array[g].mapping.length;e++){
							var MAPPING = myXML.createElement("MAPPING");
								MAPPING.attributes.ent_att = bnd_Array[g].mapping[e].ent_att;
								MAPPING.attributes.frm_att = bnd_Array[g].mapping[e].frm_att;
								MAPPING.attributes.att_name = bnd_Array[g].mapping[e].att_name;
								ENTITY_BINDING.appendChild(MAPPING);
						}
						FORM_FIELD.appendChild(ENTITY_BINDING);
						}
					}
				}
				
				if(fieldType==14){
					//GET ELEMENT GRIDs CHILDREN ELEMENTS
					var children_Array = formElements[e].children_Array;
					
					trace("\n\n" + children_Array.length)

					for(var c=0;c<children_Array.length;c++){
						
						var FORM_FIELD_CHILD = myXML.createElement("FORM_FIELD_CHILD");
							FORM_FIELD_CHILD.attributes.fieldId = children_Array[c].fieldId;
							FORM_FIELD_CHILD.attributes.fieldLabel = children_Array[c].fieldLabel;
							FORM_FIELD_CHILD.attributes.fieldType = children_Array[c].fieldType;
							FORM_FIELD_CHILD.attributes.x = children_Array[c].posGrid_x;
							FORM_FIELD_CHILD.attributes.y = children_Array[c].posGrid_y;
							if(!(children_Array[c].attId=="undefined"||children_Array[c].attId==undefined||children_Array[c].attId=="")){
								//all elements except label,button,subtitle can have att
								FORM_FIELD_CHILD.attributes.attId = children_Array[c].attId;
								FORM_FIELD_CHILD.attributes.attName = children_Array[c].attName;
								FORM_FIELD_CHILD.attributes.attLabel = children_Array[c].attLabel;
							//CHILDREN PROPERTIES
							}							
							if (children_Array[c].prp_Array.length > 0){
								for(var p=0; p<children_Array[c].prp_Array.length;p++){
									var c_pId = children_Array[c].prp_Array[p].prpId;
									var c_pValue = children_Array[c].prp_Array[p].value;
									var c_pType = children_Array[c].prp_Array[p].type;
									if(propertyHasChanged(c_pId,c_pValue)==true){
										var PROPERTY = myXML.createElement("PROPERTY");
											PROPERTY.attributes.prpId = c_pId;
											if(c_pValue=="true" ||c_pValue==true){
												PROPERTY.attributes.value = "T";
											}else{
												PROPERTY.attributes.value = c_pValue;
											}
											PROPERTY.attributes.type = c_pType;
										FORM_FIELD_CHILD.appendChild(PROPERTY);
									}
								}
							}
							//CHILDREN EVENTS
							trace("GRID COLUMN HAS EVENTS:" +children_Array[c].evt_Array.length )
							if (children_Array[c].evt_Array.length > 0){
								var CHILDREN_EVENTS = createEventsNode(children_Array[c].evt_Array);
									FORM_FIELD_CHILD.appendChild(CHILDREN_EVENTS);
							}
							//APPEND TO FORM_FIELD
							FORM_FIELD.appendChild(FORM_FIELD_CHILD);
					}
					
				}
				
				///////////////////////////////////////////////////
				//ELEMENT PROPS
				///////////////////////////////////////////////////
				//ROWSPAN
				var elementRowspan:Number = __model.getElementRowSpan(fieldId);
				if(elementRowspan != __model.getDefaultElementRowSpan(fieldType)){
					var ROWSPAN_PROP = myXML.createElement("PROPERTY");
						ROWSPAN_PROP.attributes.prpId = 9;
						ROWSPAN_PROP.attributes.type = "N";
						ROWSPAN_PROP.attributes.value = elementRowspan;
					FORM_FIELD.appendChild(ROWSPAN_PROP);
				}
				//COLSPAN
				var elementColspan:Number = __model.getElementColSpan(fieldId);
				if(elementColspan != __model.getDefaultElementColSpan(fieldType)){
					var COLSPAN_PROP = myXML.createElement("PROPERTY");
						COLSPAN_PROP.attributes.prpId = 8;
						COLSPAN_PROP.attributes.type = "N";
						COLSPAN_PROP.attributes.value = elementColspan;
					FORM_FIELD.appendChild(COLSPAN_PROP);
				}
				//All other Properties
				if (prp_Array.length > 0){
					for(var p=0; p<prp_Array.length;p++){
						var pId = prp_Array[p].prpId;
						var pValue = prp_Array[p].value;
						var pType = prp_Array[p].type;
						if(propertyHasChanged(pId,pValue)==true){
							var PROPERTY = myXML.createElement("PROPERTY");
								PROPERTY.attributes.prpId = pId;
								//PROPERTY.attributes.prpLabel =
								if((pValue=="true" || pValue==true) && pValue!=1){
								PROPERTY.attributes.value = "T";
								}else{
								PROPERTY.attributes.value =pValue;
								}
								PROPERTY.attributes.type = pType;
							FORM_FIELD.appendChild(PROPERTY);
						}
					}
				}
				////////////////////////////////////////////////////
				//ELEMENT EVENTS
				////////////////////////////////////////////////////
				if (evt_Array.length > 0){
					var EVENTS = createEventsNode(evt_Array);
					FORM_FIELD.appendChild(EVENTS);
				}
					
				//APPENND ELEMENT
				FORM_LAYOUT.appendChild(FORM_FIELD)
		 }
		
		//------------------------------------------------
		//SET DOCUMENT PROPERTIES AND EVENTS---------------
		//--------------------------------------------------
		 var FORM_EVENTS = createEventsNode(__model.getAllFormEvents());
		 var FORM_PROPERTIES=createPropertiesNode(__model.getFormProperties());
		 	FORM_LAYOUT.appendChild(FORM_PROPERTIES);
			FORM_LAYOUT.appendChild(FORM_EVENTS);
		 /////////////////////////////////////////////////////////
		 myXML.appendChild(FORM_LAYOUT)
		 return myXML;
	};
	
	
	
	//////////////////////////////////////////////////////////////////
	// OUTPUT TEMP FUNCTIONS//////////////////////////////////////////
	//////////////////////////////////////////////////////////////////
	function createEventsNode(evt_Array:Array):XMLNode{
		var myXML = new XML();
		var EVENTS = myXML.createElement("EVENTS");
		for(var e=0;e < evt_Array.length;e++){
			var EVENT = myXML.createElement("EVENT");
				EVENT.attributes.event_id = evt_Array[e].event_id;
				EVENT.attributes.event_name = evt_Array[e].event_name;
				EVENT.attributes.order = e;
				EVENT.attributes.class_id = evt_Array[e].class_id;
				EVENT.attributes.class_name = evt_Array[e].class_name;
				
				var p_bndID = evt_Array[e].bnd_id;
				
				if(p_bndID){EVENT.attributes.bnd_id = p_bndID;}
				
			var bdng:Array = evt_Array[e].binding;
			
			trace("XML NODE HAS BINDINGS:")
			
			if(bdng.length > 0){
				for(var w=0;w<bdng.length;w++){
					var BINDING = myXML.createElement("BINDING");
						BINDING.attributes.param_id = bdng[w].param_id;
						BINDING.attributes.param_name = bdng[w].param_name;
						BINDING.attributes.param_type = bdng[w].param_type;
						
						var attname = bdng[w].att_name;
						if(!(attname=="" || attname==undefined || attname=="undefined")){
							BINDING.attributes.att_id = bdng[w].att_id;
							BINDING.attributes.att_name = bdng[w].att_name;
							var type:String = bdng[w].att_type;
							BINDING.attributes.att_type=type.charAt(0);
						}//else{
							var BINDING_value = myXML.createTextNode(bdng[w].value);
							BINDING.appendChild(BINDING_value);
					//	}
						EVENT.appendChild(BINDING);
				}
			}
			EVENTS.appendChild(EVENT);
		}
		return EVENTS;
	};

	function createPropertiesNode(prop_Array:Array):XMLNode{
		var myXML = new XML();
		for(var e=0;e < prop_Array.length;e++){
			if(prop_Array[e].value==true || prop_Array[e].value=="true" || prop_Array[e].value=="T"){
			var FORM_PROPERTY = myXML.createElement("FORM_PROPERTY");
				FORM_PROPERTY.attributes.type = prop_Array[e].type;
				FORM_PROPERTY.attributes.value ="T";
				FORM_PROPERTY.attributes.prpId = prop_Array[e].prpId;
				myXML.appendChild(FORM_PROPERTY);
				}
		}
		return myXML;		
	}
	
	
	function propertyHasChanged(propID:Number,propValue:String){
		var pElementType = getPropElementByID(propID);
		//myXMLSocket.send (">>>pElementType: "+ pElementType + "\n");
		if(((pElementType=="input" || pElementType=="modal" || pElementType=="color") && (propValue!="")) 
			|| ((pElementType=="checkbox") && (propValue!=false))){
			return true;
		}else{
			return false;
		}
	};
	
	function getPropElementByID(id:Number){
		for(var z=0;z<_global.prop_array.length;z++){
			var objProp = _global.prop_array[z];
			for(var e=0; e< objProp.length;e++){
				if(objProp[e].id==id){
					//myXMLSocket.send (">>> prop: "+ objProp[e].element_type + "\n");
					return objProp[e].element_type;
				}
			}
		}
		return null;
	};

};





