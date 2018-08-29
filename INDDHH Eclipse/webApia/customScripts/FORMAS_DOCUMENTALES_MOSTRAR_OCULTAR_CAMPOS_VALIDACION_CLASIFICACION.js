function fnc_1001_4281(evtSource) { 
	
	var comboValidaClasificacion = evtSource.getValue();
	var form = ApiaFunctions.getForm('VALIDAR_CLASIFICACION');
	var campoMotivo = form.getField('EXP_MOTIVO_CLASIFICACION_STR'); //getFieldByIndex(formName, 'EXP_MOTIVO_CLASIFICACION_STR', 0);
	var btnModificar = form.getField('BTN_MODIFICAR_CLASIFICACION'); //getButton(formName, 'BTN_MODIFICAR_CLASIFICACION');
	var campoClaNueva = form.getField('EXP_CLASIFICACION_NUEVA_STR'); //getFieldByIndex(formName, 'EXP_CLASIFICACION_NUEVA_STR', 0);
	
	if (comboValidaClasificacion == "1"){
				
		campoMotivo.setProperty(IProperty.PROPERTY_REQUIRED, true);
		campoClaNueva.setProperty(IProperty.PROPERTY_REQUIRED, true);
		campoMotivo.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
		btnModificar.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);	
		campoClaNueva.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
		
	}else{
		
		campoMotivo.setProperty(IProperty.PROPERTY_REQUIRED, false);
		campoClaNueva.setProperty(IProperty.PROPERTY_REQUIRED, false);
		campoMotivo.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
		btnModificar.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
		campoClaNueva.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
	}
	
	
	return true; // END
} // END
