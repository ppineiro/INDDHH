
function DEFAULT_INDDHH_JS_SUBMIT_DATOS_CONTACTO(evtSource, par_nameInicioTrm) { 
var form = ApiaFunctions.getForm('INDDHH_FRM_DATOS_CONTACTO');

var cel = form.getField('INDDHH_TELEFONO_CONTACTO_STR');
var tel = form.getField('INDDHH_OTRO_TEL_CONTACTO_STR');
var correo = form.getField('INDDHH_CORREO_CONTACTO_STR');

var celV = form.getField('INDDHH_TELEFONO_CONTACTO_STR').getValue();
var telV = form.getField('INDDHH_OTRO_TEL_CONTACTO_STR').getValue();
var correoV = form.getField('INDDHH_CORREO_CONTACTO_STR').getValue();

var inicioTrm = form.getField(par_nameInicioTrm).getValue();

if(inicioTrm == true) {
  if(celV.length === 0 && telV.length === 0 && correoV.length === 0)
  {
    showMsgError('INDDHH_FRM_DATOS_CONTACTO', 'INDDHH_TELEFONO_CONTACTO_STR', "Error: Debe ingresar algún dato de contacto.");
    showMsgError('INDDHH_FRM_DATOS_CONTACTO', 'INDDHH_OTRO_TEL_CONTACTO_STR', "Error: Debe ingresar algún dato de contacto.");
    showMsgError('INDDHH_FRM_DATOS_CONTACTO', 'INDDHH_CORREO_CONTACTO_STR', "Error: Debe ingresar algún dato de contacto.");
    return false;
  } else
  {
    hideMsgError('INDDHH_FRM_DATOS_CONTACTO', 'INDDHH_TELEFONO_CONTACTO_STR');
    hideMsgError('INDDHH_FRM_DATOS_CONTACTO', 'INDDHH_OTRO_TEL_CONTACTO_STR');
    hideMsgError('INDDHH_FRM_DATOS_CONTACTO', 'INDDHH_CORREO_CONTACTO_STR');
  }
} else {
  if(celV.length === 0 && telV.length === 0 && correoV.length === 0)
  {
    showMessage("Error: Debe ingresar algún dato de contacto.");
    return false;
  }
}
return true; // END
} // END
