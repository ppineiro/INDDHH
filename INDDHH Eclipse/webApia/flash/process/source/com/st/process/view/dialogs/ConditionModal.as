import com.st.util.WindowManager;
import mx.controls.Alert;
import mx.controls.TextArea;
import mx.controls.Button;
import com.qlod.LoaderClass;

class com.st.process.view.dialogs.ConditionModal extends MovieClip{
	
	var confirm_btn:Button;
	var cancel_btn:Button;
	var doc_btn:Button;
	
	var cnd_txt:TextArea;
	var help_txt:TextField;
	
	var conditionValue:String;
	var conditionDocValue:String;
	
	var XML_VAL_EXPR:String;
	var oLoader:LoaderClass;
	
	function ConditionModal(Void){
		XML_VAL_EXPR = _global.XML_CONDITION;
		var thisModal = this;
		oLoader = new LoaderClass();
		
		conditionDocValue = thisModal._parent.conditionDocValue;
		conditionValue = thisModal._parent.conditionValue;
		
		this.confirm_btn.onPress = function() {
			thisModal.valExprConditionXML(thisModal.cnd_txt.text);
		};
		
		this.cancel_btn.onPress = function() {
			thisModal._parent.dispatchEvent({type:"click"});
		};
		
		this.doc_btn.onPress = function() {
			thisModal.showConditionDoc();
		};
	};
	
	
	function onLoad(){
		//SET BTN LABELS
		confirm_btn.label 	= _global.labelVars.lbl_btnConfirm;
		cancel_btn.label 	= _global.labelVars.lblbtnCancel;
		doc_btn.label		= _global.labelVars.lblbtnDocumentation;
		
		cnd_txt.setStyle("fontFamily","courier");
		
		//SET HELP TXT
		help_txt.html = true;
		//help_txt.text = unescape(_global.labelVars.lblConditionRules);
		help_txt.htmlText=_global.labelVars.lblConditionRules;
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
			thisModal._parent.dispatchEvent({type:"ok",conditionValue:p_expr,conditionDocValue:thisModal.conditionDocValue});
		}else{
			//SERVER VAL [post XML]
			var auxURL = XML_VAL_EXPR;
			
			var expr_str:String = "value=" + escape(p_expr);
			var send_xml:XML = new XML(expr_str);
			
			var myReply_xml:XML = new XML();
				myReply_xml.ignoreWhite = true;
				myReply_xml.onLoad = function(success:Boolean){
					if (success) {
						var thisModal2=thisModal;
						if ((myReply_xml.firstChild.nodeName == "MESSAGE")) {
						  thisModal._parent.dispatchEvent({type:"ok",conditionValue:p_expr,conditionDocValue:thisModal.conditionDocValue});
						}else{
						  //error show exception
//						  if(_global.isXMLexception(myReply_xml)==true){
						if ((myReply_xml.firstChild.nodeName == "EXCEPTION")) {
							var error=myReply_xml.firstChild.firstChild.nodeValue;
							var a=Alert.show("             "+error+"             ", "Error", Alert.OK,thisModal2)
							a._x=(Stage.width/2);
							a._y=(Stage.height/2);							
						  }
						}
					 }else {
						//trace("ERROR LOADING")
					 }
				};
				
			send_xml.sendAndLoad(auxURL, myReply_xml);
			//myReply_xml.load("error.xml");
		}
	};
	
	
	
	
	
	function showConditionDoc(){
		trace("OPEN! CONDITION DOC MODAL")
		var objEvt = new Object();
		objEvt.scope=this;
		objEvt.ok = function(evt){
			var newCondDoc:String = evt.conditionDocValue;
			this.scope.conditionDocValue=newCondDoc;
			this.popUp.deletePopUp();
		}
		objEvt.click = function(evt:Object):Void{
			trace("CANCEL CONDITION DOC MODAL")
			this.popUp.deletePopUp();
		}
		
		objEvt.popUp=_level5.showConditionDoc(conditionDocValue,objEvt);
		/*
		
		var thisModal = this;
		var configOBj = new Object();
		configOBj.closeButton = true;
		configOBj.contentPath = "ConditionDocModal";
		configOBj.title = _global.labelVars.lbl_ConditionModalTitle.toUpperCase();
		configOBj._width = 460;
		configOBj._height = 180;
		configOBj.conditionDocValue = conditionDocValue;
		
		var objEvt = new Object();
		objEvt.scope=this;
		objEvt.ok = function(evt){
			var newCondDoc:String = evt.conditionDocValue;
			this.scope.conditionDocValue=newCondDoc;
			this.popUp.deletePopUp();
		}
		objEvt.click = function(evt:Object):Void{
			trace("CANCEL CONDITION DOC MODAL")
			this.popUp.deletePopUp();
		}
		
		objEvt.popUp = WindowManager.popUp(configOBj,this);
		objEvt.popUp.addEventListener("ok", objEvt);
		objEvt.popUp.addEventListener("click", objEvt);*/
		
		
	}
	
	

	
	
}