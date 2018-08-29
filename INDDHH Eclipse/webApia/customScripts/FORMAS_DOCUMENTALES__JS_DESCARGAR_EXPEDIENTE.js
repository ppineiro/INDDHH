
function fnc_1001_4293(evtSource, par_nombFormulario, par_nombCampo) { 
	var vIndex = evtSource.index; 
	var form = ApiaFunctions.getForm(par_nombFormulario);
	var strNroExp = form.getFieldColumn(par_nombCampo)[vIndex].getValue();
	strNroExp = encodeBase64(strNroExp);
	if(strNroExp != ""){
		verFoliado(strNroExp ,'TSKOtra');
	}

	return true; // END
} // END
