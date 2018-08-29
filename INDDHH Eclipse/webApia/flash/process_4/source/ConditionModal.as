

import mx.controls.TextArea;
import mx.controls.Button;
import com.qlod.LoaderClass;

class ConditionModal extends MovieClip{
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	var cnd_txt:TextArea;
	var help_txt:TextField;
	
	var conditionValue:String;
	
	var XML_VAL_EXPR:String;
	var oLoader:LoaderClass;
	
	function ConditionModal(Void){
		XML_VAL_EXPR = _global.XML_CONDITION;
		var thisModal = this;
		oLoader = new LoaderClass();
		
		conditionValue = thisModal._parent.conditionValue;
		
		 this.confirm_btn.onPress = function() {
			 thisModal.valExprConditionXML(thisModal.cnd_txt.text);
		 };
		 
		 this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
	};
	
	
	function onLoad(){
		//SET BTN LABELS
		confirm_btn.label = _global.labelVars.lbl_btnConfirm;
		cancel_btn.label = _global.labelVars.lblbtnCancel;
		//SET HELP TXT
		help_txt.text = unescape(_global.labelVars.lblConditionRules);
		//SET CONDITION TXT
		if(conditionValue!=null && conditionValue!=undefined && conditionValue!=""){
			cnd_txt.text = conditionValue;
		}else{
			cnd_txt.text = "";
		}
		
	};
	
	/////////////////////////////////////
	// VALIDATE EXPRESSION
	////////////////////////////////////
	/*
	function valExprConditionXML(p_expr:String){
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
				var msg = x.firstChild.firstChild.nodeName;
				if(msg=="MESSAGE"){
					thisModal._parent.dispatchEvent({type:"ok",conditionValue:p_expr});
				}
			};
			
		var auxURL:String; 
		if(_global.DEBUG_IN_IDE){
			auxURL = XML_VAL_EXPR;
		}else{
			auxURL = XML_VAL_EXPR + "&value=" + p_expr;
		}
		trace("INIT LOAD" + auxURL)
		oLoader.load(x,auxURL,loaderListener);
	};
	*/
	function valExprConditionXML(p_expr:String){
		var thisModal = this;
		
		if(_global.DEBUG_IN_IDE){
			//BYPASS XML VALIDATION IN SERVER
			thisModal._parent.dispatchEvent({type:"ok",conditionValue:p_expr});
		}else{
			//SERVER VAL [post XML]
			var auxURL = XML_VAL_EXPR;
			
			var expr_str:String = "value=" + escape(p_expr);
			var send_xml:XML = new XML(expr_str);
			
			var myReply_xml:XML = new XML();
				myReply_xml.ignoreWhite = true;
				myReply_xml.onLoad = function(success:Boolean){
					if (success) {
						if ((myReply_xml.firstChild.nodeName == "MESSAGE")) {
						  thisModal._parent.dispatchEvent({type:"ok",conditionValue:p_expr});
						}else{
						  //error show exception
						  if(_global.isXMLexception(myReply_xml)==true){
							  
						  }
						}
					 }else {
						//trace("ERROR LOADING")
					 }
				};
				
			send_xml.sendAndLoad(auxURL, myReply_xml);
		}
	};
	
	
	
}