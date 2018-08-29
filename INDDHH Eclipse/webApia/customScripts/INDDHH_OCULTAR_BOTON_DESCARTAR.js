
function INDDHH_OCULTAR_BOTON_DESCARTAR(evtSource) { 
var formDatosITC = ApiaFunctions.getForm("TRM_DATOS_GW_ITC_PAGOS");
var habilita = formDatosITC.getField("habilitarBtnConfirmar").getValue();
//alert("habilita " + habilita);
if (habilita == "true" || habilita == "wait") {
  ApiaFunctions.hideActionButton(ActionButton.BTN_RELEASE);
}
































return true; // END
} // END
