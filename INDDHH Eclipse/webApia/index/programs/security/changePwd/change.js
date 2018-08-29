function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(testRegExpPassword(document.getElementById("txtPwd"))){
			if (document.getElementById("txtPwd").value == document.getElementById("txtNewPwd").value){
				document.getElementById("frmMain").action = "security.ChangePwdAction.do?action=change";
				submitForm(document.getElementById("frmMain"));
			} else {
				alert(SEC_PWD_MUST_BE_SAME);
			}
		} else {
			document.getElementById("txtNewPwd").value = "";
		}
	}
}
function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}
