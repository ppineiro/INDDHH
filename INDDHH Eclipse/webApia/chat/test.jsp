<html><head><title>WebSocket Test</title><meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" /><style type="text/css">
		body,td,pre,textarea,input,select		{ font-family: verdana; font-size: 10px; margin: 0px; }
		
		.newTest { font-weight: bold; margin-top: 5px; }
		.endTest { margin-bottom: 5px; }
	</style><script language="JavaScript" type="text/javascript" src="<%= request.getContextPath() %>/chat/js/mootools-core-1.4.5-full-compat.js"></script><script language="JavaScript" type="text/javascript" src="<%= request.getContextPath() %>/chat/js/mootools-more-1.4.0.1-compat.js"></script><script language="JavaScript" type="text/javascript" src="<%= request.getContextPath() %>/chat/js/atmosphere.js"></script><script language="javascript" type="text/javascript">
		window.addEvent('load', function() {
			$('btnStartTest').addEvent('click', fncBtnStartTestEvtClick);
		});
		
		var TEST_TO_RUN = 0;
		var URL = "<%= request.getContextPath() %>/testWebSocket/test:" + (new Date().getTime());
		var WEB_TRANSPORT = ['websocket','streaming', 'sse'];
		var WEB_TRANSPORT_CURRENT = 0;
		
		var WEB_SOCKET_TEST = null;
		var START_TIME = null;
		
		function fncBtnStartTestEvtClick() {
			this.disabled = true;
			testResult.empty();
			START_TIME = new Date().getTime();
			
			domCreateLog('Start test', 'newTest');
			domCreateLog('Testing transport protocols will be: ' + WEB_TRANSPORT);
			domCreateLog('Main transport protocol: ' + WEB_TRANSPORT[WEB_TRANSPORT_CURRENT]);
			domCreateLog('Creation of main object...');
			WEB_SOCKET_TEST = fncTestCreateObject();
		}
		
		function fncTestCreateObject() {
			domCreateLog('Testing url: ' + URL);
			var webRequest = {
				url: URL,
				contentType : 'text/plain', 
				trackMessageLength : true,
				shared : false,
				transport : WEB_TRANSPORT[WEB_TRANSPORT_CURRENT],
				fallbackTransport: WEB_TRANSPORT[(WEB_TRANSPORT_CURRENT + 1 < WEB_TRANSPORT.length) ? WEB_TRANSPORT_CURRENT + 1 : WEB_TRANSPORT_CURRENT],
				webTransportCurrent: WEB_TRANSPORT_CURRENT
			};
			
			webRequest.aditionalConfiguration = {};
			webRequest.onTransportFailure = function(errorMsg, request) {
				if (window.EventSource) {
					request.webTransportCurrent ++;
					
					if (request.webTransportCurrent < WEB_TRANSPORT.length) {
						var nextTransport = request.webTransportCurrent + 1;
						if (nextTransport >= WEB_TRANSPORT.length)  nextTransport = WEB_TRANSPORT.length - 1;
						request.transport = WEB_TRANSPORT[request.webTransportCurrent];
						request.fallbackTransport = WEB_TRANSPORT[nextTransport];
					}
					
					domCreateLog("Transpor failure, new transport protocol: " + request.transport + " - fallback transport will be: " + request.fallbackTransport);
				}
			};
			
			webRequest.send = function(msg) {
				this.aditionalConfiguration.webSocketWritter.push(msg); 
			}
			webRequest.onOpen				= fncWebSocketOnOpen;
			webRequest.onMessage			= fncWebSocketOnMessage;
			webRequest.onClose				= fncWebSocketOnClose;

			webRequest.onError				= fncWebSocketOnError;
	        webRequest.onReopen				= fncWebSocketOnReopen;
	        webRequest.onReconnect			= fncWebSocketOnReconnect;
	        webRequest.onMessagePublished	= fncWebSocketOnMessagePublished;
	        webRequest.onLocalMessage		= fncWebSocketOnLocalMessage;
	        webRequest.onFailureToReconnect	= fncWebSocketOnFailureToReconnect;
	        webRequest.onClientTimeout		= fncWebSocketOnCLientTimeout;
	        webRequest.onOpenAfterResume	= fncWebSocketOnOpenAfterResume;
			
			webRequest.aditionalConfiguration.webSocketWritter = atmosphere.subscribe(webRequest);
			
			return webRequest;
		}
		
		function fncWebSocketOnError(response) { domCreateLog("fncWebSocketOnError"); }
		function fncWebSocketOnReopen(response) { domCreateLog("fncWebSocketOnReopen"); }
		function fncWebSocketOnReconnect(response) { domCreateLog("fncWebSocketOnReconnect"); }
		function fncWebSocketOnMessagePublished(response) { domCreateLog("fncWebSocketOnMessagePublished"); }
		function fncWebSocketOnLocalMessage(response) { domCreateLog("fncWebSocketOnLocalMessage"); }
		function fncWebSocketOnFailureToReconnect(response) { domCreateLog("fncWebSocketOnFailureToReconnect"); }
		function fncWebSocketOnCLientTimeout(response) { domCreateLog("fncWebSocketOnCLientTimeout"); }
		function fncWebSocketOnOpenAfterResume(response) { domCreateLog("fncWebSocketOnOpenAfterResume"); }
		
		function fncStartTest1() {
			domCreateLog('Start test 1 - Information in server', 'newTest');
			WEB_SOCKET_TEST.send('start test 1');
		}
		
		function fncStartTest2() {
			domCreateLog('Start test 1 - Messages from server', 'newTest');
			WEB_SOCKET_TEST.send('start test 2');
		}
		
		function fncStartTest3() {
			domCreateLog('Start test 3 - Echo messages', 'newTest');
			domCreateLog('Sending: ' + 'start test 3');	WEB_SOCKET_TEST.send('start test 3');
			domCreateLog('Sending: ' + 'echo 1');		WEB_SOCKET_TEST.send('echo 1');
			domCreateLog('Sending: ' + 'echo 2');		WEB_SOCKET_TEST.send('echo 2');
			domCreateLog('Sending: ' + 'echo 3');		WEB_SOCKET_TEST.send('echo 3');
		}
		
		function fncEndTesting() {
			domCreateLog('Closing connection');
			domCreateLog('Test time (ms): ' + (new Date().getTime() - START_TIME));
			WEB_SOCKET_TEST.aditionalConfiguration.webSocketWritter.request.close();
			TEST_TO_RUN = 0;
			$('btnStartTest').disabled = false;
		}
		
		function fncWebSocketOnOpen(response) { 
			domCreateLog("Web socket open - status: " + response.status + " - transport: " + response.transport, 'endTest');
			fncStartNextTest()
		}
		
		function fncStartNextTest() {
			TEST_TO_RUN ++;
			switch (TEST_TO_RUN) {
				case 1: fncStartTest1.delay(200); break;
				case 2: fncStartTest2.delay(200); break;
				case 3: fncStartTest3.delay(200); break;
				default: fncEndTesting.delay(200);
			}
		}
		
		function fncProcessTestResult(result) {
			switch (TEST_TO_RUN) {
				case 1: break;
				case 2: 
				case 3: domCreateLog("Message from server: " + result); break;
			}
		}
		
		function fncWebSocketOnClose(response) {
			domCreateLog("Web socket close - status: " + response.status + " - transport: " + response.transport);
		}
		
		function fncWebSocketOnMessage(response) { 
			var msg = response.responseBody;
			
			if (msg == "test ended") {
				domCreateLog("Test ended from server", 'endTest');
				fncStartNextTest();
			} else {
				fncProcessTestResult(msg);
			}
		}
		
		function domCreateLog(msg, extraCss) {
			var ele = new Element('div', {html: msg}).inject($('testResult'));
			if (extraCss != null) ele.addClass(extraCss);
		}
	</script></head><body><h1>Web Socket Testing</h1><p>The <strong>Web Socket Testing page</strong> will execute a series of test over a web socket connection between your browser and the server. You will be able to see the browser result, but to see the server results, you may need to see the web server standard output log.</p><p>The test may take some seconds. During the test, please avoid refreshing the current page.</p><p>In order to start the test, please click <input type="button" id="btnStartTest" value="here"></p><hr><div class="testResult" id="testResult"></div></body></html>