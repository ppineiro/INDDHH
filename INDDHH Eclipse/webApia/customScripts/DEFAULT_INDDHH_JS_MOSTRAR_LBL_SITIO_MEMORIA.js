
function DEFAULT_INDDHH_JS_MOSTRAR_LBL_SITIO_MEMORIA(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_SA_FRM_ACTIVIDAD');

var visitaSitio = form.getField('INDDHH_SA_VISITA_SITIO_MEMORIA_STR').getValue();
var lbl = form.getField('lblSitioMemoria');

var texto = 'Recuerde completar el trámite “Solicitud de visita al Sitio de Memoria” que le llegará al correo electrónico.';

if(visitaSitio == '1'){ //Si
  
  lbl.setValue(texto);
 
} else{ //Si hay errores
	
  lbl.clearValue();
}










return true; // END
} // END
