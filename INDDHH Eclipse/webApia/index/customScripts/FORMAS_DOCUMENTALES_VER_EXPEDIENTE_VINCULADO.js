
function fnc_1001_1360(evtSource, par_nombFormulario, par_nombCampo) { 
	var vIndex = evtSource.index;
	var myForm = ApiaFunctions.getForm(par_nombFormulario);
	strNroExp = myForm.getFieldColumn(par_nombCampo)[vIndex].getValue();
	if(strNroExp != ""){
		verFoliado(strNroExp.split("width")[0]);
	}
	return true; // END


return true; // END
} // END
