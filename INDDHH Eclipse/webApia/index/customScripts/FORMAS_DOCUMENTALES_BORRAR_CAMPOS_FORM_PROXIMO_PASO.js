
function fnc_1001_1684(evtSource, par_Nombre_Form) { 
try{
	var form = ApiaFunctions.getForm(par_Nombre_Form);
	var fieldUDP = form.getField('EXP_USUARIO_DESTINO_PASE_STR');
	fieldUDP.setValue("");	
	var fieldODNP = form.getField('EXP_OFICINA_DESTINO_NOMB_PASE_STR');
	fieldODNP.setValue("");	
	var fieldODP = form.getField('EXP_OFICINA_DESTINO_PASE_STR');
	fieldODP.setValue("");	
} catch ( e)
{
	alert(e.description);
}


return true; // END
} // END
