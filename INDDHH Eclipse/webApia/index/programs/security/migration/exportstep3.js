function btnCon_click(){
	var file = document.getElementById("frmMain").tbxExpFile.value;
	
	if (file == null || file == "") {
		alert('Debe ingresar el nombre del archivo de exportacion');
		document.getElementById("frmMain").tbxExpFile.focus();
		return;
	}
	
	document.getElementById("iframeKeepActive").src = "security.MigrationAction.do?action=keepActive";
	
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=expconfirm";
	submitForm(document.getElementById("frmMain"));
}

function btnAnt_click() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=expbackstep2";
	submitForm(document.getElementById("frmMain"));
}

function btnVol_click() {
	document.getElementById("frmMain").target = "";
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=init";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnSal_click(){
	splash();
}

function btnDownload_click() {
	document.getElementById("frmMain").target = "downloadIFrame";
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=expdownload";
	document.getElementById("frmMain").submit();
}