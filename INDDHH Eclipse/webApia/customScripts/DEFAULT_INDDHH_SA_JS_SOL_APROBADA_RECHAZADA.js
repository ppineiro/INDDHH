
function DEFAULT_INDDHH_SA_JS_SOL_APROBADA_RECHAZADA(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_SA_FRM_APROBACION');

var aprobacion = form.getField('INDDHH_SA_APROBACION_STR').getValue();
var nombreResp = form.getField('INDDHH_SA_NOMBRE_RESPONSABLE_STR');
var correoResp = form.getField('INDDHH_SA_CORREO_RESPONSABLE_STR');
var lblPersonaResponsable = form.getField('lblPersonaResponsable');
var motivoRechazo = form.getField('INDDHH_SA_MOTIVO_RECHAZO_STR');

var texto = 'Persona responsable por la INDDHH';

lblPersonaResponsable.clearValue();

if(aprobacion == '1'){ //Aprobado
	nombreResp.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  	correoResp.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  	lblPersonaResponsable.setValue(texto);
  	motivoRechazo.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
} else if(aprobacion == '2'){ //Rechazado
	nombreResp.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  	correoResp.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  	lblPersonaResponsable.clearValue();
 	motivoRechazo.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
}



return true; // END
} // END
