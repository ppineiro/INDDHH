
function INDDHH_PRESIONAR_BOTON_CONFIRMAR(evtSource) { 
var form=ApiaFunctions.getForm("TRM_TITULO");
if (form != null) {
	var visibilidad = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_VISIBILIDAD_STR").getValue();
	var eMail = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_EMAIL_USUARIO_STR").getValue();
	var tramite = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_COD_TRAMITE_STR").getValue();

	if (ApiaFunctions.getCurrentTaskName()=="SELECCIONAR_TRAMITE") {
  		if (tramite!="" && (visibilidad>=2 || (eMail!=null && eMail!="")) ) {
	  		if (eMail!=null && eMail!="") {
		  		confirmarTramite.delay(0.1);
	  		}
  		}
	}
}  

function confirmarTramite(){	
	document.getElementById("btnConf").click();	
}















return true; // END
} // END
