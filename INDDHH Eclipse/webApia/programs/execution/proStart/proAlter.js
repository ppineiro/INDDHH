function btnSearch_click() {
	document.getElementById("frmMain").action = "execution.ProStartAction.do?action=search";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "execution.ProStartAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "execution.ProStartAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "execution.ProStartAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "execution.ProStartAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="execution.ProStartAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}
function orderBy(order){
	document.getElementById("frmMain").action = "execution.ProStartAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function btnAlt_click() {

var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "execution.ProStartAction.do?action=startAlter";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}

}

function btnExit_click(){
	splash();
}

