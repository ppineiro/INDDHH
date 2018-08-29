 
import mx.events.EventDispatcher;

import mx.controls.List;
import mx.controls.TextInput;
import mx.controls.Button;

class com.st.process.view.dialogs.Finder extends MovieClip{
	
	var add_btn:Button;
	var find_btn:Button;
	var search_txt:TextInput;
	var result_list:List;
	
	var p_url:String;
	var p_type:String;
	static var oLoader:com.qlod.LoaderClass;
	
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;
	var dispatchQueue:Function;
	
	var addUrl=null;
	
	function Finder(){
		mx.events.EventDispatcher.initialize(this);
		oLoader = new com.qlod.LoaderClass();
		
		//STYLES
		result_list.setStyle("alternatingRowColors",[0xFFFFFF,0xEEEEFF]);
		result_list.setStyle("fontFamily","Verdana");
		result_list.setStyle("fontSize","10");
		
	
		result_list.selectable = false;

		//result_list.hScrollPolicy = "on"; 
		//result_list.maxHPosition = 400;
		
		
		var thisModal = this;
		this.find_btn.onPress = function() {
			thisModal.getXML(thisModal.result_list,thisModal.search_txt);
		};
		
		
	};
	
	function onLoad(){
		if(addUrl==null){
			this.add_btn._visible=false;
		}
		var sslp = mx.controls.listclasses.ScrollSelectList.prototype;
		if (!sslp.$oldOnRowPress) {
 			sslp.$oldOnRowPress = sslp.onRowPress;
			sslp.onRowPress = function(rowIndex) {
				if(_parent._name == "finder_mc"){
					//new method action
					if(rowIndex < this.length){
						//this.dispatchEvent({target:this,type:"onRowPress",row:rowIndex});
						var itemIndex = this.__vPosition + rowIndex;
						var f = _parent.result_list.getItemAt(itemIndex);
						var sLabel = f.label;
						var sValue = f.data;
						var sType = _parent.p_type;
						_parent._parent.dispatchEvent({target:this,label:sLabel,value:sValue,elementType:sType,type:"onRowPress"});
					}
				}else{
					this.$oldOnRowPress.apply(this, [rowIndex]);
				}
			}
		}
		sslp = null;
		delete sslp;
		
	};
	
	
	function getValue(){
		var sFinderSelected = result_list.selectedItem;
		if(sFinderSelected.data!=null){
			return sFinderSelected;
		}else{
			return null;
		}
	};
	
	function getXML(objList:List,objText:TextInput){
		var x = new XML();
			x.ignoreWhite = true;
		var loaderListener = new Object();
			loaderListener.onLoadStart = function(){};
			loaderListener.onLoadProgress = function(loaderObj){};
			loaderListener.onTimeout = function(loaderObj){};
			loaderListener.onLoadComplete = function(success,loaderObj){
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
				
			};
		var auxURL:String; 
		if(_global.DEBUG_IN_IDE){
			auxURL = p_url;		
		}else{
			auxURL = p_url + "&name=" + search_txt.text;
		}
		oLoader.load(x,auxURL,loaderListener);
		
	};
	
	function setAddUrl(url){
		addUrl=_global.PROCESS_ACTION+url;
		this.add_btn._visible=true;
		var thisModal=this;
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
	}
	
}