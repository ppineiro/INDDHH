

import mx.controls.List;
import mx.controls.TextInput;
import mx.controls.Button;
import com.qlod.LoaderClass;

class GenericFinder extends MovieClip{
	
	var find_btn:Button;
	var search_txt:TextInput;
	var result_list:List;
	var p_url:String;
	var p_type:Number;
	
	var oLoader:LoaderClass;
	
	var taskDataProvider_dp:Array;
	var processDataProvider_dp:Array;
	
	function GenericFinder(){
		mx.events.EventDispatcher.initialize(this);
		oLoader = new LoaderClass();
		
		result_list.setStyle("alternatingRowColors",[0xFFFFFF,0xEEEEFF]); 
		//trace("STYLE-----> " + result_list.getStyle("alternatingRowColors")); 
		
		var thisModal = this;
		p_url = thisModal._parent.p_url;
		p_type=1;
		
		taskDataProvider_dp = new Array();
		processDataProvider_dp = new Array();
		
		this.find_btn.onPress = function() {
			thisModal.getXML(thisModal.result_list,thisModal.search_txt);
		};
	};
	
	function setFinder(pUrl:String,pType:Number){
		p_url = pUrl;
		if(p_type!=pType){
			result_list.removeAll();
			p_type = pType;
		}
		
	}
	
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
				
			};
		var auxURL:String; 
		if(_global.DEBUG_IN_IDE){
			auxURL = p_url;		//for xml file dont append search param to end of querystring
		}else{
			auxURL = p_url + "&name=" + search_txt.text;
		}
		oLoader.load(x,auxURL,loaderListener);
	};
	
}