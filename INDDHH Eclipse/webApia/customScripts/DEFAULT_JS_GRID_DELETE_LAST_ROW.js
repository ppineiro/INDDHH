
function DEFAULT_JS_GRID_DELETE_LAST_ROW(evtSource, par_nameFrm, par_nameGrid, par_row) { 
var myForm = ApiaFunctions.getEntityForm(par_nameFrm);
var myGrid = myForm.getField(par_nameGrid); 
var row = myForm.getField(par_row); 

var nroFila = row.getValue();

nrofila = parseInt(nroFila);
nrofila--;

if(nroFila!=null && nroFila >0)

{

myGrid.deleteRow(nrofila);

ajustarAnchoColumna();
 row.clearValue();
}

















return true; // END
} // END
