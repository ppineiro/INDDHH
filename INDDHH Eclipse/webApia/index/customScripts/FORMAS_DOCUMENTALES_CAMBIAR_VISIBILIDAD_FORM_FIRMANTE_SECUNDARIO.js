
function fnc_1001_1429(evtSource) { 
	var form = ApiaFunctions.getForm('NOTA_SELECCION_FIRMANTE_SECUNDARIO');	
	var tieneSegundoFirmante = document.getElementById('NOTA_SELECCION_FIRMANTE_NTA_TIENE_SEGUNDO_FIRMANTE_NUM');
	if(tieneSegundoFirmante.value == '1')
	{
	   form.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
	}
	else 
	{
	   form.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
	}

return true; // END
} // END
