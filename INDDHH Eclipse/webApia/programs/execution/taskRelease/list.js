function btnLib_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant > 0) {
		document.getElementById("frmMain").action = "execution.TasksReleaseAction.do?action=release";
		submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").action = "execution.TasksReleaseAction.do?action=setFilter";
	submitForm(document.getElementById("frmMain"));
}

function orderBy(order){
	document.getElementById("frmMain").action = "execution.TasksReleaseAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "execution.TasksReleaseAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "execution.TasksReleaseAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "execution.TasksReleaseAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "execution.TasksReleaseAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="execution.TasksReleaseAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}

function splash_iframe(){
	splash();
}