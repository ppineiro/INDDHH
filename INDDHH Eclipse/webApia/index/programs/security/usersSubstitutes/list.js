function btnView_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=view";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}

}


function btnDel_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (confirm(GNR_DELETE_RECORD)) {
			document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=removeSup";
			submitForm(document.getElementById("frmMain"));
		}
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}

}


function btnHistory_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=history";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnNew_click(){
	document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=new";
	submitForm(document.getElementById("frmMain"));

}

function btnSearch_click() {
	document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=search";
	submitForm(document.getElementById("frmMain"));
}

function orderBy(order){
	document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="security.UserSubstituteAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}