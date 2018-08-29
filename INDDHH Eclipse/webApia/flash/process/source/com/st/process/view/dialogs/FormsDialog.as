import mx.events.EventDispatcher;
import mx.controls.List;
import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;
import mx.controls.cells.CheckCellRenderer;
import com.qlod.LoaderClass;
import com.st.util.WindowManager;
import com.st.util.ToolTipClass;


class com.st.process.view.dialogs.FormsDialog extends MovieClip{
	var XML_ENT:String;
	var XML_PRO:String;
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	
	var auxM:Array;
	
	var xmlLoad_lc:MovieClip;
	
	var processCond_btn:Button;
	var entityCond_btn:Button;
	
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
	
	var step_list:List;
	var addStep_btn:Button;
	var delStep_btn:Button;

	
	var entityUp_btn:Button;
	var entityDown_btn:Button;
	var processUp_btn:Button;
	var processDown_btn:Button;
	
	var findEntity_btn:Button;
	var findProcess_btn:Button;
	
	var addEntFrm_btn:Button;
	var addProcFrm_btn:Button;
	
	var oLoader:LoaderClass;
	
	
	var step_DP:Array;
	var frm_model:Array;
	var stepSelected:Number;
	
	private var toolTip:com.st.util.ToolTipClass;
	var t;
	
