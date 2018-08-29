
function FORMAS_DOCUMENTALES_SHOW_ARBOL_MULTIPLE(evtSource) { 
	
	
	//var modal =  ModalController.openWinModal(getUrlApp() + "/expedientes/arbolDestinoMultiple/armar.jsp?" + TAB_ID_REQUEST, 710, 400, null, null, null, true, true);
	
	var URL = getUrlApp() + "/expedientes/arbolDestinoMultiple/armar.jsp?";
	window.status = URL;		
	var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 710, 400);			
	modal.setearDestino = function(sDestino) {				
		if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
			alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");
		}else{
			if (sDestino.length > 2){								
				var frmActual = ApiaFunctions.getForm("NODO_AREA_ALTA");
				frmActual.getField("ND_AREAS_TMP_STR").setValue(sDestino);
				
				var vecAreasSeleccionadas = sDestino.split("\u00ba");		
				//document.getElementById("AREAS_A_AGREGAR").innerHTML = "Se agregar�n las siguientes Areas: " + vecAreasSeleccionadas[2];
				frmActual.getField("AREAS_A_AGREGAR").setValue(obtenerMensajeMultilenguajeSegunCodigo('MSG_AREAS_A_AGREGAR_JS',currentLanguage) + " " + vecAreasSeleccionadas[2]);

				
				//frmActual.getField("DAR_ALTA_AREAS").setProperty(IProperty.PROPERTY_READONLY, false);
				//frmActual.getField("SELECCIONAR_AREAS").focus();		
				
				
				return true;
			}				
		}
	}			



return true; // END
} // END
