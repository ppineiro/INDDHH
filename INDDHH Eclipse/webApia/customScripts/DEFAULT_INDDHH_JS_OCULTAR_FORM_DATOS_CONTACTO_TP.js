
function DEFAULT_INDDHH_JS_OCULTAR_FORM_DATOS_CONTACTO_TP(evtSource) { 
var currTask = ApiaFunctions.getCurrentTaskName();
var form = ApiaFunctions.getForm('INDDHH_FRM_DATOS_CONTACTO_TP');
var cel = form.getField('INDDHH_TELEFONO_CONTACTO_TP_STR');
var celValue = cel.getValue();

//alert(celValue.length);

if(celValue.length == 0 && (currTask == 'INDDHH_RECEPCION' || currTask == 'INDDHH_REVISION_ERRORES')) {
	form.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
}










return true; // END
} // END
