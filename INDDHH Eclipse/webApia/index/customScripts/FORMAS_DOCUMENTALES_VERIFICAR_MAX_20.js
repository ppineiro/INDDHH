
function fnc_1001_3891(evtSource) { 
var form = ApiaFunctions.getForm('EXPEDIENTES_A_PASAR');

var field = 'PM_SELECCIONAR_EXP';

var column = form.getFieldColumn(field);
var cont = 0;
	for (var i = 0; i < column.length-1;i++) {
		
		if (column[i].getValue() == true) {
			cont++;			
		}
	}

if(cont>20){
	alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_SELECCIONAR_TOPE_EXP_PM_JS',currentLanguage)); //alert('No pueden seleccionarse más de 20 elementos');
var index = evtSource.index;
column[index].setValue(false);
}
return true; // END
} // END
