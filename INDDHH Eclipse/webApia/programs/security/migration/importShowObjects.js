function btnVol_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impbackstep2";
		submitForm(document.getElementById("frmMain"));
	}
}
