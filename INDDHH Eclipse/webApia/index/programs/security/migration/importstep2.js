function btnShowUpdates_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 0) {
		document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";

		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impupdates";
		submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_NONE);
	}	
}

function btnShowObjects_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";

		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impshowobject";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnConflicts_click(){
	document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=impconflicts";
	submitForm(document.getElementById("frmMain"));
}

function btnCon_click(){
	document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";

	document.getElementById("frmMain").action = "security.MigrationAction.do?action=impconfirm";
	submitForm(document.getElementById("frmMain"));
}

function btnAnt_click() {
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=impstep1";
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

function btnRemoveJS_click() {
	var cant = chksChecked(document.getElementById("jsGridList"));
	if(cant >= 1) {
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impremovejs";
		submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnShowJS_click() {
	var cant = chksChecked(document.getElementById("jsGridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impshowjs";
		submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_ONLY_ONE);
	}
}
