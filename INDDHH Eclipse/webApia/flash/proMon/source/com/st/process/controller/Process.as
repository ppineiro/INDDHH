

import com.st.process.model.ProcessModel;
import com.st.process.view.ProcessView;
import com.st.process.controller.XmlProcessParser;

import com.qlod.LoaderClass;


class com.st.process.controller.Process {
	private var __model:ProcessModel;
	private var __view:ProcessView;
	
	private var xmlProcess:XmlProcessParser;
	private var xmlLoader:LoaderClass;
	
	private var def_XML:XML;	
	
	public function Process(root:MovieClip){
		xmlLoader = new LoaderClass();
		//xmlLoader.clear();
		xmlLoader.setMinSteps(4);
		__model = new ProcessModel();
		__view = new ProcessView(root,this,__model);
		xmlProcess = new XmlProcessParser();
		reset();
	};
	
	public function reset():Void {
		__model.reset();
	};
	
	public function getProcessDefinition():Void{
		var tmpModel = this;
			def_XML = new XML();
			def_XML.ignoreWhite = true;
			
		var xmlDef_listener = new Object();
			xmlDef_listener.onLoadStart = function(loaderObj){
				trace("\nLOADING DEF XML:" + loaderObj.getUrl());
			};
			xmlDef_listener.onLoadProgress = function(loaderObj){
				var p = loaderObj.getPercent();
				if(p.isNaN()){}else{trace("\nDEF LOADING:" + Math.round(p));}
			};
			xmlDef_listener.onTimeout = function(loaderObj){
				trace("\nDEF TIMEOUT");
			};
			xmlDef_listener.onLoadComplete = function(success,loaderObj){
				trace("\nDEF LOADED\n");
				xmlProcess = new XmlProcessParser(tmpModel);
				xmlProcess.parseProcess(loaderObj.getTargetObj());
			};
		xmlLoader.load(def_XML,_global.PROCESS_XML_DATAURL, xmlDef_listener);
	};
	
	
	
	/////////////////////////
	//TASK ELEMENT
	////////////////////////
	public function addTaskElement(att_element_id:Number,att_pro_ele_id:Number,att_disabled:String,att_color:String,att_task_id:Number,att_label:String,att_x:Number,att_y:Number,info:Object){
		__model.addTask(att_element_id,att_pro_ele_id,att_disabled,att_color,att_task_id,"T",att_label,att_x,att_y,info);
	};
	
	public function addTaskMultiplier(att_element_id:Number,task_multiplier_id:Number,task_multiplier_name:String){
		__model.updateTaskMultiplier(att_element_id,task_multiplier_id,task_multiplier_name);
	};
	public function removeTaskMultiplier(att_element_id:Number){
		__model.updateTaskMultiplier(att_element_id);
	};
	/////////////////////////
	//SUBPROCESS ELEMENT
	////////////////////////
	public function addProcessElement(att_element_id:Number,att_pro_ele_id:Number,att_pro_disabled:String,att_pro_color:String,att_pro_id:Number,att_label:String,att_x:Number,att_y:Number,info:Object){
		__model.addProcess(att_element_id,att_pro_ele_id,att_pro_disabled,att_pro_color,att_pro_id,"P",att_label,att_x,att_y,info);
	};
	
	public function processElementIterate(att_id:Number,iterate:Boolean):Void{
		__model.iterateProcessElement(att_id,iterate);
	};
	
	public function processElementIterationCondition(att_id:Number,hasCondition:Boolean,condition:String){
		__model.updateProcessIterationCondition(att_id,hasCondition,condition);
	};

	public function setProcessElementType(att_id:Number,att_pro_type:String){
		__model.setProcessType(att_id,att_pro_type);
	};
	
	//Subprocess Forms
	public function updateProcessForms(att_id:Number,forms_arr:Array):Void{
		//@param forms_arr[n] = frmObj[id,readonly,type,name];
		__model.setProcessForms(att_id,forms_arr);
	};
	
	
	/////////////////////////
	//OP ELEMENT
	////////////////////////
	public function addOperatorElement(att_element_id:Number,att_pro_ele_id:Number,att_ope_id:Number,att_x:Number,att_y:Number){
		trace("att_x,att_y"+att_x+att_y);
		__model.addOperator(att_element_id,att_pro_ele_id,att_ope_id,"O",att_x,att_y);
	};
	
