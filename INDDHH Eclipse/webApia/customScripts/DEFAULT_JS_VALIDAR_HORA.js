
function DEFAULT_JS_VALIDAR_HORA(evtSource, par_nameFrm, par_nameAtt, par_nameInicioTrm) { 
	var myForm = ApiaFunctions.getEntityForm(par_nameFrm);	
	var myField = myForm.getField(par_nameAtt);
	var inicioTrm = myForm.getField(par_nameInicioTrm).getValue();
	var cel = myField.getValue();
	cel = cel.trim();
	
	myField.setValue(cel);
		
	expr = /^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/;
	if(inicioTrm == true) 
    {
      if ( cel != "" && !expr.test(cel) ) 
      {
          showMsgError(par_nameFrm, par_nameAtt, "Error: La hora ingresada es incorrecta.");
          myField.setValue("");
          return false;
        } else
        {
            hideMsgError(par_nameFrm, par_nameAtt);
        }
    }else {
      if ( cel != "" && !expr.test(cel) ) 
      {
        showMessage("Error: La hora ingresada es incorrecta.");
        myField.setValue("");
        return false;
      }
    }












return true; // END
} // END
