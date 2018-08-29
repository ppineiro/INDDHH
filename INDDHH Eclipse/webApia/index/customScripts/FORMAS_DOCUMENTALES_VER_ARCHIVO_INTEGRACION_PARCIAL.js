
function fnc_1001_3893(evtSource, par_form, par_nroExp, par_nomArch) { 

	//var nroExp = document.getElementById(par_form+'_'+par_nroExp).getAttribute("value");
	var myForm = ApiaFunctions.getForm(par_form);
	var nroExp = myForm.getField(par_nroExp).getValue();
	var vIndex = evtSource.index;	
	var nameArchivo = '';
	if (vIndex>=0) {
		var campo = myForm.getFieldColumn(par_nomArch)[vIndex];
		if(campo!=null && campo.getValue()!=null && campo.getValue()!=''){
			nameArchivo = campo.getValue();
			if (nameArchivo.indexOf('width')>0){
				nameArchivo = nameArchivo.split("width")[0];
			}
			verArchivo(nroExp, nameArchivo);

		}
	}

return true; // END
} // END
