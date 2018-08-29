var MUST_SHOW_CHAT = false;
var REQUEST_GROUPS = true;
var LAST_STATUS = null;

var webSocketStatus = null;
var chat = null;

function initClient(URL_STATUS, URL_CLIENT, CONFIG_ID) {
	
	var btnSendRequest = $('sendRequest');
	btnSendRequest.addEvent('click', evtBtnSendRequest);
	
	var inputMessage = $('inputMessage');
	inputMessage.placeholder = $('inputPlaceholder');
	inputMessage.addEvent('keyup', evtInputKeyPress);
	
	var chatMessages = $('chatMessages');
	chatMessages.fxScroll = new Fx.Scroll(chatMessages);

	var btnExit = $('btnExit');
	btnExit.addEvent('click', evtBtnExitClick);
	
	//Iniciar verificador de estado
//	webSocketStatus = initWebSocket({
//		url: URL_STATUS ,
//		contentType: 'text/plain',
//		onMessage: fncOnMessageStatus,
//		onOpen: fncOnOpenStatus,
//		onClose: fncOnCloseStatus,
//		aditionalConfiguration: {
//			configId: CONFIG_ID
//		}
//	});
	
	fncOnCloseStatus();
	
	//Iniciar client cuando se mande la solicitud inicial
	chat = new Chat({ 
		url: URL_CLIENT,
		configId: CONFIG_ID,
		sessionId: SESSION_ID
	});
	
	chat.forceClear = true;
	chat.addEvent('invalidGroup', fncChatEvtInvalidGroup);
	chat.addEvent('onOpen', fncChatEvtOnOpen);
	chat.addEvent('onClose', fncChatEvtOnClose);
	chat.addEvent('xmlMessage', fncChatEvtXmlMessage);
	chat.addEvent('textMessage', fncChatEvtTextMessage);
	chat.addEvent('enableChat', fncChatEvtEnableChat);
	chat.addEvent('requestSended', fncChatEvtRequestSended);
	chat.addEvent('requestWaiting', fncChatEvtRequestWaiting);
	chat.addEvent('groupOffline', fncChatEvtGroupOffline);
	chat.addEvent('inactivityWarning', fncChatEvtInactivityWarning);
	chat.addEvent('inactivityDisconnect', fncChatEvtInactivityDisconnect);

	domDisableEnableForm(false);
	
	fncAddNewSendFileForm();
}

/** status functionalities **/
function fncOnOpenStatus(response) {
	doConsoleLog("fncOnOpenStatus: " + 'configId:' + this.aditionalConfiguration.configId);
	this.send('configId:' + this.aditionalConfiguration.configId);
}

function fncOnCloseStatus() {
	doConsoleLog("fncOnCloseStatus");
	var bodyStart = $('bodyStart');
	bodyStart.addClass('hide');
	
	webSocketStatus = initWebSocket({
		url: URL_STATUS ,
		contentType: 'text/plain',
		onMessage: fncOnMessageStatus,
		onOpen: fncOnOpenStatus,
		onClose: fncOnCloseStatus,
		aditionalConfiguration: {
			configId: CONFIG_ID
		}
	});
}

function fncOnMessageStatus(response) {
	var message = response.responseBody;
	
	doConsoleLog("fncOnMessageStatus: " + message);

	var bodyStart = $('bodyStart');
	var boddyLoading = $('boddyLoading');
	
	if (message.indexOf("<") == 0) {
		var xml = parseXML(message);
    	var aXml = getFirstChild(xml, 'result');
    	if (aXml != null) {
    		var domGroups = $('groups');
    		while (domGroups.options.length > 0) {
    			domGroups.options[0].destroy();
    		}
    		var xmlGroups = aXml.getElementsByTagName('group');
    		if (xmlGroups != null) {
    			for (var i = 0; i < xmlGroups.length; i++) {
    				var xmlGroup = xmlGroups[i];
    				var aGroup = (xmlGroup.childNodes.length > 0) ? xmlGroup.firstChild.nodeValue : '';
    				new Element('option', {value: aGroup, html: aGroup}).inject(domGroups);
    			}
    		}
    	}
    	
	} else if (! MUST_SHOW_CHAT) {
		if (LAST_STATUS != message) {
			if (message == 'active') {
				bodyStart.removeClass('hide');
				boddyLoading.addClass('hide');
				
				if (LAST_STATUS != message) REQUEST_GROUPS = true;
			} else {
				bodyStart.addClass('hide');
				boddyLoading.removeClass('hide');
			}
		}
		
		LAST_STATUS = message;
	}
	
	if (REQUEST_GROUPS) {
		REQUEST_GROUPS = false;
		this.send('sendAvailableGroups');
	}
}
/** end status functionalities **/

