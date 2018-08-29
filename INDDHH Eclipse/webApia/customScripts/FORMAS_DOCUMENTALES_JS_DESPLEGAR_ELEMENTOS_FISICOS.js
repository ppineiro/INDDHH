
function FORMAS_DOCUMENTALES_JS_DESPLEGAR_ELEMENTOS_FISICOS(evtSource, par_nombFormulario, par_nombCampo) { 
var vIndex = evtSource.index; 
var myForm = ApiaFunctions.getForm(par_nombFormulario);
var strNroExp = myForm.getFieldColumn(par_nombCampo)[vIndex].getValue();
	if(strNroExp != ""){
        mostrarEleFisicos(strNroExp);
    }

return true; // END
} // END
