
function fnc_1001_2039(evtSource) { 
	
	var frmActual = ApiaFunctions.getForm('MEMO_DATOS');	
	if (!frmActual.getFieldColumn('MEM_SOLO_MANDAR_A_SECTOR_STR')[0].getValue()){
		//Nombre de usuario de destinatario
		frmActual.getFieldColumn('MEM_DESTINO_STR')[0].setValue(" ");		
		//Nombre de destinatario
		frmActual.getFieldColumn('MEM_DESTINO_STR')[1].setValue(" ");
		frmActual.getField('MEM_DESTINO_STR').setProperty(IProperty.PROPERTY_REQUIRED,false);		
	}
	else
	{
		frmActual.getField('MEM_DESTINO_STR').setProperty(IProperty.PROPERTY_REQUIRED,true);
	}

return true; // END
} // END
