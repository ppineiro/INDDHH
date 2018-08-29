
import mx.controls.List;
import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;
import mx.controls.cells.CheckCellRenderer;
import com.qlod.LoaderClass;


class com.st.process.view.dialogs.ProcessFormsModal extends MovieClip{
	var XML_ENT:String;
	var XML_PRO:String;
	
	//var entity_Array:Array;
	//var process_Array:Array;
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	
	var lblEntity_txt:TextField;
	var lblProcess_txt:TextField;
	
	var entity_list:List;
	var entity_dg:DataGrid;
	var process_list:List;
	var process_dg:DataGrid;
	
	var addEntity_btn:Button;
	var delEntity_btn:Button;
	var addProcess_btn:Button;
	var delProcess_btn:Button;
	var entityUp_btn:Button;
	var entityDown_btn:Button;
	var processUp_btn:Button;
	var processDown_btn:Button;
	var findEntity_btn:Button;
	var findProcess_btn:Button;
	
	var oLoader:LoaderClass;
	var frm_model:Array;
	
	var xmlLoad_lc:MovieClip;
	
	function ProcessFormsModal(Void){
		XML_ENT = _global.XML_ENT_FORMS + _global.entParams;
		XML_PRO = _global.XML_PRO_FORMS;
		mx.events.EventDispatcher.initialize(this);
		
		
		var thisModal = this;
		oLoader = new LoaderClass();

		frm_model = thisModal._parent.frm_model;
		
		//CONFIRM MODAL
		this.confirm_btn.onPress = function() {
			var frms_Array:Array = thisModal.getDataFromGrids();
			thisModal._parent.dispatchEvent({type:"ok",forms:frms_Array});
		};
		//CANCEL MODAL
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
		//GET ENTITIES
		this.findEntity_btn.onPress = function(){
			thisModal.getFormsXML(thisModal.entity_list,thisModal.entity_txt,thisModal.XML_ENT);
		};
		//GET PROCESSES
		this.findProcess_btn.onPress = function(){
			thisModal.getFormsXML(thisModal.process_list,thisModal.process_txt,thisModal.XML_PRO);
		};
		
		//ENTITY GRID ADD
		this.addEntity_btn.onPress = function(){
			var entity_list = thisModal.entity_list;
			var entity_dg = thisModal.entity_dg;
			if(thisModal.checkRepeat(entity_list,entity_dg)){
				entity_dg.dataProvider.addItemAt(0, {readOnly:false,
												 label:entity_list.selectedItem.label,
												 id:entity_list.selectedItem.data});
			}
			
		};
		//ENTITY GRID REMOVE
		this.delEntity_btn.onPress = function(){
			var selIndex = thisModal.entity_dg.selectedIndex;
			if(selIndex!=null){
				thisModal.removeFromGrid(thisModal.entity_dg,selIndex);
			}
		};
		//PROCESS GRID ADD
		this.addProcess_btn.onPress = function(){
			var process_list = thisModal.process_list;
			var process_dg = thisModal.process_dg;
			if(thisModal.checkRepeat(process_list,process_dg)){
				process_dg.dataProvider.addItemAt(0, {readOnly:false,
												  label:process_list.selectedItem.label,
												  id:process_list.selectedItem.data});
			}
		};
		//PROCESS GRID REMOVE
		this.delProcess_btn.onPress = function(){
			var selIndex = thisModal.process_dg.selectedIndex;
			if(selIndex!=null){
				thisModal.removeFromGrid(thisModal.process_dg,selIndex);
			}
		};
		
		//ENTITY GRID MOVE UP
		this.entityUp_btn.onPress = function(){
			var oGrid = thisModal.entity_dg;
			thisModal.moveRowUp(oGrid);
		};
		//ENTITY GRID MOVE DOWN
		this.entityDown_btn.onPress = function(){
			var oGrid = thisModal.entity_dg;
			thisModal.moveRowDown(oGrid);
		};
		//PROCESS GRID MOVE UP
		this.processUp_btn.onPress = function(){
			var oGrid = thisModal.process_dg;
			thisModal.moveRowUp(oGrid);
		};
		//PROCESS GRID MOVE DOWN
		this.processDown_btn.onPress = function(){
			var oGrid = thisModal.process_dg;
			thisModal.moveRowDown(oGrid);
		};
		
	};
	
	function onLoad(){
		xmlLoad_lc.message=_global.labelVars.lbl_Loader;
		xmlLoad_lc._visible=false;
		var thisModal = this;
		
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		
		//SET TITLES
		lblEntity_txt.text = _global.labelVars.lbl_frmEntityTitle.toUpperCase();
		lblProcess_txt.text =  _global.labelVars.lbl_frmProcessTitle.toUpperCase();
		
		//RENDER COLUMNS
		var column = new DataGridColumn("readOnly");
			column.headerText = "";
			column.width = 30;
			column.cellRenderer = "CheckCellRenderer";
		
		entity_dg.addColumn(column);
		process_dg.addColumn(column);
	
		var column = new DataGridColumn("label");
			column.headerText = "Name";
			column.width = 180;
			
		entity_dg.addColumn(column);
		process_dg.addColumn(column);
		
		
		//INIT GRIDS FROM DATA
		var entity_DP = new Array();
		var process_DP = new Array();
		
		for(var d=0; d < frm_model.length; d++){
			if(frm_model[d].type == "E"){
				//ENTITY
				var p_readOnly = checkBoolean(frm_model[d].read_only);
				entity_DP.addItem({readOnly:p_readOnly,
								  label:frm_model[d].name,
								  id:frm_model[d].form_id});
			}else{
				//PROCESS
				var p_readOnly = checkBoolean(frm_model[d].read_only);
				process_DP.addItem({readOnly:p_readOnly,
								  label:frm_model[d].name,
								  id:frm_model[d].form_id});
			}
		}
		entity_dg.dataProvider = entity_DP;
		process_dg.dataProvider = process_DP;
		
		
	};
	
