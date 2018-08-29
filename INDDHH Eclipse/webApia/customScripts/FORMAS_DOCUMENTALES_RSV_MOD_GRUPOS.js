
function FORMAS_DOCUMENTALES_RSV_MOD_GRUPOS(evtSource) { 
	
	var index = evtSource.index;
	var form = ApiaFunctions.getForm('FRM_RSV_MOD_RESERVA');
	var attName = 'RSV_NRO_EXP_PERM_GRUPOS';
	var attTodos = 'RSV_NRO_EXP_PERM_TODOS';

	var pools = form.getFieldColumn(attName)[index];
	var todos = form.getFieldColumn(attTodos)[index].getValue();	

	if (todos) {
		return;
	}

	if ("Todos" == pools.getValue()) {
		pools.setValue("");
	}
	
	var url = getUrlApp() + "/expedientes/notificationPools.jsp?pools=" + pools.getValue() + TAB_ID_REQUEST;
	
	var rets = ModalController.openWinModal(url , 600 , 500 , null , null , null , false , false);
	rets.addEvent('confirm', function(rets) {
		  if (rets!=null){
		    var attPools = form.getFieldColumn(attName)[index];
		    attPools.setValue(rets);
		  }
	}.bind(this));

return true; // END
} // END
