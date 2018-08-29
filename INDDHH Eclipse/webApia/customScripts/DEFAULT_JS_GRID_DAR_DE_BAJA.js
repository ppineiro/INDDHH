
function DEFAULT_JS_GRID_DAR_DE_BAJA(evtSource, par_nameFrm, par_nameGrid, par_nameAtt, par_valor, par_attSet) {  
var i = evtSource.index; 
var myForm = ApiaFunctions.getEntityForm(par_nameFrm);
var myGrid = myForm.getField(par_nameGrid); 
var attSet = myGrid.getField(par_attSet, i);
var setBaja = true; 

var attSet = myGrid.getField(par_attSet, i);
if (par_nameAtt != null && par_nameAtt != '') {
 var attValor = myGrid.getField(par_nameAtt, i).getValue();
 setBaja = (attValor != null && attValor != '' && attValor != par_valor);  
}

if (!setBaja) {
  if (par_nameAtt != null && par_nameAtt != '') {
    attSet.setValue("");
 	showMessage("para eliminar la fila debe hacer click sobre la cruz roja en la columna 'Eliminar fila'"); 
  }
}




return true; // END
} // END
