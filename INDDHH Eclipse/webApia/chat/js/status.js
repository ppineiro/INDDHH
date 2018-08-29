var CHAT_STATUS = null;

function initStatus(URL, CONFIG_ID) {
	CHAT_STATUS = $('chatStatus');
	CHAT_STATUS.addEvent('click', fncOpenChat);
	
//	initWebSocket({
//		url: URL ,
//		contentType: 'text/plain',
//		onMessage: fncOnMessage,
//		onOpen: fncOnOpen,
//		onClose: fncOnClose,
//		aditionalConfiguration: {
//			configId: CONFIG_ID
//		}
//	});
	
	fncOnClose();
}

function fncOnOpen(response) {
	this.send('configId:' + this.aditionalConfiguration.configId);
}

function fncOnClose() {
	CHAT_STATUS.removeClass('chatActive');
	
	initWebSocket({
		url: URL ,
		contentType: 'text/plain',
		onMessage: fncOnMessage,
		onOpen: fncOnOpen,
		onClose: fncOnClose,
		aditionalConfiguration: {
			configId: CONFIG_ID
		}
	});
}

function fncOnMessage(response) {
	var message = response.responseBody;
	if (message != 'invalid')	CHAT_STATUS.removeClass('invalid');
	if (message != 'active')	CHAT_STATUS.removeClass('chatActive');
	
	if (message == 'invalid')		CHAT_STATUS.addClass('invalid');
	else if (message == 'active')	CHAT_STATUS.addClass('chatActive');
	else 							CHAT_STATUS.removeClass('chatActive');
}

function fncOpenChat() {
	if (! this.hasClass('chatActive')) return false;
	
	var height = 410;
	var width = 270;
	
	var url = "client.jsp?id=" + CONFIG_ID;
	
	var top = ((screen.availHeight-30) / 2) - (height / 2);
	var left = ((screen.availWidth-10) / 2) - (width / 2);

	var valores = "height= " + height + " , " + "width= " + width;
	valores = "toolbar=no,location=no,status=no,menubar=no,resizable=yes,scrollbars=no,top=" + top + ",left=" + left + "," + valores;
	x="\"";
	valores = x + valores + x;
	window.open (url, "chatExternalWindow", valores);
	
	return false;
}
