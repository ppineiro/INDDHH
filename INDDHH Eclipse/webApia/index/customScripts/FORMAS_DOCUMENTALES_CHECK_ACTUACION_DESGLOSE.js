
function fnc_1001_1556(evtSource) { 
	var vIndex = evtSource.index;
	var form = ApiaFunctions.getForm('DESGLOSE_SEL_EXPEDIENTE');	
	strTipoAct = form.getFieldColumn('DSGL_TPO_ACT_GRD')[vIndex].getValue();	
	strFirmante = form.getFieldColumn('DSGL_FIRMANTE_GRD')[vIndex].getValue();		
	strPagDesde = form.getFieldColumn('DSGL_PAG_INI_GRD')[vIndex].getValue();		
	strPagHasta = form.getFieldColumn('DSGL_PAG_FIN_GRD')[vIndex].getValue();
			
	if(strFirmante == ""){
		alert("Selección inválida");
		return false;
	}
	
	if(strTipoAct.search(/^ag\b/i) == 0){
		alert("Las actuaciones autogeneradas no pueden ser desglosadas");
		return false;
	}
	
	if(strPagDesde == "0" && strPagHasta == "0"){
		alert("Las actuaciones migradas no pueden ser desglosadas");
		return false;
	}
	
	if (document.getElementById("samplesTab")!=null){	
		document.getElementById("samplesTab").showContent(2);
	}
	return true; // END

return true; // END
} // END
