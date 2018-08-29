
function fnc_1001_4179(evtSource) { 

	//alert('va');

	var indice = evtSource.index;
	var form = ApiaFunctions.getForm('MANT_TIPO_TITULAR');
	var fieldPEEF = form.getFieldColumn('TT_PARAM_ENTRADA_ETIQUETA_FILTRO_STR')[indice];
	var fieldPEETC = form.getFieldColumn('TT_PARAM_ENTRADA_ES_TIPO_COMBO_STR')[indice];
	var fieldPEEFC = form.getFieldColumn('TT_PARAM_ENTRADA_ENT_FUENTE_COMBO_STR')[indice];
	
	//Si chequeo
	if (form.getFieldColumn('TT_PARAM_ENTRADA_OCULTAR_COMO_FILTRO_EN_CONSULTA_S')[indice].getValue()){
		
		fieldPEEF.setValue('');	
		fieldPEEF.setProperty(IProperty.PROPERTY_READONLY,true);
				
		fieldPEETC.setValue(false);
		fieldPEETC.setProperty(IProperty.PROPERTY_READONLY,true);
		
		fieldPEEFC.setValue('');
		fieldPEEFC.setProperty(IProperty.PROPERTY_READONLY,true);		

	}else{
		//Si deschequeo
		fieldPEEF.setProperty(IProperty.PROPERTY_READONLY,false);
		fieldPEETC.setProperty(IProperty.PROPERTY_READONLY,false);		
		//removeReadonlyByIndex(formName, 'TT_PARAM_ENTRADA_ENT_FUENTE_COMBO_STR', indice);
	}
	
	return true; // END
} // END
