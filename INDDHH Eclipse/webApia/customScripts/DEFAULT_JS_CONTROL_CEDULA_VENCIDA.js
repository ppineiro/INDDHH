function DEFAULT_JS_CONTROL_CEDULA_VENCIDA(evtSource, par_nomFrm, par_nomAtt, par_onGrid) { 

	var hoy = new Date();
	var myForm = ApiaFunctions.getForm(par_nomFrm);
	var field = myForm.getField(par_nomAtt);
	var text;
	
	if (field.getValue()!=""){
		var arrFchVen = field.getValue().split("/");
		var vencimiento = new Date();
		vencimiento.setFullYear(arrFchVen[2], arrFchVen[1], arrFchVen[0]);
		
		if (vencimiento < hoy) {	  		
			showMsgError(par_nomFrm, par_nomAtt, "El documento está vencido. Deberá renovarlo para continuar con el trámite.");
			return false;			    
		}else{
			limpiarErroresFnc();
		}
	}

return true; // END
} // END
