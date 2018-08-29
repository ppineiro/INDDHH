function btnView_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").target = "";
		document.getElementById("frmMain").action = "query.OffLineAction.do?action=openResult";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnDowload_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").target = "idResult";
		document.getElementById("frmMain").action = "query.OffLineAction.do?action=downloadResult";
		document.getElementById("frmMain").submit();
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

var lastChecked = null;

function enabledButons() {
	var line = document.getElementById("gridList").selectedItems[0];
	var type = line.getAttribute("type");
	var fileToProcess = document.getElementById("fileToProcess");

	fileToProcess.value = line.getAttribute("file");

	document.getElementById("btnView").disabled = type != typeHtml;
	document.getElementById("btnDown").disabled = type == typeHtml;
}