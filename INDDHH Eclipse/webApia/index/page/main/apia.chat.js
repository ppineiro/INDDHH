function xmlElementsToArray(elements) {
	var result = new Array();
	for (var i = 0; i < elements.length; i++) {
		result.include(elements[i]);
	}
	return result;
}

var formatDate = function (formatDate, formatString) {
	if(formatDate instanceof Date) {
		var yyyy = formatDate.getFullYear();
		var yy = yyyy.toString().substring(2);
		var m = formatDate.getMonth() + 1;
		var mm = m < 10 ? "0" + m : m;
		var d = formatDate.getDate();
		var dd = d < 10 ? "0" + d : d;
		
		var h = formatDate.getHours();
		var hh = h < 10 ? "0" + h : h;
		var n = formatDate.getMinutes();
		var nn = n < 10 ? "0" + n : n;
		var s = formatDate.getSeconds();
		var ss = s < 10 ? "0" + s : s;

		formatString = formatString.replace(/yyyy/i, yyyy);
		formatString = formatString.replace(/yy/i, yy);
		formatString = formatString.replace(/MM/i, mm);
		formatString = formatString.replace(/dd/i, dd);
		formatString = formatString.replace(/hh/i, hh);
		formatString = formatString.replace(/mm/i, nn);
		formatString = formatString.replace(/ss/i, ss);

		return formatString;
	} else {
		return "";
	}
}

var uiChat = null;


function toggleChatMainUi() {
	if (uiChat == null) startChat();
	uiChat.toggleMainUi();
}

/**
 * ApiaChatUrl: encargado de enviar los datos y procesar la informaci�n que le llega.
 * Es el �nico que es capaz de enviar informaci�n al servidor, procesar el resultado 
 * y llamar a los m�todos correspondientes seg�n el XML devuelto por el servidor.
 * 
 */
ApiaChatUrl = new Class({
	Implements: [Options, Events],
	
	options: {
		url: null,
		ui: null,
		delay: 1000 //default time in milisec to refresh the status
	},

	//--- Constructors --------------------------
	initialize: function(options) {
		//Set options
		this.setOptions(options);
		this.refreshDelay = null;
		this.chatUsersFilter = $('chatUsersFilter'); //para acceder mas rapido
	},
	
	sendData: function(data, action, locking) {
		var owner = this;
		new Request( {
			method: 'post',
			data: data,
			async: !locking,
			url: this.options.url + '?action=' + action + TAB_ID_REQUEST,
			onSuccess: function(text, xmlResponse) { owner.processXml(xmlResponse); },
			onRequest: function() { },
			onFailure: function() { owner.errorConnection(); }
		} ).send();
	},
	
	setUi: function(ui) {
		this.options.ui = ui;
	},
	
	//--- Send information methods --------------
	sendLogin:					function(user, group)			{ this.sendData("name=" + user + "&group=" + group, "register"); },
	doLogout:					function(locking)				{ if (this.refreshDelay) { $clear(this.refreshDelay); this.refreshDelay = null; } this.sendData("", "unregister", locking); },
	refresh:					function()						{ this.sendData("usrFilter=" + this.chatUsersFilter.get('value'), "callback");},
	sendMessage:				function(id, msg)				{ this.sendData("conversationId=" + id + "&message=" + msg, "sendMessage"); },
	quitConversation:			function(id)					{ this.sendData("conversationId=" + id, "quitConversation"); },
	aceptConversationRequest:	function(requestId, groupId)	{ this.sendData("groupId=" + groupId + "&requestId=" + requestId, "acceptConversationRequest"); },
	requestConversation:		function(withId, about)			{ this.sendData("title=" + about + "&groupId=" + withId, "sendConversationRequest"); },
	startConversation: 			function(withId, about)			{ this.sendData("title=" + about + "&userId=" + withId, "startConversation"); },
	rejectFile:					function(conId, id, fileName)	{ this.sendData("transferId=" + id + "&fileName=" + fileName + "&conversationId=" + conId, "cancelTransfer"); },
	newTransfer:				function(conId, id, fileName)	{ this.sendData("transferId=" + id + "&fileName=" + fileName + "&conversationId=" + conId, "newTransfer"); },
	joinToConversation:			function(id, userId)			{ this.sendData("conversationId=" + id + "&userId=" + userId, "joinToConversation"); },
	joinGroupToConversation:	function(id, userId, title)		{ this.sendData("conversationId=" + id + "&groupId=" + userId + "&title=" + title, "sendConversationRequest"); },
	transferConversation:		function(id, userId)			{ this.sendData("conversationId=" + id + "&userId=" + userId, "transferConversation"); },
	transferGroupConversation:	function(id, userId, title)		{ this.sendData("conversationId=" + id + "&groupId=" + userId + "&title=" + title + "&transfer=true", "sendConversationRequest"); },
	sendCommand:				function(id, cmdId, command)	{ this.sendData("conversationId=" + id + "&cmd=" + command+ "&cmdId=" + cmdId+ "&ts=" + new Date().getTime(), "command"); },
	acceptCommand:				function(id, cmdId, command, ts){ this.sendData("conversationId=" + id + "&cmd=" + command+ "&cmdId=" + cmdId + "&ts=" + ts, "acceptCommand"); },
	cancelCommand:				function(id, cmdId, ts)			{ this.sendData("conversationId=" + id + "&cmdId=" + cmdId + "&ts=" + ts, "cancelCommand"); },
	sendConversationStarted: 	function(id)					{ this.sendData("conversationId=" + id, "conversationStarted"); },
	
	//--- Process information methods -----------
	errorConnection: function() {
		this.options.ui.processErrorConnection();
	},
	
	processXml: function(xml) {
		
//		if(window.console)
//			console.log(xml.getElementsByTagName("requests")[0]);
		
		var status = xml.getElementsByTagName("status")[0];
		this.options.ui.processLoginStatus(status);

		if (this.options.ui.logged && status != null && status.getAttribute("recall") == "true") {
			this.processUsers(xml.getElementsByTagName("users")[0]);
			this.processGroups(xml.getElementsByTagName("groups")[0]);
			this.processRequests(xml.getElementsByTagName("requests")[0]);

			this.processConversations(xml.getElementsByTagName("conversations")[0]);
			
			this.processBroadcasts(xml.getElementsByTagName("broadcasts")[0]);
			
			this.refreshDelay = this.refresh.delay(this.options.delay,this);
		} else {
			var i = 1;
			i++;
			i = i - 1;
		}
		var errMessage = status.getAttribute("error");
		if(errMessage && errMessage != null)
			showMessage(errMessage, "Error", "modalWarning");
	}, 
	
	processUsers: function(xml) {
		var elements = new Array();
		if (xml != null) {
			$each(xmlElementsToArray(xml.getElementsByTagName("user")), function(element, index) {
				elements.include({
					name: element.getAttribute('name'), 
					id: element.getAttribute('id'),
					display: element.getAttribute('display')
				});
			});
		}
		this.options.ui.processUsers(elements);
	},
	
	processGroups: function(xml) {
		var elements = new Array();
		if (xml != null) {
			$each(xmlElementsToArray(xml.getElementsByTagName("group")), function(element, index) {
				elements.include({
					name: element.getAttribute('name'), 
					id: element.getAttribute('id'),
					members: element.getAttribute('members')
				});
			});
		}
		this.options.ui.processGroups(elements);
	},
	
	processRequests: function(xml) {
		var elements = new Array();
		if (xml != null) {
			$each(xmlElementsToArray(xml.getElementsByTagName("request")), function(element, index) {
				
				var title = "";
				if(element.firstChild) {
					if(element.firstChild.nodeValue) {
						title = element.firstChild.nodeValue;
					} else if(window.XMLSerializer) {
						title = new XMLSerializer().serializeToString(element.firstChild);
					} else if (element.firstChild.xml){
						title = element.firstChild.xml;
					}
				}
				
				elements.include({
					id: element.getAttribute('id'), 
					groupName: element.getAttribute('group'),
					groupId: element.getAttribute('groupId'), 
					userName: element.getAttribute('user'),
					title: title
				});
			});
		}
		this.options.ui.processRequests(elements);
	},
	
	processBroadcasts: function(xml) {
		var elements = new Array();
		if (xml != null) {
			$each(xmlElementsToArray(xml.getElementsByTagName("message")), function(element, index) {
				elements.include({
					from: element.getAttribute('from'), 
					fromMe: element.getAttribute('fromMe'), 
					block: element.getAttribute('block'), 
					message: (element.firstChild != null) ? element.firstChild.nodeValue : ""
				});
			});
		}
		this.options.ui.processBroadcasts(elements);
	},
	
	processConversations: function(xml) {
		var elements = new Array();
		if (xml != null) {
			$each(xmlElementsToArray(xml.getElementsByTagName("conversation")), function(element, index) {
				var aConversation = {
					id: element.getAttribute("id"),
					title: element.getAttribute("title"),
					participants: new Array(),
					messages: new Array()
				};
				
				var participants = element.getElementsByTagName("members")[0];
				if (participants != null) {
					$each(xmlElementsToArray(participants.getElementsByTagName("user")), function(member, index) {
						var id = member.getAttribute("id");
						var name = member.getAttribute("name");
	
						aConversation.participants.include({id: id, name: name});
					});
				}
	
				var messages = element.getElementsByTagName("messages")[0];
				if (messages != null) {
					var xml_messages = messages.getElementsByTagName("message");
					if(xml_messages.length) {
						$each(xmlElementsToArray(xml_messages), function(message, index) {
							var from	= message.getAttribute("from");
							var msg		= (message.firstChild != null) ? message.firstChild.nodeValue : "";
							var type	= message.getAttribute("type");
							var extraId	= message.getAttribute("extraId");
							var fromMe	= message.getAttribute("fromMe");	
							aConversation.messages.include({from: from, message: msg, type: type, extraId: extraId, fromMe: fromMe});
						});
					} else {
						//TODO: El mensaje de inicio de conversaci�n se deber�a lanzar cuando se inicia la conversaci�n directamente
						//uiChat.mainUi.options.url.sendConversationStarted(aConversation.id);
					}
				}
				
				elements.include(aConversation);
			});
		}
		this.options.ui.processConversations(elements);
	}
});

