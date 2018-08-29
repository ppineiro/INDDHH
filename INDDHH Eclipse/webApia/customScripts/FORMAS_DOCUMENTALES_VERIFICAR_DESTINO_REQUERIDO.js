
function fnc_1001_2040(evtSource) { 
	var frmActual = ApiaFunctions.getForm('MEMO_DATOS');
	var mandarSoloASubAreas = frmActual.getFieldColumn('MEM_SOLO_MANDAR_A_SECTOR_STR')[0]).getValue();
	var destinoVacio = frmActual.getFieldColumn('MEM_DESTINO_STR')[0].getValue();
	
	if (mandarSoloASubAreas){
		if (destinoVacio == " "){
			alert("El campo \"Para\" no puede estar vacio.");
			return false;
		}
	}
	

return true; // END
} // END
