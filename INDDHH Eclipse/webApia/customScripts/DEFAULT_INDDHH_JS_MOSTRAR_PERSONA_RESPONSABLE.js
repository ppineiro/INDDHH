
function DEFAULT_INDDHH_JS_MOSTRAR_PERSONA_RESPONSABLE(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_SA_FRM_APROBACION');

var aprobacion = form.getField('INDDHH_SA_APROBACION_STR').getValue();
var nombreResp = form.getField('INDDHH_SA_NOMBRE_RESPONSABLE_STR');
var correoResp = form.getField('INDDHH_SA_CORREO_RESPONSABLE_STR');
var lblPersonaResponsable = form.getField('lblPersonaResponsable');

var texto = 'Persona responsable por la INDDHH';

if(aprobacion == '1'){ //Aprobado
	nombreResp.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  	correoResp.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  	lblPersonaResponsable.setValue(texto);
} else{ //Rechazado
	nombreResp.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  	correoResp.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  	lblPersonaResponsable.clearValue();
}
return true; // END
} // END
