function btnConf_click() {
	hideEmptyMasks();
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "query.TaskListAction.do?action=filterSet&workMode=" + WORK_MODE;
		submitFormModal(document.getElementById("frmMain"));
//	} else {
		showEmptyMasks();
	}
}

function callEventOnChange(filter) {
	document.getElementById("frmMain").action = "query.TaskListAction.do?action=eventOnChange&filter=" + filter + "&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
