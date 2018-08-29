


//Flow class
import mx.managers.PopUpManager;
import mx.containers.Window;

class Flow extends MovieClip {
	
	var root:MovieClip;  		// reference to the timeline - normally level0 or _root
	var model:Object;			// holds flow dependancy data
	var maxID:Number;			//element ID counter
	
	var Map:MovieClip;			//main mc
	var Box_mask:MovieClip;		//main mc's MASK
	var TaskArea:MovieClip;		//task elements mc
	var LineArea:MovieClip;		//line elements mc
	
	
	function Flow(r){
		root = r;
		model = new Model();
		
		Map = root.createEmptyMovieClip("Map",6);
		LineArea = Map.createEmptyMovieClip("lineArea",1);
		TaskArea = Map.createEmptyMovieClip("taskArea",2);
		
		///////////////////////////////
		//debug
		
		//var TOTAL_MAP_W=1179;
		//var TOTAL_MAP_H=720;
		
		var TOTAL_MAP_W=2400;
		var TOTAL_MAP_H=1800;
		
		//////////////////////////////////
		//
		//////////////////////////////////
		var Bounds = Map.createEmptyMovieClip("Bounds",0);
		Bounds.lineStyle(1, 0x000000);
		// Position the drawing pen.
		Bounds.moveTo(0, 0);
		
		// Start a white fill.
		//Bounds.beginFill(0xFFFFFF, 100);
		// Draw the border of the box.
		
		Bounds.moveTo(TOTAL_MAP_W, 0);
		Bounds.lineTo(TOTAL_MAP_W, TOTAL_MAP_H);
		Bounds.lineTo(0, TOTAL_MAP_H);
		//Bounds.lineTo(0, 0);
		
		// Formally stop filling the shape.
		//Bounds.endFill( );
		///////////////////////////////
		
		//MASK IT
		Box_mask = root.attachMovie("flowMask","flowMask", 2);
		Box_mask._width = Stage.width;
		Box_mask._height = Stage.height;
		
		Map.setMask(Box_mask);
	
	};
	
	function setSize(){
		Box_mask._width = Stage.width-2;
		Box_mask._height = Stage.height-2;
		Box_mask._x = 0;
		Box_mask._y = 0;
	};
	
	function reset(){
		//called from reload method on _root
		TaskArea.removeMovieClip();
		LineArea.removeMovieClip();
		Box_mask.removeMovieClip();
		Map.removeMovieClip();
	};
	
	function checkMaxID(p_currentID:Number):Number{
		if(p_currentID==null){
			return maxID++;
		}else{
			if(p_currentID >= maxID){
				maxID = p_currentID+1;
			}else{
				
			}
		return p_currentID;
		}
	};
	
	function addTask(p_elementId:Number,p_pro_ele_id:String,p_type:String,p_taskId:Number,p_xPos:Number,p_yPos:Number,p_rol:Number,p_rolName:String,p_name:String,process_form_array:Array,entity_form_array:Array,events_array:Array,pool_array:Array){
		p_elementId = checkMaxID(p_elementId);
		
		if(model.getElement(p_elementId)!=null){
			//root.traceDebug("TASK ID: " + p_elementId + " already exists")
		}else{
			var nextDepth = TaskArea.getNextHighestDepth(); 
			model.addElement(p_elementId);
			// add new Task
			var aux = TaskArea.attachMovie("Task", 'El_' + p_elementId, nextDepth, {
				m_id:p_elementId,
				m_pro_ele_id:p_pro_ele_id,
				m_type:p_type,
				m_taskId:p_taskId,
				m_rolId:p_rol,
				m_rolName:p_rolName,
				m_name:p_name,
				m_process_form_array:process_form_array,
				m_entity_form_array:entity_form_array,
				m_events_array:events_array,
				m_pool_array:pool_array,
				_x:p_xPos,
				_y:p_yPos
				});
			aux.addEventListener("onElementClicked",this);
			aux.addEventListener("onElementDblClicked",this);
			aux.addEventListener("onElementRollOver",this);
		    aux.addEventListener("onElementRollOut",this);
		}
	};
	
