
function fnc_1001_2236(evtSource) { 
	var form = ApiaFunctions.getForm('CARATULA');
	var strValor = form.getField('EXP_GENERAR_CARATULA_STR').getValue();
	
	if(strValor == ""){
		form.getField('EXP_GENERAR_CARATULA_STR').setValue('S');		
	}else{
		form.getField('EXP_GENERAR_CARATULA_STR').setValue('');
	}
	
	return true; // END


return true; // END
} // END
