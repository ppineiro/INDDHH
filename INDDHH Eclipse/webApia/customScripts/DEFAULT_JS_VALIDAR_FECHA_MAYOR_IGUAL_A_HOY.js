
function DEFAULT_JS_VALIDAR_FECHA_MAYOR_IGUAL_A_HOY(evtSource, par_nomFrm, par_nomAtt) { 
	var myForm = ApiaFunctions.getForm(par_nomFrm);
	var field = myForm.getField(par_nomAtt);
	if (field.getValue()!=""){
                
        var inputValues = field.getValue();
        var fechaHoy = getFechaHoy();
        if (validarFechaMayorIgualQue(inputValues, fechaHoy)){
          	field.setValue("");
        	showMsgError(par_nomFrm, par_nomAtt, "La fecha solicitada debe ser anterior a la fecha actual.");
        	return false;
        } else
        {
            hideMsgError(par_nomFrm, par_nomAtt);
        }                 
	}






return true; // END
} // END