	function addSubProcess(p_elementId:Number,p_pro_ele_id:String,p_name:String,p_type:String,p_proId:Number,p_iterate:Boolean,p_xPos:Number,p_yPos:Number,p_condition:String){
		p_elementId = checkMaxID(p_elementId);
		
		model.addElement(p_elementId);
		var nextDepth = TaskArea.getNextHighestDepth();
		var aux = TaskArea.attachMovie("SubProcess", 'El_' + p_elementId, nextDepth, {
			m_id:p_elementId,
			m_pro_ele_id:p_pro_ele_id,
			m_name:p_name,
			m_iterate:p_iterate,
			m_condition:p_condition,
			m_type:p_type,
			m_pro_id:p_proId,
			_x:p_xPos,
			_y:p_yPos
			});
		
		aux.addEventListener("onElementClicked",this);
		aux.addEventListener("onElementDblClicked",this);
		aux.addEventListener("onElementRollOver",this);
		aux.addEventListener("onElementRollOut",this);
	};

	function addInitTask(p_elementId:Number,p_pro_ele_id:String,p_type:String,p_xPos:Number,p_yPos:Number){
		p_elementId = checkMaxID(p_elementId);
		
		model.addElement(p_elementId);
		var nextDepth = TaskArea.getNextHighestDepth(); 
		var aux = TaskArea.attachMovie("InitTask", 'El_' + p_elementId, nextDepth, {
			m_id:p_elementId,
			m_pro_ele_id:p_pro_ele_id,
			m_type:p_type,
			_x:p_xPos,
			_y:p_yPos
			});
		
		aux.addEventListener("onElementClicked",this);
	};
	
	function addEndTask(p_elementId:Number,p_pro_ele_id:String,p_type:String,p_xPos:Number,p_yPos:Number){
		p_elementId = checkMaxID(p_elementId);
		
		model.addElement(p_elementId);
		var nextDepth = TaskArea.getNextHighestDepth(); 
		var aux = TaskArea.attachMovie("EndTask", 'El_' + p_elementId, nextDepth, {
			m_id:p_elementId,
			m_pro_ele_id:p_pro_ele_id,
			m_type:p_type,
			_x:p_xPos,
			_y:p_yPos
			});
		
		aux.addEventListener("onElementClicked",this);
		aux.addEventListener("onElementDblClicked",this);
		aux.addEventListener("onElementRollOver",this);
		aux.addEventListener("onElementRollOut",this);
	};
	
	function addOperator(p_elementId:Number,p_pro_ele_id:String,p_type:String,p_opeId:Number,p_xPos:Number,p_yPos:Number){
		p_elementId = checkMaxID(p_elementId);
		
		model.addElement(p_elementId);
		var nextDepth = TaskArea.getNextHighestDepth();
		var aux = TaskArea.attachMovie("Operator", 'El_' + p_elementId, nextDepth, {
			m_id:p_elementId,
			m_pro_ele_id:p_pro_ele_id,
			m_type:p_type,
			m_opeId:p_opeId,
			_x:p_xPos,
			_y:p_yPos
			});
		
		aux.addEventListener("onElementClicked",this);
		aux.addEventListener("onElementDblClicked",this);
		aux.addEventListener("onElementRollOver",this);
		aux.addEventListener("onElementRollOut",this);
	};
	
	function connectElements(p_startId:Number,p_endId:Number,p_name:String,p_condition:String){
		if(p_startId!=p_endId){
			if((model.getVertex(p_startId,p_endId)!=null) || (model.getVertex(p_endId,p_startId)!=null)){ //ALREADY EXISTS
				//trace("connection " + p_startId + " / " + p_endId + " already exists");
			}else{
				//trace("connecting " + p_startId + " / " + p_endId + "");
				var nextDepth = LineArea.getNextHighestDepth();
				model.addVertex(p_startId,p_endId);
				// add new line
				var aux = LineArea.attachMovie("LineObj", 'LineObj_' + p_startId + "_" + p_endId, nextDepth, {
					m_name:p_name,
					m_condition:p_condition,
					m_startPoint:p_startId,
					m_endPoint:p_endId,
					m_startElementMc: TaskArea["El_" + p_startId],
					m_endElementMc: TaskArea["El_" + p_endId]
					});
				
				aux.addEventListener("onLineClicked",this);
				aux.addEventListener("onLineDblClicked",this);
				aux.addEventListener("onElementRollOver",this);
				aux.addEventListener("onElementRollOut",this);
			}
		}
	};
	
	function removeElement(pObj){
		if(pObj.m_type!="I"){ //not init task
			model.removeNode(pObj.m_id); 
			//remove listeners
			pObj.removeEventListener("onElementClicked",this);
			pObj.removeEventListener("onElementDblClicked",this);
			pObj.removeEventListener("onElementRollOver",this);
			pObj.removeEventListener("onElementRollOut",this);
			//delete obj
			pObj.remove();
		}
	};
	
