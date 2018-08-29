
function fnc_1001_1125(evtSource, par_mensaje, par_nombFormulario, par_nombCampo) { 

	if(document.getElementById("btnConf")!=null){
		var form = ApiaFunctions.getForm(par_nombFormulario);
		if (confirm(par_mensaje)) {
			form.getField(par_nombCampo).setValue('S');
		}else{
			form.getField(par_nombCampo).setValue('N');
			return false;
		}

	}
	return true; // END
} // END
