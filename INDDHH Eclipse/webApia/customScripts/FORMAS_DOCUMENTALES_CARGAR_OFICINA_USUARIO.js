
function fnc_1001_1162(evtSource, par_nombFormulario, par_nombCampo1, par_nombCampo2) { 
	var form = ApiaFunctions.getForm(par_nombFormulario);
	form.getField(par_nombCampo1).setValue(lastModalReturn[5]);
	form.getField(par_nombCampo2).setValue(lastModalReturn[6]);	

return true; // END
} // END
