
function DEFAULT_JS_OCULTAR_BOTON_DESCARTAR(evtSource) { 
var habilita = ApiaFunctions.getForm("TRM_DATOS_GW_ITC_PAGOS").getField("TRM_HABILITAR_CONFIRMAR_TRAMITE").getValue();
if (habilita != "true" & habilita != "wait") {
    ApiaFunctions.hideActionButton(ActionButton.BTN_RELEASE);
}



















return true; // END
} // END
