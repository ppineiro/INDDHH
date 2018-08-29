

import mx.controls.List;
import mx.controls.TextInput;
import mx.controls.Button;
import com.qlod.LoaderClass;

class RolModal extends MovieClip{

	var XML_ROL_URL:String;
	var find_txt:TextInput;
	var find_btn:Button;
	var result_list:List;
	var confirm_btn:Button;
	var cancel_btn:Button;
	
	var oLoader:LoaderClass;
	
	function RolModal(Void){
		XML_ROL_URL = _global.XML_ROL;
		
		mx.events.EventDispatcher.initialize(this);
		
		var thisModal = this;
		oLoader = new LoaderClass();
		
		this.confirm_btn.onPress = function() {
			if(thisModal.result_list.selectedItem){
				var p_rol = new Object();
					p_rol.id =	thisModal.result_list.selectedItem.data;
					p_rol.label = thisModal.result_list.selectedItem.label;
				thisModal._parent.dispatchEvent({type:"ok",rol:p_rol});
			}
		};
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
		this.find_btn.onPress = function() {
			thisModal.getXML(thisModal.result_list,thisModal.find_txt);
		};
		/* DELETE
		this.add_btn.onPress = function() {
			if(thisModal.find_txt.text){
				thisModal.result_list.addItemAt(1,{label:thisModal.find_txt.text,data:null});
			}
		};*/
	};
	
	function onLoad(){
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		
		addEmpty();
	};
	
	function addEmpty(){
		result_list.addItemAt(0,{label:_global.labelVars.lbl_RolEmpty,data:"empty"});
	};
	
	function getXML(objList:List,objText:TextInput){
		var thisModal = this;
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
					thisModal.addEmpty();
				}
			};
		var auxURL:String; 
		if(_global.DEBUG_IN_IDE){
			auxURL = XML_ROL_URL;
		}else{
			auxURL = XML_ROL_URL + "&name=" + find_txt.text;
		}
		
		oLoader.load(x,auxURL,loaderListener);
	};

}