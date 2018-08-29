
function fnc_1001_1511(evtSource) { 
	var formEnvio = ApiaFunctions.getForm('NOTA_ENV_DATOS_ENVIO');	
	var anularNota = !document.getElementById('NOTA_ENV_ANULAR_NOTA_NTAENV_ANULADA_NUM').checked;

	if(anularNota)
		formEnvio.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);   
	else
	   formEnvio.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);

return true; // END
} // END
