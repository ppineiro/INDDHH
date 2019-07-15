
function DEFAULT_JS_MOSTRAR_CAMPO_FORMULARIO(evtSource, par_nomForm, par_nomCampo, par_nomCheck) { 
var myForm = ApiaFunctions.getEntityForm(par_nomForm);	
var field = myForm.getField(par_nomCampo);
var fldCheckCambio = myForm.getField(par_nomCheck);

field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
fldCheckCambio.setValue(true);








return true; // END
} // END
