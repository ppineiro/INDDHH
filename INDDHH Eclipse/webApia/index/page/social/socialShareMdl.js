var spModalSocShare;

function initSocialShareMdlPage(){
	var mdlSocialShareContainer = $('mdlSocialShareContainer');
	if (mdlSocialShareContainer.initDone) return;
	mdlSocialShareContainer.initDone = true;

	mdlSocialShareContainer.blockerModal = new Mask();
	
	spModalSocShare = new Spinner($('mdlBody'),{message:WAIT_A_SECOND});
	
	//Publicar
	$('btnPublishMdlSocialShare').addEvent("click", function(e){
		e.stop();		
		var txtToPub = $('txtToPub').value; 
		if (txtToPub != ''){
			txtToPub = '&txtToPub=' + encodeURIComponent(txtToPub);
			var strChannels = getChannels(); //objType�objId;objType�objId;... 
			if (strChannels != null){ //se verifica que se marque al menos un canal
				
				if(PRIMARY_SEPARATOR_IN_BODY) {
					new Request({
						method : 'post',
						url : CONTEXT + URL_REQUEST_AJAX + '?action=publishSocialMessage&isAjax=true' + TAB_ID_REQUEST,
						onRequest : function() { SYS_PANELS.showLoading(); },
						onComplete : function(resText, resXml) { modalProcessXml(resXml); }
					}).send(txtToPub + '&channels=' + strChannels);
				} else {
					new Request({
						method : 'post',
						url : CONTEXT + URL_REQUEST_AJAX + '?action=publishSocialMessage&isAjax=true&channels=' + strChannels + TAB_ID_REQUEST,
						onRequest : function() { SYS_PANELS.showLoading(); },
						onComplete : function(resText, resXml) { modalProcessXml(resXml); }
					}).send(txtToPub);
				}
				
			} else {
				showMessage(MSG_MARK_CHANNEL, GNR_TIT_WARNING, 'modalWarning');
			}
		} else {
			showMessage(MSG_NO_EMPTY_MSG, GNR_TIT_WARNING, 'modalWarning');
		}		
	});
	//Cerrar
	$('closeMdlSocialShare').addEvent("click", function(e) {
		if (e) { e.stop(); }
		closeSocialShareModal();
	});
}

function publishOk(ok){
	ok = toBoolean(ok);
	SYS_PANELS.closeAll();
	if (ok){
		$('txtToPub').value = '';
		showMessage(MSG_PUB_OK);
		hideMessage.delay(1000);
	} else {
		showMessage(MSG_PUB_NO_OK, GNR_TIT_WARNING, 'modalWarning');		
	}	
	
}

function showSocialShareModal(channels,closeFunction){ //channels: [{objType,objId,chnName},...] 
	var mdlSocialShareContainer = $('mdlSocialShareContainer');
	mdlSocialShareContainer.removeClass('hiddenModal');
	mdlSocialShareContainer.position();
	mdlSocialShareContainer.blockerModal.show();
	mdlSocialShareContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlSocialShareContainer.closeFunction = closeFunction;	
	mdlSocialShareContainer.channels = channels;
	
	initModalData(mdlSocialShareContainer.channels);
	
	mdlSocialShareContainer.position();
}

function initModalData(channels){
	spModalSocShare.show(true);
	
	var divChannels = $('channels');
	divChannels.getElements("div.fieldHalfMdl").each(function(input){ input.destroy(); });
	
	if (channels != null){
		for (var i = 0; i < channels.length; i++){
			var objType = channels[i].objType;
			var objId = channels[i].objId;
			var chnName = channels[i].chnName;			
			var chnEnabled = channels[i].chnEnabled;
			
			var fieldHalfMdl = new Element("div.field.fieldHalfMdl.inOneLine",{}).inject(divChannels);
			if (i % 2 == 1) { fieldHalfMdl.setStyle("float","right"); }
			
			var chk = new Element("input.channel",{'type':'checkbox', 'checked':chnEnabled});
			chk.setAttribute("objType",objType);
			chk.setAttribute("objId",objId);
			chk.disabled = !chnEnabled;						
			chk.inject(fieldHalfMdl);			
			
			new Element("label",{'class':'label',html:chnName,'title':chnName}).inject(fieldHalfMdl);
		}
	}
	
	$('txtToPub').value = '';
	
	spModalSocShare.hide(true);	
}

function closeSocialShareModal(){
    var mdlSocialShareContainer = $('mdlSocialShareContainer');
    mdlSocialShareContainer.addClass('hiddenModal');
    mdlSocialShareContainer.blockerModal.hide();
    if (mdlSocialShareContainer.closeFunction) mdlSocialShareContainer.closeFunction();
}

function getChannels(){
	var strRet = '';
	$('channels').getElements("input.channel").each(function(input){
		if (input.checked){
			if (strRet != '') { strRet += ';'; }
			strRet += input.getAttribute("objType") + PRIMARY_SEPARATOR + input.getAttribute("objId");
		}
	});	
	if (strRet == ''){ strRet = null; }
	return strRet;
}