function setNumericFields(){
	if (document.getElementById("hiddNumericFields")!=null){
		var allNumFields = document.getElementById("hiddNumericFields").value;
		if (allNumFields != ""){
			while (allNumFields.indexOf(";")>0){
				var numField = allNumFields.substring(0, allNumFields.indexOf(";"));
				setNumericField(document.getElementById(numField));
				allNumFields = allNumFields.substring(allNumFields.indexOf(";")+1, allNumFields.length);
			}
			setNumericField(document.getElementById(allNumFields));
		}
	}
}

function cmbTskSchChange(){
	document.getElementById("frmMain").action = "query.TaskSchedulerMonitorAction.do?action=selTaskSched";
	submitForm(document.getElementById("frmMain"));
}

function btnSearch_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "query.TaskSchedulerMonitorAction.do?action=querySearch";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnReag_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "query.TaskSchedulerMonitorAction.do?action=reschedule";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnConf(){
	document.getElementById("frmMain").action = "query.TaskSchedulerMonitorAction.do?action=confirmResched";
	submitForm(document.getElementById("frmMain"));
}

function btnBack_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "query.TaskSchedulerMonitorAction.do?action=backToFilter";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}

function btnReset_click(){
	document.getElementById("frmMain").action = "query.TaskSchedulerMonitorAction.do?action=selTaskSched";
	submitForm(document.getElementById("frmMain"));

}