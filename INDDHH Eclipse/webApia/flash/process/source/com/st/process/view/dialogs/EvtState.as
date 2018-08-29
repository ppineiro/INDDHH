

import mx.controls.DataGrid;
import mx.controls.ComboBox;
import mx.controls.Button;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;
import mx.controls.cells.CheckCellRenderer;

import com.qlod.LoaderClass;
import com.st.util.WindowManager;

class com.st.process.view.dialogs.EvtState extends MovieClip{
	var EVENTS_XML:String;
	var STATES_XML:String;
	var p_type:Number;
	var sta_array:Array;
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	var cond_btn:Button;
	
	var up_btn:Button;
	var down_btn:Button;
	
	var event_cmb:ComboBox;
	var state_cmb:ComboBox;
	
	var eventClass_dg:DataGrid;
	var eventClass_DP:Array;
	
	var del_btn:Button;
	var add_btn:Button;
	
	var oLoader:LoaderClass;
	
	function EvtState(Void){
		mx.events.EventDispatcher.initialize(this);
		oLoader = new LoaderClass();
		
		EVENTS_XML = _global.XML_EVENTS;
		STATES_XML = _global.XML_STATES+_global.entParams;
		
		var thisModal = this;
		sta_array = thisModal._parent.sta_array;
		eventClass_DP = new Array();
		
		p_type = thisModal._parent.p_type;
		
		this.confirm_btn.onPress = function() {
			var dg=thisModal.eventClass_dg;
			var p_Array:Array = thisModal.getDataFromGrid(dg);
			thisModal._parent.dispatchEvent({type:"ok",states:p_Array});
		};
		
		this.cancel_btn.onPress = function() {
			trace(".cancel_btn.onPress ");
			thisModal._parent.dispatchEvent({type:"click"});
		};
		
		this.cond_btn.onPress = function(){
			//show bind modal
			var selIndex:Number = thisModal.eventClass_dg.selectedIndex;
			if(selIndex!=null){
				thisModal.showCondition(selIndex);
			}
			
		};
		
		this.add_btn.onPress = function(){
			var eventClass_dg = thisModal.eventClass_dg;
			var event_cmb = thisModal.event_cmb;
			var state_cmb = thisModal.state_cmb;
			var isRepeated:Boolean = false;
			
			//chk repeated
			for(var w=0; w < eventClass_dg.dataProvider.length; w++){
				if(event_cmb.selectedItem.data == eventClass_dg.dataProvider[w].event_id && state_cmb.selectedItem.data == eventClass_dg.dataProvider[w].sta_id){
					isRepeated = true;
					return false;
				}else{
					isRepeated = false;
				}
			}
			//add to grid
			if(!((event_cmb.selectedItem.data=="" || state_cmb.selectedItem.data=="") ||
				(event_cmb.selectedItem.data==null || state_cmb.selectedItem.data==null) ||
				(event_cmb.selectedItem.data==undefined || state_cmb.selectedItem.data==undefined))){
				if(!isRepeated){
					eventClass_dg.dataProvider.addItemAt(0, 
								{event_id:event_cmb.selectedItem.data,
								event_name:event_cmb.selectedItem.label,
								sta_id:state_cmb.selectedItem.data,
								sta_name:state_cmb.selectedItem.label,
								conditionVal:"",
								condition:false
								});
				}
			}
		};
		//REMOVE FROM GRID
		this.del_btn.onPress = function(){
			var selIndex = thisModal.eventClass_dg.selectedIndex;
			if(selIndex!=null){
				thisModal.removeFromGrid(thisModal.eventClass_dg,selIndex);
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
			}
		};
		
		
	};
	
	
	function onLoad(){
		var modelListener:Object;
		var thisModal = this;
		
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		cond_btn.label = _global.labelVars.lblbtnCond;
		
		//RENDER COLUMNS
		var column = new DataGridColumn("event_name");
			column.headerText = _global.labelVars.lbl_EvtStaEvt;
			column.width = 175;
		eventClass_dg.addColumn(column);
		
		var column = new DataGridColumn("sta_name");
			column.headerText = _global.labelVars.lbl_EvtStaSta;
			column.width = 175;
		eventClass_dg.addColumn(column);
		
		var column = new DataGridColumn("condition");
			column.headerText = _global.labelVars.lbl_EvtStaCon;
			column.width = 100;
			column.cellRenderer = "CheckCellRenderer";
		eventClass_dg.addColumn(column);

		//LOAD CMBs
		getXML(thisModal.state_cmb,thisModal.STATES_XML);
		getXML(thisModal.event_cmb,thisModal.EVENTS_XML);
		
		//INIT GRID
		for(var d=0; d < sta_array.length; d++){
			var hasCondition:Boolean=true;
			if(sta_array[d].condition==null || sta_array[d].condition=="" || sta_array[d].condition==undefined){
				hasCondition=false;
				}
			eventClass_DP.addItem({	event_id:sta_array[d].event_id,
							  		event_name:sta_array[d].event_name,
									sta_id:sta_array[d].sta_id,
							  		sta_name:sta_array[d].sta_name,
									order:sta_array[d].order,
									conditionVal:sta_array[d].condition,
									condition:hasCondition
									});
		}
		eventClass_dg.dataProvider = eventClass_DP;
				
		var listenerObject = new Object();
		listenerObject.modelChanged = function (eventObj) {
			thisModal.update();
		}
		eventClass_DP.addEventListener("modelChanged", listenerObject)
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
				p_data.sta_id = objGrid.dataProvider[x].sta_id;
				p_data.sta_name = objGrid.dataProvider[x].sta_name;
				p_data.order= objGrid.dataProvider[x].order;
				p_data.condition = objGrid.dataProvider[x].conditionVal;
			obj_Array.push(p_data);
		}
		return obj_Array;
	};
	
	function removeFromGrid(p_oDg:DataGrid,p_oRowSelected:Number){
		p_oDg.dataProvider.removeItemAt(p_oRowSelected);
	};
	
	
	function showCondition(rowIndex:Number){
		var tmp = this;
	
		//trace("PARAM_NAME" + bind_arr[0].param_name)
		//[param_id, param_name, param_type, att_id, att_name, att_type, value]
	
		var oGrid = tmp.eventClass_dg;
		var index = oGrid.getSelectedIndex();
		if(!(index==undefined || index==null)){
		var itemSelected = oGrid.getItemAt(index);
		//thisModal.showFormCondition(itemSelected);
		var p_condition:String = itemSelected.conditionVal;
		var configOBj = new Object();
		configOBj.closeButton = true;
		configOBj.contentPath = "ConditionModal";
		configOBj.title = _global.labelVars.lbl_ConditionModalTitle.toUpperCase();
		configOBj._width = 460;
		configOBj._height = 290;
		configOBj.conditionValue = p_condition;
			
		var objEvt = new Object();
			objEvt.ok = function(evt){
				var newCond:String = evt.conditionValue;
				var oGrid = tmp.eventClass_dg;
				var index = oGrid.getSelectedIndex();
				var itemSelected = oGrid.getItemAt(index);
				itemSelected.conditionVal=newCond;
				tmp.update();
				popUp.deletePopUp();
			}
			objEvt.click = function(evt:Object):Void{
				popUp.deletePopUp();
			}
		
		var popUp = WindowManager.popUp(configOBj,this);
			popUp.addEventListener("ok", objEvt);
			popUp.addEventListener("click", objEvt);
		};
	}
	
	function update(){
		for(var x=0; x < eventClass_DP.length; x++)	{
			var hasCondition:Boolean=true;
			var p_data = new Object();
				p_data.condition = eventClass_DP[x].conditionVal;
				if(p_data.condition==null || p_data.condition=="" || p_data.condition==undefined){
				hasCondition=false;
				}
				eventClass_DP[x].condition=hasCondition;
		}
		//eventClass_dg.dataProvider = eventClass_DP;
	}
	
}