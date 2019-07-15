
function DEFAULT_JS_SET_RO_CAMPOS_SEGUN_VALORES_2_COMBOS(evtSource, par_nomForm, par_nomCombo, par_nomCombo2, par_nomAtts, par_valor1, par_valor2) { 
var form = ApiaFunctions.getEntityForm(par_nomForm);
var val1erCombo = form.getField(par_nomCombo).getValue();
var val12doCombo = form.getField(par_nomCombo2).getValue();
var listaNomAtts = par_nomAtts.split(";");
var valor1 = par_valor1;
var valor2 = par_valor2;

if (val1erCombo.toString() == valor1 && val12doCombo.toString() == valor2) {
  //si el valor de los combos son los valores que quiero
  for (let i = 0; i < listaNomAtts.length; i++) {
    //set RO en todos los fields que puse
    var fldAttASetearRO = form.getField(listaNomAtts[i]);
    fldAttASetearRO.setProperty(IProperty.PROPERTY_READONLY, true);
  }
} else {
  //sino
  for (let i = 0; i < listaNomAtts.length; i++) {
    //sacar RO en todos los fields que puse
    var fldAttASetearRO = form.getField(listaNomAtts[i]);
    fldAttASetearRO.setProperty(IProperty.PROPERTY_READONLY, false);
  }
}


return true; // END
} // END
