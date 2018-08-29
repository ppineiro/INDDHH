
function fnc_1001_1562(evtSource) { 
	
	var frmActual = ApiaFunctions.getForm('MEMO_DATOS');
	//mandarSoloASubAreas = getFieldByIndex(frmActual, "MEM_SOLO_MANDAR_A_SECTOR_STR",0).checked;
		
	if (frmActual.getFieldColumn('MEM_SOLO_MANDAR_A_SECTOR_STR')[0].getValue()){
		//Nombre de usuario de destinatario		
		frmActual.getFieldColumn('MEM_DESTINO_STR')[0].setValue(lastModalReturn[2]);
		//Nombre de destinatario		
		frmActual.getFieldColumn('MEM_DESTINO_STR')[1].setValue(lastModalReturn[3]);				
		frmActual.getField('MEM_DESTINO_STR').setProperty(IProperty.PROPERTY_REQUIRED, true);		
	}
	else
	{
		//Nombre de usuario de destinatario
		frmActual.getFieldColumn('MEM_DESTINO_STR')[0].setValue(" ");		
		//Nombre de destinatario		
		frmActual.getFieldColumn('MEM_DESTINO_STR')[1].setValue(" ");
		frmActual.getField('MEM_DESTINO_STR').setProperty(IProperty.PROPERTY_REQUIRED, false);						
	}
	//Oficina de destinatario	
	frmActual.getFieldColumn('MEM_DESTINO_OFICINA_STR')[0].setValue(lastModalReturn[5]);
	frmActual.getFieldColumn('MEM_DESTINO_OFICINA_NUM')[0].setValue(lastModalReturn[6]);	

return true; // END
} // END
