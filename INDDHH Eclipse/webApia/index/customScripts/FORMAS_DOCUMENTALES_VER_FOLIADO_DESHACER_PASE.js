
function fnc_1001_3775(evtSource) { 
	var myForm = ApiaFunctions.getForm("DESHACER_PASE_EXPEDIENTE")
	var nroExp = myForm.getField("EXP_NRO_EXP_DESHACER_PASE_STR").getValue();
	verFoliado(nroExp[0]);


return true; // END
} // END
