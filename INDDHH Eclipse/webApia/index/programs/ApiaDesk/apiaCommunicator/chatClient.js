function ChatClient(){

	this.logged=false;
	this.mainUi;
	this.id;
	
	this.options= {
		url: null,
		ui: null,
		delay: CHAT_REFRESH_TIME //default time in milisec to refresh the status
	}
	
	
	this.listUsers=new Object();
	this.listGroups=new Object();
	this.listRequests=new Object();
	
	this.getRoster=function(){
		return this.getAbstractList(this.listUsers);
	}
	
	this.getGroups=function(){
		return this.getAbstractList(this.listGroups);
	}
	
	this.getRequests=function(){
		return this.getAbstractList(this.listRequests);
	}
	
	this.sendData=function(data, action) {
		
		var loader=new xmlLoader();
		loader.setData(data);
		var tmp=this;
		loader.onload=function(xmlResponse){
			if(MSIE){
			xmlResponse=xmlResponse.lastChild;
			}
		}
		loader.load(this.options.url + '?action=' + action);
	}
	
	this.sendAndLoadData=function(data, action) {
		var loader=new xmlLoader();
		loader.setData(data);
		var tmp=this;
		loader.onload=function(xmlResponse){
			if(MSIE){
			xmlResponse=xmlResponse.lastChild;
			}
			tmp.processXml(xmlResponse);
		}
		loader.load(this.options.url + '?action=' + action);
	}
	
	this.processXml=function(xml) {
		var status = xml.getElementsByTagName("status")[0];
		this.processLoginStatus(status);

		if (this.options.ui.logged && status != null && status.getAttribute("recall") == "true") {
			if(xml.getElementsByTagName("users").length>0){
				this.processUsers(xml.getElementsByTagName("users")[0]);
			}
			if(xml.getElementsByTagName("groups").length>0){
				this.processGroups(xml.getElementsByTagName("groups")[0]);
			}
			if(xml.getElementsByTagName("requests").length>0){
				this.processRequests(xml.getElementsByTagName("requests")[0]);
			}
			if(xml.getElementsByTagName("conversations").length>0){
				this.processConversations(xml.getElementsByTagName("conversations")[0]);
			}
			if(xml.getElementsByTagName("broadcasts").length>0){
				this.processBroadcasts(xml.getElementsByTagName("broadcasts")[0]);
			}
			this.refreshDelay(this.options.delay);
		}
	}
	
	this.setUi=function(ui) {
		this.options.ui = ui;
	}
	
	
	this.setUrl=function(url) {
		this.options.url = url;
	}
	
	this.setDownloadUrl=function(dUrl) {
		this.options.downloadUrl = dUrl;
	}
	
	this.register=function(){
	
	}
	
	//--- Send information methods --------------
	this.sendLogin=function(user, group){
		this.sendAndLoadData("name=" + user + "&group=" + group, "register"); 
	}
	this.doLogout=function(){
		this.sendData("", "unregister"); 
	}
	this.refresh=function(){
		this.sendAndLoadData("", "callback"); 
	}
	this.refreshDelay=function(time){
		if(MSIE){
			var owner=this;
			setTimeout(function(){owner.refresh()},time);
		}else{
			setTimeout(function(owner){owner.refresh()},time,this);
		}
	}
	this.sendMessage=function(id, msg){
		this.sendData("conversationId=" + id + "&message=" + msg, "sendMessage");
	}
	this.quitConversation=function(id){
		this.sendData("conversationId=" + id, "quitConversation");
	}
	this.aceptConversationRequest=function(requestId, groupId){
		this.sendData("groupId=" + groupId + "&requestId=" + requestId, "acceptConversationRequest");
	}
	this.requestConversation=function(withId, about){
		this.sendData("title=" + about + "&groupId=" + withId, "sendConversationRequest");
	}	
	this.startConversation=function(withId, about){
		this.sendData("title=" + about + "&userId=" + withId, "startConversation");
	}
	
	this.rejectFile=function(conId, id, fileName)	{
		this.sendData("transferId=" + id + "&fileName=" + fileName + "&conversationId=" + conId, "cancelTransfer"); 
	}
	
	this.newTransfer=function(conId, id, fileName)	{
		this.sendData("transferId=" + id + "&fileName=" + fileName + "&conversationId=" + conId, "newTransfer"); 
	}
	
	this.processLoginStatus= function(status) {
		var wasLogged = this.logged;
		
		this.logged = (status != null) ? status.getAttribute("connected") == "true" : false;
		if (this.logged){
			this.id = status.getAttribute("id");
		}

		if (wasLogged && ! this.logged) {
			this.onblocked();
		} else if (! wasLogged && this.logged) {
			//this.onregistered();
		}
		if(this.logged){
			this.options.ui.setBlock(false);			
		}
		this.options.ui.logged=this.logged;
	}



	this.processUsers= function(elements) {
		elements=this.xmlToElements(elements);
		var toProcess = new Object();
		for(var i=0;i<elements.length;i++){
			var element=elements[i];
			toProcess[element.id]=element;
		}
		
		var toRemove = new Array();
		
		for(var i in this.listUsers){
			if (toProcess[i]) {
				delete(toProcess[i]);
			} else {
				toRemove.push(i);
			}
		}
		
		for(var i=0;i<toRemove.length;i++){
			delete(this.listUsers[toRemove[i]]);
		}
		
		for(var i in toProcess){
			this.listUsers[i]=toProcess[i];
		}
			
		comm.updateRosterModel();
		
	}

	this.processGroups= function(elements) {
		elements=this.xmlToElements(elements);
		var toProcess = new Object();
		for(var i=0;i<elements.length;i++){
			var element=elements[i];
			toProcess[element.id]=element;
		}

		var toRemove = new Array();
		
		for(var i in this.listGroups){
			if (toProcess[i]) {
				this.listGroups[i].members = toProcess[i].members;
				delete(toProcess[i]);
			} else {
				toRemove.push(i);
			}
		}
		
		for(var i=0;i<toRemove.length;i++){
			delete(this.listGroups[toRemove[i]]);
		}
		
		for(var i in toProcess){
			this.listGroups[i]=toProcess[i];
		}
		
		comm.updateGroupModel();
	}

	this.processRequests= function(elements) {
		elements=this.xmlToElements(elements);
		var toProcess = new Object();
		for(var i=0;i<elements.length;i++){
			var element=elements[i];
			toProcess[element.id]=element;
		}
		
		var toRemove = new Array();
		
		for(var i in this.listRequests){
			if (toProcess[i]) {
				delete(toProcess[i]);
			} else {
				toRemove.push(i);
			}
		}
		
		for(var i=0;i<toRemove.length;i++){
			delete(this.listRequests[toRemove[i]]);
		}
		for(var i in toProcess){
			if(this.id!=this.listRequests[i]){
				this.listRequests[i]=toProcess[i];
			}
		}

		comm.updateRequests();
	}

	this.processBroadcasts= function(xml) {
		if (xml != null) {
			var elements = this.xmlToElements(xml);
			var toProcess=new Array();
			/*for(var i=0;i<elements.length;i++){
				var element=elements[i];
				toProcess.add[element.id]=element;
				$each(xmlElementsToArray(xml.getElementsByTagName("message")), function(element, index) {
					elements.include({
						from: element.getAttribute('from'), 
						fromMe: element.getAttribute('fromMe'), 
						block: element.getAttribute('block'), 
						message: (element.firstChild != null) ? element.firstChild.nodeValue : ""
					});
				});
			}*/
			this.options.ui.processBroadcasts(elements);
		}
	}

	this.processConversations= function(elements) {
		elements=this.xmlToElements(elements);
		var toProcess = new Object();
		
		for(var i=0;i<elements.length;i++){
			var element=elements[i];
			toProcess[element.id]=element;
		}
		
		var toRemove = new Array();
		for(var key in toProcess){
			var element = toProcess[key];

			var aConversation = this.options.ui.openMessageWindow(element.id,element.title);

			aConversation.keepParticipants(element.members);
			aConversation.newMessages(element.messages);
		}
	}
	
	this.xmlToElements=function(els){
		var arr=new Array();
		if(els && els.childNodes.length>0){
			els=els.childNodes;
			for(var i=0;i<els.length;i++){
				arr.push(this.nodeToElement(els[i]));
			}
		}
		return arr;
	}
	
	this.nodeToElement=function(node){
		var el=null;
		if(node){
			el=new Object();
			for(var i=0;i<node.attributes.length;i++){
				el[node.attributes[i].nodeName]=node.attributes[i].value;
			}
			for(var i=0;i<node.childNodes.length;i++){
				var childNode=node.childNodes[i];
				if(childNode.childNodes.length>0){
					el[childNode.nodeName]=this.xmlToElements(childNode);
				}else{
					try{
						el[childNode.nodeName]=this.nodeToElement(childNode);
					}catch(e){
						el["text"]=childNode.nodeValue;
					}
				}
			}
		}
		return el;
	}
	
	this.getAbstractList=function(obj){
		var l=new Array();
		for(var i in obj){
			l.push(obj[i]);
		}
		return l;
	}

}