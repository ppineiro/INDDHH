function modalUsers() {

	var rets = openModal("/security.ResetPwdAction.do?action=showModal&onlyOne=true&environment=all" ,500,300);
	var doAfter=function(rets){
		if(rets!=null){
			document.getElementById("txtUsu").value = rets[0][0]; //usrLogin
			document.getElementById("txtNom").value = rets[0][1] //oTd.usrName
			document.getElementById("txtEma").value = rets[0][2] //oTd.usrEmail
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
function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(AUTOMATIC || testRegExpPassword(document.getElementById("txtPwd"))){
			if (document.getElementById("txtPwd").value == document.getElementById("txtNewPwd").value){
				document.getElementById("frmMain").action = "security.ResetPwdAction.do?action=reset";
				submitForm(document.getElementById("frmMain"));
			} else {
				alert(SEC_PWD_MUST_BE_SAME);
			}
		} else {
			//document.getElementById("txtNewPwd").value = "";
		}
	}
}
function btnExit_click(){
	splash();
}