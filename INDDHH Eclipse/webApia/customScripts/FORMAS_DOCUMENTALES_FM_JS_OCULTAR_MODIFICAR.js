
function FORMAS_DOCUMENTALES_FM_JS_OCULTAR_MODIFICAR(evtSource) {
	
	var step = ApiaFunctions.getCurrentStep();
	var tarea = ApiaFunctions.getCurrentTaskName();

	if (step == 2 && tarea == "FIRMA_MULTIPLE") {
		var form = ApiaFunctions.getForm("FIRMA");
		var boton = form.getField("BTN_MOD_ACT");
		boton.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
	}
	
return true; // END
} // END
