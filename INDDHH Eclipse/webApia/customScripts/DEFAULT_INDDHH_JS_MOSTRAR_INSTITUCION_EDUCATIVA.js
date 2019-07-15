
function DEFAULT_INDDHH_JS_MOSTRAR_INSTITUCION_EDUCATIVA(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_MM_FRM_VISITA');

var solicitanteValue = form.getField('INDDHH_MM_SOLICITANTE_STR').getValue();
var instEducativa = form.getField('INDDHH_MM_INSTITUCION_EDUCATIVA_STR');

if(solicitanteValue === '3'){ //Institución educativa seleccionado
  
  instEducativa.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
 
} else{ //Si hay errores

  instEducativa.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
}










return true; // END
} // END
