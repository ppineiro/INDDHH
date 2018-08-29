
function FORMAS_DOCUMENTALES_RSV_ONLOAD(evtSource) { 
var form 			= ApiaFunctions.getForm('FRM_RSV_NRO_RESERVA');
var attTodosChk 	= 'chkTodos';
var attGrupos 		= 'RSV_NRO_EXP_PERM_GRUPOS';
var attNotificar 	= 'RSV_NRO_EXP_NOTIFICAR';
var attNotPorMail 	= 'RSV_NRO_EXP_NOT_POR_MAIL';
var attNotPorMsg	= 'RSV_NRO_EXP_NOT_POR_MSG';
var attNotGrupos	= 'RSV_NRO_EXP_NOT_GRUPOS';
var btnName			= 'btnGrupos';
var btnNotGruName 	= 'btnGruNot';

if ("" == form.getField(attGrupos).getValue()){
	form.getField(attTodosChk).setValue(true);
    form.getField(btnName).setProperty(IProperty.PROPERTY_READONLY, true);
}

if ("" == form.getField(attNotGrupos).getValue()){
    form.getField(btnNotGruName).setProperty(IProperty.PROPERTY_READONLY, true);
}

if (form.getField(attNotificar).getValue()){
	form.getField(attNotPorMail).setProperty(IProperty.PROPERTY_READONLY, false);
	form.getField(attNotPorMsg).setProperty(IProperty.PROPERTY_READONLY, false);
    form.getField(btnNotGruName).setProperty(IProperty.PROPERTY_READONLY, false);
}

return true; // END
} // END
