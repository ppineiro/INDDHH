function btnImport_click(){
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=impstep1";
	submitForm(document.getElementById("frmMain"));
}

function btnExport_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=expstep1";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function orderBy(order){
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function btnSearch_click() {
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=search";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}

function prev() {
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}

function next() {
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}

function last() { 
	document.getElementById("frmMain").action = "security.MigrationAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="security.MigrationAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}
