function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("txtName").value)){
			document.getElementById("frmMain").action = "administration.CalendarAction.do?action=confClone";
			submitForm(document.getElementById("frmMain"));
		}
	}
}
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "administration.CalendarAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}