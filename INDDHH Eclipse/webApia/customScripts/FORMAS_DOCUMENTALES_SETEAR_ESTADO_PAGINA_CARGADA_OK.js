
function FORMAS_DOCUMENTALES_SETEAR_ESTADO_PAGINA_CARGADA_OK(evtSource) { 
	var myForm = ApiaFunctions.getForm("ACTUACIONES");
	if (myForm.getField("EXP_PAGINA_CARGADA_STR")!=null){		
		myForm.getField("EXP_PAGINA_CARGADA_STR").setValue("OK");
	}


return true; // END
} // END
