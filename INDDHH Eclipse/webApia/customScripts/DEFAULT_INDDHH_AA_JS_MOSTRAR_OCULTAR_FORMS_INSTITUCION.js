
function DEFAULT_INDDHH_AA_JS_MOSTRAR_OCULTAR_FORMS_INSTITUCION(evtSource) { 
var frmPertenece = ApiaFunctions.getEntityForm('INDDHH_AA_FRM_PERTENENCIA_INSTITUCIONAL');
var frmTipoInst = ApiaFunctions.getEntityForm('INDDHH_AA_FRM_TIPO_INSTITUCION');
var frmOrgEstado = ApiaFunctions.getEntityForm('INDDHH_AA_FRM_ORG_ESTADO');
var frmDomInst = ApiaFunctions.getEntityForm('INDDHH_AA_FRM_DOMICILIO_INSTITUCION');
var frmContactoInst = ApiaFunctions.getEntityForm('INDDHH_AA_FRM_DATOS_CONTACTO_INSTITUCION');
var frmRegOrg = ApiaFunctions.getEntityForm('INDDHH_AA_FRM_REGISTRO_ORGANIZACION');

var perteneceInst = frmPertenece
  .getField('INDDHH_AA_PERTENECE_A_INSTITUCION_STR')
  .getValue();
var tipoInst = frmTipoInst
  .getField('INDDHH_AA_TIPO_INSTITUCION_STR')
  .getValue();
var nombreInst = frmTipoInst.getField('INDDHH_AA_NOMBRE_INSTITUCION_STR');

if (perteneceInst == '1') {
  //Si
  frmTipoInst.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  frmDomInst.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  frmContactoInst.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  if (tipoInst == '1') { //Social
    //Org. social
    frmRegOrg.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
    frmOrgEstado.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
    nombreInst.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  } else {
    if (tipoInst == '2') { //Org. Estado
    	frmRegOrg.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
    	frmOrgEstado.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
      	nombreInst.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
    }
    else{ //Org. internacional/Agencia coop.
    	frmRegOrg.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
    	frmOrgEstado.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
      	nombreInst.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
    }
  }
}

else {
  //No
  frmTipoInst.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  frmOrgEstado.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  frmDomInst.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  frmContactoInst.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  frmRegOrg.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
}








return true; // END
} // END
