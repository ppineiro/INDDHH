
function fnc_1001_1629(evtSource) { 
		
	//var nroExp = ('RESOLUCION_EXP_NRO_EXPEDIENTE_STR').value;
	var myForm = ApiaFunctions.getForm("EXPEDIENTE");
var nroExp = myForm.getField('RESOLUCION_EXP_NRO_EXPEDIENTE_STR').getValue();
	verFoliado(nroExp);
		
return true; // END
} // END
