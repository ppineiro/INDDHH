function CIUDADANO_JS_VALIDAR_DISTINTIVO_SOL_BANDA_CIUD(evtSource) {
	var strValue = ApiaFunctions.getForm(
			"URSEC_FRM_PERMISO_ESTACION_TIPO_TRAMITE").getField(
			"URSEC_PERMISO_ESTACION_DISTINTIVO_STR").getValue();
	var letras = "abcdefghijklmn�opqrstuvwxyz";
	var numeros = "0123456789";

	function sonLetras(strValue) {
		strValue = strValue.toLowerCase();

		for (var i = 0; i < 3; i++) {
			// Si encuentra algo distinto de una letra, retorna false y sale de
			// la funci�n
			if (letras.indexOf(strValue.charAt(i), 0) == -1) {
				return false;
			}
		}
		return true;
	}

	function sonNumeros(strValue) {
		for (var i = 3; i < 8; i++) {
			// Si encuentra algo distinto de un numero, retorna false y sale de
			// la funci�n
			if (numeros.indexOf(strValue.charAt(i), 0) == -1) {
				return false;
			}
		}
		return true;
	}

	if (!(sonLetras(strValue) && sonNumeros(strValue)) || (strValue.length > 8)
			|| (strValue.length < 4)) {
		ApiaFunctions.getForm("URSEC_FRM_PERMISO_ESTACION_TIPO_TRAMITE")
				.getField("URSEC_PERMISO_ESTACION_DISTINTIVO_STR").clearValue();
		alert("El Distintivo ingresado no cumple con el formato CVCNNNNN (puede contener hasta 5 (cinco) numeros.");
	}

	return true; // END
} // END
