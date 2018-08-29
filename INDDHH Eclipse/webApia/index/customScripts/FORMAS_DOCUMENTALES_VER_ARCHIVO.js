
function FORMAS_DOCUMENTALES_VER_ARCHIVO(evtSource) { 
	var myForm = ApiaFunctions.getForm("ACTUACIONES_HISTORIAL");
	var nroExp = myForm.getField("EXP_NRO_EXPEDIENTE_STR").getValue();
	nroExp = encodeBase64(nroExp);
	var vIndex = evtSource.index;	
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
				verArchivo(nroExp, encodeBase64(nameArchivo));
			}else{						
				verActuacion(nroExp, encodeBase64(nameArchivo));
			}


		}
	}else{
		alert('Descomentar c�digo');
	}

	/*if (vIndex==0){		
		//cKids = evtSource.parentNode.parentNode.parentNode.children;
	}else{
		cKids = evtSource.parentNode.parentNode.children;	
	}*/
	
	
	/*for (var i=0;i<cKids.length;i++){
		//if (sTagName == cKids[i].innerHTML) return cKids[i];
		//alert(i + " - " + cKids[i].innerHTML);   
	}*/
	
	
	//alert(nroExp);	
	//var nameArchivo = cKids[1].getAttribute("value");
	
	/*if (nameArchivo.indexOf('width')>0){
		nameArchivo = nameArchivo.split("width")[0];
	}
	alert(nameArchivo);
	if (nameArchivo.indexOf("Actuacion-")==-1){	
		verArchivo(nroExp, nameArchivo);
	}else{		
		verActuacion(nroExp, nameArchivo);
	}*/	
				



return true; // END
} // END
