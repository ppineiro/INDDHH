
import mx.controls.Alert;
import mx.controls.Button;
import com.st.process.controller.Process;
import com.st.process.model.ProcessModel;
import com.st.util.Screen_Navigator;

import flash.display.BitmapData;


class com.st.process.view.ProcessView{
	// Internal properties
	private var __controller:Process;
	private var __model:ProcessModel;
	
	var hasEntParams=false;
	
	private var __Back:MovieClip;
	private var __Map:MovieClip;
	private var __TaskArea:MovieClip;
	private var __LineArea:MovieClip;
	private var __TempLine:MovieClip;
	private var __ToolBar:MovieClip;
	private var __ToolPanel:MovieClip;
	private var __bar_mc:MovieClip;
	private var screenNavigator:MovieClip;
	
	private var __ToolBarBtns:Number;
	private var __ToolIndex:Number;
	
//	private var mouseListener:Object;
	private var stageListener:Object;
	
	private var __CursorDelete:MovieClip;
	private var __CursorAdd:MovieClip;
	private var __CursorCross:MovieClip;
	
	
	private var __ViewMenuColl:Array;
	private var el_selectedId:Number;
	private var line_selected:MovieClip;
	
	private var connTo:Number = null;
	private var connFrom:Number = null;
	private var rolClicked:Boolean=false;
	
	var bckground:MovieClip;
	public function ProcessView(mainMc:MovieClip, controller:Process, model:ProcessModel) {
		_global.__pannedX=0;
		_global.__pannedY=0;
		_global.__zoomed=1;
		__Back=mainMc;
		bckground=__Back.attachMovie("back","atras",0,{_height:1800,_width:2400});
		__controller = controller;
		__model = model;
		__model.addListener(this);
		if(!_global.ReadOnly){
		initUIControls();
		}
		initFlowView();
		var sh=(Math.round(Stage.height))
		screenNavigator = mainMc.attachMovie("Screen_Navigator","screenNavigator",25);
		screenNavigator._y=((sh - screenNavigator._height)- 4);
		screenNavigator.init(__Back,this);
	};
	