/** client functionalities **/
function fncChatEvtOnOpen() {
	doConsoleLog("fncOnOpenClient: " + 'configId:' + this.options.configId);
	this.send('sessionId:' + this.options.sessionId);
	this.send('configId:' + this.options.configId);
	
	//habilitar el chat si corresponde
	if (MUST_SHOW_CHAT) domAddMessageAsSystem(MSG_CONNECTION_WITH_SERVER_ACQUIRE);
}

function fncChatEvtOnClose() {
	doConsoleLog("fncOnCloseClient");
	//deshabilitar el chat si corresponde
	
	if (MUST_SHOW_CHAT) {
		domAddMessageAsSystem(MSG_CONNECTION_WITH_SERVER_LOST);
		domDisableInputAndButtons(true)
	}
}

function fncChatEvtXmlMessage(xml) {
	var aXml = getFirstChild(xml, 'message');
	
	if (aXml != null) fncProcessXmlMessage(aXml);
}

function fncChatEvtTextMessage(msg) {
	doConsoleLog('message from server: ' + msg);
	if (msg.indexOf('state') == 0) $('sendRequestProgress').set('text', msg);
}

function fncChatEvtEnableChat() {
	MUST_SHOW_CHAT = true;
	if (chat.forceClear) {
		$('chatMessages').empty();
	}
	domAddMessageAsSystem(MSG_ATTENDANT_PRESENT);
	domDisableInputAndButtons(false);
	
	$('bodyStart').addClass('hide');
	$('bodyChat').removeClass('hide');
	
	chat.forceClear = false;
	domAdjustHeights();
}

