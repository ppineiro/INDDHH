
function DEFAULT_INDDHH_ROS_JS_MOSTRAR_PAIS_SEDE_INT(evtSource) { 
var myForm = ApiaFunctions.getEntityForm('INDDHH_ROS_FRM_TRABAJO');	
var areaCoberturaValue = myForm.getField('INDDHH_ROS_AREA_COBERTURA_STR').getValue();

var paisSedeInt = myForm.getField('INDDHH_ROS_PAIS_SEDE_INTERNACIONAL_STR');

if(areaCoberturaValue == '5') //Cobertura internacional
{
 	paisSedeInt.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
}
else
{
  	paisSedeInt.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
}








return true; // END
} // END
