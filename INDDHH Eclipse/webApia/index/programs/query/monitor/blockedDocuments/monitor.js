//***********************************************//
//			ACCIONES DEL FORMULARIO
//***********************************************//
function btnUnLock_click(){
	var rowId = getSelectedTaskId();
	if(rowId!=null){
		document.getElementById("frmMain").target = ""
		document.getElementById("frmMain").action = "query.MonitorBlockedDocumentsAction.do?action=unLock&"+rowId;
		submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
	
}

function btnSearch_click() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorBlockedDocumentsAction.do?action=filter";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorBlockedDocumentsAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorBlockedDocumentsAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorBlockedDocumentsAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorBlockedDocumentsAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="query.MonitorBlockedDocumentsAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}

function orderBy(order){
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorBlockedDocumentsAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}


//***********************************************//
//			ACCIONES DE SELECI?N
//***********************************************//

var lastSelection = null;

function deselectRowOrCell(r) {
  r.className = r.orgClassName;
  r.selected=false;
}

function selectRowOrCell(r) {
  r.orgClassName = r.className;
  r.className = "trSelected";
  r.selected=true;
}

function selectTask(element) {
	var e, r, c;
	if (element == null) {
    	e = window.event.srcElement;
	} else {
    	e = element;
	}
  	if (e.tagName == "TR") {
    	r = findRow(e);
		if (r != null) {
	      	if (lastSelection != null) {
	        	deselectRowOrCell(lastSelection);
	      	}
	      	selectRowOrCell(r);
	      	lastSelection = r;
    	}
	} else {
		c = findCell(e);
		if (c != null) {
			if (lastSelection != null) {
				deselectRowOrCell(lastSelection);
			}
			selectRowOrCell(c);
			lastSelection = c;
		}
	}

	window.event.cancelBubble = true;
}

function findCell(e) {
	if (e.tagName == "TD") {
		return findRow(e.parentNode);
	} else if (e.tagName == "BODY") {
		return null;
	} else {
		return findCell(e.parentNode);
	}
}


document.onclick = cancelSelect;

function findRow(e) {
	if (e.tagName == "TR" && e.rowIndex!=0) {
		return e;
	} else if (e.tagName == "BODY") {
		return null;
	} else {
		return findRow(e.parentNode);
	}
}

function cancelSelect() {
	if (lastSelection != null) {
		deselectRowOrCell(lastSelection);
		lastSelection = null;
	}
}

function getSelectedTaskId(){
	var rowId;
	var oRows = (document.getElementById("gridList").selectedItems.length>0)?document.getElementById("gridList").selectedItems[0].getAttribute("row_id"):null;
	return oRows;
}

//***********************************************//
//			ACCIONES DEL FILTRO
//***********************************************//

function selType_change() {
	document.getElementById("txtRelTitle").disabled = document.getElementById("selType").value == "";
	document.getElementById("txtRelNamePre").disabled = ! (document.getElementById("selType").value == DOC_TYPE_PROCESS_INST || document.getElementById("selType").value == DOC_TYPE_BUS_ENT_INST );
	document.getElementById("txtRelNameNum").disabled = document.getElementById("txtRelNamePre").disabled;
	document.getElementById("txtRelNamePos").disabled = document.getElementById("txtRelNamePre").disabled;

	if (document.getElementById("txtRelTitle").disabled) {
		document.getElementById("txtRelTitle").readOnly = true;
		document.getElementById("txtRelTitle").className = "txtReadOnly";
	} else {
		document.getElementById("txtRelTitle").readOnly = false;
		document.getElementById("txtRelTitle").className = "";
	}

	if (document.getElementById("txtRelNamePre").disabled) {
		document.getElementById("txtRelNamePre").readOnly = true;
		document.getElementById("txtRelNamePre").className = "txtReadOnly";
	} else {
		document.getElementById("txtRelNamePre").readOnly = false;
		document.getElementById("txtRelNamePre").className = "";
	}

	document.getElementById("txtRelNameNum").readOnly = document.getElementById("txtRelNamePre").readOnly;
	document.getElementById("txtRelNameNum").className = document.getElementById("txtRelNamePre").className;
	document.getElementById("txtRelNamePos").readOnly = document.getElementById("txtRelNamePre").readOnly;
	document.getElementById("txtRelNamePos").className = document.getElementById("txtRelNamePre").className;
}

window.onload=function() {
	selType_change();
}
