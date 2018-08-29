
function FORMAS_DOCUMENTALES_VER_PRIORIDADES(evtSource) { 
	var index 		= evtSource.index;
	var form 		= ApiaFunctions.getForm("FRM_MANT_PRIORIDADES");
	var sep1	 	= form.getField('EXP_TMP_SEP1').getValue();
	var URL 		= getUrlApp() + "/expedientes/prioridad/armar.jsp?"+TAB_ID_REQUEST;
	window.status	= URL;
	var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 600, 500);
	
	modal.setearDestino = function(sDestino) {			  
		  if (sDestino == 'undefined' ||sDestino == 'cancel' || sDestino == '' || sDestino == null){
		      form.getFieldColumn('MPRIO_NOMBRE_IMAGEN_PRIORIDAD_STR')[index].setValue('');		      		      
		  }else{      
		      var vec = sDestino.split(sep1);
		      form.getFieldColumn('MPRIO_NOMBRE_IMAGEN_PRIORIDAD_STR')[index].setValue(vec[1]);		      
		  }		  		 
		  var boton = form.getField("BTN_REFRESH_PRIORIDAD");
		  boton.fireClickEvent();
	}
			
	return true; // END
} // END
