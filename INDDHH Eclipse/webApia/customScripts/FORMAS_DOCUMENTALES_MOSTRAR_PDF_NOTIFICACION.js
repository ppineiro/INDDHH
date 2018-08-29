
function fnc_1001_1191(evtSource, par_nombFormulario, par_nombCampo) { 
	var myForm = ApiaFunctions("DEFINIR_NOTIFICACION");
	if (myForm.getField("FLAG_HISTORIA") != null){		
		if (myForm.getField("FLAG_HISTORIA").getValue() != ""){
			
			var nroExp = myForm.getField("NOT_NRO_DOC_ORIGINAL_STR").getValue();			
			var nameArchivo = myForm.getField("FLAG_HISTORIA").getValue();
			myForm.getField("FLAG_HISTORIA").getValue("");		
			verArchivoNotificacion(nroExp, nameArchivo);	
			
		}	
	}
	var form = ApiaFunctions("VISTA");
	if (form.getField("NOT2") != null){		
		if (form.getField("NOT2").getValue() != ""){
			
			var nroExp = form.getField("NOT_NRO_NOTIFICACION_STR").getValue();			
			var nameArchivo = form.getField("NOT2").getValue();					
			verArchivoNotificacion(nroExp, nameArchivo);	
		}
	}


return true; // END
} // END
