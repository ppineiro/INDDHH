var refreshTimeDelay;
var arrChannels;
var MAX_LENGTH = 105;

var apiaItemTextClickedMsgId = null;

function initTaskReadPanel(){
	var apiaSocialShare = $('apiaSocialShare');
	if (apiaSocialShare){
		apiaSocialShare.addEvent("click",startApiaSocialShare);
		apiaSocialShare.tooltip(LBL_SHARE, { mode: 'auto', width: 100, hook: 0 });
	}	
	var btnSocialShare = $('btnSocialShare');
	if (btnSocialShare){
		btnSocialShare.addEvent("click", function(e) {
			if(this.getElement('button') && this.getElement('button').get('disabled'))
				e.stop();
			else
				startApiaSocialShare();
		});
		btnSocialShare.tooltip(LBL_SHARE, { mode: 'auto', width: 100, hook: 0 });
	}
	var btnApiaSocialRefresh = $('btnApiaSocialRefresh');
	if (btnApiaSocialRefresh){
		btnApiaSocialRefresh.addEvent("click",function(e){
			forceRefresh();
			loadCurrentChannels();
		});
		btnApiaSocialRefresh.tooltip(TT_REFRESH, { mode: 'auto', width: 100, hook: 0 });
	}
	
	initSocialShareMdlPage();
	initReadChannelMdlPage();
}

function loadCurrentChannels(){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=getSocialChannels&isAjax=true' + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { processXmlApiaSocialChannels(resXml); }
	}).send();
}

function loadApiaSocialCurrentMessages(resetFilDate,apiaSocialExecPanel){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=getSocialMessages&isAjax=true&currentInfo=true&resetFilDate=' + toBoolean(resetFilDate) + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { processXmlApiaSocialMessages(resXml); if (apiaSocialExecPanel){ apiaSocialExecPanel.hide(true); } }
	}).send();
}

function processXmlApiaSocialChannels(resXml){
	arrChannels = new Array();
	var channels = resXml.getElementsByTagName("result")
	if (channels != null && channels.length > 0 && channels.item(0) != null) {
		channels = channels.item(0).getElementsByTagName("channel");
		for (var i = 0; i < channels.length; i++){ 
			var xmlChn = channels[i];
			var obj = {
						'objType': xmlChn.getAttribute("type"), 
						'objId': xmlChn.getAttribute("id"),
						'chnName': xmlChn.getAttribute("name"),
						'chnEnabled': toBoolean(xmlChn.getAttribute("enabled"))
					}
			arrChannels.push(obj);
		}
	}
}

