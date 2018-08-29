
function INDDHH_JS_VALIDAR_EMAIL(evtSource, par_nameFrm, par_nameAtt) { 
	var myForm = ApiaFunctions.getEntityForm(par_nameFrm);	
	var myField = myForm.getField(par_nameAtt);
	var email = myField.getValue();
	email = email.trim();
	
	myField.setValue(email);
		
	expr = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    if ( email != "" && !expr.test(email) ){
    	showMsgError(par_nameFrm, par_nameAtt, "Error: La dirección de correo ingresada es incorrecta.");
    	myField.setValue("");
        return false;
    }else{
    	hideMsgError(par_nameFrm, par_nameAtt);
    }


return true; // END
} // END
