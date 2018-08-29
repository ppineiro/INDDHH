


import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.controls.RadioButton;
import mx.controls.RadioButtonGroup;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;
import com.qlod.LoaderClass;
import com.st.util.WindowManager;

class com.st.formDesigner.view.EvtBindModal extends MovieClip{
	
	var BIND_XML:String;
	
	var bind_dg:DataGrid;
	var value_txt:TextInput;
	var attName_txt:TextInput;
	var att_btn:Button;
	
	var attTypeE_rad:RadioButton;
	var attTypeP_rad:RadioButton;
	var attTypeGroup:RadioButtonGroup;
	
	var att_rad:RadioButton;
	var val_rad:RadioButton;
	var frmOnGroup:RadioButtonGroup;
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	
	var bind_arr:Array;
	var bind_DP:Array;
	
	var classID:Number;
	var oLoader:LoaderClass;
	
	function EvtBindModal(Void){
		BIND_XML = _global.BIND_XML;
		var thisModal = this;
		oLoader = new LoaderClass();
		
		classID = thisModal._parent.classID;
		bind_arr = thisModal._parent.bind_arr;
		bind_DP = new Array();
		
		//CANCEL
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
		//CONFIRM
		this.confirm_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"ok",bind_arr:thisModal.bind_DP});
		};
		//ATT 
		var tmp=this;
		this.att_btn.onPress = function(){

			var configOBj = new Object();
				configOBj.closeButton = true;
				configOBj.contentPath = "AttModal";
				//configOBj.title = _global.labelVars.lbl_poolWin.toUpperCase() + ": " +  __model.getTaskName(task_att_id);
				configOBj.title =_global.labelVars.lbl_eventBindAtt;
				configOBj._width = 450;
				configOBj._height = 360;
				var index=thisModal.bind_dg.selectedIndex;
				var item=thisModal.bind_dg.dataProvider.getItemAt(index);
				var varType=item.param_type;
				configOBj.varType=varType;
												
												
			var objEvt = new Object();
				objEvt.ok = function(evt){
					var itemSelected = evt.selected;
					var att_id = itemSelected.id;
					var att_label = itemSelected.label;
					var att_name = itemSelected.name;
					var param_type=itemSelected.type;
					var dg_index = thisModal.bind_dg.selectedIndex;
					thisModal.attName_txt.dispatchEvent({type:"change",att_id:att_id,att_label:att_label,param_type:param_type});
					
					popUp.deletePopUp();
				}
				objEvt.click = function(evt:Object):Void{
					popUp.deletePopUp();
				}
			
			var popUp = WindowManager.popUp(configOBj,_level6);
				popUp.addEventListener("ok", objEvt);
				popUp.addEventListener("click", objEvt);
		
		};
	};
	
	function onLoad(model){
		var tmp = this;
		//SET LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		
		attTypeE_rad.label = _global.labelVars.lbl_frmEntityTitle;
	 	attTypeP_rad.label = _global.labelVars.lbl_BindProcess;
		val_rad.label = _global.labelVars.rad_eventBindingsValue;
		att_rad.label = _global.labelVars.rad_eventBindingsAttribute;
		
		attTypeE_rad.data = "1";
		attTypeP_rad.data = "2";
		attTypeE_rad.groupName = "attTypeGroup";
		attTypeP_rad.groupName = "attTypeGroup";
		
		//frm RADIOS
		val_rad.data = "1";
		att_rad.data = "2";
		val_rad.groupName = "frmOnGroup";
		att_rad.groupName = "frmOnGroup";
		
		attName_txt.enabled = false;
		
		//[param_id, param_name, param_type, att_id, att_name, att_type, value]
		//_global.labelVars.
		var param_name_label =_global.labelVars.lbl_BindParam;
		var param_type_label= _global.labelVars.lbl_BindType;
		var value_label=  _global.labelVars.lbl_BindValue;
		var att_name_label= _global.labelVars.lbl_BindAttribute;
		
		//SET DG SIZE
		bind_dg.setSize(520,110);
		bind_dg.setStyle("alternatingRowColors",[0xFFFFFF,0xEEEEFF]);
		
		//SET DG COLS
		var column = new DataGridColumn("param_name");
			column.headerText = param_name_label;
			column.width = 110;
		bind_dg.addColumn(column);
			
		var column = new DataGridColumn("param_type");
			column.headerText = param_type_label;
			column.width = 100;
		bind_dg.addColumn(column);
			
		var column = new DataGridColumn("value");
			column.headerText = value_label;
			column.width = 100;
		bind_dg.addColumn(column);
			
		var column = new DataGridColumn("att_name");
			column.headerText = att_name_label;
			column.width = 110;
		bind_dg.addColumn(column);
			
		var column = new DataGridColumn("param_IO");
			column.headerText = _global.labelVars.att_IO_label;
			column.width = 100;
		bind_dg.addColumn(column);
		
		getBindingsXML();

	};
	
	
	function initGrid(bindxmlArr:Array){
		var tmp = this;
		
		//ATTACH grid evt
		var rowListener = new Object();
			rowListener.change = function(event) {
				var i = event.target.selectedIndex;
				if(i < tmp.bind_dg.dataProvider.length){
					trace("\n GRID ROW CHANGE")
					var v:RadioButton = tmp.val_rad;
					var a:RadioButton = tmp.att_rad;
					var p_value =  tmp.bind_dg.dataProvider[i].value;
					var p_att = tmp.bind_dg.dataProvider[i].att_name;
					var p_attType = tmp.bind_dg.dataProvider[i].att_type;
					
					trace("VALOR----> " + p_value)
					trace("ATT----> " + p_att)
					
					if(p_value!=null && p_value!="undefined" && p_value!=""){
						//value row
						tmp.value_txt.text = tmp.bind_dg.dataProvider[i].value;
						tmp.val_rad.selected = true;
						tmp.attTypeP_rad.selected = false;
						tmp.attTypeE_rad.selected = false;
						tmp.frmOnGroup.dispatchEvent({type:"click"});
						
					}
					else if(p_att!=null && p_att!="undefined" && p_att!=""){
						//attribute row
						tmp.attName_txt.text = tmp.bind_dg.dataProvider[i].att_name;
						tmp.att_rad.selected = true;
						if(p_attType=="E" || p_attType=="e"){
							tmp.attTypeE_rad.selected = true;
						}else{
							tmp.attTypeP_rad.selected = true;
						}
						tmp.frmOnGroup.dispatchEvent({type:"click"});
						
					}else{
						//empty row
						tmp.value_txt.text = "";
						tmp.val_rad.selected = true;
						tmp.attTypeP_rad.selected = false;
						tmp.attTypeE_rad.selected = false;
						tmp.frmOnGroup.dispatchEvent({type:"click"});
	
					}
					
				}
			};
		
		bind_dg.addEventListener("change", rowListener);
		
		//////////////////////////////////////////////////////
		//INIT GRID
		/////////////////////////////////////////////////////
		for(var d=0; d< bindxmlArr.length; d++){
			var pId = bindxmlArr[d].param_id;
			var pName = bindxmlArr[d].param_name;
			var pType = bindxmlArr[d].param_type;
			var pIO= bindxmlArr[d].param_IO;
			var aId;
			var aName;
			var aType;
			var vValue;
			
			for(var p=0; p<bind_arr.length;p++){
				if(pId==bind_arr[p].param_id){
					aId = bind_arr[p].att_id;
					aName= bind_arr[p].att_name;
					aType = bind_arr[p].att_type;
					vValue = bind_arr[p].value;
				}
			}
		
			bind_DP.addItem({
					param_id:pId,
					param_name:pName,
					param_type:pType,
					att_id:aId,
					att_name:aName,
					att_type:aType,
					value:vValue,
					param_IO:pIO
				});
			
		}
		//[param_id, param_name, param_type, att_id, att_name, att_type, value]
		bind_dg.dataProvider = bind_DP;
		

		//FRMGROUP RADIO EVTS
		//attach events to radio
		var frmOnListener = new Object();
			frmOnListener.click = function (evt){
				var chkState = evt.target.selection.data;
				//trace("radio FRM CHANGE ON:" + chkState);
				if(chkState==1){//val ON
					trace("VALUE-CHECK: ON")
					tmp.attName_txt.enabled = false;
					tmp.attName_txt.text = "";
					tmp.attName_txt.setStyle("backgroundColor","0xEFEFEF");
					tmp.att_btn.enabled = false;
					
					tmp.attTypeGroup.enabled = false;
					tmp.attTypeP_rad.selected = false;
					tmp.attTypeE_rad.selected = false;
					
					tmp.value_txt.enabled = true;
					tmp.value_txt.setStyle("backgroundColor","0xFFFFFF");
					
					tmp.attName_txt.dispatchEvent({type:"change",att_id:"",att_label:"",att_type:""});
			
					
				}else{			//att ON
					trace("ATT-CHECK: ON")
					tmp.value_txt.enabled = false;
					tmp.value_txt.text = "";
					tmp.value_txt.setStyle("backgroundColor","0xEFEFEF");
					tmp.attTypeGroup.enabled = true;
					tmp.att_btn.enabled = true;
					tmp.attTypeE_rad.selected=true;
					tmp.bind_DP.editField(tmp.bind_dg.selectedIndex, "att_type", "E");
					tmp.attName_txt.setStyle("backgroundColor","0xFFFFFF");
					tmp.value_txt.dispatchEvent({type:"change"});
				}
			}
		frmOnGroup.addEventListener("click", frmOnListener);
		
		
		//ATT TYPE RADIOS EVTs
		var attTypeListener = new Object();
			attTypeListener.click = function (evt){
				var chkState = evt.target.selection.data;
				var dg_index = tmp.bind_dg.selectedIndex;
				if(chkState==1){//TYPE E on
					tmp.bind_DP.editField(dg_index, "att_type", "E");
				}else{	//TYPE P on
					tmp.bind_DP.editField(dg_index, "att_type", "P");
				}
			}
		attTypeGroup.addEventListener("click", attTypeListener);
		
		
		//VALUE CHANGE
		var valueTxtListener = new Object();
			valueTxtListener.change = function(event) {
				trace("VALUE INPUT ONCHANGE")
				var txtVal = event.target.text;
				var dg_index = tmp.bind_dg.selectedIndex;
				tmp.bind_DP.editField(dg_index, "value", txtVal);
			}
		value_txt.addEventListener("change",valueTxtListener);
		
		
		//ATTRIBUTE CHANGE
		var attTxtListener = new Object();
			attTxtListener.change = function(event) {
				trace("ATT INPUT ONCHANGE")
				//var txtVal = event.target.text;
				var att_id = event.att_id;
				var att_label= event.att_label;
				var att_name= event.att_name;
				//var att_type= event.att_type;
				var dg_index = tmp.bind_dg.selectedIndex;
				tmp.bind_DP.editField(dg_index, "att_name", att_label);
				var a=tmp.bind_DP.getItemAt(dg_index);
				tmp.bind_DP.editField(dg_index, "att_id", att_id);
				//tmp.bind_DP.editField(dg_index, "att_type", att_type);
				tmp.attName_txt.text = att_label;
			}
		attName_txt.addEventListener("change",attTxtListener);
		
		
		//----------------------------------------------
		//INIT MODAL STATE [grid selection values] 
		bind_dg.selectedIndex = 0;
		bind_dg.dispatchEvent({type:"change", target:bind_dg});
				
	};
	
	
	function getBindingsXML(){
		var tmpF = this;
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
					//loaded
					var bindXMLarr:Array = new Array();
					for (var e=0;e < x.firstChild.childNodes.length;e++) {
						var row = new Object();
							row.param_id= x.firstChild.childNodes[e].childNodes[0].firstChild.nodeValue;
  							row.param_name= x.firstChild.childNodes[e].childNodes[1].firstChild.nodeValue;
  							row.param_type= x.firstChild.childNodes[e].childNodes[2].firstChild.nodeValue;
							row.param_IO= x.firstChild.childNodes[e].childNodes[3].firstChild.nodeValue;
						bindXMLarr[e] = row;
					}
					tmpF.initGrid(bindXMLarr);
				}
			};
			
		var auxURL:String; 
		if(_global.DEBUG_IN_IDE){
			auxURL = BIND_XML;
		}else{
			auxURL = BIND_XML + "&claId=" + classID;
		}
		oLoader.load(x,auxURL,loaderListener);
	};
	
}


