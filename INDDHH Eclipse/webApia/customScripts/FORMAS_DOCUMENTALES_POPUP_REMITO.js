
function fnc_1001_2112(evtSource) { 
	var form = ApiaFunctions.getForm('FIRMA');
	var strPrint = form.getField('TMP_IMP_REMITO_STR').getValue();
	
	if(strPrint == "SI"){
		window.open(getUrlApp() + "/expedientes/ImprimirRemito.jsp?" + TAB_ID_REQUEST);
	}
	return true; // END

return true; // END
} // END
