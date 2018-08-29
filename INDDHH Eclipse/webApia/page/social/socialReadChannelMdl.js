var spModalReadChannel;
var refreshTimeReadChannelDelay;

function initReadChannelMdlPage(){
	var mdlReadChannelContainer = $('mdlReadChannelContainer');
	if (mdlReadChannelContainer.initDone) return;
	mdlReadChannelContainer.initDone = true;

	mdlReadChannelContainer.blockerModal = new Mask();
	
	spModalReadChannel = new Spinner($('chnMdlBody'),{message:WAIT_A_SECOND});
	
	//Publicar
	$('btnPublishMdlReadChannel').addEvent("click", function(e){
		e.stop();		
		var txtToPub = $('chnTxtToPub').value; 
		if (txtToPub != ''){
			txtToPub = '&txtToPub=' + encodeURIComponent(txtToPub);
			var strChannels = setChannel(); //objType·objId 
			var request = new Request({
				method : 'post',
				url : CONTEXT + URL_REQUEST_AJAX + '?action=publishSocialMessage&isAjax=true&fromReadChannelMdl=true&channels=' + strChannels + TAB_ID_REQUEST,
				onRequest : function() { SYS_PANELS.showLoading(); },
				onComplete : function(resText, resXml) { modalProcessXml(resXml); }
			}).send(txtToPub);
		} else {
			showMessage(MSG_NO_EMPTY_MSG, GNR_TIT_WARNING, 'modalWarning');
		}	
	});
	//Cerrar
	$('closeMdlReadChannel').addEvent("click", function(e) {
		if (e) { e.stop(); }
		closeReadChannelModal();
	});
}

function publishOkReadChannel(ok){
	ok = toBoolean(ok);
	SYS_PANELS.closeAll();
	if (ok){
		$('chnTxtToPub').value = '';
		showMessage(MSG_CHN_PUB_OK);
		hideMessage.delay(1000);
	} else {
		showMessage(MSG_CHN_PUB_NO_OK, GNR_TIT_WARNING, 'modalWarning');
	}	
	$clear(refreshTimeReadChannelDelay);
	loadSocialChannelMessages();
}

function showReadChannelModal(channel,closeFunction){ //channel: {objType,objId,chnName} 
	var mdlReadChannelContainer = $('mdlReadChannelContainer');
	mdlReadChannelContainer.removeClass('hiddenModal');
	mdlReadChannelContainer.position();
	mdlReadChannelContainer.blockerModal.show();
	mdlReadChannelContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlReadChannelContainer.closeFunction = closeFunction;	
	mdlReadChannelContainer.channel = channel;
	
	loadChannel(mdlReadChannelContainer.channel);
	
	mdlReadChannelContainer.position();
}

function loadChannel(channel){
	spModalReadChannel.show(true);
	
	//titulo
	$('mdlReadChannelTitle').innerHTML = channel.chnName;
	
	$('apiaSocialReadChannel').getElements("div.apiaSocialItem").each(function (item){ item.destroy(); });
		
	$('chnTxtToPub').value = '';
	
	loadSocialChannelMessages(true);
		
	spModalReadChannel.hide(true);	
}

function loadSocialChannelMessages(init){
	var channel = getChannelParams();
	
	var resetFilDate = '&resetFilDate=' + toBoolean(init);
	var request = new Request({
		method : 'post',
		async: !toBoolean(init),
		url : CONTEXT + URL_REQUEST_AJAX + '?action=getSocialMessages&isAjax=true&currentInfo=false' + resetFilDate + channel + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { processXmlSocialChannelMessages(resXml); }
	}).send();
}

