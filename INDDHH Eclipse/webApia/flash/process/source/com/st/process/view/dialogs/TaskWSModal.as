import mx.events.EventDispatcher;
import mx.controls.List;
import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.controls.CheckBox;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;
import mx.controls.cells.CheckCellRenderer;
import com.qlod.LoaderClass;
import com.st.util.WindowManager;
import com.st.util.ToolTipClass;


class com.st.process.view.dialogs.TaskWSModal extends MovieClip{
	var XML_ENT:String;
	var XML_PRO:String;
	
	var publishId:String="";
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	
	var auxM:Array;
	
	var xmlLoad_lc:MovieClip;
	
	var lblName:TextField;
	var lblEntity_txt:TextField;
	var lblProcess_txt:TextField;
	
	var name_txt:TextField;
	
	var entity_list:List;
	var entity_dg:DataGrid;
	var process_list:List;
	var process_dg:DataGrid;
	
	var addEntity_btn:Button;
	var delEntity_btn:Button;
	var addProcess_btn:Button;
	var delProcess_btn:Button;
	
	var step_list:List;
	var addStep_btn:Button;
	var delStep_btn:Button;

	var findEntity_btn:Button;
	var findProcess_btn:Button;
	
	var oLoader:LoaderClass;
	
	
	var step_DP:Array;
	var model:Object;
	var stepSelected:Number;
	
	private var toolTip:com.st.util.ToolTipClass;
	var t;
	
	function TaskWSModal(Void){
		toolTip = new com.st.util.ToolTipClass(_root);
		mx.events.EventDispatcher.initialize(this);
		
		XML_ENT = _global.XML_ATT;
		XML_PRO = _global.XML_ATT;
		
		
		var thisModal = this;
		model = thisModal._parent.webservice;
		oLoader = new LoaderClass();
		
		//CONFIRM BTN
		this.confirm_btn.onPress = function() {
			//var frms:Array= thisModal.getM();
			thisModal.setM();
			thisModal._parent.dispatchEvent({type:"ok",webService:thisModal.model});
			//thisModal.entity_dg.dataProvider.removeAll();
			//thisModal.process_dg.dataProvider.removeAll();
			
		};
		
		//CANCEL BUTTON
		this.cancel_btn.onPress = function() {
			var frms:Array = thisModal.auxM;
			var aux:Array=new Array();
			for(var i=0;i<frms.length;i++){
				aux.push(frms[i].valueOf());
			}
			thisModal._parent.dispatchEvent({type:"ok",taskFrms:aux});
			thisModal.entity_dg.dataProvider.removeAll();
			thisModal.process_dg.dataProvider.removeAll();
		};
		
		//GET_ENTITIES_XML BUTTON
		this.findEntity_btn.onPress = function(){
			thisModal.getAttXML(thisModal.entity_list,thisModal.entity_txt,thisModal.XML_ENT);
		};
		//GET_PROCESSES_XML BUTTON
		this.findProcess_btn.onPress = function(){
			thisModal.getAttXML(thisModal.process_list,thisModal.process_txt,thisModal.XML_PRO);
		};
		
		//ENTITYGRID ADD BUTTON
		this.addEntity_btn.onPress = function(){
			var entity_list = thisModal.entity_list;
			var entity_dg = thisModal.entity_dg;
			if(thisModal.checkRepeat(entity_list,entity_dg)){
				entity_dg.dataProvider.addItemAt(0, {multivalued:false,uk:false,
												 label:entity_list.selectedItem.label,
												 id:entity_list.selectedItem.data.id,
												 type:"E"});
				
			}
			
		};
		//ENTITYGRID REMOVE BUTTON
		this.delEntity_btn.onPress = function(){
			var selIndex = thisModal.entity_dg.selectedIndex;
			if(selIndex!=null){
				thisModal.removeFromGrid(thisModal.entity_dg,selIndex);
			}
		};
		//PROCESSGRID ADD BUTTON
		this.addProcess_btn.onPress = function(){
			var process_list = thisModal.process_list;
			var process_dg = thisModal.process_dg;
			if(thisModal.checkRepeat(process_list,process_dg)){
				process_dg.dataProvider.addItemAt(0, {multivalued:false,uk:false,
												 label:process_list.selectedItem.label,
												 id:process_list.selectedItem.data.id,
												 type:"P"});
			}
		};
		//PROCESSGRID REMOVE BUTTON
		this.delProcess_btn.onPress = function(){
			var selIndex = thisModal.process_dg.selectedIndex;
			if(selIndex!=null){
				thisModal.removeFromGrid(thisModal.process_dg,selIndex);
			}
		};
		
		
		
		
	};
	
