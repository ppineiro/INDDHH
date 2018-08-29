
function fnc_1001_3811(evtSource) { 
	var formVer = ApiaFunctions.getForm('ACTUACIONES');
	if(formVer!=null){
		var ver = formVer.getField('EXP_VERSION_PROCESO_ACTUACIONES_2_STR');
		if(ver!=null && ver.getValue()!=null && ver.getValue()!='' && parseFloat(ver.getValue())<2){
			return true;
		}
	}
	var formAct = ApiaFunctions.getForm('FRM_DOC_FISICA');
	if(formAct!=null){
		var col = formAct.getField('EXP_AGREGAR_DOC_FISICA_STR');
		var fieldUEA = formAct.getField('EXP_UBICACION_EN_ACTUACION_STR');
		var gridAF = formAct.getField('GRD_ADJUNTOS_FISICOS');

		if(col.getValue()=="1"){
			fieldUEA.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
			gridAF.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);										

		}else if (col.getValue()=="2"){
			fieldUEA.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
			gridAF.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);	
		}else{
			//No estaba, pero no tendria que ocultar fieldUEA tambien?
			gridAF.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);
		}
	}
	return true; // END
} // END
