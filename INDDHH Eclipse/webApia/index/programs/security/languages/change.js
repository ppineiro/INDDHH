function btnConf_click() {
	document.getElementById("frmMain").action = "security.LanguageAction.do?action=confirmLang";
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click(){
	splash();
}