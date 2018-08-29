
function fnc_1001_4166(evtSource) { 
	
	var form = ApiaFunctions.getForm('CARATULA');	
	var attModoRecFolios = form.getField('EXP_CHECK_ADJUNTAR_ARCHIVOS_REC_OE_STR');
	var fieldNPOE = form.getField('EXP_NRO_PAGINA_ORG_EXT_STR');
	var fieldDFOE = form.getField('EXP_DOC_FOLIOS_ORGANISMO_EXTERNO_STR');
	
	if (attModoRecFolios != null && attModoRecFolios.getValue() == 'adjuntarfolios' ){
		fieldNPOE.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
		fieldDFOE.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);				
		fieldNPOE.setValue('');
	
	}else if (attModoRecFolios != null && attModoRecFolios.getValue() == 'cantidadfolios' ){
	
		fieldNPOE.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);		
		fieldDFOE.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			
	}else{
		
		fieldNPOE.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
		fieldDFOE.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);		
	}
return true; // END
} // END
