
function INDDHH_JS_OCULTAR_BOTON_ANTERIOR(evtSource, par_form, par_steps) { 
var form="TRM_TITULO";
if (par_form != null) {
  form = par_form;
}
var att_steps="TRM_STEP_CANTIDAD_NUM";
if (par_steps != null) {
  att_steps = par_steps;
}

var steps = ApiaFunctions.getForm(form).getField(att_steps).getValue();
if (steps =="0") {
    ApiaFunctions.hideActionButton(ActionButton.BTN_PREV);
}
















return true; // END
} // END
