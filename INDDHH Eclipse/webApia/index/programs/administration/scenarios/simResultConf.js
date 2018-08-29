function btnConf_click(){
	document.getElementById("frmMain").action = "administration.SimScenarioAction.do?action=genResult" + windowId;
	document.getElementById("frmMain").submit();
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}

function btnBack_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "administration.SimScenarioAction.do?action=backToList" + windowId;
		submitForm(document.getElementById("frmMain"));
	}
}

function sectionChecked(checkbox, otherSectionName) {
	var div = document.getElementById(checkbox.name + "Section");
	
	div.style.display = checkbox.checked ? "block" : "none";
}

function btnExecuteForce_click(){
	document.getElementById("frmMain").action = "administration.SimScenarioAction.do?action=forceSimulate";
	submitForm(document.getElementById("frmMain"));	
}
