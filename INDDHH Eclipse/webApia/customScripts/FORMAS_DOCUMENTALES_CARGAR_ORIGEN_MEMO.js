
function fnc_1001_2034(evtSource) { 
	
	var frmActual = ApiaFunctions.getForm('MEMO_DATOS');
	
	//Nombre de usuario de origen
	frmActual.getFieldColumn('MEM_ORIGEN_STR')[0].setValue(lastModalReturn[2]);	
	//Nombre de origen
	frmActual.getFieldColumn('MEM_ORIGEN_STR')[1].setValue(lastModalReturn[3]);	
	//Login del usuario origen
	frmActual.getFieldColumn('MEM_USUARIO_CREADOR_STR')[0].setValue(lastModalReturn[1]);	
	//Oficina de origen	
	frmActual.getFieldColumn('MEM_ORIGEN_OFICINA_STR')[0].setValue(lastModalReturn[5]);	
	//Numero de oficina origen
	frmActual.getFieldColumn('MEM_ORIGEN_OFICINA_NUM')[0].setValue(lastModalReturn[6]);
	
return true; // END
} // END
