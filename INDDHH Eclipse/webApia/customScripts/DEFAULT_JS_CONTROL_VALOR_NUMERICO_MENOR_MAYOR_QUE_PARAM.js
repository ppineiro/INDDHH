
function DEFAULT_JS_CONTROL_VALOR_NUMERICO_MENOR_MAYOR_QUE_PARAM(evtSource, par_form, par_attrib, par_valor, par_mayorMenor) { 
var strValue = ApiaFunctions.getForm(par_form).getField(par_attrib).getValue();
var valor = par_valor;
var mayorMenor = par_mayorMenor;

if (mayorMenor) {
	if (strValue > valor) {
		ApiaFunctions.getForm(par_form).getField(par_attrib).clearValue();
		alert("El valor ingresado debe ser menor a " + valor + ".");
	}
} else {
	if (strValue < valor) {
		ApiaFunctions.getForm(par_form).getField(par_attrib).clearValue();
		alert("El valor ingresado debe ser mayor a " + valor + ".");
	}
}



return true; // END
} // END
