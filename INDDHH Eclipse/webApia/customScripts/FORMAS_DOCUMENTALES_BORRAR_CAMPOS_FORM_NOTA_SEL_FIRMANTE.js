
function fnc_1001_1685(evtSource, par_par_Nombre_Form) { 
try{
	var formNota = ApiaFunctions.getForm('NOTA_SELECCION_FIRMANTE');
	var fieldUsuario = formNota.getField('NTA_USUARIO_FIRMANTE1_STR');
	var fieldNomOf = formNota.getField('NTA_NOMBRE_OFICINA_USUARIO_FIRMANTE1_STR');
	var fieldOfUsuario = formNota.getField('NTA_OFICINA_USUARIO_FIRMANTE1_STR');
	fieldUsuario.setValue("");
	fieldNomOf.setValue("");
	fieldOfUsuario.setValue("");
} catch ( e)
{
	alert(e.description);
}

return true; // END
} // END
