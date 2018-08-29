
function FORMAS_DOCUMENTALES_JS_FIN_MODIFICACION_CARATULA(evtSource) { 

	var form = ApiaFunctions.getForm("FIN_MODIFICACION_CARATULA");
	
	if(form == null){ form = ApiaFunctions.getForm("MODIFICAR_CARATULA"); }
	if(form == null){ form = ApiaFunctions.getForm("FIRMA_MODIFICACION_CARATULA"); }
	
	var ele_inst_id = form.getField("MC_PRO_ELE_INST_ID").getValue();
	var pro_inst_id = form.getField("MC_PRO_INST_ID").getValue();
	
	var url = getUrlApp() + "/apia.execution.TaskAction.run?action=getTask&forceAcquire=true&proInstId=" + pro_inst_id+"&proEleInstId="+ele_inst_id + TAB_ID_REQUEST;
	
	SYS_PANELS.showLoading();
	setTimeout(function() {
		parent.document.location.href = url;
	}, 2000);
	

	return true; // END
	
} // END
