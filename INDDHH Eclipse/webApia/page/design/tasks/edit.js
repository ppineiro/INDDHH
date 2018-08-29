function initPage() {
	
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	var poolImage = $('poolImage');
	if (poolImage) {
		poolImage.addEvent('click', function(evt) {
			showImagesModal(processModalImageConfirm,null);
		});
	}

	var btnResetImage = $('btnResetImage');
	if(btnResetImage) {
		btnResetImage.addEvent('click', function(evt) {
			var path = CONTEXT + '/images/uploaded/' + POOL_DEFAULT_IMAGE;
			$('poolImage').setStyle('background-image', 'url(' + path + ')');
			$('imgPath').value = POOL_DEFAULT_IMAGE;		
		});
	}
	
	//['btnResetImage', 'btnViewTemplate'].each(setTooltip);
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition(executeBeforeConfirm);	
	initPermissions();
	initDocuments();
	initImgMdlPage();
	
	initTemplateSelection();
	initAdminFav();
	initTabActions();
	initMsgNotificationsMdlPage();
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
	
	$('btnViewTemplate').addEvent("click", function(evt){
		evt.stop();
		
		var cmbTemplate = $('idTemplates');
		var template = "";
				
		if (cmbTemplate.value == "<CUSTOM>"){
			if ($('customTemplate').value == ""){
				showMessage(MSG_ADD_TEMPLATE, GNR_TIT_WARNING, 'modalWarning');
				return;
			} else {
				template = $('customTemplate').value;
			}   		
		} else {
			template = cmbTemplate.value;												
		}
		
		var width = Number.from(frameElement.getParent("body").clientWidth);
		var height = Number.from(frameElement.getParent("body").clientHeight);
		width = (width*80)/100; //80%
		height = (height*80)/100; //80%
		
		var url = TSK_TEMPLATE_PAGE + "?template=" + template + TAB_ID_REQUEST;
		ModalController.openWinModal(url, width, height, undefined, undefined, false, true, false);
	});
	
	initLangMdlPage();
	loadLanguage();
	
	$('addLanguage').addEvent("click", function(e) {
		e.stop();	
		showLanguageModal(processLanguageModalReturn);
	});
	
	resetChangeHighlight();
}

function processModalImageConfirm(image) {
	if (image){
		var poolImage = $('poolImage');
		$('poolImage').setStyle('background-image', 'url(' + image.path + ')');
		$('imgPath').value = image.id;
	}
}

function initTemplateSelection() {
	var idTemplates = $('idTemplates');
	var customTemplate = $('customTemplate');
	
	var divTemplate = $('divTemplate');
	
	idTemplates.customTemplate = customTemplate;
	idTemplates.addEvent('change', function(evt) {
		if ($(this.options[this.selectedIndex]).get("value") == '<CUSTOM>') {
			//agregar requerido
			if (!customTemplate.hasClass("validate['required']")){
				customTemplate.addClass("validate['required']");
			}
			$('frmData').formChecker.register(customTemplate);
			divTemplate.addClass("required");	
			
			this.customTemplate.show();
		
		} else {
			this.customTemplate.hide();
			
			//ocultar requerido
			$('frmData').formChecker.dispose(customTemplate);
			if (divTemplate.hasClass("required")){
				divTemplate.removeClass("required");
			}	
			customTemplate.value = "";			
		}
	});
	
	idTemplates.fireEvent("change");
}

function executeBeforeConfirm(){
	if(!verifyPermissions()){
		return false;
	}
	return executeBeforeConfirmTabActions();
}

function processLanguageModalReturn(ret){
	ret.each(function(e){
		var text = e.getRowContent()[0];	
		addActionElementLanguage($('langContainer'),text,e.getRowId(),"true");
	});
}

function addActionElementLanguage(container, text, id, helper) {
	var repeated = false;
	//primero verificar que no exista
	container.getElements("DIV").each(function(item,index){
		if(item.get("id") == id) {
			repeated = true;
		}
	});
	if(repeated){
		return;
	}
	
	//si no esta, se agrega
	var divElement = new Element('div.option', {
		id: id,
		'data-helper': helper,
		html: text
	});
	//divElement.set("id", id).set("data-helper",helper);
	
	new Element('input',{ type: 'hidden', name : 'chkLanguage', value :id}).inject(divElement);
	new Element('input',{ type: 'hidden', name : 'langName', value :text}).inject(divElement);
 	
	new Element('div.optionRemove').addEvent("click", actionElementAdminClickRemove).inject(divElement);
	
	divElement.container = container;
//	divElement.addClass("optionRemove");
//	divElement.addEvent("click", actionElementAdminClickRemove);
//	divElement.addEvent("mouseenter", actionElementAdminMouseOverToggleClasss);
//	divElement.addEvent("mouseleave", actionElementAdminMouseOverToggleClasss);
	
	divElement.inject(container.getLast(),'before');
	
	return divElement;
}

function loadLanguage(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=getLanguages&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { 
			processXMLLanguage(resXml);
			sp.hide(true);
			initAdminModalHandlerOnChangeHighlight($('langContainer'));
		}
	}).send();
}

function processXMLLanguage(ajaxCallXml) {
	if (ajaxCallXml != null) {
		var langs = ajaxCallXml.getElementsByTagName("languages");
		if (langs != null && langs.length && langs[0] != null) {
			langs = langs[0].getElementsByTagName("language");
			for(var i = 0; i < langs.length; i++) {
				addActionElementLanguage($('langContainer'), langs[i].getAttribute("text"), langs[i].getAttribute("id"), "true");
			}
		}
	}
}