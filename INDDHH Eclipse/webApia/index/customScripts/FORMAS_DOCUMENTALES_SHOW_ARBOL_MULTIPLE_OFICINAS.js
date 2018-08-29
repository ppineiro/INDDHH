
function fnc_1001_4082(evtSource) { 
	var modal =  ModalController.openWinModal(getUrlApp() + "/expedientes/adminUsuarios/armar.jsp?" + TAB_ID_REQUEST, 710, 400, null, null, null, true, true);
	
	modal.onclose=function(){
		var sDestino=this.returnValue;
		if (sDestino == '' || sDestino == null){
			alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino válido.");
		}else if(sDestino == 'cancel'){}		
		else{
			if (sDestino.length > 2){								
				var frmActual = ApiaFunctions.getForm("FRM_OFICINAS_USUARIO");
				frmActual.getField("ATT_OFICINAS_OCULTO_STR").setValue(sDestino);
				
				//Se clickea el botón que dispara la clase java
				//fireEvent(document.getElementById("BTN_" + frmActual + "_CARGAR_OFICINA"),"click");
				frmActual.getField("OCULTO").fireClickEvent();
				
				return true;
			}				
		}
	}
	
	return false;
	


return true; // END
return true; // END
} // END
