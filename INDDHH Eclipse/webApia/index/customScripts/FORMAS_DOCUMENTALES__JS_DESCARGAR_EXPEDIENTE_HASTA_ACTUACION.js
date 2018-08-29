
function fnc_1001_4331(evtSource, par_nombFormulario, par_nombCampoExp, par_nombCampoAct) { 
var vIndex = evtSource.index;
var form = ApiaFunctions.getForm(par_nombFormulario);
var strNroExp = form.getFieldColumn(par_nombCampoExp)[vIndex].getValue();
	if(strNroExp != ""){
			var strNroAct = form.getFieldColumn(par_nombCampoAct)[vIndex].getValue();
			var nroAct = parseInt(strNroAct);
		    strNroAct = nroAct.toString();
		    strNroExp = encodeBase64(strNroExp);
			verFoliadoHastaActuacion(strNroExp ,strNroAct);
       	}




return true; // END
} // END
