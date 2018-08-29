
function fnc_1001_4303(evtSource, par_nombFormulario, par_nombCampo) { 
var vIndex = evtSource.index; 
var myForm = ApiaFunctions.getForm(par_nombFormulario);
var nroExp = myForm.getFieldColumn(par_nombCampo)[vIndex].getValue();
imprimirRemitoEmitirRemito(nroExp);
return true; // END
} // END
