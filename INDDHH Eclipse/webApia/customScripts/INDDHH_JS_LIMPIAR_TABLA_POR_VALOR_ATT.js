
function INDDHH_JS_LIMPIAR_TABLA_POR_VALOR_ATT(evtSource, par_gridName, par_formName, par_attVal, par_value, par_formGridName) { 
if (par_value = null) {
  par_value = "";
}
if (ApiaFunctions.getForm(par_formName).getField(par_attVal).getValue() == par_value) {
	ApiaFunctions.getForm(par_formGridName).getField(par_gridName).deleteGrid();
}


return true; // END
} // END
