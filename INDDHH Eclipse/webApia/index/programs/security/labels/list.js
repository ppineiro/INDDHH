function btnNew_click(){
	document.getElementById("frmMain").action = "security.LabelsAction.do?action=new";
	submitForm(document.getElementById("frmMain"));
}
function btnDel_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if (confirm(GNR_DELETE_RECORD)) {
			document.getElementById("frmMain").action = "security.LabelsAction.do?action=remove";
			submitForm(document.getElementById("frmMain"));
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}
function btnMod_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "security.LabelsAction.do?action=update";
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
		document.getElementById("frmMain").action = "security.LabelsAction.do?action=viewDeps";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").action = "security.LabelsAction.do?action=search";
	submitForm(document.getElementById("frmMain"));
}

function orderBy(order){
	document.getElementById("frmMain").action = "security.LabelsAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "security.LabelsAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "security.LabelsAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "security.LabelsAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "security.LabelsAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="security.LabelsAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}