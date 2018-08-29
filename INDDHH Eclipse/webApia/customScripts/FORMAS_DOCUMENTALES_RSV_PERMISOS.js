
function FORMAS_DOCUMENTALES_RSV_PERMISOS(evtSource) { 
var form 		= ApiaFunctions.getForm('FRM_RSV_NRO_RESERVA');
var attTodosChk = 'chkTodos';
var btnName 	= 'btnGrupos';

var checked = form.getField(attTodosChk).getValue();

if (checked){
      form.getField(btnName).setProperty(IProperty.PROPERTY_READONLY, true);
}else {
      form.getField(btnName).setProperty(IProperty.PROPERTY_READONLY, false);
}

return true; // END
} // END
