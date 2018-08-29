
function INDDHH_JS_VALIDAR_EMAIL_GRILLA(evtSource, par_nameFrm, par_nameGrid, par_columna, par_nameAtt) { 
	var myForm = ApiaFunctions.getEntityForm(par_nameFrm);	
	var myGrid = myForm.getField(par_nameGrid);
	var myField = myGrid.getRow(evtSource.index)[par_columna-1];

	var email = myField.getValue();
	email = email.trim();
	
	myField.setValue(email);
		
	expr = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    if ( !expr.test(email) ){
    	myField.setValue('');
    	//showMsgError(par_nameFrm, par_nameAtt, "Error: La dirección de correo ingresada es incorrecta.");        
    	showMessage("Error: La dirección de correo ingresada es incorrecta.");
        return false;
    }else{
    	hideMsgError(par_nameFrm, par_nameAtt);
    }












return true; // END
} // END
