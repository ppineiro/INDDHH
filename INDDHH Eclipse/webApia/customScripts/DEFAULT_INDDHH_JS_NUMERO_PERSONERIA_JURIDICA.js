
function fnc_1_1971(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_FRM_RECEPCION');

var formAdm = ApiaFunctions.getForm('INDDHH_ES_ADMISIBLE');
var formNoAdm = ApiaFunctions.getForm('INDDHH_NO_ES_ADMISIBLE');
var formDDHHVuln = ApiaFunctions.getForm('INDDHH_FRM_DDHH_VULN_ORG_DENUNCIADO');

var hayErrores = form.getField('INDDHH_ERRORES_DATOS_STR').getValue();
var err = form.getField('INDDHH_ESPECIFICACION_ERRORES_INGRESADOS_STR');
var admONo = form.getField('INDDHH_ADMISIBLE_O_NO_STR');
var lblFinaliza = form.getField('lblFinalizarTmt');
var finaliza = form.getField('INDDHH_FINALIZA_TRAMITE_STR');

var texto = 'Seleccione el check "Finalizar trámite" si se desea terminar definitivamente con el trabajo correspondiente a esta Consulta/Denuncia';

if(hayErrores == '1'){ //No
  
  if(admONo == '1'){ //Admisible
      formAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
    formNoAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  } else{
      formAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
    formNoAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  }
  
  formDDHHVuln.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
  
	err.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  admONo.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
 
  lblFinaliza.setValue(texto);
  finaliza.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
 
} else{ //Si hay errores
	err.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  admONo.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  
  lblFinaliza.clearValue();
  finaliza.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  
  formAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  formNoAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  formDDHHVuln.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
}









return true; // END
} // END
