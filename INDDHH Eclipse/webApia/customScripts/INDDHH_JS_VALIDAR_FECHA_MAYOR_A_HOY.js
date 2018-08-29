
function INDDHH_JS_VALIDAR_FECHA_MAYOR_A_HOY(evtSource, par_nomFrm, par_nomAtt) { 
	var myForm = ApiaFunctions.getForm(par_nomFrm);
	var field = myForm.getField(par_nomAtt);
	if (field.getValue()!=""){
                
        var inputValues = field.getValue();
        var fechaHoy = getFechaHoy();
        if (validarFechaMayorQue(inputValues, fechaHoy)){
        	showMsgError(par_nomFrm, par_nomAtt, "La fecha solicitada no puede ser posterior a la fecha actual.");
        	return false;
        }                  
	}


return true; // END
} // END
