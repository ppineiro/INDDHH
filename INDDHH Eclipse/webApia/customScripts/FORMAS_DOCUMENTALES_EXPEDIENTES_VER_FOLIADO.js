
function fnc_1001_1287(evtSource) { 
	var myForm = ApiaFunctions.getForm("ACTUACIONES_HISTORIAL")
	var nroExp = myForm.getField("EXP_NRO_EXPEDIENTE_STR").getValue();
	if(!nroExp){
		nroExp = myForm.getField("EXP_NRO_EXPEDIENTE_STR").getValue();
	}
	verFoliado(nroExp);
		
return true; // END
} // END
