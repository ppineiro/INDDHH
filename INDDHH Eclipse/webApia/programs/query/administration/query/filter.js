function btnSearch_click() {
	document.getElementById("frmFilter").target = "";
	if (verifyRequiredObjects()) {
		enableAll();
		document.getElementById("frmFilter").action = "query.QueryAction.do?action=processQuery";
		
		submitForm(document.getElementById("frmFilter"));
	} else {
		showEmptyMasks();
	}
}

function btnReset_click() {
	var formEls = document.getElementById("frmFilter").getElementsByTagName("input");

	for (var indexCampo=0; indexCampo < formEls.length; indexCampo++){
		if(formEls[indexCampo].type=="hidden"){
			continue;
		}
		formEls[indexCampo].value="";
	}
	formEls = document.getElementById("frmFilter").getElementsByTagName("SELECT");

	for (var indexCampo=0; indexCampo < formEls.length; indexCampo++){
		formEls[indexCampo].value="";
	}
}

function enableAll(){
	var elements = document.getElementsByTagName("INPUT");
	if (elements != null) {
		for (i = 0; i < elements.length; i++) {
			elements[i].disabled=false;
		}
	}
	elements = document.getElementsByTagName("SELECT");
	if (elements != null) {
		for (i = 0; i < elements.length; i++) {
			elements[i].disabled=false;
		}
	}
}

function callEventOnChange(filter) {
	document.getElementById("frmFilter").action = "query.QueryAction.do?action=eventOnChange&filter=" + filter;
	submitForm(document.getElementById("frmFilter"));
}

//function btnExit_click(){
//	splash();
//}

//function btnAnt_click() {
//	document.getElementById("frmMain").target = "";
//	document.getElementById("frmMain").action="query.QueryAction.do?action=returnAction";
//	document.getElementById("frmMain").submit();
//}

//function btnPrint_click() {
//	window.print();
//}

