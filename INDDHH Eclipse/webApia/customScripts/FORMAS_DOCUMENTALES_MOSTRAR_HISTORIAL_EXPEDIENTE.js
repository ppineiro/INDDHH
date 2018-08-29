
function fnc_1001_1266(evtSource, par_nombFormulario, par_nombCampo) { 
	var vIndex = evtSource.index; 
	var form = ApiaFunctions.getForm(par_nombFormulario);
	var strNroExp = form.getFieldColumn(par_nombCampo)[vIndex].getValue();
	if(strNroExp != ""){
       	var sAux =  ModalController.openWinModal(getUrlApp() + "/expedientes/HistorialActuaciones/historialActuaciones.jsp?NroExp=" + strNroExp + TAB_ID_REQUEST, 1000, 505, null, null, null, false, false);
       	sAux.setConfirmLabel('Imprimir');
	}

return true; // END
} // END
