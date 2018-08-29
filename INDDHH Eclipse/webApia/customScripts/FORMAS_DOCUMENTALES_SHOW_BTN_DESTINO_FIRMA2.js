
function fnc_1001_1439(evtSource) { 
var frmActual = "NOTA_SELECCION_FIRMANTE_SECUNDARIO_";
	
	
	var entro=false;
	var cElems = document.getElementsByTagName('INPUT');
	var iNumElems = cElems.length;
	for (var i=1;i<iNumElems;i++) {		
		if (cElems[i].id  == frmActual + "NTA_PROXIMO_PASO_FIRMA2_STR"){
			//alert(cElems[i].id + " - " + cElems[i].name + " - " + cElems[i].value);
			if (cElems[i].getValue() == "PASE_INTERNO"){				
				if (cElems[i].getValue()){
					entro=true;
					//alert("PASE_INTERNO: " + document.getElementById("BTN_" + frmActual +  + "ELEGIR_DESTINO").value);
					document.getElementById("BTN_" + frmActual + "ELEGIR_DESTINO").setProperty(IProperty.PROPERTY_READONLY, false);
					document.getElementById(frmActual + "NTA_USUARIO_FIRMANTE2_STR").setValue("");
				} 
			}
			if (cElems[i].getValue() == "PASE_EXTERNO"){				
				if (cElems[i].getValue()){
					entro=true;
					//alert("PASE_EXTERNO: " + document.getElementById("BTN_" + frmActual + "ELEGIR_DESTINO").value);
					document.getElementById("BTN_" + frmActual + "ELEGIR_DESTINO").setProperty(IProperty.PROPERTY_READONLY, false);
					document.getElementById(frmActual + "NTA_USUARIO_FIRMANTE2_STR").setValue("");
				}
			}					
		}
	}
	


return true; // END
} // END
