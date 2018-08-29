
function FORMAS_DOCUMENTALES_CARGAR_DATOS_USUARIO(evtSource, par_idProcesoOculto, par_nombFormularioActual) { 
	
	var frmActual = ApiaFunctions.getForm('NODO_DISTRIBUCION_USR_MODIF');
	var mdl_return = ApiaFunctions.getLastModalReturn();
	frmActual.getField("ND_USR_OFICINA_STR").setValue(mdl_return[5]);	
	frmActual.getField("ND_USR_OFICINA_CODE_STR").setValue(mdl_return[6]);


return true; // END
} // END
