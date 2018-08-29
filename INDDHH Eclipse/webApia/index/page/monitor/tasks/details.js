function initDetailsPage() {
	var btnBack = $('btnBack');
	if(btnBack)
		btnBack.addEvent('click', function(evt){
			SYS_PANELS.showLoading();
			document.location = CONTEXT + URL_REQUEST_AJAX + "?action=back&reset=true"  + TAB_ID_REQUEST;
		});
		
	var btnPrintFrm = $('btnPrint');
	if(btnPrintFrm)
		btnPrintFrm.addEvent('click', function(e){
			if(this.getElement('button') && this.getElement('button').get('disabled'))
				e.stop();
			else
				printForms();
		});
	
	var btnCloseTab = $('btnCloseTab');
	if(btnCloseTab)
		btnCloseTab.addEvent('click', function(e){
			getTabContainerController().removeActiveTab();
		});
	
	
	if (DISABLED){
		var tabComponent = $('tabComponent');
		tabComponent.getElements("input").each(function(input){
    		input.disabled = true;
    		input.readOnly = true;
    		input.addClass("readonly");
    	});
		tabComponent.getElements("textarea").each(function(textarea){
			textarea.disabled = true;
			textarea.readOnly = true;
			textarea.addClass("readonly");
    	});
		tabComponent.getElements("select").each(function(select){
    		select.disabled = true;
    		select.readOnly = true;
    		select.addClass("readonly");
    	});    	
		tabComponent.getElements("div.option").each(function(option){
			option.removeEvents('click');
    	});
		tabComponent.getElements("div.gridButtons.gridButton").each(function(button){
			button.removeEvents('click');
    	});				
	}
}