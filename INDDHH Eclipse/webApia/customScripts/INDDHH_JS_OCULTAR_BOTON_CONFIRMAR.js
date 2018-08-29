
function INDDHH_JS_OCULTAR_BOTON_CONFIRMAR(evtSource) { 
var form=ApiaFunctions.getForm("TRM_TITULO");
if (form != null) {
	var email = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_EMAIL_USUARIO_STR").getValue();
	if (email==null || email == "" ) {
		ApiaFunctions.getForm("TRM_TITULO").getField("URL_DESCRIPCION_TRAMITE").setProperty(IProperty.PROPERTY_VALUE,"");
	} else {
  		var verlink = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_VER_LINK_STR").getValue();
    	if (verlink=="1") {
        	ApiaFunctions.hideActionButton(ActionButton.BTN_CONFIRM);
        	ApiaFunctions.getForm("TRM_TITULO").getField("URL_DESCRIPCION_TRAMITE").setProperty(IProperty.PROPERTY_VALUE,"");
    	} else {
        	// No se si hay que hacer algo aca.
        	if (ApiaFunctions.getCurrentTaskName()!="CARGA_DATOS_TRAMITE") {
           		ApiaFunctions.getForm("TRM_TITULO").getField("URL_DESCRIPCION_TRAMITE").setProperty(IProperty.PROPERTY_VALUE,"");
        	} 
    	}
    }
}













return true; // END
} // END
