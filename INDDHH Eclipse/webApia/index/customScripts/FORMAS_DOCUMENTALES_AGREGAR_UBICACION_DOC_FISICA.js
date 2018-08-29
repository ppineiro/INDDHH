
function FORMAS_DOCUMENTALES_AGREGAR_UBICACION_DOC_FISICA(evtSource) { 
	var i = evtSource.index;
	var form = ApiaFunctions.getForm('FRM_DOC_FISICA');
	var formVer = ApiaFunctions.getForm('ACTUACIONES');

	if(formVer!=null){		
		var ver = formVer.getField('EXP_VERSION_PROCESO_ACTUACIONES_2_STR');
		if(!(ver!=null && ver.getValue()!=null && ver.getValue()!='' && parseFloat(ver.getValue())>=2)){
			return 0;
		}
			
	}
	
	if (i == undefined || i == null){
		i = form.getFieldColumn('EXP_ACOMPANIA_EXPEDIENTE_STR').length -1;
	}

	var colAcompania = form.getFieldColumn('EXP_ACOMPANIA_EXPEDIENTE_STR');	
	if(colAcompania!=null){
		for(var i = 0; i < colAcompania.length; i++){
			var field = form.getFieldColumn('EXP_EXP_MOTIVO_NO_ACOMPANIA_STR')[i];
			if(colAcompania[i].getValue()  == 1){
				if(field.getValue() == '-'){
					field.setValue('');
				}										
				field.setProperty(IProperty.PROPERTY_READONLY,false);
				field.setProperty(IProperty.PROPERTY_REQUIRED,true);					
				
			}else{					
				field.setValue('-');
				field.setProperty(IProperty.PROPERTY_READONLY,true);
				field.setProperty(IProperty.PROPERTY_REQUIRED,false);					
			}
		}
	}
	
	/*
	if (i<0){
		var colAcompania = form.getFieldColumn('EXP_ACOMPANIA_EXPEDIENTE_STR');
		
		if(colAcompania!=null){
			for(var i = 0; i < colAcompania.length; i++){
				var field = form.getFieldColumn('EXP_EXP_MOTIVO_NO_ACOMPANIA_STR')[i];
				if(colAcompania[i].getValue()  == 1){
					if(field.getValue() == '-'){
						field.setValue('');
					}										
					field.setProperty(IProperty.PROPERTY_READONLY,false);
					field.setProperty(IProperty.PROPERTY_REQUIRED,true);					
					
				}else{					
					field.setValue('-');
					field.setProperty(IProperty.PROPERTY_READONLY,true);
					field.setProperty(IProperty.PROPERTY_REQUIRED,false);					
				}
			}
		}

	}else{		
		var acompania = form.getFieldColumn('EXP_ACOMPANIA_EXPEDIENTE_STR')[i];
				
		if(acompania!=null){
				var field = form.getFieldColumn('EXP_EXP_MOTIVO_NO_ACOMPANIA_STR')[i];
				if(acompania.getValue() == 1){
					if(field.getValue() == '-'){
						field.setValue('');					
					}
					field.setProperty(IProperty.PROPERTY_READONLY,false);	
					field.setProperty(IProperty.PROPERTY_REQUIRED,true);													
	
				}else{				
					field.setValue('-');
					field.setProperty(IProperty.PROPERTY_READONLY,true);
					field.setProperty(IProperty.PROPERTY_REQUIRED,false);				
				}			
		}

	}		
	*/
	
	return true; // END

return true; // END
} // END
