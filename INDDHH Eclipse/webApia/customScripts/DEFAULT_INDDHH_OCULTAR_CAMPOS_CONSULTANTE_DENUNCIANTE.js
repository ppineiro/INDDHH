
function DEFAULT_INDDHH_OCULTAR_CAMPOS_CONSULTANTE_DENUNCIANTE(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_FRM_CONSULTANTE_DENUNCIANTE');
var tipoPersona = form.getField('INDDHH_TIPO_PERSONA_STR').getValue();

//Campos
var tablaVariasPersonas = form.getField('tblVariasPersonas');
var org = form.getField('INDDHH_NOMBRE_ORGANIZACION_STR');
var inciso = form.getField('INDDHH_ORG_INCISO_DENUNCIANTE_STR');
var unEjecutora = form.getField('INDDHH_ORG_UNIDAD_EJECUTORA_DENUNCIANTE_STR');
var orgInt = form.getField('INDDHH_NOMBRE_ORG_INTERNACIONAL_STR');
var especifiqueOtro = form.getField('INDDHH_OTRO_DENUNCIANTE_STR');

if(tipoPersona == '1')
{
    tablaVariasPersonas.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
    org.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
    inciso.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
    unEjecutora.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
    orgInt.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
    especifiqueOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
} 
else
{
  if(tipoPersona == '2')
  {
      tablaVariasPersonas.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);    
      org.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
      inciso.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
      unEjecutora.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
      orgInt.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
      especifiqueOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  }
  else
  {
  	if(tipoPersona == '3')
    {
        tablaVariasPersonas.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
        org.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
      	org.setProperty(IProperty.PROPERTY_REQUIRED, true);
        inciso.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
        unEjecutora.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
        orgInt.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
        especifiqueOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
    }
    else
    {
      if(tipoPersona == '4')
      {
          tablaVariasPersonas.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
          org.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
          inciso.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
          unEjecutora.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
          	inciso.setProperty(IProperty.PROPERTY_REQUIRED, true);
          	unEjecutora.setProperty(IProperty.PROPERTY_REQUIRED, true);
          orgInt.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
          especifiqueOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
      }
      else
      {
          if(tipoPersona == '5')
          {
              tablaVariasPersonas.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
              org.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
              inciso.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
              unEjecutora.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
              orgInt.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
             	orgInt.setProperty(IProperty.PROPERTY_REQUIRED, true);
              especifiqueOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
          }
        else
        {
          	if(tipoPersona == '6')
            {
                tablaVariasPersonas.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
                org.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
                inciso.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
                unEjecutora.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
                orgInt.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
                especifiqueOtro.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
               	especifiqueOtro.setProperty(IProperty.PROPERTY_REQUIRED, true);
            }
        }
      }
    }
  }
}













return true; // END
} // END
