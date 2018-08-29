var lastSelection = null;

function getSelectedTaskId(){
	var rowId;
	var oRows = document.getElementById("gridList").rows;
	for (var t=0;t<oRows.length;t++){
		if(oRows[t].selected==true){
			rowId = oRows[t].row_id || oRows[t].getAttribute('row_id');
		}
	}
	return rowId;
}

function deselectRowOrCell(r) {
  r.className = r.orgClassName;
  r.selected=false;
}

function selectRowOrCell(r) {
  r.orgClassName = r.className
  r.className = "trSelected";
  r.selected=true;
}

function selectProcess(element) {
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

///////////////////////////////////////////////
// Funciones de botones 
///////////////////////////////////////////////
function callEventOnChange(filter) {
	document.getElementById("frmMain").action = "query.TaskMonitorAction.do?action=eventOnChange&filter=" + filter;
	submitForm(document.getElementById("frmMain"));
}

function btnDet_click() {
	var proId= getSelectedTaskId();
	if(proId!=null){
		document.getElementById("frmMain").target = ""
		document.getElementById("frmMain").action = "query.TaskMonitorAction.do?action=viewDet&" + proId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnTsk_click() {
	var proId= getSelectedTaskId();
	if(proId!=null){
		document.getElementById("frmMain").target = ""
		document.getElementById("frmMain").action = "query.TaskMonitorAction.do?action=viewProTsks&" + proId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}


function btnHis_click(){
	var rowId = getSelectedTaskId();
	if(rowId!=null){
		document.getElementById("frmMain").target = "";
		document.getElementById("frmMain").action = "query.TaskMonitorAction.do?action=viewHis&" + rowId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.TaskMonitorAction.do?action=filter";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.TaskMonitorAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.TaskMonitorAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.TaskMonitorAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.TaskMonitorAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="query.TaskMonitorAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click(){
	splash();
}

/* ------------------------------------ */
/* --- Generaci?n archivos de lista --- */
/* ------------------------------------ */
function btnExport_click(field) {
	var rets = openModal("/programs/modals/export.jsp?hiddeXPDL=true",500,220);
	var doAfter=function(rets){
		if (rets != null) {
			if (rets[0] == "pdf") {
				btnPDF_click(rets[1]);
			} else if (rets[0] == "excel") {
				btnExcel_click(rets[1]);
			} else if (rets[0] == "csv") {
				btnCSV_click(rets[1]);
			} else if (rets[0] == "html") {
				btnHTML_click(rets[1]);
			} else if (rets[0] == "txt") {
				btnTXT_click(rets[1]);
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnHTML_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.TaskMonitorAction.do?action=generateHtml&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnCSV_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.TaskMonitorAction.do?action=generateCsv&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnTXT_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.TaskMonitorAction.do?action=generateTxt&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnExcel_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.TaskMonitorAction.do?action=generateExcel&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnPDF_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.TaskMonitorAction.do?action=generatePdf&count=" + count;
	document.getElementById("frmMain").submit();
}
