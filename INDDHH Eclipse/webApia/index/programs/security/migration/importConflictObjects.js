function btnVol_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=impbackconflicts";
		submitForm(document.getElementById("frmMain"));
	 }
}

function btnMapObject_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant >= 1) {
		document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";

		document.getElementById("frmMain").action = "security.MigrationAction.do?action=mapobject";
		submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnModifyObject_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";

		document.getElementById("frmMain").action = "security.MigrationAction.do?action=modifyobject";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnRemoveObject_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant >= 1) {
		document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";
	
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=removeobject";
		submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnUpdateObject_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant >= 1) {
		document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";
	
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=updateobject";
		submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}