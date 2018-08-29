
function fnc_1001_4067(evtSource) { 
var vIndex = evtSource.index;
var myForm = ApiaFunctions.getForm("CONSULTA_ACTUACIONES_HISTORIAL";	
	var nroExp = myForm.getFieldColumn('CAH_NRO_EXPEDIENTE_TMP_STR')[vIndex].getValue();
	
	//var cKids;
	var nameArchivo = '';

	if (vIndex>=0) {
		var campo = myForm.getFieldColumn('EXP_HIS_TMP_ARCHIVO_NOMBRE_STR')[vIndex];
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