	function FormsDialog(Void){
		toolTip = new com.st.util.ToolTipClass(_root);
		mx.events.EventDispatcher.initialize(this);
		
		XML_ENT = _global.XML_ENT_FORMS;
		XML_PRO = _global.XML_PRO_FORMS;
		
		
		var thisModal = this;
		oLoader = new LoaderClass();

		//CONFIRM BTN
		this.confirm_btn.onPress = function() {
			var frms:Array= thisModal.getM();
			thisModal._parent.dispatchEvent({type:"ok",taskFrms:frms});
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
			thisModal.getFormsXML(thisModal.entity_list,thisModal.entity_txt,thisModal.XML_ENT);
		};
		//GET_PROCESSES_XML BUTTON
		this.findProcess_btn.onPress = function(){
			thisModal.getFormsXML(thisModal.process_list,thisModal.process_txt,thisModal.XML_PRO);
		};
		
		//ENTITYGRID ADD BUTTON
		this.addEntity_btn.onPress = function(){
			var entity_list = thisModal.entity_list;
			var entity_dg = thisModal.entity_dg;
			if(thisModal.checkRepeat(entity_list,entity_dg)){
				entity_dg.dataProvider.addItemAt(0, {readOnly:false,readOnly:false,
												 label:entity_list.selectedItem.label,
												 id:entity_list.selectedItem.data});
				
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
				process_dg.dataProvider.addItemAt(0, {readOnly:false,readOnly:false,
												  label:process_list.selectedItem.label,
												  id:process_list.selectedItem.data,
												  condition:false,
												  conditionVal:"",
												  conditionDocVal:""});
			}
		};
		//PROCESSGRID REMOVE BUTTON
		this.delProcess_btn.onPress = function(){
			var selIndex = thisModal.process_dg.selectedIndex;
			if(selIndex!=null){
				thisModal.removeFromGrid(thisModal.process_dg,selIndex);
			}
		};
		
		//ENTITYGRID MOVE-UP BUTTON
		this.entityUp_btn.onPress = function(){
			var oGrid = thisModal.entity_dg;
			thisModal.moveRowUp(oGrid);
		};
		//ENTITYGRID MOVE-DOWN BUTTON
		this.entityDown_btn.onPress = function(){
			var oGrid = thisModal.entity_dg;
			thisModal.moveRowDown(oGrid);
		};
		//PROCESSGRID MOVE-UP BUTTON
		this.processUp_btn.onPress = function(){
			var oGrid = thisModal.process_dg;
			thisModal.moveRowUp(oGrid);
		};
		//PROCESSGRID MOVE-DOWN BUTTON
		this.processDown_btn.onPress = function(){
			var oGrid = thisModal.process_dg;
			thisModal.moveRowDown(oGrid);
		};
		
		//PROCESSCOND BUTTON
		this.processCond_btn.onPress = function(){
			var oGrid = thisModal.process_dg;
			var index = oGrid.getSelectedIndex();
			if(!(index==undefined || index==null)){
			var itemSelected = oGrid.getItemAt(index);
			//thisModal.showFormCondition(itemSelected);
			var tmp = this;
			var p_condition:String = itemSelected.conditionVal;
			var p_conditionDoc:String = itemSelected.conditionDocVal;
			var configOBj = new Object();
			configOBj.closeButton = true;
			configOBj.contentPath = "FormConditionModal";
			configOBj.title = _global.labelVars.lbl_ConditionModalTitle.toUpperCase();
			configOBj._width = 460;
			configOBj._height = 290;
			configOBj.conditionValue = p_condition;
			configOBj.conditionDocValue = p_conditionDoc;
			
			var objEvt = new Object();
				objEvt.ok = function(evt){
					var newCond:String = evt.conditionValue;
					var newCondDoc:String = evt.conditionDocValue;
					var oGrid = thisModal.process_dg;
					var index = oGrid.getSelectedIndex();
					var itemSelected = oGrid.getItemAt(index);
					itemSelected.conditionVal=newCond;
					itemSelected.conditionDocVal=newCondDoc;
					thisModal.updateTaskFormsData();
					popUp.deletePopUp();
				}
				objEvt.click = function(evt:Object):Void{
					trace("CANCEL CONDITION MODAL")
					popUp.deletePopUp();
				}
					
			var popUp = WindowManager.popUp(configOBj,this);
				popUp.addEventListener("ok", objEvt);
				popUp.addEventListener("click", objEvt);
			}
			this._x=558;
			this._y=213;
		};
		
		//ENTITYCOND BUTTON
		this.entityCond_btn.onPress = function(){
			var oGrid = thisModal.entity_dg;
			var index = oGrid.getSelectedIndex();
			if(!(index==undefined || index==null)){
			var itemSelected = oGrid.getItemAt(index);
			//thisModal.showFormCondition(itemSelected);
				var tmp = this;
				var p_condition:String = itemSelected.conditionVal;
				var p_conditionDoc:String = itemSelected.conditionDocVal;
				var configOBj = new Object();
				configOBj.closeButton = true;
				configOBj.contentPath = "FormConditionModal";
				configOBj.title = _global.labelVars.lbl_ConditionModalTitle.toUpperCase();
				configOBj._width = 460;
				configOBj._height = 290;
				configOBj.conditionValue = p_condition;
				configOBj.conditionDocValue = p_conditionDoc;
			
				var objEvt = new Object();
				objEvt.ok = function(evt){
					var newCond:String = evt.conditionValue;
					var newCondDoc:String = evt.conditionDocValue;
					var oGrid = thisModal.entity_dg;
					var index = oGrid.getSelectedIndex();
					var itemSelected = oGrid.getItemAt(index);
					itemSelected.conditionVal=newCond;
					itemSelected.conditionDocVal=newCondDoc;
					thisModal.updateTaskFormsData();
					popUp.deletePopUp();
				}
				
				objEvt.click = function(evt:Object):Void{
					trace("CANCEL CONDITION MODAL")
					popUp.deletePopUp();
				}
			trace("el path de frmdialog"+targetPath(this));
				var popUp = WindowManager.popUp(configOBj,this);
				popUp.addEventListener("ok", objEvt);
				popUp.addEventListener("click", objEvt);
			}
			this._x=558;
			this._y=38;
		};
		
		this.addStep_btn.onPress = function(){
			trace("Add _ step")
			var nextStep = thisModal.step_DP.length;
			thisModal.step_DP.addItem({label:"STEP " + (nextStep+1), data:nextStep});
			thisModal.step_list.selectedIndex = nextStep;
			thisModal.step_list.dispatchEvent({type:"change", target:step_list});
		};
		this.delStep_btn.onPress = function(){
			trace("Del _ step" + thisModal.step_DP.length)
			var selIndex = thisModal.step_list.selectedIndex;
			if(thisModal.step_DP.length > 1){
				thisModal.step_DP.removeItemAt(selIndex);
				thisModal.step_list.selectedIndex = selIndex - 1;
				thisModal.clearStep();
				thisModal.step_list.dispatchEvent({type:"change", target:step_list});
				thisModal.updateSteps();
			}
		};
		
		
		//ADD ENTITYFORM
		this.addEntFrm_btn.onPress = function(){
			thisModal.addEntityForm(thisModal.entity_txt.text);
		};
		//ADD PROCESS FORM
		this.addProcFrm_btn.onPress = function(){
			thisModal.addProcessForm(thisModal.process_txt.text);
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
		lblEntity_txt.text = _global.labelVars.lbl_frmEntityTitle.toUpperCase();
		lblProcess_txt.text =  _global.labelVars.lbl_frmProcessTitle.toUpperCase();
		
		entity_dg.sortableColumns = false;
		process_dg.sortableColumns = false;
		
		
		//RENDER COLUMN - readonly
		var column = new DataGridColumn("readOnly");
			column.headerText = "RO";
			column.width = 30;
			column.cellRenderer = "CheckCellRenderer";
		
		entity_dg.addColumn(column);
		process_dg.addColumn(column);
		
		//RENDER COLUMN - multiply
		var column = new DataGridColumn("multiply");
			column.headerText = "M";
			column.width = 30;
			column.cellRenderer = "CheckCellRenderer";
		
		entity_dg.addColumn(column);
		process_dg.addColumn(column);
		
		//RENDER COLUMN - Condition
		var column = new DataGridColumn("condition");
			column.headerText = "C";
			column.width = 30;
			column.cellRenderer = "CheckCellRenderer";
		
		entity_dg.addColumn(column);
		process_dg.addColumn(column);
		
		//RENDER COLUMN - label
		var column = new DataGridColumn("label");
			column.headerText = "Name";
			column.width = 120;
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
		setM(tskForms);
		
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
		
		//STEP LIST CLICK LISTENER
		var stepListener = new Object();
			stepListener.change = function(evt) {
				trace("STEP ONCHANGE" + evt.target.selectedItem.label)
				
				stepSelected = evt.target.selectedItem.data;
				tmp.stepSelected = stepSelected;
				var frmA = tmp.getM();
				
				
				//-----------debug----------------------------
				/*
				trace("\n")
				for(var u=0;u< frmA[stepSelected].length;u++){
					//trace("1:" + formsInTask[u].join(", "));
					//trace("2:" + formsInTask[u].join(", ").toString());
					//trace("3:" + formsInTask[u].toString());
					var w = frmA[stepSelected][u];
					for (var i in w) {
  						trace("w." + i + " = " + w [i]);
					}
					trace("-----------")
				}
				trace("\n")
				*/
				//-------------------------------------
				
				var entity_DP = new Array();
				var process_DP = new Array();
				
				//LOAD GRIDS
				//trace("LEN>" + formsInTask[stepSelected].length)
				
				trace("LOAD_GRIDS STEP" + stepSelected)
				
				for(var e=0; e < frmA[stepSelected].length; e++){
					var frm_name:String = frmA[stepSelected][e].name;
					var frm_id:Number = frmA[stepSelected][e].form_id;
					var frm_type:String = frmA[stepSelected][e].type;
					var frm_read_only:Boolean = tmp.checkBoolean(frmA[stepSelected][e].read_only);
					var frm_multiply:Boolean = tmp.checkBoolean(frmA[stepSelected][e].multiply);
					var frm_condition:String = frmA[stepSelected][e].condition;
					var frm_conditionDoc:String = frmA[stepSelected][e].conditionDoc;
					var hasCondition:Boolean;
					if(frm_condition==""  || frm_condition==null || frm_condition==undefined){
						hasCondition=false;
						}else{
						hasCondition=true;
						}
					if(frm_type=="P"){
						//trace("entro P")
						process_DP.addItem({  
							readOnly:frm_read_only,
							multiply:frm_multiply,
							label:frm_name,
							id:frm_id,
							condition:hasCondition,
							conditionVal:frm_condition,
							conditionDocVal:frm_conditionDoc
							});
					}else{//type==E
						//trace("entro E")
						entity_DP.addItem({
							readOnly:frm_read_only,
							multiply:frm_multiply,
							label:frm_name,
							id:frm_id,
							condition:hasCondition,
							conditionVal:frm_condition,
							conditionDocVal:frm_conditionDoc
							});
					}
				}

				tmp.entity_dg.dataProvider = entity_DP;
				tmp.process_dg.dataProvider = process_DP;
				
				//---------------
				//datagrid modelChanged listener
				var entityModelListener = new Object();
					entityModelListener.modelChanged = function(eventObject){
						trace("entityModelChanged")
						tmp.updateTaskFormsData();
					}
				var processModelListener = new Object();
					processModelListener.modelChanged = function(eventObject){
						trace("processModelChanged")
						tmp.updateTaskFormsData();
					}
				tmp.entity_dg.dataProvider.addEventListener("modelChanged", entityModelListener);
				tmp.process_dg.dataProvider.addEventListener("modelChanged", processModelListener);
				//-----------------
			};
		
		step_list.addEventListener("change", stepListener);
		
		//select step 0 & fire onchange
		step_list.selectedIndex = 0;
		step_list.dispatchEvent({type:"change", target:step_list});
		
		
		//Dispatch SHOW
		_parent.dispatchEvent({type:"onInitModal"});
	};
	
	function setM(arr:Array):Void{
		frm_model = new Array();
		frm_model = arr;
	};
	function getM():Array{
		return frm_model;
	};
	

	function updateTaskFormsData(){
		var frmArr = getM();
		trace("UPDATING STEP" + stepSelected)
		
		//frmArr[stepSelected] = [];
		var frmArrAux= new Array();
		for(var x=0; x< entity_dg.dataProvider.length;x++){
			var o = new Object();
				o.name =  entity_dg.dataProvider.getItemAt(x).label;
				o.form_id = entity_dg.dataProvider.getItemAt(x).id;
				o.type = "E";
				o.read_only = entity_dg.dataProvider.getItemAt(x).readOnly;
				o.multiply = entity_dg.dataProvider.getItemAt(x).multiply;
				o.condition=entity_dg.dataProvider.getItemAt(x).conditionVal;
				o.conditionDoc=entity_dg.dataProvider.getItemAt(x).conditionDocVal;
				if(o.condition==null || o.condition=="" || o.condition==undefined){
				entity_dg.dataProvider.getItemAt(x).condition=false;
				}else{
				entity_dg.dataProvider.getItemAt(x).condition=true;
				}
				
			frmArrAux.push(o);
		}
		for(var x=0; x< process_dg.dataProvider.length;x++){
			var o = new Object();
				o.name =  process_dg.dataProvider.getItemAt(x).label;
				o.form_id = process_dg.dataProvider.getItemAt(x).id;
				o.type = "P";
				o.read_only = process_dg.dataProvider.getItemAt(x).readOnly;
				o.multiply = process_dg.dataProvider.getItemAt(x).multiply;
				o.condition=process_dg.dataProvider.getItemAt(x).conditionVal;
				o.conditionDoc=process_dg.dataProvider.getItemAt(x).conditionDocVal;
				if(o.condition==null || o.condition=="" || o.condition==undefined){
					process_dg.dataProvider.getItemAt(x).condition=false;
				}else{
					process_dg.dataProvider.getItemAt(x).condition=true;
				}
			frmArrAux.push(o);
		}
		frmArr[stepSelected]=frmArrAux;
		setM(frmArr);
	};
	
	function clearStep(){
		var frmArr = getM();
		var auxArr=new Array();
		for(var i=0;i<frmArr.length;i++){
			if(i!=stepSelected){
				auxArr.push(frmArr[i]);
			}
		}
		setM(auxArr);
	};
	
	function checkBoolean(p):Boolean{
		if(p=="true" || p==true){
			return true;
		}else{
			return false;
		}
	};
	
	function getFormsXML(objList:List,objText:TextInput,p_url:String){
		var tmp = this;
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
			var auxURL = p_url+_global.entParams+"&name=" + objText.text;
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
				p_data.label = objGrid.dataProvider[x].label;
			obj_Array.push(p_data);
		}
		return obj_Array;
	};
	
