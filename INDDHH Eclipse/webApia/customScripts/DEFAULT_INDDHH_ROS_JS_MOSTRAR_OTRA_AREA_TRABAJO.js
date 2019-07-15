
function DEFAULT_INDDHH_ROS_JS_MOSTRAR_OTRA_AREA_TRABAJO(evtSource) { 
var myForm = ApiaFunctions.getEntityForm('INDDHH_ROS_FRM_TRABAJO');	
var myGrid = myForm.getField('tblAreaTem');
var myField = myGrid.getRow(evtSource.index)[0];
var campoOtro = myForm.getField('INDDHH_ROS_OTRA_TEMATICA_TRABAJO_STR');

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
