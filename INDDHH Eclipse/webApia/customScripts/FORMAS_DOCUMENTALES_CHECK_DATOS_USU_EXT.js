
function fnc_1001_1630(evtSource) { 
	
	var form = ApiaFunctions.getForm('ALTA_USUARIO_EXTERNO');
	var strDoc = form.getField('USUEXT_DOCUMENTO_TXT_FRM').getValue();	
	var strMail = form.getField('USUEXT_MAIL_TXT_FRM').getValue();
	
	if(strMail != ""){
		var matchMail = /^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$/.exec(strMail);
		if(matchMail == null){
			alert("El mail ingresado no tiene el formato correcto");
			return false;
		}
	}
	
	if(strDoc != ""){
		var matchNro = /^\d+$/.exec(strDoc);
		if(matchNro == null){
			alert("Ingrese sólo dígitos en el documento");
			return false;
		}
	}
	return true; // END

return true; // END
} // END
