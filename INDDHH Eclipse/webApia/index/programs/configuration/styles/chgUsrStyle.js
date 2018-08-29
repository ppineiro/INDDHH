function btnConf_click() {
	document.getElementById("frmMain").action = "configuration.StylesAction.do?action=confirmUsrStyle";
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click(){
	splash();
}