function processXmlApiaSocialMessages(resXml){
	if(!resXml) return;
	var messages = resXml.getElementsByTagName("result")
	if (messages != null && messages.length > 0 && messages.item(0) != null) {
		messages = messages.item(0).getElementsByTagName("message");
		var apiaSocialExecPanel = $('apiaSocialExecPanel');
		
		if (messages.length > 0){
			$('apiaSocialNoMessages').setStyle("display","none");
		}
		
		for (var i = messages.length-1; i >= 0; i--){ //se recorre de atras para adelante para insertar siempre al ppcio.
			var xmlMsg = messages[i];
			
			var msgDate = xmlMsg.getAttribute("date");
			var msgAuthor = xmlMsg.getAttribute("author");
			var msgObjType = xmlMsg.getAttribute("type");
			var msgObjId = xmlMsg.getAttribute("id");
			var msgName = xmlMsg.getAttribute("name");
			var msgText = xmlMsg.getAttribute("text");
			var msgDelete = toBoolean(xmlMsg.getAttribute("delete"));
			var msgId = xmlMsg.getAttribute("msgId");
			var msgChannels = xmlMsg.getAttribute("channels");
			var msgChannelsTitles = xmlMsg.getAttribute("chnTitles");			
			
			var add3Dots = false;
			var textToShow = msgText;
			if (textToShow.length > MAX_LENGTH){
				textToShow = textToShow.substring(0,MAX_LENGTH);
				add3Dots = true;
			}
			
			var apiaSocialItem = new Element("div.apiaSocialItem",{});
			var divApiaSocialTitle = new Element("div.apiaSocialTitle",{}).inject(apiaSocialItem);
			if (msgDelete){
				var divApiaSocialDelete = new Element("div.apiaSocialDelete",{}).inject(divApiaSocialTitle);
				divApiaSocialDelete.addEvent("click",function(e){
					e.stopPropagation();
					var parent = this.getParent("div.apiaSocialItem");
					var msgId = parent.getAttribute("msgId");
					showConfirm(LBL_DEL_MSG, "", function(ret) { if (ret) removeMessage(msgId); }, "modalWarning" );
				});
			}
			
			apiaSocialItem.addEvent("mouseover",function(e){ this.toggleClass("hover"); });
			apiaSocialItem.addEvent("mouseout",function(e){ this.toggleClass("hover"); });
			
			var apiaSocialTitleDate = new Element("span.apiaSocialTitle",{html:msgDate}).inject(divApiaSocialTitle);
			new Element("span.apiaSocialTitle",{html: "&nbsp;&nbsp;|&nbsp;&nbsp;"}).inject(divApiaSocialTitle);
			var apiaSocialTitleAuthor = new Element("span.apiaSocialTitle",{html:msgAuthor}).inject(divApiaSocialTitle);
			var apiaSocialText = new Element("div.apiaSocialText" + (add3Dots?".dots3":""),{html:textToShow}).inject(apiaSocialItem);			
									
			apiaSocialItem.setAttribute("msgDate",msgDate);
			apiaSocialItem.setAttribute("msgAuthor",msgAuthor);
			apiaSocialItem.setAttribute("msgObjType",msgObjType);
			apiaSocialItem.setAttribute("msgObjId",msgObjId);
			apiaSocialItem.setAttribute("msgName",msgName);
			apiaSocialItem.setAttribute("msgText",msgText);
			apiaSocialItem.setAttribute("msgDelete",msgDelete);
			apiaSocialItem.setAttribute("msgId",msgId);
			apiaSocialItem.setAttribute("channels",msgChannels);
			apiaSocialItem.setAttribute("channelsTitles",msgChannelsTitles);
						
			apiaSocialTitleAuthor.addEvent("click",function(e){
				e.stop();
				var parent = this.getParent("div.apiaSocialItem");
				startShowChannel(OBJ_CHANNEL_USER,parent.getAttribute("msgAuthor"),parent.getAttribute("msgName"));
			});
			apiaSocialText.addEvent("click",function(e){
				if (e) e.stop();
				var parent = this.getParent("div.apiaSocialItem");
				var title = parent.getAttribute("msgDate") + "  |  " + parent.getAttribute("msgAuthor");
				var htmlChannles = "";
				
				var arrMsgChannels = parent.getAttribute("channels").split(";");
				var arrMsgChannelsTitles = parent.getAttribute("channelsTitles").split(PRIMARY_SEPARATOR);
				
				var htmlChannels = '<br><br><u>'+TT_SHOW_CHANNELS+':</u><br>';
				for (var j = 0; j < arrMsgChannels.length; j++){
					var chnInfo = arrMsgChannels[j].split(PRIMARY_SEPARATOR);
					htmlChannels += '<br><span style=\'cursor: pointer;\' onclick=\'SYS_PANELS.closeActive();startShowChannel("'+chnInfo[0]+'","'+chnInfo[1]+'","'+arrMsgChannelsTitles[j]+'");\'>'+arrMsgChannelsTitles[j]+'</span>';
				}			
				
				apiaItemTextClickedMsgId = parent.getAttribute("msgId");
				
				showMessage(parent.getAttribute("msgText") + htmlChannels,title,'');
			});
			
			var arrMsgChannelsTitles = msgChannelsTitles.split(PRIMARY_SEPARATOR);
			var tooltip = "";
			for (var j = 0; j < arrMsgChannelsTitles.length; j++){
				tooltip += "<br>"+arrMsgChannelsTitles[j];
			}
			if (tooltip != ""){
				tooltip = LBL_CHANNELS + tooltip;
				apiaSocialText.tooltip(tooltip, { mode: 'auto', width: 150, hook: 0 });
			}
			
			var msgAfter = apiaSocialExecPanel.getElement("div.apiaSocialItem");
			if (msgAfter){
				apiaSocialItem.inject(msgAfter,"before");				
			} else {
				apiaSocialItem.inject(apiaSocialExecPanel);
			}
		}		
		
		if (messages.length > 0){
			addHScrollDiv(apiaSocialExecPanel.getParent("div"),Number.from(apiaSocialExecPanel.getStyle("width")));			
		}
	}
	
	$clear(refreshTimeDelay);
	refreshTimeDelay = loadApiaSocialCurrentMessages.delay(APIA_SOCIAL_REFRESH_TIME);	
}

