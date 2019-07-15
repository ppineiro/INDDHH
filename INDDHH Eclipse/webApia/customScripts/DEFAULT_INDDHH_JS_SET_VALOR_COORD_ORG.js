
function DEFAULT_INDDHH_JS_SET_VALOR_COORD_ORG(evtSource) { 
var form = ApiaFunctions.getEntityForm('INDDHH_ES_ADMISIBLE');
if(form != null){
  var organismo = form.getField('INDDHH_ORGANISMO_COORDINAR_STR');
  var organismoVal = form.getField('INDDHH_ORGANISMO_COORDINAR_STR').getValue();
  
  var otroOrg = form.getField('INDDHH_OTRO_ORG_COORDINAR_STR').getValue();
  var fldOrgValor = form.getField('INDDHH_ORGANISMO_COORDINAR_VALOR_STR');
  
  if (organismoVal == '1') {
    fldOrgValor.setValue('Comisionado Parlamentario Penitenciario');
  } else {
    if (organismoVal == '2') {
      fldOrgValor.setValue('Defensoría de Vecinas y Vecinos de Montevideo');
    } else {
      if (organismoVal == '3') {
        fldOrgValor.setValue('Comisión Honoraria contra el Racismo, la Xenofobia y toda otra forma de Discriminación');
      } else {
        if (organismoVal == '4') {
          fldOrgValor.setValue(otroOrg);
        }
      }
    }
  }
}




return true; // END
} // END
