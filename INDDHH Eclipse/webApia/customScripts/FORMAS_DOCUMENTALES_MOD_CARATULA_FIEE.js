
function FORMAS_DOCUMENTALES_MOD_CARATULA_FIEE(evtSource) { 
	var caratula	= ApiaFunctions.getForm('CARATULA_EMBEBIDA');
	var nroexp		= caratula.getField("EXP_NRO_EXPEDIENTE_STR").getValue();

	
	//var URL = getUrlApp() + "/templates/modalCambioCaratulaFIEE.jsp?";
	//window.status = URL;
	
	//var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 500, 186, null, null, true, false, false);	
	//modal.addEvent('confirm', function(datos) {
	var action = 4;//datos.split(",")[0];
	var envId = 1001;//datos.split(",")[1];
		
	if(action != "vacio"){
		var URL = getUrlApp() + "/page/externalAccess/open.jsp?logFromSession=true&onFinish=2&env=" + envId + "&type=P&entCode=3029&proCode=3282&eatt_STR_EXP_TIPO_CAMBIO_CARATULA_STR=" + action + "&onFinish=100&eatt_STR_EXP_NRO_EXPEDIENTE_STR=" + nroexp + TAB_ID_REQUEST;
		var obj = frameElement;
		obj.src = URL;
	}
		
	//});
return true; // END
} // END