/**
 * ApiaChatUI se encarga de mantener todo junto y es el que sabe que hacer y cuando hacerlo.
 */
ApiaChatUI = new Class({
	Implements: [Options, Events],
	
	options: {
		url: null,
		hasLogin: true, 		//Indica si tiene secci�n de login
		loginTitle: '',
		hasMain: true,			//Indica si tiene pantalla principal
		mainTitle: '',
		widthMain: 250,
		heightMain: 500,
		openMainOnLogged: true,
		onCloseMainDisconect: true,
		hasConversations: true,	//Indica si tiene pantallas de conversaci�n
		delayRefresh: APIACHAT_FREQUENCY_CALLBACK //1000 //Refresh de callback
	},
	
	//--- Constructors --------------------------
	initialize: function(options) {
		this.setOptions(options);
		this.checkingStatus = false;
		
		//Parte l�gica
		this.listConversationsUi = new Hash();	//Contenedor de conversaciones para su procesamiento
		this.listUsers = new Hash();		//Contenedor de usuarios (id,ApiaChatUser)
		this.listGroups = new Hash();		//Contenedor de groups (id,ApiaChatGroup)
		this.listRequests = new Hash();		//Contenedor de solicitudes (id,ApiaChatConversationRequest)
		
		this.logged = false;
		this.id = null;
		
		this.loginUi = null;
		this.mainUi = null;
		
		//Elementos
		this.url = new ApiaChatUrl({ //Crear elemento para las urls
			url: this.options.url,
			ui: this,
			delay: this.options.delayRefresh
		});
		
		//Parte gr�fica
		if (this.options.hasLogin) {
			this.loginUi = new ApiaChatLogin({
				label: this.options.loginTitle,
				url: this.url
			});
		};
		
		if (this.options.hasMain) {
			this.mainUi = new ApiaChatMain({
				label: this.options.mainTitle,
				width: this.options.widthMain,
				height: this.options.heightMain,
				url: this.url,
				onCloseDisonect: this.options.onCloseMainDisconect
			});
			this.mainUi.owner = this;
		};
		
		this.url.setUi(this);
		if (this.options.hasLogin) { this.loginUi.setUrl(this.url); }
		if (this.options.hasMain) { this.mainUi.setUrl(this.url); }
		
		//Desconexion autmatica en caso de que se cierre la ventana
		window.onbeforeunload = function() {
			this.url.doLogout(true);
		}.bind(this);
	},
	
	//Parte gr�fica
	showLogin: function() { if (this.options.hasLogin) this.loginUi.open(); },
	showMain: function() { if (this.options.hasMain) this.mainUi.open(); },
	closeLogin: function() { if (this.options.hasLogin) this.loginUi.close(); },
	closeMain: function() { if (this.options.hasMain) this.mainUi.close(); },
	toggleMainUi: function() {
		if (this.options.hasMain) {
			if (this.mainUi.isOpen()) {
				this.closeMain();
			} else {
				this.showMain();
			}
		}
	},
	
	doLogin: function() {
		this.checkStatus();
	},
	
	doLogout: function(forceInterface) {
		if (! forceInterface && ! this.isLogged()) return;
		
		this.logged = false;
		
		this.closeMain();
		
		if (! forceInterface) this.url.doLogout();
		
		this.mainUi.clearUsers();
		this.mainUi.clearGroups();
		this.mainUi.clearRequests();
		
		if (this.options.hasMain) this.mainUi.dialog.fireEvent('logoutDone');
		
		if (! forceInterface) {
			var activeChats = $('tabContentContainer').getElements("div.chat-window");
			if(activeChats && activeChats.length) {
				activeChats.each(function(chat) {
					var chatContent = chat.getElement('div.chat-content');
					chatContent.getElement('input').set("disabled", "true");
					var chatPrps = chatContent.getElement('div.chat-prps')
					var chatPrpOps = chatContent.getElement('div.chat-prp-opts');
					var fileContainer = chatContent.getElement('div.file-container');
					if(chatPrps) chatPrps.destroy();
					if(chatPrpOps) chatPrpOps.destroy();
					if(fileContainer) fileContainer.destroy();
				});
			}
		}
		
		if (! this.automaticDisconnect) this.listConversationsUi.empty();
		this.listUsers.empty();
		this.listGroups.empty();
		this.listRequests.empty();
		
		this.showLogin();
	},

	//Parte logica
	processUsers: function(elements) {
		var toProcess = new Hash();
		$each(elements, function(element, index) { toProcess.set(element.id, element); });

		var toRemove = new Array();
		$each(this.listUsers.getKeys(), function(key, index) {
			if (toProcess.has(key)) {
				toProcess.erase(key);
			} else {
				toRemove.include(key);
			}
		});
		
		$each(toRemove, function(key, index) { this.listUsers.erase(key); }, this);
		$each(toProcess.getValues(), function(element, index) { this.listUsers.set(element.id, element); }, this);
		
		if (this.options.hasMain) this.mainUi.keepUsers(this.listUsers.getValues());
	},
	
	processGroups: function(elements) {
		var toProcess = new Hash();
		$each(elements, function(element, index) { toProcess.set(element.id, element); });

		var toRemove = new Array();
		$each(this.listGroups.getKeys(), function(key, index) {
			if (toProcess.has(key)) {
				this.listGroups.get(key).members = toProcess.get(key).members;
				toProcess.erase(key);
			} else {
				toRemove.include(key);
			}
		}, this);
		
		$each(toRemove, function(key, index) { 
			var toRemove = this.listGroups.erase(key);
		}, this);
		$each(toProcess.getValues(), function(element, index) { this.listGroups.set(element.id, element); }, this);

		
		if (this.options.hasMain) this.mainUi.keepGroups(this.listGroups.getValues());
	},
	
	processRequests: function(elements) {
		var toProcess = new Hash();
		$each(elements, function(element, index) { toProcess.set(element.id, element); });
		
		var toRemove = new Array();
		$each(this.listRequests.getKeys(), function(key, index) {
			if (toProcess.has(key)) {
				toProcess.erase(key);
			} else {
				toRemove.include(key);
			}
		});
		
		$each(toRemove, function(key, index) { this.listRequests.erase(key); }, this);
		$each(toProcess.getValues(), function(element, index) { 
			this.listRequests.set(element.id, element);
			
			Generic.createNotification(LBL_CHAT_NEW_REQ_FOR + ' ' + element.groupName, LBL_CHAT_SUBJECT + ': ' + element.title + '\n' + LBL_CHAT_USER + ': ' + element.userName, Generic.showCurrentWindow);
		}, this);

		if (this.options.hasMain) {
			if (this.mainUi.keepRequests(this.listRequests.getValues()) && ! this.mainUi.isOpen()) {
				this.showMain();
			}
		}
	},
	
	processBroadcasts: function(messages) {
		$each(messages, function(message) {
			if (message.block == "true") {
				
				Generic.createNotification(CHAT_LBL_BY + ": " + message.from, message.message, Generic.showCurrentWindow);
				
				SYS_PANELS.newPanel();
				var panel = SYS_PANELS.getActive();
				panel.header.innerHTML = CHAT_LBL_BY + ": " + message.from;
				
				new Element("div", {'html': message.message}).inject(panel.content)
				
				SYS_PANELS.addClose(panel);
				SYS_PANELS.refresh();
			} else {
				(function() {
					new Message({
					  title: CHAT_LBL_BY + ': ' + message.from,
					  message: message.message,
					  stack: true,
					  waitTime: 4000
					}).say();
					Generic.createNotification(CHAT_LBL_BY + ': ' + message.from, message.message, Generic.showCurrentWindow);
				}).delay(250)
			}
		});
	},
	
	processConversations: function(elements) {
		var toProcess = new Hash();
		$each(elements, function(element, index) { toProcess.set(element.id, element); });
		
		var toRemove = new Array();
		$each(toProcess.getKeys(), function(key, index) {
			if (! toProcess.has(key)) {
				toRemove.include(key);
				return;
			}
			var openIsMessages = true;
			var element = toProcess.get(key);
			var aConversation = this.listConversationsUi.get(key);
			if (aConversation == null) {
				aConversation = new ApiaChatConversation({
					id: element.id,
					label: element.title,
					url: this.url,
					owner: this
				});
				this.listConversationsUi.set(key,aConversation);
				if (this.options.hasConversations) aConversation.open();
				
				/****/
				if(element.participants && element.participants.length && element.messages && element.messages[0]) {
					//if(element.participants[0].name != CURRENT_USER_LOGIN) {
					if(element.messages[0].from != CURRENT_USER_LOGIN) {
						//No inicie el chat
						var participants_names = '';
						element.participants.each(function(participant) {
							if(participants_names)
								participants_names += ', ';
							participants_names += participant.name;
						});
						
						Generic.createNotification(CHAT_TIT_NEW_CON, LBL_CHAT_SUBJECT  + ': ' + element.title + '\n' + CHAT_PNL_PART + ': ' + participants_names, Generic.showCurrentWindow);
					}
				} else {
					if(!this.queuedNotif)
						this.queuedNotif = {};
					this.queuedNotif[key] = "true";
				}
				/****/
			}
			
			this.unblockConversation(aConversation);
			
			/******/
			if(this.queuedNotif && this.queuedNotif[key] && element.participants && element.participants.length && element.messages && element.messages[0]) {
				this.queuedNotif[key] = undefined;
				
				//if(element.participants[0].name != CURRENT_USER_LOGIN) {
				//if(element.messages[0].from != CURRENT_USER_LOGIN) {
				if(!element.messages[0].fromMe) {
					//No inicie el chat
					var participants_names = '';
					element.participants.each(function(participant) {
						if(participants_names)
							participants_names += ', ';
						participants_names += participant.name;
					});
				
					Generic.createNotification(CHAT_TIT_NEW_CON, LBL_CHAT_SUBJECT + ': ' + element.title + '\n' + CHAT_PNL_PART + ': ' + participants_names, Generic.showCurrentWindow);
				}
			}
			/*****/
			
			aConversation.keepParticipants(element.participants);
			aConversation.newMessages(element.messages);
			
			if (this.options.hasConversations && aConversation.options.closed && element.messages != null && element.messages.length > 0) aConversation.open();

			toProcess.erase(key);

		}, this);
		
		$each(toRemove, function(key, index) { 
			this.listConversationsUi.get(key).dispose();
			this.listConversationsUi.erase(key);
		}, this);
		
	},
	
	unblockConversation: function(conversation) {
		if (! conversation.isBlocked) return;
		if(conversation.isPermanentBlocked) return;
		
		conversation.isBlocked = false;
		
		conversation.dialog.owner.newMessage(null, '<font class="chat-admin-message">' + CHAT_RECONNECTED + '</font>');
		//conversation.input.set("disabled", "");
		//tinymce.get(conversation.input.get('id')).settings.readonly = false;
		var editor_body = tinymce.get(conversation.input.get('id')).contentDocument.body;
		editor_body.setAttribute('contenteditable', 'true');
		if(editor_body.className.contains('disabled'))
			editor_body.className = editor_body.className.replace('disabled', '');
		
		var chatContent = conversation.dialog.getElement('div.chat-content');
		var chatPrps = chatContent.getElement('div.chat-prps')
		var chatPrpOps = chatContent.getElement('div.chat-prp-opts');
		var fileContainer = chatContent.getElement('div.file-container');
		
		if(chatPrps)		chatPrps.removeClass('hidden');
		if(chatPrpOps)		chatPrpOps.removeClass('hidden');
		if(fileContainer)	fileContainer.removeClass('hidden');
	},
	
	blockConversations: function() {
		var hide = false;
		var spinner = $(document.body).getChildren('div.spinner');
		if(spinner && spinner.length && spinner[0].isVisible())
			hide = true;
		
		this.listConversationsUi.getValues().each(function(conversation) {
			if (! conversation.isBlocked) {
				conversation.isBlocked = true;
				conversation.dialog.owner.newMessage(null, '<font class="chat-admin-message">' + CHAT_ERR_NOT_CONNECTED + '</font>');
				//conversation.input.set("disabled", "true");
				//tinymce.get(conversation.input.get('id')).settings.readonly = true;
				//tinymce.get(conversation.input.get('id')).contentDocument.body.setAttribute('contenteditable', false);
				var editor_body = tinymce.get(conversation.input.get('id')).contentDocument.body;
				editor_body.setAttribute('contenteditable', false);
				if(!editor_body.className.contains('disabled'))
					editor_body.className = editor_body.className += ' disabled';
				
				var chatContent = conversation.dialog.getElement('div.chat-content');
				var chatPrps = chatContent.getElement('div.chat-prps')
				var chatPrpOps = chatContent.getElement('div.chat-prp-opts');
				var fileContainer = chatContent.getElement('div.file-container');
				//if(chatPrps) chatPrps.destroy();
				//if(chatPrpOps) chatPrpOps.destroy();
				//if(fileContainer) fileContainer.destroy();
				if(chatPrps) chatPrps.addClass('hidden');
				if(chatPrpOps) chatPrpOps.addClass('hidden');
				if(fileContainer) fileContainer.addClass('hidden');
				
				if(hide) conversation.dialog.setStyle('z-index', 1);
			}
		},this);
	},
	
	processLoginStatus: function(status) {
		var wasLogged = this.logged;
		
		var newLoggedStatus = (status != null) ? status.getAttribute("connected") == "true" : false;
		if (newLoggedStatus) this.id = status.getAttribute("id");

		if (wasLogged && ! newLoggedStatus) {
			if (this.options.hasLogin)	this.loginUi.open();
			if (this.options.hasMain)	{
				this.closeMain();
				this.mainUi.clearUsers();
				this.mainUi.clearGroups();
				this.mainUi.clearRequests();
				this.mainUi.owner.blockConversations();
				this.mainUi.fireEvent('logoutDone');
				this.mainUi.dialog.fireEvent('logoutDone');
				this.mainUi.dialog.fireEvent('serverAutomaticLogoutDone');
				//this.listConversationsUi.empty();
				this.listUsers.empty();
				this.listGroups.empty();
				this.listRequests.empty();
				
				this.showLogin();
				this.showLogin();
			}
		} else if (! wasLogged && newLoggedStatus) {
			if (this.options.hasLogin)	this.loginUi.close();
			if (this.options.hasMain) {
				if (this.options.openMainOnLogged) this.mainUi.open();
				this.mainUi.dialog.fireEvent('loginDone');
			}
		}
		
		this.logged = newLoggedStatus;
	},
	
	processErrorConnection: function() {
		this.processLoginStatus(null);
		this.fireEvent('errorConnection');
	},
	
	checkStatus: function() {
		if (this.checkingStatus) return;
		
		this.checkingStatus = true;
		this.url.refresh();
		this.checkingStatus = false;
	},
	
	isLogged: function () { return this.logged; }
});

