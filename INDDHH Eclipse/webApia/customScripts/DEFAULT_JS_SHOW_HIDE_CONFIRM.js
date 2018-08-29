
function DEFAULT_JS_SHOW_HIDE_CONFIRM(evtSource, par_nomAtt, par_valor, par_form) { 
var form = ApiaFunctions.getForm(par_form);
var field_combo_evaluar = form.getField(par_nomAtt);
var valor = par_valor;
var selectedtValueValidacion = field_combo_evaluar.getValue();

if(selectedtValueValidacion != valor) {
	ApiaFunctions.hideActionButton(ActionButton.BTN_CONFIRM);
} else {
  	ApiaFunctions.showActionButton(ActionButton.BTN_CONFIRM);
}






return true; // END
} // END
