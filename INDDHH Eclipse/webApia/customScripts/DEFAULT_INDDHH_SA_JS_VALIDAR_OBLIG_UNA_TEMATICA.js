
function DEFAULT_INDDHH_SA_JS_VALIDAR_OBLIG_UNA_TEMATICA(evtSource) { 
var myForm = ApiaFunctions.getEntityForm('INDDHH_SA_FRM_ACTIVIDAD');
var myGrid = myForm.getField('tblTematicas');
var indicador = false;
for (let index = 0; index < 9; index++) {
  var value = myForm
    .getFieldColumn('INDDHH_SA_SELECCIONAR_TEMATICA_STR')
    [index].getValue();
  if (value == true) {
    //alguno está marcado
    indicador = true;
    break;
  }
}
if (indicador == false) {
  showMsgConfirm('error', 'Debe seleccionar al menos una temática.', 'setFocoObj');
  return false;
}




return true; // END
} // END
