
function FORMAS_DOCUMENTALES_SHOW_ARBOL_MULTIPLE_USUARIOS(evtSource) { 
	var frmActual = ApiaFunctions.getForm("DEFINIR_NOTIFICACION");
	
	/*
	alert(document.getElementById(frmActual + "NOT_OPCION_PASE_STR").value);	
	if (document.getElementById(frmActual + "NOT_TIPO_DESTINATARIO_ENUM").value == ""){
		return false;
	}
	if (document.getElementById(frmActual + "INDICE_HISTORIA").value != ""){
		return false;
	}
	*/
	
	if (frmActual.getField("NOT_OPCION_PASE_STR").getValue() == "INTERNO") {
		var modal =  ModalController.openWinModal(getUrlApp()  + "/expedientes/arbolDestinoMultipleConUsuarios/armar.jsp?" + TAB_ID_REQUEST, 1050, 400, null, null, null, true, true);

		modal.onclose=function(){
			var sDestino=this.returnValue;
			if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
				alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino válido.");
			}else{			
				//alert("El destino es " + sDestino);				
				frmActual.getField("INDICE_HISTORIA").setValue("");
				frmActual.getField("NOT_DESTINATARIO_STR").setValue(sDestino);
				frmActual.getField("NOT_OPCION_PASE_STR").setValue("");	
				frmActual.getField("ELEGIR_DESTINO").fireClickEvent();		
				return true;					
			}
		}
	}
	return false;
	
	



return true; // END
} // END
