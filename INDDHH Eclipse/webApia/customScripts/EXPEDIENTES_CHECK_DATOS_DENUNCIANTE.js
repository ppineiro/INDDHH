
function fnc_1001_2036(evtSource) { 
	var frmDen = ApiaFunctions.getForm('FRM_DENUNCIANTE');
	var fieldCI = frmDen.getField('DEN_CI_DENUNCIANTE_STR');
	var fieldMail = frmDen.getField('DEN_MAIL_DENUNCIANTE_STR');
	var strCI = fieldCI.getValue();
	var strMail = fieldMail.getValue();
	
	if(strMail != ""){
		var matchMail = /^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$/.exec(strMail);
		if(matchMail == null){
			alert("El mail ingresado no tiene el formato correcto");
			return false;
		}
	}
	/*
	if(strCI != ""){
		var matchCI = /^\d{6,7}-\d{1}$/.exec(strCI);
		if(matchCI == null){
			alert("El formato de la CI debe ser #######-#");
			return false;
		}
	}
	*/
	return true; // END
} // END
