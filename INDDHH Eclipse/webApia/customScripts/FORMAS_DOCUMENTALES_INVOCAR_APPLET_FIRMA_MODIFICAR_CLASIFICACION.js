
function FORMAS_DOCUMENTALES_INVOCAR_APPLET_FIRMA_MODIFICAR_CLASIFICACION(evtSource, par_esMC) { 
	var ua = navigator.userAgent.toLowerCase(),
	platform = navigator.platform.toLowerCase(),
	UA = ua.match(/(opera|ie|firefox|chrome|trident|version)[\s\/:]([\w\d\.]+)?.*?(safari|(?:rv[\s\/:]|version[\s\/:])([\w\d\.]+)|$)/) || [null, 'unknown', 0],
	mode = UA[1] == 'ie' && document.documentMode;
	
	if (UA[1] == 'trident'){
		UA[1] = 'ie';
		if (UA[4]) UA[2] = UA[4];
	}	
	
	var modificar = "false";	
	if (par_esMC == "true"){
		modificar = "true";
	}
	
	var name = (UA[1] == 'version') ? UA[3] : UA[1];
	var version = mode || parseFloat((UA[1] == 'opera' && UA[4]) ? UA[4] : UA[2]);
	var url = null;
	var esChromeMC = "false";
	
	if (name == 'chrome' && version >= 42) {
		esChromeMC = "true";
		url = getUrlApp() + "/expedientes/firma/firmarActuacionchromeSignature.jsp?esMC=" + modificar + TAB_ID_REQUEST;			
	}else if(name == 'ie'){
		url = getUrlApp() + "/expedientes/firma/firmarActuacionie.jsp?esMC=" + modificar + TAB_ID_REQUEST;
	}else{
		url = getUrlApp() + "/expedientes/firma/firmarActuacion.jsp?esMC=" + modificar + TAB_ID_REQUEST;	
	}
	
	
	modal =  ModalController.openWinModal(url, 435, 245, null, null, null, true, true);	
	
	modal.onclose=function(){
		
		var sDestino=this.returnValue;
		if (sDestino == "OK"){
			// SE HABILITA EL BOTON DE FIRMA
			document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);
					
			var nombreArchivo = "";
			var myForm = ApiaFunctions.getForm("FIRMA")
			if (myForm.getField("TMP_NOMBRE_ARCHIVO_A_FIRMAR_1_STR") != null){
				nombreArchivo = myForm.getField("TMP_NOMBRE_ARCHIVO_A_FIRMAR_1_STR").getValue();
			}
		}
	}
	
return true; // END
} // END
