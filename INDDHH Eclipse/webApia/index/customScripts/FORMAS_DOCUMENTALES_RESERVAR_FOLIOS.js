
function FORMAS_DOCUMENTALES_RESERVAR_FOLIOS(evtSource) { 
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
		i = form.getFieldColumn('EXP_EXP_RESERVACION_FOLIOS_STR').length -1;
	}
	
	var colAcompania = form.getFieldColumn('EXP_EXP_RESERVACION_FOLIOS_STR');
	if(colAcompania!=null){
		for(var i = 0; i < colAcompania.length; i++){

			var field = form.getFieldColumn('EXP_FOLIO_RESERVADO_NUM')[i];
			
			if(colAcompania[i].getValue() == "2"){
				field.setProperty(IProperty.PROPERTY_READONLY,false);
				field.setProperty(IProperty.PROPERTY_REQUIRED,true);					
			}else{
				field.setValue("0");
				field.setProperty(IProperty.PROPERTY_READONLY,true);
				field.setProperty(IProperty.PROPERTY_REQUIRED,false);										
			}
		}
	}
	
	/*
	if (i<0){
		var colAcompania = form.getFieldColumn('EXP_EXP_RESERVACION_FOLIOS_STR');
		if(colAcompania!=null){
			for(var i = 0; i < colAcompania.length; i++){

				var field = form.getFieldColumn('EXP_FOLIO_RESERVADO_NUM')[i];
				
				if(colAcompania[i].getValue() == "2"){
					field.setProperty(IProperty.PROPERTY_READONLY,false);
					field.setProperty(IProperty.PROPERTY_REQUIRED,true);					
				}else{
					field.setValue("0");
					field.setProperty(IProperty.PROPERTY_READONLY,true);
					field.setProperty(IProperty.PROPERTY_REQUIRED,false);										
				}
			}
		}

	}else{
		var acompania = form.getFieldColumn('EXP_EXP_RESERVACION_FOLIOS_STR')[i];

		if(acompania!=null){
			
			var field = form.getFieldColumn('EXP_FOLIO_RESERVADO_NUM')[i];
			
			if(acompania.getValue() == "2"){
				field.setProperty(IProperty.PROPERTY_READONLY,false);
				field.setProperty(IProperty.PROPERTY_REQUIRED,true);				
			}else{
				field.setValue("0");
				field.setProperty(IProperty.PROPERTY_READONLY,true);
				field.setProperty(IProperty.PROPERTY_REQUIRED,false);						
			}
		}
	}
	*/


return true; // END
} // END