	function checkBoolean(p){
		if(p=="true" || p==true){
			return true;
		}else{
			return false;
		}
	};
	
	function getFormsXML(objList:List,objText:TextInput,p_url:String){
		var tmp=this;
		var x = new XML();
			x.ignoreWhite = true;
		var loaderListener = new Object();
			loaderListener.onLoadStart = function(){};
			loaderListener.onLoadProgress = function(loaderObj){};
			loaderListener.onTimeout = function(loaderObj){};
			loaderListener.onLoadComplete = function(success,loaderObj){
				//trace("onLoadComplete" + loaderObj.getTargetObj().toString());
				var x = loaderObj.getTargetObj();
				if(_global.isXMLexception(x)==true){
				}else{
					objList.removeAll();
					for (var e=0;e < x.firstChild.childNodes.length;e++) {
						var col_id = x.firstChild.childNodes[e].childNodes[0].firstChild.nodeValue;
						var col_name = x.firstChild.childNodes[e].childNodes[1].firstChild.nodeValue;
						objList.addItem(col_name,col_id);
					}
				}
				tmp.xmlLoad_lc._visible=false;
			};
			
		var auxURL:String; 
		if(_global.DEBUG_IN_IDE){
			auxURL = p_url;
		}else{
			var auxURL = p_url + "&name=" + objText.text;
		}
		xmlLoad_lc._visible=true;
		oLoader.load(x,auxURL,loaderListener);
	};
	
	function removeFromGrid(oDg:DataGrid,oRowSelected:Number){
		oDg.dataProvider.removeItemAt(oRowSelected);
	};
	
	function checkRepeat(objList:List,objGrid:DataGrid){
		if(objList.selectedItem){
			var isRepeated = false;
			for(var w=0; w < objGrid.dataProvider.length; w++){
				if(objList.selectedItem.data == objGrid.dataProvider[w].id){
					isRepeated = true;
					return false;
				}
			}
			if(isRepeated==false){
				return true;
			}
		}
	};
	
	function getDataFromGrid(objGrid:DataGrid,p_type:String){
		var obj_Array = new Array();
		for(var x=0; x < objGrid.dataProvider.length; x++)	{
			var p_data = new Object();
				p_data.form_id = objGrid.dataProvider[x].id;
				p_data.read_only = objGrid.dataProvider[x].readOnly;
				p_data.type = p_type;
				p_data.name = objGrid.dataProvider[x].label;
			obj_Array.push(p_data);
		}
		return obj_Array;
	};
	
	function getDataFromGrids():Array{
		var obj_Array = new Array();
		for(var x=0; x < entity_dg.dataProvider.length; x++){
			var p_data = new Object();
				p_data.form_id = entity_dg.dataProvider[x].id;
				p_data.read_only = entity_dg.dataProvider[x].readOnly;
				p_data.type = "E";
				p_data.name = entity_dg.dataProvider[x].label;
			obj_Array.push(p_data);
		}
		for(var d=0; d < process_dg.dataProvider.length; d++){
			var p_data = new Object();
				p_data.form_id = process_dg.dataProvider[d].id;
				p_data.read_only = process_dg.dataProvider[d].readOnly;
				p_data.type = "P";
				p_data.name = process_dg.dataProvider[d].label;
			obj_Array.push(p_data);
		}
		
		return obj_Array;
	};
	
	function moveRowUp(oGrid){
		var selectedIndex = oGrid.getSelectedIndex();
		if(selectedIndex!=null && selectedIndex != 0){
			var itemSelected = oGrid.getItemAt(selectedIndex);
			var itemToMove = oGrid.getItemAt(selectedIndex - 1);
			oGrid.replaceItemAt(selectedIndex - 1, {readOnly:itemSelected.readOnly,label:itemSelected.label,id:itemSelected.id});
			oGrid.replaceItemAt(selectedIndex,{readOnly:itemToMove.readOnly,label:itemToMove.label,id:itemToMove.id});
			oGrid.setSelectedIndex(selectedIndex - 1);
		}
	};
	
	function moveRowDown(oGrid){
		var selectedIndex = oGrid.getSelectedIndex();
		var lastRow = oGrid.length;
		if(selectedIndex!=null && selectedIndex < lastRow-1){
			var itemSelected = oGrid.getItemAt(selectedIndex);
			var itemToMove = oGrid.getItemAt(selectedIndex + 1);
			oGrid.replaceItemAt(selectedIndex + 1, {readOnly:itemSelected.readOnly,label:itemSelected.label,id:itemSelected.id});
			oGrid.replaceItemAt(selectedIndex,{readOnly:itemToMove.readOnly,label:itemToMove.label,id:itemToMove.id});
			oGrid.setSelectedIndex(selectedIndex + 1);
		}
	};
}



