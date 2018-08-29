var AT_LEAST_ON_FIELD_INPUT_CHANGED = false;


function initAdminActionsEdition() {
	initAdminActionsEdition(null,false,false,false);
}
/**
 * Inicializa los eventos de botones.
 * @param func	Funcion a ser invocada previo a la confirmacion del formulario
 */
function initAdminActionsEdition(func,hideBtnConf,hideBtnBack,hideBtnClose) {
	$('frmData').formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetX: -10
				}
			}
		);
	
	var btnConf = $('btnConf');
	if (!hideBtnConf && btnConf) btnConf.style.display = '';
	if (btnConf){
		btnConf.addEvent("click", function(e) {
			if (e) e.stop();
			
			if(func) {
				if(func() == false) //Evitar null, undefined y ""
					return;
			}
			
			var form = $('frmData');
			if(!form.formChecker.isFormValid()){
				return;
			}
			
			var params = getFormParametersToSend(form);
			params += "&ctrlKeyPressedOnConfirm=" + e.control;
						
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=confirm&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send(params);
		
		});
	}

	var btnCloseTab = $('btnCloseTab');
	if (!hideBtnClose && btnCloseTab) btnCloseTab.style.display = '';
	if (btnCloseTab) {
		btnCloseTab.addEvent("click", closeCurrentTab);
	}
	
	var btnBackToList = $('btnBackToList');
	if (!hideBtnBack && btnBackToList) btnBackToList.style.display = '';
	if (btnBackToList){
		btnBackToList.addEvent("click", function(e) {
			e.stop();
			sp.show(true);
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=list' + TAB_ID_REQUEST;
		});
	}
	
	var divAdminActEdit = $('divAdminActEdit');
	if ((!hideBtnConf || !hideBtnBack) && divAdminActEdit) divAdminActEdit.style.display = '';
	
	/*
	$$("div.button").each(function(ele){
		ele.addEvent("onmouseover", function(evt) {this.toggleClass("buttonHover")});
		ele.addEvent("onmouseout", function(evt) {this.toggleClass("buttonHover")});
	});
	*/
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	
	//['btnConf','btnBackToList','btnCloseTab'].each(setTooltip);
}

function initAdminFieldOnChangeHighlight(avoidInput, avoidSelect) {
	getTabContainerController().changeTabState(TAB_ID, false); 
	if (! avoidInput) $$('input').each(function(ele) {
		if (ele.hasClass('avoidDetectChangeHighlight')) return;
		var isCheckbox = ele.get('type').toLowerCase() == 'checkbox';
		var eventName = ! isCheckbox ? 'change' : 'click';
		ele.addEvent(eventName, fncSendFieldChangeTabHighlight);
		ele.set('initialValue', isCheckbox ? ele.checked : ele.value);
	});
	if (! avoidSelect) $$('select').each(function(ele) {
		if (ele.hasClass('avoidDetectChangeHighlight')) return;
		ele.addEvent('change', fncSendFieldChangeTabHighlight);
		ele.set('initialValue', ele.value);
	});
}

function fncSendFieldChangeTabHighlight(evt) {
	AT_LEAST_ON_FIELD_INPUT_CHANGED = true;
	var isCheckbox = this.get('type').toLowerCase() == 'checkbox';
	var isSameValue = (isCheckbox ? (this.checked + "") : this.value) == this.get('initialValue') 
	if (! isSameValue) {
		if (! this.disabled) this.addClass("highlighted");
	} else {
		this.removeClass("highlighted");
	}
	getTabContainerController().changeTabState(TAB_ID, true); 
}

function resetChangeHighlight() {
	getTabContainerController().changeTabState(TAB_ID, false); 
	AT_LEAST_ON_FIELD_INPUT_CHANGED = false;
	$$('*.highlighted').each(function(ele) { 
		ele.removeClass('highlighted');
		ele.set('initialValue', ele.value);
	});
}

function closeCurrentTab() {
	getTabContainerController().removeActiveTab();
}