function startApiaSocialShare(){
	showSocialShareModal(arrChannels,endApiaSocialShare);
}

function endApiaSocialShare(){
	$clear(refreshTimeDelay);
	loadApiaSocialCurrentMessages();	
}

function startShowChannel(objType,objId,chnName){
	var obj = {
			'objType': objType, 
			'objId': objId,
			'chnName': chnName	
			}
	showReadChannelModal(obj,endShowChannel);
}

function endShowChannel(){
	if (apiaItemTextClickedMsgId){ 
		var apiaSocialItems = $('apiaSocialExecPanel').getElements("div.apiaSocialItem");
		for (var i = 0; i < apiaSocialItems.length; i++){
			if (apiaSocialItems[i].getAttribute("msgId") == apiaItemTextClickedMsgId){ //es el mensaje buscado para borrar
				apiaSocialItems[i].getElement("div.apiaSocialText").fireEvent("click");
				break;
			}			
		}
	}
	forceRefresh();
}

function removeMessage(msgId){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=removeSocialMessage&isAjax=true&msgId=' + msgId + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { removeOk(resXml); }
	}).send();
}

function removeOk(resXml){
	var result = resXml.getElementsByTagName("result")
	if (result != null && result.length > 0 && result.item(0) != null) {
		result = result.item(0);
		
		if (toBoolean(result.getAttribute("delete"))){
			var msgId = result.getAttribute("msgId");
						
			var apiaSocialExecPanel = $('apiaSocialExecPanel');
			var apiaSocialItems = apiaSocialExecPanel.getElements("div.apiaSocialItem");
			
			for (var i = 0; i < apiaSocialItems.length; i++){
				var item = apiaSocialItems[i];
				if (item.getAttribute("msgId") == msgId){ //es el mensaje buscado para borrar
					item.destroy();
					addHScrollDiv(apiaSocialExecPanel.getParent("div"),Number.from(apiaSocialExecPanel.getStyle("width")));
					if (apiaSocialExecPanel.getElements("div.apiaSocialItem").length == 0){ // no queda ningun mensaje
						$('apiaSocialNoMessages').setStyle("display","");
					}
					break;
				}			
			}			
		}		
	}
}

function forceRefresh(){
	$clear(refreshTimeDelay);
	var apiaSocialExecPanel = $('apiaSocialExecPanel');
	var spApiaSocialExecPanel = new Spinner(apiaSocialExecPanel);
	spApiaSocialExecPanel.show(true);
	apiaSocialExecPanel.getElements("div.apiaSocialItem").each(function (item){
		item.destroy();
	});
	$('apiaSocialNoMessages').setStyle("display","");
	loadApiaSocialCurrentMessages(true,spApiaSocialExecPanel);
}

