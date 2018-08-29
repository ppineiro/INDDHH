
function fnc_1001_4086(evtSource) { 
	var form = ApiaFunctions.getForm('FRM_OFICINAS_USUARIO');
	var indice = evtSource.index;
	var boton;

	msg = "Está seguro que desea borrar la oficina ?\n";	
	if(confirm(msg)){
		boton = form.getFieldColumn('BORRAR_OFICINA_OCULTO')[indice];		
		boton.fireClickEvent();
	}
	
	
	
	

return true; // END
} // END
