
import mx.controls.Alert;

keyListener = new Object();
keyListener.onKeyUp = function(){
	var theKeyPressed = Key.getCode();
	if(theKeyPressed == 113){
		getURL("JavaScript:top.toggleExplorer()");
	}
}
Key.addListener(keyListener);


showMsg = function(p_msg:String){
	var alertListener = new Object();
		alertListener.click = function(evt) {
			if (evt.detail == Alert.OK){
				trace("_________OK")
			}else{
				trace(evt.detail)
			}
		}
	var alertDialog = mx.controls.Alert;
	/*
	var msgStyles = new CSSStyleDeclaration();
		msgStyles.setStyle("fontSize", 9);
		alertDialog.messageStyleDeclaration = msgStyles;
	*/
		//alertDialog.width = 300;
		//alertDialog.scaleX = 300;
		
		alertDialog.show(p_msg, "Exception                                               ", Alert.OK, this, alertListener, "stockIcon", Alert.OK);
	//Alert.show(p_msg, "Exception", Alert.OK, this, alertListener, "stockIcon", Alert.OK);
};


_global.isXMLexception = function(oXML:XML):Boolean{
	if(oXML.firstChild.nodeName == "EXCEPTION"){
		showMsg(oXML.firstChild.firstChild.nodeValue);
		return true;
	}else{
		return false;
	}
};



_global.debug = function(exp){
	var tmp = _root._url.substr(0,4);
	if(tmp == "file"){
		trace(exp);
	}else{
		getURL("javascript:alert('" + exp + "')");
	}
}

