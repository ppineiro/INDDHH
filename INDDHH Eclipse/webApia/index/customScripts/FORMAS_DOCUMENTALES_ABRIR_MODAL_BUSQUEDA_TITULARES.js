
function fnc_1001_4072(evtSource) { 

var index = evtSource.index;
var form = ApiaFunctions.getForm('CARATULA');
var field = form.getFieldColumn('EXP_QRY_BUSQUEDA_TITULARES_STR')[index];
var lupa = field.nextSibling;
lupa.onclick();

	//var field = getFieldByIndex('CARATULA', 'EXP_TIPO_TITULAR_ENUM', index);
	//	var URL = getUrlApp() + "/expedientes/tipoTitulares/consultaTipoTitulares.jsp?tipoTitular='" + field.value + "'";
	//	window.status = URL;		
	//	var modal = xShowModalDialog( URL,"","dialogWidth:850px; dialogHeight:850px;status=no" );
	//	modal.onclose=function(){
	//	}

return true; // END
} // END
