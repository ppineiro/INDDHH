
function fnc_1001_2095(evtSource) { 
var nroRepartido = document.getElementById("PR_EXPEDIENTE_PR_IDENTIFICADOR").getValue();
		
var nameArchivo = document.getElementById("PR_EXPEDIENTE_PR_UBICACION_RESOLUCION").getValue();
	
verResolucion(nroRepartido, nameArchivo);

return true; // END
} // END
