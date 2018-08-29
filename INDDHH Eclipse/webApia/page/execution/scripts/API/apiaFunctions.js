var ApiaFunctions = {};

/**
 * Returns an execution Apia Entity form by its design name 
 */
ApiaFunctions.getEntityForm = function(frmName) {
	for(var i = 0; i < executionEntForms.length; i++) {
		if(executionEntForms[i].frmName == frmName)
			return new ApiaForm(executionEntForms[i]);
	}
	return null;
};

/**
 * Returns an execution Apia Process form by its design name 
 */
ApiaFunctions.getProcessForm = function(frmName) {
	for(var i = 0; i < executionProForms.length; i++) {
		if(executionProForms[i].frmName == frmName)
			return new ApiaForm(executionProForms[i]);
	}
	return null;
};

ApiaFunctions.getAttField = function(attType, attId) {
	if(attType == "E") {
		for(var i = 0; i < executionEntForms.length; i++) {
			var form = new ApiaForm(executionEntForms[i]);
			var field = form.getAttField(attId);
			if(field != null)
				return field;
		}
	} else if(attType == "P") {
		for(var i = 0; i < executionProForms.length; i++) {
			var form = new ApiaForm(executionProForms[i]);
			var field = form.getAttField(attId);
			if(field != null)
				return field;
		}
	}
	return null;
};

ApiaFunctions.getForm = function(frmName, frmType) {
	if(frmType == "E")
		return ApiaFunctions.getEntityForm(frmName);
	if(frmType == "P")
		return ApiaFunctions.getProcessForm(frmName);
	
	var eForm = ApiaFunctions.getEntityForm(frmName);
	if(eForm)
		return eForm;
	else
		return ApiaFunctions.getProcessForm(frmName);
};

/**
 * Returns all Apia forms in the current step 
 */
ApiaFunctions.getAllForms = function() {
	var forms = [];
	for(var i = 0; i < executionEntForms.length; i++) {
		forms.push(new ApiaForm(executionEntForms[i]));
	}
	for(i = 0; i < executionProForms.length; i++) {
		forms.push(new ApiaForm(executionProForms[i]));
	}
	return forms;
};

ApiaFunctions.getRootPath = function() {
	return CONTEXT;
};

ApiaFunctions.getCurrentStep = function() {
	return currentStep;
};

ApiaFunctions.changeTab = function(tabIndex) {
	var tabHolder = $('tabHolder');
	if(tabHolder) {
		var tabs = tabHolder.getChildren('div.tab');
		var tabNumber = Number.from(tabIndex);
		if(tabs && tabs[tabNumber])
			tabs[tabNumber].fireEvent('click', new Event({
				type: 'click'
			}));
	}
}
   
ApiaFunctions.getTabTitle = function(tabNumber) {
	var tabHolder = $('tabHolder');
	if(tabHolder) {
		var tabs = tabHolder.getChildren('div.tab');
		tabNum = Number.from(tabNumber);
		if(tabs && tabs[tabNum])
			return tabs[tabNum].get('html');
	}
}

ApiaFunctions.getTabNumber = function(tabTitle) {
	var tabHolder = $('tabHolder');
	if(tabHolder) {
		var tabs = tabHolder.getChildren('div.tab');
		for(var i = 0; i < tabs.length; i++) {
			if(tabs[i].get('html') == tabTitle)
				return i;
		}
	}
}

/**
 * Retorna los nombres de los formularios en un tab
 */
ApiaFunctions.getFormNamesInTab = function(tab) {
	var res = new Array();
	var tabNumber;
	if(typeOf(tab) == 'string') {
		//Se pasa el t�tulo
		tabNumber = ApiaFunctions.getTabNumber(tab);
	} else if(typeOf(tab) == 'number') {
		//Se pasa el �ndice
		tabNumber = tab;
	}
	var tabComponent = $('tabComponent');
	if(tabComponent) {
		tabs = tabComponent.getChildren('div.aTab');
		if(tabs && tabs[tabNumber]) {
			var frm_ids = tabs[tabNumber].getElements('div.formContainer').get('id');
			for(var i = 0; i < executionEntForms.length; i++) {
				if(frm_ids.contains(executionEntForms[i].id))
					res.push(executionEntForms[i].frmName);
			}
			for(i = 0; i < executionProForms.length; i++) {
				if(frm_ids.contains(executionProForms[i].id))
					res.push(executionProForms[i].frmName);
			}
		}
	}
	return res;
}

