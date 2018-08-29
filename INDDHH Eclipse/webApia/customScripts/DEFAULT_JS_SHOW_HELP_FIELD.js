
function DEFAULT_JS_SHOW_HELP_FIELD(evtSource, par_form, par_attrib) { 
var form = ApiaFunctions.getForm(par_form);
var field = form.getField(par_attrib);
			     
showDivAyuda(1, par_attrib, par_form);
return true; // END
} // END
