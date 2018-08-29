
function fnc_1001_1746(evtSource) { 
	var frmActual = "NOTA_OFICINA_ORIGEN_";

	//Permite la reutilizaci�n de la clase en otros formularios sin afectar
	//el funcionamiento para PROXIMO_PASO	
	if(document.getElementById('divTitFrmOFICIO_PROXIMO_PASO')!=null) {
		frmActual = 'OFICIO_PROXIMO_PASO_';
	}
	else if(document.getElementById('divTitFrmMEMO_PROXIMO_PASO')!=null) {
		frmActual = 'MEMO_PROXIMO_PASO_';
	}
	var sep1 = document.getElementById(frmActual + "EXP_TMP_SEP1").getValue();
	var sep2 = document.getElementById(frmActual + "EXP_TMP_SEP2").getValue();
	
	var entro=false;
	var TIPO_PASE;
	
	if(document.getElementById(frmActual + "EXP_OPCION_PASE_STR")!=null){
		TIPO_PASE = document.getElementById(frmActual + "EXP_OPCION_PASE_STR").getValue();
	}
	else
	{			
		var cElems = document.getElementsByTagName('INPUT');
		var iNumElems = cElems.length;
		for (var i=1;i<iNumElems;i++) {		
			if (cElems[i].id  == frmActual +"EXP_PROXIMO_PASO_STR"){			
				if (cElems[i].getValue() == "PASE_INTERNO"){				
					if (cElems[i].getValue()){
						TIPO_PASE="PASE_INTERNO";
					} 
				}
				if (cElems[i].getValue() == "PASE_EXTERNO"){				
					if (cElems[i].getValue()){
						TIPO_PASE="PASE_EXTERNO";
					}
				}
				if (cElems[i].getValue() == "PASE_MULTIPLE"){				
					if (cElems[i].getValue()){
						TIPO_PASE="PASE_MULTIPLE";
					}
				}
				if (cElems[i].getValue() == "PASE_GRUPO_TRABAJO"){				
					if (cElems[i].getValue()){
						TIPO_PASE="PASE_GRUPO_TRABAJO";
					}
				}
				if (cElems[i].getValue() == "PASE_DELEGACION"){				
					if (cElems[i].getValue()){
						TIPO_PASE="PASE_DELEGACION";
					}
				}
				if (cElems[i].getValue() == "PASE_ELEVACION"){				
					if (cElems[i].getValue()){
						TIPO_PASE="PASE_ELEVACION";
					}
				}																	
			}
		}	
	}
	
	if (TIPO_PASE=="PASE_INTERNO"){		
		var modal =  ModalController.openWinModal(getUrlApp() + "/expedientes/arbolDestino/armar.jsp?" + TAB_ID_REQUEST, 1050, 400, null, null, null, true, true);

		modal.onclose=function(){
			var sDestino=this.returnValue;
			if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
				alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue("");			
				document.getElementById(frmActual + "NTA_OFICINA_ORIGEN_STR").setValue("");		
				document.getElementById(frmActual + "NTA_USUARIO_ORIGEN_STR").setValue("");
				document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
			}
			else{								
				var vec = sDestino.split(sep1);						
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);			
				document.getElementById(frmActual + "NTA_OFICINA_ORIGEN_STR").setValue(vec[1]);		
				document.getElementById(frmActual + "NTA_USUARIO_ORIGEN_STR").setValue(vec[2]);							
			}
		}
	}
	
	if (TIPO_PASE=="PASE_DELEGACION"){
		var modal =  ModalController.openWinModal(getUrlApp() + "/expedientes/arbolDestino/armar.jsp?" + TAB_ID_REQUEST, 1050, 400, null, null, null, true, true);

		modal.onclose=function(){
			var sDestino=this.returnValue;
			if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
				alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue("");		
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");		
				document.getElementById(frmActual + "EXP_USUARIO_DESTINO_PASE_STR").setValue("");
				document.getElementById(frmActual + "EXP_NOM_USR_DESTINO_PASE_STR").setValue("");
				document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
			}
			else{						
				var vec = sDestino.split(sep1);						
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);		
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue(vec[1]);				
				document.getElementById(frmActual + "EXP_USUARIO_DESTINO_PASE_STR").setValue(vec[2]);					
			}
		}
	}
	
	if (TIPO_PASE=="PASE_EXTERNO"){		
		var modal =  ModalController.openWinModal(getUrlApp() + "/expedientes/arbolDestino/armar.jsp?" + TAB_ID_REQUEST, 1050, 400, null, null, null, true, true);

		modal.onclose=function(){
			var sDestino=this.returnValue;
			if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
				alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue("");		
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");		
				document.getElementById(frmActual + "EXP_USUARIO_DESTINO_PASE_STR").setValue("");
				document.getElementById(frmActual + "EXP_NOM_USR_DESTINO_PASE_STR").setValue("");
				document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
			}else{			
				var vec = sDestino.split(sep1);						
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);		
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue(vec[1]);			
				document.getElementById(frmActual + "EXP_USUARIO_DESTINO_PASE_STR").setValue(vec[2]);
			}
		}
	}
	
	if (TIPO_PASE=="PASE_MULTIPLE"){
		
		var modal =  ModalController.openWinModal(getUrlApp() + "/expedientes/arbolDestinoMultiple/armar.jsp?" + TAB_ID_REQUEST, 750, 400, null, null, null, true, true);

		
		modal.onclose=function(){
			var sDestino=this.returnValue;
			if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
				alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue("");		
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");		
				document.getElementById(frmActual + "EXP_USUARIO_DESTINO_PASE_STR").setValue("");
				document.getElementById(frmActual + "EXP_NOM_USR_DESTINO_PASE_STR").setValue("");
				document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
			}
			else{			
						
				var vec = sDestino.split(sep1);			
				document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);	
				document.getElementById(frmActual + "EXP_USUARIO_DESTINO_PASE_STR").setValue(vec[1]);	
			}
		}
	}
	
	/*
	alert( document.getElementById("gridListfrm_E_1050_19") );
	alert( document.getElementById("gridListfrm_E_1050_19").style.display );
	alert( document.getElementById("gridListfrm_E_1050_19").style.height );
	alert( document.getElementById("gridListfrm_E_1050_19").style.width );
	
	document.getElementById("gridListfrm_E_1050_19").style.height = 0;
	document.getElementById("gridListfrm_E_1050_19").style.width = 0;
	*/
	
	if (TIPO_PASE=="PASE_PARA_FIRMA"){
	
		if (document.getElementById(frmActual + "EXP_USUARIOS_EN_GRILLA_STR").getValue()==""){
		
			var modal =  ModalController.openWinModal(getUrlApp() + "/expedientes/arbolDestinoMultipleConUsuarios/armar.jsp?" + TAB_ID_REQUEST, 1050, 400, null, null, null, true, true);

			modal.onclose=function(){
				var sDestino=this.returnValue;
				if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
					alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");
					document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue("");			
					document.getElementById(frmActual + "EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");			
					document.getElementById(frmActual + "EXP_USUARIO_DESTINO_PASE_STR").setValue("");
					document.getElementById(frmActual + "EXP_NOM_USR_DESTINO_PASE_STR").setValue("");
					document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
				}else{	
					
					sDestino = replaceSubstring(sDestino, LOGGED_USER, "");
					sDestino = sacarSeperadorDeLosExtremos(sDestino, sep2);
					sDestino = sDestino  +  sep2 + LOGGED_USER;
						
					document.getElementById(frmActual + "EXP_DESTINATARIO_PASE_PARA_FIRMA_STR").setValue(sDestino);
					document.getElementById(frmActual + "EXP_USUARIOS_EN_GRILLA_STR").setValue("EN PROCESO");
					//document.getElementById("BTN_PROXIMO_PASO_CARGAR_USUARIOS").onclick();
					fireEvent(document.getElementById("BTN_PROXIMO_PASO_CARGAR_USUARIOS"),"click");			
					//document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").value = "";			
					//document.getElementById(frmActual + "EXP_OFICINA_DESTINO_NOMB_PASE_STR").value = "";			
					//document.getElementById(frmActual + "EXP_USUARIO_DESTINO_PASE_STR").value = "";										
				}
			}
		}
		
	}
	
	if (TIPO_PASE=="PASE_GRUPO_TRABAJO"){		
		var modal =  ModalController.openWinModal(getUrlApp() + "/expedientes/arbolDestino/armar.jsp?" + TAB_ID_REQUEST, 1050, 400, null, null, null, true, true);

		if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
			alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");
			document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue("");		
			document.getElementById(frmActual + "EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");			
			document.getElementById(frmActual + "EXP_USUARIO_DESTINO_PASE_STR").setValue("");
			document.getElementById(frmActual + "EXP_NOM_USR_DESTINO_PASE_STR").setValue("");
			document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
		}else{						
			var vec = sDestino.split(sep1);						
			document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);		
			document.getElementById(frmActual + "EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue(vec[1]);			
			document.getElementById(frmActual + "EXP_USUARIO_DESTINO_PASE_STR").setValue(vec[2]);
		}
		
	}
	
	if (TIPO_PASE=="PASE_ELEVACION"){		
		var modal =  ModalController.openWinModal(getUrlApp() + "/expedientes/arbolElevar/armar.jsp?" + TAB_ID_REQUEST, 750, 400, null, null, null, true, true);

		if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
			alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino v�lido.");
			document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue("");			
			document.getElementById(frmActual + "EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue("");		
			document.getElementById(frmActual + "EXP_USUARIO_DESTINO_PASE_STR").setValue("");
			document.getElementById(frmActual + "EXP_NOM_USR_DESTINO_PASE_STR").setValue("");
			document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);
		}else{						
			//alert(sDestino);
			var vec = sDestino.split(sep1);						
			document.getElementById(frmActual + "EXP_OFICINA_DESTINO_PASE_STR").setValue(vec[0]);		
			document.getElementById(frmActual + "EXP_OFICINA_DESTINO_NOMB_PASE_STR").setValue(vec[1]);			
			document.getElementById(frmActual + "EXP_USUARIO_DESTINO_PASE_STR")..setValue(vec[2]);	
		}
		
	}
		
	if(document.getElementById(frmActual + "EXP_OPCION_PASE_STR")!=null){
		document.getElementById(frmActual + "EXP_OPCION_PASE_STR").setValue("");
	}
	





return true; // END
} // END
