
function DEFAULT_JS_VALIDAR_TEL_FIJO_TP(evtSource, par_nameFrm, par_nameAtt) { 
	var myForm = ApiaFunctions.getEntityForm(par_nameFrm);	
	var myField = myForm.getField(par_nameAtt);
	var tel = myField.getValue();
	tel = tel.trim();
	
	myField.setValue(tel);
		
	expr = /^[0-9]{8}$/;
    if ( tel != "" && !expr.test(tel) ){
    	//showMsgError(par_nameFrm, par_nameAtt, "Error: El teléfono ingresado es incorrecto.");
    	showMessage("Error: El teléfono ingresado es incorrecto.");
    	myField.setValue("");
        return false;
    }

return true; // END
} // END