function fncProcessXmlMessage(xml) {
	var text = '';
	var usrId = xml.getAttribute('userId');
	var user = xml.getAttribute('user');
	var time = xml.getAttribute('time');
	var extraId = xml.getAttribute('extraId');
	var fromMe = xml.getAttribute('fromMe') == 'true';
	
	for (var i = 0; i < xml.childNodes.length; i++) {
		text += xml.childNodes[i].nodeValue;
	}
	
	switch (xml.getAttribute('type')) {
		case MSG_TYPE_NEW_USER:
		case MSG_TYPE_EXIT_USER: break;
		
		case MSG_TYPE_NEW_FILE_TRANFER:
			var domMessage = domAddMessage(usrId, user, ' ', time, fromMe, true);
			domMessage.domMessage.empty();
			domMessage.set('id', 'msg' + extraId);
			domMessage.fileExtraId = extraId;
			domMessage.fileName = text;
			
			if (fromMe) {
				new Element('span', { text: MSG_FILE_WAIT_ACCEPT.replace("$[fileName]", text) + ' ' }).inject(domMessage.domMessage);
			} else {
				new Element('span', { text: MSG_FILE_NEW.replace("$[fileName]", text).replace("$[user]", user) + ' ' }).inject(domMessage.domMessage);
				var btnAccept = new Element('span.button', {text: LBL_ACCEPT}).inject(domMessage.domMessage);
				btnAccept.domMessage = domMessage;
				btnAccept.addEvent('click', fncBtnAcceptFileEvtClick);
			}

			var btnReject = new Element('span.button', {text: LBL_REJECT}).inject(domMessage.domMessage);
			btnReject.domMessage = domMessage;
			btnReject.addEvent('click', fncBtnRejectFileEvtClick);

			break;
			
		case MSG_TYPE_CANCEL_FILE_TRANFER:
			$('msg' + extraId).domMessage.set('html', fromMe ? MSG_FILE_CANCEL_BY_YOU.replace("$[fileName]", text) : MSG_FILE_CANCEL_BY_USER.replace("$[fileName]", text).replace("$[user]", user) );
			break;
			
		case MSG_TYPE_ACCEPT_FILE_TRANFER:
			$('msg' + extraId).domMessage.set('html', fromMe ? MSG_FILE_ACCEPTED_BY_YOU.replace("$[fileName]", text) : MSG_FILE_ACCEPTED_BY_USER.replace("$[fileName]", text).replace("$[user]", user) );
			
			if (! fromMe) { //enviamos el formulario
				
				var chatOptions = $('chatOptions');
				var domIframe = new Element('iframe', {'class': 'hide', id: 'iframe' + extraId, name: 'iframe' + extraId}).inject(chatOptions);
				
				var domMessage = $('msg' + extraId);
				
				var toSend = atmosphere.util.stringifyJSON({
					sessionId: SESSION_ID,
					name: domMessage.fileName,
					transferId: domMessage.fileExtraId
				});
				
				var domForm = $(extraId);
				domForm.set('target', domIframe.name);
				domForm.set('action', URL_FILE_UPDALOAD + "?json=" + toSend);
				domForm.submit();
			}
			
			break;
			
		case MSG_TYPE_SENDING_FILE_TRANFER:
			$('msg' + extraId).domMessage.set('html', fromMe ? MSG_FILE_DOWNLOADING_BY_YOU.replace("$[fileName]", text) : MSG_FILE_DOWNLOADING_BY_USER.replace("$[fileName]", text).replace("$[user]", user) );
			
			break;
			
		case MSG_TYPE_COMPLET_FILE_TRANFER:
			$('msg' + extraId).domMessage.set('html', fromMe ? MSG_FILE_DOWNLOADED_BY_USER.replace("$[fileName]", text) : MSG_FILE_DOWNLOADED_BY_YOU.replace("$[fileName]", text).replace("$[user]", user) );
			
			var form = document.id(extraId);
			var iframe = document.id("iframe" + extraId);

			if (form != null) form.destroy();
			if (iframe != null) iframe.destroy();
			break;

		case MSG_TYPE_ERROR_FILE_TRANFER:
			$('msg' + extraId).domMessage.set('html', MSG_FILE_ERROR_TRANSFER.replace("$[fileName]", text) );
			
			var form = document.id(extraId);
			var iframe = document.id("iframe" + extraId);

			if (form != null) form.destroy();
			if (iframe != null) iframe.destroy();
			break;
			
		case MSG_TYPE_COMMAND: break;
		default:
			domAddMessage(
					usrId, 
					user, 
					text, 
					time, 
					fromMe, 
					false);
	}
	
}

function fncChatEvtRequestSended() {
	if (MUST_SHOW_CHAT) {
		domAddMessageAsSystem(MSG_WAITING_FOR_ATTENDANT);
		domDisableInputAndButtons(true);
	} else {
		$('sendRequestProgress').set('text', MSG_WAITING_FOR_ATTENDANT);
	}
}

function fncChatEvtRequestWaiting() {
	if (MUST_SHOW_CHAT) {
		domAddMessageAsSystem(MSG_STILL_WAITING_FOR_ATTENDANT);
		domDisableInputAndButtons(true);
	} else {
		$('sendRequestProgress').set('text', MSG_STILL_WAITING_FOR_ATTENDANT);
	}
}

function fncChatEvtGroupOffline() {
	domAddMessageAsSystem(MSG_ATTENDANT_NOT_AVAILABLE);
	domDisableInputAndButtons(true);
}

function fncChatEvtInactivityWarning() {
	domAddMessageAsSystem(MSG_INACTIVITY_WARNING);
}

function fncChatEvtInactivityDisconnect() {
	domAddMessageAsSystem(MSG_INACTIVITY_DISCONNECT);
	domDisableInputAndButtons(true);

	chat.forceClear = true;
	chat.send('_exitConversation');
}

/** end client functionalities **/

/** file functionalities **/

function evtBtnSendFileClick(evt) {
	this.domFileToSend.click();
}

