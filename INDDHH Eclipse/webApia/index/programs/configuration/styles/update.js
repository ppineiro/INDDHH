function btnConf_click(){
	if (verifyRequiredObjects()) {
		var style=document.getElementById("style");
		if(style.value.indexOf("?")<0 &&  style.value.indexOf("!")<0){
			document.getElementById("frmMain").action = "configuration.StylesAction.do?action=confirm";
			submitForm(document.getElementById("frmMain"));
		}else{
			alert(GNR_INVALID_NAME);
		}
	}
}

function btnBack_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "configuration.StylesAction.do?action=init";
		document.getElementById("frmMain").target = "_self";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}