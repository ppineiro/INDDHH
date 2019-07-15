
function DEFAULT_INDDHH_SA_JS_MOSTRAR_OTRA_TEMATICA_SI_MARCO(evtSource) { 
var myForm = ApiaFunctions.getEntityForm('INDDHH_SA_FRM_ACTIVIDAD');	

var value = myForm.getFieldColumn('INDDHH_SA_SELECCIONAR_TEMATICA_STR')[8].getValue();

var campoOtro = myForm.getField('INDDHH_SA_OTRA_TEMATICA_STR');

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
