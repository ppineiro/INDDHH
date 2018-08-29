
function fnc_1001_1563(evtSource) { 
	
	var frmActual = ApiaFunctions.getForm('MEMO_DATOS_RESPUESTA');	
	//Nombre de usuario de destinatario
	frmActual.getFieldColumn('MEM_RESP_DESTINO_STR')[0].setValue(lastModalReturn[2]);			
	//Nombre de destinatario
	frmActual.getFieldColumn('MEM_RESP_DESTINO_STR')[1].setValue(lastModalReturn[3]);	
	//Oficina de destinatario		
	frmActual.getFieldColumn('MEM_RESP_DESTINO_OFICINA_STR')[0].setValue(lastModalReturn[5]);
	/*
	//Código para ver valores retornados
	var msg = "";

	for(i=0;i<lastModalReturn.length;i++)
	{
		msg = msg + "Valor " + i + ": " + lastModalReturn[i] + "\n";
		
	}
	alert(msg);
	*/

return true; // END
} // END
