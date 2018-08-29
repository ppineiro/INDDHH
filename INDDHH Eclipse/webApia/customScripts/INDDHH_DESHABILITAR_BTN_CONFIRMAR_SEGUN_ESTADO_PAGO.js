
function INDDHH_DESHABILITAR_BTN_CONFIRMAR_SEGUN_ESTADO_PAGO(evtSource) { 
var formDatosPagosWeb = ApiaFunctions.getForm("TRM_DATOS_GW_ITC_PAGOS");

if(formDatosPagosWeb != null){
	var campoHabilitarBtnConfirmar = formDatosPagosWeb.getField("habilitarBtnConfirmar").getValue();
	//Si el pago no se realizó correctamente
	if(campoHabilitarBtnConfirmar != "true"){
	  //deshabilito el botón confirmar para que pueda volver a intentar pagar
	  ApiaFunctions.hideActionButton(ActionButton.BTN_CONFIRM);
	}
} else {
	//Para que el formulario de datos de pago sea nulo el pago tiene que estar en un estado que no permite confirmar 
	//ni volver a pagar. Puede ser para un estado pendiente, que se espera a que se compruebe que el cliente pagó
	ApiaFunctions.hideActionButton(ActionButton.BTN_CONFIRM);
}

//Esto seria para presionar automáticamente el botón confirmar
//setTimeout($('btnConf').fireEvent('click', new Event({ type: 'click',target: $('btnConf')})), 3000);



































return true; // END
} // END
