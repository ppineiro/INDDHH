var lastSelection = null;

function getSelectedBusEntInstId(){
	var rowId;
	var oRow = document.getElementById("gridList").selectedItems[0];
	rowId = oRow.getAttribute("row_id");
	return rowId;
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

function findRow(e) {
	if (e.tagName == "TR" && e.rowIndex!=0) {
		return e;
	} else if (e.tagName == "BODY") {
		return null;
	} else {
		return findRow(e.parentNode);
	}
}

///////////////////////////////////////////////
// Funciones de botones 
///////////////////////////////////////////////
function callEventOnChange(filter) {
	document.getElementById("frmMain").action = "query.EntityMonitorAction.do?action=eventOnChange&filter=" + filter;
	submitForm(document.getElementById("frmMain"));
}

function btnDet_click() {
	var busEntInstId= getSelectedBusEntInstId();
	if(busEntInstId!=null){
		document.getElementById("frmMain").target = ""
		document.getElementById("frmMain").action = "query.EntityMonitorAction.do?action=viewHis&" + busEntInstId;
		submitForm(document.getElementById("frmMain"));	
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.EntityMonitorAction.do?action=filter";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.EntityMonitorAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.EntityMonitorAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.EntityMonitorAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.EntityMonitorAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="query.EntityMonitorAction.do?action=page";
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
	document.getElementById("frmMain").action="query.EntityMonitorAction.do?action=generateHtml&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnCSV_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.EntityMonitorAction.do?action=generateCsv&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnTXT_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.EntityMonitorAction.do?action=generateTxt&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnExcel_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.EntityMonitorAction.do?action=generateExcel&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnPDF_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.EntityMonitorAction.do?action=generatePdf&count=" + count;
	document.getElementById("frmMain").submit();
}



function stringType(field) {
	var rets = openModal("/programs/query/administration/filter/string.jsp?type=" + document.getElementById(field).value,500,200);
	var doAfter=function(rets){
		if (rets != null) {
			document.getElementById(field).value = rets;
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}


function numberType(field) {
	var rets = openModal("/programs/query/administration/filter/number.jsp?type=" + document.getElementById(field).value,500,220);
	var doAfter=function(rets){
		if (rets != null) {
			document.getElementById(field).value = rets;
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}
