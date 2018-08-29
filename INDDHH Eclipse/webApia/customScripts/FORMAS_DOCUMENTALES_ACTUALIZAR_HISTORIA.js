
function fnc_1001_1361(evtSource) { 
	var strAreas = "";
	var strDependencias = "";
	
	var cElems = document.getElementsByTagName('TD');
	var iNumElems = cElems.length;
	
	for (var i=1;i<iNumElems;i++) {
		if (cElems[i].id  == "ACTUACIONES_HISTORIAL_EXP_HIS_ACTUACION_AREA_NUM"){						
			strAreas = strAreas + ";" + cElems[i].innerText;
		}
		
		if (cElems[i].id  == "ACTUACIONES_HISTORIAL_EXP_HIS_ACTUACION_DEPENDENICA_NUM"){						
			strDependencias = strDependencias + ";" + cElems[i].innerText;
		}		
	}
	
	var vecAreas = strAreas.split(";");
	var vecDependencias = strDependencias.split(";");
		
	var index = 1;
	for (var i=1;i<iNumElems;i++) {		
		if (cElems[i].id  == "ACTUACIONES_HISTORIAL_EXP_HIS_ACTUACION_OFICINA_STR"){			
			cElems[i].title = vecDependencias[index] + " / " + vecAreas[index];			
			index = index + 1;
		}
	}
	


return true; // END
} // END
