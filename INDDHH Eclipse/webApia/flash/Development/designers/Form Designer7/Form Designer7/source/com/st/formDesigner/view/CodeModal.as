

import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;
import com.qlod.LoaderClass;



class com.st.formDesigner.view.CodeModal extends MovieClip{
	var XML_COD:String;
	var search_txt:TextInput;
	var find_btn:Button;
	var cod_dg:DataGrid;
	
	var cod_DP:Array;
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	
	var oLoader:LoaderClass;
	
	var src:String;
	
	function CodeModal(Void){
		
		XML_COD = _global.COD_XML;
		var thisModal = this;
		oLoader = new LoaderClass();
		
		src=thisModal._parent.src;
		//CANCEL
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
		//CONFIRM
		this.confirm_btn.onPress = function() {
			var selectedIndex = thisModal.cod_dg.getSelectedIndex();
			if(selectedIndex!=null){
				var itemSelected = thisModal.cod_dg.getItemAt(selectedIndex);
				var code=itemSelected.desc;
				thisModal._parent.dispatchEvent({type:"ok",code:code});
			}
		};
		//SEARCH
		this.find_btn.onPress = function() {
			thisModal.getXML(thisModal.cod_dg,thisModal.search_txt);
		};
	};
	
	function onLoad(){
		var codCode_label = _global.labelVars.lbl_codCode;
		var codDesc_label=  _global.labelVars.lbl_codDesc;
				
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		
		//SET DG SIZE
		cod_dg.setSize(345,220);
		//SET DG COLS
		var columnCode = new DataGridColumn("code");
			columnCode.headerText = codCode_label;
			columnCode.width = 150;
			
		var columnDesc = new DataGridColumn("desc");
			columnDesc.headerText = codDesc_label;
			columnDesc.width = 220;
			
		
		cod_dg.addColumn(columnCode);
		cod_dg.addColumn(columnDesc);
				
		cod_dg.setStyle("alternatingRowColors",[0xFFFFFF,0xEEEEFF]);
		
		this._parent.dispatchEvent({type:"show"});
	};
	
	
	function getXML(obj_dg:DataGrid,search_txt:TextInput){
		var p_url = XML_COD;
		var x = new XML();
			x.ignoreWhite = true;
		var loaderListener = new Object();
			loaderListener.onLoadStart = function(){};
			loaderListener.onLoadProgress = function(loaderObj){};
			loaderListener.onTimeout = function(loaderObj){};
			loaderListener.onLoadComplete = function(success,loaderObj){
				//trace("onLoadComplete" + loaderObj.getTargetObj().toString());
					var x = loaderObj.getTargetObj();
					obj_dg.removeAll();
					var COD_DP = new Array();
					for (var e=0;e < x.firstChild.childNodes.length;e++) {
					var col_code = x.firstChild.childNodes[e].childNodes[0].firstChild.nodeValue;
					var col_desc = x.firstChild.childNodes[e].childNodes[1].firstChild.nodeValue;	//obj_dg.addItem(colName,colLabel,colType,colMax);
						COD_DP.addItem({code:col_code,
								  desc:col_desc});
				}
				obj_dg.dataProvider = COD_DP;
			};
			
		var auxURL:String; 
		if(_global.DEBUG_IN_IDE){
			trace("p_url"+p_url);
			auxURL = p_url;
		}else{
			auxURL = p_url + "&name=" + search_txt.text+" &type="+src;
		}
	
		oLoader.load(x,auxURL,loaderListener);
		
	};
	
	
	
	
}