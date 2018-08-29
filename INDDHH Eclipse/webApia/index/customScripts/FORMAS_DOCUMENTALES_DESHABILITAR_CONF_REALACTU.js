
function FORMAS_DOCUMENTALES_DESHABILITAR_CONF_REALACTU(evtSource) { 
	
	var tskName = ApiaFunctions.getCurrentTaskName();
	var tabsNoNulls = 0;
	
	var tab1 = ApiaFunctions.getForm("TAB_CARATULA");	
	var tab2 = ApiaFunctions.getForm("TAB_ACTUACIONES");
	var tab3 = ApiaFunctions.getForm("TAB_PASES");
	var tab4 = ApiaFunctions.getForm("TAB_FRM_DOC_FISICA");	
	var tab5 = ApiaFunctions.getForm("TAB_FRM_CONFIDENCIAL");
	var tab6 = ApiaFunctions.getForm("TAB_HISTORIAL");
	var tab7 = ApiaFunctions.getForm("TAB_BALDUCADOS");
	var tab8 = ApiaFunctions.getForm("TAB_RELACIONADOS");
	var tab9 = ApiaFunctions.getForm("TAB_INTEGRACION_PARCIAL");
	var tab10 = ApiaFunctions.getForm("TAB_MODIFICAR_CARATULA");
	
	if (tab1 != null){ tabsNoNulls += 1; }	
	if (tab2 != null){ tabsNoNulls += 1; }	
	if (tab3 != null){ tabsNoNulls += 1; }	
	if (tab4 != null){ tabsNoNulls += 1; }	
	if (tab5 != null){ tabsNoNulls += 1; }	
	if (tab6 != null){ tabsNoNulls += 1; }	
	if (tab7 != null){ tabsNoNulls += 1; }	
	if (tab8 != null){ tabsNoNulls += 1; }	
	if (tab9 != null){ tabsNoNulls += 1; }
	if (tab10 != null){ tabsNoNulls += 1; }
	
	if(tskName == "REALIZAR ACTUACION" && (tabsNoNulls == 1 || tabsNoNulls == 3)){
      document.getElementById("btnConf").style.display = "none";
	}
	

return true; // END
} // END
