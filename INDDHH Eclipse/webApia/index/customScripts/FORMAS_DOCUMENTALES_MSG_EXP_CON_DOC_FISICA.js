
function fnc_1001_4122(evtSource) { 
	var form = ApiaFunctions.getForm('OFA_RECIBIR_FIEE');
	var valueAtt = form.getField('EXP_HIS_ACTUACION_DOC_FISICO_STR').getValue();	
	if (valueAtt == 'Si'){
		alert('El expediente que está importando tiene documentación física asociada.');
	}
return true; // END
} // END
