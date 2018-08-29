

import mx.controls.Button;
import com.st.process.controller.Process;
import com.st.process.model.ProcessModel;
import com.st.util.Screen_Navigator;
import com.st.util.WindowManager;


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
		var tmp=this;
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
		__LineArea = __Map.createEmptyMovieClip("lineArea",1);
		__TaskArea = __Map.createEmptyMovieClip("taskArea",2);
		__TaskArea.menu = __ViewMenuColl[5];
		
	};

	private function setElementMenus(){
		var _TaskMenuItems = [_global.labelVars.lbl_taskContext1,
							  _global.labelVars.lbl_taskContext3,
							  _global.labelVars.lbl_taskContext2,
							  _global.labelVars.lbl_taskContext6,
							  _global.labelVars.lbl_taskContext5];
		
		var _TaskMenuItems_SubMenu = [{label:_global.labelVars.lbl_taskContext7, enabled:this.hasEntParams},
									  _global.labelVars.lbl_taskContext8];
		
		var _EndTaskMenuItems = [_global.labelVars.lbl_endTaskContext1];
		
		var _ProcessMenuItems = [_global.labelVars.lbl_processContext4,
				{label:_global.labelVars.lbl_processContext1, type:"check", selected:true, enabled:true, instanceName:"checkIterate"},
				{label:_global.labelVars.lbl_processContext3,enabled:false},
				_global.labelVars.lbl_processContext6,
				{label:_global.labelVars.lbl_processContext7,enabled:false},
				_global.labelVars.lbl_processContext5];
		
		var _ProcessType_SubMenu = [
				{label:_global.labelVars.lbl_processContext8, type:"radio", enabled:true, selected:true, groupName:"processType", instanceName:"t_map"},
				{label:_global.labelVars.lbl_processContext9, type:"radio", enabled:true, selected:false, groupName:"processType", instanceName:"t_ssync"},
				{label:_global.labelVars.lbl_processContext10, type:"radio", enabled:true, selected:false, groupName:"processType", instanceName:"t_sync"}];
		
		var _OperatorMenuItems = [_global.labelVars.lbl_opContext1];
		
		var _DependancyMenuItems = [_global.labelVars.lbl_dependencyContext1, 
				_global.labelVars.lbl_dependencyContext2, 
				{label:_global.labelVars.lbl_dependencyContext3, type:"check", selected:true, enabled:true, instanceName:"checkWizard"},
				{label:_global.labelVars.lbl_dependencyContext5, type:"check", selected:true, enabled:true, instanceName:"checkLoop"},
				_global.labelVars.lbl_dependencyContext4];
		
		var _TaskAreaMenuItems = [_global.labelVars.lbl_mapContext,
								  _global.labelVars.lbl_printProcess];
		
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
					if(item.attributes.label == _global.labelVars.lbl_mapContext){
						trace(">>> _level4.showProcessEvtDialog();");
						_level4.showProcessEvtDialog();
					}
					if(item.attributes.label == _global.labelVars.lbl_printProcess){
						trace(">>> _level4.showProcessEvtDialog();");
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
					//PROCESS
					if(item.attributes.label == _global.labelVars.lbl_processContext5){
						tmpThis.__controller.removeElement(el_att_id);
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
	public function onTaskAdded(att_id:Number,att_label:String,att_disabled:String,att_color:String,x:Number,y:Number):Void {
		var mc = attachElement("Task",att_id,{att_id:att_id,att_label:att_label,_x:x,_y:y});
		mc.setColorFade(att_color);
		if(att_disabled=="true"){
			mc._alpha=50;
		}
		mc.menu = __ViewMenuColl[0];
	};
	public function onInitTaskAdded(att_id:Number,att_label:String,x:Number,y:Number):Void {
		var mc = attachElement("InitTask",att_id,{att_id:att_id,att_label:att_label,_x:x,_y:y});
	};
	
	public function onEndTaskAdded(att_id:Number,att_label:String,x:Number,y:Number):Void {
		var mc = attachElement("EndTask",att_id,{att_id:att_id,att_label:att_label,_x:x,_y:y});
			mc.menu = __ViewMenuColl[1];
	};
	
	public function onProcessAdded(att_id:Number,att_label:String,att_pro_disabled:String,att_pro_color:String,x:Number,y:Number):Void {
		var mc = attachElement("SubProcess",att_id,{att_id:att_id,att_label:att_label,_x:x,_y:y});
		mc.setColorFade(att_pro_color);
		if(att_pro_disabled=="true"){
			mc._alpha=50;
		}
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
	
	var lastClick:Number=0;
	private function onElementClicked(eventObj:Object):Void{
		if((getTimer()-lastClick)<=300){
			onElementDblClicked(eventObj);
		}
		lastClick=getTimer();
	}

	private function onElementDblClicked(eventObj:Object):Void{
		var m_el = eventObj.target;
		var selectedId = m_el.att_id;
		var infoText=__model.getElementInfo(selectedId).text;
		var infoTitle=__model.getElementInfo(selectedId).title;
		var configOBj = new Object();
			configOBj.contentPath = "infoText";
			configOBj.title = infoTitle;
			configOBj._width = 460;
			configOBj._height = 225;
			configOBj.closeButton=true;
			configOBj.text=infoText;			
			
		var objEvt = new Object();
		var tmp=this;
			objEvt.click = function(evt:Object):Void{
				evt.target.deletePopUp();
			}
		if(infoText!="" && infoText!=undefined && infoText!="undefined"){
			var modal = WindowManager.popUp(configOBj,_root);
			modal.addEventListener("click", objEvt);
			modal.addEventListener("onReady", objEvt);
			modal.addEventListener("onInitModal", objEvt);
		}
	}
	
	private function onElementMoved(eventObj:Object):Void{
		var m_el = eventObj.target;
		__controller.setElementPos(m_el.att_id,m_el._x,m_el._y);
	};
	
	public function onLineAdded(startId:Number,endId:Number,disabled:String):Void{
		var nextDepth = __LineArea.getNextHighestDepth();
		var aux = __LineArea.attachMovie("LineObj", 'LineObj_' + startId + "_" + endId, nextDepth, {
			m_startPoint:startId,
			m_endPoint:endId,
			m_startElementMc: __TaskArea["El_" + startId],
			m_endElementMc: __TaskArea["El_" + endId]
			});
			if(disabled=="true"){
				aux._alpha=20;
			}
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

	public function getLine(startId:Number,endId:Number):MovieClip{
		return __LineArea["LineObj_" + startId + "_" + endId];
	};
	
	public function onTaskRolAdded(att_id:Number,rolName:String):Void{
		var oTask:MovieClip = getElement(att_id);
			oTask.showRol(rolName);
	};
	
	public function onDependencyNameAdded(startId:Number,endId:Number,name:String,disabled:String):Void{
		var oLine:MovieClip = getLine(startId,endId);
			oLine.showName(name);
	};
	
	public function onDependencyConditionAdded(startId:Number,endId:Number,condition:String):Void{
		var oLine:MovieClip = getLine(startId,endId);
			oLine.showCondition(condition);
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
		//var mypj:PrintJob=new PrintJob();
		//mypj.addPage(_level0.Map,"bframe");
		//mypj.start();
		_global.printIt();
		trace("print1 "+_level0.Map);
		trace("pp "+targetPath(__TaskArea)+" "+targetPath(__LineArea));
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
}