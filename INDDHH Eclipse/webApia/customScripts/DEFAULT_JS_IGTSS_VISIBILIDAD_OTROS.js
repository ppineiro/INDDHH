
function DEFAULT_JS_IGTSS_VISIBILIDAD_OTROS(evtSource, par_combo_evaluar, par_cual) { 
var form = ApiaFunctions.getForm("IGTSS_CAT_CONCEPTO");
var field_combo_evaluar = form.getField(par_combo_evaluar);
var selectedtValueValidacion = field_combo_evaluar.getValue();

var field = form.getField(par_cual);

	
if(selectedtValueValidacion == "1"){	
	field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
}else{
	field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
}











return true; // END
} // END
