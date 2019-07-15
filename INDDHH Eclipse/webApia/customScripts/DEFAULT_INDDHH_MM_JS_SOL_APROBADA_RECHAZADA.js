
function DEFAULT_INDDHH_MM_JS_SOL_APROBADA_RECHAZADA(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_MM_FRM_APROBACION');
var formRechazo = ApiaFunctions.getForm('INDDHH_MM_FRM_RECHAZO');

var aprobacion = form.getField('INDDHH_MM_APROBACION_STR').getValue();

var fechaSol = form.getField('INDDHH_MM_FECHA_VISITA_FEC').getValue();
var horaSol = form.getField('INDDHH_MM_HORA_VISITA_STR').getValue();

var fechaDef = form.getField('INDDHH_MM_FECHA_VISITA_DEFINITIVA_FEC');
var horaDef = form.getField('INDDHH_MM_HORA_VISITA_DEFINITIVA_STR');

var fechaDefValue = form.getField('INDDHH_MM_FECHA_VISITA_DEFINITIVA_FEC').getValue();
var horaDefValue = form.getField('INDDHH_MM_HORA_VISITA_DEFINITIVA_STR').getValue();

var cambio = form.getField('INDDHH_MM_CAMBIO_FECHA_HORA_STR');
var motivosCambio = form.getField('INDDHH_MM_MOTIVOS_CAMBIO_FECHA_HORA_STR');

var lblDefinitivo = form.getField('lblDefinitivo');

var texto = 'Definitivo:';

cambio.setValue(false);

if((fechaSol != fechaDefValue) || (horaSol != horaDefValue)){
  motivosCambio.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  cambio.setValue(true);
} else{
	motivosCambio.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  cambio.setValue(false);
}


if(aprobacion == '1'){ //Aprobado
	fechaDef.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  	horaDef.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  	formRechazo.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  	lblDefinitivo.setValue(texto);
} else if(aprobacion == '2'){ //Rechazado
	fechaDef.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  	horaDef.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
 	motivosCambio.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
 	formRechazo.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  	lblDefinitivo.clearValue();
  
} else{
  	fechaDef.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  	horaDef.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
 	formRechazo.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
	lblDefinitivo.clearValue();
}












return true; // END
} // END
