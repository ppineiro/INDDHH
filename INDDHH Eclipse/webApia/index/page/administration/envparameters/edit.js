function initPage() {
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});

	//Si no se viene desde Ambientes
	var envName = $('envName').value;
	if (envName != null && envName != "") {  
		var span = $('sTitle');
		span.innerHTML = span.innerHTML + " - " + envName;		
	}
	
	//Reset Imagen
	$('btnResetImage').addEvent('click', function(evt) {
		var path = CONTEXT + '/images/apia_logo.gif';
		$('envImg').setStyle('background-image', 'url(' + path + ')');
		$('envParam10').value = "/images/apia_logo.gif";		
	});
	
	//Cargar Parametros
	loadEnvParameters();
	
	//Seleccionar Imagen
	$('envImg').addEvent('click', function(evt) {
		showImagesModal(processModalImageConfirm,null);
	});
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition();
	initImgMdlPage();
	initAdminFav();
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
	
	$("lastMemoryUpdate").set("html", lastMemoryUpdate);	
	$("lastDBUpdate").set("html", lastDBUpdate);	
	
	$("btnReloadPars").addEvent("click", 
		function(evt) { 			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=reloadParameters&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.closeAll(); SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { 
					if (synchronizedParameters)
						$("lastDBUpdate").removeClass('paramsDateStatus');
					modalProcessXml(resXml);  }
			}).send(); 
		}
	);
	
	if (!synchronizedParameters){
		//Resalto error en fecha BD		
		$("lastDBUpdate").addClass('paramsDateStatus');
		
		//Necesario debido a que se encuentra dentro del initPage
		setTimeout(function() {
			showConfirm(LABEL_CONFIRM_UPDATE, GNR_TIT_WARNING, 
				function(ret){					
						if (ret)
							$("btnReloadPars").fireEvent('click');					
				}, 'modalWarning');
		}, 500);
		
	}
}

function loadEnvParameters(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadXmlEnvParameters&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); SYS_PANELS.closeAll(); }
	}).send();
}

function reloadChanges(url) {
	if (url != null && url != undefined && url != ''){
		setTimeout(function() { 
			SYS_PANELS.closeAll(); 
			SYS_PANELS.showLoading();
			window.location = CONTEXT + url;			
		}, 1000);		
	}
}

function processXmlEnvParams(){
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];
	if (ajaxCallXml != null && ajaxCallXml.getElementsByTagName("envParameters")[0].getElementsByTagName("envParam")) {
		var envParameters = ajaxCallXml.getElementsByTagName("envParameters")[0].getElementsByTagName("envParam");
		for (var i = 1; i <= envParameters.length; i++){
			var xmlEnvParam = envParameters[i-1];
			var fieldParam = $("envParam"+i);
			fieldParam.value = xmlEnvParam.getAttribute("value");
		}
		if (envParameters[9] != null){ //Imagen
			var value = envParameters[9].getAttribute("value");
			if (value != null && value != ""){
				$('envImg').style.backgroundImage = "url('"+CONTEXT+value+"')";
			} else {
				$('envImg').setStyle('background-image', "url('')");
			}						
		}
		if (envParameters[14] != null && envParameters[14].getAttribute("value") == "false"){ //Habilitacion chat
			var field16 = $("envParam16");
			field16.disabled = true;
			field16.readOnly = true;
			field16.addClass("readonly");
		}
	}
}

function enableDisableField(cmb,fieldId){
	$(fieldId).disabled = (cmb.value == "false");
	$(fieldId).readOnly = (cmb.value == "false");
	if (cmb.value == "false"){
		$(fieldId).addClass("readonly");
	} else {
		$(fieldId).removeClass("readonly");
	}
}

function processModalImageConfirm(image) {
	$('envImg').style.backgroundImage = "url('"+image.path+"')";
	$('envParam10').value = PATH_IMG + image.id;	
}


	