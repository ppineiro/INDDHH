function btnVol_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impbackstep2";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnShowObjects_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";

		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impconflictobjects";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnMapObjects_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant >= 1) {
		document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";

		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impconflictmap";
		submitForm(document.getElementById("frmMain"));
	} else if (cant <= 0) {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnRemoveObjects_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant >= 1) {
		document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";

		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impconflictremove";
		submitForm(document.getElementById("frmMain"));
	} else if (cant <= 0) {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnUpdateObjects_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant >= 1) {
		document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";

		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impconflictupdate";
		submitForm(document.getElementById("frmMain"));
	} else if (cant <= 0) {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}
