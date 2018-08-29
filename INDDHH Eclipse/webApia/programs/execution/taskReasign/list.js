function btnLibUsr_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		var selItem = document.getElementById("gridList").selectedItems[0].rowIndex-1;
		var trows=document.getElementById("gridList").rows;
		var acquiredDate = trows[selItem].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value;
		if (acquiredDate==null || acquiredDate=="" || acquiredDate=="null"){
			alert(MSG_TAR_NOT_ACQUIRED);
			return;
		}
		document.getElementById("frmMain").action = "execution.TaskReasignAction.do?action=reasign&mode=user";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnLibPool_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "execution.TaskReasignAction.do?action=reasign&mode=pool";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").action = "execution.TaskReasignAction.do?action=setFilter";
	submitForm(document.getElementById("frmMain"));
}

function orderBy(order){
	document.getElementById("frmMain").action = "execution.TaskReasignAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "execution.TaskReasignAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "execution.TaskReasignAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "execution.TaskReasignAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "execution.TaskReasignAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="execution.TaskReasignAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}

function splash_iframe(){
	splash();
}