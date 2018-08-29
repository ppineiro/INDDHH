
function fnc_1001_4235(evtSource) { 
var frmActual = ApiaFunctions.getForm('GRUPOS_TRABAJO_USUARIO');
var indice = evtSource.index;
var boton;
	
msg = "¿Está seguró que desea eliminar el Grupo de Trabajo ?\n";	
		
if(confirm(msg)){
	var frmBtn = ApiaFunctions.getForm('BTN_' + frmActual.getFormName());	
	boton = frmBtn.getFieldColumn('BORRAR_GRUPO_TRABAJO')[indice];
	boton.fireClickEvent();
}
		
return true; // END
} // END
