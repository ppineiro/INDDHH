
function FORMAS_DOCUMENTALES_SHOW_ARBOL_OFICINAS(evtSource) {

	var form = ApiaFunctions.getForm("PROXIMO_PASO");
	var grillaTC = form.getField("GRILLA_TRABAJO_COLABORATIVO");
	
	var checkCloseTab =  form.getField("CloseTab");
	var closeTab = checkCloseTab.getProperty(IProperty.PROPERTY_CHECKED);
	
	if (!closeTab){
		var siEntro = false;
		var tipo = false;
		
		var frmActual = "PROXIMO_PASO_";
		
		var sep1 = form.getField("EXP_TMP_SEP1").getValue();
		var sep2 = form.getField("EXP_TMP_SEP2").getValue();

		// MUESTRO EL BOTON TC
		form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
		grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
		
		var entro=false;
		var TIPO_PASE;	
		if(form.getField("EXP_OPCION_PASE_STR")!=null){
			TIPO_PASE = form.getField("EXP_OPCION_PASE_STR").getValue();
			siEntro = true;
		}else{		
			var cElems = document.getElementsByTagName('INPUT');
			var iNumElems = cElems.length;
			for (var i=1;i<iNumElems;i++) {	
				if (cElems[i].id  == frmActual +"EXP_PROXIMO_PASO_STR"){
					if (cElems[i].getValue() == "PASE_INTERNO"){				
						if (cElems[i].getValue()){
							TIPO_PASE="PASE_INTERNO";
							siEntro = true;
						} 
					}
					if (cElems[i].getValue() == "PASE_EXTERNO"){				
						if (cElems[i].getValue()){
							TIPO_PASE="PASE_EXTERNO";
							siEntro = true;
						}
					}
					if (cElems[i].getValue() == "PASE_MULTIPLE"){				
						if (cElems[i].getValue()){
							TIPO_PASE="PASE_MULTIPLE";
							siEntro = true;
						}
					}
					if (cElems[i].getValue() == "PASE_GRUPO_TRABAJO"){				
						if (cElems[i].getValue()){
							TIPO_PASE="PASE_GRUPO_TRABAJO";
							siEntro = true;
						}
					}
					if (cElems[i].getValue() == "PASE_DELEGACION"){				
						if (cElems[i].getValue()){
							TIPO_PASE="PASE_DELEGACION";
							siEntro = true;
						}
					}
					if (cElems[i].getValue() == "PASE_ELEVACION"){				
						if (cElems[i].getValue()){
							TIPO_PASE="PASE_ELEVACION";
							siEntro = true;
						}
					}
				}
			}	
		}

		if (TIPO_PASE == "" && tipo == true){
			alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_ELIGA_PROXIMO_PASO_JS',currentLanguage)); //alert('Por favor vuelva a elegir el Pr�ximo Paso.');
		}

		if (TIPO_PASE == "REALIZAR_ACTUACION"){
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
		}
		
		if (TIPO_PASE == "PASES_PASE_A_PROCESAMIENTO_INTERNO"){
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
		}
		
		if (TIPO_PASE == "PASES_PASE_A_FIN_EXPEDIENTE_EDOCS"){
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
		}
		
		if (TIPO_PASE == ""){
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
		}
		
		if (TIPO_PASE == "PASE_ORGANISMO_EXTERNO"){
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			var URL = getUrlApp() + "/expedientes/arbolOrganismoExternoDestino/armar.jsp?";
			window.status = URL;		
			var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 900, 450);			
			modal.setearDestino = function(sDestino) {		
				try{
					if (sDestino == 'undefined' ||sDestino == 'cancel' || sDestino == '' || sDestino == null){
						alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");
						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");						
						form.getField("EXP_ID_ORGANISMO_EXT_STR").setValue("");
						form.getField("EXP_NOMBRE_ORGANISMO_EXT_STR").setValue("");
						form.getField("EXP_ID_MESA_ENTRADA_OE_STR").setValue("");
						form.getField("EXP_MESA_ENTRADA_OE_STR").setValue("");
						form.getField("EXP_MODO_ENVIO_OE_STR").setValue("");

						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
					}
					else{					
						//document.getElementById(frmActual + "EXP_NOMBRE_ORGANISMO_EXT_STR").value = sDestino;
						var vec = sDestino.split(sep1);
						form.getField("EXP_ID_ORGANISMO_EXT_STR").setValue(vec[0]);
						form.getField("EXP_NOMBRE_ORGANISMO_EXT_STR").setValue(vec[1]);
						form.getField("EXP_ID_MESA_ENTRADA_OE_STR").setValue(vec[2]);
						form.getField("EXP_MESA_ENTRADA_OE_STR").setValue(vec[3]);
						form.getField("EXP_MODO_ENVIO_OE_STR").setValue(vec[4]);

						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);		
					}
				}catch(e){
					alert(e);
				}
			}
		}

		if (TIPO_PASE=="PASE_INTERNO"){
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			var URL = getUrlApp() + "/expedientes/arbolDestino/armar.jsp?";
			window.status = URL;		
			var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1000, 430);
			modal.setearDestino = function(sDestino) {
				try{
					// var sDestino=this.returnValue;
					if (sDestino == "cancel" || sDestino == "" || sDestino == null){
						alert(obtenerMensajeMultilenguajeSegunCodigo("MSG_DESTINO_NO_VALIDO",currentLanguage)); //alert("No se ha elegido un destino v�lido.");

						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");	
						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
					}else{										
						var vec = sDestino.split(sep1);	
						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);
						form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue(vec[1]);
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue(vec[2]);
						form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue(vec[3]);
						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);								
					}
				}catch(e){
					alert(e);
				}
			}
		}

		if (TIPO_PASE=="PASE_DELEGACION"){
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);

			if (form.getField("EXP_USUARIOS_EN_GRILLA_STR").getValue()==""){
				var URL = getUrlApp() + "/expedientes/arbolDestinoAdHoc/armar.jsp?";
				window.status = URL;
				var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1000, 430);
				modal.setearDestino = function(sDestino) {				
					try{
						if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
							alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");

							form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue("");
							form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");
							form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");
							form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");	
							if (document.getElementById("btnConf") != null)
								document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
						}else{

							var vec = sDestino.split(sep1);		
							if(vec[2] == null || vec[2] == ''){
								alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_ELEGIR_USUARIO_DESTINO',currentLanguage)); //alert("No se ha elegido un destino v�lido. No se eligi� el usuario de destino");

								form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue("");
								form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");
								form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");
								form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");	
								if (document.getElementById("btnConf") != null)
									document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
							}else{
								if(vec[2].indexOf('\u00b7')==-1){
									alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_ELEGIR_MINIMO_DOS_DESTINATARIOS',currentLanguage)); //alert("Debe elegir al menos 2 destinatarios");

									form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue("");
									form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");
									form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");
									form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");	
									if (document.getElementById("btnConf") != null)
										document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
								}else{

									form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);
									form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue(vec[1]);
									form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");
									form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");	
									form.getField("EXP_DESTINATARIO_PASE_PARA_FIRMA_STR").setValue(vec[2]);
									form.getField("EXP_USUARIOS_EN_GRILLA_STR").setValue("EN PROCESO");

									fireEvent(document.getElementById("BTN_PROXIMO_PASO_CARGAR_USUARIOS"),"click");			

									if (document.getElementById("btnConf") != null)
										document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);	
								}
							}
						}
					}catch(e){
						alert(e);
					}
				}
			}
		}

		if (TIPO_PASE=="PASE_EXTERNO"){		
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			var URL = getUrlApp() + "/expedientes/arbolDestino/armar.jsp?";
			window.status = URL;
			var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1000, 430);
			modal.setearDestino = function(sDestino) {	
				try{
					if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
						alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");

						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");	
						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
					}else{			
						var vec = sDestino.split(sep1);		

						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);
						form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue(vec[1]);
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue(vec[2]);

						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);	
					}			
				}catch(e){
					alert(e);
				}
			}
		}

		if (TIPO_PASE=="PASE_MULTIPLE"){
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			var URL = getUrlApp() + "/expedientes/arbolDestinoMultiple/armar.jsp?";
			window.status = URL;
			var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1000, 430);
			modal.setearDestino = function(sDestino) {
				try{
					if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
						alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");

						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");	
						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
					}
					else{								
						var vec = sDestino.split(sep1);			
						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue(vec[1]);

						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);
					}
				}catch(e){
					alert(e);
				}
			}
		}
		
		if (TIPO_PASE=="PASE_PARA_FIRMA"){

			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			var usuarios = form.getField("EXP_USUARIOS_EN_GRILLA_STR").getValue();
			if (usuarios == '' || usuarios == null || usuarios == ""){
				var URL = getUrlApp() + "/expedientes/arbolDestinoMultipleConUsuarios/armar.jsp?";
				window.status = URL;	
				var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1000, 430);
				
				modal.addEvent('confirm', function() {
					form.getField("CARGAR_USUARIOS").fireClickEvent();
				});
				
				modal.setearDestino = function(sDestino) {
					
					try{
						if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
							
							// No se ha elegido un destino valido.
							alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage));

							form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue("");
							form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");
							form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");
							form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");	
							if (document.getElementById("btnConf") != null){
								document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
							}	
							
						}else{
							
							sDestino = sacarSeperadorDeLosExtremos(sDestino, sep2);
							var sDestinoArr = sDestino.split(sep2);

							sDestino = "";
							var sDestinoOf = "";
							for (var i = 0; i < sDestinoArr.length; i++){
								if (!(sDestinoArr[i].split("#")[1] == LOGGED_USER)){
									sDestino += sDestinoArr[i].split("#")[1]+sep2;
									sDestinoOf += sDestinoArr[i].split("#")[0]+sep2;
								}
							}
							
							sDestino = sDestino + LOGGED_USER;
							try{
								sDestinoOf = sDestinoOf + ApiaFunctions.getForm("ACTUACIONES").getField("EXP_OFICINA_ACTUAL_ENUM").getValue();
							}catch(e){
								
							}
							
							form.getField("EXP_DESTINATARIO_PASE_PARA_FIRMA_STR").setValue(sDestino);
							form.getField("EXP_DEST_OFICINAS_PASE_PARA_FIRMA_STR").setValue(sDestinoOf);
							form.getField("EXP_USUARIOS_EN_GRILLA_STR").setValue("EN PROCESO");

							if (document.getElementById("btnConf") != null){
								document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);
							}
															
						}
						
					}catch(e){
						alert(e);
					}
					
				}
				
			}
			
		}

		if (TIPO_PASE=="PASE_GRUPO_TRABAJO"){	
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			var URL = getUrlApp() + "/expedientes/arbolDestino/armar.jsp?";
			window.status = URL;	
			var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1000, 430);
			modal.setearDestino = function(sDestino) {	
				try{
					if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
						alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");

						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");	
						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
					}else{						
						var vec = sDestino.split(sep1);		

						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);
						form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue(vec[1]);
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue(vec[2]);

						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);	
					}
				}catch(e){
					alert(e);
				}
			}
		}

		if (TIPO_PASE=="PASE_ELEVACION"){	
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			var URL = getUrlApp() + "/expedientes/arbolElevar/armar.jsp?";
			window.status = URL;		
			var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 700, 400);
			modal.setearDestino = function(sDestino) {	
				try{
					if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
						alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");

						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");	
						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
					}else{						
						//alert(sDestino);
						var vec = sDestino.split(sep1);						
						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);
						form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue(vec[1]);
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue(vec[2]);

						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);	
					}
				}catch(e){
					alert(e);
				}
			}
		}
		
		// Ruta estatica
		if (TIPO_PASE == "PASE_SUGERIDO"){
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
		}
		// End Ruta estatica

		// Para el pase a firma
		if (TIPO_PASE=="PASE_INTERNO_PASE_FIRMA"){
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			var URL = getUrlApp() + "/expedientes/arbolDestino/armar.jsp?";
			window.status = URL;		
			var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1000, 430);
			modal.setearDestino = function(sDestino) {

				try{				
					if (sDestino == "cancel" || sDestino == "" || sDestino == null){
						alert(obtenerMensajeMultilenguajeSegunCodigo("MSG_DESTINO_NO_VALIDO",currentLanguage)); //alert("No se ha elegido un destino v�lido.");
						form.getField("EXP_COD_OFICINA_DESTINO_PP_PASE_FIRMA_STR").setValue("");
						form.getField("EXP_OFICINA_DESTINO_PP_PASE_FIRMA_STR").setValue("");
						form.getField("EXP_USUARIO_DESTINO_PP_PASE_FIRMA_STR").setValue("");

						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
					}
					else{										
						var vec = sDestino.split(sep1);			
						form.getField("EXP_COD_OFICINA_DESTINO_PP_PASE_FIRMA_STR").setValue(vec[0]);
						form.getField("EXP_OFICINA_DESTINO_PP_PASE_FIRMA_STR").setValue(vec[1]);
						form.getField("EXP_USUARIO_DESTINO_PP_PASE_FIRMA_STR").setValue(vec[2]);

						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);								
					}

				}catch(e){
					alert(e);
				}
			}
		}

		if (TIPO_PASE=="PASE_EXTERNO_PASE_FIRMA"){		
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			var URL = getUrlApp() + "/expedientes/arbolDestino/armar.jsp?";
			window.status = URL;
			var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1000, 430);
			modal.setearDestino = function(sDestino) {
				try{
					if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
						alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");

						form.getField("EXP_COD_OFICINA_DESTINO_PP_PASE_FIRMA_STR").setValue("");
						form.getField("EXP_OFICINA_DESTINO_PP_PASE_FIRMA_STR").setValue("");
						form.getField("EXP_USUARIO_DESTINO_PP_PASE_FIRMA_STR").setValue("");

						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
					}else{			
						var vec = sDestino.split(sep1);						
						form.getField("EXP_COD_OFICINA_DESTINO_PP_PASE_FIRMA_STR").setValue(vec[0]);
						form.getField("EXP_OFICINA_DESTINO_PP_PASE_FIRMA_STR").setValue(vec[1]);
						form.getField("EXP_USUARIO_DESTINO_PP_PASE_FIRMA_STR").setValue(vec[2]);

						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);	
					}
				}catch(e){
					alert(e);
				}
			}
		}
		
		/************************************************************* TRABAJO COLABORATIVO **************************************************************/
		if (TIPO_PASE == "TRABAJO_COLABORATIVO"){
			var sepTC = ",";
			form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");

			var usuarios = form.getField("EXP_USUARIOS_EN_GRILLA_STR").getValue();
			if (usuarios == '' || usuarios == null || usuarios == ""){
				var URL = getUrlApp() + "/expedientes/trabajoColaborativo/arbolOficinas/armarArbolOficinasTC.jsp?";
				window.status = URL;
				var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1000, 430);
				
				modal.addEvent('confirm', function() {
					form.getField("TC_CARGAR_GRILLA").fireClickEvent();
				});
				
				modal.setearDestino = function(sDestino) {	
					try{
						if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
							alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino valido.");
							form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");		
							form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");
							form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");	
							if (document.getElementById("btnConf") != null)
								document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
							
						}else{
							sDestino = sacarSeperadorDeLosExtremos(sDestino, sep2);
							var sDestinoArr = sDestino.split(sep2);

							sDestino = "";
							var sDestinoOf = "";
							for (var i = 0; i < sDestinoArr.length; i++){
								sDestino += sDestinoArr[i].split("#")[1]+sepTC;
								sDestinoOf += sDestinoArr[i].split("#")[0]+sepTC;
							}
							
							if ((sep2 + sDestino + sep2).indexOf(sep2 + LOGGED_USER + sep2)>=0){
								try{
									sDestino = sDestino.substring(0, sDestino.length-1);
								}catch(e){}
							}else{
								sDestino = sDestino.substring(0, sDestino.length-1);
								sDestino = LOGGED_USER + sepTC + sDestino;
								try{
									sDestinoOf = sDestinoOf + ApiaFunctions.getForm("ACTUACIONES").getField("EXP_OFICINA_ACTUAL_ENUM").getValue();
								}catch(e){}
							}

							var oficina_actual = form.getField("EXP_OFICINA_ACTUAL_NOMB_STR").getValue();
							
							form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue(sDestino);
							form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue(sDestinoOf);							
							form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue(oficina_actual);
							
							if (document.getElementById("btnConf") != null)
								document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);						
						}				
					}catch(e){
						alert(e);
					}
				}
			}			
		}		
				
		if (grillaTC.getProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN) == false && grillaTC.getRow(0).length != 0){			
			grillaTC.getField('TC_GRID_FIRMAR', 0).setProperty(IProperty.PROPERTY_READONLY, true);
			grillaTC.getField('TC_GRID_TERMINAR', 0).setProperty(IProperty.PROPERTY_READONLY, true);			
			grillaTC.getField('TC_GRID_CANCELAR', 0).setProperty(IProperty.PROPERTY_READONLY, true);
		}
		
		/**************************************************************************************************************************************************************/
				
		/**************************************************************** PASE DISTRIBUCI�N ******************************************************************/
		if (TIPO_PASE == "PASES_PASE_DISTRIBUCION"){
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);

			//---------------------------------------------------------------
			var actuaciones = ApiaFunctions.getForm("ACTUACIONES");
			var tipoAct = actuaciones.getField("EXP_TIPO_ACTUACION_ENUM").setProperty(IProperty.PROPERTY_REQUIRED, false);
			var contAct = actuaciones.getField("EXP_ACTUACION_STR").setProperty(IProperty.PROPERTY_REQUIRED, false);
			//---------------------------------------------------------------

			var URL = getUrlApp() + "/expedientes/arbolDestino/armar.jsp?";
			window.status = URL;		
			var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1000, 430);
			modal.setearDestino = function(sDestino) {
				try{
					// var sDestino=this.returnValue;
					if (sDestino == "cancel" || sDestino == "" || sDestino == null){
						alert(obtenerMensajeMultilenguajeSegunCodigo("MSG_DESTINO_NO_VALIDO",currentLanguage)); //alert("No se ha elegido un destino v�lido.");

						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue("");
						form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue("");	
						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
					}else{										
						var vec = sDestino.split(sep1);	
						form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);
						form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue(vec[1]);
						form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue(vec[2]);
						form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue(vec[3]);
						if (document.getElementById("btnConf") != null)
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);								
					}
				}catch(e){
					alert(e);
				}
			}
		}
		/**************************************************************************************************************************************************************/
		
		/*************************************************************** PASE A SOLICITANTE ******************************************************************/
		if (TIPO_PASE == "PASES_PASE_A_SOLICITANTE") {

			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			
			var exp = form.getField("EXP_NRO_EXPEDIENTE_STR").getValue();
			
			var URL = getUrlApp() + "/expedientes/solicitudes/cargarDatosPaseSolicitud.jsp?nroExp=" + exp + TAB_ID_REQUEST;
			
			var xmlHttp = null;
			if(window.XMLHttpRequest){
				xmlHttp=new XMLHttpRequest();
			}
			else{
				xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
			}
			
			xmlHttp.onreadystatechange = function() {
	    		if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
	    			
	    			var sep = ";";
	    			var basura = "$";
	    			var datos = xmlHttp.responseText.split(basura)[0];
	    			
	    			var solicitante_login = datos.split(sep)[0];
	    			var solicitante_name = datos.split(sep)[1];
	    			var solicitante_cod_oficina = datos.split(sep)[2];
	    			var solicitante_desc_oficina = datos.split(sep)[3];
	    			
	    			form.getField("EXP_USUARIO_DESTINO_PASE_STR").setValue(solicitante_login);
	    			form.getField("EXP_NOM_USR_DESTINO_PASE_STR").setValue(solicitante_name);	    			
	    			form.getField("EXP_OFICINA_DESTINO_PASE_STR").setValue(solicitante_cod_oficina);
					form.getField("EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue(solicitante_desc_oficina);	    			
	    		}
			}
			
			xmlHttp.open("POST", URL, false);
	    	xmlHttp.send();				
			
		}		
		/**************************************************************************************************************************************************************/
		
		if(form.getField("EXP_OPCION_PASE_STR")!=null){
			form.getField("EXP_OPCION_PASE_STR").setValue("");
			if (TIPO_PASE == "TRABAJO_COLABORATIVO"){
				form.getField("EXP_OPCION_PASE_STR").setValue("TC_Iniciar");
			}
		}
		
		if (TIPO_PASE == "FIN_EXPEDIENTE" || TIPO_PASE == "EXPEDIENTE_EN_ESPERA"
			|| TIPO_PASE == "PASE_A_PROCESO" || TIPO_PASE == "PASE_TRANSICION"  || TIPO_PASE == "DESHACER_PASE") {
			form.getField("TC_Button_Start").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			grillaTC.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
		}		
		
	}else{
		var msg = 'El trabajo colaborativo ha sido iniciado con \u00e9xito.';
		var title = "";
		showMessageCustom(msg , title , undefined , function(){ ApiaFunctions.closeCurrentTab(); });
	}	

	return true; // END

} // END