	public function onReset():Void {
		__controller.getProcessDefinition();
	};
	
	
	private function initUIControls(){
		if(!(_global.entParams=="" || _global.entParams==null || _global.entParams==undefined)){
			hasEntParams=true;
		}
		
		
		var tmp = this;
		var center_x = Math.round(Stage.width/2);
		var center_y = Math.round(Stage.height/2);
		//__bar_mc = _root.attachMovie("bar","__bar_mc",4000,{_x:center_x,_y:center_y});
		__ToolBarBtns = 4;
		__ToolBar = _root.attachMovie("ToolBarSmall","ToolBar",10,{_x:4,_y:4});
		__ToolBar.view = this;
		__ToolBar.drag_mc.onPress = function(){this._parent.startDrag();}
		__ToolBar.drag_mc.onRelease = __ToolBar.drag_mc.onReleaseOutside = function(){this._parent.stopDrag();}
		
		__ToolBar.btn1.clickHandler = function(eventObj) {this._parent.view.updateToolBarButton(this,1);}
		__ToolBar.btn2.clickHandler = function(eventObj) {this._parent.view.updateToolBarButton(this,2);}
		__ToolBar.btn3.clickHandler = function(eventObj) {this._parent.view.updateToolBarButton(this,3);}
		__ToolBar.btn4.clickHandler = function(eventObj) {
		_global.printIt();
		this._parent.view.updateToolBarButton(this,1);
		this._parent.btn4.selected=false;
		this._parent.btn1.selected=true;}
		__ToolIndex = 1;
		
		setElementMenus();

		 __CursorDelete = _root.attachMovie("cursor_delete","cursor_delete",5000,{_visible:false});
		 __CursorAdd = _root.attachMovie("cursor_add","cursor_add",5001,{_visible:false});
		 __CursorCross = _root.attachMovie("cursor_cross","cursor_cross",5002,{_visible:false});

		//----------------------------------------------
		//LOAD TOOLPANEL SWF
		//----------------------------------------------
		
		var myListener:Object = new Object();
			myListener.onLoadStart = function(target_mc:MovieClip) {}
			myListener.onLoadProgress = function(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number) {
				trace("toolPanel : " + loadedBytes)
			}
			myListener.onLoadComplete = function(target_mc:MovieClip) {
				target_mc.view = tmp;
				target_mc.model = tmp.__model;
				target_mc.taskArea = tmp.__TaskArea;
			}
			myListener.onLoadInit = function(target_mc:MovieClip) {
				target_mc.init();
			}
		
		var my_mcl:MovieClipLoader = new MovieClipLoader();
			my_mcl.addListener(myListener);
		
		__ToolPanel = _root.createEmptyMovieClip("__ToolPanel", _root.getNextHighestDepth());
		__ToolPanel._x = 550;
		__ToolPanel._y = 50;
		my_mcl.loadClip(_global.SWF_OBJ_PATH + "ToolPanel.swf", __ToolPanel);
		__ToolPanel.setView(this);
		
		
		//----------------------------------------------
		//LOAD DIALOG SWF
		//----------------------------------------------
		var DlgListener:Object = new Object();
			DlgListener.onLoadStart = function(target_mc:MovieClip) {trace("LOADING DIALOGS")}
			DlgListener.onLoadProgress = function(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number) {
				trace("LOADING DIALOGS:" + loadedBytes)
			}
			DlgListener.onLoadComplete = function(target_mc:MovieClip) {}
			DlgListener.onLoadInit = function(target_mc:MovieClip) {
				target_mc.init(tmp.__controller,tmp.__model);
			}
		
		var form_loader:MovieClipLoader = new MovieClipLoader();
			form_loader.addListener(DlgListener);
			//load dialogs.swf in _level5
			form_loader.loadClip(_global.SWF_OBJ_PATH + "Dialogs.swf", 5);
		//------------------------------------------------
		//------------------------------------------------
		
		//----------------------------------------------
		//LOAD ATT MODAL SWF
		//----------------------------------------------
		var attLoadListener:Object = new Object();
			attLoadListener.onLoadStart = function(target_mc:MovieClip) {trace("LOADING ATT MODAL")}
			attLoadListener.onLoadProgress = function(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number) {
				trace("LOADING ATT MODAL:" + loadedBytes)
			}
			attLoadListener.onLoadComplete = function(target_mc:MovieClip) {}
			attLoadListener.onLoadInit = function(target_mc:MovieClip) {
				target_mc.init(tmp.__controller,tmp.__model);
			}
	
		var att_loader:MovieClipLoader = new MovieClipLoader();
			att_loader.addListener(attLoadListener);
			//load dialogs.swf in _level6
			att_loader.loadClip(_global.SWF_OBJ_PATH + "AttributesDialog.swf", 6);
		//------------------------------------------------

		//----------------------------------------------
		//LOAD EVT SWF
		//----------------------------------------------
		var evtLoadListener:Object = new Object();
			evtLoadListener.onLoadStart = function(target_mc:MovieClip) {trace("LOADING EVT MODAL")}
			evtLoadListener.onLoadProgress = function(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number) {
				trace("LOADING EVT MODAL:" + loadedBytes)
			}
			evtLoadListener.onLoadComplete = function(target_mc:MovieClip) {}
			evtLoadListener.onLoadInit = function(target_mc:MovieClip) {
				target_mc.init(tmp.__controller,tmp.__model);
			}
	
		var evt_loader:MovieClipLoader = new MovieClipLoader();
			evt_loader.addListener(evtLoadListener);
			//load dialogs.swf in _level7
			evt_loader.loadClip(_global.SWF_OBJ_PATH + "EvtDialog.swf", 4);
		
		
		
		//-----------------------------------------------
		// register mouse evts
		var x:Number;
		var y:Number;
		var flag1:Boolean=false;
		bckground.useHandCursor=false;
		
		bckground.onPress= function(){
			if(!flag1){
				flag1=true;
				x=_root._xmouse;
				y=_root._ymouse;
				}else{
					flag1=false;
				}
			}
		
		
		
		bckground.onRelease= function(){
			flag1=false;
			if(tmp.__ToolIndex==2){	//	cross cursor
				if(!tmp.__TaskArea.hitTest(_root._xmouse,_root._ymouse,1)){
					tmp.hideConnect();
				}
			}
			if(tmp.__ToolIndex==1){	//	Select[SHOWMENU]
				if((!tmp.__TaskArea.hitTest(_root._xmouse,_root._ymouse,1)) &&
					(!tmp.__LineArea.hitTest(_root._xmouse,_root._ymouse,1))&&
					(!tmp.__ToolBar.hitTest(_root._xmouse,_root._ymouse,1))&&
					(!tmp.screenNavigator.hitTest(_root._xmouse,_root._ymouse,1))&&
					(!__ToolPanel.hitTest2())){
					//show BG Menu
					//if (Key.isDown(Key.ALT)) {	//ALT + CLICK = show menu
					if(x==_root._xmouse && y==_root._ymouse){
						var p = {x:_root._xmouse,y:_root._ymouse};
						//tmp.__TaskArea.localToGlobal(p);
						var menuX = Math.round(p.x);
						var menuY = Math.round(p.y);
						tmp.__TaskArea.menu.show(menuX,menuY);
					}
				}
			}
		}
		stageListener = {};
		stageListener.onResize = function(){
			tmp.onStageResize();
		}
		Stage.addListener(stageListener);
		
		//------------------------------------------------
	};
	
	private function initFlowView():Void {
		__Map = _root.createEmptyMovieClip("Map",5);
		__TempLine = _root.attachMovie("TempLine","TempLine",2,{_visible:false});
		__LineArea = __Map.createEmptyMovieClip("lineArea",1)
		__TaskArea = __Map.createEmptyMovieClip("taskArea",2);
		__TaskArea.menu = __ViewMenuColl[5];
		
	};
	
