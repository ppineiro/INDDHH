
function fnc_1001_4145(evtSource) { 
	var modal =  ModalController.openWinModal(getUrlApp() + "/expedientes/arbolDestinoMultiple/armar.jsp?" + TAB_ID_REQUEST, 710, 400, null, null, null, true, true);

	modal.onclose=function(){
		var sDestino=this.returnValue;
		if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
			alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino válido.");
		}else{
			if (sDestino.length > 2){								
				var frmActual = ApiaFunctions.getForm("UNIDAD_ORGANIZACIONAL_ALTA");
				frmActual.getField("UO_TMP_STR").setValue(sDestino);
				
				var vecAreasSeleccionadas = sDestino.split("º");		
				frmActual.getField("UO_AGREGAR_STR").setValue("Se agregarán las siguientes UOs: " + vecAreasSeleccionadas[2]);
				//document.getElementById("UO_A_AGREGAR").innerHTML = obtenerMensajeMultilenguajeSegunCodigo("MSG_UOS_A_AGREGAR_JS",currentLanguage) + " " + vecAreasSeleccionadas[2];

				
				//document.getElementById("BTN_NODO_AREA_ALTA_DAR_ALTA_AREAS").disabled = false;
				//document.getElementById("BTN_NODO_AREA_ALTA_SELECCIONAR_AREAS").focus();		
				
				
				return true;
			}	
else{alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); }			
		}
	}	
	return false;

return true; // END
} // END
