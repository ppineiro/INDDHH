
function FORMAS_DOCUMENTALES_CONFIRMAR_MODIF_ELE_FISICO(evtSource) { 
	var mensaje = obtenerMensajeMultilenguajeSegunCodigo('MSG_CAMBIO_ELE_DOC_FISICA_EXP',currentLanguage);
	var doRollback = !confirm(mensaje);
	if (doRollback) {
		if (evtSource.getValue() == "1"){
			evtSource.setValue("2");
		}else{
			if (evtSource.getValue() == "2"){
				evtSource.setValue("1");
			}
		}
		return false;
	}






return true; // END
} // END
