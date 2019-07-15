
function DEFAULT_INDDHH_JS_OCULTAR_FORMS_CONSULTANTE_DENUNCIANTE(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_FRM_CONSULTANTE_DENUNCIANTE');
var tipoPersona = form.getField('INDDHH_TIPO_PERSONA_STR').getValue();

//Forms con campos
var tablaVariasPersonas = ApiaFunctions.getForm('INDDHH_FRM_CONSULTANTE_DENUNCIANTE_VARIAS_PERSONAS');
var org = ApiaFunctions.getForm('INDDHH_FRM_CONSULTANTE_DENUNCIANTE_ORG');
var inciso = ApiaFunctions.getForm('INDDHH_FRM_CONSULTANTE_DENUNCIANTE_ESTADO');
var orgInt = ApiaFunctions.getForm('INDDHH_FRM_CONSULTANTE_DENUNCIANTE_ORG_INT');
var especifiqueOtro = ApiaFunctions.getForm('INDDHH_FRM_CONSULTANTE_DENUNCIANTE_OTRO');

if(tipoPersona == '1') //Persona individual
{
    tablaVariasPersonas.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
    org.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
    inciso.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
    orgInt.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
    especifiqueOtro.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
} 
else
{
  if(tipoPersona == '2') //Varias personas
  {
      tablaVariasPersonas.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);    
      org.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
      inciso.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
      orgInt.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
      especifiqueOtro.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  }
  else
  {
  	if(tipoPersona == '3') //Org social
    {
        tablaVariasPersonas.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
        org.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
        inciso.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
        orgInt.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
        especifiqueOtro.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
    }
    else
    {
      if(tipoPersona == '4') //Org del estado
      {
          tablaVariasPersonas.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
          org.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
          inciso.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
          orgInt.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
          especifiqueOtro.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
      }
      else
      {
          if(tipoPersona == '5') //Org inte
          {
              tablaVariasPersonas.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
              org.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
              inciso.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
              orgInt.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
              especifiqueOtro.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
          }
        else
        {
          	if(tipoPersona == '6') //Otro
            {
                tablaVariasPersonas.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
                org.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
                inciso.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
                orgInt.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
                especifiqueOtro.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
            }
        }
      }
    }
  }
}
















return true; // END
} // END