	private function updateToolBarButton(btnObj:Button,btnIndex:Number){
		hideConnect();
		for(var e=0; e < __ToolBarBtns; e++){
			__ToolBar["btn" + (e+1)].selected = false;
		}
		btnObj.selected = true;
		__ToolIndex = btnIndex;
		
		__CursorAdd.onMouseMove = null;
		__CursorDelete.onMouseMove = null;
		__CursorCross.onMouseMove = null;
		
		var tmpThis = this;
		
		if(__ToolIndex==2){	//	cross cursor - line
			__CursorCross.onMouseMove = function(){
				tmpThis.setToolCursor(this);
			}
		}else if(__ToolIndex==3){	//delete cursor
			__CursorDelete.onMouseMove = function(){
				tmpThis.setToolCursor(this);
			}
		}else if(__ToolIndex>3 && __ToolIndex<=9){ //add cursor
			__CursorAdd.onMouseMove = function(){
				tmpThis.setToolCursor(this);
			}
		}else{
			__CursorAdd.onMouseMove = null;
			__CursorDelete.onMouseMove = null;
			__CursorCross.onMouseMove = null;
			
			__CursorAdd._visible = false;
			__CursorDelete._visible = false;
			__CursorCross._visible = false;
			Mouse.show();
		}
	};
	
	
	
	private function setToolCursor(mouseClip:MovieClip){
		if(checkCursorMouseOver(mouseClip)){
			Mouse.hide();
			mouseClip._visible = true;
			mouseClip._x = _root._xmouse;
			mouseClip._y = _root._ymouse;
			updateAfterEvent();
		}else{
			mouseClip._visible = false;
			Mouse.show();	
		}
	};
	
	private function checkCursorMouseOver(mouseClip:MovieClip):Boolean{
		if((__ToolBar.hitTest(_root._xmouse,_root._ymouse,1)) || 
			(__ToolPanel.hitTest(_root._xmouse,_root._ymouse,1))){
			return false;
		}else{
			return true;
		}
	};
	
