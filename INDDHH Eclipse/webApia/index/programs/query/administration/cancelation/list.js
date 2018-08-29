var submitPerformed = false;
function btnExport_click(field) {
	var rets = openModal("/programs/modals/export.jsp?hiddeCount=true&hiddeHtml=true&hiddeXPDL=true&isQuery=false",500,220);
	var doAfter=function(rets){
		if (rets != null) {
			if (rets[0] == "pdf") {
				btnPDF_click(rets[1]);
			} else if (rets[0] == "excel") {
				btnExcel_click(rets[1]);
			} else if (rets[0] == "csv") {
				btnCSV_click(rets[1]);
			} else if (rets[0] == "txt") {
				btnTXT_click(rets[1]);
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnCSV_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.QryProCancelAction.do?action=generateCsv&count=" + count;
	document.getElementById("frmMain").submit();
	document.getElementById("frmMain").target = "_self";
}

function btnTXT_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.QryProCancelAction.do?action=generateTxt&count=" + count;
	document.getElementById("frmMain").submit();
	document.getElementById("frmMain").target = "_self";
}

function btnExcel_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.QryProCancelAction.do?action=generateExcel&count=" + count;
	document.getElementById("frmMain").submit();
	document.getElementById("frmMain").target = "_self";
}

function btnPDF_click(count) {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action="query.QryProCancelAction.do?action=generatePdf&count=" + count;
	document.getElementById("frmMain").submit();
	document.getElementById("frmMain").target = "_self";
}

function submitFormReload(obj) {
	if (submitPerformed ==  true){
		return false;
	}
	obj.target = "_self";
	submitForm(obj);
	submitPerformed = true;
}

function callEventOnChange(filter) {
	document.getElementById("frmMain").action = "query.QryProCancelAction.do?action=eventOnChange&filter=" + filter;
	submitForm(document.getElementById("frmMain"));
}

function btnSearch_click() {
	hideEmptyMasks();
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "query.QryProCancelAction.do?action=search";
		submitForm(document.getElementById("frmMain"));
	} else {
		showEmptyMasks();
	}
}

function first() {
	document.getElementById("frmMain").action = "query.QryProCancelAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "query.QryProCancelAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "query.QryProCancelAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "query.QryProCancelAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="query.QryProCancelAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
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

function btnCancel_click() {
	var cant = document.getElementById("gridList").selectedItems.length;
	if(cant == 1) {
		document.getElementById("proInstCancelId").value=document.getElementById("gridList").selectedItems[0].getAttribute("proInstCancelId");
		document.getElementById("proInstCancelAction").value=document.getElementById("gridList").selectedItems[0].getAttribute("proInstCancelAction");
		document.getElementById("frmMain").action = "execution.ProStartAction.do?action=startCancel&qryProCancel=true";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}
