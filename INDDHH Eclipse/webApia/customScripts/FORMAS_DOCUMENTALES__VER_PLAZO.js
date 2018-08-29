
function FORMAS_DOCUMENTALES__VER_PLAZO(evtSource, par_indxId, par_tipoNum, par_for) {
	
if (par_indxId.getValue() == ""){
    return true;
}else {
      if (par_indxId.getValue() == null || par_indxId.getValue() == "0") {
    	  alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_SELECCIONAR_PLAZO_JS',currentLanguage)); //alert("Debe seleccionar un plazo");
      }else {
    	  
    	  var URL = getUrlApp() + "/expedientes/plazoView.jsp?indxId="+par_indxId.getValue()+"&tipoNum="+par_tipoNum.getValue()+"&for="+par_for + TAB_ID_REQUEST;	
    	  modal =  ModalController.openWinModal(URL, 600, 300, null, null, null, true, false);
    	  
     }	
}



return true; // END
} // END
