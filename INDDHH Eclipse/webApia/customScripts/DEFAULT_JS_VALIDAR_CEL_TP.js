
function DEFAULT_JS_VALIDAR_CEL_TP(evtSource, par_nameFrm, par_nameAtt) { 
	var myForm = ApiaFunctions.getEntityForm(par_nameFrm);	
	var myField = myForm.getField(par_nameAtt);
	var cel = myField.getValue();
	cel = cel.trim();
	
	myField.setValue(cel);
		
	expr = /^[0][9][1-9][0-9]{6}$/;
    if ( cel != "" && !expr.test(cel) ){
    	//showMsgError(par_nameFrm, par_nameAtt, "Error: El celular ingresado es incorrecto.");
    	showMessage("Error: El celular ingresado es incorrecto.");
    	myField.setValue("");
        return false;
    }








return true; // END
} // END
