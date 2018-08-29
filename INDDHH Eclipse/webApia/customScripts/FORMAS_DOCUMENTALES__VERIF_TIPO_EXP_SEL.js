
function fnc_1001_3970(evtSource, par_tipoExp) { 
if (par_tipoExp.getValue()==null || "" == par_tipoExp.getValue()) {
	alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_SELECCIONAR_TIPO_EXPEDIENTE_JS',currentLanguage)); // alert("Debe seleccionar un tipo de expediente primero.");
    var form = ApiaFunctions.getForm('PLAZOS_Y_ALARMAS');
	var grid = form.getField('gridPlazos');
	grid.clearGrid();		
}
return true; // END
} // END
