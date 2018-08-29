
function fnc_1001_4168(evtSource) { 
	var myForm = ApiaFunctions.getForm('CARATULA');
	var URL = getUrlApp() + "/expedientes/arbolOrganismoExternoRecepcion/armar.jsp?";
	window.status = URL;				
	var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 850, 500);

	modal.setearDestino = function(sDestino) {	
		try{
			if (sDestino == 'undefined' ||sDestino == 'cancel' || sDestino == '' || sDestino == null){
				alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_NO_ELIGIO_OE_ORIGEN',currentLanguage));
				myForm.getField('EXP_OOEE_ORIGEN_EXP_STR').setValue('');		
			}
			else{					
				myForm.getField('EXP_OOEE_ORIGEN_EXP_STR').setValue(sDestino);			
			}
		} catch(e){
			alert(e);
		}
	}
	return true; // END
} // END
