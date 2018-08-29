function btnGen_click(){
	if (verifyRequiredObjects()) {
//		frmMain.target = "idResult";
		document.getElementById("frmMain").action = "administration.DocumentationAction.do?action=generate";
//		frmMain.submit();
		submitForm(document.getElementById("frmMain"));
	}
}

function btnExit_click(){
	splash();
}

//---------------------------------------------------
//------------   FUNCIONES PARA TEMPLATES   ---------
//---------------------------------------------------

function changeTemplate() {
	if (document.getElementById("txtTemplate").value=="<CUSTOM>") {
		document.getElementById("customTemplate").disabled=false;
		document.getElementById("customTemplate").style.visibility = "";
		document.getElementById("customTemplate").title=TOOL_TIP;
	} else if (!document.getElementById("customTemplate").disabled) {
		document.getElementById("customTemplate").disabled=true;
		document.getElementById("customTemplate").style.visibility = "hidden";
	}
}
