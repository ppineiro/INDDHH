
function fnc_1001_4172(evtSource) { 
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
	
	// DESHABILITAR EL BOTON DE FIRMA
	var modal =  ModalController.openWinModal(url, 430, 240, null, null, null, true, true);
	
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

return true; // END
} // END
