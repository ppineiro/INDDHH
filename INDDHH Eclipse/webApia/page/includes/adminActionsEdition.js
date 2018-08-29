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
			
			if (isAnyElementModified()){
				SYS_PANELS.newPanel();
				var panel = SYS_PANELS.getActive();
				panel.addClass("modalWarning");
				panel.content.innerHTML = GNR_PER_DAT_ING;
				panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); clickAdminActionGoBack();\">" + BTN_CONFIRM + "</div>";
				SYS_PANELS.addClose(panel);
				SYS_PANELS.refresh();	
			} else {
				clickAdminActionGoBack();
			}
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
		var path = 'url(' + e.get('data-src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	
	//['btnConf','btnBackToList','btnCloseTab'].each(setTooltip);
}

function clickAdminActionGoBack(){
	sp.show(true);
	window.location = CONTEXT + URL_REQUEST_AJAX + '?action=list' + TAB_ID_REQUEST;	
}

function addElementsOnChangeHighlight(elements, includeDisable) {
	if (!elements) return;
	elements.each(function(ele) {
		if (ele.hasClass('avoidDetectChangeHighlight')) return;
		//Se evita control en modal de documentos
		if (ele.getParent('#mdlDocumentContainer')) return;
		var isDatePicker = ele.getAttribute('hasdatepicker')=='true' 
							|| ele.getAttribute('data-hasdatepicker')=='true'; 
		if (isDatePicker){
			var eventName = 'selectDate';			
		} else {
			var type = ele.get('type');			
			if (type){
				var isCheckbox = type.toLowerCase() == 'checkbox';
				var eventName = ! isCheckbox ? 'change' : 'click';	
			}
		}
		if (eventName){
			ele.addEvent(eventName, fncSendFieldChangeTabHighlight.bind(ele, includeDisable));
			ele.set('initialValue', isCheckbox ? ele.checked : ele.value);	
		}
	});
}

function initAdminRadioButtonOnChangeHighlight(container, radioName){
	if (!container) return;
	
	var radios = container.getElements('input[name='+radioName);
	radios.each(function(r){
		r.set('initialValue', r.checked);
		
		r.addEvent('change', function(){
			radios.each(function(ele){ ele.removeClass("highlighted"); });
			
			var isSameValue =  (this.checked+"") == this.get('initialValue'); 
			if (!isSameValue) this.addClass("highlighted");
			
			getTabContainerController().changeTabState(TAB_ID, true); 
		})
	})
}

function initAdminFieldOnChangeHighlight(avoidInput, avoidSelect, avoidTextarea, element, includeDisable) {
	getTabContainerController().changeTabState(TAB_ID, false);
	
	if (!element) element = document;
	if (! avoidInput) addElementsOnChangeHighlight(element.getElements('input'), includeDisable);
	
	if (! avoidSelect) addElementsOnChangeHighlight(element.getElements('select'), includeDisable);
	
	if (! avoidTextarea) addElementsOnChangeHighlight(element.getElements('textarea'), includeDisable);
}

function initAdminEditorOnChangeHighlight(editor) {
	if (!editor) return;
	
	AT_LEAST_ON_FIELD_INPUT_CHANGED = true;
	editor.initialValue = editor.getValue();
	editor.on("blur", function() {
		var isSameValue = editor.initialValue == editor.getValue() 
		if (! isSameValue) {
			editor.getWrapperElement().addClass("highlighted");
		} else {
			editor.getWrapperElement().removeClass("highlighted");
		}
	 });
}

function fncSendFieldChangeTabHighlight(includeDisable) {
	AT_LEAST_ON_FIELD_INPUT_CHANGED = true;
	var isCheckbox = this.get('type').toLowerCase() == 'checkbox';
	var isSameValue = (isCheckbox ? (this.checked + "") : this.value) == this.get('initialValue') 
	if (! isSameValue) {
		if (! this.disabled || includeDisable) this.addClass("highlighted");
	} else {
		this.removeClass("highlighted");
	}
	getTabContainerController().changeTabState(TAB_ID, true); 
}

function resetChangeHighlight(element) {
	getTabContainerController().changeTabState(TAB_ID, false); 
	AT_LEAST_ON_FIELD_INPUT_CHANGED = false;
	if (!element) element = document;
	element.getElements('*.highlighted').each(function(ele) { 
		ele.removeClass('highlighted');
		ele.set('initialValue', ele.value);
	});
}

function closeCurrentTab() {
	getTabContainerController().removeActiveTab();
}

function isAnyElementModified(avoidContainers) {
	var modElements = $$('*.highlighted');
	var count = modElements.length;
	
	if (avoidContainers){
		avoidContainers.each(function(ac){
			var mods = $(ac).getElements('.highlighted');
			if (mods) count = count - mods.length;
		})
	}
	return count>0;
}

/*
 * Se agrega observer para detectar cambios al agregar/borrar elementos de colección.
 */
function initAdminModalHandlerOnChangeHighlight(element, avoidNotification, avoidInput, customNotification){
	//Se agrega control sobre hijos
	initAdminFieldOnChangeHighlight(avoidInput,false,false,element);
	
	if (!avoidNotification && !customNotification){ 
		element.grab(new Element('div', {id : 'editionNot'}), "bottom"); 
	}
	
	var observer = element.retrieve('observer');
	if (observer){ observer.disconnect(); }
	
	observer = new MutationObserver(function(mutations) {
		var _initialValue = this.initialValue;
		mutations.forEach(function(mutation) {
			
			//Se verifica si hubo cambios y se notifica elementos agregados
			if (_initialValue && _initialValue != getObjectToCompare(mutation.target)){
				for (var i=0; i<mutation.addedNodes.length; i++) {
					var item = mutation.addedNodes[i];
					if (item.hasClass('option')) {
						item.addClass('highlighted');
					} else if (item.hasClass('selectableTR')) {
						item = item.getElement('span');
						if (item) item.addClass('highlighted');
					} else if (item.getElement('div.divHeader')) {
						item.getElement('div.divHeader').addClass('highlighted');
					} else {
						item = item.getElement('.list-item');
						if (item) item.addClass('highlighted');
					}
				}
				if (mutation.removedNodes.length > 0){
					//Si se borra algún elemento, queda en estado "Modificado"
					if (customNotification){
						customNotification.addClass('highlighted option-highlighted');

					} else {
						var target = mutation.target;
						var editionNot = target.getElementById('editionNot');
						if (!editionNot && target.getParent('.field')) 
							editionNot = target.getParent('.field').getElementById('editionNot');
						if (editionNot) 
							editionNot.addClass('highlighted option-highlighted');	
					}
				}
			}
	    });
	});
	
	observer.initialValue = getObjectToCompare(element); 
	
	//Se crea observer
	var config = { childList:true, subtree:true };
	observer.observe(element, config);
	element.store('observer',observer);
}

function getObjectToCompare(obj){
	if (!obj){ return; }	
	return JSON.stringify(obj.innerHTML);
}