	//----------------------------------------------
	//	dummy line
	//----------------------------------------------
	private function showConnect(p_targetID:Number,p_target:MovieClip){
		if(connFrom != null){
			connTo = p_targetID;
			__controller.addDependency(connFrom, connTo,null,null);
			hideConnect();
		}else{
			connFrom = p_targetID;
			connTo = null;
			var p = {x:p_target._x,y:p_target._y};
			__TaskArea.localToGlobal(p);
								
			var initLinePoint_x = Math.round(p.x);
			var initLinePoint_y = Math.round(p.y);
			__TempLine.show(initLinePoint_x,initLinePoint_y);
		}
	};
	private function hideConnect(){
		__TempLine.hide();
		connTo = null;
		connFrom = null;
	};
	//----------------------------------------------
	//	element menus
	//----------------------------------------------
	private function setElementMenus(){
		var _TaskMenuItems = [_global.labelVars.lbl_taskContext1,
							  _global.labelVars.lbl_taskContext3,
							  _global.labelVars.lbl_taskContext2,
							  _global.labelVars.lbl_taskContext6,
							  _global.labelVars.lbl_taskContext5,
							  _global.labelVars.lbl_taskContext9,
							  _global.labelVars.lbl_taskContext11,
							  {label:_global.labelVars.lbl_taskContext10, type:"check", selected:true, enabled:true, instanceName:"checkHC"}];
		
		var _TaskMenuItems_SubMenu = [{label:_global.labelVars.lbl_taskContext7, enabled:this.hasEntParams},
									  _global.labelVars.lbl_taskContext8];
		
		var _EndTaskMenuItems = [_global.labelVars.lbl_endTaskContext1];
		
		var _ProcessMenuItems = [_global.labelVars.lbl_processContext4,
				{label:_global.labelVars.lbl_processContext1, type:"check", selected:true, enabled:true, instanceName:"checkIterate"},
				{label:_global.labelVars.lbl_processContext3,enabled:false},
				_global.labelVars.lbl_processContext6,
				{label:_global.labelVars.lbl_processContext7,enabled:false},
				_global.labelVars.lbl_processContext5,
				_global.labelVars.lbl_processContext13];
		
		var _ProcessType_SubMenu = [
				{label:_global.labelVars.lbl_processContext8, type:"radio", enabled:true, selected:true, groupName:"processType", instanceName:"t_map"},
				{label:_global.labelVars.lbl_processContext9, type:"radio", enabled:true, selected:false, groupName:"processType", instanceName:"t_ssync"},
				{label:_global.labelVars.lbl_processContext10, type:"radio", enabled:true, selected:false, groupName:"processType", instanceName:"t_sync"},
				{label:_global.labelVars.lbl_processContext11, type:"radio", enabled:true, selected:false, groupName:"processType", instanceName:"t_A"},
				{label:_global.labelVars.lbl_processContext12, type:"radio", enabled:true, selected:false, groupName:"processType", instanceName:"t_B"}];
		
		var _OperatorMenuItems = [_global.labelVars.lbl_opContext1];
		
		var _DependancyMenuItems = [_global.labelVars.lbl_dependencyContext1, 
				_global.labelVars.lbl_dependencyContext2, 
				{label:_global.labelVars.lbl_dependencyContext3, type:"check", selected:true, enabled:true, instanceName:"checkWizard"},
				{label:_global.labelVars.lbl_dependencyContext5, type:"check", selected:true, enabled:true, instanceName:"checkLoop"},
				_global.labelVars.lbl_dependencyContext4];
		
		var _TaskAreaMenuItems = [_global.labelVars.lbl_mapContext,
								  _global.labelVars.lbl_cleanProcess,
								  _global.labelVars.lbl_mapContext2
								  /*_global.labelVars.lbl_printProcess*/];
		
		var menusItems = [_TaskMenuItems,_EndTaskMenuItems,_ProcessMenuItems,_OperatorMenuItems,_DependancyMenuItems,_TaskAreaMenuItems];
		__ViewMenuColl = [];
		
		
		for(var e=0;e<menusItems.length;e++){
			var m = mx.controls.Menu.createMenu();
				m.setStyle("fontFamily","Verdana");
				m.setStyle("fontSize","10");
				m.setStyle("backgroundColor","0xFEFEFE");
			
			for(var z=0;z<menusItems[e].length;z++){
				m.addMenuItem(menusItems[e][z]);
			}
			
			if(e==2){
				//ADD SUB TO process menu
				var itemType = m.getMenuItemAt(3);
				for(var d=0;d< _ProcessType_SubMenu.length;d++){
					itemType.addMenuItem(_ProcessType_SubMenu[d]);
				}
			}	
			
			if(e==0){
				//ADD SUB TO task menu
				var itemType = m.getMenuItemAt(1);
				for(var d=0;d< _TaskMenuItems_SubMenu.length;d++){
					itemType.addMenuItem(_TaskMenuItems_SubMenu[d]);
				}
			}
			__ViewMenuColl[e] = m;
			
			/*
			//MENU EVENTS - SHOW
			var listenerObject = new Object();
				listenerObject.menuShow  = function(eventObject){
				}
			__ViewMenuColl[e].addEventListener("menuShow", listenerObject)
			*/
			//MENU EVENTS - CHANGE
			var tmpThis = this;
			var changeListener = new Object();
				changeListener.change = function(event) {
			  		var item = event.menuItem;
					var el_att_id = tmpThis.getElementSelectedId();
					
					//PROCESS BACKGROUND
					if(item.attributes.label == _global.labelVars.lbl_mapContext2){
						trace(">>> _level4.showProcessEvtDialog();");
						_level5.showProcWSDialog();
					}
					if(item.attributes.label == _global.labelVars.lbl_mapContext){
						_level4.showProcessEvtDialog();
					}
					if(item.attributes.label == _global.labelVars.lbl_cleanProcess){
						trace(">>> CLEAN MODEL");
						var myClickHandler:Function = function (evt_obj:Object) {
						if (evt_obj.detail == Alert.OK) {
							tmpThis.__model.cleanModel();
						}
					}
						var dialog_obj:Object = Alert.show( _global.labelVars.lbl_PrcInitQ,"INIT", Alert.OK | Alert.CANCEL, null, myClickHandler, "testIcon", Alert.OK);
					}
					if(item.attributes.label == _global.labelVars.lbl_printProcess){
						tmpThis.printJob();
					}
					//TASK
					if(item.attributes.label == _global.labelVars.lbl_taskContext5){
						tmpThis.__controller.removeElement(el_att_id);
					}
					if(item.attributes.label == _global.labelVars.lbl_taskContext1){
						_level5.showFormsDialog(el_att_id);
					}
					if(item.attributes.label == _global.labelVars.lbl_taskContext7){
						_level4.showEvtStatesDialog(el_att_id);						
					}
					if(item.attributes.label == _global.labelVars.lbl_taskContext8){
						_level4.showEvtDialog(el_att_id);
					}
					if(item.attributes.label == _global.labelVars.lbl_taskContext2){
						_level5.showPoolsDialog(el_att_id);
					}
					if(item.attributes.label == _global.labelVars.lbl_taskContext6){
						_level5.showTaskPrpDialog(el_att_id);
					}
					if(item.attributes.label == _global.labelVars.lbl_taskContext9){
						_level5.showTaskWSDialog(el_att_id);
					}
					if(item.attributes.label == _global.labelVars.lbl_taskContext10){
						if(item.attributes.selected){
							tmpThis.__controller.taskHighlightComments(el_att_id,true);
						}else{
							tmpThis.__controller.taskHighlightComments(el_att_id,false);
						}
					}
					if(item.attributes.label == _global.labelVars.lbl_taskContext11){
						_level5.showTaskCalDialog(el_att_id);
					}
					//PROCESS
					if(item.attributes.label == _global.labelVars.lbl_processContext5){
						tmpThis.__controller.removeElement(el_att_id);
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext13){
						_level5.showProcessPrpDialog(el_att_id);
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext4){
						fscommand("viewProcess",tmpThis.__model.getProcessId(el_att_id));
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext1){
						if(item.attributes.selected){
							tmpThis.__controller.processElementIterate(el_att_id,true);
						}else{
							tmpThis.__controller.processElementIterate(el_att_id,false);
						}
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext3){
						_level5.showProcessCondition(el_att_id);
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext7){
						_level5.showProcessFormsDialog(el_att_id);
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext8){
						//trace(">>>>>>>>><<<<" + item.attributes.selected)
						tmpThis.__controller.setProcessElementType(el_att_id,"m");
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext9){
						//s radio on
						tmpThis.__controller.setProcessElementType(el_att_id,"a");
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext10){
						//s radio on
						tmpThis.__controller.setProcessElementType(el_att_id,"s");
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext11){
						//s radio on
						tmpThis.__controller.setProcessElementType(el_att_id,"k");
					}
					if(item.attributes.label == _global.labelVars.lbl_processContext12){
						//s radio on
						tmpThis.__controller.setProcessElementType(el_att_id,"j");
					}							
					//OPERATOR
					if(item.attributes.label == _global.labelVars.lbl_opContext1){
						tmpThis.__controller.removeElement(el_att_id);
					}
					//END TASK
					if(item.attributes.label == _global.labelVars.lbl_endTaskContext1){
						tmpThis.__controller.removeElement(el_att_id);
					}
					//DEPENDENCIES
					if(item.attributes.label == _global.labelVars.lbl_dependencyContext4){
						var oLine:MovieClip = tmpThis.getLineSelected();
						var startId:Number = oLine.m_startPoint;
						var endId:Number = oLine.m_endPoint;
						tmpThis.deleteLine(startId,endId);
					}
					if(item.attributes.label == _global.labelVars.lbl_dependencyContext1){
						var oLine:MovieClip = tmpThis.getLineSelected();
						var startId:Number = oLine.m_startPoint;
						var endId:Number = oLine.m_endPoint;
						_level5.showNamesDialog(startId,endId);
					}
					if(item.attributes.label == _global.labelVars.lbl_dependencyContext2){
						var oLine:MovieClip = tmpThis.getLineSelected();
						var startId:Number = oLine.m_startPoint;
						var endId:Number = oLine.m_endPoint;
						_level5.showDependencyCondition(startId,endId);
					}
					if(item.attributes.label == _global.labelVars.lbl_dependencyContext3){
						var oLine:MovieClip = tmpThis.getLineSelected();
						var startId:Number = oLine.m_startPoint;
						var endId:Number = oLine.m_endPoint;
						if(item.attributes.selected){
							//TAKE_NEXT=true
							tmpThis.__controller.dependencyAsWizard(startId,endId,true);
						}else{
							//TAKE_NEXT=false
							tmpThis.__controller.dependencyAsWizard(startId,endId,false);
						}
					}
					
					if(item.attributes.label == _global.labelVars.lbl_dependencyContext5){
						var oLine:MovieClip = tmpThis.getLineSelected();
						var startId:Number = oLine.m_startPoint;
						var endId:Number = oLine.m_endPoint;
						if(item.attributes.selected){
							//LOOPBACK=true
							tmpThis.__controller.dependencyLoopBack(startId,endId,true);
						}else{
							//LOOPBACK=false
							tmpThis.__controller.dependencyLoopBack(startId,endId,false);
						}
					}
					
				}
			__ViewMenuColl[e].addEventListener("change", changeListener);
	
		}
	};
	
	
	/////////////////////////////////////////////////////////////////
	// MODEL EVTs
	//////////////////////////////////////////////////////////////////
	public function onTaskAdded(att_id:Number,att_label:String,x:Number,y:Number):Void {
		var mc = attachElement("Task",att_id,{att_id:att_id,att_label:att_label,_x:x,_y:y});
			mc.menu = __ViewMenuColl[0];
	};
	public function onCustomTaskAdded(att_id:Number,att_label:String,x:Number,y:Number,imgName:String):Void {
		var mc = attachElement("Task",att_id,{att_id:att_id,att_label:att_label,_x:x,_y:y});
			mc.addImage(imgName);
			mc.menu = __ViewMenuColl[0];
	};
	public function onInitTaskAdded(att_id:Number,att_label:String,x:Number,y:Number):Void {
		var mc = attachElement("InitTask",att_id,{att_id:att_id,att_label:att_label,_x:x,_y:y});
	};
	
