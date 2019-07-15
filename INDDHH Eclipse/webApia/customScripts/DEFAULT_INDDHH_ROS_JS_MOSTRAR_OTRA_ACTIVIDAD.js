
function DEFAULT_INDDHH_ROS_JS_MOSTRAR_OTRA_ACTIVIDAD(evtSource) { 
var myForm = ApiaFunctions.getEntityForm('INDDHH_ROS_FRM_ACTIVIDADES_TRABAJO_INTERINST');	
var myGrid = myForm.getField('tblActividad');
var myField = myGrid.getRow(evtSource.index)[0];
var campoOtro = myForm.getField('INDDHH_ROS_OTRA_ACTIVIDAD_STR');

var seleccionar = myField.getValue();

if(seleccionar == true && evtSource.index == 14)
{
 	 campoOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
}
else
{
  	if(seleccionar == false && evtSource.index == 14)
    {
 		campoOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true); 
    }
}











return true; // END
} // END