/**
 * Retorna los los formularios en un tab
 */
ApiaFunctions.getFormsInTab = function(tab) {
	var res = new Array();
	var tabNumber;
	if(typeOf(tab) == 'string') {
		//Se pasa el t�tulo
		tabNumber = ApiaFunctions.getTabNumber(tab);
	} else if(typeOf(tab) == 'number') {
		//Se pasa el �ndice
		tabNumber = tab;
	}
	var tabComponent = $('tabComponent');
	if(tabComponent) {
		tabs = tabComponent.getChildren('div.aTab');
		if(tabs && tabs[tabNumber]) {
			var frm_ids = tabs[tabNumber].getElements('div.formContainer').get('id');
			for(var i = 0; i < executionEntForms.length; i++) {
				if(frm_ids.contains(executionEntForms[i].id))
					res.push(new ApiaForm(executionEntForms[i]));
			}
			for(i = 0; i < executionProForms.length; i++) {
				if(frm_ids.contains(executionProForms[i].id))
					res.push(new ApiaForm(executionProForms[i]));
			}
		}
	}
	return res;
}

ApiaFunctions.getCurrentTaskName = function() {
	return CURRENT_TASK_NAME;
}


//--- This method converts an Apia formatted number into a java script number
ApiaFunctions.toJSNumber = function(pValue) {
	var re
	if(charThousSeparator == '.')
		re = new RegExp("\\" + charThousSeparator, 'g');
	else
		re = new RegExp(charThousSeparator, 'g');
	
	var	aux = pValue.replace(re, "");
	aux = aux.replace(charDecimalSeparator,".");
	return parseFloat(aux);
}

//--- This method converts a number in an Apia formatted number
ApiaFunctions.toApiaNumber = function(pValue) {
	try {pValue = pValue.toFixed(amountDecimalSeparator)} catch(e1) {}
	var s = new String(pValue);
	if(s.indexOf(".")==-1){
		if(addThousandSeparator){
			s=addThousSeparator(s);
		}
		return s;
	} else {
		if(addThousandSeparator){
			s=addThousSeparator(s.replace(".",charDecimalSeparator));
		}else{
			s=s.replace(".",charDecimalSeparator);
		}
		var int=s.split(charDecimalSeparator)[0];
		var decimals=s.split(charDecimalSeparator)[1];
		var decCount=decimals.length-1;
		while(decCount>=amountDecimalZeros && decimals.charAt(decCount)=="0"){
			decimals=decimals.substring(0,decCount);
			decCount--;
		}
	}
	return int+charDecimalSeparator+decimals;
}

/* Ver de implementarlas en los campos
//--checks if a field is an apia number by index
ApiaFunctions.isApiaNumberByIndex = function(formName, fieldName, index) {
	var field = getFieldByIndex(formName, fieldName, index);
	return validateNumber(field);
}
//--checks if a field is an apia number
ApiaFunctions.isApiaNumber = function(formName, fieldName) {
	var field = getFieldByIndex(formName, fieldName, 0);
	return validateNumber(field);

}
*/

function addThousSeparator(nStr) {
	nStr += '';
	var x = nStr.split(charDecimalSeparator);
	x1 = x[0];
	x2 = x.length > 1 ? charDecimalSeparator + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + charThousSeparator + '$2');
	}
	return x1 + x2;
}

var lastModalReturn;
ApiaFunctions.getLastModalReturn = function() {
	return lastModalReturn;
}

ApiaFunctions.getModalReturn = ApiaFunctions.getLastModalReturn;

ApiaFunctions.getModalValue = function() {
	return lastModalReturn[0];
};

ApiaFunctions.getModalShowValue = function() {
	return lastModalReturn[1];
};

ApiaFunctions.getModalSelectedRow = function() {
	var clone = lastModalReturn.clone();
	clone.shift();
	clone.shift();
	return clone;
};

