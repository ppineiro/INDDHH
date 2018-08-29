
function initPage(){
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition(null,false,MODE_SERVER,false);	
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
	
	loadCustomParameters();
	
}


function loadCustomParameters(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadParametersForView&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
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

function processXMLParameters(){
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		var parameters = ajaxCallXml.getElementsByTagName("parameters");
		
		if (parameters != null && parameters.length > 0 && parameters.item(0) != null) {
			var projects = parameters.item(0).getElementsByTagName("project");
			
			if (projects != null && projects.length > 0 && projects.item(0) != null) {
				for (var i = 0; i < projects.length; i++){
					var prjId = projects[i].getAttribute("id");
					var container = $('container_'+prjId);
					var divNoCusPar = $('no_cus_par_'+prjId);
					
					var params = projects[i].getElementsByTagName("parameter");
					for (var j = 0; j < params.length; j++){
						var pInfo = params[j]; 
						
						var parId = pInfo.getAttribute("id");
						var parLbl = pInfo.getAttribute("label");
						var parDesc = pInfo.getAttribute("desc");
						var parType = pInfo.getAttribute("type");
						var parVal = pInfo.getAttribute("value");
						var parReq = toBoolean(pInfo.getAttribute("required"));
						var parReadOnly = toBoolean(pInfo.getAttribute("readonly"));
						
						var objPar = createParameter(parId, parLbl, parDesc, parType, parVal, parReq, parReadOnly);
						divNoCusPar.setStyle("display","none");
						objPar.inject(container);
					}
				}
			}
		}
		
		$$('img.datepickerSelector').each(function(img){
			img.setStyle("margin-top","-2px");
		});
	}
}

function createParameter(parId,parLbl,parDesc,parType,parVal,parReq,parReadOnly){
	var field = new Element("div.field.fieldOneThird",{});
	new Element("label.label",{html:parLbl+':&nbsp;','title':parDesc}).inject(field);
	
	if (parReq){ field.addClass("required"); }
	
	if (parType == TYPE_STRING){
		var inputValue = new Element("input",{'type':'text','id':'cusPar_'+parId,'name':'cusPar_'+parId,'title':parDesc,'value':parVal}).inject(field);
		inputValue.set("maxlength","255");
		inputValue.disabled = parReadOnly;
		if (parReq){
			inputValue.addClass("validate['required']");
			$('frmData').formChecker.register(inputValue);
		}
	} else if (parType == TYPE_INTEGER){
		var inputValue = new Element("input",{'type':'text','id':'cusPar_'+parId,'name':'cusPar_'+parId,'title':parDesc,'value':parVal}).inject(field);
		inputValue.disabled = parReadOnly;
		if (parReq){
			inputValue.addClass("validate['required','digit']");
		} else {
			inputValue.addClass("validate['digit']");	
		}		
		$('frmData').formChecker.register(inputValue);
	} else if (parType == TYPE_DATE){
		var inputValue = new Element("input",{'type':'text','id':'cusPar_'+parId,'name':'cusPar_'+parId,'title':parDesc,'value':parVal}).inject(field);
		inputValue.disabled = parReadOnly;
		inputValue.addClass("datePicker");
		inputValue.set("size","10");
		inputValue.set("format",'d/m/Y');
		inputValue.setStyle("width","93%");
		inputValue.set("cusPar_id",'cusPar_'+parId);
		if (parReq){
			inputValue.addClass('validate["required","target:cusPar_' + parId + '_d"]');
			$('frmData').formChecker.register(inputValue);
		}
		setAdmDatePicker(inputValue);		
	} else if (parType == TYPE_BOOL_COMBO){
		var selectValue = new Element("select",{'id':'cusPar_'+parId,'name':'cusPar_'+parId,'title':parDesc,'value':toBoolean(parVal)}).inject(field);
		selectValue.disabled = parReadOnly;
		new Element("option", {'value': 'true', html: lblSi, 'selected':toBoolean(parVal) }).inject(selectValue);
		new Element("option", {'value': 'false', html: lblNo, 'selected':!toBoolean(parVal) }).inject(selectValue);
	} else if (parType == TYPE_CHECKBOX){
		var inputValue = new Element("input",{'type':'checkbox','id':'cusPar_'+parId,'name':'cusPar_'+parId,'title':parDesc}).inject(field);
		inputValue.disabled = parReadOnly;
		inputValue.setStyle("width","76%");
		inputValue.checked = toBoolean(parVal);
	}
	
	return field;
}

function cusParametersSavedOk(){
	SYS_PANELS.closeAll();
	showMessage(msgOpOk);
	hideOkMessage.delay(2500);
}

function hideOkMessage(){
	SYS_PANELS.closeActive();
}
