

import mx.controls.TextInput;
import mx.controls.Button;
import mx.controls.RadioButton;
import mx.controls.RadioButtonGroup;
import mx.controls.Label;
import mx.controls.ComboBox;
import com.cetdemi.LoadingCircle;
import com.qlod.LoaderClass;
import com.st.util.WindowManager;

class com.st.process.view.dialogs.CalendarModal extends MovieClip{
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	
	var cmbCalendars:ComboBox;
	var cmbTypes:ComboBox;
	var cmbTasks:ComboBox;
	var lblCalendars:ComboBox;
	var lblTypes:ComboBox;
	var lblTasks:ComboBox;
	var xmlLoading:LoadingCircle;
	var oLoader:LoaderClass;
	var XML_CAL;
	
	var tasks:Array;
	var calendar:Object;

	function CalendarModal(Void){
		mx.events.EventDispatcher.initialize(this);
		var thisModal = this;
		
		tasks = thisModal._parent.tasks;
		calendar = thisModal._parent.calendar;
		
		XML_CAL = _global.XML_CAL;
		
		this.confirm_btn.onPress = function() {
			var calendar:Object = {};
			calendar.calendarId =  thisModal.cmbCalendars.selectedItem.data.id;
			calendar.typeId =  thisModal.cmbTypes.selectedItem.data.id;
			calendar.taskId =  thisModal.cmbTasks.selectedItem.data.id;
			
			thisModal._parent.dispatchEvent({type:"ok",calendar:calendar});
			
		};
		
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
		oLoader = new LoaderClass();
	};
	
	function onLoad(){
		//SET BTN LABELS
		var tmp = this;
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		
		confirm_btn.enabled=false;
		
		lblCalendars.text=_global.labelVars.lbl_calendars;
		lblTypes.text=_global.labelVars.lbl_asignTypes;
		lblTasks.text=_global.labelVars.lbl_taskToSch;
		
		var tmp=this;
		var cmbChange=function(e){
			tmp.tryEnableConfirm();
		}
		
		cmbCalendars.addEventListener("change",cmbChange);
		cmbTasks.addEventListener("change",cmbChange);
		cmbTypes.addEventListener("change",cmbChange);
		
		loadCombos();
	}
	
	function loadCombos(){
		setXmlCombos();
		setTasksCombo();
	}
	
	function setXmlCombos(){
		var tmp=this;
		var x = new XML();
			x.ignoreWhite = true;
		var loaderListener = new Object();
		loaderListener.onLoadStart = function(){};
		loaderListener.onLoadProgress = function(loaderObj){};
		loaderListener.onTimeout = function(loaderObj){};
		loaderListener.onLoadComplete = function(success,loaderObj){
			//trace("onLoadComplete" + loaderObj.getTargetObj().toString());
			tmp.cmbCalendars.removeAll();
			tmp.cmbCalendars.addItem("",{id:""});
			tmp.cmbTypes.removeAll();
			tmp.cmbTypes.addItem("",{id:""});
			var x = loaderObj.getTargetObj();
			if(_global.isXMLexception(x)==true){
			}else{
				var calSelected=null;
				var typSelected=null;
				for (var e=0;e < x.firstChild.childNodes.length;e++) {
					var optName=x.firstChild.childNodes[e].attributes.name;
					var optId=x.firstChild.childNodes[e].attributes.id;
					if(x.firstChild.childNodes[e].nodeName=="CALENDAR"){
						tmp.cmbCalendars.addItem(optName,{label:optName,id:optId});
						if(tmp.calendar.calendarId==optId){
							calSelected=(tmp.cmbCalendars.length-1);
						}
					}else{
						tmp.cmbTypes.addItem(optName,{label:optName,id:optId});
						if(tmp.calendar.typeId==optId){
							typSelected=(tmp.cmbTypes.length-1);
						}
					}
				}
				tmp.cmbTypes.selectedIndex=typSelected;
				tmp.cmbCalendars.selectedIndex=calSelected;
				//objList.dataProvider = att_DP;
				tmp.xmlLoading._visible=false;
				tmp.tryEnableConfirm();
			}
		};
			
		xmlLoading._visible=true;
		oLoader.load(x,XML_CAL,loaderListener);
	}
	
	function setTasksCombo(){
		cmbTasks.removeAll();
		cmbTasks.addItem("",{id:""});
		var tskSelected=0;
		for (var e=0;e < tasks.length;e++) {
			var tsk=tasks[e];
			if(calendar.taskId==tsk.att_task_id){
				tskSelected=(cmbTasks.length);
			}
			cmbTasks.addItem(tsk.att_label,{label:tsk.att_label,id:tsk.att_task_id});
		}
		cmbTasks.selectedIndex=tskSelected;
	}
	
	function tryEnableConfirm(){
		confirm_btn.enabled=false;
		if( (cmbCalendars.selectedIndex>0 && cmbTypes.selectedIndex>0 && cmbTasks.selectedIndex>0 ) ||
			(cmbCalendars.selectedIndex==0 && cmbTypes.selectedIndex==0 && cmbTasks.selectedIndex==0 )){
			confirm_btn.enabled=true;
		}
	}
	
}