	public function onEndTaskAdded(att_id:Number,att_label:String,x:Number,y:Number):Void {
		var mc = attachElement("EndTask",att_id,{att_id:att_id,att_label:att_label,_x:x,_y:y});
			mc.menu = __ViewMenuColl[1];
	};
	
	public function onProcessAdded(att_id:Number,att_label:String,x:Number,y:Number):Void {
		var mc = attachElement("SubProcess",att_id,{att_id:att_id,att_label:att_label,_x:x,_y:y});
		mc.menu = __ViewMenuColl[2];
	};
	
	public function onOperatorAdded(att_id:Number,att_ope_id:Number,x:Number,y:Number):Void {
		var mc = attachElement("Operator",att_id,{att_id:att_id,att_ope_id:att_ope_id,_x:x,_y:y});
			mc.menu = __ViewMenuColl[3];
	};
	
	private function attachElement(mc_type,mc_id,att_params):MovieClip{
		var aux = __TaskArea.attachMovie(mc_type, 'El_' + mc_id, 
						getTaskElementNextHighestDepth(),
						att_params);
			
			//aux.view = this;
			aux.addEventListener("onElementMoved",this);
			aux.addEventListener("onElementClick",this);
			aux.addEventListener("onElementClicked",this);
			aux.addEventListener("onRolClicked",this);
			aux.addEventListener("onElementRollOver",this);
			aux.addEventListener("onElementRollOut",this);
			aux.addEventListener("onRolRollOver",this);
			aux.addEventListener("onRolRollOut",this);
			
		return aux;
	};
	
