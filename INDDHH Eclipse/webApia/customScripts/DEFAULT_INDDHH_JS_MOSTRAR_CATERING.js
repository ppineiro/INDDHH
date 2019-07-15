
function DEFAULT_INDDHH_JS_MOSTRAR_CATERING(evtSource) { 
var myForm = ApiaFunctions.getEntityForm('INDDHH_SA_FRM_ACTIVIDAD');	
var habraCateringValue = myForm.getField('INDDHH_SA_HABRA_CATERING_STR').getValue();

var empresa = myForm.getField('INDDHH_SA_NOMBRE_DE_EMPRESA_SERVICIO_CATERING_STR');
var telefono = myForm.getField('INDDHH_SA_TELEFONO_CATERING_STR');

if(habraCateringValue == '1')
{
 	 empresa.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  	telefono.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
}
else
{
  	empresa.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  	telefono.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
}






return true; // END
} // END
