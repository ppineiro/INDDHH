function btnSig_click(){
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=expstep3";
	submitForm(document.getElementById("frmMain"));
}

function btnAnt_click() {
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=expstep1";
	submitForm(document.getElementById("frmMain"));
}

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

function removeSelected_click() {
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=expremsel";
	submitForm(document.getElementById("frmMain"));
}

