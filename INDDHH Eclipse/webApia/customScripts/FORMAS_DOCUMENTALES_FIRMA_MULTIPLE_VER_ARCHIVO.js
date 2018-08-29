
function FORMAS_DOCUMENTALES_FIRMA_MULTIPLE_VER_ARCHIVO(evtSource) { 
var vIndex = evtSource.index;
var myForm = ApiaFunctions.getForm("FIRMA_MULTIPLE_SELECCION_FIRMAS");	
	var nroExp = myForm.getFieldColumn('FIRMA_MULTIPLE_NRO_EXPEDIENTE_B64_STR')[vIndex].getValue();
	
	//var cKids;
	var nameArchivo = '';

	if (vIndex>=0) {
		var campo = myForm.getFieldColumn('FIRMA_MULTIPLE_NOMBRE_DOCUMENTO_B64_STR')[vIndex];
		if(campo!=null && campo.getValue()!=null && campo.getValue()!=''){
			nameArchivo = campo.getValue();
			if (nameArchivo.indexOf('width')>0){
				nameArchivo = nameArchivo.split("width")[0];
			}
			if (nameArchivo.indexOf("Actuacion-")==-1){	
				verArchivo(nroExp, nameArchivo);
			}else{		
				verActuacion(nroExp, nameArchivo);
			}


		}
	}else{
		alert('Descomentar código');
	}
return true; // END
} // END
