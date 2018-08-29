function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("txtNomTar").value) && isValidName(document.getElementById("txtNomRol").value)){
			document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=confMerToEntities";
			try {
				submitForm(document.getElementById("frmMain"));
			} catch (e) {
				alert(e.message);
			}
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
		document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}



function cmbDbConId_change() {
	document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=changeDb";
	submitForm(document.getElementById("frmMain"));
}


function cmbLoadFrom_change() {
	if (document.getElementById("loadFrom").value == LOAD_FROM_FILE) {
		document.getElementById("loadFromFile").style.display = "block";
		document.getElementById("loadFromDb").style.display = "none";
		document.getElementById("cmbDbConId").p_required="false";
		document.getElementById("txtUpload").p_required="true";
	} else {
		document.getElementById("loadFromFile").style.display = "none";
		document.getElementById("loadFromDb").style.display = "block";
		document.getElementById("cmbDbConId").p_required="true";
		document.getElementById("txtUpload").p_required="false";
	}
}

