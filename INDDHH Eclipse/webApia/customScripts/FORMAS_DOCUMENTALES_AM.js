
function fnc_1001_2101(evtSource) { 
function getIndex(evtSource){
	var vIndex = evtSource.parentNode.parentNode.rowIndex;
		
	if(vIndex != null){
		vIndex = vIndex - 2;
		if(vIndex < 0){
			alert("Error al obtener el índice");
			vIndex = "0";
		}
	}else{
		vIndex = "0";
	}
		
	return vIndex;
}


var vIndex = evtSource.index;
//var vIndex = 1;
var cKids;
try{	

	if (vIndex==0){
		cKids = evtSource.parentNode.parentNode.parentNode.children;
	}else{
		cKids = evtSource.parentNode.parentNode.children;	
	}

        var nroRepartido  = cKids[5].innerText;

        var nameArchivo = cKids[1].innerText;

        var tipoArchivo  = cKids[4].innerText;

	if(tipoArchivo == 'Resolución'){
	
		verResolucion(nroRepartido, nameArchivo);
	}

	if(tipoArchivo == 'Registro de Infractores'){
		
		verRegistroInfractores(nroRepartido, nameArchivo);
	}

	if(tipoArchivo == 'Nota de Secretaria General'){
		
		verNota(nroRepartido, nameArchivo);

	}

}catch(e){
alert(e.description);
}




return true; // END
} // END
