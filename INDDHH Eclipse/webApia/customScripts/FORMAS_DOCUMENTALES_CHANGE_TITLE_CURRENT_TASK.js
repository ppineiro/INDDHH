
function FORMAS_DOCUMENTALES_CHANGE_TITLE_CURRENT_TASK(evtSource) { 
	// OBTENGO EL TITULO Y LE DOY FORMATO
	var task = ApiaFunctions.getCurrentTaskName();	
	var new_title = "SIN NOMBRE"
	var ejecutar = false;
	
	switch (task){
		case "REALIZAR ACTUACION":
			new_title = $('taskInfoContainer').getElement('div.taskTitle').get('text');
			ejecutar = true;
			break;
	}
	
	if (ejecutar){
		// CARGO EL TITULO EN EL TAB
		var prevFrame = frameElement.getPrevious();
		var i = 0;
		while(prevFrame.hasClass('tabContent')) {
		  prevFrame = prevFrame.getPrevious();
		  i++;
		}
		var subTabContainer = frameElement.contentWindow.parent.$('subTabContainer');
		var tabs = subTabContainer.getChildren('div.tab');
		tabs[i].getElement('span').set('text', new_title);
		
		subTabContainer.setStyle('width', tabs.getWidth().sum() + (i + 1)*7);
	}	
	
	return true; // END
} // END
