
function DEFAULT_JS_OCULTAR_FIELD(evtSource, par_nomForm, par_nomField) { 
var form = ApiaFunctions.getForm(par_nomForm);
var field = form.getField(par_nomField);

field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);

return true; // END
} // END
