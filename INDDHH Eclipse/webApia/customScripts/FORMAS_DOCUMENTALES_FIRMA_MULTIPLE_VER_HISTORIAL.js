
function FORMAS_DOCUMENTALES_FIRMA_MULTIPLE_VER_HISTORIAL(evtSource) { 
var vIndex = evtSource.index;
var myForm = ApiaFunctions.getForm("FIRMA_MULTIPLE_SELECCION_FIRMAS");	
var nroExp = myForm.getFieldColumn('FIRMA_MULTIPLE_NRO_EXPEDIENTE_STR')[vIndex].getValue();

mostrarHistorial(nroExp);
return true; // END
} // END
