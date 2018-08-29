﻿


import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.gridclasses.DataGridRow;
import com.qlod.LoaderClass;



class com.st.process.view.dialogs.AttModal extends MovieClip{
	var XML_ATT:String;
	var search_txt:TextInput;
	var find_btn:Button;
	var add_btn:Button;
	var att_dg:DataGrid;
	
	var xmlLoad_lc:MovieClip;
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	
	var oLoader:LoaderClass;
	
	var varType;
	var n;
	var addUrl;
	
	function AttModal(Void){
		addUrl=_global.PROCESS_ACTION+"createAttribute";
		XML_ATT = _global.XML_ATT;
		var thisModal = this;
		oLoader = new LoaderClass();
		
		varType=thisModal._parent.varType;
		
		n=thisModal._parent.n;
		if(n=="N"){
			XML_ATT=XML_ATT+"&"+"attType=N";
			}
			trace(XML_ATT+" "+varType);
		
		//CANCEL
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
		//CONFIRM
		this.confirm_btn.onPress = function() {
			var selectedIndex = thisModal.att_dg.getSelectedIndex();
			if(selectedIndex!=null){
				var itemSelected = thisModal.att_dg.getItemAt(selectedIndex);
				thisModal._parent.dispatchEvent({type:"ok",selected:itemSelected});
			}
		};
		//SEARCH
		this.find_btn.onPress = function() {
			thisModal.getXML(thisModal.att_dg,thisModal.search_txt);
		};
		
		this.add_btn.onPress = function() {
			var x = new XML();
			x.ignoreWhite = true;
			var tmp=thisModal;
			var name=thisModal.search_txt.text;
			x.onLoad=function(){
				tmp.getXML(tmp.result_list,tmp.search_txt);
			}
			if(name!=""){
				x.load(tmp.addUrl+"&name="+name);
			}
		}
	};
	
	function onLoad(){
		var attName_label = _global.labelVars.lbl_attName;
		var attLabel_label=  _global.labelVars.lbl_attLabel;
		var attType_label=  _global.labelVars.lbl_attType;
		var attMax_label=  _global.labelVars.lbl_attMaxlength;
		xmlLoad_lc.message=_global.labelVars.lbl_Loader;
		xmlLoad_lc._visible=false;
		
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		
		//SET DG SIZE
		att_dg.setSize(410,220);
		//SET DG COLS
		var columnName = new DataGridColumn("name");
			columnName.headerText = attName_label;
			columnName.width = 100;
			
		var columnLabel = new DataGridColumn("label");
			columnLabel.headerText = attLabel_label;
			columnLabel.width = 160;
			
		var columnType = new DataGridColumn("type");
			columnType.headerText = attType_label;
			columnType.width = 80;
			
		var columnMax = new DataGridColumn("maxlength");
			columnMax.headerText = attMax_label;
			columnMax.width = 30;
			
		att_dg.addColumn(columnName);
		att_dg.addColumn(columnLabel);
		att_dg.addColumn(columnType);
		att_dg.addColumn(columnMax);
		
		att_dg.setStyle("alternatingRowColors",[0xFFFFFF,0xEEEEFF]);
		
		this._parent.dispatchEvent({type:"show"});
	};
	
	
	function getXML(obj_dg:DataGrid,search_txt:TextInput){
		var p_url = XML_ATT;
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
					obj_dg.removeAll();
					var att_DP = new Array();
					for (var e=0;e < x.firstChild.childNodes.length;e++) {
						var colId = x.firstChild.childNodes[e].attributes.id;
						var colName = x.firstChild.childNodes[e].attributes.name;
						var colLabel = x.firstChild.childNodes[e].attributes.label;
						var colType = x.firstChild.childNodes[e].attributes.type;
						var colMax = x.firstChild.childNodes[e].attributes.maxlength;
						//obj_dg.addItem(colName,colLabel,colType,colMax);
						//if(varType==colType){
						att_DP.addItem({name:colName,
								  label:colLabel,
								  type:colType,
								  maxlength:colMax,
								  id:colId});
						//}
					}
					obj_dg.dataProvider = att_DP;
					tmp.xmlLoad_lc._visible=false;
				}
			};
			
		var auxURL:String; 
		if(_global.DEBUG_IN_IDE){
			auxURL = p_url;
		}else{
			auxURL = p_url + "&name=" + search_txt.text+"&type="+varType;
		}
		xmlLoad_lc._visible=true;
		oLoader.load(x,auxURL,loaderListener);
		
	};
	
	
	
	
}