
function DEFAULT_INDDHH_AA_JS_MOSTRAR_FORMS_PERSONA_ORG_2(evtSource) { 
var myForm = ApiaFunctions.getEntityForm('INDDHH_AA_FRM_PERSONA_ORGANIZACION');	
var personaOrgValue = myForm.getField('INDDHH_AA_PERSONA_ORGANIZACION_STR').getValue();

var frmDatosPersonales = ApiaFunctions.getEntityForm('INDDHH_AA_FRM_DATOS_PERSONALES');
var frmDatosGenerales = ApiaFunctions.getEntityForm('INDDHH_AA_FRM_DATOS_GENERALES');
var frmDomicilio = ApiaFunctions.getEntityForm('INDDHH_AA_FRM_DOMICILIO');
var frmDatosContacto = ApiaFunctions.getEntityForm('INDDHH_AA_FRM_DATOS_CONTACTO');
var frmRepTitulares = ApiaFunctions.getEntityForm('INDDHH_AA_REPRESENTANTES_TITULARES');
var frmRepSuplentes = ApiaFunctions.getEntityForm('INDDHH_AA_REPRESENTANTES_SUPLENTES');

if(personaOrgValue == '1') //Persona
{
 	frmDatosPersonales.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  	frmDatosGenerales.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  	frmDomicilio.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  	frmDatosContacto.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  	frmRepTitulares.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  	frmRepSuplentes.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
}
else 
{
  if(personaOrgValue == '2'){ //Organización
    
  	frmDatosPersonales.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  	frmDatosGenerales.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  	frmDomicilio.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  	frmDatosContacto.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  	frmRepTitulares.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  	frmRepSuplentes.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  }
}






return true; // END
} // END