	function onLoad(){
		var tmp=this;
		xmlLoad_lc.message=_global.labelVars.lbl_Loader;
		xmlLoad_lc._visible=false;
		
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		
		addStep_btn.label = "+";
		delStep_btn.label = "-";
		
		//SET TITLES
		lblEntity_txt.text = _global.labelVars.lbl_wsBusEntAtt.toUpperCase();
		lblProcess_txt.text =  _global.labelVars.lbl_wsBusProAtt.toUpperCase();
		lblName.text = _global.labelVars.lblWSName;
		
		entity_dg.sortableColumns = false;
		process_dg.sortableColumns = false;
		
		//RENDER COLUMN - label
		var column = new DataGridColumn("label");
			column.headerText = "Name";
			column.width = 120;
		entity_dg.addColumn(column);
		process_dg.addColumn(column);
		
		//RENDER COLUMN - readonly
		var column = new DataGridColumn("multivalued");
			column.headerText = "Multi";
			column.width = 60;
			column.cellRenderer = "WsCheckCellRenderer";
		
		entity_dg.addColumn(column);
		process_dg.addColumn(column);
		
		//RENDER COLUMN - multiply
		var column = new DataGridColumn("uk");
			column.headerText = "UK";
			column.width = 30;
			column.cellRenderer = "WsCheckCellRenderer";
		
		entity_dg.addColumn(column);
		process_dg.addColumn(column);
		
		var listener:Object=new Object();
		listener.itemRollOver=function(eventObj){
			var index:Number=eventObj.index;
			var dp=eventObj.target.dataProvider;
			var aux=dp.getItemAt(index);
			tmp.showToolTip(aux.label);
			}
		listener.itemRollOut=function(eventObj){
			tmp.hideToolTip();
		}
		entity_dg.addEventListener("itemRollOver",listener);
		process_dg.addEventListener("itemRollOver",listener);
		entity_dg.addEventListener("itemRollOut",listener);
		process_dg.addEventListener("itemRollOut",listener);
		//fire ready evt to parent so it can call the init function here
		_parent.dispatchEvent({type:"onReady"});
		
		var atts=model.attributes;
		
		var entAtts:Array=new Array();
		var proAtts:Array=new Array();
		
		for(var i=0;i<atts.length;i++){
			if(atts[i].type=="E"){
				entAtts.push(atts[i]);
			}else{
				proAtts.push(atts[i]);
			}
		}
		fillDataGrid(entity_dg,entAtts);
		fillDataGrid(process_dg,proAtts);
		name_txt.text=(model.name)?model.name:"";
		publishId=(model.publicationId)?model.publicationId:"";
	};

	function showToolTip(p_txt:String){
		toolTip.setText(p_txt + " ");
	};
		
	function hideToolTip(){
		toolTip.clearText();
	};

	
	function init(tskForms:Array){
		//trace("__INIT___FRMDIALOG");
		var tmp = this;
		auxM=new Array();
		for(var i=0;i<tskForms.length;i++){
			var o:Object=new Object(tskForms[i].valueOf());
			auxM.push(o);
		}
		//setM();
		
		step_DP = new Array();
		//INIT STEP LIST
		//---------------------------------------------
		if(tskForms.length > 0){
			for(var d=1;d < (tskForms.length+1); d++){
				step_DP.addItem({label:"STEP " + (d), data:(d-1)});
			}
		}else{
			step_DP.addItem({label:"STEP " + 1, data:0});
		}
		step_list.dataProvider = step_DP;
		//---------------------------------------------
		
		//Dispatch SHOW
		_parent.dispatchEvent({type:"onInitModal"});
	};
	
	function setM():Void{
		model = new Object();
		model.name=name_txt.text;
		model.publicationId=publishId;
		var atts:Array=new Array();
		var processAtts=getDataFromGrid(process_dg);
		var entityAtts=getDataFromGrid(entity_dg);
		for(var i=0;i<processAtts.length;i++){
			atts.push(processAtts[i]);
		}
		for(var i=0;i<entityAtts.length;i++){
			atts.push(entityAtts[i]);
		}
		model.attributes=atts;
		
	};
	function getM(){
		return model;
	};
	
	function checkBoolean(p):Boolean{
		if(p=="true" || p==true){
			return true;
		}else{
			return false;
		}
	};
	
	function getAttXML(objList:List,objText:TextInput,p_url:String){
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
					var att_DP = new Array();
					for (var e=0;e < x.firstChild.childNodes.length;e++) {
						var colId = x.firstChild.childNodes[e].attributes.id;
						var colName = x.firstChild.childNodes[e].attributes.name;
						var colLabel = x.firstChild.childNodes[e].attributes.label;
						var colType = x.firstChild.childNodes[e].attributes.type;
						var colMax = x.firstChild.childNodes[e].attributes.maxlength;
						/*att_DP.addItem({name:colName,
								  label:colLabel,
								  type:colType,
								  maxlength:colMax,
								  id:colId});
								  */
						objList.addItem(colName,{id:colId,name:colName,type:colType,maxLength:colMax});
					}
					//objList.dataProvider = att_DP;
					tmp.xmlLoad_lc._visible=false;
				}
			};
			
		var auxURL:String; 
		if(_global.DEBUG_IN_IDE){
			auxURL = p_url;
		}else{
			auxURL = p_url + "&name=" + objText.text;//+"&type="+varType;
		}
		xmlLoad_lc._visible=true;
		oLoader.load(x,auxURL,loaderListener);
	};
	
	function removeFromGrid(oDg:DataGrid,oRowIndex:Number){
		oDg.dataProvider.removeItemAt(oRowIndex);
	};
	
	function checkRepeat(objList:List,objGrid:DataGrid){
		if(objList.selectedItem){
			var isRepeated = false;
			for(var w=0; w < objGrid.dataProvider.length; w++){
				if(objList.selectedItem.data.id == objGrid.dataProvider[w].id){
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
				p_data.id = objGrid.dataProvider[x].id;
				p_data.multivalued = objGrid.dataProvider[x].multivalued?"T":"F";
				p_data.uk = objGrid.dataProvider[x].uk?"T":"F";
				p_data.type = objGrid.dataProvider[x].type;
				p_data.name = objGrid.dataProvider[x].label;
			obj_Array.push(p_data);
		}
		return obj_Array;
	};
	
	function fillDataGrid(objGrid:DataGrid,obj_Array:Array){
		for(var x=0; x < obj_Array.length; x++)	{
			var p_data = obj_Array[x];
			objGrid.dataProvider.addItemAt(0, {multivalued:p_data.multivalued=="T",
											uk:p_data.uk=="T",
											label:p_data.name,
											id:p_data.id,
											type:p_data.type});
		}
	};
	
	
}



