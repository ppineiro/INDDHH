function INDDHH_JS_GRID_CHK_REQUIRED(evtSource, par_nameFrm, par_nameGrid) { 
	
	var myForm = ApiaFunctions.getEntityForm(par_nameFrm);
	var myGrid = myForm.getField(par_nameGrid);
	
	var i = evtSource.index;
	objVolverFoco = myForm;			
	
	var vals = 'Columna que faltan datos: ';
	
	for(var j = 0; j < 50; j++) {	
		var selItems = null;
		try{
			selItems = myGrid.getRow(j);
		}catch(err){
			return true;
		}
		
		if(selItems != null){
			//var selItems = myGrid.getRow(j);	
			var noPermitirNuevaFila = false;
			for(var i = 0; i < selItems.length; i++) { 
				var col = selItems[i];
				
				if (i==0){
					if (col.fldType == "image"){			
						//objVolverFoco = col;
					}
				}
				
				if (col.fldType == "select" || col.fldType == "input"){
					if (col.getProperty(IProperty.PROPERTY_REQUIRED)){
						if (col.getValue()==""){
							noPermitirNuevaFila = true;
							//vals += col.getValue() + ' ';
							vals += i + ' ';
						}
					}		
				}		 			
			}
			if (noPermitirNuevaFila){			
				showMsgConfirm("warning", "Faltan campos requeridos!", "setFocoObj");
				return false;
			}
		}
	}
	
return true; // END
} // END
