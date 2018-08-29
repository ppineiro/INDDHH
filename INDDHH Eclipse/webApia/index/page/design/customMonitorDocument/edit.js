function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//Cambiar imagen
	$('changeImg').addEvent("click", function(evt){
		evt.stop();
		showImagesModal(processModalImageConfirm);		
	});
	//Reiniciar imagen
	$('btnResetImg').addEvent("click", function(evt){
		evt.stop();
		var txtPathImg = $('imgPath');
		var changeImg = $('changeImg'); 
		changeImg.style.backgroundImage = "url('"+CONTEXT + "/" + PATH_IMG + DEFAULT_IMG+"')";
		txtPathImg.value = DEFAULT_IMG;
	});
	
	//Init Tabs
	initTabFilters();
	initTabFiltersMetadata();
	initTabDisplay();
	initPermissions();			
	
	initDocTypeMdlPage();
	initUsrMdlPage();
	initTaskMdlPage();
	initProcMdlPage();
	initEntMdlPage();
	initAttMdlPage();
	initFormMdlPage();
	initImgMdlPage();
	
	initAdminActionsEdition(executeBeforeConfirm);
	initAdminFav();	
	initAdminFieldOnChangeHighlight();
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function executeBeforeConfirm(){
	var ok = true;
	
	if (ok) { ok = ok && executeBeforeConfirmTabFilters(); }
	if (ok) { ok = ok && executeBeforeConfirmTabFiltersMetadata(); }
	if (ok) { ok = ok && executeBeforeConfirmTabDisplay(); }
		
	return ok;
}

function processModalImageConfirm(image){
	if (image != null){
		var txtPathImg = $('imgPath');
		var changeImg = $('changeImg'); 
		changeImg.style.backgroundImage = "url('"+image.path+"')";
		txtPathImg.value = image.id;
	}
}

