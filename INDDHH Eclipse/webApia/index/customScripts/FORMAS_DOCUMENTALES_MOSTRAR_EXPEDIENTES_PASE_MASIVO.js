
function fnc_1001_4299(evtSource, par_nombFormulario, par_nombCampo) { 
var vIndex = evtSource.index; 
var form = ApiaFunctions.getForm(par_nombFormulario);
var strNroPM = form.getFieldColumn(par_nombCampo)[vIndex].getValue();
	if(strNroPM != ""){
       	var sAux =  ModalController.openWinModal(getUrlApp() + "/expedientes/emitirRemito/mostrarExpedientesPaseMasivo.jsp?NroPaseMasivo=" + strNroPM + TAB_ID_REQUEST, 1000, 500, null, null, null, true, true);
	}
return true; // END
} // END
