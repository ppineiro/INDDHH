function initPage() {
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//Generar Documentacion
	$('btnGenerate').addEvent('click', function(e){
		e.stop();
		
		var form = $('frmData');
		if(!form.formChecker.isFormValid()){ return; }
		var params = getFormParametersToSend(form);		
		
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=generateDocumentation&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send(params);				
	});
	
	initAdminFav();
	initAdminActionsEdition();
}

function showHideCustomTemplate(cmb){
	var docCustTemplate = $('docCustTemplate');
	var custTemplate = $('custTemplate');
	if (cmb.value == CUSTOM_TEMPLATE){
		docCustTemplate.value = "";
		custTemplate.setStyle("display","");
	} else {
		custTemplate.setStyle("display","none");
		docCustTemplate.value = "null";
	}
}

function startDownload(){
	createDownloadIFrame(LBL_DOCUMENTATION,DOWNLOADING,URL_REQUEST_AJAX,"downloadDocumentation","","","",null);
}
