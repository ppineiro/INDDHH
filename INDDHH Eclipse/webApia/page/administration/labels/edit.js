function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//Agregar Lenguaje
	$('addLanguage').addEvent("click", function(e) {
		e.stop();
		var defLang = $('defaultLang').value;
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=ajaxUploadStart&isAjax=true&default=' + defLang + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	});	
	
	//Cargar Lenguajes
	loadLanguages();
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition();	
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function loadLanguages(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadLanguages&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { 
			modalProcessXml(resXml); SYS_PANELS.closeAll();
			
			initAdminModalHandlerOnChangeHighlight($('languagesContainter'));
			initAdminRadioButtonOnChangeHighlight($('languagesContainter'), 'langDefault');
		}
	}).send();
}

function processXMLLanguages(ajaxCall){
	var ajaxCallXml = ajaxCall;
	if (!ajaxCallXml){ ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0]; }
	if (ajaxCallXml != null && ajaxCallXml.getElementsByTagName("languages")[0].getElementsByTagName("language")) {
		var languages = ajaxCallXml.getElementsByTagName("languages")[0].getElementsByTagName("language");
		var addLanguage = $('addLanguage');
		for (var i = 0; i < languages.length; i++){
			var xmlLang = languages[i];
			//DIV
			var elemDiv = new Element("div", {'id': xmlLang.getAttribute("id"), html: xmlLang.getAttribute("name"), 'class': 'option'});
			if (xmlLang.getAttribute("remove")) { //REMOVE 
				var removeDiv = new Element('div', {'class': 'optionRemove'}).inject(elemDiv);				
				removeDiv.addEvent('click', function(evt) { 
					var elemDiv = this.getParent();
					removeLang(elemDiv,elemDiv.getId()); 
				});
			} 
			elemDiv.getId = function () { return this.getAttribute("id"); };
			elemDiv.inject(addLanguage,"before")
			//DOWNLOAD
			var elemDown = new Element("div", {'class': 'optionDownload' });
			elemDown.set('title', TT_DOWNLOAD_LANG);
			elemDown.addEvent('click', function(evt) { prepareModalDownload(this.parentNode.getId()); evt.stopPropagation(); });
			elemDown.inject(elemDiv);
			//DEFAULT			
			var elemDef = new Element("input", {'name': "langDefault", 'id': "radio_"+elemDiv.getId(), 'type': "radio"});
			elemDef.addEvent('click', function(evt) { setDefaultLang(this.parentNode.getId()); evt.stopPropagation(); });
			elemDef.set('title', TT_DEFAULT_LANG);
			if (xmlLang.getAttribute("default")){
				elemDef.checked = true;
				setDefaultLang(xmlLang.getAttribute("id"));
			}
			elemDef.inject(elemDiv);			
		}
		
		//Set default si no hay uno seteado
		var defLang = ajaxCallXml.getElementsByTagName("languages")[0].getElementsByTagName("default");
		if (defLang.length > 0){
			var defId = ajaxCallXml.getElementsByTagName("languages")[0].getElementsByTagName("default")[0].getAttribute("id");
			setDefaultLang(defId);
			$("radio_"+defId).checked = true;
		}
			
	}
}

function removeLang(lang,langId){
	var defaultLang = $('defaultLang');
	if (defaultLang.value == langId) { defaultLang.value=""; }
	lang.destroy();
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=removeLang&isAjax=true&id=' + langId + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
	
}

function setDefaultLang(langId){
	$('defaultLang').value = langId;	
}

function prepareModalDownload(langId){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=prepareModalDownload&isAjax=true&id=' + langId + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}

function processModalAddLanguage(){
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];;
	var text = ajaxCallXml.getAttribute("msgToShow");
	var title= ajaxCallXml.getAttribute("name");
	SYS_PANELS.closeAll();
	showMessage(text, title);
	processXMLLanguages(ajaxCallXml);	
}

function startDownload(type, exportAll){
	if (type == "excel"){
		var action = "downloadExcel";
	} else {
		var action = "downloadTxt";
	}	
	sp = new Spinner($('frmData'),{message:WAIT_A_SECOND});
	createDownloadIFrame(TIT_DOWNLOAD,DOWNLOADING,URL_REQUEST_AJAX,action,"&exportAll="+exportAll,"","",null);	
}


