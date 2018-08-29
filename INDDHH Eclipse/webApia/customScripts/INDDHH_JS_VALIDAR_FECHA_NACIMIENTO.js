
function INDDHH_JS_VALIDAR_FECHA_NACIMIENTO(evtSource, par_nomFrm, par_nomAtt) { 
var myForm = ApiaFunctions.getForm(par_nomFrm);
var field = myForm.getField(par_nomAtt);

if (field.getValue()!=""){
  
	var inputValues = field.getValue();
    var fechaHoy = getFechaHoy();

    if (validarFechaMayorQue(fechaHoy, inputValues)){
    	field.setValue("");
      	showMsgError(par_nomFrm, par_nomAtt, "La fecha de nacimiento ingresada no es válida, debe ser menor a la fecha actual");
        return false;
    }else{
		limpiarErroresFnc();
	}
}
return true; // END
} // END