	function disconectElements(pObj){
		model.removeVertex(pObj.m_startPoint,pObj.m_endPoint);
		//remove listeners
		pObj.removeEventListener("onLineClicked",this);
		pObj.removeEventListener("onLineDblClicked",this);
		pObj.removeEventListener("onElementRollOver",this);
		pObj.removeEventListener("onElementRollOut",this);
		//delete obj
		pObj.remove();
	};
	
	
	//////////////////////////////////////////////////////////////
	//					EVENTS
	//////////////////////////////////////////////////////////////
	function onElementClicked(p_eventObj) {
		//trace(p_eventObj.target._nId)
		var _mode = root.getToolMode();
		switch(_mode){
			case 1: // SELECT & MOVE TASKs
				p_eventObj.target.allowMoving = true;
			break;
			case 2: // CONNECT TASKS
				root.showConnect(p_eventObj.target.m_id,p_eventObj.target);
			break;
			case 3: // DELETE ELEMENT
				this.removeElement(p_eventObj.target);
			break;
		}
	};
	
	function onElementDblClicked(p_eventObj){
		var me = this;
		var _mode = root.getToolMode();
		
		if(_mode==1){	//SELECT
			//------Show Menu
		var m_el = p_eventObj.target;
		
		if(m_el.m_type!="I"){
		  if(m_el.menu == undefined) {
				// Create a Menu instance and add some items
				m_el.menu = mx.controls.Menu.createMenu();
				
				m_el.menu.embedFonts = true;
				m_el.menu.setStyle("fontFamily","k0554");
				m_el.menu.setStyle("fontSize","8");
				m_el.menu.setStyle("rollOverColor","0xEFEFEF");
				m_el.menu.setStyle("selectionColor","0xEFEFEF");
				
				if(m_el.m_type=="T"){
					m_el.menu.addMenuItem(_global.labelVars.lbl_taskContext1.toUpperCase());
					m_el.menu.addMenuItem(_global.labelVars.lbl_taskContext2.toUpperCase());
					m_el.menu.addMenuItem(_global.labelVars.lbl_taskContext3.toUpperCase());
					m_el.menu.addMenuItem(_global.labelVars.lbl_taskContext4.toUpperCase());
					//m_el.menu.addMenuItem(_global.labelVars.lbl_delete.toUpperCase());
				}
				if(m_el.m_type=="P"){
					//trace("m_el.isIterated()==" + m_el.isIterated());
					if(m_el.isIterated()){
						m_el.menu.addMenuItem(_global.labelVars.lbl_processContext2.toUpperCase());
						if(_global.isAutomatic){
							m_el.menu.addMenuItem(_global.labelVars.lbl_processContext3.toUpperCase());
						}
					}else{
						m_el.menu.addMenuItem(_global.labelVars.lbl_processContext1.toUpperCase());
					}
					m_el.menu.addMenuItem(_global.labelVars.lbl_processContext4.toUpperCase());
				}
				
				m_el.menu.addMenuItem(_global.labelVars.lbl_delete.toUpperCase());
				
				
				// Add a change-listener to catch item selections
				var changeListener = new Object();
				changeListener.change = function(event) {
			  		var item = event.menuItem;
			  		trace("Item selected:  " + item.attributes.label);
					if(item.attributes.label ==_global.labelVars.lbl_taskContext1.toUpperCase()){
						//forms
						me.showFormDialog(m_el);
					}
					if(item.attributes.label ==_global.labelVars.lbl_taskContext2.toUpperCase()){
						//groups
						me.showPoolDialog(m_el);
					}
					if(item.attributes.label ==_global.labelVars.lbl_taskContext3.toUpperCase()){
						//event
						me.showEventDialog(m_el,2);
					}
					if(item.attributes.label ==_global.labelVars.lbl_taskContext4.toUpperCase()){
						//rol
						me.showRolDialog(m_el);
					}
					if(item.attributes.label ==_global.labelVars.lbl_delete.toUpperCase()){
						//delete
						me.removeElement(m_el);
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext1.toUpperCase()){
						//iterate subProcess
						m_el.addIteration();
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext2.toUpperCase()){
						//remove iterate subProcess
						m_el.removeIteration();
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext3.toUpperCase()){
						//iterate Condition on subprocess
						me.iterateCondition(m_el);
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext4.toUpperCase()){
						//view subprocess
						me.viewSubProcess(m_el);
					}
				}
				m_el.menu.addEventListener("change", changeListener);
				
			}else{	//MENU ALREADY CREATED //add or remove items
				//trace("ALREADY CREATED MENU")
				if(m_el.m_type=="P"){
					m_el.menu.removeAll()
					if(m_el.isIterated()){
							m_el.menu.addMenuItem(_global.labelVars.lbl_processContext2.toUpperCase());
							if(_global.isAutomatic){
								m_el.menu.addMenuItem(_global.labelVars.lbl_processContext3.toUpperCase());
							}
						}else{
							m_el.menu.addMenuItem(_global.labelVars.lbl_processContext1.toUpperCase());
					}
					m_el.menu.addMenuItem(_global.labelVars.lbl_processContext4.toUpperCase());
					m_el.menu.addMenuItem(_global.labelVars.lbl_delete.toUpperCase());
				}
			}
			//SHOW MENU
			var p = {x:m_el._x,y:m_el._y + 20};
			TaskArea.localToGlobal(p);
							
			var theMenuX = Math.round(p.x);
			var theMenuY = Math.round(p.y);
		  	m_el.menu.show(theMenuX,theMenuY);
			//-----------------
			}
		}
	};
	
