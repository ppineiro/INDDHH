
function DEFAULT_INDDHH_JS_SET_MOTIVO_NO_ADMISIBLE(evtSource) { 
var form = ApiaFunctions.getEntityForm('INDDHH_NO_ES_ADMISIBLE');

if(form != null){
  var motivo = form.getField('INDDHH_MOTIVO_NO_ADMISIBLE_STR');
  var motivoVal = form.getField('INDDHH_MOTIVO_NO_ADMISIBLE_STR').getValue();
  
  alert(motivoVal);
  
  var fldMotivoValor = form.getField('INDDHH_MOTIVO_NO_ADMISIBLE_VALOR_STR');
  
  if (motivoVal == 1) {
    fldMotivoValor.setValue('Fuera de plazo');
  } else {
    if (motivoVal == 2) {
      fldMotivoValor.setValue('Incompetencia');
    } else {
      if (motivoVal == 3) {
        fldMotivoValor.setValue('Inadmisibilidad manifiesta');
      } else {
        if (motivoVal == 4) {
          fldMotivoValor.setValue('Falta de fundamentos');
        } else {
          if (motivoVal == 5) {
            fldMotivoValor.setValue('Evidente mala fe');
          }
        }
      }
    }
  }
}







return true; // END
} // END
