
function FORMAS_DOCUMENTALES_VER_ARCHIVO_INTEGRACION_PARCIAL(evtSource, par_form, par_nroExp, par_nomArch) {

	// encodeBase64 y verArchivo son funciones de la clase CustomJS-EXP_ELEC.js
	
	var vIndex = evtSource.index;
	if (vIndex >= 0) {
		
		var myForm = ApiaFunctions.getForm(par_form);
		var campo = myForm.getFieldColumn(par_nomArch)[vIndex];
		if (campo != null && campo.getValue() != null && campo.getValue() != '') {
			
			var nroExp = myForm.getField(par_nroExp).getValue();
			var nroExpB64 = encodeBase64(nroExp);
			
			var nameArchivo = campo.getValue();
			if (nameArchivo.indexOf('width') > 0) {
				nameArchivo = nameArchivo.split("width")[0];
			}
			var nameArchivoB64 = encodeBase64(nameArchivo);
			
			verArchivo(nroExpB64, nameArchivoB64);

		}
		
	}

return true; // END
} // END
