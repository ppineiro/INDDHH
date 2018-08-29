/*
 * Constructor options
 * 	url
 * 
 * Events
 * 
 * 	state:connected
 *	state:connectionError
 *	state:invalidGroup
 *	state:invalidRequest
 *	state:requestSended
 *  state:requestWaiting
 *	state:requestAccepted
 *	state:dataFormSend
 *	state:readyToReceiveMessages
 *	state:lastMessageNotSend
 *  state:groupOffline
 *  state:fileTransferComplete:{name: <file name>, transferId: <transferId>}
 *  state:fileTransferError:{name: <file name>, transferId: <transferId>}
 * 
 *  state:inactivityWarning
 *  state:inactivityDisconnect
 * 
 *	onOpen
 *  xmlMessage
 *  textMessage
 *  onClose
 */
var MSG_TYPE_NEW_USER				= '1';
var MSG_TYPE_EXIT_USER				= '2';
var MSG_TYPE_NEW_FILE_TRANFER		= '1001';
var MSG_TYPE_ACCEPT_FILE_TRANFER	= '1002';
var MSG_TYPE_CANCEL_FILE_TRANFER	= '1003';
var MSG_TYPE_COMPLET_FILE_TRANFER	= '1004';
var MSG_TYPE_SENDING_FILE_TRANFER	= '1005';
var MSG_TYPE_ERROR_FILE_TRANFER		= '1006';
var MSG_TYPE_COMMAND				= '1008';

var Chat = new Class({
	Implements: [Chain, Events, Options],
	
	options: {
	},
	
	initialize: function(options) {
		this.setOptions(options);
		this.webSocket = initWebSocket({
			url: this.options.url,
			contentType: 'text/plain',
			onMessage: this.fncOnMessageClient,
			onOpen: this.fncOnOpenClient,
			onClose: this.fncOnCloseClient,
			aditionalConfiguration: {
				parent: this
			}
		});
	},
	
	fncOnMessageClient: function(response) {
		var msg = response.responseBody;
		
		if (msg.indexOf('state:') == 0) {
			var event = msg.substring(6);
			var index = event.indexOf(":")
			obj = null;
			
			if (index > -1) {
				var json = event.substring(index + 1);
				event = event.substring(0, index);
				
				obj = atmosphere.util.parseJSON(json);
			}
			doConsoleLog('calling event: ' + msg);
			this.aditionalConfiguration.parent.fireEvent(event, obj);
		} else if (msg.indexOf("<") == 0) {
			this.aditionalConfiguration.parent.fireEvent('xmlMessage', parseXML(msg));
		} else {
			this.aditionalConfiguration.parent.fireEvent('textMessage', msg);
		}
	},
	
	fncOnOpenClient: function(response) {
		this.aditionalConfiguration.parent.fireEvent('onOpen');
	},
	
	fncOnCloseClient: function() {
		this.aditionalConfiguration.parent.fireEvent('onClose');
	},
	
	send: function(msg) {
		this.webSocket.send(msg);
	}
});