	function onElementRollOver(p_eventObj){
		var _mode = root.getToolMode();
		if(_mode==3){
			p_eventObj.target._alpha = 30;
		}
	};
	function onElementRollOut(p_eventObj){
		p_eventObj.target._alpha = 100;
	};
	
	function onLineClicked(p_eventObj) {
		var _mode = root.getToolMode();
		if(_mode==3){	//ERASE LINE
			this.disconectElements(p_eventObj.target);
		}
	};
	
	function onLineDblClicked(p_eventObj){
		var me = this
		var _mode = root.getToolMode();
		if(_mode==1){	//SELECT
			//------Show Menu
		var oLine = p_eventObj.target;
		  if(oLine.menu == undefined) {
				// Create a Menu instance and add some items
				oLine.menu = mx.controls.Menu.createMenu();
				
				oLine.menu.embedFonts = true;
				oLine.menu.setStyle("fontFamily","k0554");
				oLine.menu.setStyle("fontSize","8");
				oLine.menu.setStyle("rollOverColor","0xEFEFEF");
				oLine.menu.setStyle("selectionColor","0xEFEFEF");
				
				oLine.menu.addMenuItem(_global.labelVars.lbl_dependencyContext1.toUpperCase());
				oLine.menu.addMenuItem(_global.labelVars.lbl_dependencyContext2.toUpperCase());
				//oLine.menu.addMenuItem({type:"separator"});
				oLine.menu.addMenuItem(_global.labelVars.lbl_delete.toUpperCase());
				
				// Add a change-listener to catch item selections
				var changeListener = new Object();
				changeListener.change = function(event) {
			  		var item = event.menuItem;
					if(item.attributes.label ==_global.labelVars.lbl_dependencyContext1.toUpperCase()){
						//name
						me.showNameDialog(oLine);
					}
					if(item.attributes.label ==_global.labelVars.lbl_dependencyContext2.toUpperCase()){
						//condition
						me.showConditionDialog(oLine);
					}
					if(item.attributes.label ==_global.labelVars.lbl_delete.toUpperCase()){
						//delete
						me.disconectElements(oLine);
					}
	
				}
				oLine.menu.addEventListener("change", changeListener);
			}
			/*
			var mSy = oLine["theLine_mc"]._yscale;
			var mSx = oLine["theLine_mc"]._xscale;
		  	oLine.menu.show(Math.floor((oLine._x + mSx/2)), Math.floor((oLine._y + mSy/2))+ 0.5);
			*/
			var x = Math.floor(root._xmouse);
			var y = Math.floor(root._ymouse);
			oLine.menu.show(x, y);
			//-----------------
		}
	};
	
	function iterateCondition(p_obj_subprocess:MovieClip){
		showConditionDialog(p_obj_subprocess);
	};
	
	function viewSubProcess(p_obj_subprocess:MovieClip){
		root.loadSubProcess(p_obj_subprocess.m_id,p_obj_subprocess.m_name);
	};
	
	
	///////////////////////////////////////////////////
	///////////////////////////////////////////////////
	// 			MODAL DIALOGS
	/////////////////////////////////////////////////
	///////////////////////////////////////////////////
	function showFormDialog(p_task:MovieClip){
		var configOBj = new Object();
			configOBj.closeButton = true;
			configOBj.contentPath = "FormModal";
			configOBj.title = _global.labelVars.lbl_formWin.toUpperCase() + ": " + p_task.m_name;
			configOBj._width = 550;
			configOBj._height = 420;
			configOBj.entity_Array = p_task.m_entity_form_array;
			configOBj.process_Array = p_task.m_process_form_array;
			
		var objEvt = new Object();
			objEvt.ok = function(evt){
				p_task.m_entity_form_array = evt.entities;
				p_task.m_process_form_array = evt.processes;
				popUp.deletePopUp();
			}
		
		var popUp = WindowManager.popUp(configOBj);
			popUp.addEventListener("ok", objEvt);
	};
	
