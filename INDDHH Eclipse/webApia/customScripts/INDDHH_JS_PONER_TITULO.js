
function INDDHH_JS_PONER_TITULO(evtSource, par_form, par_attNomb) { 
debugger;
var form = ApiaFunctions.getForm("TRM_TITULO");
if (par_form != null) {
 form = ApiaFunctions.getForm(par_form);
}
if (form != null){
 var title="";
 if (par_attNomb != null) {
    title = form.getField(par_attNomb).getValue();
 } else {
    title = form.getField("TRM_NOMBRE_STR").getValue();
 }  
 document.getElementById("titleTramite").innerHTML = title;
 
  var actual = form.getField("TRM_STEP_ACTUAL_NUM").getValue();
  var anterior = form.getField("TRM_STEP_ANTERIOR_NUM").getValue();
  
  if (actual != anterior ){
   
   setTimeout(function(){window.location = '#';}, 100);
   
  }
  
  if( ApiaFunctions.getCurrentTaskName() == "RESULTADO"){
   setTimeout(function(){window.location = '#';}, 100);
  }
  
  form.getField("TRM_STEP_ANTERIOR_NUM").setValue( form.getField("TRM_STEP_ACTUAL_NUM").getValue() );

}









return true; // END
} // END