/**
 * Representa a un grupo al cual se le pueden enviar solicitudes de conversaci�n.
 * 
 */
ApiaChatGroup = new Class({
	Implements: Options,
	
	options: {
		id: -1,		//Id of group
		name: '',	//Name of group
		members: 0	//Amount of members in the group
	},
	
	initialize: function(options) {
		this.owner = options.owner;
		options.owner = null;
		
		//Set options
		this.setOptions(options);
		this.options.owner = this.owner;
		
		//Create visual representation
		this.domObj = new Element("div", {'styles': {'cursor': 'pointer'}});
		this.domObj.owner = this;
		this.members = new Element("span", {'html': " (" + options.members + ")", 'class': 'chatGroupNumber'});
		
		new Element("span", {'html': options.name + ""}).inject(this.domObj);
		this.members.inject(this.domObj);
		
		//Add event
		this.domObj.addEvent('dblclick', this.dbClick, this);
	},
	
	dbClick: function(e) {
		var group = this.owner;
		group.owner.startConversationRequest(group.options.id, group.options.name);
	},
	
	update: function(amount) {
		if (this.options.members != amount) {
			this.members.innerHTML = " (" + amount + ")";
			this.options.members = amount;
		}
	},
	
	inject: function(el,where) { $(this.domObj).inject(el,where); },
	dispose: function() { this.domObj.dispose(); }
});

ApiaChatUser = new Class({
	Implements: Options,
	
	options: {
		id: -1,		//Id of user
		name: '',	//Name of user
		container: null
	},
	
	initialize: function(options){
		//Keep owner and avoid as option
		this.owner = options.owner;
		options.owner = null;

		//Set options
		this.setOptions(options);
		
		//Create visual representation
		var display = options.name + (PARAMETER_CHAT_CLIENT_DISPLAY_NAME ? ' - ' + options.display : '')
		this.domObj = new Element("div", {'html': display, 'styles': {'cursor': 'pointer'}});
		this.domObj.owner = this;
		
		//Set event
		this.domObj.addEvent('dblclick', this.dbClick, this);
		
		if (options.container != null) this.inject(options.container);
	},
	
	dbClick: function(e) {
		var user = this.owner;
		user.owner.startConversation(user.options.id, user.options.name);
	},
	
	inject: function(el,where) { $(this.domObj).inject(el,where); },
	dispose: function() { this.domObj.dispose(); }
});

ApiaChatConversationRequest = new Class({
	Implements: Options,
	
	options: {
		id: -1,		//Id of conversation
		title: "",
		groupName: "",	//Name of group
		groupId: -1,
		userName: "",
		url: null
	},
	
	initialize: function(options){
		//Keep owner and avoid as option
		this.owner = options.owner;
		this.url = options.url;
		options.owner = null;
		options.url = null;

		//Set options
		this.setOptions(options);
		
		this.options.url = this.url;
		
		//Create visual representation
		//this.domObj = new Element("div", {'html': options.groupName + " - " + options.userName + " - " + options.title, 'styles': {'cursor': 'pointer'}});
		this.domObj = new Element("div", {'text': options.groupName + " - " + options.userName + " - " + options.title, 'styles': {'cursor': 'pointer'}});
		this.domObj.owner = this;
		
		this.isBlocked = false;
		
		//Set event
		this.domObj.addEvent('dblclick', this.dbClick);
	},
	
	dbClick: function(e) {
		var request = this.owner;
		this.owner.options.url.aceptConversationRequest(request.options.id, request.options.groupId);
		request.owner.removeRequest(request.options.id);
		
		$('tabContainer').tabUser.close();
	},
	
	inject: function(el,where) { $(this.domObj).inject(el,where); },
	dispose: function() { this.domObj.dispose(); }
});

/**
 * Dispara evento usersupdate cuando cambian los usuarios logeados en el chat
 */
