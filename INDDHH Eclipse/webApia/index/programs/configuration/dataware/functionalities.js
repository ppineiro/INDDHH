function btnConf_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "analitic.DatawareAction.do?action=confFunct";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnExit_click(){
	splash();
}