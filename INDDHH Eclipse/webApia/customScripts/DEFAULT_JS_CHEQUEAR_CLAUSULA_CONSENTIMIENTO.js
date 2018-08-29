
function DEFAULT_JS_CHEQUEAR_CLAUSULA_CONSENTIMIENTO(evtSource, par_nombFrm, par_nombAtt, par_esRadio) { 
debugger;

var myForm = ApiaFunctions.getForm(par_nombFrm);
var readOnly=myForm.getProperty(IProperty.PROPERTY_FORM_READONLY);
if (!isMonitor && readOnly != true) {
  try{
  if (btnAction){
      var field = myForm.getField(par_nombAtt);
      if (field.getValue()=="2"){
          if(par_esRadio =="true")
             showMsgError2(par_nombFrm, par_nombAtt, "¡No puede continuar con el trámite si no acepta los términos de la cláusula!",par_esRadio);
      else
          showMsgError(par_nombFrm, par_nombAtt, "¡No puede continuar con el trámite si no acepta los términos de la cláusula!");
          return false;
      }
  }
  }catch(err){
    var field = myForm.getField(par_nombAtt);
      if (field.getValue()=="2"){
          //showMsgError(par_nombFrm, par_nombAtt, "¡No puede continuar con el tramite si no acepta los terminos de la clausula!");
          //AGREGAR MENSAJE DE ERROR NORMAL
          return false;
      }
  }

}














return true; // END
} // END
