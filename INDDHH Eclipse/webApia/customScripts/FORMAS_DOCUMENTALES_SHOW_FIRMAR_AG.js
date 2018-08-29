
function FORMAS_DOCUMENTALES_SHOW_FIRMAR_AG(evtSource, par_nombFormulario, par_fldAccion, par_fldResultado, par_btnFirma) { 
	myForm = ApiaFunctions.getForm(par_nombFormulario);
	strAccion = myForm.getField(par_fldAccion).getValue();
	strOK = "";
	strFalla = "";
	
	//alert("se ejecuta");
	
	if(strAccion != ""){
		if (strAccion.search(/^firmar_.+/i) == 0){
			switch(strAccion){
				case "FIRMAR_BALDUQUE":
					strOK = "BALDUQUE_OK";
					strFalla = "BALDUQUE_FALLA";
					break;
				case "FIRMAR_DESBALDUQUE":
					strOK = "DESBALDUQUE_OK";
					strFalla = "DESBALDUQUE_FALLA";
					break;
				case "FIRMAR_CONF_EXP":
					strOK = "CONF_EXP_OK";
					strFalla = "CONF_EXP_FALLA";
					break;
				case "FIRMAR_CLA_EXP":
					strOK = "CLA_EXP_OK";
					strFalla = "CLA_EXP_FALLA";
					break;
				case "FIRMAR_CONF_ACT":
					strOK = "CONF_ACT_OK";
					strFalla = "CONF_ACT_FALLA";
					break;
				case "FIRMAR_DESGLOSE":
					strOK = "DESGLOSE_OK";
					strFalla = "DESGLOSE_FALLA";
					break;
				case "FIRMAR_CAMBIO_CARATULA":
					strOK = "CAMBIO_CARATULA_OK";
					strFalla = "CAMBIO_CARATULA_FALLA";
					myForm.getField(par_fldAccion).setValue("");
					break;
				case "FIRMAR_CAMBIO_ELE_FISICO_EXP":
					strOK = "CAMBIO_ELE_FISICO_EXP_OK";
					strFalla = "CAMBIO_ELE_FISICO_EXP_FALLA";
					myForm.getField(par_fldAccion).setValue("");
					break;
			}
			
			var ua = navigator.userAgent.toLowerCase(),
			platform = navigator.platform.toLowerCase(),
			UA = ua.match(/(opera|ie|firefox|chrome|trident|version)[\s\/:]([\w\d\.]+)?.*?(safari|(?:rv[\s\/:]|version[\s\/:])([\w\d\.]+)|$)/) || [null, 'unknown', 0],
			mode = UA[1] == 'ie' && document.documentMode;
			
			if (UA[1] == 'trident'){
				UA[1] = 'ie';
				if (UA[4]) UA[2] = UA[4];
			}
			var name = (UA[1] == 'version') ? UA[3] : UA[1];
			var version = mode || parseFloat((UA[1] == 'opera' && UA[4]) ? UA[4] : UA[2]);
			var url = null;
			if(name == 'chrome' && version >= 42){
				url =  getUrlApp() + "/expedientes/firma/firmarchromeSignature.jsp?" + TAB_ID_REQUEST;
				//alert(url);
			}else{
				url =  getUrlApp() + "/expedientes/firma/firmar.jsp?" + TAB_ID_REQUEST;
				//alert(url);
			}
			var modal =  ModalController.openWinModal(url, 420, 235, null, null, true, true, true);			
			modal.addEvent('confirm', function() {
				myForm.getField(par_btnFirma).fireClickEvent();				
			});
			
			modal.setearResultado = function(sDestino) {	
				if (sDestino+"" == "undefined"){
					sDestino = "";
				}
				
				//alert("Destino: "+ sDestino);
				if (sDestino == "OK"){
					myForm.getField(par_fldResultado).setValue(strOK);
					myForm.getField(par_fldAccion).setValue(strAccion + ".GUARDAR_FIRMA");
				}else{
					myForm.getField(par_fldResultado).setValue(strFalla);
				}
			}
		}
	}



return true; // END
} // END
