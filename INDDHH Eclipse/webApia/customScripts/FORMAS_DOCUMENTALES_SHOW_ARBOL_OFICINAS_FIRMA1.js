
function fnc_1001_1432(evtSource) { 
	try{
		var frmActual = "NOTA_SELECCION_FIRMANTE_";
		var sep1 = document.getElementById(frmActual + "EXP_TMP_SEP1").getValue();
		
		var entro=false;
		var TIPO_PASE;
		
	
		var cElems = document.getElementsByTagName('INPUT');
		var iNumElems = cElems.length;
		for (var i=1;i<iNumElems;i++) {		
			if (cElems[i].id  == frmActual +"NTA_PROXIMO_PASO_FIRMA1_STR"){			
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
			}
		}	
		
		if (TIPO_PASE=="PASE_INTERNO"){
			var sDestino =  ModalController.openWinModal(getUrlApp() + "/expedientes/arbolDestino/armar.jsp?" + TAB_ID_REQUEST, 1050, 400, null, null, null, true, true);

			
			modal.onclose=function(){
				var sDestino=this.returnValue;
				if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
					alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino válido.");
					document.getElementById(frmActual + "NTA_OFICINA_USUARIO_FIRMANTE1_STR").setValue("");			
					document.getElementById(frmActual + "NTA_NOMBRE_OFICINA_USUARIO_FIRMANTE1_STR").setValue("");			
					document.getElementById(frmActual + "NTA_USUARIO_FIRMANTE1_STR").setValue("");
				}
				else{							
					var vec = sDestino.split(sep1);						
					document.getElementById(frmActual + "NTA_OFICINA_USUARIO_FIRMANTE1_STR").setValue(vec[0]);			
					document.getElementById(frmActual + "NTA_NOMBRE_OFICINA_USUARIO_FIRMANTE1_STR").setValue(vec[1]);			
					document.getElementById(frmActual + "NTA_USUARIO_FIRMANTE1_STR").setValue(vec[2])					
				}	
			}
		}	
	
		
		if (TIPO_PASE=="PASE_EXTERNO"){	
			var modal =  ModalController.openWinModal(getUrlApp() + "/expedientes/arbolDestino/armar.jsp?" + TAB_ID_REQUEST, 1050, 400, null, null, null, true, true);

			
			modal.onclose=function(){
				var sDestino=this.returnValue;
				if (sDestino == 'cancel' || sDestino == '' || sDestino == null){
					alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_DESTINO_NO_VALIDO',currentLanguage)); //alert("No se ha elegido un destino válido.");
					document.getElementById(frmActual + "NTA_OFICINA_USUARIO_FIRMANTE1_STR").setValue("");			
					document.getElementById(frmActual + "NTA_NOMBRE_OFICINA_USUARIO_FIRMANTE1_STR").setValue("");		
					document.getElementById(frmActual + "NTA_USUARIO_FIRMANTE1_STR").setValue("");
				}
				else{	
		
					var vec = sDestino.split(sep1);						
					document.getElementById(frmActual + "NTA_OFICINA_USUARIO_FIRMANTE1_STR").setValue(vec[0]);		
					document.getElementById(frmActual + "NTA_NOMBRE_OFICINA_USUARIO_FIRMANTE1_STR").setValue(vec[1]);		
					document.getElementById(frmActual + "NTA_USUARIO_FIRMANTE1_STR").setValue(vec[2]);	
				}
			}
		}	
		}catch(e){
			alert(e);
		}

return true; // END
} // END
