
function DEFAULT_PRESIONAR_BOTON_NEXT_STEP_PAGO(evtSource) { 
	presionarBtnNextPago.delay(0.1);
	return true; // END
}

	function presionarBtnNextPago()  {
  		var formDatosPagosGwItc = ApiaFunctions.getForm("TRM_DATOS_GW_ITC_PAGOS");
		var habilita = formDatosPagosGwItc.getField("habilitarBtnConfirmar").getValue();
		var estadoPago = ApiaFunctions.getForm("TRM_REGISTRAR_PAGO_GW_ITC").getField("estadoPago").getValue();
		divBtnSiguiente = $("btnNext");
		if(divBtnSiguiente != null){
			if(habilita == 'true'&& (estadoPago == 'APROBADO' || estadoPago == 'CONCILIADO')){
				//btnSiguiente = divBtnSiguiente.getElement("button");
				//btnSiguiente.click();
				document.getElementById("btnNext").click();	
			}
		}
    }

function salir() {




return true; // END
} // END
