alert(1);

function btnFree_click(sessionId) {
	alert("solicitada liberación de tarea para session " + sessionId);
}

function btnDelegate_click(sessionId) {
	alert("solicitada delegación de tarea para session " + sessionId);
}

function btnSave_click(sessionId) {
	alert("solicitada salvación de tarea para session " + sessionId);
}

function btnLast_click(sessionId) {
	submitForm("lastStep",sessionId);
}

function btnNext_click(sessionId) {
	submitForm("nextStep",sessionId);
}

function btnConf_click(sessionId) {
	if (validateRequired(sessionId)) {
		submitForm("confirm",sessionId);
	}
}

function validateRequired(form) {
	return true;
}

function submitForm(action,sessionId) {
	var form = document.getElementById("frmApia" + sessionId);
	document.getElementById("action" + sessionId).value = action;
	form.submit();
}
