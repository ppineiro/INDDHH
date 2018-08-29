
function INDDHH_JS_GRID_DELETE_ROW(evtSource, par_nameFrm, par_nameGrid, par_nameAtt, par_valor) { 
debugger;
var myForm = ApiaFunctions.getEntityForm(par_nameFrm);
var myGrid = myForm.getField(par_nameGrid); 
//var index = myGrid.getSelectedIndexes(true);
var borrar = true; 
var i = evtSource.index; 

if (par_nameAtt != null && par_nameAtt != '') {
 var attValor = myGrid.getField(par_nameAtt, i).getValue();
 borrar = (attValor != par_valor);  
}

if (borrar) {
	myGrid.deleteRow(i);
	ajustarAnchoColumna();
} else {
  if (par_nameAtt != null && par_nameAtt != '') {
 	showMessage("No se puede eliminar la fila. Haga click en el checkbox 'Eliminar' para marcar el registro para eliminar"); 
  }
}







return true; // END
} // END
