
function INDDHH_JS_GRID_ADD_N_ROWS(evtSource, par_nameFrm, par_nameGrid, par_cantFilas) { 
var myForm = ApiaFunctions.getEntityForm(par_nameFrm);
var myGrid = myForm.getField(par_nameGrid); 
var cant= par_cantFilas;
var cols = myGrid.getAllColumns();
try{
  if(cols[0].length<cant) {
	for (i = 0; i < cant; i++) { 
      myGrid.addRow();
      ajustarAnchoColumna();
	}	  	
  }
}catch(err){
 	myGrid.addRow();
	ajustarAnchoColumna();
}













return true; // END
} // END
