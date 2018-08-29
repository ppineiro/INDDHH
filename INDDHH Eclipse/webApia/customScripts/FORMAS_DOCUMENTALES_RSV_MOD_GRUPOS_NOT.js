
function FORMAS_DOCUMENTALES_RSV_MOD_GRUPOS_NOT(evtSource) { 
		
	var index = evtSource.index;
	var form = ApiaFunctions.getForm('FRM_RSV_MOD_RESERVA');
	var attName = 'RSV_NRO_EXP_NOT_GRUPOS';
	var pools = form.getFieldColumn(attName)[index];
	var attPoMail = 'RSV_NRO_EXP_NOT_POR_MAIL';
	var attPorMsg = 'RSV_NRO_EXP_NOT_POR_MSG';

	var porMail = form.getFieldColumn(attPoMail)[index].getValue();
	var porMsg = form.getFieldColumn(attPorMsg)[index].getValue();
	if (!porMail && !porMsg){
		return;
	}
	
	var url = getUrlApp() + "/expedientes/notificationPools.jsp?pools=" + pools.getValue() + TAB_ID_REQUEST;		

	var rets = ModalController.openWinModal(url , 600, 500 , null , null , null , false , false);
	rets.addEvent('confirm', function(rets) {
		  if (rets!=null){
		    var attPools = form.getFieldColumn(attName)[index];
		    attPools.setValue(rets);
		  }
	});

return true; // END
} // END
