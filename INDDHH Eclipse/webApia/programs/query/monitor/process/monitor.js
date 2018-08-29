function btnVis_click(id){
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=showTasks&" + id;
	submitForm(document.getElementById("frmMain"));
}

function btnDet_click(){
	var rowId = getSelectedTaskId();
	if(rowId!=null){
		document.getElementById("frmMain").target = ""
		document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=detail&" + rowId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnDetTsk_click(){
	var rowId = getSelectedTaskId();
	var rowFor = getSelectedTaskFor();
	if(rowId!=null){
		document.getElementById("frmMain").target = ""
		if (rowFor == "T") {
			document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=detailTask&" + rowId;
		} else {
			document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=detailSub&" + rowId;
		}
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function validateTask(){
	var rowFor = getSelectedTaskFor();
	document.getElementById("btnTskSub").disabled=true;
	if(rowFor!="T"){
		document.getElementById("btnTskSub").disabled=false;
	}
}

function btnTsk_click(){
	var rowId = getSelectedTaskId();
	if(rowId!=null){
		document.getElementById("frmMain").target = ""
		document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=tasks&" + rowId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnAnt_click(){
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=backTasks";
	submitForm(document.getElementById("frmMain"));	
}


function btnTskSub_click(){
	var rowId = getSelectedTaskId();
	var rowFor = getSelectedTaskFor();
	if(rowId!=null && rowFor != null && rowFor != "T"){
		document.getElementById("frmMain").target = ""
		document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=tasksSub&" + rowId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnBack_click(){
	//var msg = confirm(GNR_PER_DAT_ING);
	//if (msg) {
		document.getElementById("frmMain").target = ""
		if (hasParent) {
			document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=backTask";
		} else if (hasQueryProcessMonitor) {
		  	document.getElementById("frmMain").action = "query.ProcessMonitorAction.do?action=backList";
		} else if (hasQueryTaskMonitor) {
		  	document.getElementById("frmMain").action = "query.TaskMonitorAction.do?action=backList";
		} else if (hastEntityMonitor) {
			document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=backFromProTasks";
		} else {
			document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=backToList";
		}
		submitForm(document.getElementById("frmMain"));
	//}
}

function btnSearch_click() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=filter";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="query.MonitorProcessesAction.do?action=page";
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
	document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function showTsk_change(){
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorProcessesAction.do?action=showTasks";
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

function getSelectedTaskId(){
	var rowId;
	if(document.getElementById("gridList").selectedItems.length>0){
		var oRow = document.getElementById("gridList").selectedItems[0];
		rowId = oRow.getAttribute("row_id");
	}
	return rowId;
}

function getSelectedTaskFor(){
	var rowFor;
	if(document.getElementById("gridList").selectedItems.length>0){
		var oRows = document.getElementById("gridList").selectedItems[0];
		rowFor = oRows.getAttribute("row_for");
	}
	return rowFor;
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
	document.getElementById("frmMain").action="query.MonitorProcessesAction.do?action=generateCsv&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnExcel_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.MonitorProcessesAction.do?action=generateExcel&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnPDF_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.MonitorProcessesAction.do?action=generatePdf&count=" + count;
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
	document.getElementById("frmMain").action="query.MonitorProcessesAction.do?action=generateTaskCsv&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnTskExcel_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.MonitorProcessesAction.do?action=generateTaskExcel&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnTskPDF_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.MonitorProcessesAction.do?action=generateTaskPdf&count=" + count;
	document.getElementById("frmMain").submit();
}
