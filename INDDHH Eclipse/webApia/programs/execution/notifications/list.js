function btnView_click() {
	//var cant = chksChecked(gridList);
	var cant = document.getElementById("gridList").selectedItems;
	if(cant.length == 1) {
		cant[0].getElementsByTagName("INPUT")[0].checked=true;
		document.getElementById("frmMain").action = "execution.NotificationAction.do?action=view";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}
function btnEli_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
			document.getElementById("frmMain").action = "execution.NotificationAction.do?action=renmove";
			submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").action = "execution.NotificationAction.do?action=search";
	submitForm(document.getElementById("frmMain"));
}

function orderBy(order){
	document.getElementById("frmMain").action = "execution.NotificationAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function markUnMark(action){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
			document.getElementById("frmMain").action = action;
			submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function first() {
	document.getElementById("frmMain").action = "execution.NotificationAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "execution.NotificationAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "execution.NotificationAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "execution.NotificationAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="execution.NotificationAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "execution.NotificationAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
