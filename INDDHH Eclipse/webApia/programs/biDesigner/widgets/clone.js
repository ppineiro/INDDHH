function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("txtName").value)){
			document.getElementById("frmMain").action = "biDesigner.WidgetAction.do?action=confClone";
			submitForm(document.getElementById("frmMain"));
		}
	}
}
function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}
function btnBack_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "biDesigner.WidgetAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}