function initPage() {
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});

	//Si no se viene desde Ambientes
	var envTitle = $('envTitle').value;
	if (envTitle != null && envTitle != "") {  
		var span = $('sTitle');
		span.innerHTML = span.innerHTML + " - " + envTitle;	
		
		$('fncDescriptionText').getPrevious().set('data-src', 'images/uploaded/fncParamAmb.gif');		
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
	initAdminActionsEdition(beforeConfirm);
	initImgMdlPage();
	initAdminFav();
	
	var btnCloseTab = $('btnCloseTab');
	if (btnCloseTab) {
		btnCloseTab.removeEvents('click');
		btnCloseTab.addEvent("click", function(e){
			if (e) e.stop();
			
			if (isAnyElementModified()){
				SYS_PANELS.newPanel();
				var panel = SYS_PANELS.getActive();
				panel.addClass("modalWarning");
				panel.content.innerHTML = GNR_PER_DAT_ING;
				panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); closeCurrentTab();\">" + BTN_CONFIRM + "</div>";
				SYS_PANELS.addClose(panel);

				SYS_PANELS.refresh();	
			} else {
				closeCurrentTab();	
			}
		});
	}
	
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

function beforeConfirm(){
	resetChangeHighlight();
}

function reloadChanges(url) {
	resetChangeHighlight();
	
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
			disableField($("envParam16"));
			disableField($("envParam19"));
			disableField($("envParam20"));
			disableField($("envParam21"));			
		}
	}
}

function disableField(field){
	if (!field) return;
	
	field.disabled = true;
	field.readOnly = true;
	field.addClass("readonly");
}

function enableDisableField(cmb,fieldIds){
	if (fieldIds == null) return;
	
	fieldIds.each(function(fieldId){
		$(fieldId).disabled = (cmb.value == "false");
		$(fieldId).readOnly = (cmb.value == "false");
		if (cmb.value == "false"){
			$(fieldId).addClass("readonly");
		} else {
			$(fieldId).removeClass("readonly");
		}	
	})
}

function processModalImageConfirm(image) {
	$('envImg').style.backgroundImage = "url('"+image.path+"')";
	$('envParam10').value = PATH_IMG + image.id;	
}


	