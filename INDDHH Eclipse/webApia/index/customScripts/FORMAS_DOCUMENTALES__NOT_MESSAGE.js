
function FORMAS_DOCUMENTALES__NOT_MESSAGE(evtSource, par_formName, par_forType) { 
	var index = evtSource.index;
	var form = ApiaFunctions.getForm(par_formName);
	var forType = par_forType;
	var attMSGName = 'PLAZO_MENSAJE';
	var attTipoName = 'PLAZO_TIPO_STR';

	var attMsg = form.getFieldColumn(attMSGName)[index];
	var attEvt = form.getFieldColumn(attTipoName)[index];

	var URL = getUrlApp() + "/expedientes/notificationMessage.jsp?forType="+forType+"&msg="+attMsg.getValue() + "&evt="+attEvt.getValue();
	var modal = ModalController.openWinModal(URL + TAB_ID_REQUEST, 495, 535, null, null, null, false, false);
	
	modal.setearTexto = function(texto){
		 if (texto!=null){
					attMsg.setValue(texto);
		  }
	}
	
	/*modal.onclose=function(){
		   doAfter(rets.returnValue);
	}*/
    
return true; // END
} // END
