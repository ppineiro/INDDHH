function getSelectedId(){
	var rowId = "";
	
	for (var i = 0; i < getAmountSelected(); i++) {
		var oRow = document.getElementById("gridList").selectedItems[i];
		rowId += "&" + oRow.getAttribute("row_id");
	}
	
	return rowId;
}

function getAmountSelected() {
	return document.getElementById("gridList").selectedItems.length;
}

function btnView_click() {
	var amountSelected = getAmountSelected();
	if(amountSelected == 1){
		var rowId = getSelectedId();
		document.getElementById("frmMain").target = ""
		document.getElementById("frmMain").action = "query.BroadcastMonitorChatAction.do?action=view" + rowId;
		submitForm(document.getElementById("frmMain"));
	} else if (amountSelected == 0) {
		alert(GNR_CHK_AT_LEAST_ONE);		
	} else if (amountSelected > 1) {
		alert(GNR_CHK_ONLY_ONE);
	}
}

function btnDelete_click() {
	if(getAmountSelected() >= 1){
		var rowId = getSelectedId();
		document.getElementById("frmMain").target = ""
		document.getElementById("frmMain").action = "query.BroadcastMonitorChatAction.do?action=remove" + rowId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.BroadcastMonitorChatAction.do?action=search";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.BroadcastMonitorChatAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.BroadcastMonitorChatAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.BroadcastMonitorChatAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.BroadcastMonitorChatAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="query.BroadcastMonitorChatAction.do?action=page";
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
	document.getElementById("frmMain").action = "query.BroadcastMonitorChatAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
