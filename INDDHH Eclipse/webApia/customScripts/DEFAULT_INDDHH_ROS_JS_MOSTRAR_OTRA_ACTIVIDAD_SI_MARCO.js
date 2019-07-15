
function DEFAULT_INDDHH_ROS_JS_MOSTRAR_OTRA_ACTIVIDAD_SI_MARCO(evtSource) { 
var myForm = ApiaFunctions.getEntityForm('INDDHH_ROS_FRM_ACTIVIDADES_TRABAJO_INTERINST');	

var value = myForm.getFieldColumn('INDDHH_ROS_SELECCIONAR_ACTIVIDAD_STR')[14].getValue();

var campoOtro = myForm.getField('INDDHH_ROS_OTRA_ACTIVIDAD_STR');

if(value == true)
{
 	 campoOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
}
else
{
  	if(value == false)
    {
 		campoOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true); 
    }
}


















return true; // END
} // END
