
function DEFAULT_INDDHH_SA_JS_MOSTRAR_OTRA_TEMATICA(evtSource) { 
var myForm = ApiaFunctions.getEntityForm('INDDHH_SA_FRM_ACTIVIDAD');	
var myGrid = myForm.getField('tblTematicas');
var myField = myGrid.getRow(evtSource.index)[0];
var campoOtro = myForm.getField('INDDHH_SA_OTRA_TEMATICA_STR');

var seleccionar = myField.getValue();

if(seleccionar == true && evtSource.index == 8)
{
 	 campoOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
}
else
{
  	if(seleccionar == false && evtSource.index == 8)
    {
 		campoOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true); 
    }
}














return true; // END
} // END
