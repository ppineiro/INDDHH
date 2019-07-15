
function DEFAULT_INDDHH_JS_OCULTAR_FORM_DATOS_CONTACTO(evtSource) { 
var currTask = ApiaFunctions.getCurrentTaskName();
var form = ApiaFunctions.getForm('INDDHH_FRM_DATOS_CONTACTO');
var cel = form.getField('INDDHH_TELEFONO_CONTACTO_STR');
var celValue = cel.getValue();

if(celValue.length == 0 && (currTask == 'INDDHH_RECEPCION' || currTask == 'INDDHH_REVISION_ERRORES')) {
	form.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
}



return true; // END
} // END
