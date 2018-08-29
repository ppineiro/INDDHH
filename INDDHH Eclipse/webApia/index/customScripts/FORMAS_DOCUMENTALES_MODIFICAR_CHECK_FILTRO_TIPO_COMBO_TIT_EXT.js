
function fnc_1001_4180(evtSource) { 

	//alert('voy');
	var indice = evtSource.index;
	var form = ApiaFunctions.getForm('MANT_TIPO_TITULAR');
	var field = form.getFieldColumn("TT_PARAM_ENTRADA_ENT_FUENTE_COMBO_STR")[indice];
	//Si chequeo
	if (form.getFieldColumn("TT_PARAM_ENTRADA_ES_TIPO_COMBO_STR")[indice]).getValue()){				
		field.setProperty(IProperty.PROPERTY_READONLY,false);		
	}else{
		//Si deschequeo
		form.getFieldColumn("TT_PARAM_ENTRADA_ES_TIPO_COMBO_STR")[indice]).setValue('');
		field.setProperty(IProperty.PROPERTY_READONLY,true);
	}

return true; // END
} // END
