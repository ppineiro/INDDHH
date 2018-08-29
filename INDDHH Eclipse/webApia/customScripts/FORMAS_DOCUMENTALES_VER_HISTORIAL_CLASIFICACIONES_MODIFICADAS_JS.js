
function fnc_1001_4209(evtSource) { 
	var myForm = ApiaFunctions.getForm("ACTUACIONES_HISTORIAL");
	var pathArchivo = myForm.getField('ARCHIVO_HISTORIAL_MOD_CLA_STR').getValue();
	
	if (pathArchivo != null && pathArchivo != ''){
		
		verArchivoModCla(pathArchivo);
		myForm.getField('ARCHIVO_HISTORIAL_MOD_CLA_STR').setValue('');
		
	}

return true; // END
} // END
