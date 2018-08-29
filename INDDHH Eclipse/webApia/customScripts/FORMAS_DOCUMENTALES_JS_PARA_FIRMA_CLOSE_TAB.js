
function FORMAS_DOCUMENTALES_JS_PARA_FIRMA_CLOSE_TAB(evtSource) { 
	
	var form = ApiaFunctions.getForm("FIRMA");
	var tipo_pase = form.getField("TMP_TIPO_PASE_STR").getValue();
	
	if (tipo_pase == "PASE_PARA_FIRMA"){
		
		var usuario     = form.getField("EXP_NO_FIRMO_USUARIO_ACTUANTE").getValue();
		var usrAnterior = form.getField("EXP_PASE_A_FIRMA_USR_ANTERIOR").getValue();
		
		if (usuario != "false") {
			
			form.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
			
			var msg = "A\u00fan no ha firmado el usuario actuante: " + usrAnterior + ". No puede firmar hasta que dicho usuario realice la firma.";
			var title = "";
			showMessageCustom(msg , title , undefined , function(){ ApiaFunctions.closeCurrentTab(); });
			
		} else {
			
			var turno = form.getField("EXP_PASE_A_FIRMA_TURNO").getValue();
			if (turno != "true" && turno != ""){
				form.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true);
				
				var msg = "A\u00fan no ha firmado el usuario " + usrAnterior + ". No puede firmar hasta que dicho usuario realice la firma.";
				var title = "";
				showMessageCustom(msg , title , undefined , function(){ ApiaFunctions.closeCurrentTab(); });
			}
			
		}
		
	}	


return true; // END
} // END
