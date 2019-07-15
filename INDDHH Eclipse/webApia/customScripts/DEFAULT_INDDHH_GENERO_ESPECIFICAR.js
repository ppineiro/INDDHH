
function DEFAULT_INDDHH_GENERO_ESPECIFICAR(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_FRM_DATOS_PERSONALES');
var genero = form.getField('INDDHH_PERSONA_GENERO_STR').getValue();
var especifique = form.getField('INDDHH_ESPECIFICACION_GENERO_STR');

if(genero == '4')
{
	especifique.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
} 
else
{
	especifique.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
}

return true; // END
} // END
