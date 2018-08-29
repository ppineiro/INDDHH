
function fnc_1001_1853(evtSource) { 
if (document.getElementById("PR_REPARTIDO_EXPEDIENTE_FLAG_HISTORIA") != null){		
		if (document.getElementById("PR_REPARTIDO_EXPEDIENTE_FLAG_HISTORIA").value != ""){
			//var desktopURL = URL_ROOT_PATH + "/docs/" + document.getElementById("PR_REPARTIDO_EXPEDIENTE_FLAG_HISTORIA").value;
			//document.getElementById("PR_REPARTIDO_EXPEDIENTE_FLAG_HISTORIA").value = "";				
			//var desktop = window.open(desktopURL);
			//desktop.focus();	
			
			var nroExp = document.getElementById("PR_EXPEDIENTE_RESOLUCION_EXP_NRO_EXPEDIENTE_STR").value;			
			var nameArchivo = document.getElementById("PR_REPARTIDO_EXPEDIENTE_FLAG_HISTORIA").value;
			document.getElementById("PR_REPARTIDO_EXPEDIENTE_FLAG_HISTORIA").value = "";		
			verArchivoNotificacion(nroExp, nameArchivo);	
			
		}	
	}



return true; // END
} // END
