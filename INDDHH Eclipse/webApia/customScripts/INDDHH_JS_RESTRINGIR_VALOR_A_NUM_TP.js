
function INDDHH_JS_RESTRINGIR_VALOR_A_NUM_TP(evtSource, par_form, par_attrib, par_cantNumeros) { 
var strValue = ApiaFunctions.getForm(par_form).getField(par_attrib).getValue();
var numeros = "0123456789";
var tope = 0;
var ob1 = ApiaFunctions.getForm(par_form).getField(par_attrib);
if (par_cantNumeros != null) {
	tope = par_cantNumeros;
  	if (!sonNumeros(strValue)) {  		
		ApiaFunctions.getForm(par_form).getField(par_attrib).clearValue();		
		showMessage("El campo debe ser num&eacute;rio.");		
		//showMsgError(par_form, par_attrib, "El campo debe ser num&eacute;rico.");
     	return false;
	} else{ 
		if (strValue.length > tope) {
			ApiaFunctions.getForm(par_form).getField(par_attrib).clearValue();
			showMessage("El campo solo puede contener n&uacute;meros de hasta " + tope + " cifras.");
			//showMsgError(par_form, par_attrib, "El campo solo puede contener n&uacute;meros de hasta " + tope + " cifras.");
			return false;
		}
	}
} else {
	tope = strValue.length;
}

if (!sonNumeros(strValue)) {		
	ApiaFunctions.getForm(par_form).getField(par_attrib).clearValue();
	showMessage("El campo debe ser num&eacute;rio.");
	//showMsgError(par_form, par_attrib, "El campo debe ser num&eacute;rico.");
	return false;
}

function sonNumeros (strValue) {
	for (var i = 0; i < tope; i++) {
		//Si encuentra algo distinto de un numero, retorna false y sale de la funcion
		if (numeros.indexOf(strValue.charAt(i),0) == -1) {
			return false;
		}
	}
	return true;
}

return true; // END
} // END
