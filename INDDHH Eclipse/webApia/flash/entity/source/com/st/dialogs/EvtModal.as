

import mx.controls.DataGrid;
import mx.controls.ComboBox;
import mx.controls.Button;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;
import com.st.util.DataSourceXML;

import com.qlod.LoaderClass;
import com.st.util.WindowManager;

class com.st.dialogs.EvtModal extends MovieClip{
	var EVENTS_XML:String;
	var CLASSES_XML:String;
	var p_type:Number;
	var evt_array:Array;
	
	var bind_btn:Button;
	
	var up_btn:Button;
	var down_btn:Button;
	
	var event_cmb:ComboBox;
	var class_cmb:ComboBox;
	
	var eventClass_dg:DataGrid;
	var eventClass_DP:Array;
	
	var del_btn:Button;
	var add_btn:Button;
	
	var oLoader:LoaderClass;
	
	function EvtModal(Void){
		
		mx.events.EventDispatcher.initialize(this);
		oLoader = new LoaderClass();
		
		EVENTS_XML =_global.XML_EVENTS;
		CLASSES_XML =_global.XML_CLASSES;
		
		var thisModal = this;
		evt_array = thisModal._parent.evt_array;
		eventClass_DP = new Array();
		
		p_type = thisModal._parent.p_type;
		
		this.bind_btn.onPress = function(){
			//show bind modal
			var selIndex:Number = thisModal.eventClass_dg.selectedIndex;
			if(selIndex!=null){
				thisModal.showEvtBinding(selIndex);
			}
			
		};
		
		this.add_btn.onPress = function(){
			var eventClass_dg = thisModal.eventClass_dg;
			var event_cmb = thisModal.event_cmb;
			var class_cmb = thisModal.class_cmb;
			var isRepeated:Boolean = false;
			
			//chk repeated
			for(var w=0; w < eventClass_dg.dataProvider.length; w++){
				if(event_cmb.selectedItem.data == eventClass_dg.dataProvider[w].event_id && class_cmb.selectedItem.data == eventClass_dg.dataProvider[w].class_id){
					isRepeated = true;
					return false;
				}else{
					isRepeated = false;
				}
			}
			//add to grid
			if(!isRepeated){
				eventClass_dg.dataProvider.addItemAt(0, 
							{event_id:event_cmb.selectedItem.data,
							event_name:event_cmb.selectedItem.label,
							class_id:class_cmb.selectedItem.data,
							class_name:class_cmb.selectedItem.label});
				thisModal.update();
			}
		};
		//REMOVE FROM GRID
		this.del_btn.onPress = function(){
			var selIndex = thisModal.eventClass_dg.selectedIndex;
			if(selIndex!=null){
				thisModal.removeFromGrid(thisModal.eventClass_dg,selIndex);
				thisModal.update();
			}
		};
		
		//ORDER
		this.up_btn.onPress = function(){
			var selIndex = thisModal.eventClass_dg.selectedIndex;
			if(selIndex!=null && selIndex != 0){
				var item = thisModal.eventClass_DP.getItemAt(selIndex);
				thisModal.eventClass_DP.removeItemAt(selIndex);
				thisModal.eventClass_DP.addItemAt(selIndex-1,item);
				thisModal.eventClass_dg.setSelectedIndex(selIndex - 1);
				thisModal.update();
			}
		};
		this.down_btn.onPress = function(){
			var selIndex = thisModal.eventClass_dg.selectedIndex;
			var lastRow = thisModal.eventClass_DP.length;
			if(selIndex!=null && selIndex < lastRow-1){
				var item = thisModal.eventClass_DP.getItemAt(selIndex);
				thisModal.eventClass_DP.removeItemAt(selIndex);
				thisModal.eventClass_DP.addItemAt(selIndex+1,item);
				thisModal.eventClass_dg.setSelectedIndex(selIndex + 1);
				thisModal.update();
			}
		};
		
		
	};
	
	
	function onLoad(){
		var thisModal = this;

		eventClass_dg.setStyle("alternatingRowColors",[0xFFFFFF,0xEEEEFF]);
		//SET BTN LABELS
		bind_btn.label = _global.labelVars.lblbtnBind;
		
		//RENDER COLUMNS
		var column = new DataGridColumn("event_name");
			column.headerText = _global.labelVars.lbl_events;
			column.width = 160;
		eventClass_dg.addColumn(column);
		
		var column = new DataGridColumn("class_name");
			column.headerText = _global.labelVars.lbl_classes;
			column.width = 220;
		eventClass_dg.addColumn(column);
		
		//LOAD CMBs
		getXML(thisModal.class_cmb,thisModal.CLASSES_XML);
		getXML(thisModal.event_cmb,thisModal.EVENTS_XML);
		var aux="";
		for(var i in evt_array[0]){
			aux+=" "+i;
		}
		trace(aux);
		//INIT GRID
		for(var d=0; d < evt_array.length; d++){
			trace(evt_array[d].event_name)
			eventClass_DP.addItem({	event_id:evt_array[d].event_id,
							  		event_name:evt_array[d].event_name,
									class_id:evt_array[d].class_id,
							  		class_name:evt_array[d].class_name,
									bnd_id:evt_array[d].bnd_id,
									binding:evt_array[d].binding
									});
		}
		eventClass_dg.dataProvider = eventClass_DP;
		fscommand("isReady");
	
	};
	
