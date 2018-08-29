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
				printForms(btnPrintFrm.getElement('button'));
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
	
	checkErrors();
}

function checkErrors(){
	
	var xmlDoc;
	if (window.DOMParser) {
		parser = new DOMParser();
		xmlDoc = parser.parseFromString(new String($('execErrors').value),"text/xml");
	} else {
		// Internet Explorer
		xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc.async = false;
		xmlDoc.loadXML(new String($('execErrors').value)); 
	}
	
	var xml;
	if(Browser.ie) {
		for(var iter_e = xmlDoc.childNodes.length - 1; iter_e >= 0; iter_e--) {
			if(xmlDoc.childNodes[iter_e].nodeType != 3) {
				xml = xmlDoc.childNodes[iter_e];
				break;
			}
		}
	} else {
		xml = xmlDoc.childNodes[0];
	}
	
	var hasErrors = false;
	var hasExceptions = false;
	if(xml && xml.childNodes) {
		for(var i = 0; i < xml.childNodes.length; i++) {
			if (xml.childNodes[i].tagName == "sysExceptions") {
				processXmlExceptions(xml.childNodes[i], true);
				hasErrors = true;
				hasExceptions = true;
			}
			
			if (xml.childNodes[i].tagName == "sysMessages" && !hasExceptions) {
				processXmlMessages(xml.childNodes[i], true);
				hasErrors = true;
			}
		}
	}
	$('execErrors').value  = "<?xml version='1.0' encoding='iso-8859-1'?><data onClose='' />";
	
	return hasErrors;
}