	public function addInitElement(att_element_id:Number,att_pro_ele_id:Number,att_x:Number,att_y:Number){
		var lbl_start = _global.labelVars.lbl_startTask;
		__model.addInitTask(att_element_id,att_pro_ele_id,"I",lbl_start,att_x,att_y);
	};
	
	public function addEndElement(att_element_id:Number,att_pro_ele_id:Number,att_x:Number,att_y:Number){
		var lbl_end = _global.labelVars.lbl_endTask;
		__model.addEndTask(att_element_id,att_pro_ele_id,"E",lbl_end,att_x,att_y);
	};
	
	public function removeElement(att_element_id:Number){
		__model.removeElement(att_element_id);
	};
	public function setElementPos(att_id:Number, posX:Number, posY:Number):Void{
		__model.setElementPosition(att_id,posX,posY);
	};
	
	
	/////////////////////////
	//DEPENDENCY ELEMENT
	////////////////////////
	public function addDependency(att_id:Number, dependency_Id:Number,dependency_Name:String,dependency_Cond:String, take_next:Boolean, loop_back:Boolean,disabled:String){
		__model.addLineElement(att_id,dependency_Id,dependency_Name,dependency_Cond,disabled);
		if(take_next){
			dependencyAsWizard(att_id,dependency_Id,take_next);
		}
		if(loop_back){
			dependencyLoopBack(att_id,dependency_Id,loop_back);
		}
	};
	
	public function dependencyAsWizard(startId:Number,endId:Number,isWizard:Boolean):Void{
		__model.dependencyIsWizard(startId,endId,isWizard);
	};
	
	public function dependencyLoopBack(startId:Number,endId:Number,loop_back:Boolean):Void{
		__model.dependencyHasLoopBack(startId,endId,loop_back);
	};
	
	public function removeDependency(startId:Number,endId:Number){
		__model.removeLineElement(startId,endId);
	};
	
	public function addDependencyName(id_a:Number,id_b:Number,dependency_Name:String,dependency_disabled:String){
		__model.addLineName(id_a,id_b,dependency_Name,dependency_disabled);
	};
	public function removeDependencyName(id_a:Number,id_b:Number){
		__model.removeLineName(id_a,id_b);
	};
	
	public function addDependencyCondition(startId:Number,endId:Number,condition:String){
		__model.addLineCondition(startId,endId,condition);
	};
	public function removeDependencyCondition(startId:Number,endId:Number):Void{
		__model.removeLineCondition(startId,endId)
	};
	
	/////////////////////////////////////
	//TASK FORM
	/////////////////////////////////////
	public function addStepFormToTask(att_id:Number,step_pos:Number,form_obj:Object):Void{
		trace("form_obj "+form_obj.condition);
		//@param (taskid,step_pos,form_obj[id,readonly,type,name,multiply])
		__model.addFormToStep(att_id,step_pos,form_obj);
	}
	public function addFormToTask(att_id:Number,form_obj:Array):Void{
		//@param (taskid,step_pos,form_obj[id,readonly,type,name,multiply])
		__model.addFormToTask(att_id,form_obj);
	}
	/////////////////////////////////////
	//TASK ROL
	/////////////////////////////////////
	public function addRolToTask(att_id:Number,rol_id:Number,rol_name:String):Void{
		__model.addRol(att_id,rol_id,rol_name);
	};
	public function removeRol(att_id:Number):Void{
		trace("REMOVE ROLE"+" "+att_id);
		__model.removeRol(att_id);
	};
	/////////////////////////////////////
	//TASK POOLS
	/////////////////////////////////////
	public function addPoolsToTask(att_id:Number,pool_array:Array):Void{
		//@param (att_id,pool_array[pool_id,condition,pool_name])
		__model.addPools(att_id,pool_array);
	};
	/////////////////////////////////////
	//TASK STATES
	/////////////////////////////////////
	public function addStateToTask(att_id:Number,state_array:Array):Void{
		//@param (att_id,pool_array[pool_id,condition,pool_name])
		__model.addStates(att_id,state_array);
	};
	/////////////////////////////////////
	//TASK EVENTS
	/////////////////////////////////////
	public function updateTaskEvents(att_id:Number,evt_arr:Array):Void{
		__model.setTaskEvts(att_id,evt_arr);
	};
	
