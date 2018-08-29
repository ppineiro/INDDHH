function btnSearch_click() {
	if(document.getElementById("listFilterArea") && document.getElementById("listFilterArea").style.display!="none"){
		toggleFilterSection('<%= Parameters.FORM_QRY_MODAL_HEIGHT - 216 - Parameters.FILTER_LIST_SIZE %>','<%= Parameters.FORM_QRY_MODAL_HEIGHT - 210 %>');
	}
	document.getElementById("frmMain").action = "execution.ProStartAction.do?action=search";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "execution.ProStartAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "execution.ProStartAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "execution.ProStartAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "execution.ProStartAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="execution.ProStartAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}
function btnCancel_click() {

var cant = document.getElementById("gridList").selectedItems.length;
	if(cant == 1) {
		document.getElementById("proInstCancelId").value=document.getElementById("gridList").selectedItems[0].getAttribute("proInstCancelId");
		document.getElementById("proInstCancelAction").value=document.getElementById("gridList").selectedItems[0].getAttribute("proInstCancelAction");
		document.getElementById("frmMain").action = "execution.ProStartAction.do?action=startCancel";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}

}

function btnExit_click(){
	splash();
}
