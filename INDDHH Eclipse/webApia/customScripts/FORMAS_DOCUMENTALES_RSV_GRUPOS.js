
function FORMAS_DOCUMENTALES_RSV_GRUPOS(evtSource) { 
var index = evtSource.index;
var form = ApiaFunctions.getForm('FRM_RSV_NRO_RESERVA');
var attName = 'RSV_NRO_EXP_PERM_GRUPOS';
	
var pools = form.getField(attName);

var URL = getUrlApp() + "/expedientes/notificationPools.jsp?pools="+pools.getValue() + TAB_ID_REQUEST;

var rets =  ModalController.openWinModal(URL, 600, 500, null, null, null, false, false);

rets.addEvent('confirm', function(rets) {
  if (rets!=null){
    var attPools = form.getField(attName);
    attPools.setValue(rets);
  }
});

return true; // END
} // END
