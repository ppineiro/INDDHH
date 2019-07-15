
function DEFAULT_INDDHH_ROS_JS_MOSTRAR_OTRA_TEMATICA_SI_MARCO(evtSource) { 
var myForm = ApiaFunctions.getEntityForm('INDDHH_ROS_FRM_TRABAJO');	

var value = myForm.getFieldColumn('INDDHH_ROS_SELECCIONAR_TEMATICA_TRABAJO_STR')[14].getValue();

var campoOtro = myForm.getField('INDDHH_ROS_OTRA_TEMATICA_TRABAJO_STR');

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
