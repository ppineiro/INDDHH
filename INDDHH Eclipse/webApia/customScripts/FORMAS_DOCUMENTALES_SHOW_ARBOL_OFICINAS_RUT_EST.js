
function FORMAS_DOCUMENTALES_SHOW_ARBOL_OFICINAS_RUT_EST(evtSource) { 
	var sep1 = "º";
	var frmActual = ApiaFunctions.getForm("RUTA_ESTATICA_MNT");
	var URL = getUrlApp() + "/expedientes/arbolRutaEstatica/armar.jsp?";
	window.status = URL;		
	var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1050, 400, null, null, null, false, false);

	modal.setearDestino = function(sDestino){
		//var sDestino=this.returnValue;
		var i = evtSource.index;
	
		if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
			
			alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino válido.");
			frmActual.getFieldColumn('RUTEST_LISTA_OFICINAS_NOMB_STR')[i].setValue("");
			//getFieldByIndex(frmActual, "RUTEST_OFICINA_ES_ND_STR",i-1).value = "";
			frmActual.getFieldColumn('RUTEST_LISTA_OFICINAS_STR')[i].setValue("");
	
			//document.getElementById(frmActual + "RUTEST_OFICINA_DESTINO_PASE_STR").value = "";			
			//document.getElementById(frmActual + "RUTEST_OFICINA_DESTINO_NOMB_PASE_STR").value = "";			
			//document.getElementById(frmActual + "RUTEST_USUARIO_DESTINO_PASE_STR").value = "";
	
		}else{
		
			var vec = sDestino.split(sep1);	
			frmActual.getFieldColumn('RUTEST_LISTA_OFICINAS_NOMB_STR')[i].setValue(vec[1]);	
			//getFieldByIndex(frmActual, "RUTEST_OFICINA_ES_OFICINA_STR",i).value = true;
			frmActual.getFieldColumn('RUTEST_LISTA_OFICINAS_STR')[i].setValue(vec[0]);	
	
			//document.getElementById(frmActual + "RUTEST_OFICINA_DESTINO_PASE_STR").value = vec[0];			
			//document.getElementById(frmActual + "RUTEST_OFICINA_DESTINO_NOMB_PASE_STR").value = vec[1];			
			//document.getElementById(frmActual + "RUTEST_USUARIO_DESTINO_PASE_STR").value = vec[2];
	
		}
	}
		

	



	return true; // END




return true; // END
} // END
