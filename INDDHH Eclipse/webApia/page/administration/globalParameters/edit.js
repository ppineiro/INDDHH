var prev_button;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	['formatTab','locTab','logTab','emailTab','otherTab','chatTab','authenticationTab','biTab'].each(function(ele) {
		ele = $(ele);
		var id = ele.get('id');
		var buttonsId = id.substring(0, id.indexOf('Tab')) + 'Buttons';
		var buttons = $(buttonsId);
		
		if (buttons == null) showMessage(id + " - " + buttonsId);
		
		ele.buttons = buttons;
		
		ele.addEvent("focus", function(evt) { 
			if(prev_button)
				prev_button.buttons.addClass('hidden');
			this.buttons.removeClass('hidden');
			$('currentParamTab').value = this.getAttribute("id"); 
			prev_button = ele;
		});

	});
	
	$$('div.actionButton').each(function(ele) { ele.addEvent('click', callButtonAction); });
	
	initAdminFav();
	initAdminActionsEdition(null,false,true);
	
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
	
	initParameterButtons();
	
	initAdminFieldOnChangeHighlight();
	
	if (currentParamTab != null && currentParamTab != undefined && currentParamTab != ''){
		$('currentParamTab').value = currentParamTab;
		if ($(currentParamTab)){ $(currentParamTab).fireEvent("click"); }
	}
	
	$$("img.colorPicker").each(function(item) {
		colorPicker(item);
	});

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

function callButtonAction(evt) {
	var action = this.get('action');
	
	if (! action || action.length == 0) return;
	
	var form = $('frmData');
	var params = getFormParametersToSend(form);
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=' + action + '&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send(params);
}

function disableElements(elements) { elements.each(disableElement); }
function enableElements(elements) { elements.each(enableElement); }
function hiddeElements(elements) { elements.each(hideElement); }
function showElements(elements) { elements.each(showElement); }

function hideElement(ele) {
	ele = $(ele);
	ele.addClass('hidden');
}

function disableElement(ele) {
	ele = $(ele);
	ele.set('disabled', 'true');
	ele.disabled = true;
	ele.readonly = true;
	ele.addClass('readonly');
	if(ele.type=='password'){
		ele.removeAttribute('placeholder',LBL_MODIFY_PWD);
		ele.setAttribute('avoidSend',false);
	}
	disposeValidation(ele);
}

function showElement(ele) {
	ele = $(ele);
	ele.removeClass('hidden');
}

function enableElement(ele) {
	ele = $(ele);
	ele.erase('disabled');
	ele.disabled = false;
	ele.readonly = false;
	ele.removeClass('readonly');
	if(ele.type=='password'){
		ele.setAttribute('placeholder',LBL_MODIFY_PWD);
		if (ele.getAttribute('avoidSend')=="false") 
			ele.setAttribute('avoidSend',true);
		else
			registerValidation(ele);
	} else {
		registerValidation(ele);
	}
}

function registerPassword(ele, register){
	if (register){
		registerValidation(ele);
		ele.setAttribute('avoidSend',false);
	} else {
		disposeValidation(ele);
		ele.setAttribute('avoidSend',true);		
	} 
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

function resetChanges(url) {
	var notSaved = $('notSaved');
	notSaved = notSaved.value;
	
	if (notSaved.length == 1) {
		getTabContainerController().changeTabState(TAB_ID, false); 
		AT_LEAST_ON_FIELD_INPUT_CHANGED = false;
	}
	$$('*.highlighted').each(function(ele) {
		if (notSaved.indexOf("," + ele.id + ",") == -1) {
			ele.removeClass('highlighted');
			ele.set('initialValue', ele.value);
		}
	});

	if (url != null && url != undefined && url != ''){
		setTimeout(function() { 
			SYS_PANELS.closeAll(); 
			SYS_PANELS.showLoading();
			window.location = CONTEXT + url;			
		}, 1000);		
	}
}

function registerValidation(obj){
	$('frmData').formChecker.register(obj);
}

function disposeValidation(obj){
	$('frmData').formChecker.dispose(obj);
}

function colorPicker(ele){
	var div = ele.getParent("div");
	var inputValue = div.getElement("input");
	var inputColor = div.getElements("input")[1];
	
	var rgb = hexToRgb(inputValue.value.toUpperCase());
	var r = rgb != null ? rgb.r : 255;
	var g = rgb != null ? rgb.g : 0;
	var b = rgb != null ? rgb.b : 0;
	
	var picker = new MooRainbow(ele, {
		id: inputValue.get('id') + "picker",
		'startColor': [r, g, b],
		'imgPath': CONTEXT + '/js/colorpicker/images/',
		'onChange': function(color) {},
		'onComplete': function(color) {
			inputValue.set('value', color.hex);
			inputValue.value = inputValue.value.toUpperCase();
			inputColor.setStyle('background-color', color.hex);
			this.fireEditionEvent();
		},
		'onCancel':function(color) {}
	});	
}

function hexToRgb(hex) {
    // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
    var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
    hex = hex.replace(shorthandRegex, function(m, r, g, b) {
        return r + r + g + g + b + b;
    });

    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}