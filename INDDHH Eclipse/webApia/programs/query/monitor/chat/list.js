function getSelectedId(){
	var rowId;
	var oRow = document.getElementById("gridList").selectedItems[0];
	if (oRow == null) return null;
	rowId = oRow.getAttribute("row_id");
	return rowId;
}


function btnView_click() {
	var rowId = getSelectedId();
	if(rowId!=null){
		document.getElementById("frmMain").target = ""
		document.getElementById("frmMain").action = "query.MonitorChatAction.do?action=view&" + rowId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorChatAction.do?action=filter";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorChatAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorChatAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorChatAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorChatAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="query.MonitorChatAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}

function btnBack_click(){
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorChatAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
