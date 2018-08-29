
function DEFAULT_JS_SUMA_DOS_NUM_MAYOR_QUE_VALOR(evtSource, par_form, par_attribUno, par_attribDos, par_minimo) { 
var numUno = ApiaFunctions.getForm(par_form).getField(par_attribUno).getValue();
var numDos = ApiaFunctions.getForm(par_form).getField(par_attribDos).getValue();
var minValue = par_minimo;
var sumaValue = parseInt(numUno) + parseInt(numDos);

if (sumaValue < minValue) {
	ApiaFunctions.getForm(par_form).getField(par_attribUno).clearValue();
    ApiaFunctions.getForm(par_form).getField(par_attribDos).clearValue();
	alert("Deben ser al menos "+minValue+" integrantes.");
}








return true; // END
} // END
