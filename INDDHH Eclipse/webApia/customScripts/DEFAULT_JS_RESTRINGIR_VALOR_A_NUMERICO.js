
function DEFAULT_JS_RESTRINGIR_VALOR_A_NUMERICO(evtSource, par_form, par_attrib, par_cantNumeros) { 
	
var numeros		= "0123456789";
var tope		= 0;
var ob1			= ApiaFunctions.getForm(par_form).getField(par_attrib);
var strValue	= ob1.getValue();

if (strValue != null && strValue != "" ) { 
	limpiarErroresFnc();
	if (par_cantNumeros != null) {
		tope = par_cantNumeros;
		if (!sonNumeros(strValue)) {
			limpiarErroresFnc();
			ob1.clearValue();
			//showMessage("El campo debe ser num&eacute;rio.");
			showMsgError(par_form, par_attrib, "El campo debe ser num&eacute;rico y no puede contener espacios, puntos o guiones.");
			return;
		} else {
			if (strValue.length > tope) {
				limpiarErroresFnc();
				ob1.clearValue();
				//showMessage("El campo solo puede contener n&uacute;meros de hasta " + tope + " cifras.");
				showMsgError(par_form, par_attrib, "El campo solo puede contener n&uacute;meros de hasta " + tope + " digitos.");
				return;
			} else limpiarErroresFnc();
		}
	} else tope = strValue.length;

	if (!sonNumeros(strValue)) {
		limpiarErroresFnc();
		ob1.clearValue();
		//showMessage("El campo debe ser num&eacute;rio.");
		showMsgError(par_form, par_attrib, "El campo debe ser num&eacute;rico y no puede contener espacios, puntos o guiones.");
	} else limpiarErroresFnc();
}

function sonNumeros (strValue) {
	for (var i = 0; i < tope; i++) {
		//Si encuentra algo distinto de un numero, retorna false y sale de la funcion
		if (numeros.indexOf(strValue.charAt(i),0) == -1) return false;
	}
	return true;
}
	return true; // END


return true; // END
} // END
