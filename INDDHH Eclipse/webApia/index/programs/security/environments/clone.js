function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("txtEnvName").value)){
			document.getElementById("frmMain").action = "security.EnvironmentsAction.do?action=confClone";
			submitForm(document.getElementById("frmMain"));
		}
	}
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
		document.getElementById("frmMain").action = "security.EnvironmentsAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function enableCheckBox(from, checkbox, checkbox2) {
	var fromInput = document.getElementById(from);
	var chkInput = document.getElementById(checkbox);
	if (biCorrectlyInstalled == "true"){
		var chkInput2 = document.getElementById(checkbox2);
	}
	
	if (fromInput != null && chkInput != null) {
		chkInput.disabled = ! fromInput.checked;
	}
	
	if (biCorrectlyInstalled == "true" && fromInput != null && chkInput2 != null) {
		chkInput2.disabled = ! fromInput.checked;
	}
}