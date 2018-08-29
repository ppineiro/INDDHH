
function FORMAS_DOCUMENTALES_TC_CONFIRMAR_ACCION(evtSource, par_mensaje, par_formulario, par_boton) { 
	
	var ejecutar = confirm(par_mensaje);
	if (ejecutar) {
	  var myForm = ApiaFunctions.getForm(par_formulario); 
	  var myButton = myForm.getField(par_boton); 
	  myButton.fireClickEvent();
	}


return true; // END
} // END
