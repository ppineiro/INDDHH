
function FORMAS_DOCUMENTALES__PLAZOS_NOT_GRUPOS(evtSource, par_for) { 
	var index = evtSource.index;
	var form = ApiaFunctions.getForm('MANT_TIPO_EXPEDIENTE_PLAZOS');
	var attName = 'PLAZO_GRUPO_STR';
	var forType = par_for;

	if (forType != "TIPO_EXP"){
		form = ApiaFunctions.getForm('MANT_TIPO_ACTUACION_PLAZOS');
	}

	var pools = form.getFieldColumn(attName)[index];
	
	var URL = getUrlApp() + "/expedientes/notificationPools.jsp?pools="+pools.getValue() + TAB_ID_REQUEST;

	var modal = ModalController.openWinModal(URL, 600, 425, null, null, true, false, false);
	
	modal.addEvent('confirm', function(resultado) {
		if (resultado!=null){
			var attPools = form.getFieldColumn(attName)[index];
			attPools.setValue(resultado);
		}
	});  
	
	/*
	var doAfter=function(modal){
		   if (modal!=null){              
				  var attPools = form.getFieldColumn(attName)[index];
				  attPools.setValue(modal);
		   }
	}
    
	modal.onclose=function(){
			 doAfter(rets.returnValue);
	}
	*/

return true; // END
} // END
