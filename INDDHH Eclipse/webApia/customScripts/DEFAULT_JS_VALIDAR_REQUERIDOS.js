
function DEFAULT_JS_VALIDAR_REQUERIDOS(evtSource, par_form) { 
var requerido = ApiaFunctions.getForm(par_form).getField("TRM_VALIDACION_REQUERIDO_STR").getValue();
if (requerido != "") {
  alert("Faltan campos requeridos. No se puede enviar la solicitud");
  return false;
}
return true;



return true; // END
} // END
