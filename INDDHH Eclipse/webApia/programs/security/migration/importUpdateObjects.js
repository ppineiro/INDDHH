function btnVol_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impbackupdates";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnRemoveObject_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant >= 1) {
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=removeupdateobject";
		submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

