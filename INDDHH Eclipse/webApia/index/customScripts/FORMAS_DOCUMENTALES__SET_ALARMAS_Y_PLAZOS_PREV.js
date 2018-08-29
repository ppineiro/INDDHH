
function fnc_1001_3971(evtSource, par_nroExp, par_alarmaEjecutada, par_atrasoEjecutado, par_alarmaActEjecutada, par_atrasoActEjecutado) { 
if (par_nroExp.getValue()==null || par_nroExp.getValue()==""){
	alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_SELECCIONE_EXPEDIENTE_JS',currentLanguage)); //alert("Debe seleccionar un expediente primero");
   return false;
}
		
if (par_alarmaEjecutada.getValue()!=null && par_alarmaEjecutada.getValue()=="true" 
          && par_atrasoEjecutado.getValue()!=null && par_atrasoEjecutado.getValue()=="true"
          && par_alarmaActEjecutada.getValue()!=null && par_alarmaActEjecutada.getValue()=="true"
          && par_atrasoActEjecutado.getValue()!=null && par_atrasoActEjecutado.getValue()=="true"){
	alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_NO_GUARDA_CAMBIOS_TODOS_PLAZOS_EJECUTADOS_JS',currentLanguage)); //alert("No se guardaran los cambios, todos los plazos ya fueron ejecutados");
   return false;
}

return true;


return true; // END
} // END
