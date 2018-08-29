
function fnc_1001_1940(evtSource) { 
var myForm = ApiaFunctions.getForm("AT_CREAR_ACTA");
if (myForm.getField("AT_FLAG_HISTORIA") != null){		
		if (myForm.getField("AT_FLAG_HISTORIA").getValue() != ""){
			
			var nroExp = myForm.getField("AT_NUMERO_ACTA").getValue();			
			var nameArchivo = myForm.getField("AT_FLAG_HISTORIA").getValue();
			myForm.getField("AT_FLAG_HISTORIA").getValue() = "";		
			verArchivoNotificacion(nroExp, nameArchivo);	
			
		}	
	}


return true; // END
} // END
