
function fnc_1001_4234(evtSource) { 
var frmActual = ApiaFunctions.getForm('FRM_PERMISOS_USUARIO');
var indice = evtSource.index;
var boton;
	
msg = "¿ Está seguro que desea borrar el Rol Organizacional ?\n";	

if(confirm(msg)){	
	var frmBtn = ApiaFunctions.getForm('BTN_' + frmActual.getFormName());
	boton = frmBtn.getFieldColumn('BORRAR_PERMISO')[indice];
    boton.click();
}


return true; // END
} // END
