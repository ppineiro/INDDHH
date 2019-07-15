
function DEFAULT_INDDHH_OCULTAR_PAIS_EMISOR(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_FRM_DATOS_PERSONALES');
var docTipo = form.getField('INDDHH_ATT_DATOS_PERSONALES_DOC_TIPO_STR').getValue();
var paisEmisor = form.getField('INDDHH_ATT_DATOS_PERSONALES_PAIS_STR');

if(docTipo == '1')
{
	paisEmisor.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
} 
else
{
	paisEmisor.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
}
return true; // END
} // END
