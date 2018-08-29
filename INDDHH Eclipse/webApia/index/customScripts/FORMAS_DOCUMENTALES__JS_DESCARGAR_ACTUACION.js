
function fnc_1001_4330(evtSource, par_nombFormulario, par_nombCampoExp, par_nombCampoAct) { 
	var vIndex = evtSource.index; 
	var myForm = ApiaFunctions.getForm(par_nombFormulario);
	var strNroExp = myForm.getFieldColumn(par_nombCampoExp)[vIndex].getValue();

	if(strNroExp != ""){
		var strNroAct = myForm.getFieldColumn(par_nombCampoAct)[vIndex].getValue();
		var nroAct = parseInt(strNroAct);
		var strAct = "";
		if (nroAct == 0){
			strAct = "Caratula-"+strNroExp+".pdf";
		}else{
			strNroAct = nroAct.toString();
			strAct = "Actuacion-"+nroAct+"-"+strNroExp+".pdf";
		}
		strNroExp = encodeBase64(strNroExp);
		verActuacionConsultaActuacion(strNroExp ,strAct);
	}








	return true; // END
} // END