//--this method downloads a document by it ID and returns the path of the document 
ApiaFunctions.getDocPath = function(fnc, docId) {
	var request = new Request({
		method: 'post',
		url: CONTEXT + '/apia.execution.DocumentAction.run?action=getDocPath&docId=' + docId + '&isAjax=true&' + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { 
			if (resXml != null) {
				//obtener el codigo de retorno
				var code = resXml.getElementsByTagName("general");
				if(code != null) {
					fnc(code[0].getAttribute("path"));
				}else {
					fnc("Error getting doc path");
				}
			} else {
				fnc("Error getting doc path");
			}
		}
	}).send();
}

/**
 * This method opens an Apia Modal that allows the administration of an entity instance.
 * entName: Entity name, required.
 * entNum: If a value is supplied, the modal will allow the modification of that entitiy. If no number
 * 			is supplied, an entity instance creation modal will be shown.
 * parameters: Parameters for the entity. Format: param1=value;param2=value2;.
 * onShowEvent: If a function is supplied, it will be executed when the modal is shown.
 * onCloseEvent: If a function is supplied, it will be executed when the modal is closed. 
 * returns: A modal object, capable of fire the events: close, confirm.
 */
ApiaFunctions.admEntity = function(entName, entNum, parameters, width, height, onShowEvent, onCloseEvent) {
	var newTabIdRequest = '';
	var split = TAB_ID_REQUEST.split('&');
	for(var i = 0; i < split.length; i++) {
		if(split[i].contains('tabId'))
			newTabIdRequest += '&tabId=' + new Date().getTime();
		else if(split[i])
			newTabIdRequest += '&' + split[i];
	}
	
	var url = CONTEXT + '/apia.execution.EntInstanceListAction.run?action=admEntity&busEntName=' + entName + newTabIdRequest;
	if (entNum)
		url += "&busEntNum="+ entNum;
	if (parameters)
		url += "&params=" + escape(parameters);
	if(!width)
		width = 800;
	if(!height)
		height = 600;
	
	return ModalController.openWinModal(url, width, height, null, null, null, true, true, null, onShowEvent, onCloseEvent);
}

/**
 * This method opens an Apia Modal that allows seeing an entity instance.
 * entName: Entity name, required.
 * entNum: Entity number, required.
 * onShowEvent: If a function is supplied, it will be executed when the modal is shown.
 * onCloseEvent: If a function is supplied, it will be executed when the modal is closed. 
 * returns: A modal object, capable of fire the event: close.
 */
ApiaFunctions.viewAdmEntity = function(entName, entNum, parameters, width, height, onShowEvent, onCloseEvent) {
	var newTabIdRequest = '';
	var split = TAB_ID_REQUEST.split('&');
	for(var i = 0; i < split.length; i++) {
		if(split[i].contains('tabId'))
			newTabIdRequest += '&tabId=' + new Date().getTime();
		else if(split[i])
			newTabIdRequest += '&' + split[i];
	}
	
	var url = CONTEXT + '/apia.execution.EntInstanceListAction.run?action=admEntity&viewMode=true&busEntName=' + entName + "&busEntNum="+ entNum + newTabIdRequest;
 
	if (parameters)
		url += "&params=" + escape(parameters);
	if(!width)
		width = 800;
	if(!height)
		height = 600;
	
	return ModalController.openWinModal(url, width, height, null, null, null, true, true, null, onShowEvent, onCloseEvent);
}


ActionButton = {};
ActionButton.BTN_CONFIRM	 		= 0;
ActionButton.BTN_NEXT 				= 1;
ActionButton.BTN_PREV 				= 2;
ActionButton.BTN_SIGN 				= 3;
ActionButton.BTN_SAVE 				= 4;
ActionButton.BTN_RELEASE 			= 5;
ActionButton.BTN_DELEGATE 			= 6;
ActionButton.BTN_SHARE 				= 7;

OptionButton = {};
OptionButton.BTN_VIEW_DOCS	= 100;
OptionButton.BTN_PRINT		= 101;


