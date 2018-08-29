
function INDDHH_JS_SET__FIELD_VISIBILITY(evtSource, par_form, par_attrib) { 
var form = ApiaFunctions.getForm(par_form);
var attrib = form.getField(par_attrib);
var selectedtValueValidacion = attrib.getValue();

if(selectedtValueValidacion != ""){	
	// Muestro 
  	attrib.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
} else {
  	//Oculto
	attrib.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);	
}


return true; // END
} // END
