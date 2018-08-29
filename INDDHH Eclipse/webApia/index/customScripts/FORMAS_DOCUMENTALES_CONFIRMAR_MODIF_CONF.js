
function FORMAS_DOCUMENTALES_CONFIRMAR_MODIF_CONF(evtSource, par_desdeCaratula, par_mensaje) { 
	var doRollback = false;
	var showMessage = true;

	if(document.getElementById("btnConf")!=null){

		/*--------------------------------

	par_desdeCaratula = "H" -> Viene desde Historial
	par_desdeCaratula = "C" -> Viene desde Caratula
	par_desdeCaratula = "A" -> Viene desde Actuacion

	---------------------------------*/
		if(par_desdeCaratula == "H"){
			par_mensaje = obtenerMensajeMultilenguajeSegunCodigo('MSG_CAMBIO_CONF_FORM_HIST_JS',currentLanguage);
		}else if(par_desdeCaratula == "A"){
			par_mensaje = obtenerMensajeMultilenguajeSegunCodigo('MSG_CAMBIO_CONF_FORM_ACT_JS',currentLanguage);
		}else if(par_desdeCaratula == "C"){
			par_mensaje = obtenerMensajeMultilenguajeSegunCodigo('MSG_CAMBIO_CONF_FORM_CARATULA_JS',currentLanguage);
		}

		
		if(par_desdeCaratula == "H"){
			var vIndex = evtSource.index;
			var myForm = ApiaFunctions.getForm("ACTUACIONES_HISTORIAL"); 
			strTipoAct = myForm.getFieldColumn("EXP_HIS_ACTUACION_TIPO_STR")[vIndex].getValue();

			if(strTipoAct.search(/^ag\b/i) == 0 || strTipoAct.search(/^inicio de tramite$/i) == 0){
				if(vIndex > 0){
					alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_IMPOSIBLE_CAMBIO_CONF_ACT_AG_JS',currentLanguage)); //alert("No se puede modificar la confidencialidad a las actuaciones autogeneradas");
				}else{
					alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_IMPOSIBLE_CAMBIO_CONF_CARATULA_JS',currentLanguage)); //alert("No se puede modificar la confidencialidad a la carátula");
				}
				doRollback = true;
				showMessage = false;
			}else{
				par_desdeCaratula = "A";
			}
		}

		if(par_desdeCaratula == "A"){
			var myForm = ApiaFunctions.getForm("ACTUACIONES_HISTORIAL"); 
			var strConfExp = myForm.getFieldColumn("EXP_HIS_ACTUACION_CONFIDENCIALIDAD_STR")[0].getValue(); 
			if(strConfExp == "2"){
				alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_IMPOSIBLE_MOD_CONF_ACT_EXP_CONFIDENCAL_JS',currentLanguage)); //alert("No se puede modificar la confidencialidad a las actuaciones de un expediente confidencial");
				doRollback = true;
				showMessage = false;			
			}
		}

		if(showMessage){
			doRollback = !confirm(par_mensaje);
		}

		if (doRollback) {
			if (evtSource.getValue() == "1"){
				evtSource.setValue("2");
			}else{
				if (evtSource.getValue() == "2"){
					evtSource.setValue("1");
				}
			}
			return false;
		}
		return true; // END
	}

return true; // END
} // END
