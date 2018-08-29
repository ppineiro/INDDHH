
function INDDHH_JS_VALIDAR_FECHA_SOLICITUD_GRABACION(evtSource, par_nomFrm, par_nomAtt) { 
	var myForm = ApiaFunctions.getForm(par_nomFrm);
	var field = myForm.getField(par_nomAtt);
	
	if (field.getValue()!=""){
                
        var inputValues = field.getValue();
        var fechaHoy = getFechaHoy();
        if (!validarFechaMayorIgualQue(inputValues, fechaHoy)){
          	field.setValue("");
        	showMsgError(par_nomFrm, par_nomAtt, "La fecha solicitada no puede ser posterior a la fecha actual.");
        	return false;
        }  
        var fechaDesde = sumarFecha(-90, fechaHoy);
        if (!validarFechaMayorIgualQue(fechaDesde, inputValues)){
          	field.setValue("");
        	showMsgError(par_nomFrm, par_nomAtt, "La fecha solicitada no puede ser anterior al " + fechaDesde);
        	return false;
        }  
        
	}


return true; // END
} // END
