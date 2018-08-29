
function FORMAS_DOCUMENTALES_PLANTILLA_EDITAR(evtSource) { 
var myForm = ApiaFunctions.getForm("TC_ACTUACIONES");

var valEdit = myForm.getField("PLANTILLA_TMP_FILE").getValue();

editWebDav(valEdit);
return true; // END
} // END
