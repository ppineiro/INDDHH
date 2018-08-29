
function INDDHH_JS_GRID_DELETE_ALL_ROW(evtSource, par_nameFrm, par_nameGrid) { 

var myForm = ApiaFunctions.getEntityForm(par_nameFrm);
if(myForm != null){
	var myGrid = myForm.getField(par_nameGrid);
	myGrid.deleteGrid();   	
}




return true; // END
} // END
