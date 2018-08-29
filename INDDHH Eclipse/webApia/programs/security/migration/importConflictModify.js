function btnVol_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impbackconflictobjects";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnCon_click(){
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=modifyobjectconfirm";
	submitForm(document.getElementById("frmMain"));
}