	/////////////////////////////////////
	//PROCESS EVENTS
	/////////////////////////////////////
	public function updateProcessEvents(evt_arr:Array):Void{
		__model.setProcessEvts(evt_arr);
	};
	
	
	public function getModelXML():XML{
		var myXML = new XML();
			myXML.xmlDecl="<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>";
			//myXML.docTypeDecl = "<!DOCTYPE PROCESS_DEFINITION SYSTEM \"\\stsdesa01\Documentacion\ST\DOGMA\XML\process\process.dtd\">";
		var root = myXML.createElement("PROCESS_DEFINITION");
			//root.attributes.maxId = ""; //get max id
		
		//----------------------------------------
		//APPEND PROCESS MAP EVENTS
			var EVENTS = myXML.createElement("EVENTS");
			var evtArr:Array = __model.getProcessEvts(el_id);
			for(var d=0; d<evtArr.length;d++){
				var EVENT = myXML.createElement("EVENT");
					EVENT.attributes.event_id = evtArr[d].event_id;
					EVENT.attributes.event_name = evtArr[d].event_name;
					EVENT.attributes.order = d;
					EVENT.attributes.class_id = evtArr[d].class_id;
					EVENT.attributes.class_name = evtArr[d].class_name;
					var p_bndID = evtArr[d].bnd_id;
					if(p_bndID){EVENT.attributes.bnd_id = p_bndID;}
				for(var e=0; e<evtArr[d].binding.length;e++){
					var BINDING = myXML.createElement("BINDING");
						BINDING.attributes.param_id = evtArr[d].binding[e].param_id;
						BINDING.attributes.param_name = evtArr[d].binding[e].param_name;
						BINDING.attributes.param_type = evtArr[d].binding[e].param_type;
						
						var attId =  evtArr[d].binding[e].att_id;
						if(attId){
							BINDING.attributes.att_id =attId;
							BINDING.attributes.att_name = evtArr[d].binding[e].att_name;
							BINDING.attributes.att_type = evtArr[d].binding[e].att_type;
						}else{
							var BINDING_value = myXML.createTextNode(evtArr[d].binding[e].value);
							BINDING.appendChild(BINDING_value);
						}
					EVENT.appendChild(BINDING);
				}
				EVENTS.appendChild(EVENT);
			}
			root.appendChild(EVENTS);
		//----------------------------------------
		
		var modelElements:Object = __model.getElements();
		
		//ITERATE ELEMENTS
		 for(var l in modelElements) {
			var el_id:Number = __model.getElementId(l);
			var el_pro_ele_id:Number =  __model.getElementProEleId(el_id);
			var el_type:String =  __model.getElementType(el_id);
			
			var oEl = myXML.createElement("ELEMENT");
				oEl.attributes.id = el_id;
				oEl.attributes.type = el_type;
				if(!isNaN(el_pro_ele_id)){
					oEl.attributes.pro_ele_id = el_pro_ele_id;
				}
				
			root.appendChild(oEl);
				
			//SET DESIGN
			var DESIGN_NODE = myXML.createElement("DESIGN");
				DESIGN_NODE.attributes.x = __model.getElementX(el_id);
				DESIGN_NODE.attributes.y = __model.getElementY(el_id);
				
				
				//SET by element TYPE
				var oElType:XMLNode;
				switch(el_type){
					//---------------------
					//INIT MARK
					//---------------------
					case "I": 
						oElType = myXML.createElement("INIT_MARK");
					break;
					//---------------------
					//TASK ELEMENT
					//---------------------
					case "T":
						oElType = myXML.createElement("TASK");
						oElType.attributes.task_id = __model.getTaskId(el_id);
						oElType.attributes.name = __model.getTaskName(el_id);
						
						//APPEND MULTIPLIER
						var oMultiplier = __model.getTaskMultiplier(el_id);
						if(oMultiplier!=null){
							oElType.attributes.mult_id = oMultiplier.id;
							oElType.attributes.mult_name = oMultiplier.name;
						}
						
						//---------------------
						//APPEND ROL TO TASK 
						//---------------------
						var rol_id = __model.getTaskRolId(el_id);
						var rol_name = __model.getTaskRolName(el_id);
						if(rol_id){
							var oRol_xml = myXML.createElement("ROL");
								oRol_xml.attributes.rol_id = rol_id;
								oRol_xml.attributes.name = rol_name;
							oElType.appendChild(oRol_xml);
						}
						//-------------------------
						//APPEND POOLS TO TASK EL
						//-------------------------
						var oPools = myXML.createElement("POOLS");
						var thePools:Array = __model.getPools(el_id);
						
						for(var d=0; d<thePools.length;d++){
							var oPool = myXML.createElement("POOL");
								oPool.attributes.pool_id = thePools[d].pool_id;
								oPool.attributes.name = thePools[d].pool_name;
								if(!(thePools[d].condition==null || thePools[d].condition==undefined || thePools[d].condition=="")){
									var theCondition = myXML.createTextNode(thePools[d].condition);
									oPool.appendChild(theCondition);
								}
								
							oPools.appendChild(oPool);
						}
						oElType.appendChild(oPools);
						
						//-------------------------
						//APPEND STATES TO TASK EL
						//-------------------------
						var oStates = myXML.createElement("STATES");
						var theStates:Array = __model.getStates(el_id);
						
						for(var d=0; d<theStates.length;d++){
							var oState = myXML.createElement("STATE");
								oState.attributes.event_id = theStates[d].event_id;
								oState.attributes.event_name = theStates[d].event_name;
								oState.attributes.sta_id = theStates[d].sta_id;
								oState.attributes.sta_name = theStates[d].sta_name;
								if(!(theStates[d].condition==null || theStates[d].condition==undefined || theStates[d].condition=="")){
									trace("theCondition "+theCondition);
									var theCondition = myXML.createTextNode(theStates[d].condition);
									oState.appendChild(theCondition);
								}
								
							oStates.appendChild(oState);
						}
						oElType.appendChild(oStates);
						
						
						//---------------------------
						//-------------------------
						//APPEND <FORMS> TO TASK
						//-------------------------
						var FORMS = myXML.createElement("FORMS");
						var theSteps:Array = __model.getTaskForms(el_id);
						for(var d=0; d<theSteps.length;d++){
							if(theSteps[d].length>0){
							var STEP = myXML.createElement("STEP");
							for(var e=0; e<theSteps[d].length;e++){
								var FORM = myXML.createElement("FORM");
									FORM.attributes.form_id = theSteps[d][e].form_id;
									FORM.attributes.read_only = theSteps[d][e].read_only;
									FORM.attributes.type = theSteps[d][e].type;
									FORM.attributes.name = theSteps[d][e].name;
									FORM.attributes.multiply = checkBoolean(theSteps[d][e].multiply);
									if(!(theSteps[d][e].condition==null || theSteps[d][e].condition==undefined || theSteps[d][e].condition=="")){
									var FORM_value = myXML.createTextNode(theSteps[d][e].condition);
									FORM.appendChild(FORM_value);
									}
									STEP.appendChild(FORM);
									}
							}
							FORMS.appendChild(STEP);
						}
						oElType.appendChild(FORMS);
						//-------------------------
						//-------------------------
						//APPEND <EVENTS> TO TASK
						//-------------------------
						var EVENTS = myXML.createElement("EVENTS");
						var evtArr:Array = __model.getTaskEvts(el_id);
						for(var d=0; d<evtArr.length;d++){
							var EVENT = myXML.createElement("EVENT");
								EVENT.attributes.event_id = evtArr[d].event_id;
								EVENT.attributes.event_name = evtArr[d].event_name;
								EVENT.attributes.order = d;
								EVENT.attributes.class_id = evtArr[d].class_id;
								EVENT.attributes.class_name = evtArr[d].class_name;
								var p_bndID = evtArr[d].bnd_id;
								if(p_bndID){EVENT.attributes.bnd_id = p_bndID;}
							for(var e=0; e<evtArr[d].binding.length;e++){
								var BINDING = myXML.createElement("BINDING");
									BINDING.attributes.param_id = evtArr[d].binding[e].param_id;
									BINDING.attributes.param_name = evtArr[d].binding[e].param_name;
									BINDING.attributes.param_type = evtArr[d].binding[e].param_type;
									
									var attId =  evtArr[d].binding[e].att_id;
									if(attId){
										BINDING.attributes.att_id =attId;
										BINDING.attributes.att_name = evtArr[d].binding[e].att_name;
										BINDING.attributes.att_type = evtArr[d].binding[e].att_type;
									}else{
										var BINDING_value = myXML.createTextNode(evtArr[d].binding[e].value);
										BINDING.appendChild(BINDING_value);
									}
								EVENT.appendChild(BINDING);
							}
							EVENTS.appendChild(EVENT);
						}
						oElType.appendChild(EVENTS);
						//------------------------
					break;
					//END MARK
					case "E": 
						oElType = myXML.createElement("END_MARK");
					break;
					
					//OPERATOR ELEMENT
					case "O": 
						oElType = myXML.createElement("OPERATOR");
						oElType.attributes.ope_id =  __model.getOperatorId(el_id);
					break;
					//---------------------
					//SUBPROCESS ELEMENT
					//---------------------
					case "P": 
						oElType = myXML.createElement("PROCESS");
						oElType.attributes.pro_id =  __model.getProcessId(el_id);
						oElType.attributes.name = __model.getProcessName(el_id);
						
						var att_pro_type = __model.getProcessType(el_id);
						var att_pro_iterate = __model.getProcessIterate(el_id);
						var proIterateCondition = __model.getProcessIterateCondition(el_id);
						
						if(att_pro_type){
							oElType.attributes.type = att_pro_type;
						}
						if(att_pro_iterate){
							var ITERATE = myXML.createElement("ITERATE");
							if(proIterateCondition){
								var it_con = myXML.createTextNode(proIterateCondition);
								ITERATE.appendChild(it_con);
							}
							oElType.appendChild(ITERATE);
						}
						/*
						var processCondition = flowManager.getElement(z).m_condition;
						if(processCondition){	//ADD condition to subprocess
							var pCondition = myXML.createTextNode(processCondition);
								oElType.appendChild(pCondition);
						}*/
						
						//SUBPROCESS FORMS
						var frm_Arr:Array = __model.getProcessForms(el_id);
						if(frm_Arr.length>0){
							var frm_xml = myXML.createElement("FORMS");
							for(var d=0; d < frm_Arr.length; d++){
								var frmItem_xml = myXML.createElement("FORM");
									frmItem_xml.attributes.form_id = frm_Arr[d].form_id;
									frmItem_xml.attributes.read_only = frm_Arr[d].read_only;
									frmItem_xml.attributes.type = frm_Arr[d].type;
									frmItem_xml.attributes.name = frm_Arr[d].name;
									frm_xml.appendChild(frmItem_xml);
							}
							oElType.appendChild(frm_xml);
						}
						
		
					break;
				};
				oEl.appendChild(oElType);
				oEl.appendChild(DESIGN_NODE);
				
				//-----------------------------------
				//ITERATE ELEMENT DEPENDENCIES
				//-----------------------------------
				
				var el_vertices = __model.getVertices(el_id);
				var depenIndex = 0;
				
				for(var n in el_vertices){
					depenIndex++;
				}
				if(depenIndex>1){
					var NEXT_TASKS = myXML.createElement("DEPENDENCIES");
				}
				
				var v_a:Number = el_id; //vetice a
				
				for(var n in el_vertices){
					var v_b:Number = parseInt(n); //vetice b
					
					var NEXT_TASK = myXML.createElement("DEPENDENCY");
						NEXT_TASK.attributes.id =  __model.getLineId(v_a,v_b);
						//trace(v_a + ":" + v_b)
					
					var dependency_name:String = __model.getLineName(v_a,v_b);
					if(dependency_name){
						NEXT_TASK.attributes.name = dependency_name;
					}
					var dependency_condition:String = __model.getLineCondition(v_a,v_b);
					if(dependency_condition){
						var a = myXML.createTextNode(dependency_condition);
						NEXT_TASK.appendChild(a);
					}
					var dependency_take_next:Boolean = __model.isWizard(v_a,v_b);
					if(dependency_take_next){
						NEXT_TASK.attributes.take_next = "true";
					}
					var dependency_loop_back:Boolean = __model.isLooped(v_a,v_b);
					if(dependency_loop_back){
						NEXT_TASK.attributes.loop_back = "true";
					}
					/////////////////////////
					if(v_b){
						if(depenIndex>1){
							NEXT_TASKS.appendChild(NEXT_TASK);
						}else{
							oEl.appendChild(NEXT_TASK);
						}
					}
				}
				if(depenIndex>1){
					oEl.appendChild(NEXT_TASKS);
				}
		//end main loop
		}
		
		myXML.appendChild(root);
		return myXML.toString();
	};
	
	
	function getXMLin():XML{
		return def_XML;
	};
	
	
	function checkBoolean(p):Boolean{
		if(p=="true" || p==true){
			return true;
		}else{
			return false;
		}
	};
	
	function enableEntParams(){
		__view.setHasEntParams();
		}
	
	
}