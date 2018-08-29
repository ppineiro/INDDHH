
function INDDHH_JS_VALIDAR_FECHA_EN_GRILLA(evtSource, par_nomFrm, par_nomAtt, par_nomGrilla) { 
limpiarErroresFnc();	
	var myForm = ApiaFunctions.getForm(par_nomFrm);
	if (par_nomGrilla != null && par_nomGrilla != "") {
		var field = myForm.getField(par_nomGrilla).getField(par_nomAtt, evtSource.index);
    } else {
        var field = myForm.getField(par_nomAtt);
    }
	
	if (field.getValue()!=""){
                
        var inputValues = field.getValue();
        if (!validateDate(inputValues)){
  	    	field.setValue("");
        	showMessage( "La fecha no es válida.");
        	return false;
        }        
	}












return true; // END
} // END
