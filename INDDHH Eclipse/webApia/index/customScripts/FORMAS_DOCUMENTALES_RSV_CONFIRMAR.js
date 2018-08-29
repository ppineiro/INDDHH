
function FORMAS_DOCUMENTALES_RSV_CONFIRMAR(evtSource) { 
	var cantNums = 'RSV_NRO_EXP_CANT_NUMEROS';
	var form = ApiaFunctions.getForm('FRM_RSV_NRO_RESERVA');
	var attCantNums = form.getField(cantNums);
	
	if(attCantNums.getValue() == '' || isNaN(attCantNums.getValue())){
	   	//alert('La cantidad de n�meros a reservar debe ser un valor n�merico.');
		alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_CANTIDAD_RESERVAS_VALOR_NUMERICO_JS',currentLanguage));
	    return false;
	}
	
	//if (!confirm('�Realmente desea reservar ' + attCantNums.value + ' n�meros?')) return false;
	if (!confirm(obtenerMensajeMultilenguajeSegunCodigo('MSG_CONFIRMAR_RESERVA_NUMEROS_JS',currentLanguage)
	    .replace("<CANT_NUM_RESERVAR>",attCantNums.getValue()))){
	  return false;
	}
	
	return true; // END
} // END