ApiaChatMain = new Class({
	Implements: [Options, Events],
	
	options: {
		label: CHAT_TIT_DO_LOGIN,
		width: 250,
		height: 500,
		owner: null,
		url: null,
		onCloseDisonect: true
	},
	
	initialize: function(options) {
		this.options = options;
		this.options.closed = true;
		
		this.usersHash = new Hash();
		this.groupsHash = new Hash();
		this.requestsHash = new Hash();
		
		this.usersPanel = $('chatPanelUsers');
		this.groupsPanel = $('chatPanelGroups');
		this.requestsPanel = $('chatPanelRequests');
		this.dialog = $('tabUser');
	},
	
	//Visual methods
	open: function() { 
		if (this.options.closed) {
			this.options.closed = false;
			this.dialog.open();
		}
	},
	
	close: function() {
		if (! this.options.closed) {
			this.options.closed = true;
			this.dialog.close();
		}
	},
	
	isOpen: function() { return ! this.options.closed; },
	
	//Process requests methods
	clearUsers: function() {
		this.usersHash.each(function(value,key) {
			value.dispose();
		});
		
		this.usersHash.empty();
	},
	
	clearGroups: function() {
		this.groupsHash.each(function(value,key) {
			value.dispose();
		});
		this.groupsHash.empty();
	},
	
	clearRequests: function() {
		this.requestsHash.each(function(value,key) {
			value.dispose();
		});
		this.requestsHash.empty();
	},
	
	addUser: function(user) {
		if (this.hasUser(user.id)) return;
		
		this.usersHash.set(user.id, new ApiaChatUser({
			id: user.id,
			name: user.name,
			display: user.display,
			owner: this,
			container: this.usersPanel.content
		}));
	},
	
	addGroup: function(group) {
		if (this.hasGroup(group.id)) {
			this.groupsHash.get(group.id).update(group.members);
		} else {
			var aGroup = new ApiaChatGroup({
				id: group.id,
				name: group.name,
				members: group.members,
				owner: this
			});
			aGroup.inject(this.groupsPanel.content);
			this.groupsHash.set(group.id,aGroup);
		}
	},
	
	//Interaction methods
	startConversation: function(id, name) {
		/*
		SYS_PANELS.newPanel();
		var panel = SYS_PANELS.getActive();
		panel.header.innerHTML = CHAT_LBL_CONVERSATION;
		
		new Element('div', {html: CHAT_LBL_START_CON + " " + name + " " + CHAT_LBL_REQ_CON_WITH}).inject(panel.content);
		
		var input = new Element("input", {
			"type": "text", 
			"styles": {"width": "95%"},
			id: 'poolNewRequestSubject'
		});
		input.inject(panel.content);
		
		var button = new Element('div', {html: BTN_CONFIRM});
		button.addClass('button');
		button.url = this.options.url;
		button.addEvent('click', function(evt){
			this.url.startConversation(id,input.value);
			SYS_PANELS.closeAll();
		});
		button.inject(panel.footer);
		
		input.button = button;
		input.addEvent('keypress', function(e) { if (e.key == 'enter') this.button.fireEvent('click'); });
		
		SYS_PANELS.addClose(panel);
		SYS_PANELS.refresh();
		
		input.focus();
		*/
		if(!Browser.safari)
			$('tabUser').click();
		
		this.options.url.startConversation(id, CURRENT_USER_LOGIN + " " + name);
	},
	
	startConversationRequest: function(id, name) {
		
		SYS_PANELS.newPanel();
		var panel = SYS_PANELS.getActive();
		panel.header.innerHTML = CHAT_TIT_REQUEST;
		
		new Element('div', {html: CHAT_LBL_REQ_CON + " " + name + " " + CHAT_LBL_REQ_CON_WITH}).inject(panel.content);
		
		var input = new Element("input", {
			"type": "text", 
			"styles": {"width": "95%"},
			id: 'poolNewRequestSubject'
		});
		input.inject(panel.content);
		
		var button = new Element('div', {html: BTN_CONFIRM});
		button.addClass('button');
		button.url = this.options.url;
		button.addEvent('click', function(evt){
			this.url.requestConversation(id,input.value);
			SYS_PANELS.closeAll();
		});
		button.inject(panel.footer);
		
		input.button = button;
		input.addEvent('keypress', function(e) { if (e.key == 'enter') this.button.fireEvent('click'); });
		
		SYS_PANELS.addClose(panel);
		SYS_PANELS.refresh();
		
		//input.focus();
		//input.setSelectionRange(0, 0);
		//input.focus();
		setTimeout(function() {input.focus();}, 100);
		
		$('tabContainer').tabUser.close();
	},
	
	addRequest: function(request) {
		if (this.hasRequest(request.id)) return;
		
		var aRequest = new ApiaChatConversationRequest({
			id: request.id,
			title: request.title,
			groupName: request.groupName,
			groupId: request.groupId,
			userName: request.userName,
			owner: this,
			url: this.options.url
		});
		
		aRequest.inject(this.requestsPanel.content);
		this.requestsHash.set(request.id,aRequest);
		
		$('tabContainer').tabUser.open();
	},
	
	hasUser: function(id) { return this.usersHash.has(id); },
	hasGroup: function(id) { return this.groupsHash.has(id); },
	hasRequest: function(id) { return this.requestsHash.has(id); },
	
	removeRequest : function(id) {
		this.requestsHash.get(id).dispose();
		this.requestsHash.erase(id);
	},
	
	keepUsers: function(users) {
		var toDelete = new Array();
		var owner = this;
		var update = false;
		
		$each(this.usersHash.getKeys(), function(id, index) {
			toDelete.include(id);
		});
		
		$each(users, function(user, index) {
			if (! owner.hasUser(user.id)) {
				owner.addUser(user);
				update = true;
			} else {
				toDelete.erase(user.id);
			}
		});
		
		$each(toDelete, function(id, index) {
			owner.usersHash.get(id).dispose();
			owner.usersHash.erase(id);
		});
		
		if(update || (toDelete && toDelete.length)) {
			fireEvent('usersupdate');
		}
	},
	
	keepGroups: function(groups) {
		var toDelete = new Array();
		var owner = this;
		$each(this.groupsHash.getKeys(), function(id, index) {
			toDelete.include(id);
		});
		
		$each(groups, function(group, index) {
			owner.addGroup(group);
			if (owner.hasGroup(group.id)) {
				toDelete.erase(group.id);
			}
		});
		
		$each(toDelete, function(id, index) {
			owner.groupsHash.get(id).dispose();
			owner.groupsHash.erase(id);
		});
	},
	
	keepRequests: function(requests) {
		var toDelete = new Array();
		var owner = this;
		$each(this.requestsHash.getKeys(), function(id, index) {
			toDelete.include(id);
		});
		
		var addedOne = false;
		
		$each(requests, function(request, index) {
			if (! owner.hasRequest(request.id)) {
				owner.addRequest(request);
				addedOne = true;
			} else {
				toDelete.erase(request.id);
			}
		});
		
		$each(toDelete, function(id, index) {
			if (owner.requestsHash.has(id)) {
				owner.requestsHash.get(id).dispose();
				owner.requestsHash.erase(id);
			}
		});
		
		return addedOne;
	},
	
	setUrl: function(url) {
		this.options.url = url;
	}

});

ApiaChatLogin = new Class({
	Implements: Options,
	options: {
		label: CHAT_TIT_DO_LOGIN,
		width: 250,
		height: 250,
		url: null
	},
	initialize: function(options) {
		//Guardar propiedades
		this.setOptions(options);
		
		loginButton.owner = this;
		loginButton.addTo(dialog.content);
		
		this.dialog = this.options.mainDialog;
		this.dialog.owner = this;
	},
	
	open: function() {
		this.dialog.open();
	},
	
	close: function() {
		this.dialog.close();
	},
	
	getUserValue: function() {
		return this.loginInput.value;
	},
	
	getGroupValue: function() {
		return this.groupInput.value;
	},
	
	setUrl: function(url) {
		this.options.url = url;
	}
});



