
function INDDHH_DESHABILITAR_BTN_NEXT_SEGUN_ESTADO_PAGO(evtSource) { 
var formDatosPagos = ApiaFunctions.getForm("TRM_DATOS_GW_ITC_PAGOS");

if(formDatosPagos != null){
	var campoHabilitarBtnConfirmar = formDatosPagos.getField("habilitarBtnConfirmar").getValue();
	if(campoHabilitarBtnConfirmar == "wait"){
	  //deshabilito el botón next para que pueda volver a intentar pagar
	  ApiaFunctions.hideActionButton(ActionButton.BTN_NEXT);
	}
}





return true; // END
} // END
