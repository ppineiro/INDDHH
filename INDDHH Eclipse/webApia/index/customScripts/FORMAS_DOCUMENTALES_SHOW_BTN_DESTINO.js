
function fnc_1001_1073(evtSource) { 
	try{
		var frmActual = "PROXIMO_PASO_";
		var attProximoPaso = "EXP_PROXIMO_PASO_STR";
		var usuarioFirmante = "EXP_USUARIO_DESTINO_PASE_STR";
		//Permite la reutilización de la clase en otros formularios sin afectar
		//el funcionamiento para PROXIMO_PASO	
		if(document.getElementById('divTitFrmOFICIO_PROXIMO_PASO')!=null) {
			frmActual = 'OFICIO_PROXIMO_PASO_';
		}
		else if(document.getElementById('divTitFrmMEMO_PROXIMO_PASO')!=null) {
			frmActual = 'MEMO_PROXIMO_PASO_';
		}
		else if(document.getElementById('divTitFrmNOTA_SELECCION_FIRMANTE')!=null) {
			frmActual = 'NOTA_SELECCION_FIRMANTE_';
			attProximoPaso = "NTA_PROXIMO_PASO_FIRMA1_STR";
			usuarioFirmante = "NTA_USUARIO_FIRMANTE1_STR";
		}
		
		var entro=false;
		var cElems = document.getElementsByTagName('INPUT');
		var iNumElems = cElems.length;
		
		
		for (var i=1;i<iNumElems;i++) {		
			if (cElems[i].id  == frmActual + attProximoPaso){
				//alert(cElems[i].id + " - " + cElems[i].name + " - " + cElems[i].value);
				if (cElems[i].getValue() == "PASE_INTERNO"){				
					if (cElems[i].getValue()){
						entro=true;
						//alert("PASE_INTERNO: " + document.getElementById("BTN_" + frmActual +  + "ELEGIR_DESTINO").value);
						document.getElementById("BTN_" + frmActual + "ELEGIR_DESTINO").setProperty(IProperty.PROPERTY_READONLY, false);
						//document.getElementById(frmActual + usuarioFirmante).value = "";
					} 
				}
				if (cElems[i].getValue() == "PASE_EXTERNO"){			
					if (cElems[i].getValue()){
						entro=true;
						//alert("PASE_EXTERNO: " + document.getElementById("BTN_" + frmActual + "ELEGIR_DESTINO").value);
						document.getElementById("BTN_" + frmActual + "ELEGIR_DESTINO").setProperty(IProperty.PROPERTY_READONLY, false);
						document.getElementById(frmActual + usuarioFirmante).setValue("");	
					}
				}			
				if (cElems[i].getValue() == "PASE_MULTIPLE"){				
					if (cElems[i].getValue()){
						entro=true;
						//alert("PASE_EXTERNO: " + document.getElementById("BTN_" + frmActual + "ELEGIR_DESTINO").value);
						document.getElementById("BTN_" + frmActual + "ELEGIR_DESTINO").setProperty(IProperty.PROPERTY_READONLY, false);
						document.getElementById(frmActual + usuarioFirmante).setValue("");	
					}
				}
				if (cElems[i].getValue() == "PASE_GRUPO_TRABAJO"){				
					if (cElems[i].getValue()){
						entro=true;
						//alert("PASE_EXTERNO: " + document.getElementById("BTN_" + frmActual + "ELEGIR_DESTINO").value);
						document.getElementById("BTN_" + frmActual + "ELEGIR_DESTINO").setProperty(IProperty.PROPERTY_READONLY, false);
						document.getElementById(frmActual + usuarioFirmante).setValue("");					
					}
				}
				if (cElems[i].getValue() == "REALIZAR_ACTUACION"){				
					//alert("REALIZAR_ACTUACION: " + document.getElementById("BTN_" + frmActual + "ELEGIR_DESTINO").value);
					if (cElems[i].getValue()){
						//alert("REALIZAR_ACTUACION: " + document.getElementById("BTN_" + frmActual + "ELEGIR_DESTINO").value);
						document.getElementById("BTN_" + frmActual +  "ELEGIR_DESTINO").setProperty(IProperty.PROPERTY_READONLY, true);
						document.getElementById(frmActual + usuarioFirmante).setValue(LOGGED_USER);
					}else{
						if (!entro){
							cElems[i].setValue(true);
							//alert("REALIZAR_ACTUACION: " + document.getElementById("BTN_" + frmActual + ELEGIR_DESTINO").value);
							document.getElementById("BTN_PROXIMO_PASO_ELEGIR_DESTINO").setProperty(IProperty.PROPERTY_READONLY, true);
							document.getElementById(frmActual + usuarioFirmante).setValue(LOGGED_USER);
						}
					}
				}						
			}
		}
	}catch(e)	{
		alert(e);
	}

return true; // END
} // END