ApiaChatConversation = new Class({
	options: {
		id: '',
		label: CHAT_TIT_NEW_CON,
		width: 200,
		height: 100,
		owner: null,
		url: null
	},
	
	intervalVar: null,
	
	initialize: function(options) {
		//Guardar propiedades
		this.options = options;
		this.options.closed = false;
		this.options.width = 500;
		this.options.height = 250;
		this.participants = new Hash({});

		//var content = new Element('div', {'class': 'tabChat'})
		var content = new Element('div', {'class': 'chat-content'});

		//var tabContainer = $('tabContainer');
		
		//create el tab
		//this.dialog = tabContainer.createNewChatTab(options.label, content);
		this.dialog = tabContainer.createNewChatWindow(options.label, content);
		this.dialog.owner = this;
		
		this.dialog.addEvent('remove', function() {
			var owner = this.owner;
			if (! owner.options.closed) {
				owner.options.closed = true;
				owner.options.url.quitConversation(owner.options.id);
				owner.options.owner.listConversationsUi.erase(owner.options.id);
			}
		});
		this.dialog.addEvent('onFocusTab', function(){
			var owner = this.owner;
			//owner.input.focus();
			tinymce.get(owner.input.get('id')).focus();
		});
		
		//Cargar los participantes
		this.secParticipants = new Element('div', {'class': 'chatParticipants'});
		this.secParticipants.inject(content);
		new Element('label', {html: CHAT_PNL_PART + ': '}).inject(this.secParticipants);
		
		//Cargar el contenido del tab
		this.secMessages = new Element('div', {'class': 'chatContent'}).set('cid', this.options.id);
		this.secMessages.fxScroll = new Fx.Scroll(this.secMessages);
		this.secMessages.inject(content);
		/*
		this.input = new Element('input', {type: 'text',
			events: {
				'keypress': function(evt) {
					if (evt.code == 13) {
						owner = this.owner;
						owner.sendMessage(this.value);
						this.value = "";
					} else if (evt.code == 27) {
						owner = this.owner;
						owner.dialog.fireEvent('click');
						this.value = "";
					}
				}
			}});
		this.input.owner = this;
		this.input.inject(this.secMessages, 'after');
		*/
		
		//Editor en lugar de input
		this.input = new Element('textarea', {id: 'chat_area_' + ApiaChatConversation.next_id}).addEvent('enterPressed', function(editor) {
			var message = this.get('value');
			if(Browser.safari || Browser.chrome) {
				//Hay que quitar los p que se incluyen como incializacion para safari, porque pierde el foco
				message = message.replace(/<p>/g, '');
				message = message.replace(/<\/p>/g, '');
			}
			message = message.replace(/&/g, '&amp;');
			message = encodeURIComponent(message);
			
			this.owner.sendMessage(message);
			
			this.value = "";
			editor.setContent('');
			editor.resize();
			
		});
		this.input.owner = this;
		this.input.inject(this.secMessages, 'after');
		
		tinyMCE.execCommand("mceAddEditor", false, 'chat_area_' + ApiaChatConversation.next_id);
		ApiaChatConversation.next_id++;
		
		
		
		var owner = this;
		/*
		var secMessages = this.secMessages;
		this.secMessages.addEvent('click', function(event) {
			if(event.target == secMessages)
				owner.input.focus();
		});
		*/
		var chatPrps = new Element('div.chat-prps').addEvent('click', function() {
			//Limpiar los frames que hayan quedado
			var fDiv = this.getNext('div.file-container');
			while(fDiv != null) {
				if(fDiv.get('keep') != "true")
					fDiv.dispose();
				fDiv = fDiv.getNext('div.file-container');
			}
			
			if(this.hasClass('pressed')) {
				this.getNext('div.chat-prp-opts').dispose();
			} else {
				var opts = new Element('div.chat-prp-opts');
				
				//Buzz
				new Element('div.chat-prp-opt').set('html', LBL_CHAT_BUZZ_1).inject(opts).addEvent('click', function() {
					//Enviar comando buzz
					owner.options.url.sendCommand(owner.options.id, BUZZ_COMMAND);
					
					//Simular que se cierran las opciones
					this.getParent().getPrevious('div.chat-prps').toggleClass('pressed');
					opts.destroy();
				});
				
				var _id = 'id' + new Date().getTime();
				
				new Element('div.chat-prp-opt').set('html', CHAT_BTN_SEND_FILE).inject(opts).addEvent('click', function() {
					//this.getNext().getElement('input').click();
					var form = $(_id);
					form.getElement('input').click();
					//form.getParent().getPrevious('div.chat-prps').click();
					//Simular que se cierran las opciones
					form.getParent().getPrevious('div.chat-prps').toggleClass('pressed');
					opts.destroy();
				});
				new Element('div.file-container').setStyles({
					'height': '0px',
					'visibility': 'hidden'
				}).set('html', "<form id='" + _id + "' target='frm" + _id + "' enctype='multipart/form-data' method='post'><input style='height: 0px;' type='file' name='theFile'/></form><iframe style='display: none' id='frm" + _id + "' name='frm" + _id + "'></iframe>").inject(this.getParent()).getElement('input').addEvent('change', function() {
					this.getParent('div.file-container').set('keep', 'true');
					var form = this.getParent('form');
					var filename = this.get('value');
					if(filename.match(/fakepath/)) {
						filename = filename.replace(/C:\\fakepath\\/i, '');
                    }
					owner.options.url.newTransfer(owner.options.id, form.id, filename);
				});
				
				new Element('hr').inject(opts);
				
				//Invitar usuario
				new Element('div.chat-prp-opt').set('html', CHAT_BTN_INVITE_USR).inject(opts).addEvent('click', function() {
					//Simular que se cierran las opciones
					this.getParent().getPrevious('div.chat-prps').toggleClass('pressed');
					opts.destroy();
					
					var h = 370;
					var mdlUsrContainer = new Element('div.mdlContainer').setStyles({
						width: 385,
						height: h
					}).set('html', '<div class="mdlHeader">' + CHAT_BTN_INVITE_USR + '</div>');
					
					
					var usrContainer = new Element('div.mdlBody').setStyles({
						'height': h - 57,
						'overflow': 'auto'
					});
					
					var usrKeys = uiChat.mainUi.usersHash.getKeys(); //ya es una copia del original, no van a haber problemas de concurrencia
					if(usrKeys && usrKeys.length) {
						usrKeys.each(function(key) {
							if(!owner.participants[key]) {
								var usr = uiChat.mainUi.usersHash.get(key);
								if(usr)
									new Element('div.chat-user').set('html', '<label class="checkbox-label"><input type="checkbox"/>' + usr.options.name + '</label>').set('usrid', usr.options.id).inject(usrContainer);
							}
						});
					}
					
					var grpKeys = uiChat.mainUi.groupsHash.getKeys(); //ya es una copia del original, no van a haber problemas de concurrencia
					if(grpKeys && grpKeys.length) {
						grpKeys.each(function(key) {
							if(!owner.participants[key]) {
								var grp = uiChat.mainUi.groupsHash.get(key);
								if(grp)
									new Element('div.chat-user').set('html', '<label class="checkbox-label"><input type="checkbox"/>' + grp.options.name + '</label>').set('usrid', grp.options.id).inject(usrContainer);
							}
						});
					}
					
					usrContainer.inject(mdlUsrContainer);
					new Element('div.mdlFooter').set('html', '<div class="close">' + BTN_CLOSE + '</div><div class="modalButton">' + BTN_CONFIRM + '</div>').inject(mdlUsrContainer).getElement('div.close').addEvent('click', function() {
						mdlUsrContainer.destroy(); 
						blocker.destroy();
					}).getNext('div').addEvent('click', function() {
						//Obtener todos los elementos seleccionados
						var eles = usrContainer.getElements('input');
						if(eles && eles.length) {
							var usrKeys = uiChat.mainUi.usersHash.getKeys();
							var grpKeys = uiChat.mainUi.groupsHash.getKeys();
							eles.each(function(ele) {
								if(ele.get('checked')) {
									//Invocar los joins
									var usrid = ele.getParent('div.chat-user').get('usrid');
									if(usrKeys.contains(usrid))
										owner.options.url.joinToConversation(owner.options.id, usrid);
									else if(grpKeys.contains(usrid))
										owner.options.url.joinGroupToConversation(owner.options.id, usrid, owner.options.label);
								}
							});
						}
						mdlUsrContainer.destroy();
						blocker.destroy();
					});
					var z_index = $('tab-2').getStyle('z-index');
					var blocker = new Element('div.chat-mask').setStyle('z-index', z_index).inject(document.body);
					mdlUsrContainer.setStyle('z-index', z_index).inject(document.body);
					mdlUsrContainer.position();
				});
				
				//Transferir
				new Element('div.chat-prp-opt').set('html', CHAT_BTN_TRANSFER).inject(opts).addEvent('click', function() {
					//Simular que se cierran las opciones
					this.getParent().getPrevious('div.chat-prps').toggleClass('pressed');
					opts.destroy();
					
					var h = 370;
					var mdlUsrContainer = new Element('div.mdlContainer').setStyles({
						width: 370,
						height: h
					}).set('html', '<div class="mdlHeader">' + CHAT_TITLE_TRANSFER + '</div>');
					
					var usrContainer = new Element('div.mdlBody').setStyles({
						'height': h - 57,
						'overflow': 'auto'
					}).addEvent('click', function(event) {
						if(event.target.hasClass("chat-user")) {
							event.target.getParent().getChildren("div.chat-user").erase('checked').removeClass('selected');
							event.target.set('checked', 'true');
							event.target.addClass('selected');
						}
					});
					
					var usrKeys = uiChat.mainUi.usersHash.getKeys(); //ya es una copia del original, no van a haber problemas de concurrencia
					if(usrKeys && usrKeys.length){
						usrKeys.each(function(key) {
							if(!owner.participants[key]) {
								var usr = uiChat.mainUi.usersHash.get(key);
								if(usr)
									new Element('div.chat-user').set('html', usr.options.name).set('usrid', usr.options.id).inject(usrContainer);
							}
						});
					}
					
					var grpKeys = uiChat.mainUi.groupsHash.getKeys(); //ya es una copia del original, no van a haber problemas de concurrencia
					if(grpKeys && grpKeys.length) {
						grpKeys.each(function(key) {
							if(!owner.participants[key]) {
								var grp = uiChat.mainUi.groupsHash.get(key);
								if(grp)
									new Element('div.chat-user').set('html', grp.options.name).set('usrid', grp.options.id).inject(usrContainer);
							}
						});
					}
					
					usrContainer.inject(mdlUsrContainer);
					new Element('div.mdlFooter').set('html', '<div class="close">' + BTN_CLOSE + '</div><div class="modalButton">' + BTN_CONFIRM + '</div>').inject(mdlUsrContainer).getElement('div.close').addEvent('click', function() {
						mdlUsrContainer.destroy(); 
						blocker.destroy();
					}).getNext('div').addEvent('click', function() {
						//Obtener todos los elementos seleccionados
						var eles = usrContainer.getElements('div.chat-user');
						if(eles && eles.length) {
							var usrKeys = uiChat.mainUi.usersHash.getKeys();
							var grpKeys = uiChat.mainUi.groupsHash.getKeys();
							for(var i = 0; i < eles.length; i++) {
								if(eles[i].get('checked')) {
									var usrid = eles[i].get('usrid');
									if(usrKeys.contains(usrid))
										owner.options.url.transferConversation(owner.options.id, usrid);
									else if(grpKeys.contains(usrid))
										owner.options.url.transferGroupConversation(owner.options.id, usrid, owner.options.label);
									
									owner.dialog.getElement('span.remover').click();
									break;
								}
							}
						}
						mdlUsrContainer.destroy();
						blocker.destroy();
					});
					var z_index = $('tab-2').getStyle('z-index');
					var blocker = new Element('div.chat-mask').setStyle('z-index', z_index).inject(document.body);
					mdlUsrContainer.setStyle('z-index', z_index).inject(document.body);
					mdlUsrContainer.position();
				});
				
				new Element('hr').inject(opts);
				
				//Historial
				new Element('div.chat-prp-opt').set('html', CHAT_TITLE_HISTORY).inject(opts).addEvent('click', function() {
					//Simular que se cierran las opciones
					this.getParent().getPrevious('div.chat-prps').toggleClass('pressed');
					opts.destroy();
					
					var participants = owner.participants.getValues();
					var participantsFilter = "";
					for(var i = 0; i < participants.length; i++) {
						if(participantsFilter.length)
							participantsFilter += encodeURIComponent(" ");
						participantsFilter += encodeURIComponent("+") + participants[i].get('text');
					}
					
					if(tabContainer && tabContainer.addNewTab)
						tabContainer.addNewTab(CHAT_TITLE_HISTORY, "apia.monitor.ChatAction.run?action=init&txtParticipant=" + participantsFilter);
				});
				
				//Copiar contenido
				new Element('div.chat-prp-opt').set('html', CHAT_TITLE_COPY_CONTENT).inject(opts).addEvent('click', function() {
					//Simular que se cierran las opciones
					this.getParent().getPrevious('div.chat-prps').toggleClass('pressed');
					opts.destroy();
					
					if(tabContainer)
						tabContainer.chatContent = owner.secMessages.get('html');
				});
				
				opts.inject(this.getParent());
			}
			
			this.toggleClass('pressed');
		}).inject(content)
		
		//mostrar el tab
		this.dialog.open();
		
		//this.input.focus();
		//tinymce.get(this.input.get('id')).focus(); //No se creo el editor todavia
		
		this.dialog.addEvent('click', function() {
			clearInterval(this.intervalVar);
			this.intervalVar = null;
			this.dialog.getElement('div.chat-title').removeClass('chat-highlight').addClass('chat-title-bg');
		}.bind(this));
		
		//Crear ventana
//		var dialog = new Jx.Dialog({
//	        label: options.label,
//	        image: 'images/page_white_text.png',
//	        modal: false, 
//	        resize: true,
//	        move: true,
//	        maximize: false,
//	        width: this.options.width,
//	        height: this.options.height,
//	        onClose: function() {
//				var owner = this.owner;
//				if (! owner.options.closed) {
//					owner.options.closed = true;
//					owner.options.url.quitConversation(owner.options.id);
//				}
//			},
//			onExpand: function() {
//				if (this.owner != null) {
//					this.setLabel(this.owner.options.label);
//				}
//			}
//	    });
//		
//		this.dialog = dialog;
//		this.dialog.owner = this;
//		
//		//Crear secciones de la ventana
//		
//		var panelParticipants = new Jx.Panel({
//			label: CHAT_PNL_PART,
//			collapse: false
//		});
//		this.secParticipants = panelParticipants.content;
//
//		var panelMessages = new Jx.Panel({
//			label: CHAT_PNL_MSGS,
//			collapse: false
//		});
//		this.secMessages = panelMessages.content;
//		this.secMessages.scroll = new Fx.Scroll(this.secMessages);
//		
//		var dinamic = new Element("div", {});
//        dinamic.inject(dialog.content);
//
//        var splitV = new Jx.Splitter(dialog.content, {
//        	layout: 'vertical',
//        	containerOptions: [null, {height: 25, minHeight: 25, maxHeight: 25}]
//       	});
//
//       	var splitH = new Jx.Splitter(splitV.elements[0], {
//       		elements: [panelParticipants, panelMessages],
//       		containerOptions: [{width: 25}, null]
//       	});
//
//       	//Crear la parte inferior
//		var divLow = new Element("div", {});
//		divLow.inject(dialog.content);
//       	
//		//Crear envio de mensaje al hacer ENTER
//		var input = new Element("input", {});
//		//input.inject(dialog.content);
//		input.inject(divLow);
//		input.owner = this;
//		input.addEvent('keypress', function(evt) {
//			if (evt.key == 'enter') {
//				owner = this.owner;
//				owner.sendMessage(this.value);
//				this.value = "";
//			}
//		});
//		
//		var btnSendFile = new Element("input", {type: 'button', value: 'Archivo'});
//		btnSendFile.inject(divLow);
//		btnSendFile.owner = this;
//		btnSendFile.addEvent('click', this.openSendFile);
//		btnSendFile.dialog = this.dialog;
//		new Jx.Layout(divLow, { top: null,  height: 25 });
//		new Jx.Layout(input, { top: null,  height: 25, right: 50});
//		new Jx.Layout(btnSendFile, { top: null,  left: null, width: 50});
	},
	/*
	openSendFile: function(evt) {
		var formId = "id" + (new Date()).getTime();
		var div = document.createElement("DIV");
		
		div.innerHTML = "<form id='" + formId + "' method='post' target='frm" + formId + "' enctype='multipart/form-data'></form><iframe id='frm" + formId + "' name='frm" + formId + "' style='visibility:hidden; width:1px; height:1px;'></iframe>";
		
		var form = div.firstChild;
		form.id = formId;
		
		new Element("div", {'html': CHAT_TIT_SEL_FILE}).inject(form);
		var input = new Element("input", {
			"type": "file",
			"name": "theFile",
			"styles": {"width": "95%"}
		});
		input.inject(form);
		
		new Element("div",{}).inject(form);
		var button = new Element("input", {
			"type": "button", 
			"value": CHAT_BTN_SEND_FILE
		});
		
		button.owner = this.owner;
		button.url = this.owner.options.url;
		button.addEvent('click', function(e) {
				var owner = this.owner;
				owner.options.url.newTransfer(owner.options.id,form.id,input.value);
				this.parent.close();
			}
		);
		button.inject(form);

		form.button = button;
		input.owner = form;
		
		var dialog = new Jx.Dialog({
	        label: CHAT_TIT_REQUEST,
	        image: 'images/page_white_text.png',
	        modal: true, 
			collapse: false,
	        resize: false,
	        move: false,
	        content: div,
	        width: this.owner.options.width * .80,
	        height: 130,
	        parent: this.dialog.content
		});
		
		button.parent = dialog;
		dialog.open();
		input.focus();
	},
	*/
	sendMessage: function(msg) {
		if (msg == null || msg == "") return;
		
		//TODO: Quitar esto. La forma de mandar comandos no es as�, esto es para testeo
		if(msg[0] == '/')
			this.options.url.sendCommand(this.options.id, msg[1], msg.substring(2));
		else
			this.options.url.sendMessage(this.options.id, msg);
	},
	
	open: function() {
		this.dialog.open();
	},
	
	newMessage: function(from, msg, id, byMe, forceHighlight) {
		if(!msg) return; //Obviar mensajes vacios
		if (byMe == null) byMe = false;
		var bySystem = from == null;
		
		var indent = true;
		if (from != null && this.prev_from != from) {
			msg = "<b>" + from + "</b>" + msg;
			indent = false;
		}
		
		this.prev_from = from;
		
		var p = new Element("p", {'title': formatDate(new Date(), DATE_FORMAT + " " + TIME_FORMAT), 'html': msg, 'id': id, 'class': 'chatMessage'}).inject(this.secMessages);
		p.addClass(byMe ? 'chatMessageByOwner' : 'chatMessageByNotOwner');
		if (bySystem) p.addClass('chatMessageBySystem');
		
		if(indent) p.addClass(byMe ? 'chatMessageByOwnerIdent' : 'chatMessageIdent');
		
		this.secMessages.fxScroll.toBottom();
		
		//TODO: Si no tengo el foco y no estoy titlando
		if(forceHighlight || (this.intervalVar == null && (!document.hasFocus || document.hasFocus && !document.hasFocus()))) {
			var title = this.dialog.getElement('div.chat-title');
			var repetitions = 11;
			this.intervalVar = setInterval(function() {
				title.toggleClass('chat-highlight').toggleClass('chat-title-bg');
				repetitions--;
				if(!repetitions) {
					clearInterval(this.intervalVar);
					this.intervalVar = null;
				}
			}.bind(this), 1000);
		}
		
	},
	
	newMessages: function(messages) {
		if (messages != null && messages.length > 0) {
			$each(messages,function(message, index) {
				
				if (MSG_TYPE_NEW_USER == message.type)	return; //No mostrar que hay nuevos usuarios
				//if (MSG_TYPE_EXIT_USER == message.type)	return; //No mostrar que se fue un usuario
				
				if(MSG_TYPE_WARN_INACTIVITY == message.type) {
					this.newMessage(null, "<span id='spanMsg" + message.extraId + "' class='chat-admin-message'>" + CHAT_TIME_INACT_MSG + "</span>", null, null, true);
					return;
				}
				
				message.fromMe = message.fromMe == "true";
				
				if (MSG_TYPE_NEW_FILE_TRANFER == message.type) {
					if (message.fromMe) {
						var form = document.getElementById(message.extraId);
						
						this.newMessage(null, "<span id='spanMsg" + message.extraId + "' class='chat-admin-message'>" + CHAT_LBL_WAIT_ACEPT + message.message + ". <a href='#' id='aMsgRej" + message.extraId + "'>" + BTN_CANCEL + "</a></span>", "msg" + message.extraId);
						
						var aReject = $('aMsgRej' + message.extraId);
						aReject.url = this.options.owner.url;
						aReject.extraId = message.extraId;
						aReject.fileName = message.message;
						aReject.conversationId = this.options.id;
						aReject.addEvent('click', function(evt) {
							this.url.rejectFile(this.conversationId, this.extraId, this.fileName);
							return false;
						});

					} else {
						var params = "";
						params += "action=aceptTransfer";
						params += TAB_ID_REQUEST;
						params += "&";
						params += "fileName=" + message.message;
						params += "&";
						params += "transferId=" + message.extraId;
						params += "&";
						params += "conversationId=" + this.options.id;
						
						
						var url = this.options.owner.options.urlDownload + "?" + params;
						
						this.newMessage(null, "<span id='spanMsg" + message.extraId + "' class='chat-admin-message'>" + message.from + " " + CHAT_LBL_IS_SENDING + message.message + ". <a href='" + url + "' target='_new'>" + BTN_CONFIRM + "</a> | <a href='#' id='aMsgRej" + message.extraId + "'>" + BTN_CANCEL + "</a></span>", "msg" + message.extraId);
						
						var aReject = $('aMsgRej' + message.extraId);
						aReject.url = this.options.owner.url;
						aReject.extraId = message.extraId;
						aReject.fileName = message.message;
						aReject.conversationId = this.options.id;
						aReject.addEvent('click', function(evt) {
							this.url.rejectFile(this.conversationId, this.extraId, this.fileName);
							return false;
						});
					}
					
					return;
				}
				
				if (MSG_TYPE_ACCEPT_FILE_TRANFER == message.type) {
					var span = $("spanMsg" + message.extraId);
					span.innerHTML = (message.fromMe ? CHAT_LBL_YOU : message.from) + " " + CHAT_LBL_ACEPT_TRANS + " " + message.message + ".";
					
					if (! message.fromMe) {
						var params = "";
						params += "action=startTransfer";
						params += TAB_ID_REQUEST;
						params += "&";
						params += "transferId=" + message.extraId;
						params += "&";
						params += "conversationId=" + this.options.id;
						
						var url = this.options.owner.options.url + "?" + params;

						var form = $(message.extraId);
						form.action = url;
						form.submit();
					}
					
					return;
				}
				
				if (MSG_TYPE_CANCEL_FILE_TRANFER == message.type) {
					var span = document.getElementById("spanMsg" + message.extraId);
					span.innerHTML = (message.fromMe ? CHAT_LBL_YOU : message.from) + " " + CHAT_LBL_CANEL_TRANS + " " + message.message + ".";

					var form = $(message.extraId);
					if (form != null) form.parentNode.removeChild(form);
					
					var iframe = $("frm" + message.extraId);
					if (iframe != null) iframe.parentNode.removeChild(iframe);

					return;
				}
				
				if (MSG_TYPE_COMPLET_FILE_TRANFER == message.type) {
					var span = document.getElementById("spanMsg" + message.extraId);
					span.innerHTML = CHAT_LBL_ENDED_TRANS + " " + message.message + ".";
					
					var form = $(message.extraId);
					if (form != null) form.parentNode.removeChild(form);
					
					var iframe = $("frm" + message.extraId);
					if (iframe != null) iframe.parentNode.removeChild(iframe);
					
					return;
				}
				
				if (MSG_TYPE_SENDING_FILE_TRANFER == message.type) {
					var span = $("spanMsg" + message.extraId);
					span.innerHTML = (message.fromMe ? CHAT_LBL_YOU : (message.from + " is")) + " " + CHAT_LBL_DOWN_TRANS + message.message + ".";
					return;
				}
				
				if (MSG_TYPE_ERROR_FILE_TRANFER == message.type) {
					var span = document.getElementById("spanMsg" + message.extraId);
					span.innerHTML = CHAT_ERR_TRANS_1 + message.message + CHAT_ERR_TRANS_2;
					
					var form = $(message.extraId);
					if (form != null) form.parentNode.removeChild(form);
					
					var iframe = $("frm" + message.extraId);
					if (iframe != null) iframe.parentNode.removeChild(iframe);

					return;
				}
				
				/*
				if(MSG_TYPE_NEW_CONVERSATION_STARTED == message.type) {
					this.newMessage(null, "<span class='chat-admin-message' style='float:right;'>Conversaci�n iniciada a las ...</span>");
				}
				*/
				
				if (MSG_TYPE_COMMAND == message.type) {
					var msg = "";
					var sync_id = message.message.split('-')[0];
					var real_msg = message.message.substring(sync_id.length + 1);
					//Segun el extraId distinguir el tipo de comando, y por ende, el mensaje a mostrar
					if(message.extraId == TRANSFER_TASK_COMMAND) {
						if(message.fromMe) {
							this.newMessage(null, "<span id='spanMsg" + sync_id + "' class='chat-admin-message'>" + LBL_CHAT_TRANS_TASK_1 + "</span>", "msg" + message.extraId);							
						} else {
							env_id = real_msg.split(' ')[0];
							if(CURRENT_ENVIRONMENT == env_id)
								this.newMessage(null, "<span id='spanMsg" + sync_id + "' class='chat-admin-message' cmdId='" + message.extraId + "' cmd='" + real_msg +"'>" + Generic.parseMessage(LBL_CHAT_TRANS_TASK_2, [message.from]) + " <span><a href='#' id='confirmCmd" + sync_id + "'>" + BTN_CONFIRM + "</a> | <a href='#' id='cancelCmd" + sync_id + "'>" + BTN_CANCEL + "</a></span></span>", "msg" + message.extraId);
							else
								this.newMessage(null, "<span class='chat-admin-message'>" + Generic.parseMessage(LBL_CHAT_TRANS_TASK_3, [message.from]) + "</span>", "msg" + message.extraId);
						}
					} else if(message.extraId == LOG_COMMAND) {
						if(message.fromMe)
							this.newMessage(null, "<span id='spanMsg" + sync_id + "' class='chat-admin-message'>Esperando que se acepte el comando log.</span>", "msg" + message.extraId);
						else
							this.newMessage(null, "<span class='chat-admin-message' cmdId='" + message.extraId + "' cmd='" + real_msg +"'>El usuario " + message.from + " desea ejecutar el comando log. <span><a href='#' id='confirmCmd" + sync_id + "'>" + BTN_CONFIRM + "</a> | <a href='#' id='cancelCmd" + sync_id + "'>" + BTN_CANCEL + "</a></span></span>", "msg" + message.extraId);
					} else if(message.extraId == START_PROCESS_COMMAND) {
						if(message.fromMe) {
							this.newMessage(null, "<span id='spanMsg" + sync_id + "' class='chat-admin-message'>" + "Esperando que se acepte el comando startProcess" + "</span>", "msg" + message.extraId);							
						} else {
							//console.log(real_msg); //Mantener una referencia de estos datos para disparar el openTab con los datos del proceso
							env_id = real_msg.split(' ')[0];
							//real_msg = encodeURIComponent(real_msg);
							//escapear atributos del proceso
//							var real_msg_split = real_msg.split(' ');
//							real_msg = "";
//							for(var i_r = 0; i_r < real_msg_split.length; i_r++) {
//								if(i_r < 6)
//									real_msg += real_msg_split[i_r] + " ";
//								else
//									real_msg += encodeURIComponent(real_msg_split[i_r]);
//							}
							if(CURRENT_ENVIRONMENT == env_id)
								this.newMessage(null, "<span id='spanMsg" + sync_id + "' class='chat-admin-message' cmdId='" + message.extraId + "' cmd='" + real_msg +"'>" + "Desea aceptar proceso de " + message.from + "? <span><a href='#' id='confirmCmd" + sync_id + "'>" + BTN_CONFIRM + "</a> | <a href='#' id='cancelCmd" + sync_id + "'>" + BTN_CANCEL + "</a></span></span>", "msg" + message.extraId);
							else
								this.newMessage(null, "<span class='chat-admin-message'>" + "Error de startProcess " + message.from + ". Se quiere enviar un proceso de otro ambiente.</span>", "msg" + message.extraId);
						}
					} else if(message.extraId == SHOW_QUERY_COMMAND) {
						if(message.fromMe) {
							this.newMessage(null, "<span id='spanMsg" + sync_id + "' class='chat-admin-message'>" + "Esperando que se acepte el comando showQuery" + "</span>", "msg" + message.extraId);							
						} else {
							//console.log(real_msg); //Mantener una referencia de estos datos para disparar el openTab con los datos del proceso
							env_id = real_msg.split(' ')[0];
							//real_msg = encodeURIComponent(real_msg);
							//escapear atributos del proceso
//							var real_msg_split = real_msg.split(' ');
//							real_msg = "";
//							for(var i_r = 0; i_r < real_msg_split.length; i_r++) {
//								if(i_r < 6)
//									real_msg += real_msg_split[i_r] + " ";
//								else
//									real_msg += encodeURIComponent(real_msg_split[i_r]);
//							}
							if(CURRENT_ENVIRONMENT == env_id)
								this.newMessage(null, "<span id='spanMsg" + sync_id + "' class='chat-admin-message' cmdId='" + message.extraId + "' cmd='" + real_msg +"'>" + "Desea aceptar consulta de " + message.from + "? <span><a href='#' id='confirmCmd" + sync_id + "'>" + BTN_CONFIRM + "</a> | <a href='#' id='cancelCmd" + sync_id + "'>" + BTN_CANCEL + "</a></span></span>", "msg" + message.extraId);
							else
								this.newMessage(null, "<span class='chat-admin-message'>" + "Error de showQuery " + message.from + ". Se quiere enviar una consulta de otro ambiente.</span>", "msg" + message.extraId);
						}
					} else if(message.extraId == BUZZ_COMMAND) {
						
						if(message.fromMe) {
							this.newMessage(null, "<span id='spanMsg" + sync_id + "' class='chat-admin-message'>" + LBL_CHAT_BUZZ_3 + "</span>", "msg" + message.extraId);
						} else {
							Generic.createNotification(LBL_CHAT_BUZZ_1, Generic.parseMessage(LBL_CHAT_BUZZ_2, [message.from]), Generic.showCurrentWindow);
							this.newMessage(null, "<span id='spanMsg" + sync_id + "' class='chat-admin-message'>" + Generic.parseMessage(LBL_CHAT_BUZZ_2, [message.from]) + "</span>", "msg" + message.extraId);
						}
						
					}
					
					if(!message.fromMe) {
						var conf = $('confirmCmd' + sync_id);
						var canc = $('cancelCmd' + sync_id);
						if(conf)
							conf.addEvent('click', function(evt) {
								var spanParent = evt.target.getParent().getParent();
								this.options.url.acceptCommand(this.options.id, spanParent.get('cmdId'), spanParent.get('cmd'), sync_id);
								spanParent.getElement('span').destroy();
								//new Element('span', {html: 'Aceptado'}).inject(spanParent);
								new Element('div.chat-loader').inject(spanParent);
							}.bind(this));
						if(canc)
							canc.addEvent('click', function(evt) {
								var spanParent = evt.target.getParent().getParent();
								//this.options.url.cancelCommand(this.options.id, spanParent.get('cmd'), spanParent.get('cmdId'), sync_id);
								this.options.url.cancelCommand(this.options.id, spanParent.get('cmdId'), sync_id);
								spanParent.getElement('span').destroy();
								//new Element('span', {html: 'Rechazado'}).inject(spanParent);
								new Element('div.chat-loader').inject(spanParent);
							}.bind(this));
					}
					
					return;
				}
				
				if (MSG_TYPE_ACCEPT_COMMAND == message.type) {
					if(!message.fromMe) {
						if(message.extraId == TRANSFER_TASK_COMMAND) {
							$('spanMsg' + message.message).set('html', Generic.parseMessage(CHAT_USR_ACCEPTED_TASK, [message.from]));
							//Refrescar la lista de tareas
							//this.options.owner.fireEvent('taskTransfer')
							for(var i = 0; i < frames.length; i++) {
								if(frames[i].fireTaskTransfer) frames[i].fireTaskTransfer();
							}
						} else if(message.extraId == LOG_COMMAND) {
							$('spanMsg' + message.message).set('html', message.from + ' acept� el comando log.');
						} else if(message.extraId == START_PROCESS_COMMAND) {
							$('spanMsg' + message.message).set('html', message.from + ' acept� el comando startProcess.');
						} else if(message.extraId == SHOW_QUERY_COMMAND) {
							$('spanMsg' + message.message).set('html', message.from + ' acept� el comando showQuery.');
						}
					} else {
						if(message.extraId == TRANSFER_TASK_COMMAND) {
							var span_msg = $('spanMsg' + message.message);
							span_msg.getElement('div').destroy();
							new Element('span', {html: CHAT_USR_ACCEPTED_CMD}).inject(span_msg);
							for(var i = 0; i < frames.length; i++) {
								if(frames[i].fireTaskTransfer) frames[i].fireTaskTransfer();
							}
						} else if(message.extraId == START_PROCESS_COMMAND) {
							var span_msg = $('spanMsg' + message.message);
							span_msg.getElement('div').destroy();
							new Element('span', {html: CHAT_USR_ACCEPTED_CMD}).inject(span_msg);
							
//							console.log(message);
//							console.log("jojo: " + span_msg.get('cmd'));
							var cmd = span_msg.get('cmd');
							var cmd_split = cmd.split(' ');
							var atts = cmd_split[6];
//							for(var i = 7; i < cmd_split.length; i++)
//								atts += " " + cmd_split[i];
							for(var i = 7; i < cmd_split.length; i++)
								atts += "&" + cmd_split[i];
							$('tabContainer').addNewTab("", 'apia.execution.TaskAction.run?action=startCreationProcess&busEntId=' + cmd_split[3] + '&proId=' + cmd_split[2] + "&" + atts + TAB_ID_REQUEST);
						} else if(message.extraId == SHOW_QUERY_COMMAND) {
							var span_msg = $('spanMsg' + message.message);
							span_msg.getElement('div').destroy();
							new Element('span', {html: CHAT_USR_ACCEPTED_CMD}).inject(span_msg);
							
//							console.log(message);
//							console.log("jojo: " + span_msg.get('cmd'));
							var cmd = span_msg.get('cmd');
							var cmd_split = cmd.split(' ');
							var atts = cmd_split[5];
//							for(var i = 7; i < cmd_split.length; i++)
//								atts += " " + cmd_split[i];
							for(var i = 6; i < cmd_split.length; i++)
								atts += "&" + cmd_split[i];
							$('tabContainer').addNewTab(cmd_split[1].replace(/%20/g, " "), 'apia.query.UserAction.run?action=init&fromQryChat=true&query=' + cmd_split[2] + "&" + atts + TAB_ID_REQUEST);
						}
					}
					return;
				}
				
				if (MSG_TYPE_CANCEL_COMMAND == message.type) {
					if(!message.fromMe) {
						if(message.extraId == TRANSFER_TASK_COMMAND)
							$('spanMsg' + message.message).set('html', Generic.parseMessage(CHAT_USR_CANCELED_TASK, [message.from]));
						else if(message.extraId == LOG_COMMAND)
							$('spanMsg' + message.message).set('html', message.from + ' cancel� el comando log.');
						else if(message.extraId == START_PROCESS_COMMAND)
							$('spanMsg' + message.message).set('html', message.from + " cancel� el comando startProcess.");
						else if(message.extraId == SHOW_QUERY_COMMAND)
							$('spanMsg' + message.message).set('html', message.from + " cancel� el comando showQuery.");
					} else {
						if(message.extraId == TRANSFER_TASK_COMMAND) {
							var span_msg = $('spanMsg' + message.message);
							span_msg.getElement('div').destroy();
							new Element('span', {html: CHAT_USR_CANCELED_CMD}).inject(span_msg);
						} else if(message.extraId == START_PROCESS_COMMAND) {
							var span_msg = $('spanMsg' + message.message);
							span_msg.getElement('div').destroy();
							new Element('span', {html: CHAT_USR_CANCELED_CMD}).inject(span_msg);
						} else if(message.extraId == SHOW_QUERY_COMMAND) {
							var span_msg = $('spanMsg' + message.message);
							span_msg.getElement('div').destroy();
							new Element('span', {html: CHAT_USR_CANCELED_CMD}).inject(span_msg);
						} 
					}
					return;
				}
				
				this.newMessage(message.from, message.message, null, message.fromMe);
			}, this);
			
//			if (this.dialog.options.closed) {
//				this.dialog.setLabel("<blink style='color:red'>***</blink> " + this.options.label + " <blink style='color:red'>***</span>");
//			}
		}
	},
	
	newParticipant: function(id, user) {
		if (! this.hasParticipant(id)) {
			if (this.secParticipants) {
				var div = new Element("span", {'html': user, 'class': 'participant'});
				div.inject(this.secParticipants);
				this.participants.set(id,div);
			}
		}
	},
	
	hasParticipant: function(id) {
		return this.participants.has(id);
	},
	
	keepParticipants: function(users) {
		var toDelete = new Array();
		var owner = this;
		$each(this.participants.getKeys(), function(id, index) {
			toDelete.include(id);
		});
		
		var do_resize = false;
		$each(users, function(user, index) {
			if (! owner.hasParticipant(user.id)) {
				owner.newParticipant(user.id, user.name);
				do_resize = true;
			} else {
				toDelete.erase(user.id);
			}
		});
		
		var test_member_count = false;
		
		$each(toDelete, function(id, index) {
			var span = owner.participants.get(id);
			var usr_name = span.get('html');
			span.dispose();
			owner.participants.erase(id);
			//Mostrar mensaje de que se fue un participante de la conversacion
			owner.newMessage(null, "<font class='chat-admin-message'>" + usr_name + " " + CHAT_USR_LEFT + "</font>");
			test_member_count = true;
			do_resize = true;
		});
		
		if(test_member_count && this.participants.getLength() <= 1) {
			//No hay mas participantes
			//owner.input.set('disabled', 'true');
			//tinymce.get(owner.input.get('id')).settings.readonly = true;
//			tinymce.get(owner.input.get('id')).contentDocument.body.setAttribute('contenteditable', false);
			var editor_body = tinymce.get(owner.input.get('id')).contentDocument.body;
			editor_body.setAttribute('contenteditable', false);
			if(!editor_body.className.contains('disabled'))
				editor_body.className = editor_body.className += ' disabled';
			
			owner.isPermanentBlocked = true;
			
			var chatContent = owner.dialog.getElement('div.chat-content');
			var chatPrps = chatContent.getElement('div.chat-prps')
			var chatPrpOps = chatContent.getElement('div.chat-prp-opts');
			var fileContainer = chatContent.getElement('div.file-container');
			//if(chatPrps) chatPrps.destroy();
			//if(chatPrpOps) chatPrpOps.destroy();
			//if(fileContainer) fileContainer.destroy();
			if(chatPrps) chatPrps.addClass('hidden');
			if(chatPrpOps) chatPrpOps.addClass('hidden');
			if(fileContainer) fileContainer.addClass('hidden');
		}
		
		if(do_resize || toDelete.length > 0) {
			//Que se vuelvan a resizear las ventanas
			tabContainer.resizeChatWindows();
		}
	},
	
	clearParticipants: function(parts) {
		this.participants.each(function(value,key) {
			value.dispose();
		});
		
		this.participants.empty();
	},
	
	toggleCollapse: function(state) {
		this.dialog.toggleCollapse(state);
	},
	
	close: function() {
		this.dialog.close();
	},
	
	closeAndDestroy: function() {
		this.dialog.closeAndDestroy();
	}
});

ApiaChatConversation.next_id = 1;

