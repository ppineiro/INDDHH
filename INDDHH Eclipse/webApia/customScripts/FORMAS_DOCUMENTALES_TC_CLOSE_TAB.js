
function FORMAS_DOCUMENTALES_TC_CLOSE_TAB(evtSource) { 

	var form = ApiaFunctions.getForm("TC_ESTADO");
	var flag = form.getField("TC_FLAG_FIN").getValue();
	
	if (flag == "TERMINAR") {
		var msg = 'Ha concluido exitosamente el trabajo colaborativo, la actuaci\u00f3n est\u00e1 lista para ser firmada por los usuarios firmantes.';
		var title = "";
		showMessageCustom(msg , title , undefined , function(){ ApiaFunctions.closeCurrentTab(); });
	}

return true; // END
} // END
