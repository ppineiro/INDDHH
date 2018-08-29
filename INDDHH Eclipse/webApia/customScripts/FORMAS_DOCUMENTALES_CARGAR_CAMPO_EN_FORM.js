
function fnc_1001_1086(evtSource, par_nombFormulario, par_nombCampo, par_valor) { 

	try{
		var form = ApiaFunctions.getForm(par_nombFormulario);
		form.getField(par_nombCampo).setValue(par_valor);		
	}catch(e){}
	return true; // END
return true; // END
} // END
