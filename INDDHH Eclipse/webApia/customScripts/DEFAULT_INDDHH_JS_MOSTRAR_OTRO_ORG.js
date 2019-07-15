
function DEFAULT_INDDHH_JS_MOSTRAR_OTRO_ORG(evtSource) { 
var myForm = ApiaFunctions.getEntityForm('INDDHH_FRM_DESCRIPCION_PROBLEMA');	
var myGrid = myForm.getField('tblOrg');
var myField = myGrid.getRow(evtSource.index)[0];
var campoOtro = myForm.getField('INDDHH_OTRO_ORGANISMO_CONCURRIO_STR');

var seleccionar = myField.getValue();

//alert(seleccionar);
//alert(evtSource.index);

if(seleccionar == true && evtSource.index == 3)
{
 	 campoOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
}
else
{
  	if(seleccionar == false && evtSource.index == 3)
    {
 		campoOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true); 
    }
}






return true; // END
} // END