	function moveRowUp(oGrid){
		var selectedIndex = oGrid.getSelectedIndex();
		if(selectedIndex!=null && selectedIndex != 0){
			var itemSelected = oGrid.getItemAt(selectedIndex);
			var itemToMove = oGrid.getItemAt(selectedIndex - 1);
			oGrid.replaceItemAt(selectedIndex - 1, {readOnly:itemSelected.readOnly,multiply:itemSelected.multiply,label:itemSelected.label,id:itemSelected.id,condition:itemSelected.condition,conditionVal:itemSelected.conditionVal});
			oGrid.replaceItemAt(selectedIndex,{readOnly:itemToMove.readOnly,multiply:itemToMove.multiply,label:itemToMove.label,id:itemToMove.id,condition:itemToMove.condition,conditionVal:itemToMove.conditionVal});
			oGrid.setSelectedIndex(selectedIndex - 1);
		}
	};
	
	function moveRowDown(oGrid){
		var selectedIndex = oGrid.getSelectedIndex();
		var lastRow = oGrid.length;
		if(selectedIndex!=null && selectedIndex < lastRow-1){
			var itemSelected = oGrid.getItemAt(selectedIndex);
			var itemToMove = oGrid.getItemAt(selectedIndex + 1);
			oGrid.replaceItemAt(selectedIndex + 1, {readOnly:itemSelected.readOnly,multiply:itemSelected.multiply,label:itemSelected.label,id:itemSelected.id,condition:itemSelected.condition,conditionVal:itemSelected.conditionVal});
			oGrid.replaceItemAt(selectedIndex,{readOnly:itemToMove.readOnly,multiply:itemToMove.multiply,label:itemToMove.label,id:itemToMove.id,condition:itemToMove.condition,conditionVal:itemToMove.conditionVal});
			oGrid.setSelectedIndex(selectedIndex + 1);
		}
	};
	
	function updateSteps(){
		var frms:Array= getM();
		for(var i=0;i<step_list.rowCount;i++){
			var step=step_list.getItemAt(i);
			step.label=("STEP "+(i+1));
			step.data=i;
		}
	}
	
	function addProcessForm(name){
		trace("addProcessForm "+name);
		var x = new XML();
		x.ignoreWhite = true;
		var tmp=this;
		x.onLoad=function(){
			tmp.getFormsXML(tmp.process_list,tmp.process_txt,tmp.XML_PRO);
		}
		if(name!=""){
			var url=_global.PROCESS_ACTION+"addNewForm&type=P";
			x.load(url+"&name="+name);
		}
	}
	
	function addEntityForm(name){
		var x = new XML();
		x.ignoreWhite = true;
		var tmp=this;
		x.onLoad=function(){
			tmp.getFormsXML(tmp.entity_list,tmp.entity_txt,tmp.XML_ENT);
		}
		if(name!=""){
			var url=_global.PROCESS_ACTION+"addNewForm&type=E"+_global.entParams;
			x.load(url+"&name="+name);
		}
	}
	
}



