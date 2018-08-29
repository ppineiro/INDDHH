function btnVol_click() {
	var msg = confirm(GNR_PER_DAT_ING);
		if (msg) {
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=init";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnSal_click(){
	splash();
}


