
function DEFAULT_INDDHH_JS_VISIBILIDAD_FORMS_RECEPCION(evtSource) { 
var form = ApiaFunctions.getEntityForm('INDDHH_FRM_RECEPCION');

var formAdm = ApiaFunctions.getEntityForm('INDDHH_ES_ADMISIBLE');
var formNoAdm = ApiaFunctions.getEntityForm('INDDHH_NO_ES_ADMISIBLE');
var formDDHHVuln = ApiaFunctions.getEntityForm('INDDHH_FRM_DDHH_VULN_ORG_DENUNCIADO');

var hayErrores = form.getField('INDDHH_ERRORES_DATOS_STR').getValue();
var err = form.getField('INDDHH_ESPECIFICACION_ERRORES_INGRESADOS_STR');
var admONo = form.getField('INDDHH_ADMISIBLE_O_NO_STR');
var admONoVal = form.getField('INDDHH_ADMISIBLE_O_NO_STR').getValue();
var lblFinaliza = form.getField('lblFinalizarTmt');
var lblFinaliza2 = form.getField('lblFinalizarTmt2');
var finaliza = form.getField('INDDHH_FINALIZA_TRAMITE_STR');

var texto = 'Seleccione el check "Finalizar trámite" si se desea terminar definitivamente con el trabajo correspondiente a esta Consulta/Denuncia';
var texto2 = 'De lo contrario, Confirme y luego Libere la tarea, para finalizar su trabajo actual.';

if(hayErrores == '1'){ //No hay errores
  
  	err.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  	admONo.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
 
    lblFinaliza.setValue(texto);
    lblFinaliza2.setValue(texto2);
    finaliza.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  
    if(admONoVal == '1'){ //Admisible
        formAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
        formNoAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
        formDDHHVuln.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
    } else { 
      if(admONoVal == '2'){// No admisible
          formAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
          formNoAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);
        formDDHHVuln.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
      }
      else{
      	formAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
          formNoAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
        formDDHHVuln.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
      }
    }	
 
} else { 
    if(hayErrores == '2'){ //Si hay errores
      err.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
      admONo.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
      
      lblFinaliza.clearValue();
      lblFinaliza2.clearValue();
      finaliza.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
      
      formAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
      formNoAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
      formDDHHVuln.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  	}
  else{
    	err.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
      admONo.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
      
      lblFinaliza.clearValue();
      lblFinaliza2.clearValue();
      finaliza.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
      
      formAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
      formNoAdm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
      formDDHHVuln.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
  }
}























return true; // END
} // END
