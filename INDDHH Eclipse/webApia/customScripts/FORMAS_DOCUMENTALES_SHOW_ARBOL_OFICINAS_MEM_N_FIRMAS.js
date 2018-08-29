
function fnc_1001_2008(evtSource) { 
	var frmActual = "MEMO_PROXIMO_PASO_";

	document.getElementById(frmActual+"MEM_ULTIMO_BOTON_PRESIONADO_STR").setValue("arbolentero");
    if (document.getElementById(frmActual + "MEM_VARIOS_FIRMANTES_STR").getValue() == "2")//Elegio que hay multiples firmantes (2)
    {
			var sep1 = document.getElementById(frmActual + "EXP_TMP_SEP1").getValue();
			var sep2 = document.getElementById(frmActual + "EXP_TMP_SEP2").getValue();
			var usuOrigen = document.getElementById("MEMO_DATOS_" + "MEM_USUARIO_CREADOR_STR",0).getValue();
			
			var entro=false;
			var TIPO_PASE = "PASE_PARA_FIRMA";
			
			if (TIPO_PASE=="PASE_PARA_FIRMA"){
				//if (document.getElementById(frmActual + "EXP_USUARIOS_EN_GRILLA_STR").value==""){
					var URL = getUrlApp() + "/expedientes/arbolDestinoMultipleConUsuarios/armar.jsp?";
					window.status = URL;						
					var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1050, 400, null, null, null, true, true);

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
							sDestino = sacarSeperadorDeLosExtremos(sDestino, sep2);
							sDestino = sDestino  +  sep2 + usuOrigen;
							document.getElementById(frmActual + "EXP_DESTINATARIO_PASE_PARA_FIRMA_STR").setValue(sDestino);
							document.getElementById(frmActual + "EXP_USUARIOS_EN_GRILLA_STR").setValue("EN PROCESO");
							fireEvent(document.getElementById("BTN_" +frmActual+ "CARGAR_USUARIOS"),"click");		
							document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);								
						}
					}
				}
			//} 
		
			if(document.getElementById(frmActual + "EXP_OPCION_PASE_STR")!=null){
				document.getElementById(frmActual + "EXP_OPCION_PASE_STR").setValue("");
			}
		}

return true; // END
} // END