	private function getTaskElementNextHighestDepth():Number{
		var nextDepth = __TaskArea.getNextHighestDepth(); 
		return nextDepth;
	};
	
	private function getElementSelectedId():Number{
		return el_selectedId;
	};
	
	private function getElement(att_id:Number):MovieClip{
		return __TaskArea["El_" + att_id];
	}
	
	/////////////////////////////////////////////////////////////////
	// ELEMENTS EVTs
	//////////////////////////////////////////////////////////////////
	var x:Number;
	var y:Number;
	var flag2:Boolean=false;
	private function onElementClick(){
		if(!flag2){
		flag2=true;
		x=_root._xmouse;
		y=_root._ymouse;
		}else{
			flag2=false;
		}
		}
	

	private function onElementClicked(eventObj:Object):Void{
		var m_el = eventObj.target;
		var easeType = mx.transitions.easing.Regular.easeInOut;
		var a:Object;
		
		//Select element o multiple
		el_selectedId = m_el.att_id;
		//if(m_el._x>(Stage.width*2.9)){
		if(m_el._x>(2300)){
			a=new mx.transitions.Tween(m_el, "_x", easeType, m_el._x, 2300, (1/2), true);
			//m_el._x=2300;
		}
		if(m_el._x<0){
			a=new mx.transitions.Tween(m_el, "_x", easeType, m_el._x, 10, (1/2), true);
			//m_el._x=10;
		}
		//if(m_el._y>(Stage.height*2.9)){
		if(m_el._y>1750){
			a=new mx.transitions.Tween(m_el, "_y", easeType, m_el._y, 1750, (1/2), true);
			//m_el._y=1750;
		}
		if(m_el._y<0){
			a=new mx.transitions.Tween(m_el, "_y", easeType, m_el._y, 10, (1/2), true);
		}
		a.onMotionChanged=function(){
			m_el.dispatchEvent({type:"onElementMoved"});
		}
		switch(__ToolIndex){
			case 1:	//select Cursor
				m_el.__allowMoving = true;
				
				//if (Key.isDown(Key.ALT)) {	//ALT + CLICK = show menu
				if((x==_root._xmouse && y==_root._ymouse)){
					var p = {x:m_el._x + 24,y:m_el._y};
					__TaskArea.localToGlobal(p);
					var menuX = Math.round(p.x);
					var menuY = Math.round(p.y);
					
					if(__model.getElementType(el_selectedId)=="P"){
						//UPDATE MENU CHECKBOX ITEM STATE [iterate process]
						var chkIterateState:Boolean = __model.isProcessIterated(el_selectedId);
						var itemIterate = m_el.menu.getMenuItemAt(1);
						m_el.menu.setMenuItemSelected(itemIterate, chkIterateState);
						//trace(itemIterate.attributes.label + " : " + itemIterate.attributes.selected);
						
						var itemProIterateCondition = m_el.menu.getMenuItemAt(2);
						if(chkIterateState){
							m_el.menu.setMenuItemEnabled(itemProIterateCondition, true);
						}else{
							m_el.menu.setMenuItemEnabled(itemProIterateCondition, false);
						}
						
						
						//UPDATE MENU RADIO ITEM STATE [process type]
						var processCurrentType:String = __model.getProcessType(el_selectedId)
						var itemType = m_el.menu.getMenuItemAt(3);
						//trace("RADIO:" + itemType.getMenuItemAt(0).attributes.label + " --> " + itemType.getMenuItemAt(0).attributes.selected)
						//trace("TYPE_VALUE: " + processCurrentType);
						
						//enable or diabled process-forms menu item
						var itemProForms = m_el.menu.getMenuItemAt(4);
						
						switch(processCurrentType){
							case "m": 
								m_el.menu.setMenuItemSelected(itemType.getMenuItemAt(0),true);
								m_el.menu.setMenuItemEnabled(itemProForms, false);
							break;
							case "a": 
								m_el.menu.setMenuItemSelected(itemType.getMenuItemAt(1),true);
								m_el.menu.setMenuItemEnabled(itemProForms, true);
							break;
							case "s": 
								m_el.menu.setMenuItemSelected(itemType.getMenuItemAt(2),true);
								m_el.menu.setMenuItemEnabled(itemProForms, true);
							break;
							case "j": 
								m_el.menu.setMenuItemSelected(itemType.getMenuItemAt(4),true);
								m_el.menu.setMenuItemEnabled(itemProForms, true);
							break;
							case "k": 
								m_el.menu.setMenuItemSelected(itemType.getMenuItemAt(3),true);
								m_el.menu.setMenuItemEnabled(itemProForms, true);
							break;
							default:
								//trace("default_process_type")
								m_el.menu.setMenuItemSelected(itemType.getMenuItemAt(0),true);
								m_el.menu.setMenuItemEnabled(itemProForms, false);
						}
					}
					if(__model.getElementType(el_selectedId)=="T"){
						var chkHCState:Boolean = __model.isTaskHighlightComments(el_selectedId);
						var itemHC = m_el.menu.getMenuItemAt(6);
						m_el.menu.setMenuItemSelected(itemHC, chkHCState);
					}
					//SHOW MENU
					m_el.menu.show(menuX,menuY);
				}
			break;
			
			case 2:  //line Cursor [CONNECT TASKS]
				showConnect(el_selectedId, m_el);
			break;
			
			case 3: //delete Cursor [DELETE TASKS]
				if(!this.rolClicked){
					m_el.removeMouseListener();
					__controller.removeElement(el_selectedId);
				}else{
					this.rolClicked=false;
				}
			break;
		}
		
	};
	
