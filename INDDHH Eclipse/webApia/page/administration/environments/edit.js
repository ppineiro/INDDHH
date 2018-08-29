function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//Lenguajes
	loadLanguages();
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition();	
	ADDITIONAL_INFO_IN_TABLE_DATA = false;
	initDocuments();
	initAdminFav();
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function loadLanguages(lblId){
	var id = "";
	if (lblId){ id = "&id=" + lblId; }
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadXMLLanguages&isAjax=true' + id + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); SYS_PANELS.closeAll(); }
	}).send();	
}

function processXMLLblLanguages(){
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];
	if (ajaxCallXml != null && ajaxCallXml.getElementsByTagName("labelsLanguages")[0].getElementsByTagName("lblSet")) {
		var xmlLblSet = ajaxCallXml.getElementsByTagName("labelsLanguages")[0].getElementsByTagName("lblSet")[0];
		$('cmbLbl').value = xmlLblSet.getAttribute("id");
	}	
	if (ajaxCallXml != null && ajaxCallXml.getElementsByTagName("labelsLanguages")[0].getElementsByTagName("languages")[0].getElementsByTagName("language")) {
		var languages = ajaxCallXml.getElementsByTagName("labelsLanguages")[0].getElementsByTagName("languages")[0].getElementsByTagName("language");
		var cmbLang = $('cmbLang');
		cmbLang.innerHTML = "";
		cmbLang.selectedIndex = 0;
		for(var i = 0; i < languages.length; i++){
			var xmlLang = languages[i];
			cmbLang[i] = new Option(xmlLang.getAttribute("name"),xmlLang.getAttribute("value"));
			if (xmlLang.getAttribute("selected") == "true"){
				cmbLang.selectedIndex = i;
			}
		}
	}
}


	