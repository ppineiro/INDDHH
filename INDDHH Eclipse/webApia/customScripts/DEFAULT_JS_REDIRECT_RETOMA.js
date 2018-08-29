
function DEFAULT_JS_REDIRECT_RETOMA(evtSource) { 
var form = ApiaFunctions.getForm("RET_TRM_DATOS_RETOMA_2");

var field_result = form.getField("RET_TRM_RESULT");
var valor = field_result.getValue();

var field_ping = form.getField("RET_TRM_PING");
var ping = field_ping.getValue();

var field_usuario = form.getField("RET_TRM_USUARIO_STR");
var usuario = field_usuario.getValue();

var field_pass = form.getField("RET_TRM_USUARIO_PASS_STR");
var pass = field_pass.getValue();

var link= form.getField("TRM_URL_RETOMA_STR").getValue();

var modoAut= form.getField("TRM_MODO_AUTENTICACION_STR").getValue();
var auth="";
switch (modoAut) {
  // Solo registro
  case "2" : auth="&authType="
  break;
    
  // Solo cédula electrónica.
  case "3" : auth="&authType=CI"
  break;
    
}

ApiaFunctions.hideActionButton(ActionButton.BTN_CONFIRM);
if(valor == "OK") {
  if( usuario=='guest') {
	//parent.document.location.href= CONTEXT + "/page/externalAccess/workTask.jsp?logFromFile=true&env=1&lang=1&numInst=" + ping + "&onFinish=101&eatt_str_TRM_RETOMA_TRAMITE_STR=SI";
	//top.document.location.href= link;
	top.document.location.href= CONTEXT + '/portal/retomaTramite.jsp?a=1'+auth+TAB_ID_REQUEST;
  } else {
    //alert("El trámite fue iniciado por un usuario registrado");
	// parent.parent.document.location.href= CONTEXT + '/portal/retomaCoesys.jsp?id_tramite='+ping;
	// top.document.location.href= CONTEXT + '/portal/retomaCoesys.jsp?id_tramite='+ping+auth+TAB_ID_REQUEST;
    top.document.location.href=link;
    
  }
}else{
	top.document.location.href= CONTEXT + '/portal/retomaMsg.jsp?a=1' + TAB_ID_REQUEST;

}






return true; // END
} // END