function fncBtnRejectFileEvtClick(evt) {
	if (this.hasClass('disabled')) return;
	var toSend = atmosphere.util.stringifyJSON({
		name: this.domMessage.fileName,
		transferId: this.domMessage.fileExtraId
	});
	
	chat.send("_userRejectFile:" + toSend);
}

function fncBtnAcceptFileEvtClick(evt) {
	if (this.hasClass('disabled')) return;
	
	var chatOptions = $('chatOptions');
	var domA = new Element('a.hide', {target: '_new'}).inject(chatOptions);
	
	var toSend = atmosphere.util.stringifyJSON({
		sessionId: SESSION_ID,
		name: this.domMessage.fileName,
		transferId: this.domMessage.fileExtraId
	});
	
	domA.set('href', URL_FILE_DOWNLOAD + "?json=" + toSend);
	domA.click();
	
	domA.destroy();
}

function evtTheFileChange(evt) {
	var theFileName = this.get('value');
	if (theFileName == null || theFileName == "") return;
	if (theFileName.match(/fakepath/)) theFileName = theFileName.replace(/C:\\fakepath\\/i, '');
	
	var formId = "frmFile" + new Date().getTime();
	
	var toSend = atmosphere.util.stringifyJSON({
		name: theFileName,
		transferId: formId
	});
	
	this.domTheForm.addClass('hide');
	this.domTheForm.set('id', formId);
	this.domTheForm.setFileName = theFileName;
	
	chat.send("_userFile:" + toSend);
	
	fncAddNewSendFileForm();
}

function fncAddNewSendFileForm() {
	var defaultForm = $('defaultForm');
	var theForm = defaultForm.clone(true, false);
	theForm.inject(defaultForm, 'after');
	
	var theButton = theForm.getElement('input.theButton');
	var fileToSend = theForm.getElement('input.theFile');
	
	fileToSend.domTheForm = theForm;
	fileToSend.addEvent('change', evtTheFileChange);
	theButton.domFileToSend = fileToSend;
	theButton.addEvent('click', evtBtnSendFileClick);
	theForm.removeClass('hide');
}

/** end file functionalities **/

function evtBtnExitClick(evt) {
	//acá se debe hacern varias cosas para cerrar la conexión y demás
	if (confirm(MSG_EXIST_CONVERSATION_QUESTION)) {
		chat.forceClear = true;
		chat.send('_exitConversation');
		
		MUST_SHOW_CHAT = false;
		
		domDisableEnableForm(false);
		REQUEST_GROUPS = true;
		
		$('bodyStart').removeClass('hide');
		$('bodyChat').addClass('hide');
		
		domDisableInputAndButtons(true);
	}
}

function evtInputKeyPress(evt) {
	if (evt.key == 'enter') {
		chat.send("_userMessage:" + this.innerText);
		this.innerText = '';
	}
	if (this.innerText == '' || this.innerHTML == "<br>") this.placeholder.removeClass('hide'); else this.placeholder.addClass('hide');
}

function evtBtnSendRequest(evt) {
	//acá se debe hacern varias cosas para establecer la conexión y demás
	
	var bodyStartFields = $('bodyStartFields');
	var domDivRequireds = bodyStartFields.getElements('div.required');
	var allDone = true;
	var dataToSend = new Array();
	for (var i = 0; i < domDivRequireds.length; i++) {
		var domDivRequired = domDivRequireds[i];
		var elements = 
			domDivRequired.getElements('input').concat(
			domDivRequired.getElements('select').concat(
			domDivRequired.getElements('textarea').concat()));
		
		var mustShowMessage = false;
		
		for (var j = 0; j < elements.length && ! mustShowMessage; j++) {
			var element = elements[j];
			mustShowMessage = element.value == '';
			dataToSend.push(element.name + '=' + element.value);
		}
		
		if (mustShowMessage) {
			allDone = false;
			if (domDivRequired.domRequiredMessage == null) domDivRequired.domRequiredMessage = new Element('span', {html: MSG_REQUIRED_MSG, 'class': 'requiredMsg'}).inject(domDivRequired);
			domDivRequired.domRequiredMessage.removeClass('hide');
		} else {
			if (domDivRequired.domRequiredMessage != null) domDivRequired.domRequiredMessage.addClass('hide');
		}
	}
	
	if (allDone) {
		doConsoleLog('sending information to server...');
		doConsoleLog('sessionId:' + chat.options.sessionId);
		doConsoleLog('configId:' + chat.options.configId);
		chat.send('sessionId:' + chat.options.sessionId);
		chat.send('configId:' + chat.options.configId);
		
		domDisableEnableForm(true);
		
		doConsoleLog("connectToServer");
		chat.send("connectToServer");
		
		var sendRequestProgress = $('sendRequestProgress');
		
		for (var i = 0; i < dataToSend.length; i++) {
			sendRequestProgress.set('text', 'Sending: ' + dataToSend[i]);
			
			doConsoleLog("_formData:" + dataToSend[i]);
			chat.send("_formData:" + dataToSend[i]);
		}
		doConsoleLog("sendRequest");
		chat.send("sendRequest");
	}
}

