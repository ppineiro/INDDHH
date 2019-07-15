
function DEFAULT_INDDHH_CD_JS_OCULTAR_FORM_VIA_INGRESO(evtSource) { 
if(ApiaFunctions.getCurrentTaskName() == 'CARGA_DATOS_TRAMITE'){
  var formViaIngreso = ApiaFunctions.getEntityForm('INDDHH_FRM_VIA_COMPLETA');
  var viaIngreso = formViaIngreso.getField('INDDHH_CD_VERIFICACION_VIA_INGRESO_STR').getValue();
  
  if(viaIngreso == 'Online'){
      formViaIngreso.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  } else{
      if(viaIngreso == 'Presencial'){
          formViaIngreso.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
      }
  }
}


return true; // END
} // END
