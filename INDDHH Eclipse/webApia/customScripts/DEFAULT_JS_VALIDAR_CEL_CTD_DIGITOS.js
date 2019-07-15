
function DEFAULT_JS_VALIDAR_CEL_CTD_DIGITOS(evtSource, par_nameFrm, par_nameAtt, par_nameInicioTrm) { 
	var myForm = ApiaFunctions.getEntityForm(par_nameFrm);	
	var myField = myForm.getField(par_nameAtt);
	var inicioTrm = myForm.getField(par_nameInicioTrm).getValue();
	var cel = myField.getValue();
	cel = cel.trim();
	
	myField.setValue(cel);
		
	expr = /^[0-9]{9}$/;
	if(inicioTrm == true) 
    {
      if ( cel != "" && !expr.test(cel) ) 
      {
          showMsgError(par_nameFrm, par_nameAtt, "Error: El celular ingresado es incorrecto.");
          myField.setValue("");
          return false;
        } else
        {
            hideMsgError(par_nameFrm, par_nameAtt);
        }
    }else {
      if ( cel != "" && !expr.test(cel) ) 
      {
        showMessage("Error: El celular ingresado es incorrecto.");
        myField.setValue("");
        return false;
      }
    }












return true; // END
} // END
