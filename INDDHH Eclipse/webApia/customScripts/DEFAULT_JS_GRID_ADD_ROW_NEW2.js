
function DEFAULT_JS_GRID_ADD_ROW_NEW2(evtSource, par_par_nameFrm, par_par_nameGrid, par_par_maximoFilas) { 
var myForm = ApiaFunctions.getEntityForm(par_par_nameFrm);
var myGrid = myForm.getField(par_par_nameGrid); 
var max= par_par_maximoFilas;

var cols = myGrid.getAllColumns();
var cantFilas = cols[0].length;
var cantCols = cols.length;
var ultFila = (cantFilas)-1;


try{
  	if(cantFilas != 0){
		for(var i = 0 ; i < cantCols; i++){
			if(cols[i][ultFila].fldType == "select" || cols[i][ultFila].fldType == "input"){
				if(cols[i][ultFila].getProperty(IProperty.PROPERTY_REQUIRED) && (cols[i][ultFila].getValue() == null || cols[i][ultFila].getValue() == "")){
              		showMsgConfirm("warning", "Faltan campos requeridos!", "setFocoObj");
					return false;
                }
        	}
		}
          
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
    }else{
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
    }
}catch(err){
 	myGrid.addRow();
	ajustarAnchoColumna();
}



return true; // END
} // END
