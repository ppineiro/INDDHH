
function INDDHH_JS_RETOMA_COESYS(evtSource) { 
var myForm = ApiaFunctions.getForm('TRM_TITULO');

if (myForm != null) {
	var field = myForm.getField('TRM_COD_TRAMITE_STR');
	var codTramite = field.getValue();

	var field = myForm.getField('TRM_VISIBILIDAD_STR');
	var visibilidad = field.getValue();

	var field = myForm.getField('TRM_ACCESO_EXTERNO_STR');
	var externo = field.getValue();

	var field = myForm.getField('TRM_COD_UNICO_STR');
	var codUnico = field.getValue();
	
	var modoAut= myForm.getField("TRM_MODO_AUTENTICACION_STR").getValue();
	
	if (visibilidad != '1' || CURRENT_USER_LOGIN != 'guest') {
	    //parent.parent.document.location.href = CONTEXT + '/portal/linkCoesys.jsp?cod_tramite='+codTramite;
		//EXTERNAL_ACCESS="true";
		if (externo=='true') {
		    parent.parent.document.location.href = CONTEXT + '/portal/tramite.jsp?id='+codUnico+"&modoAut=" + modoAut;
		}
	}
}


return true; // END
} // END
