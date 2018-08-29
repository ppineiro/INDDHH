
function fnc_1001_4309(evtSource, par_nombFormulario, par_nombCampo) { 
var vIndex = evtSource.index; 
var myForm = ApiaFunctions.getForm(par_nombFormulario);
var nroPM =  myForm.getFieldColumn(par_nombCampo)[vIndex].getValue();
imprimirRemitoEmitirRemitoPaseMasivo(nroPM );
return true; // END
} // END
