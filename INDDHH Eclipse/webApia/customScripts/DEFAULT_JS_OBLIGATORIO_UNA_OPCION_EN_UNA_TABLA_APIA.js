
function DEFAULT_JS_OBLIGATORIO_UNA_OPCION_EN_UNA_TABLA_APIA(evtSource, par_nomForm, par_nomTabla, par_ctdElemsTabla, par_nomAttSeleccionarOpcion, par_msjError) { 
var myForm = ApiaFunctions.getEntityForm(par_nomForm);
var myGrid = myForm.getField(par_nomTabla);
var indicador = false;
for (let index = 0; index < par_ctdElemsTabla; index++) {
  var value = myForm
    .getFieldColumn(par_nomAttSeleccionarOpcion)
    [index].getValue();
  if (value == true) {
    //alguno está marcado
    indicador = true;
    break;
  }
}
if (indicador == false) {
  //ApiaFunctions.showConfirm(par_msjError);
  //showMessage(par_msjError);
  //return false;
}






return true; // END
} // END
