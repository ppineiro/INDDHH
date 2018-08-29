
function fnc_1001_1874(evtSource) { 
var myForm = ApiaFunctions.getForm("PR_ORDEN_DEL_DIA");
var nroExp = myForm.getField("PR_ORDEN_NUMERO_FOLIADO").getValue();
verFoliado(nroExp);

return true; // END
} // END
