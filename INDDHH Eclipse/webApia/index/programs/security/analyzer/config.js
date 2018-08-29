function btnGen_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "security.AnalyzerAction.do?action=analyze";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnExit_click(){
	splash();
}