ApiaFunctions.disableActionButton = function(button) {
	var btn = Number.from(button);
	var btnId;
	switch(btn) {
	case ActionButton.BTN_CONFIRM:
		btnId = 'btnConf'; break;
	case ActionButton.BTN_NEXT:
		btnId = 'btnNext'; break;
	case ActionButton.BTN_PREV:
		btnId = 'btnLast'; break;
	case ActionButton.BTN_SIGN:
		btnId = 'btnSign'; break;
	case ActionButton.BTN_SAVE:
		btnId = 'btnSave'; break;
	case ActionButton.BTN_RELEASE:
		btnId = 'btnFree'; break;
	case ActionButton.BTN_DELEGATE:
		btnId = 'btnDelegate'; break;
	case ActionButton.BTN_SHARE:
		btnId = 'btnSocialShare'; break;
	case OptionButton.BTN_VIEW_DOCS:
		btnId = 'btnViewDocs'; break;
	case OptionButton.BTN_PRINT:
		btnId = 'btnPrintFrm'; break;
	default:
		return;
	}
	if(btnId) {
		btnId = $(btnId);
		if(btnId) {
			var button = btnId.addClass('apia-disabled-rounded-button').getElement('button');
			if(button)
				button.set('disabled', true);
		}
	}
}

ApiaFunctions.enableActionButton = function(button) {
	var btn = Number.from(button);
	var btnId;
	switch(btn) {
	case ActionButton.BTN_CONFIRM:
		btnId = 'btnConf'; break;
	case ActionButton.BTN_NEXT:
		btnId = 'btnNext'; break;
	case ActionButton.BTN_PREV:
		btnId = 'btnLast'; break;
	case ActionButton.BTN_SIGN:
		btnId = 'btnSign'; break;
	case ActionButton.BTN_SAVE:
		btnId = 'btnSave'; break;
	case ActionButton.BTN_RELEASE:
		btnId = 'btnFree'; break;
	case ActionButton.BTN_DELEGATE:
		btnId = 'btnDelegate'; break;
	case ActionButton.BTN_SHARE:
		btnId = 'btnSocialShare'; break;
	case OptionButton.BTN_VIEW_DOCS:
		btnId = 'btnViewDocs'; break;
	case OptionButton.BTN_PRINT:
		btnId = 'btnPrintFrm'; break;
	default:
		return;
	}
	if(btnId) {
		btnId = $(btnId);
		if(btnId) {
			var button = btnId.removeClass('apia-disabled-rounded-button').getElement('button');
			if(button)
				button.erase('disabled');
		}
	}
}

ApiaFunctions.hideActionButton = function(button) {
	var btn = Number.from(button);
	var btnId;
	switch(btn) {
	case ActionButton.BTN_CONFIRM:
		btnId = 'btnConf'; break;
	case ActionButton.BTN_NEXT:
		btnId = 'btnNext'; break;
	case ActionButton.BTN_PREV:
		btnId = 'btnLast'; break;
	case ActionButton.BTN_SIGN:
		btnId = 'btnSign'; break;
	case ActionButton.BTN_SAVE:
		btnId = 'btnSave'; break;
	case ActionButton.BTN_RELEASE:
		btnId = 'btnFree'; break;
	case ActionButton.BTN_DELEGATE:
		btnId = 'btnDelegate'; break;
	case ActionButton.BTN_SHARE:
		btnId = 'btnSocialShare'; break;
	case OptionButton.BTN_VIEW_DOCS:
		btnId = 'btnViewDocs'; break;
	case OptionButton.BTN_PRINT:
		btnId = 'btnPrintFrm'; break;
	default:
		return;
	}
	if(btnId) {
		btnId = $(btnId);
		if(btnId)
			btnId.setStyle('display', 'none');
	}
}

ApiaFunctions.showActionButton = function(button) {
	var btn = Number.from(button);
	var btnId;
	switch(btn) {
	case ActionButton.BTN_CONFIRM:
		btnId = 'btnConf'; break;
	case ActionButton.BTN_NEXT:
		btnId = 'btnNext'; break;
	case ActionButton.BTN_PREV:
		btnId = 'btnLast'; break;
	case ActionButton.BTN_SIGN:
		btnId = 'btnSign'; break;
	case ActionButton.BTN_SAVE:
		btnId = 'btnSave'; break;
	case ActionButton.BTN_RELEASE:
		btnId = 'btnFree'; break;
	case ActionButton.BTN_DELEGATE:
		btnId = 'btnDelegate'; break;
	case ActionButton.BTN_SHARE:
		btnId = 'btnSocialShare'; break;
	case OptionButton.BTN_VIEW_DOCS:
		btnId = 'btnViewDocs'; break;
	case OptionButton.BTN_PRINT:
		btnId = 'btnPrintFrm'; break;
	default:
		return;
	}
	if(btnId) {
		btnId = $(btnId);
		if(btnId)
			btnId.setStyle('display', 'inline');
	}
}

