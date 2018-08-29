var WEB_TRANSPORT = ['websocket','streaming', 'sse'];

var DEFAULT_CONTENT_TYPE = "application/json";

function initWebSocket(options) {
	var WEB_TRANSPORT_CURRENT = 0;
	
	var webRequest = {
		url: options.url,
		contentType : options.contentType, 
		trackMessageLength : true,
		shared : false,
		transport : WEB_TRANSPORT[WEB_TRANSPORT_CURRENT],
		fallbackTransport: WEB_TRANSPORT[(WEB_TRANSPORT_CURRENT + 1 < WEB_TRANSPORT.length) ? WEB_TRANSPORT_CURRENT + 1 : WEB_TRANSPORT_CURRENT],
		webTransportCurrent: WEB_TRANSPORT_CURRENT
	};
	
	webRequest.aditionalConfiguration = options.aditionalConfiguration;
	webRequest.onTransportFailure = function(errorMsg, request) {
		if (window.EventSource) {
			request.webTransportCurrent ++;
			
			if (request.webTransportCurrent < WEB_TRANSPORT.length) {
				var nextTransport = request.webTransportCurrent + 1;
				if (nextTransport >= WEB_TRANSPORT.length)  nextTransport = WEB_TRANSPORT.length - 1;
				request.transport = WEB_TRANSPORT[request.webTransportCurrent];
				request.fallbackTransport = WEB_TRANSPORT[nextTransport];
			}
		}
	};
	
	webRequest.send = function(msg) {
		this.aditionalConfiguration.webSocketWritter.push(msg); 
	}
	if (options.onOpen) webRequest.onOpen = options.onOpen;
	if (options.onMessage) webRequest.onMessage = options.onMessage;
	if (options.onClose) webRequest.onClose = options.onClose;

	if (webRequest.aditionalConfiguration == null) webRequest.aditionalConfiguration = {};
	webRequest.aditionalConfiguration.webSocketWritter = atmosphere.subscribe(webRequest);
	
	return webRequest;
}

function parseXML(xmlString) {
	if (document.implementation && document.implementation.createDocument) {
		xmlDoc = new DOMParser().parseFromString(xmlString, 'text/xml');
	}  else if (window.ActiveXObject) {
		xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc.loadXML(xmlString);
	}
	return xmlDoc;
}

function getFirstChild(xml, name) {
	var childs = xml.getElementsByTagName(name);
	return childs != null && childs.length > 0 ? childs[0] : null;
}

function doConsoleLog(msg) {
	if (true) console.log(msg);
}