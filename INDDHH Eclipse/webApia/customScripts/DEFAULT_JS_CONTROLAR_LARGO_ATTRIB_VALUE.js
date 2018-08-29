
function DEFAULT_JS_CONTROLAR_LARGO_ATTRIB_VALUE(evtSource, par_form, par_attrib, par_tope) { 
var strValue = ApiaFunctions.getForm(par_form).getField(par_attrib).getValue();
var tope = par_tope;

if (strValue.length > tope) {
  ApiaFunctions.getForm(par_form).getField(par_attrib).clearValue();
  alert("El largo m�ximo del campo es " + tope);
}
return true; // END
} // END