	function showPoolDialog(p_task){
		var configOBj = new Object();
			configOBj.closeButton = true;
			configOBj.contentPath = "PoolModal";
			configOBj.title = _global.labelVars.lbl_poolWin.toUpperCase() + ": " + p_task.m_name;
			configOBj._width = 570;
			configOBj._height = 240;
			configOBj.pool_array = p_task.m_pool_array;
	
		var objEvt = new Object();
			objEvt.ok = function(evt){
				p_task.m_pool_array = evt.pools;
				popUp.deletePopUp();
			}
		
		var popUp = WindowManager.popUp(configOBj);
			popUp.addEventListener("ok", objEvt);
	};
	
	function showNameDialog(p_line:MovieClip){
		var configOBj = new Object();
			configOBj.closeButton = true;
			configOBj.contentPath = "NameModal";
			configOBj.title = _global.labelVars.lbl_NameModalTitle.toUpperCase();
			configOBj._width = 250;
			configOBj._height = 140;
			configOBj.nameValue = p_line.getName();
			
		var objEvt = new Object();
			objEvt.ok = function(evt){
				p_line.setName(evt.name);
				popUp.deletePopUp();
			}
		
		var popUp = WindowManager.popUp(configOBj);
			popUp.addEventListener("ok", objEvt);
	};
	
	function showRolDialog(p_task){
		var configOBj = new Object();
			configOBj.closeButton = true;
			configOBj.contentPath = "RolModal";
			configOBj.title = _global.labelVars.lbl_RolModalTitle.toUpperCase() + ": " + p_task.m_name;
			configOBj._width = 290;
			configOBj._height = 220;
		
		var objEvt = new Object();
			objEvt.ok = function(evt){
				if(evt.rol.id!="empty"){
					p_task.addRol(evt.rol.id,evt.rol.label);
				}else{
					p_task.removeRol();
				}
				popUp.deletePopUp();
			}
			
		var popUp = WindowManager.popUp(configOBj);
			popUp.addEventListener("ok", objEvt);

	};
	
	function showConditionDialog(p_obj:MovieClip){
		var configOBj = new Object();
			configOBj.closeButton = true;
			configOBj.contentPath = "ConditionModal";
			configOBj.title = _global.labelVars.lbl_ConditionModalTitle.toUpperCase();
			configOBj._width = 460;
			configOBj._height = 290;
			configOBj.conditionValue = p_obj.getCondition();
		
		var objEvt = new Object();
			objEvt.ok = function(evt){
				p_obj.setCondition(evt.conditionValue);
				popUp.deletePopUp();
			}
		
		var popUp = WindowManager.popUp(configOBj);
			popUp.addEventListener("ok", objEvt);
	};
	
	
	function showEventDialog(p_task:MovieClip,p_type:Number){
		//p_type [1=Process Events][2=task events]
		var dialogTitle;
		if(p_task.m_name!=undefined){
			dialogTitle = _global.labelVars.lbl_eventWin.toUpperCase() + ": " + p_task.m_name;
		}else{
			dialogTitle = _global.labelVars.lbl_eventWin.toUpperCase();
		}
		
		var configOBj = new Object();
			configOBj.closeButton = true;
			configOBj.contentPath = "EventModal";
			configOBj.title = dialogTitle;
			configOBj._width = 500;
			configOBj._height = 310;
			configOBj.events_array = p_task.m_events_array;
			configOBj.p_type = p_type;
	
		var objEvt = new Object();
			objEvt.ok = function(evt){
				p_task.m_events_array = evt.events;
				popUp.deletePopUp();
			}
		
		var popUp = WindowManager.popUp(configOBj);
			popUp.addEventListener("ok", objEvt);
	};
	
	
	///////////////////////////////////////////////////
	// 			TEMPS
	/////////////////////////////////////////////////
	function getElement(elementId:Number){
		return TaskArea["El_" + elementId];
	};
	
	function getLine(lineId:Number,vertex:Number){
		return LineArea["LineObj_" + lineId + "_" + vertex];
	};

	
}




