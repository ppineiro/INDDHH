
function fnc_1_2049(evtSource, par_nomForm, par_nomTabla, par_ctdElemsTabla, par_nomAttSeleccionarOpcion, par_msjError) { 
var myForm = ApiaFunctions.getEntityForm('INDDHH_ROS_FRM_ACTIVIDADES_TRABAJO_INTERINST');
var datosGen = ApiaFunctions.getEntityForm('INDDHH_ROS_FRM_DATOS_GENERALES');
var tipoInst = datosGen.getField('INDDHH_ROS_TIPO_ORGANIZACION_STR').getValue();

if(tipoInst == '2') //social
{
    var myGrid = myForm.getField('tblActividad');
    var indicador = false;
    for (let index = 0; index < 15; index++) {
      var value = myForm
        .getFieldColumn('INDDHH_ROS_SELECCIONAR_ACTIVIDAD_STR')
        [index].getValue();
      if (value == true) {
        //alguno está marcado
        indicador = true;
        break;
      }
    }
    if (indicador == false) {
      showMsgConfirm("error", 'Debe seleccionar al menos una actividad.', "setFocoObj");
      return false;
    }
}

return true; // END
} // END
