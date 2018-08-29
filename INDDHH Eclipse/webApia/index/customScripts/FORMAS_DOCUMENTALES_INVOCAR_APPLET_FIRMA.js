
function FORMAS_DOCUMENTALES_INVOCAR_APPLET_FIRMA(evtSource) { 
	var form = ApiaFunctions.getForm("FIRMA_RECEPCION_FIEE");
	var myForm = ApiaFunctions.getForm("FIRMA");
	
	// DESHABILITO EL BOTON DE FIRMAR
	if (myForm.getField("FIRMAR") != null){
		myForm.getField("FIRMAR").setProperty(IProperty.PROPERTY_READONLY, true);
	}else if (form.getField("FIRMAR") != null){
		form.getField("FIRMAR").setProperty(IProperty.PROPERTY_READONLY, true);
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
		url = getUrlApp() + "/expedientes/firma/firmarActuacionchromeSignature.jsp?" + TAB_ID_REQUEST;
	}else{
		url = getUrlApp() + "/expedientes/firma/firmarActuacion.jsp?" + TAB_ID_REQUEST;
	}

	var modal =  ModalController.openWinModal(url, 420, 235, null, null, true, true, true);
	modal.addEvent('confirm', function(sDestino) {
		if (sDestino == "OK"){
			// HABILITO EL BOTON DE CONFIRMAR
			document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);
			var nombreArchivo = "";
			if (myForm.getField("TMP_NOMBRE_ARCHIVO_A_FIRMAR_1_STR") != null){
				nombreArchivo = myForm.getField("TMP_NOMBRE_ARCHIVO_A_FIRMAR_1_STR").getValue();
			}
			chkFirma(nombreArchivo);
			document.getElementById("btnConf").fireClickEvent();
		}
		document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);

		// HABILITO EL BOTON FIRMAR
		if (myForm.getField("FIRMAR") != null){
			myForm.getField("FIRMAR").setProperty(IProperty.PROPERTY_READONLY, false);
		}else if (form.getField("FIRMAR") != null){
			form.getField("FIRMAR").setProperty(IProperty.PROPERTY_READONLY, false);
		}
	});

	modal.addEvent('close', function(sDestino) {
			// HABILITO EL BOTON FIRMAR
			if (myForm.getField("FIRMAR") != null){
				myForm.getField("FIRMAR").setProperty(IProperty.PROPERTY_READONLY, false);
			}else if (form.getField("FIRMAR") != null){
				form.getField("FIRMAR").setProperty(IProperty.PROPERTY_READONLY, false);
			}
	});
	
return true; // END
} // END
