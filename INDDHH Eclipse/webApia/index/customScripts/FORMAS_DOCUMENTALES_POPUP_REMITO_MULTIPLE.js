
function fnc_1001_4301(evtSource) { 
	var form = ApiaFunctions.getForm('FRM_EMITIR_REMITO');
	var strPrint = form.getField('TMP_IMP_REMITO_STR').getValue();
	
	if(strPrint == "SI"){
		window.open(getUrlApp() + "/expedientes/ImprimirRemito.jsp?" + TAB_ID_REQUEST);
	}
	form.getField('TMP_IMP_REMITO_STR').setValue('NO');	

	return true; // END
} // END
