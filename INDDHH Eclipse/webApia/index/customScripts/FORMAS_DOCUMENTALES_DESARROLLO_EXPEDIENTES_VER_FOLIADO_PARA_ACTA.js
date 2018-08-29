
function fnc_1001_1939(evtSource) { 
var myForm = ApiaFunctions.getForm("AT_CREAR_ACTA");
var nroExp = myForm.getField('AT_NUMERO_ACTA').getValue();
	verFoliado(nroExp);

return true; // END
} // END
