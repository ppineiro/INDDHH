function btnConf_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "execution.TasksReleaseAction.do?action=confirm";
		submitForm(document.getElementById("frmMain"));
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
		document.getElementById("frmMain").action = "execution.TasksReleaseAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}