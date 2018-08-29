function btnConf_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "administration.BPMNAction.do?action=confirmImpXPDL";
		try {
			submitForm(document.getElementById("frmMain"));
		} catch (e) {
			alert(e.message);
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
		document.getElementById("frmMain").action = "administration.BPMNAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}



function cmbLoadEntInfo_change() {
	if (document.getElementById("cmbEnt").value == existEnt || document.getElementById("cmbEnt").value == newEnt) {
		document.getElementById("entInfo").style.display = "";
		if (document.getElementById("cmbEnt").value == existEnt) {
			document.getElementById("entName").style.display = "none";
			document.getElementById("busEnts").style.display = "";
			unsetRequiredField(document.getElementById("entName"));
			setRequiredField(document.getElementById("busEnts"));
		} else {
			document.getElementById("entName").style.display = "";
			document.getElementById("busEnts").style.display = "none";
			setRequiredField(document.getElementById("entName"));
			unsetRequiredField(document.getElementById("busEnts"));
		}
	} else {
		document.getElementById("entName").style.display = "none";
		document.getElementById("busEnts").style.display = "none";
		document.getElementById("entInfo").style.display = "none";
		document.getElementById("entName").p_required="false";
		document.getElementById("busEnts").p_required="false";
	}
}
