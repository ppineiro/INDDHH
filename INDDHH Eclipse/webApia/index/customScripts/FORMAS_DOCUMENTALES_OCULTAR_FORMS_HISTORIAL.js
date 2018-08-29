
function FORMAS_DOCUMENTALES_OCULTAR_FORMS_HISTORIAL(evtSource) { 
	
	var form1 = ApiaFunctions.getForm("ACTUACIONES_HISTORIAL");
	var form2 = ApiaFunctions.getForm("ACTUACIONES_ARCHIVOS");
	
	if(form1 != null && form2 != null){
		form1.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
		form2.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);	
	}



return true; // END
} // END
