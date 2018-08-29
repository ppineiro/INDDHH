
function fnc_1001_3802(evtSource) {
	var myForm = ApiaFunctions.getForm("ACTUACIONES_HISTORIAL");
	var nroExp = myForm.getField("EXP_NRO_EXPEDIENTE_STR").getValue();
	verHistCaratulas(nroExp);
return true; // END
} // END
