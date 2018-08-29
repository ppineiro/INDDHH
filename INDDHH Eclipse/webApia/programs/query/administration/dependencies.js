function btnBack_click() {
	document.getElementById("frmMain").action = "query.AdministrationAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click(){
	splash();
}

function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "query.AdministrationAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}