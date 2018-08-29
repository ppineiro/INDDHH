
function FORMAS_DOCUMENTALES_JS_CERRAR_TAB_MOD_ACT(evtSource) { 

	var form = ApiaFunctions.getForm("FIRMA");
	var flag = form.getField("FLAG_MODIFICAR_ACTUACION").getValue();

	if (flag == "TRUE"){
			
		var msg = "La actuaci\u00f3n est\u00e1 pronta para ser modificada.";
		var title = "";
		showMessageCustom(msg , title , undefined , function(){ ApiaFunctions.closeCurrentTab(); });
		
	}

return true; // END
} // END
