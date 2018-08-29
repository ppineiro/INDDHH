function first() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=firstHis";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=prevHis";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=nextHis";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=lastHis";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="query.MonitorEntityAction.do?action=pageHis";
	submitForm(document.getElementById("frmMain"));
}

function filterByAttribute() { 
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=attribute";
	submitForm(document.getElementById("frmMain"));
}

function sortHistoryBy(orderBy) { 
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=orderHis&orderBy=" + orderBy;
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click(){
	splash();
}

function btnBack_click() {
	if (FROM_QUERY) {
		document.getElementById("frmMain").action = "query.EntityMonitorAction.do?action=backToList";
	} else {
		document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=backToList";
	}
	submitForm(document.getElementById("frmMain"));
}


function btnTsk_click(){
	var rowId = getSelectedTaskId();
	if(rowId!=null){
		document.getElementById("frmMain").target = ""
		document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=viewTsk&" + rowId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}


function getSelectedTaskId(){
	var rowId;
	var oRow = document.getElementById("gridListInst").selectedItems[0];
	rowId = oRow.getAttribute("row_id");
	return rowId;
}
