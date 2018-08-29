
function FORMAS_DOCUMENTALES_OCULTAR_FORMS_HISTORIAL(evtSource) { 
	
	var form1 = ApiaFunctions.getForm("TAB_HISTORIAL");
	var form2 = ApiaFunctions.getForm("ACTUACIONES_HISTORIAL");
	var form3 = ApiaFunctions.getForm("ACTUACIONES_ARCHIVOS");
	
	if(form1 == null && form2 != null && form3 != null){
		form2.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
		form3.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);	
	}


return true; // END
} // END
