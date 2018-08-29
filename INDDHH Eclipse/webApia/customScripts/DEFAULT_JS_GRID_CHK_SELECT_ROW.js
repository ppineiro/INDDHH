function DEFAULT_JS_GRID_CHK_SELECT_ROW(evtSource, par_nameFrm, par_nameGrid) { 
var myForm = ApiaFunctions.getEntityForm(par_nameFrm);
var myGrid = myForm.getField(par_nameGrid); 

var myField = myGrid.getField("URSEC_AUTR_USR_SELECCION");

var cant = 0;
var i = 0;
while (i < 50) {
	if (myGrid.getField("URSEC_AUTR_USR_SELECCION", i) ==null){
		break;
	}else{				
		if ("|" + myGrid.getField("URSEC_AUTR_USR_SELECCION", i).getValue() + "|" == "|true|"){
			cant++;
		}
	}    
	i++
}

if (cant == 0){
	//showMsgError(par_nameFrm, "URSEC_AUTR_USR_SELECCION", "Error: debe elegir un registro.");
	showMsgConfirm("warning", "Error: debe elegir un registro.", "");	
	return false;
}

if (cant >= 2){
	//showMsgError(par_nameFrm, "URSEC_AUTR_USR_SELECCION", "Error: Solo puede elegir un registro.");
	//alert("Error: Solo puede elegir un registro.");
	showMsgConfirm("warning", "Solo puede elegir un registro.", "");
	return false;
}

return true; // END
} // END
