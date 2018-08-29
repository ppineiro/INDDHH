
function fnc_1001_4236(evtSource) { 
var frmActual = ApiaFunctions.getForm('MESA_ENTRADA_USUARIO');
var indice = evtSource.index;
var boton;
	
msg = "¿Está seguró que desea eliminar la Mesa de Entrada ?\n";	
if(confirm(msg)){
     formBtn = ApiaFunctions.getForm('BTN_' + frmActual.getFormName());	 
	 boton = formBtn.getFieldColumn('BTN_BORRAR_MESA')[indice];
     boton.fireClickEvent();
}


return true; // END
} // END
