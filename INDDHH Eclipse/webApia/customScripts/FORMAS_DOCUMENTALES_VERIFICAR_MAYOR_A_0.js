
function FORMAS_DOCUMENTALES_VERIFICAR_MAYOR_A_0(evtSource, par_form, par_campo, par_esgrid) { 
	var form = ApiaFunctions.getForm(par_form);
	if(par_esgrid == 'N'){
		if(form.getField(par_campo)!=null){
			var valor = form.getField(par_campo).getValue();
			if(valor!= null && valor != ''  && parseFloat(valor)<0){
				form.getField(par_campo).setValue('');
				alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_INGRESAR_NRO_POSITIVO_JS',currentLanguage)); //alert('Debe ingresar un número positivo');
			}

		}
	}else{

		var i = evtSource.index;
		if(form.getFieldColumn(par_campo)[i]!=null){
			var valor = form.getFieldColumn(par_campo)[i].getValue();
			if(valor!= null && valor != ''  && parseFloat(valor)<0){
				form.getFieldColumn(par_campo)[i].setValue('');
				alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_INGRESAR_NRO_POSITIVO_JS',currentLanguage)); //alert('Debe ingresar un número positivo');
			}
		}
	}






return true; // END
} // END
