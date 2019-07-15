
function DEFAULT_INDDHH_JS_OCULTAR_FORM_DATOS_PERSONALES(evtSource) { 
var currTask = ApiaFunctions.getCurrentTaskName();
var form = ApiaFunctions.getForm('INDDHH_FRM_DATOS_PERSONALES');
var doc = form.getField('INDDHH_ATT_DATOS_PERSONALES_DOC_NUM_STR');
var docValue = doc.getValue();

if(docValue.length == 0 && (currTask == 'INDDHH_RECEPCION' || currTask == 'INDDHH_REVISION_ERRORES')) {
	form.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
}











return true; // END
} // END