ApiaFunctions.disableOptionButton = ApiaFunctions.disableActionButton;

ApiaFunctions.enableOptionButton = ApiaFunctions.enableActionButton;

ApiaFunctions.hideOptionButton = ApiaFunctions.hideActionButton;

ApiaFunctions.showOptionButton = ApiaFunctions.showActionButton;

ApiaFunctions.openTab = function(title, url) {
	var topParent = window;
	var tabContainer = topParent.$('tabContainer');
	while(tabContainer == null && topParent != topParent.parent) {
		topParent = topParent.parent;
		tabContainer = topParent.$('tabContainer');
	}
	if(tabContainer != null)
		tabContainer.addNewTab(title, url);
	else
		alert("Error opening tab");
}

ApiaFunctions.closeTab = function(title) {
	var topParent = window;
	var tabContainer = topParent.$('tabContainer');
	while(tabContainer == null && topParent != topParent.parent) {
		topParent = topParent.parent;
		tabContainer = topParent.$('tabContainer');
	}
	if(tabContainer != null && tabContainer.tabs) {
		var tab = null;
		for(var i = 0; i < tabContainer.tabs.length; i++) {
			if(tabContainer.tabs[i]) {
				var span = tabContainer.tabs[i].getElement('span');
				if(span && span.get('text') == title) {
					tab = tabContainer.tabs[i];
					break;
				}
			}
		}
		if(tab)
			tabContainer.removeTab(tab);
		else
			alert("Tab " + title + " not fonud");
	} else {
		alert("Error removing tab");
	}
}

ApiaFunctions.closeCurrentTab = function() {
	
	var iframePosition = frameElement.getAllPrevious('iframe.tabContent').length - 1;
	
	var topParent = window;
	var tabContainer = topParent.$('tabContainer');
	while(tabContainer == null && topParent != topParent.parent) {
		topParent = topParent.parent;
		tabContainer = topParent.$('tabContainer');
	}
	if(tabContainer != null && tabContainer.tabs) {
		
		var tabPosition = tabContainer.tabs.length - (iframePosition + 2);
		
		var tab = tabContainer.tabs[tabPosition]
		
		if(tab)
			tabContainer.removeTab(tab);
		else
			alert("Tab " + title + " not fonud");
	} else {
		alert("Error removing tab");
	}
}

ApiaFunctions.getChatContentCopied = function(keepFormat) {
	var topParent = window;
	var tabContainer = topParent.$('tabContainer');
	while(tabContainer == null && topParent != topParent.parent) {
		topParent = topParent.parent;
		tabContainer = topParent.$('tabContainer');
	}
	
	if(tabContainer != null) {
		if(keepFormat)
			return tabContainer.chatContent;
		
		var res = '';
		var ele = new Element('div').set('html', tabContainer.chatContent);
		var current_chat_user = '';
		ele.getChildren().each(function(p) {
			res += '[' + p.get('title') + '] ';
			
			if(p.hasClass('chatMessageBySystem')) {
				res += p.get('text');
			} else {
				var chat_user = p.getChildren('b')[0];
				if(chat_user) {
					current_chat_user = chat_user.get('text');
					res += current_chat_user + ': ' + p.get('text').substring(current_chat_user.length);
				} else {
					res += current_chat_user + ': ' + p.get('text');
				}
			}
			
			
			res += '\n';
		});
		
		return res;
	}
}

ApiaFunctions.getCurrentLanguageCode = function() {
	return document.documentElement.getAttribute('lang');
}

ApiaFunctions.showMessage = function(text, title, additionalClass){
	showMessage(text, title, additionalClass);
}

ApiaFunctions.showConfirm = function(text, title, return_fnc, additionalClass){
	showConfirm(text, title, return_fnc, additionalClass);
}
