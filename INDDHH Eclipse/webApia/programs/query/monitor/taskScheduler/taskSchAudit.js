function cmbTskSchChange(){
	document.getElementById("frmMain").action = "query.TaskSchedulerMonitorAction.do?action=selTaskSchedForAudit";
	submitForm(document.getElementById("frmMain"));
}

function btnSearch_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "query.TaskSchedulerMonitorAction.do?action=auditSearch";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnBack_click(){
	//var msg = confirm(GNR_PER_DAT_ING);
	//if (msg) {
		document.getElementById("frmMain").action = "query.TaskSchedulerMonitorAction.do?action=backToFilter";
		submitForm(document.getElementById("frmMain"));
	//}
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}

function btnReset_click(){
	document.getElementById("frmMain").action = "query.TaskSchedulerMonitorAction.do?action=selTaskSchedForAudit";
	submitForm(document.getElementById("frmMain"));

}