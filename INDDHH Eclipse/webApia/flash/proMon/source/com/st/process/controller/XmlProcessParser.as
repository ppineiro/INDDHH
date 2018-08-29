

import com.st.process.controller.Process;

class com.st.process.controller.XmlProcessParser{
	
	private var __controller:Process;
	
	public function XmlProcessParser(controller:Process){
		__controller = controller;
	};
	

	public function parseProcess(oXML:XML) {
        var x:XML = oXML;
		var tmpController = __controller;
		var tmpThis = this;
		////////////////////////////////////////////////
		//---------------------------------------------
		//GET ALL ELEMENTS
		//---------------------------------------------
		/////////////////////////////////////////////////
		for(var e in x.firstChild.childNodes){
			var currentNode = x.firstChild.childNodes[e];
			with (currentNode){
				//GET PROCESS MAP EVENTS
				if(nodeName=="EVENTS"){
					thisNode = currentNode;
					var pro_events_array = new Array();
					for(var j in thisNode.childNodes){
						//get EVENT element
						var p_events = new Object();
							p_events.event_id = thisNode.childNodes[j].attributes.event_id;
							p_events.event_name = thisNode.childNodes[j].attributes.event_name;
							p_events.class_id = thisNode.childNodes[j].attributes.class_id;
							p_events.class_name = thisNode.childNodes[j].attributes.class_name;
							p_events.bnd_id = thisNode.childNodes[j].attributes.bnd_id;
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
						pro_events_array.push(p_events);
					}
					tmpController.updateProcessEvents(pro_events_array);
				}
				//GET ELEMENT INFO
				var infoNode=tmpThis.getChildNode(currentNode,"INFO");
				var infoText="";
				for(var i=0;i<infoNode.childNodes.length;i++){
					infoText=infoText+infoNode.childNodes[i];
				}
				var info:Object = {title:infoNode.attributes.title,text:infoText};
				//GET ELEMENT ATT id
				var att_element_id = parseInt(attributes.id);
				
				//GET ELEMENT ATT pro_ele_id
				//all elements can have a pro_ele_id attribute(task,process,op,inti,end)
				var att_pro_ele_id = parseInt(attributes.pro_ele_id);
				
				//GET ELEMENT ATT type
				var att_type = attributes.type;
				
				//GET ELEMENT ATT disabled
				var att_disabled=attributes.disabled;
				//GET ELEMENT ATT color
				var att_color=attributes.color;
				//GET DESIGN ELEMENT
				//GET ELEMENT ATT x & y
				var moved:Number=0;
				if(attributes.copia=="T"){
					moved=100;
					}
				var designNode = tmpThis.getChildNode(currentNode,"DESIGN");
				var att_x = parseInt(designNode.attributes.x)+moved;
				var att_y = parseInt(designNode.attributes.y)+moved;
				
			
				//INITMARK ELEMENT
				if(att_type == "I"){ 
					tmpController.addInitElement(att_element_id,
										att_pro_ele_id,
										att_x,
										att_y
										);
					
				}
				//ENDMARK ELEMENT
				if(att_type == "E"){ 
					tmpController.addEndElement(att_element_id,
										att_pro_ele_id,
										att_x,
										att_y
										);
				}
				//TASK ELEMENT
				if(att_type == "T"){ 
					var p_rol:Number = null;
					var p_rolName:String = null;
					var taskNode:XMLNode = tmpThis.getChildNode(currentNode,"TASK");
					var thisNode:XMLNode;
					
					//unique element attributes
					var att_label:String = taskNode.attributes.name;
					var att_task_id:Number = taskNode.attributes.task_id;
					
					tmpController.addTaskElement(att_element_id,
												att_pro_ele_id,
												att_disabled,
												att_color,
												att_task_id,
												att_label,
												att_x,
												att_y,
												info
												);
					
					//set task multiplier
					var task_multiplier_id = taskNode.attributes.mult_id;
					var task_multiplier_name = taskNode.attributes.mult_name;
					
					if(task_multiplier_id){
						tmpController.addTaskMultiplier(att_element_id,task_multiplier_id,task_multiplier_name);
					}
					
					//------------------------------------
					//TASK ELEMENT CHILDREN ELEMENTS
					//------------------------------------
					for(var d in taskNode.childNodes){
						thisNode = taskNode.childNodes[d];
						//TASK ROL
						if(thisNode.nodeName=="ROL"){
							p_rolId = parseInt(thisNode.attributes.rol_id);
							p_rolName = thisNode.attributes.name;
							tmpController.addRolToTask(att_element_id,p_rolId,p_rolName);
						}
						//TASK FORMS
						if(thisNode.nodeName=="FORMS"){
							//loop element <forms>
							//for(var j in thisNode.childNodes){
							for(var j=0; j < thisNode.childNodes.length;j++){
								//for(var z in thisNode.childNodes[j].childNodes){
								for(var z=0; z < thisNode.childNodes[j].childNodes.length;z++){
									var p_form = new Object();
										p_form.form_id = thisNode.childNodes[j].childNodes[z].attributes.form_id;
										p_form.type = thisNode.childNodes[j].childNodes[z].attributes.type;
										p_form.read_only = thisNode.childNodes[j].childNodes[z].attributes.read_only;
										p_form.name = thisNode.childNodes[j].childNodes[z].attributes.name;
										p_form.multiply = thisNode.childNodes[j].childNodes[z].attributes.multiply;
										p_form.condition = thisNode.childNodes[j].childNodes[z].firstChild.nodeValue;
										
									tmpController.addStepFormToTask(att_element_id,j,p_form);
								}
							}
						}
						//TASK POOLS
						if(thisNode.nodeName=="POOLS"){
							var pool_array = new Array();
							for(var j in thisNode.childNodes){
								var p_pools = new Object();
									p_pools.pool_id = thisNode.childNodes[j].attributes.pool_id;
									p_pools.condition = thisNode.childNodes[j].firstChild.nodeValue;
									p_pools.pool_name = thisNode.childNodes[j].attributes.name;
								pool_array.push(p_pools);
							}
							tmpController.addPoolsToTask(att_element_id,pool_array);
						}
						//---------------------------
						//TASK STATES
						if(thisNode.nodeName=="STATES"){
							var state_array=new Array();
							for(var j=0; j < thisNode.childNodes.length;j++){
									var p_state = new Object();
										p_state.event_id = thisNode.childNodes[j].attributes.event_id;
										p_state.event_name = thisNode.childNodes[j].attributes.event_name;
										p_state.sta_id = thisNode.childNodes[j].attributes.sta_id;
										p_state.sta_name = thisNode.childNodes[j].attributes.sta_name;
										p_state.order = thisNode.childNodes[j].attributes.order;
										p_state.condition = thisNode.childNodes[j].firstChild.nodeValue;
									state_array.push(p_state);
							}
							tmpController.addStateToTask(att_element_id,state_array);
						}
						
						//---------------------------
						//TASK EVENTS
						if(thisNode.nodeName=="EVENTS"){
							var events_array = new Array();
							for(var j in thisNode.childNodes){
								//get EVENT element
								var p_events = new Object();
									p_events.event_id = thisNode.childNodes[j].attributes.event_id;
									p_events.event_name = thisNode.childNodes[j].attributes.event_name;
									p_events.class_id = thisNode.childNodes[j].attributes.class_id;
									p_events.class_name = thisNode.childNodes[j].attributes.class_name;
									p_events.bnd_id = thisNode.childNodes[j].attributes.bnd_id;
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
								events_array.push(p_events);
							}
							tmpController.updateTaskEvents(att_element_id,events_array);
						}
						//----------------------------
						
					}
				}
				//SUBPROCESS ELEMENT
				if(att_type == "P"){
					var processNode = tmpThis.getChildNode(currentNode,"PROCESS");
					//unique element att
					var att_label = processNode.attributes.name;
					var att_pro_id = processNode.attributes.pro_id;
					var att_pro_type = processNode.attributes.type;
					var att_pro_disabled = att_disabled;
					var att_pro_color = att_color;
					tmpController.addProcessElement(att_element_id,
										att_pro_ele_id,
										att_pro_disabled,
										att_pro_color,
										att_pro_id,
										att_label,
										att_x,
										att_y,
										info										
										);
					
					//SUBPROCESS TYPE
					if(att_pro_type){
						tmpController.setProcessElementType(att_element_id,att_pro_type);
					}
					
					//SUBPROCESS CHILDREN
					var frms_array = new Array();
					for(var d in processNode.childNodes){
						thisNode = processNode.childNodes[d];
						if(thisNode.nodeName=="FORMS"){
							//SUBPROCESS FORMS NODE
							for(var j=0;j<thisNode.childNodes.length;j++){
							//for(var j in thisNode.childNodes){
								var sp_form = new Object();
									sp_form.form_id = thisNode.childNodes[j].attributes.form_id;
									sp_form.read_only = thisNode.childNodes[j].attributes.read_only;
									sp_form.type = thisNode.childNodes[j].attributes.type;
									sp_form.name = thisNode.childNodes[j].attributes.name;
								
								frms_array.push(sp_form);
								
							}
							tmpController.updateProcessForms(att_element_id,frms_array);
						}
						if(thisNode.nodeName=="ITERATE"){
							//SUBPROCESS ITERATE NODE
							tmpController.processElementIterate(att_element_id,true);
							//SUBPROCESS ITERATE NODE CONDITION
							var iterateCondition = thisNode.firstChild.nodeValue;
							if(iterateCondition){
								tmpController.processElementIterationCondition(att_element_id,true,iterateCondition);
							}
						}
					}
					
					
					
				}
				
				
				//OPERATOR ELEMENT
				if(att_type == "O"){ 
					var opNode = tmpThis.getChildNode(currentNode,"OPERATOR");
					var att_ope_id = parseInt(opNode.attributes.ope_id);
					tmpController.addOperatorElement(att_element_id,
										att_pro_ele_id,
										att_ope_id,
										att_x,
										att_y
										);
				}
			}
        }
		////////////////////////////////////////////////
		//---------------------------------------------
		//GET DEPENDANCIES
		//---------------------------------------------
		//////////////////////////////////////////////////
		for(var e in x.firstChild.childNodes){
			with (x.firstChild.childNodes[e]){
				for(var d in childNodes){
					if(childNodes[d].nodeName == "DEPENDENCIES"){
						for(var z in childNodes[d].childNodes){
							var att_id = parseInt(attributes.id);
							var dependencyId = parseInt(childNodes[d].childNodes[z].attributes.id);
							var dependencyName = childNodes[d].childNodes[z].attributes.name;
							var dependencyCond = childNodes[d].childNodes[z].firstChild.nodeValue;
							var dependencyDisabled = childNodes[d].childNodes[z].attributes.disabled;
							
							var pTakeNext:Boolean;
							if(childNodes[d].childNodes[z].attributes.take_next == "true"){
								pTakeNext = true;
							}else{
								pTakeNext = false;
							}
							
							var pLoopBack:Boolean;
							if(childNodes[d].childNodes[z].attributes.loop_back == "true"){
								pLoopBack = true;
							}else{
								pLoopBack = false;
							}
							
							tmpController.addDependency(att_id,dependencyId, dependencyName, dependencyCond, pTakeNext, pLoopBack,dependencyDisabled);
						}
					}
					if(childNodes[d].nodeName == "DEPENDENCY"){
						var att_id = parseInt(attributes.id);
						var dependencyId = parseInt(childNodes[d].attributes.id);
						var dependencyName = childNodes[d].attributes.name;
						var dependencyCond = childNodes[d].firstChild.nodeValue;
						var dependencyDisabled = childNodes[d].attributes.disabled;
						
						var pTakeNext:Boolean;
						if(childNodes[d].attributes.take_next == "true"){
							pTakeNext = true;
						}else{
							pTakeNext = false;
						}
						
						var pLoopBack:Boolean;
							if(childNodes[d].attributes.loop_back == "true"){
								pLoopBack = true;
							}else{
								pLoopBack = false;
							}
						tmpController.addDependency(att_id, dependencyId, dependencyName, dependencyCond, pTakeNext, pLoopBack,dependencyDisabled);
						
					}
				}
			}
		}
		
		fscommand("isReady","true");
	
	};
	
	
	
	private function getChildNode(p_node:XMLNode,p_name:String):XMLNode{
		//returns node p_name in p_node xml
		for(var s in p_node.childNodes){
			if(p_node.childNodes[s].nodeName==p_name){
				return p_node.childNodes[s];
			}
		}
	};
	
	

}





