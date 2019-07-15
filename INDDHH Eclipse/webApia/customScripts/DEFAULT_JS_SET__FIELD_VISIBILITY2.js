
function DEFAULT_JS_SET__FIELD_VISIBILITY2(evtSource, par_form, par_attrib) { 
var form = ApiaFunctions.getForm(par_form);
var attrib = form.getField(par_attrib);

attrib.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);



return true; // END
} // END
