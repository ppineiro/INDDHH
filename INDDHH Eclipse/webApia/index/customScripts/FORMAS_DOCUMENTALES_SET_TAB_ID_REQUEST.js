
function FORMAS_DOCUMENTALES_SET_TAB_ID_REQUEST(evtSource) { 
var form = ApiaFunctions.getForm("FIRMA");
form.getField("TAB_ID_REQUEST").setValue(TAB_ID_REQUEST);

return true; // END
} // END
