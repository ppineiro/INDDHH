
function INDDHH_JS_CONFIRM_TIPO_OPERADOR_NO_INCLUIDO(evtSource) {
	
	var myForm = ApiaFunctions.getEntityForm("GENERIC_FRM_OPERADORES");	
	if ("|" + myForm.getField("GENERIC_OPERADOR_NO_INCLUIDO_STR").getValue() + "|" == "|true|"){
		var m = "¿Confirma que no está incluido directamente en ninguna de las actividades?";
		if (confirm(m) == true) {		
	    } else {    	
	    	myForm.getField("GENERIC_OPERADOR_NO_INCLUIDO_STR").setValue("false");	    	
	        return false;
	    }
	}
	
return true; // END
} // END
