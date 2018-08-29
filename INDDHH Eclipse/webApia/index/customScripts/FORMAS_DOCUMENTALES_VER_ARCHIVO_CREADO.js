
function fnc_1001_2100(evtSource) { 
var vIndex = evtSource.index;	
var cKids;
try{	
	if (vIndex==0){
		cKids = evtSource.parentNode.parentNode.parentNode.children;
	}else{
		cKids = evtSource.parentNode.parentNode.children;	
	}

        var nroRepartido  = cKids[5].innerHTML;

        var nameArchivo = cKids[1].innerHTML;

        var tipoArchivo  = cKids[4].innerHTML;

	if(tipoArchivo == 'Resolución'){
		verResolucion(nroRepartido, nameArchivo);
	}

	if(tipoArchivo == 'Registro de Infractores'){
		verRegistroInfractores(nroRepartido, nameArchivo);
	}

	if(tipoArchivo == 'Nota para Registro de Infractores' || 
	tipoArchivo == 'Nota' ||
	tipoArchivo == 'Nota de Resolución' ||
	tipoArchivo == 'Nota de Secretaria General'){

		verNota(nroRepartido, nameArchivo);

	}

}catch(e){
	alert(e);
}




return true; // END
} // END