	function getXML(p_objCmb:ComboBox,p_url:String){
		var x = new XML();
			x.ignoreWhite = true;
		var loaderListener = new Object();
			loaderListener.onLoadStart = function(){};
			loaderListener.onLoadProgress = function(loaderObj){};
			loaderListener.onTimeout = function(loaderObj){};
			loaderListener.onLoadComplete = function(success,loaderObj){
				//trace("onLoadComplete" + loaderObj.getTargetObj().toString());
				var x = loaderObj.getTargetObj();
				p_objCmb.removeAll();
				for (var e=0;e < x.firstChild.childNodes.length;e++) {
					//p_objCmb.addItem(x.firstChild.childNodes[e].attributes.name,x.firstChild.childNodes[e].attributes.id);
					var col_id = x.firstChild.childNodes[e].childNodes[0].firstChild.nodeValue;
					var col_name = x.firstChild.childNodes[e].childNodes[1].firstChild.nodeValue;
					p_objCmb.addItem(col_name,col_id);
				}
				
			};
			
		var auxURL:String; 
//		if(_global.DEBUG_IN_IDE){
			auxURL = p_url;
//		}else{
		//	auxURL = p_url + "&type=" + p_type;
//		}
		
		oLoader.load(x,auxURL,loaderListener);
	};
	
	function getDataFromGrid(objGrid:DataGrid){
		var obj_Array = new Array();
		for(var x=0; x < objGrid.dataProvider.length; x++)	{
			var p_data = new Object();
				p_data.event_id = objGrid.dataProvider[x].event_id;
				p_data.event_name = objGrid.dataProvider[x].event_name;
				p_data.class_id = objGrid.dataProvider[x].class_id;
				p_data.class_name = objGrid.dataProvider[x].class_name;
				p_data.bnd_id = objGrid.dataProvider[x].bnd_id;
				p_data.binding = objGrid.dataProvider[x].binding;
				p_data.order = x;
				
				obj_Array.push(p_data);
		}
		return obj_Array;
	};
	
	function removeFromGrid(p_oDg:DataGrid,p_oRowSelected:Number){
		p_oDg.dataProvider.removeItemAt(p_oRowSelected);
	};
	
	
	function showEvtBinding(rowIndex:Number){
		var tmp = this;
		var bind_arr:Array = eventClass_dg.dataProvider[rowIndex].binding;
		var classID:Number = eventClass_dg.dataProvider[rowIndex].class_id;
		trace(classID);
		
		//trace("PARAM_NAME" + bind_arr[0].param_name)
		//[param_id, param_name, param_type, att_id, att_name, att_type, value]
	
		var configOBj = new Object();
			configOBj.closeButton = true;
			configOBj.contentPath = "EvtBindModal";
			//configOBj.title = _global.labelVars.lbl_eventWin.toUpperCase() + " : " + __model.getTaskName(task_att_id);
			configOBj.title = _global.labelVars.eventBindingsTitle;
			configOBj._width = 550;
			configOBj._height = 360;
			configOBj.bind_arr = bind_arr;
			configOBj.classID = classID;
			
			
		var objEvt = new Object();
			objEvt.ok = function(evt){
				tmp.eventClass_dg.dataProvider[rowIndex].binding = evt.bind_arr;
				popUp.deletePopUp();
				tmp.update();
			}
			objEvt.click = function(evt:Object):Void{
				popUp.deletePopUp();
				tmp.update();
			}
		
		var popUp = WindowManager.popUp(configOBj,this);
			popUp.addEventListener("ok", objEvt);
			popUp.addEventListener("click", objEvt);
		};
		
		function update(){
			var definitions:Array=this.getDataFromGrid(eventClass_dg);
			this._parent.dispatchEvent({type:"update",defs:definitions});
		}
	
}