function fncChatEvtInvalidGroup() {
	domDisableEnableForm(false);
}

function domDisableEnableForm(disable) {
	var bodyStart = $('bodyStart');
	var bodyChat = $('bodyChat');
	var sendRequestProgress = $('sendRequestProgress');
	
	sendRequestProgress.empty();
	
	var formElements = new Array();
	formElements.append(bodyStart.getElements('input'));
	formElements.append(bodyStart.getElements('select'));
	formElements.append(bodyStart.getElements('textarea'));
	formElements.push($('sendRequest'));
	
	for (var i = 0; i < formElements.length; i++) {
		var ele = formElements[i];
		ele.disabled = disable;
	}
		
	if (disable) {
		sendRequestProgress.removeClass('hide');
	} else {
		sendRequestProgress.addClass('hide');
	}
}

function domDisableInputAndButtons(disable) {
	if (disable) {
		$('chatOptions').addClass('disableSend');
		$('chatMessages').getElements('span.button').addClass('disabled');
	} else {
		$('chatOptions').removeClass('disableSend');
		$('chatMessages').getElements('span.button').removeClass('disabled');
	}
}

function domAddMessageAsSystem(msg) {
	domAddMessage('-1', 'System', msg, getCurrentTime(), false, true);
}

function domAddMessage(usrId, user, text, time, fromMe, fromSystem) {
	if (text == '') return null;
	
	var usrClass = 'usr_' + usrId;
	var chatMessages = $('chatMessages');
	var domMessage = new Element('div.aMessage').inject(chatMessages);
	domMessage.addClass(usrClass);
	domMessage.domFrom = new Element('span.from', {html: user}).inject(domMessage);
	domMessage.domMessage = new Element('span.message', {html: text}).inject(domMessage);
	domMessage.domTime = new Element('span.time', {html: time}).inject(domMessage);
	
	if (fromSystem) domMessage.addClass('fromSystem');
	else if (fromMe) domMessage.addClass('fromMe');
	chatMessages.fxScroll.toBottom();
	
	var domPrevious = domMessage.getPrevious();
	if (domPrevious != null && domPrevious.hasClass(usrClass) == domMessage.hasClass(usrClass)) domMessage.addClass('continue');
	
	return domMessage;
}

function getCurrentTime() {
	var date = new Date();
	var minutes = '' + date.getMinutes();
	if (minutes.length == 1) minutes = '0' + minutes;
	
	return date.getHours() + ':' + minutes;
}

function domAdjustHeights() {
	var bodyChat = $('bodyChat');
	if (bodyChat.hasClass('hide')) return;
	
	var header = $('chatHeader');
	var container = $('chatMessagesContainer');
	var footer = $('chatOptions');
	
	
	container.setStyle('height', (getStageHeight() - header.offsetHeight - footer.offsetHeight) + 'px');
	doConsoleLog('adjust height: ' + (getStageHeight() - header.offsetHeight - footer.offsetHeight) + 'px')
}

function getStageHeight() {
	if(navigator.userAgent.indexOf("MSIE") >= 0){
		var height = document.body.parentElement.clientHeight;
		if(document.body.parentElement.clientHeight == 0){
			height = document.body.clientHeight;
		}
		return height;
	}else{
		return height = window.innerHeight;
	}
}