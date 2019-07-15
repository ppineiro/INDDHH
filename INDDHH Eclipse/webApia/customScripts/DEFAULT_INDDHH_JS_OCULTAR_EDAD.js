
function DEFAULT_INDDHH_JS_OCULTAR_EDAD(evtSource, par_nameFrm, par_nombreAtt) { 
var currTask = ApiaFunctions.getCurrentTaskName();
var form = ApiaFunctions.getForm(par_nameFrm);
var edad = form.getField(par_nombreAtt);

if(currTask != 'CARGA_DATOS_TRAMITE')
{
	edad.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
} 
else
{
	edad.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
}







return true; // END
} // END
