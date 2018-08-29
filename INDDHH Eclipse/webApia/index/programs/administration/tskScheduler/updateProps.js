function chkAllowCitClk(){
	if (document.getElementById("chkAllowCit").checked){
		document.getElementById("txtDefOvrAsgn").disabled = false;
		document.getElementById("txtDefSubHor").disabled = false;
		document.getElementById("chkNotify").disabled = false;
		if (document.getElementById("txtDefSubHor").value > 0){
			document.getElementById("txtOthDefFracc").disabled = true;
		}else{
			document.getElementById("txtOthDefFracc").disabled = false;
		}
	}else{
		if (document.getElementById("txtDefOvrAsgn").value == ""){
			document.getElementById("txtDefOvrAsgn").value = "0";
		}
		document.getElementById("txtDefOvrAsgn").disabled = true;
		document.getElementById("txtDefSubHor").value = 30;
		document.getElementById("txtDefSubHor").disabled = true;
		document.getElementById("chkNotify").disabled = true;	
		document.getElementById("txtOthDefFracc").disabled = true;
		document.getElementById("txtOthDefFracc").value = "";
	}
}

function chkNotifyClk(){
	if (document.getElementById("chkNotify").checked){
		document.getElementById("txtEmails").disabled = false;
		setRequiredField(document.getElementById("txtEmails"));
	}else{
		document.getElementById("txtEmails").disabled = true;	
		document.getElementById("txtEmails").value = "";
		unsetRequiredField(document.getElementById("txtEmails"));
	}

}

function changeDefFraccCmb(){
	var fracc = document.getElementById("txtDefSubHor").value;
	if (fracc == -1){
		fracc = 30;
		selDefFraccTime(fracc);
	}
	if (document.getElementById("txtDefSubHor").value == 0){ //Otro
		document.getElementById("txtOthDefFracc").disabled = false;
	}else{
		document.getElementById("txtOthDefFracc").disabled = true;
		document.getElementById("txtOthDefFracc").value = "";
	}
}

//Seleccionamos la subdivision horaria pasada por parametro
function selDefFraccTime(fracc){
	var cmbFracc = document.getElementById("txtDefSubHor");
	var found = false;
	for (i = 0; i < cmbFracc.options.length; i++) {
		if (cmbFracc.options[i].value == fracc) {
			cmbFracc.selectedIndex = i;
			found = true;
			document.getElementById("txtOthDefFracc").value = "";
			return;
		}
	}
	
	//Si llego aqui no se encontro --> es otro valor
	cmbFracc.selectedIndex = cmbFracc.options.length-1;
	document.getElementById("txtOthDefFracc").disabled = false;
	document.getElementById("txtOthDefFracc").value = fracc;
}
