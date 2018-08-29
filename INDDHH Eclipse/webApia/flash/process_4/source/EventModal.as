

import mx.controls.DataGrid;
import mx.controls.ComboBox;
import mx.controls.Button;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;

import com.qlod.LoaderClass;

class EventModal extends MovieClip{
	var EVENTS_XML:String;
	var CLASSES_XML:String;
	var p_type:Number;
	var events_array:Array;
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	
	var event_cmb:ComboBox;
	var class_cmb:ComboBox;
	var eventClass_dg:DataGrid;
	
	var del_btn:Button;
	var add_btn:Button;
	
	var oLoader:LoaderClass;
	
	var eventClass_dg_rowSelected:Number;
	
	function EventModal(Void){
		EVENTS_XML = _global.XML_EVENTS;
		CLASSES_XML = _global.XML_CLASSES;
		
		mx.events.EventDispatcher.initialize(this);
		oLoader = new LoaderClass();
		eventClass_dg_rowSelected = null;
		
		var thisModal = this;
		events_array = thisModal._parent.events_array;
		p_type = thisModal._parent.p_type;
		
		this.confirm_btn.onPress = function() {
			var eventClass_dg = thisModal.eventClass_dg;
			var p_Array:Array = thisModal.getDataFromGrid(eventClass_dg);
			thisModal._parent.dispatchEvent({type:"ok",events:p_Array});
		};
		
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
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
				eventClass_dg.dataProvider.addItemAt(0, {event_id:event_cmb.selectedItem.data,
														 event_name:event_cmb.selectedItem.label,
														 class_id:class_cmb.selectedItem.data,
														 class_name:class_cmb.selectedItem.label});
			}
		};
		//REMOVE FROM GRID
		this.del_btn.onPress = function(){
			var selIndex = thisModal.eventClass_dg.selectedIndex;
			if(selIndex!=null){
				thisModal.removeFromGrid(thisModal.eventClass_dg,selIndex);
			}
		};
	};
	
	
	function onLoad(){
		var thisModal = this;
		
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		
		//RENDER COLUMNS
		var column = new DataGridColumn("event_name");
			column.headerText = "Events";
			column.width = 160;
		eventClass_dg.addColumn(column);
		
		var column = new DataGridColumn("class_name");
			column.headerText = "Classes";
			column.width = 220;
		eventClass_dg.addColumn(column);
		
		//SET ROW LISTENERS
		var eventClass_dgListener = new Object();
			eventClass_dgListener.cellPress = function(event) {
				thisModal.eventClass_dg_rowSelected = event.itemIndex;
			};
		eventClass_dg.addEventListener("cellPress", eventClass_dgListener);
		
		//LOAD CMBs
		getXML(thisModal.class_cmb,thisModal.CLASSES_XML);
		getXML(thisModal.event_cmb,thisModal.EVENTS_XML);
		
		//INIT GRID
		var eventClass_DP = new Array();
		for(var d=0; d < events_array.length; d++){
			trace(events_array[d].event_name)
			eventClass_DP.addItem({	event_id:events_array[d].event_id,
							  		event_name:events_array[d].event_name,
									class_id:events_array[d].class_id,
							  		class_name:events_array[d].class_name});
		}
		eventClass_dg.dataProvider = eventClass_DP;
		
	
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
		if(_global.DEBUG_IN_IDE){
			auxURL = p_url;
		}else{
			auxURL = p_url + "&type=" + p_type;
		}
		
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
				obj_Array.push(p_data);
		}
		return obj_Array;
	};
	
	function removeFromGrid(p_oDg:DataGrid,p_oRowSelected:Number){
		p_oDg.dataProvider.removeItemAt(p_oRowSelected);
	};
	
}