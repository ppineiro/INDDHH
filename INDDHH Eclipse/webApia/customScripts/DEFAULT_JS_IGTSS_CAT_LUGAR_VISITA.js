
function DEFAULT_JS_IGTSS_CAT_LUGAR_VISITA(evtSource) { 
var form = ApiaFunctions.getForm("IGTSS_CAT_DATOS_ACTUACION_INSPECTIVA");
var field_combo_evaluar = form.getField("IGTSS_DAI_LUGAR_VI_STR");
var selectedtValueValidacion = field_combo_evaluar.getValue();


var fieldCiudad = form.getField("IGTSS_DAI_CIUDAD_STR");
var fieldRural = form.getField("IGTSS_DAI_RURAL_STR");
var fieldPuerto = form.getField("IGTSS_DAI_PUERTO_STR");
var fieldMuelle = form.getField("IGTSS_DAI_MUELLE_STR");
var fieldBuque = form.getField("IGTSS_DAI_BUQUE_STR");

	
if(selectedtValueValidacion == "4"){	
	fieldCiudad.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
	fieldRural.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
	fieldPuerto.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
	fieldMuelle.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
	fieldBuque.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
} else if(selectedtValueValidacion == "5"){	
	fieldCiudad.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
	fieldRural.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
	fieldPuerto.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
	fieldMuelle.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
	fieldBuque.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
} else if(selectedtValueValidacion == "6") {
	fieldCiudad.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
	fieldRural.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
    fieldPuerto.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
    fieldMuelle.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
	fieldBuque.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
}	else{
	fieldCiudad.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
	fieldRural.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
	fieldPuerto.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
	fieldMuelle.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
	fieldBuque.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
}








return true; // END
} // END
