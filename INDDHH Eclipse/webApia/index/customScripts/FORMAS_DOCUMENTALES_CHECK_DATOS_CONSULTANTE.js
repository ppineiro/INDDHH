
function fnc_1001_2037(evtSource) { 
	var form = ApiaFunctions.getForm('FRM_CONSULTANTE');
	
	var strCI = form.getField('CNS_CI_CONSULTANTE_STR').getValue();
	var strMail = form.getField('CNS_MAIL_CONSULTANTE_STR').getValue()
	var strTelefono = form.getField('CNS_TELEFONO_CONSULTANTE_STR').getValue();
	
	if(strMail != ""){
		var matchMail = /^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$/.exec(strMail);
		if(matchMail == null){
			alert("El mail ingresado no tiene el formato correcto");
			return false;
		}
	}
	
	if(strCI != ""){
		var matchCI = /^\d{6,7}-\d{1}$/.exec(strCI);
		if(matchCI == null){
			alert("El formato de la CI debe ser #######-#");
			return false;
		}
	}
	
	if(strTelefono != ""){
		var matchTel = /^\d+$/.exec(strTelefono);
		if(matchTel == null){
			alert("Ingrese únicamente números en el teléfono");
			return false;
		}
	}
	return true; // END

return true; // END
} // END
