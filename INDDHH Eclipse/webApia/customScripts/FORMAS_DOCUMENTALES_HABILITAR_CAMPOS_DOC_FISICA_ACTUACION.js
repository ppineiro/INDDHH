
function fnc_1001_3816(evtSource) { 

	/*var formVer = getForm('ACTUACIONES');
	if(formVer!=null){
		var ver = getField('ACTUACIONES','EXP_VERSION_PROCESO_ACTUACIONES_2_STR');
		if(ver!=null && ver.value!=null && ver.value!='' && parseFloat(ver.value)>=2){
			var formAct = getForm('FRM_DOC_FISICA');
			var formCar = getForm('CARATULA');
			if(formAct!=null && formCar!=null ){
				var col = getField('CARATULA','EXP_DOCUMENTO_FISICO_NUM');

				if(col.value==1){

					clearGridData('FRM_DOC_FISICA', 'GRD_ADJUNTOS_FISICOS');
					//clearGridRows('ACTUACIONES', 'GRD_ADJUNTOS_FISICOS');
					//alert('2');
					hideField('FRM_DOC_FISICA','EXP_UBICACION_EN_ACTUACION_STR');
					hideField('FRM_DOC_FISICA', 'GRD_ADJUNTOS_FISICOS');
					getField('FRM_DOC_FISICA','EXP_AGREGAR_DOC_FISICA_STR').value= 1;
					hideField('FRM_DOC_FISICA', 'EXP_AGREGAR_DOC_FISICA_STR');
					hideForm('FRM_DOC_FISICA');

				}else if (col.value==2){
					try{showForm('FRM_DOC_FISICA');}catch(e){}
					try{showField('FRM_DOC_FISICA','EXP_UBICACION_EN_ACTUACION_STR');}catch(e){}
					try{showField('FRM_DOC_FISICA', 'GRD_ADJUNTOS_FISICOS');}catch(e){}
					try{showField('FRM_DOC_FISICA', 'EXP_AGREGAR_DOC_FISICA_STR');}catch(e){}
				}else{
					clearGridData('FRM_DOC_FISICA', 'GRD_ADJUNTOS_FISICOS');
					//clearGridRows('ACTUACIONES', 'GRD_ADJUNTOS_FISICOS');
					hideField('FRM_DOC_FISICA','EXP_UBICACION_EN_ACTUACION_STR');
					hideField('FRM_DOC_FISICA', 'GRD_ADJUNTOS_FISICOS');
					getField('FRM_DOC_FISICA','EXP_AGREGAR_DOC_FISICA_STR').value= 1;
					hideField('FRM_DOC_FISICA', 'EXP_AGREGAR_DOC_FISICA_STR');
					hideForm('FRM_DOC_FISICA');
				}
			}

		}
	}*/
	return true; // END
} // END
