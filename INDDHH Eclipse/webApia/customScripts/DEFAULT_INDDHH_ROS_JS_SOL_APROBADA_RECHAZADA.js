
function DEFAULT_INDDHH_ROS_JS_SOL_APROBADA_RECHAZADA(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_ROS_FRM_APROBACION');

var aprobacion = form.getField('INDDHH_ROS_APROBACION_STR').getValue();
var nroReg = form.getField('INDDHH_ROS_NRO_REGISTRO_STR');
var motivoRechazo = form.getField('INDDHH_ROS_MOTIVO_RECHAZO_STR');

if(aprobacion == '1'){ //Aprobado
	nroReg.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  	motivoRechazo.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
} else if(aprobacion == '2'){ //Rechazado
	nroReg.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
 	motivoRechazo.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
}






return true; // END
} // END