function processXmlSocialChannelMessages(resXml){
	var messages = resXml.getElementsByTagName("result")
	if (messages != null && messages.length > 0 && messages.item(0) != null) {
		messages = messages.item(0).getElementsByTagName("message");
		var apiaSocialReadChannel = $('apiaSocialReadChannel');
		
		if (messages.length > 0){
			$('apiaSocialNoMessagesReadChannel').setStyle("display","none");
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
			
			var apiaSocialItem = new Element("div.apiaSocialItem",{});
			var apiaSocialTitle = new Element("div.apiaSocialTitle",{html: msgDate + '  |  ' + msgAuthor}).inject(apiaSocialItem);
			if (msgDelete){
				var divApiaSocialDelete = new Element("div.apiaSocialDelete",{}).inject(apiaSocialTitle);
				divApiaSocialDelete.addEvent("click",function(e){
					e.stopPropagation();
					var parent = this.getParent("div.apiaSocialItem");
					var msgIde = parent.getAttribute("msgId");
					var objType = parent.getAttribute("msgObjType");
					var objId = parent.getAttribute("msgObjId");
					
					showConfirm(MSG_DEL_MSG, "", function(ret) { if (ret) removeMessageReadChannel(msgId,objType,objId); }, "modalWarning" );					
				});
			}
			var apiaSocialText = new Element("div.apiaSocialText",{html:msgText}).inject(apiaSocialItem);	
						
			apiaSocialItem.setAttribute("msgDate",msgDate);
			apiaSocialItem.setAttribute("msgAuthor",msgAuthor);
			apiaSocialItem.setAttribute("msgObjType",msgObjType);
			apiaSocialItem.setAttribute("msgObjId",msgObjId);
			apiaSocialItem.setAttribute("msgName",msgName);
			apiaSocialItem.setAttribute("msgDelete",msgDelete);
			apiaSocialItem.setAttribute("msgId",msgId);
			
			apiaSocialItem.addEvent("mouseover",function(e){ this.toggleClass("hover"); });
			apiaSocialItem.addEvent("mouseout",function(e){ this.toggleClass("hover"); });
			
			var msgAfter = apiaSocialReadChannel.getElement("div.apiaSocialItem");
			if (msgAfter){
				apiaSocialItem.inject(msgAfter,"before");				
			} else {
				apiaSocialItem.inject(apiaSocialReadChannel);
			}						
		}	
		
		if (messages.length > 0){
			addHScrollDiv(apiaSocialReadChannel.getParent("div"),Number.from(apiaSocialReadChannel.getStyle("width")));			
		}
	}	
	
	$clear(refreshTimeReadChannelDelay);
	refreshTimeReadChannelDelay = loadSocialChannelMessages.delay(APIA_SOCIAL_REFRESH_TIME_MDL_CHN);	
	
	mdlReadChannelContainer.position();
}

function closeReadChannelModal(){
	$clear(refreshTimeReadChannelDelay);
    var mdlReadChannelContainer = $('mdlReadChannelContainer');
    mdlReadChannelContainer.addClass('hiddenModal');
    mdlReadChannelContainer.blockerModal.hide();    
    if (mdlReadChannelContainer.closeFunction) mdlReadChannelContainer.closeFunction();
}

function setChannel(){
	var mdlReadChannelContainer = $('mdlReadChannelContainer');
	return mdlReadChannelContainer.channel.objType + '·' + mdlReadChannelContainer.channel.objId;
}

function getChannelParams(){
	var mdlReadChannelContainer = $('mdlReadChannelContainer');
	var strParams = '';
	
	var objType = mdlReadChannelContainer.channel.objType;
	var objId = mdlReadChannelContainer.channel.objId;
	
	if (MDL_OBJ_CHANNEL_ENVIRONMENT == objType){
		strParams += '&chnE=true';
		strParams += '&chnEvalues=' + objId;
	} else if (MDL_OBJ_CHANNEL_PROCESS == objType){
		strParams += '&chnP=true';
		strParams += '&chnPvalues=' + objId;
	} else if (MDL_OBJ_CHANNEL_TASK == objType){
		strParams += '&chnT=true';
		strParams += '&chnTvalues=' + objId;
	} else if (MDL_OBJ_CHANNEL_POOL == objType){
		strParams += '&chnG=true';
		strParams += '&chnGvalues=' + objId;
	} else if (MDL_OBJ_CHANNEL_USER == objType){
		strParams += '&chnU=true';
		strParams += '&chnUvalues=' + objId;
	}		
	
	return strParams;
}

function removeMessageReadChannel(msgId,objType,objId){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=removeSocialMessage&isAjax=true&msgId=' + msgId + '&objType=' + objType + '&objId=' + objId + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { removeOkReadChannel(resXml); }
	}).send();
}

function removeOkReadChannel(resXml){
	var result = resXml.getElementsByTagName("result")
	if (result != null && result.length > 0 && result.item(0) != null) {
		result = result.item(0);
		
		if (toBoolean(result.getAttribute("delete"))){
			var msgId = result.getAttribute("msgId");
			
			var apiaSocialReadChannel = $('apiaSocialReadChannel');
			var apiaSocialItems = apiaSocialReadChannel.getElements("div.apiaSocialItem");
			
			for (var i = 0; i < apiaSocialItems.length; i++){
				var item = apiaSocialItems[i];
				if (item.getAttribute("msgId") == msgId){ //es el mensaje buscado para borrar
					item.destroy();
					addHScrollDiv(apiaSocialReadChannel.getParent("div"),Number.from(apiaSocialReadChannel.getStyle("width")));
					if (apiaSocialReadChannel.getElements("div.apiaSocialItem").length == 0){ // no queda ningun mensaje
						$('apiaSocialNoMessagesReadChannel').setStyle("display","");
					}
					break;
				}			
			}			
		}		
	}
}