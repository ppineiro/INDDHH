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
		var m = formatDate.getMonth();
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

function startChat() {
	uiChat = new ApiaChatUI({
		hasLogin: false,
		url: 'server.chat',
		loginTitle: CHAT_TIT_LOGIN,
		mainTitle: CHAT_LBL_CONVERSATION,
		openMainOnLogged: false,
		onCloseMainDisconect: false
	});
	uiChat.checkStatus();
}

function toggleChatMainUi() {
	if (uiChat == null) startChat();
	uiChat.toggleMainUi();
}

/**
 * ApiaChatUrl: encargado de enviar los datos y procesar la información que le llega.
 * Es el único que es capaz de enviar información al servidor, procesar el resultado 
 * y llamar a los métodos correspondientes según el XML devuelto por el servidor.
 * 
 */
ApiaChatUrl = new Class({
	Implements: Options,
	
	options: {
		url: null,
		ui: null,
		delay: 1000 //default time in milisec to refresh the status
	},

	//--- Constructors --------------------------
	initialize: function(options) {
		//Set options
		this.setOptions(options);
	},
	
	sendData: function(data, action) {
		var owner = this;
		new Request( {
			method: 'post',
			data: data,
			url: this.options.url + '?action=' + action,
			onSuccess: function(text, xmlResponse) { owner.processXml(xmlResponse); },
			onRequest: function() { },
			onFailuer: function() { }
		} ).send();
	},
	
	setUi: function(ui) {
		this.options.ui = ui;
	},
	
	//--- Send information methods --------------
	sendLogin:					function(user, group)			{ this.sendData("name=" + user + "&group=" + group, "register"); },
	doLogout:					function()						{ this.sendData("", "unregister"); },
	refresh:					function()						{ this.sendData("", "callback"); },
	sendMessage:				function(id, msg)				{ this.sendData("conversationId=" + id + "&message=" + msg, "sendMessage"); },
	quitConversation:			function(id)					{ this.sendData("conversationId=" + id, "quitConversation"); },
	aceptConversationRequest:	function(requestId, groupId)	{ this.sendData("groupId=" + groupId + "&requestId=" + requestId, "acceptConversationRequest"); },
	requestConversation:		function(withId, about)			{ this.sendData("title=" + about + "&groupId=" + withId, "sendConversationRequest"); },
	startConversation: 			function(withId, about)			{ this.sendData("title=" + about + "&userId=" + withId, "startConversation"); },
	rejectFile:					function(conId, id, fileName)	{ this.sendData("transferId=" + id + "&fileName=" + fileName + "&conversationId=" + conId, "cancelTransfer"); },
	newTransfer:				function(conId, id, fileName)	{ this.sendData("transferId=" + id + "&fileName=" + fileName + "&conversationId=" + conId, "newTransfer"); },
	
	//--- Process information methods -----------
	processXml: function(xml) {
		var status = xml.getElementsByTagName("status")[0];
		this.options.ui.processLoginStatus(status);

		if (this.options.ui.logged && status != null && status.getAttribute("recall") == "true") {
			this.processUsers(xml.getElementsByTagName("users")[0]);
			this.processGroups(xml.getElementsByTagName("groups")[0]);
			this.processRequests(xml.getElementsByTagName("requests")[0]);

			this.processConversations(xml.getElementsByTagName("conversations")[0]);
			
			this.processBroadcasts(xml.getElementsByTagName("broadcasts")[0]);
			
			this.refresh.delay(this.options.delay,this);
		} else {
			var i = 1;
			i++;
			i = i - 1;
		}
	}, 
	
	processUsers: function(xml) {
		var elements = new Array();
		if (xml != null) {
			$each(xmlElementsToArray(xml.getElementsByTagName("user")), function(element, index) {
				elements.include({name: element.getAttribute('name'), id: element.getAttribute('id')});
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
				elements.include({
					id: element.getAttribute('id'), 
					groupName: element.getAttribute('group'),
					groupId: element.getAttribute('groupId'), 
					userName: element.getAttribute('user'),
					title: (element.firstChild != null) ? element.firstChild.nodeValue : ""
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
					$each(xmlElementsToArray(messages.getElementsByTagName("message")), function(message, index) {
						var from	= message.getAttribute("from");
						var msg		= (message.firstChild != null) ? message.firstChild.nodeValue : "";
						var type	= message.getAttribute("type");
						var extraId	= message.getAttribute("extraId");
						var fromMe	= message.getAttribute("fromMe");
						
						aConversation.messages.include({from: from, message: msg, type: type, extraId: extraId, fromMe: fromMe});
					});
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
	Implements: Options,
	
	options: {
		url: null,
		hasLogin: true, 		//Indica si tiene sección de login
		loginTitle: '',
		hasMain: true,			//Indica si tiene pantalla principal
		mainTitle: '',
		widthMain: 250,
		heightMain: 500,
		openMainOnLogged: true,
		onCloseMainDisconect: true,
		hasConversations: true,	//Indica si tiene pantallas de conversación
		delayRefresh: 1000
	},
	
	//--- Constructors --------------------------
	initialize: function(options) {
		this.setOptions(options);
		this.checkingStatus = false;
		
		//Parte lógica
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
		
		//Parte gráfica
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
	},
	
	//Parte gráfica
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
	
	doLogout: function() {
		$each(conversationsUi.getValues(), function(conversation) {
			conversation.close();
		});
		
		this.listConversationsUi.empty();
		this.listUsers.empty();
		this.listGrouos.empty();
		this.listRequests.empty();
		
		this.url.doLogout();
		
		this.showLogin();
		this.closeMain();
	},

	//Parte lógica
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
		
		$each(toRemove, function(key, index) { this.listGroups.erase(key); }, this);
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
		$each(toProcess.getValues(), function(element, index) { this.listRequests.set(element.id, element); }, this);

		if (this.options.hasMain) {
			if (this.mainUi.keepRequests(this.listRequests.getValues()) && ! this.mainUi.isOpen()) {
				this.showMain();
			}
		}
	},
	
	processBroadcasts: function(messages) {
		$each(messages, function(message) {
			if (message.block == "true") {
				var dialog = new Jx.Dialog({
			        label: CHAT_LBL_BY + ': ' + message.from ,
			        image: 'images/page_white_text.png',
			        modal: true, 
			        resize: false,
			        move: false,
			        content: new Element("div", {'html': message.message}),
			        width: 420,
			        height: 210
				});
				dialog.open();
			} else {
				(function() {new Message({
					  title: CHAT_LBL_BY + ': ' + message.from,
					  message: message.message,
					  stack: true,
					  waitTime: 4000
					}).say(); }).delay(250);
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
			}
			
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
	
	blockConversations: function() {
		this.listConversationsUi.getValues().each(function(conversation) {
			var dialog = new Jx.Dialog({
		        label: CHAT_TIT_CONVERSATION,
		        image: 'images/page_white_text.png',
		        modal: true, 
		        resize: false,
		        move: false,
		        content: new Element("div", {'html': CHAT_ERR_NOT_CONNECTED}),
		        width: 120,
		        height: 120,
		        parent: conversation.dialog.content
			});
			dialog.open();
		},this);
	},
	
	processLoginStatus: function(status) {
		var wasLogged = this.logged;
		
		this.logged = (status != null) ? status.getAttribute("connected") == "true" : false;
		if (this.logged) this.id = status.getAttribute("id");

		if (wasLogged && ! this.logged) {
			if (this.options.hasLogin)	this.loginUi.open();
			if (this.options.hasMain)	{
				this.mainUi.close();
				this.mainUi.clearUsers();
				this.mainUi.clearGroups();
				this.mainUi.clearRequests();
				this.mainUi.owner.blockConversations();
			}
		} else if (! wasLogged && this.logged) {
			if (this.options.hasLogin)	this.loginUi.close();
			if (this.options.hasMain && this.options.openMainOnLogged)	this.mainUi.open();
		}
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
 * Representa a un grupo al cual se le pueden enviar solicitudes de conversación.
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
		this.members = new Element("span", {'html': options.members});
		
		new Element("span", {'html': options.name + " ("}).inject(this.domObj);
		this.members.inject(this.domObj);
		new Element("span", {'html': ")"}).inject(this.domObj);
		
		//Add event
		this.domObj.addEvent('dblclick', this.dbClick, this);
	},
	
	dbClick: function(e) {
		var group = this.owner;
		group.owner.startConversationRequest(group.options.id, group.options.name);
	},
	
	update: function(amount) {
		if (this.options.members != amount) {
			this.members.innerHTML = amount;
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
		this.domObj = new Element("div", {'html': options.name, 'styles': {'cursor': 'pointer'}});
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
		this.domObj = new Element("div", {'html': options.groupName + " - " + options.userName + " - " + options.title, 'styles': {'cursor': 'pointer'}});
		this.domObj.owner = this;
		
		//Set event
		this.domObj.addEvent('dblclick', this.dbClick);
	},
	
	dbClick: function(e) {
		var request = this.owner;
		this.owner.options.url.aceptConversationRequest(request.options.id, request.options.groupId);
		request.owner.removeRequest(request.options.id);
	},
	
	inject: function(el,where) { $(this.domObj).inject(el,where); },
	dispose: function() { this.domObj.dispose(); }
});

ApiaChatMain = new Class({
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
		
		this.usersPanel = new Jx.Panel({ label: CHAT_PNL_USERS,  maximize: false,  collapse: false  });
		this.groupsPanel = new Jx.Panel({ label: CHAT_PNL_GROUPS, maximize: false, collapse: false });
		this.requestsPanel = new Jx.Panel({ label: CHAT_PNL_REQUESTS, maximize: false, collapse: false });
		
		var panelSet = new Jx.PanelSet({panels: [ this.usersPanel, this.groupsPanel, this.requestsPanel ]});

		this.dialog = new Jx.Dialog({
	        label: options.label, 
	        modal: false, 
	        width: options.width,
	        height: options.height,
	        resize: false,
	        content: panelSet,
	        horizontal: '10 left', 
	        vertical: '10 top', 
	        onClose: function() {
				var owner = this.owner;
				if (! owner.options.closed) {
					owner.options.closed = true;
					if (owner.options.onCloseDisonect) owner.options.url.doLogout();
				}
			}
	        
	    });
		this.dialog.owner = this;
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
		var form = new Element("div");
		new Element("div", {'html': CHAT_LBL_START_CON + " " + name + " " + CHAT_LBL_START_CON_WITH}).inject(form);
		var input = new Element("input", {
			"type": "text", 
			"styles": {"width": "95%"},
			events: {
				'keypress': function(e) {
					if (e.key == 'enter') {
						owner = this.owner;
						owner.button.click();
					}
				}
			}
		});
		input.inject(form);
		var separator = new Element("div",{
			"align": "right"
		});
		separator.inject(form);
		var button = new Element("input", {
			"type": "button", 
			"value": CHAT_BNT_SEND_REQUEST,
			events: {
				click: function(e) {
					this.url.startConversation(id,input.value);
					this.parent.close();
				}
			}
		});
		button.inject(separator);
		button.url = this.options.url;
		form.button = button;
		input.owner = form;
		
		var dialog = new Jx.Dialog({
	        label: CHAT_TIT_CONVERSATION,
	        image: 'images/page_white_text.png',
	        modal: true, 
	        collapse: false,
	        resize: false,
	        move: false,
	        content: form,
	        width: this.options.width * .80,
	        height: 130,
	        parent: this.dialog.content
		});
		
		button.parent = dialog;
		dialog.open();
		input.focus();
	},
	
	startConversationRequest: function(id, name) {
		var form = new Element("div");
		new Element("div", {'html': CHAT_LBL_REQ_CON + " " + name + " " + CHAT_LBL_START_CON_WITH}).inject(form);
		var input = new Element("input", {
			"type": "text", 
			"styles": {"width": "95%"},
			events: {
				'keypress': function(e) {
					if (e.key == 'enter') {
						owner = this.owner;
						owner.button.click();
					}
				}
			}
		});
		input.inject(form);
		
		new Element("div",{}).inject(form);
		var button = new Element("input", {
			"type": "button", 
			"value": CHAT_BNT_SEND_REQUEST,
			events: {
				click: function(e) {
					this.url.requestConversation(id,input.value);
					this.parent.close();
				}
			}
		});
		button.inject(form);
		button.url = this.options.url;
		form.button = button;
		input.owner = form;
		
		var dialog = new Jx.Dialog({
	        label: CHAT_TIT_REQUEST,
	        image: 'images/page_white_text.png',
	        modal: true, 
			collapse: false,
	        resize: false,
	        move: false,
	        content: form,
	        width: this.options.width * .80,
	        height: 130,
	        parent: this.dialog.content
		});
		
		button.parent = dialog;
		dialog.open();
		input.focus();
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
		$each(this.usersHash.getKeys(), function(id, index) {
			toDelete.include(id);
		});
		
		$each(users, function(user, index) {
			if (! owner.hasUser(user.id)) {
				owner.addUser(user);
			} else {
				toDelete.erase(user.id);
			}
		});
		
		$each(toDelete, function(id, index) {
			owner.usersHash.get(id).dispose();
			owner.usersHash.erase(id);
		});
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
		
		var dialog = new Jx.Dialog({
			label: options.label,
			image: 'images/delicious.png',
			modal: true,
			resize: false,
			move: false,
			close: false
		});
		
		var loginDiv = new Element("div", {'html': "User", 'styles': {'align': "center"}});
		var groupDiv = new Element("div", {'html': "Group", 'styles': {'align': "center"}});
		
		this.loginInput = new Element("input", {'type': "text"});
		this.groupInput = new Element("input", {'type': "text"});
		
		this.loginInput.inject(loginDiv);
		this.groupInput.inject(groupDiv);
		
		loginDiv.inject(dialog.content);
		groupDiv.inject(dialog.content);

		var loginButton = new Jx.Button({
			label: CHAT_TIT_DO_LOGIN,
			tooltip: 'a tooltip',
			onClick: function() {
				var owner = this.owner;
				owner.options.url.sendLogin(this.owner.getUserValue(),this.owner.getGroupValue());
			}
		});
		loginButton.owner = this;
		loginButton.addTo(dialog.content);
		
		this.dialog = dialog;
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
	
	initialize: function(options) {
		//Guardar propiedades
		this.options = options;
		this.options.closed = false;
		this.options.width = 500;
		this.options.height = 250;
		this.participants = new Hash({});
		
		//Crear ventana
		var dialog = new Jx.Dialog({
	        label: options.label,
	        image: 'images/page_white_text.png',
	        modal: false, 
	        resize: true,
	        move: true,
	        maximize: false,
	        width: this.options.width,
	        height: this.options.height,
	        onClose: function() {
				var owner = this.owner;
				if (! owner.options.closed) {
					owner.options.closed = true;
					owner.options.url.quitConversation(owner.options.id);
				}
			},
			onExpand: function() {
				if (this.owner != null) {
					this.setLabel(this.owner.options.label);
				}
			}
	    });
		
		this.dialog = dialog;
		this.dialog.owner = this;
		
		//Crear secciones de la ventana
		
		var panelParticipants = new Jx.Panel({
			label: CHAT_PNL_PART,
			collapse: false
		});
		this.secParticipants = panelParticipants.content;

		var panelMessages = new Jx.Panel({
			label: CHAT_PNL_MSGS,
			collapse: false
		});
		this.secMessages = panelMessages.content;
		this.secMessages.scroll = new Fx.Scroll(this.secMessages);
		
		var dinamic = new Element("div", {});
        dinamic.inject(dialog.content);

        var splitV = new Jx.Splitter(dialog.content, {
        	layout: 'vertical',
        	containerOptions: [null, {height: 25, minHeight: 25, maxHeight: 25}]
       	});

       	var splitH = new Jx.Splitter(splitV.elements[0], {
       		elements: [panelParticipants, panelMessages],
       		containerOptions: [{width: 25}, null]
       	});

       	//Crear la parte inferior
		var divLow = new Element("div", {});
		divLow.inject(dialog.content);
       	
		//Crear envio de mensaje al hacer ENTER
		var input = new Element("input", {});
		//input.inject(dialog.content);
		input.inject(divLow);
		input.owner = this;
		input.addEvent('keypress', function(evt) {
			if (evt.key == 'enter') {
				owner = this.owner;
				owner.sendMessage(this.value);
				this.value = "";
			}
		});
		
		var btnSendFile = new Element("input", {type: 'button', value: 'Archivo'});
		btnSendFile.inject(divLow);
		btnSendFile.owner = this;
		btnSendFile.addEvent('click', this.openSendFile);
		btnSendFile.dialog = this.dialog;
		new Jx.Layout(divLow, { top: null,  height: 25 });
		new Jx.Layout(input, { top: null,  height: 25, right: 50});
		new Jx.Layout(btnSendFile, { top: null,  left: null, width: 50});
	},
	
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
	
	sendMessage: function(msg) {
		if (msg == null || msg == "") return;
		this.options.url.sendMessage(this.options.id, msg);
	},
	
	open: function() {
		this.dialog.open();
	},
	
	newMessage: function(from, msg, id) {
		if (from != null) msg = "<b>" + from + ":</b> " + msg;

		new Element("div", {'title': formatDate(new Date(), DATE_FORMAT + " " + TIME_FORMAT), 'html': msg, 'id': id}).inject(this.secMessages);
		this.secMessages.scroll.toBottom();
		if (this.dialog.options.closed) {
			this.dialog.setLabel("<blink style='color:red'>***</blink> " + this.options.label + " <blink style='color:red'>***</span>");
		}
	},
	
	newMessages: function(messages) {
		if (messages != null && messages.length > 0) {
			$each(messages,function(message, index) {
				
				if (MSG_TYPE_NEW_USER == message.type)	return; //No mostrar que hay nuevos usuarios
				if (MSG_TYPE_EXIT_USER == message.type)	return; //No mostrar que se fue un usuario
				
				message.fromMe = message.fromMe == "true";
				
				if (MSG_TYPE_NEW_FILE_TRANFER == message.type) {
					if (message.fromMe) {
						var form = document.getElementById(message.extraId);
						
						this.newMessage(null, "<span id='spanMsg" + message.extraId + "'>" + CHAT_LBL_WAIT_ACEPT + message.message + ". <a href='#' id='aMsgRej" + message.extraId + "'>" + CHAT_BTN_REJECT_TRANS + "</a></span>", "msg" + message.extraId);
						
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
						params += "&";
						params += "fileName=" + message.message;
						params += "&";
						params += "transferId=" + message.extraId;
						params += "&";
						params += "conversationId=" + this.options.id;
						
						var url = this.options.owner.options.urlDownload + "?" + params;
						
						this.newMessage(null, "<span id='spanMsg" + message.extraId + "'>" + message.from + " " + CHAT_LBL_IS_SENDING + message.message + ". <a href='" + url + "' target='_new'>" + CHAT_BTN_ACEPT + "</a> | <a href='#' id='aMsgRej" + message.extraId + "'>" + CHAT_BTN_REJECT_TRANS + "</a></span>", "msg" + message.extraId);
						
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
					span.innerHTML = (message.fromMe ? CHAT_LBL_YOU : message.from) + " " + CHAT_LBL_ACEPT_TRANS + message.message + ".";
					
					if (! message.fromMe) {
						var params = "";
						params += "action=startTransfer";
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
					span.innerHTML = (message.fromMe ? CHAT_LBL_YOU : message.from) + " " + CHAT_LBL_CANEL_TRANS + message.message + ".";

					var form = $(message.extraId);
					if (form != null) form.parentNode.removeChild(form);
					
					var iframe = $("frm" + message.extraId);
					if (iframe != null) iframe.parentNode.removeChild(iframe);

					return;
				}
				
				if (MSG_TYPE_COMPLET_FILE_TRANFER == message.type) {
					var span = document.getElementById("spanMsg" + message.extraId);
					span.innerHTML = (message.fromMe ? message.from : CHAT_LBL_YOU) + " " + CHAT_LBL_ENDED_TRANS + message.message + ".";
					
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
				
				this.newMessage(message.from, message.message);
			}, this);
			
			if (this.dialog.options.closed) {
				this.dialog.setLabel("<blink style='color:red'>***</blink> " + this.options.label + " <blink style='color:red'>***</span>");
			}
		}
	},
	
	newParticipant: function(id, user) {
		if (! this.hasParticipant(id)) {
			var div = new Element("div", {'html': user});
			div.inject(this.secParticipants);
			this.participants.set(id,div);
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
		
		$each(users, function(user, index) {
			if (! owner.hasParticipant(user.id)) {
				owner.newParticipant(user.id, user.name);
			} else {
				toDelete.erase(user.id);
			}
		});
		
		$each(toDelete, function(id, index) {
			owner.participants.get(id).dispose();
			owner.participants.erase(id);
		});
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
	}
});
