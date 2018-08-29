
function FORMAS_DOCUMENTALES_SHOW_TAB_5_RA(evtSource) { 
	
	var tarea = ApiaFunctions.getCurrentTaskName();
	
	if(tarea == "REALIZAR ACTUACION" && ApiaFunctions.getForm("TABSBUTTONS")) {
	  
	  var tabsbuttons = ApiaFunctions.getForm("TABSBUTTONS");
	  var tab = tabsbuttons.getField("TAB_A_MOSTRAR").getValue();
	  var historial = tabsbuttons.getField("TAB_MOSTRAR_HISTORIAL").getValue();
	  
	  if(historial == "TRUE" && tab == "hist"){
		  tabsbuttons.getField("TAB_MOSTRAR_HISTORIAL").setValue("FALSE");
		  ApiaFunctions.changeTab(5);			  
	  }	  	
	}
	
	return true; // END
	
} // END
