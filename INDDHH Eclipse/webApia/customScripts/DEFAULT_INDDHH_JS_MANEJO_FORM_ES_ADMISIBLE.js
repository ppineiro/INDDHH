
function DEFAULT_INDDHH_JS_MANEJO_FORM_ES_ADMISIBLE(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_ES_ADMISIBLE');

var esAdm = form.getField('INDDHH_OPCIONES_ADMISIBLE_STR');
var org = form.getField('INDDHH_ORGANISMO_COORDINAR_STR');
var otro = form.getField('INDDHH_OTRO_ORG_COORDINAR_STR');
var tipoDen = form.getField('INDDHH_TIPO_DENUNCIA_STR');

var esAdmVal = esAdm.getValue();
var orgVal = org.getValue();
var otroVal = otro.getValue();
var tipoDenVal = tipoDen.getValue();

if(esAdmVal == '1')
{
	org.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  	tipoDen.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  	
  	if(orgVal == '4')
    {
        otro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
    }
    else{
    	otro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
    }
  } 
else
{
  if(esAdmVal == '2')
  {
      org.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
      otro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
    
      tipoDen.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  }
}



return true; // END
} // END
