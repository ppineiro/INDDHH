
function FORMAS_DOCUMENTALES_INVOCAR_APPLET_FIRMA(evtSource) { 
	
var integracionCoesys = "";
	var nroExp = "";

	var tarea = CURRENT_TASK_NAME;
	
	var form = ApiaFunctions.getForm("FIRMA_RECEPCION_FIEE");
	var myForm = ApiaFunctions.getForm("FIRMA");
	
	if (myForm.getField("EXP_FIRMA_CON_COESYS_STR") != null){
		integracionCoesys = myForm.getField("EXP_FIRMA_CON_COESYS_STR").getValue();
	}
	
	if (myForm.getField('TMP_NRO_DOC_A_FIRMAR_STR') != null){
		nroExp = myForm.getField('TMP_NRO_DOC_A_FIRMAR_STR').getValue()
	}
	

	if(integracionCoesys != null && integracionCoesys == 'true'){//firma integrandose con servicio de firma digital de coesys

		if(tarea == 'FIRMAR_CARATULA'){
       
			var url = getUrlApp() + "/expedientes/firma/EnviarDocumento.jsp?tipo=Caratula" + TAB_ID_REQUEST;
	
			//var modal = xShowModalDialog(url,"Firma dss","dialogWidth:1200px; dialogHeight:600px; dialogtop:100; dialogleft:100; scroll:yes; status=no");			
			var modal =  ModalController.openWinModal(url, 1200, 600, 100, 100, true, true, true);
			modal.onclose=function(){
				var sDestino=this.returnValue;
				if (sDestino == "OK"){
					//habilitar el botn de firma para que no apreten de nuevo
					document.getElementById("btnConf").disabled= false;	
					document.getElementById("btnConf").fireClickEvent();
				}
			}

		}else{
        
			var url = getUrlApp() + "/expedientes/firma/EnviarDocumento.jsp?tipo=Act&nroExp="+ nroExp + TAB_ID_REQUEST;
			//var modal = xShowModalDialog(url,"Firma dss","dialogWidth:1200px; dialogHeight:600px; dialogtop:100; dialogleft:100; scroll:yes; status=no");			
			var modal =  ModalController.openWinModal(url, 1200, 600, 100, 100, true, true, true);
			modal.onclose=function(){
				var sDestino=this.returnValue;
				if (sDestino == "OK"){
					//habilitar el botn de firma para que no apreten de nuevo
					document.getElementById("btnConf").disabled= false;	
					document.getElementById("btnConf").fireClickEvent();
				}
			}

		}
	}else{//firma con applet de apia	
	
		var form = ApiaFunctions.getForm("FIRMA_RECEPCION_FIEE");
		var myForm = ApiaFunctions.getForm("FIRMA");
		
		// DESHABILITO EL BOTON DE FIRMAR
		if (myForm != null && myForm.getField("FIRMAR") != null){
			myForm.getField("FIRMAR").setProperty(IProperty.PROPERTY_READONLY, true);
		}else if (form != null && form.getField("FIRMAR") != null){
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
			url = getUrlApp() + "/expedientes/firma/firmarActuacionchromeSignature.jsp?esMC=false" + TAB_ID_REQUEST;
		}else if(name == 'chrome' && version < 42){
			url = getUrlApp() + "/expedientes/firma/firmarActuacion.jsp?esMC=false" + TAB_ID_REQUEST;
		}else if(name == 'ie'){
			url = getUrlApp() + "/expedientes/firma/firmarActuacionie.jsp?esMC=false" + TAB_ID_REQUEST;
		}else{
			url = getUrlApp() + "/expedientes/firma/firmarActuacion.jsp?esMC=false" + TAB_ID_REQUEST;
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
	}
	



return true; // END
} // END