	private function onRolClicked(eventObj:Object):Void{
		rolClicked=true;
		//trace(eventObj.rolmc._name)
		var m_el = eventObj.target;
		if(__ToolIndex==3){ //delete Cursor
			m_el.removeMouseListener();
			__controller.removeRol(m_el.att_id);
		}
	};
	
	private function onElementMoved(eventObj:Object):Void{
		var m_el = eventObj.target;
		__controller.setElementPos(m_el.att_id,m_el._x,m_el._y);
	};
	
	private function onElementRollOver(eventObj:Object):Void{
		var m_el = eventObj.target;
		if(__ToolIndex==3){ //delete Cursor
			m_el._alpha = 40;
		}
	};
	private function onElementRollOut(eventObj:Object):Void{
		var m_el = eventObj.target;
		if(__ToolIndex==3){ //delete Cursor
			m_el._alpha = 100;
		}
	};
	private function onRolRollOver(eventObj:Object):Void{
		var m_el = eventObj.target;
		if(__ToolIndex==3){ //delete Cursor
			eventObj.rolmc._alpha = 30;
		}
	};
	
	private function onRolRollOut(eventObj:Object):Void{
		var m_el = eventObj.target;
		if(__ToolIndex==3){ //delete Cursor
			eventObj.rolmc._alpha = 100;
		}
	};
	
	public function onElementRemoved(att_id:Number){
		var eleObj:MovieClip = getElement(att_id);
			eleObj.removeEventListener("onElementMoved",this);
			eleObj.removeEventListener("onElementClick",this);
			eleObj.removeEventListener("onElementClicked",this);
			eleObj.removeEventListener("onElementRollOver",this);
			eleObj.removeEventListener("onElementRollOut",this);
			eleObj.removeEventListener("onRolClicked",this);
			eleObj.removeEventListener("onRolRollOver",this);
			eleObj.removeEventListener("onRolRollOut",this);
			eleObj.remove();
	};
	
	
	
	public function onLineAdded(startId:Number,endId:Number):Void{
		var nextDepth = __LineArea.getNextHighestDepth();
		var aux = __LineArea.attachMovie("LineObj", 'LineObj_' + startId + "_" + endId, nextDepth, {
			m_startPoint:startId,
			m_endPoint:endId,
			m_startElementMc: __TaskArea["El_" + startId],
			m_endElementMc: __TaskArea["El_" + endId]
			});
			aux.addEventListener("onLineClick",this);
			aux.addEventListener("onLineClicked",this);
			aux.addEventListener("onElementRollOver",this);
			aux.addEventListener("onElementRollOut",this);
			aux.addEventListener("onLineDelete",this);
			
			aux.menu = __ViewMenuColl[4];
	};
	
	var lx:Number;
	var ly:Number;
	
	var flag:Boolean=false;
	private function onLineClick(){
		if(!flag){
		flag=true;
		lx=_root._xmouse;
		ly=_root._ymouse;
		}else{
			flag=false;
		}
	}
	
	private function onLineClicked(eventObj:Object):Void{
		var m_el = eventObj.target;
		var tmp = this;
		flag=false;
		//Select line o multiple
		line_selected = m_el;
		
		if(__ToolIndex==1){ //select Cursor
//			if (Key.isDown(Key.ALT)) {	//show menu
			if((lx==_root._xmouse && ly==_root._ymouse)){
				var x = Math.floor(_root._xmouse);
				var y = Math.floor(_root._ymouse);
				
				var startId = m_el.m_startPoint;
				var endId = m_el.m_endPoint;
				
				var chkIsTakeNextState:Boolean = __model.isWizard(startId,endId)
				var chkIsLoopedState:Boolean = __model.isLooped(startId,endId)
				
				//UPDATE MENU CHECKBOX ITEM STATE for line [as wizard]
				var itemTN = m_el.menu.getMenuItemAt(2);
				m_el.menu.setMenuItemSelected(itemTN, chkIsTakeNextState);
				
				//UPDATE MENU CHECKBOX ITEM STATE for line [LOOPBACK]
				var itemLB = m_el.menu.getMenuItemAt(3);
				m_el.menu.setMenuItemSelected(itemLB, chkIsLoopedState);
				
				//show
				m_el.menu.show(x, y);
			}
		}
		if(__ToolIndex==3){ //delete Cursor
			var startId = m_el.m_startPoint;
			var endId = m_el.m_endPoint;
			tmp.deleteLine(startId,endId);
		}
	};
	
	private function getLineSelected():MovieClip{
		return line_selected;
	};
	
	public function getLine(startId:Number,endId:Number):MovieClip{
		return __LineArea["LineObj_" + startId + "_" + endId];
	};
	
