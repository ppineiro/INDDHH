
function DEFAULT_PRESIONAR_BOTON_CONFIRMAR_PAGO(evtSource) { 
presionarBtnConfirmarPago.delay(0.1);
	return true; // END
}

	function presionarBtnConfirmarPago() {
  		var formDatosPagosGwItc = ApiaFunctions.getForm("TRM_DATOS_GW_ITC_PAGOS");
		var habilita = formDatosPagosGwItc.getField("habilitarBtnConfirmar").getValue();
		var estadoPago = ApiaFunctions.getForm("TRM_REGISTRAR_PAGO_GW_ITC").getField("estadoPago").getValue();
		if(habilita == 'true'){
			divBtnSiguiente = $("btnConf");
			if(divBtnSiguiente != null && (estadoPago == 'APROBADO' || estadoPago == 'CONCILIADO')){
				//btnSiguiente = divBtnSiguiente.getElement("button");
				//btnSiguiente.click();
				document.getElementById("btnConf").click();
			}
	
		}
    }



function salir() {










return true; // END
} // END
