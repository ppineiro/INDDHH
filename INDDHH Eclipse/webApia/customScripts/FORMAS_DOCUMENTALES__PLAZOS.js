
function FORMAS_DOCUMENTALES__PLAZOS(evtSource, par_calId) { 
var calId = par_calId.getValue();

if (calId == null || calId == "") {
	alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_SELECCIONAR_CALENDARIO_JS',currentLanguage)); //alert("Debe seleccionar un calendario");
}else {
    var URL = getUrlApp() + "/programs/modals/calendarView.jsp?calendarId="+ calId.replace('.','');
  	//openModal(URL,600,500);
  	ModalController.openWinModal(URL, 600, 500, null, null, null, false, false);
}

// END - 20120407_PREVERSION -

return true; // END
} // END
