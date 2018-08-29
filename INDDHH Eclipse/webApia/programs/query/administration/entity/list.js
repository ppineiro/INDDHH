var submitPerformed = false;

function btnExport_click(field) {
	var rets = openModal("/programs/modals/export.jsp?hiddeHtml=true&hiddeXPDL=true&isQuery=false",500,220);

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
	document.getElementById("frmMain").action="query.EntInstanceAction.do?action=generateCsv&count=" + count;
	//submitForm(document.getElementById("frmMain"));
	document.getElementById("frmMain").submit();
}

function btnTXT_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.EntInstanceAction.do?action=generateTxt&count=" + count;
	//submitForm(document.getElementById("frmMain"));
	document.getElementById("frmMain").submit();
}

function btnExcel_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.EntInstanceAction.do?action=generateExcel&count=" + count;
	//submitForm(document.getElementById("frmMain"));
	document.getElementById("frmMain").submit();
}

function btnPDF_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.EntInstanceAction.do?action=generatePdf&count=" + count;
	//submitForm(document.getElementById("frmMain"));
	document.getElementById("frmMain").submit();
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
	document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=eventOnChange&filter=" + filter;
	submitForm(document.getElementById("frmMain"));
}

function btnNew_click(){
	document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=new&fromQuery=true";
	submitForm(document.getElementById("frmMain"));
}

function btnBack_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnDel_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if (confirm(GNR_DELETE_RECORD)) {
			document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=remove";
			submitForm(document.getElementById("frmMain"));
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}
function btnMod_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=update&fromQuery=true";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnClo_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=clone&fromQuery=true";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
	
}

function btnAlt_click() {
	var cant = chksChecked(gridList);
	if(cant == 1) {
		document.getElementById("frmMain").action = "execution.ProStartAction.do?action=startAlter";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}

}
function btnDep_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=viewDeps";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnSearch_click() {
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=searchEntity";
		submitForm(document.getElementById("frmMain"));
	}
}

function first() {
	document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="query.EntInstanceAction.do?action=page";
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