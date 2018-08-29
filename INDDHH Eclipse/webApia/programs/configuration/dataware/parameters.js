function btnConf_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "analitic.DatawareAction.do?action=change";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnTest_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "analitic.DatawareAction.do?action=test";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnExit_click(){
	splash();
}

//--------------------------------------------
//-- Funciones para trabajar con los atributos
//--------------------------------------------

function btnRemAtt_click(val,type) {
	document.getElementById('hidAttId'+type+val).value = "";
	document.getElementById('txtAttNam'+type+val).value = "";
	document.getElementById('cmbAttFrom'+type+val).disabled = true;
}

function btnLoadAtt_click(val,type) {
	var rets = openModal("/programs/modals/atts.jsp?onlyOne=true&type=" + type,500,300);
	var id;
	var name;
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var ok = true;
			
				var count = 0;
				if (TYPE_STRING == type) {
					count = COUNT_STRING;
				} else if (TYPE_NUMERIC == type) {
					count = COUNT_NUMERIC;
				} else if (TYPE_DATE == type) {
					count = COUNT_DATE;
				}
				
				for (i = 0; i < count && ok; i++) {
					ok = ok && document.getElementById('hidAttId'+type+i).value != ret[0];
				}
				
				if (ok) {
					document.getElementById('hidAttId'+type+val).value = ret[0];
					document.getElementById('txtAttNam'+type+val).value = ret[1];
					document.getElementById('cmbAttFrom'+type+val).disabled = false;
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doAfter(rets);
	}*/
}



