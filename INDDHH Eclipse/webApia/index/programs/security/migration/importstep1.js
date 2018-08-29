function btnSig_click(){
	if (verifyRequiredObjects()) {
		if((document.getElementById('txtTargetName').getAttribute("p_required")!="true") || (document.getElementById('txtTargetName').getAttribute("p_required")=="true" && isValidName(document.getElementById('txtTargetName').value) )){
			var fileObj = document.getElementById('impFile');
			if (fileObj != null && fileObj.value != null && fileObj.value != '') {
				document.getElementById("frmMain").action = "security.MigrationAction.do?action=impstep2";
				submitForm(document.getElementById("frmMain"));		
			} else {
				alert('Debe ingresar el nombre de archivo');
				fileObj.focus();
			}
		}else{
		
		}
	}
}

function btnVol_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "security.MigrationAction.do?action=init";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnSal_click(){
	splash();
}


