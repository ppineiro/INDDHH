function btnAnt_click() {
	document.getElementById("frmMain").action = "query.OffLineAction.do?action=openResultPage&page=" + (PAGE - 1);
	submitForm(document.getElementById("frmMain"));
}

function btnSig_click() {
	document.getElementById("frmMain").action = "query.OffLineAction.do?action=openResultPage&page=" + (PAGE + 1);
	submitForm(document.getElementById("frmMain"));
}

function btnBack_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "query.OffLineAction.do?action=backToOff&query=" + QUERY_ID;
		submitForm(document.getElementById("frmMain"));
	}
}

function btnExit_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}