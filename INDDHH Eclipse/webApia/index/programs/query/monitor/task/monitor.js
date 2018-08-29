function btnDet_click(){
	var rowId = getSelectedTaskId();
	if(rowId!=null){
		document.getElementById("frmMain").target = "";
		document.getElementById("frmMain").action = "query.MonitorTasksAction.do?action=details&" + rowId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnHis_click(){
	var rowId = getSelectedTaskId();
	if(rowId!=null){
		document.getElementById("frmMain").target = "";
		document.getElementById("frmMain").action = "query.MonitorTasksAction.do?action=history&" + rowId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnDetTsk_click() {
	var rowId = getSelectedTaskId();
	if(rowId!=null){
		document.getElementById("frmMain").target = "";
		document.getElementById("frmMain").action = "query.MonitorTasksAction.do?action=detailsHis&" + rowId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnTsk_click() {
	var rowId = getSelectedTaskId();
	if(rowId != null){
		document.getElementById("frmMain").target = "";
		document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=tasksTask&" + rowId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnBack_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").target = "";
		if (fromQueryTaskMonitor) {
			document.getElementById("frmMain").action = "query.TaskMonitorAction.do?action=backList";
		} else {
			document.getElementById("frmMain").action = "query.MonitorTasksAction.do?action=backToList";
		}
		submitForm(document.getElementById("frmMain"));
	}
}

function btnSearch_click() {
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").target = "";
		document.getElementById("frmMain").action = "query.MonitorTasksAction.do?action=filter";
		submitForm(document.getElementById("frmMain"));
	}
}

function first() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.MonitorTasksAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.MonitorTasksAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.MonitorTasksAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.MonitorTasksAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="query.MonitorTasksAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="query.MonitorTasksAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}

function orderBy(order){
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.MonitorTasksAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

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
	if(document.getElementById("gridList").selectedItems.length>0){
		var oRow = document.getElementById("gridList").selectedItems[0];
		rowId = oRow.getAttribute("row_id");
	}
	return rowId;
}

/* ------------------------------------ */
/* --- Generaci?n archivos de lista --- */
/* ------------------------------------ */
function btnExport_click(field) {
	var rets = openModal("/programs/modals/export.jsp?hiddeHtml=true&hiddeXPDL=true&hiddeTXT=true",500,220);
	var doAfter=function(rets){
		if (rets != null) {
			if (rets[0] == "pdf") {
				btnPDF_click(rets[1]);
			} else if (rets[0] == "excel") {
				btnExcel_click(rets[1]);
			} else if (rets[0] == "csv") {
				btnCSV_click(rets[1]);
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
	}else{
		doAfter(rets);
	}*/
}

function btnCSV_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.MonitorTasksAction.do?action=generateCsv&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnExcel_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.MonitorTasksAction.do?action=generateExcel&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnPDF_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.MonitorTasksAction.do?action=generatePdf&count=" + count;
	document.getElementById("frmMain").submit();
}

/* ------------------------------------- */
/* --- Generaci?n archivos de tareas --- */
/* ------------------------------------- */
function btnTskExport_click(field) {
	var rets = openModal("/programs/modals/export.jsp?hiddeHtml=true&hiddeXPDL=true&hiddeTXT=true&hiddeCount=true",500,220);
	var doAfter=function(rets){
		if (rets != null) {
			if (rets[0] == "pdf") {
				btnTskPDF_click(rets[1]);
			} else if (rets[0] == "excel") {
				btnTskExcel_click(rets[1]);
			} else if (rets[0] == "csv") {
				btnTskCSV_click(rets[1]);
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
	}else{
		doAfter(rets);
	}*/
}

function btnTskCSV_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.MonitorTasksAction.do?action=generateTaskCsv&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnTskExcel_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.MonitorTasksAction.do?action=generateTaskExcel&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnTskPDF_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.MonitorTasksAction.do?action=generateTaskPdf&count=" + count;
	document.getElementById("frmMain").submit();
}

