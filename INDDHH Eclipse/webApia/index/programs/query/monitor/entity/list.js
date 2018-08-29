function btnSearch_click() {
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").target = ""
		document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=filter";
		submitForm(document.getElementById("frmMain"));
	}
}

function first() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="query.MonitorEntityAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click(){
	splash();
}

function btnBack_click() {
	document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}


function orderBy(order){
	document.getElementById("frmMain").target = ""
	document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function btnView_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "query.MonitorEntityAction.do?action=history";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}
