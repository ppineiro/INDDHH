var newProcess;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//Ocultar botones
	var hideBtnConf = false;
	var hideBtnBack = false;
	if (MODE_READ_ONLY || MODE_DISABLED){
		hideBtnConf = true;
		if (MODE_DISABLED){
			hideBtnBack = true;
		}
	} else if (MODE_DEBUG){
		hideBtnConf = true;
	} 

	newProcess = MODE_CREATE;
	
	//Init Admin Actions Edition
	initAdminActionsEdition(executeBeforeConfirm,hideBtnConf,hideBtnBack);
	
	//Init Modals
	initImgMdlPage();
	initCalendarViewMdlPage();
	initPoolMdlPage();
	initMsgNotificationsMdlPage();
	initAdminFav();	
	initFormMdlPage();
	initPrfMdlPage();
	initEntMdlPage();		
		
	//Init Tabs
	initTabGenData();
	initTabMapa();
	if (!MODE_DEBUG){
		initTabAttributes();
		initTabActions();
		initDocuments(null,"ajaxUploadStartDoc");
		initDocTypePermitted();
		initTabMonitor();
		initPermissions();
		initTabAnalyticalQueries();	
	}
	
	if (MODE_DISABLED){
		//Deshabilitar campos en paginas genericas
		disableAllPermissionsPage(); //tab permisos
		disableAllDocumentsPage(); //tab documentos
		
		//Elimina iconos de elementos requeridos
		$('frmData').getElements(".required").each(function (obj){
    		obj.removeClass("required");
    	});
	}
	
	//Setear permisos de lectura y escritura por defecto
	if (MODE_CREATE || !HAS_PERMISSIONS){
		setCmbPermDefaultValue("2"); //Leer y modificar
	}
	
	initAdminFieldOnChangeHighlight(false, false, false, null, true);
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function executeBeforeConfirm(){
	if(!verifyPermissions()){
		return false;
	}
	if(!xml_model_exported) {
		if(executeBeforeConfirmTabActions() 
		  && executeBeforeConfirmTabMonitor()
		  && executeBeforeConfirmTabAnalyticalQueries()
		  && checkPermissions()) {
			if(flashLoaded) {
				if(IS_PRO_BPMN)
					getFlashMovie('Designer').getModel();
				else
					getFlashOutput();
			} else {
				setTimeout(function() {
					xml_model_exported = true;
					executeBeforeConfirmCallback();
				}, 10);
			}
		}
		return false;
	}
	xml_model_exported = false;
	return true;
}

function executeBeforeConfirmCallback() {
	$('btnConf').fireEvent('click', {
	    target: $('btnConf'),
	    type: 'click',
	    stop: Function.from
	});
}

function proTypeChange() {
	try{
		if (flashLoaded) {
			if(IS_PRO_BPMN) {
				var cmb = $("cmbAction");
				var type = "";
				if(cmb.tagName.toUpperCase() == "SELECT"){
					type=cmb.options[cmb.selectedIndex].value;
				} else {
					type = cmb.value;
				}
				getFlashMovie("Designer").setProAction(type);
			} else {
				oldProTypeChange();
			}
		}
	}catch(e){}
}

function checkPermissions(){
	if ($('selPerAllPoolPerm').value != 2 && !$('usePrjPerms').checked){
		var hasUpdPerm = false;
		getActionElements('prmPoolContainter').each(function (item){
			var chk = item.getElements("input")[1];
			hasUpdPerm = hasUpdPerm || chk.checked;
		});
		
		if (!hasUpdPerm){
			showMessage(MSG_ERR_PERM, GNR_TIT_WARNING, 'modalWarning');
		}	
		
		return hasUpdPerm;
	} else {
		return true;
	}
}

