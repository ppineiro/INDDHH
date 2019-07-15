
function DEFAULT_INDDHH_ROS_JS_TIPO_ORGANIZACION(evtSource) { 
var frmDatosGen = ApiaFunctions.getEntityForm('INDDHH_ROS_FRM_DATOS_GENERALES');	
var tipoOrg = frmDatosGen.getField('INDDHH_ROS_TIPO_ORGANIZACION_STR').getValue();

var frmOrgSocial = ApiaFunctions.getEntityForm('INDDHH_ROS_FRM_ORG_SOCIAL');	
var frmOrgGub = ApiaFunctions.getEntityForm('INDDHH_ROS_FRM_ORG_GUBERNAMENTAL');	
var frmOrg = ApiaFunctions.getEntityForm('INDDHH_ROS_FRM_ORGANIZACION');
var frmActiv = ApiaFunctions.getEntityForm('INDDHH_ROS_FRM_ACTIVIDADES_TRABAJO_INTERINST');

if(tipoOrg == '1') //Gubernamental
{
	frmOrgSocial.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  	frmOrgGub.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
    frmOrg.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  	frmActiv.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
}
else
{
  	if(tipoOrg == '2') //Social
    {
 		frmOrgSocial.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  		frmOrgGub.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
        frmOrg.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
      	frmActiv.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
    }
  	else
    {
  		frmOrgSocial.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  		frmOrgGub.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
        frmOrg.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
      	frmActiv.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  	}
}






return true; // END
} // END
