
function DEFAULT_INDDHH_JS_MOSTRAR_NUMERO_PERSONERIA_JURIDICA(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_ROS_FRM_ORG_SOCIAL');

var persJur = form.getField('INDDHH_ROS_PERSONERIA_JURIDICA_STR').getValue();
var fieldNumero = form.getField('INDDHH_ROS_NUMERO_PERSONERIA_JURIDICA_STR');
  
if(persJur === '1') //Si tiene
{ 
    fieldNumero.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
}  
else //No tiene
{
    fieldNumero.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
}
















return true; // END
} // END