	public function onLineDelete(eventObj:Object){
		var lineObj = eventObj.target;
		var startId = lineObj.m_startPoint;
		var endId = lineObj.m_endPoint;
		deleteLine(startId,endId);
	};
	
	public function deleteLine(startId:Number,endId:Number):Void{
		__controller.removeDependency(startId,endId);
	};
	
	public function onLineRemoved(startId:Number,endId:Number){
		var lineObj:MovieClip = getLine(startId,endId);
			lineObj.removeEventListener("onLineClick",this);
			lineObj.removeEventListener("onLineClicked",this);
			lineObj.removeEventListener("onLineDblClicked",this);
			lineObj.removeEventListener("onElementRollOver",this);
			lineObj.removeEventListener("onElementRollOut",this);
			lineObj.remove();
	};

	
	public function onTaskRolAdded(att_id:Number,rolName:String):Void{
		var oTask:MovieClip = getElement(att_id);
			oTask.showRol(rolName);
	};
	public function onTaskRolRemoved(att_id:Number):Void{
		var oTask:MovieClip = getElement(att_id);
			oTask.hideRol();
	};
	
	public function onDependencyNameAdded(startId:Number,endId:Number,name:String):Void{
		var oLine:MovieClip = getLine(startId,endId);
			oLine.showName(name);
	};
	
	public function onDependencyNameRemoved(startId:Number,endId:Number):Void{
		var oLine:MovieClip = getLine(startId,endId);
			oLine.hideName();
	};
	
	public function onDependencyConditionAdded(startId:Number,endId:Number,condition:String):Void{
		var oLine:MovieClip = getLine(startId,endId);
			oLine.showCondition(condition);
	};
	public function onDependencyConditionRemoved(startId:Number,endId:Number):Void{
		var oLine:MovieClip = getLine(startId,endId);
			oLine.hideCondition();
	};
	
	public function onDependencyWizard(startId:Number,endId:Number,isWizard:Boolean):Void{
		var oLine:MovieClip = getLine(startId,endId);
			oLine.setAsWizard(isWizard);
	};
	
	public function onDependencyLoopBack(startId:Number,endId:Number,loop_back:Boolean):Void{
		var oLine:MovieClip = getLine(startId,endId);
			oLine.loopBack(loop_back);
	};
	
	public function onIterateProcess(att_id:Number,iterate:Boolean):Void{
		var oSubPro:MovieClip = getElement(att_id);
			oSubPro.iterate(iterate);
	};
	
	public function onIterateProcessCondition(att_id:Number,condition_flag:Boolean):Void{
		var oSubPro:MovieClip = getElement(att_id);
			oSubPro.setCondition(condition_flag);
	};
	
	public function onProcessTypeChanged(att_id:Number,att_pro_type:String):Void{
		var oSubPro:MovieClip = getElement(att_id);
			oSubPro.setType(att_pro_type);
	};
	
	function setZoom(p_percent){
	//flowManager.Map._xscale = p_percent;
	//flowManager.Map._yscale = p_percent;
	//flowManager.Map.Bounds._xscale = p_percent;
	
	var num:Number;
	
	switch(p_percent){
		case 100:
		num=1;
		break;
		case 50:
		num=2;
		break;
		case 25:
		num=4;
		break;
	}
	_global.__zoomed=num;
	__TaskArea._xscale = p_percent;
	__TaskArea._yscale = p_percent;
	__LineArea._xscale = p_percent;
	__LineArea._yscale = p_percent;
	setPanning(0,0)
	};
	
	function setPanning(x,y){
	//trace("pan x:" + x + "  pan y:" + y);
	_global.__pannedX=-x;
	_global.__pannedY=-y;
	__TaskArea._x = x;
	__LineArea._x = x;
	__TaskArea._y = y;
	__LineArea._y = y;

	updateAfterEvent();
};
	
	private function onStageResize():Void{
		var s_w = Math.round(Stage.width);
		var s_h = Math.round(Stage.height);
		trace("RESIZE_UI")
		screenNavigator._x = 4;
		screenNavigator._y = (s_h - screenNavigator._height)- 4;
		__ToolPanel._x = (s_w - __ToolPanel._width)-2;
		__ToolPanel._y = 2;

	};
	
	public function printJob(){		
		_global.printIt();
		}
	
	public function setHasEntParams(){

		this.hasEntParams=true;
		var m = mx.controls.Menu.createMenu();
		m= __ViewMenuColl[0];
		var item=m.getMenuItemAt(1);
		var item2=item.getMenuItemAt(0);
		item2.attributes.enabled=true;
		item.addMenuAt(0,item2);
		m.addMenuItemAt(1,item);
		__ViewMenuColl[0]=m;
	}
	
	public function uploadProcessImage(){
		var startWidth	=__Map._width;
		var startHeight	=__Map._height;
		var trans=__Map.createEmptyMovieClip("trans",__Map.getNextHighestDepth());
		trans.moveTo(0,0);
		trans.lineStyle(1,0x000000,0);
		trans.lineTo(2,2);
		var x	=__Map._width-startWidth;
		var y	=__Map._height-startHeight;
		trans.removeMovieClip();
		_root.upload.moveAndExportToBmp(__Map,(x-1),(y-1));
	}
	
}