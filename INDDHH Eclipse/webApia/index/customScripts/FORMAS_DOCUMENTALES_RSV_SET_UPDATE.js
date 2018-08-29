
function FORMAS_DOCUMENTALES_RSV_SET_UPDATE(evtSource) { 
	var index = evtSource.index;
	var form = ApiaFunctions.getForm('FRM_RSV_MOD_RESERVA');
	var attName = 'RSV_NRO_EXP_ACTUALIZAR';
	form.getFieldColumn(attName)[index].setValue(true);
	
	return true; // END
} // END
