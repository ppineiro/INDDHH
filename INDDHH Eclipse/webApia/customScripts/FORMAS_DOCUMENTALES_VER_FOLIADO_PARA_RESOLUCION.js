
function fnc_1001_1949(evtSource) { 
	var myForm = ApiaFunctions.getForm("EXPEDIENTE");
var nroExp = myForm.getField('PR_IDENTIFICADOR').getValue();
	verFoliado(nroExp);
		

return true; // END
} // END
