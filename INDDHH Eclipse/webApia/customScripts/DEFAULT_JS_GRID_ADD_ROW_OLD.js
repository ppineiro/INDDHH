
function DEFAULT_JS_GRID_ADD_ROW_OLD(evtSource, par_nameFrm, par_nameGrid, par_maximoFilas) { 
	var myForm = ApiaFunctions.getEntityForm(par_nameFrm);
	var myGrid = myForm.getField(par_nameGrid); 
	var max= par_maximoFilas;
	var cols = myGrid.getAllColumns();
	
try{
	var boton = myForm.getField("BTN_AGREGAR_FILA");

    if((max == null) ||  (cols[0].length < max)){
  		myGrid.addRow();
		ajustarAnchoColumna();
  	
      	var filas = cols[0].length;
  		if((max != null) && (filas+1 == max)){
  			
 	  		boton.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
  		}
    }else{
		myGrid.addRow();
		ajustarAnchoColumna();
    }
}catch(err){
 	myGrid.addRow();
	ajustarAnchoColumna();
}


return true; // END
} // END
