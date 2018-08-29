var spModalCal;
var defaultMsg;
var defaultSub;

var NOTIFICATIONMODAL_HIDE_OVERFLOW	= true;

function initMsgNotificationsMdlPage(){
	var mdlMsgNotificationsContainer = $('mdlMsgNotificationsContainer');
	if (mdlMsgNotificationsContainer.initDone) return;
	mdlMsgNotificationsContainer.initDone = true;

	mdlMsgNotificationsContainer.blockerModal = new Mask();
	
	spModalCal = new Spinner($('mdlBodyMsg'),{message:WAIT_A_SECOND});
	
	//Default Message
	$('btnDefaultMsgNotificationsModal').addEvent("click", function(e){
		e.stop();
		$('msgText').value = defaultMsg;
		$('msgSubject').value = defaultSub;
	});
	//Confirm
	$('btnConfirmMsgNotificationsModal').addEvent("click", function(e){
		e.stop();
		if(this.OBJtooltip) this.OBJtooltip.hide();
		if (mdlMsgNotificationsContainer.onModalConfirm){
			//var ret = $('msgText').value;
			var ret = {subject: $('msgSubject').value, message: $('msgText').value};
			
			jsCaller(mdlMsgNotificationsContainer.onModalConfirm,ret);
		}		
		$('closeModalMsgNotifications').fireEvent("click");		
	});
	//Close
	$('closeModalMsgNotifications').addEvent("click", function(e) {
		if (e) { e.stop(); }
		closeMsgNotificationsModal();
	});
	
	//['btnDefaultMsgNotificationsModal','btnConfirmMsgNotificationsModal'].each(setTooltip);
	
	replaceAcents();
}

function replaceAcents(){
	DEFAULT_SUB_ASI = DEFAULT_SUB_ASI.replace("&#243;","�");
	DEFAULT_SUB_COM = DEFAULT_SUB_COM.replace("&#243;","�");
	DEFAULT_SUB_ACQ = DEFAULT_SUB_ACQ.replace("&#243;","�");
	DEFAULT_SUB_REL = DEFAULT_SUB_REL.replace("&#243;","�");
	DEFAULT_SUB_ALE = DEFAULT_SUB_ALE.replace("&#243;","�");
	DEFAULT_SUB_OVE = DEFAULT_SUB_OVE.replace("&#243;","�");
	DEFAULT_SUB_REA = DEFAULT_SUB_REA.replace("&#243;","�");
	DEFAULT_SUB_ELE = DEFAULT_SUB_ELE.replace("&#243;","�");
	DEFAULT_SUB_DEL = DEFAULT_SUB_DEL.replace("&#243;","�");
}

function showMsgNotificationsModal(event,sub,text,retFunction,closeFunction){
	
	if(NOTIFICATIONMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	var mdlMsgNotificationsContainer = $('mdlMsgNotificationsContainer');
	mdlMsgNotificationsContainer.removeClass('hiddenModal');
	mdlMsgNotificationsContainer.position();
	mdlMsgNotificationsContainer.blockerModal.show();
	mdlMsgNotificationsContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlMsgNotificationsContainer.onModalConfirm = retFunction;
	mdlMsgNotificationsContainer.onModalClose = closeFunction;
	
	if (event == "Asi"){
		$('mdlTitle').innerHTML = TIT_ASI;
		defaultMsg = DEFAULT_MSG_ASI;
		defaultSub = DEFAULT_SUB_ASI;
	} else if (event == "Com"){
		$('mdlTitle').innerHTML = TIT_COM;
		defaultMsg = DEFAULT_MSG_COM;
		defaultSub = DEFAULT_SUB_COM
	} else if (event == "Acq"){
		$('mdlTitle').innerHTML = TIT_ACQ;
		defaultMsg = DEFAULT_MSG_ACQ;
		defaultSub = DEFAULT_SUB_ACQ
	} else if (event == "Rel"){
		$('mdlTitle').innerHTML = TIT_REL;
		defaultMsg = DEFAULT_MSG_REL;
		defaultSub = DEFAULT_SUB_REL;
	} else if (event == "Ale"){
		$('mdlTitle').innerHTML = TIT_ALE;
		defaultMsg = DEFAULT_MSG_ALE;
		defaultSub = DEFAULT_SUB_ALE;
	} else if (event == "Ove"){
		$('mdlTitle').innerHTML = TIT_OVE;
		defaultMsg = DEFAULT_MSG_OVE;
		defaultSub = DEFAULT_SUB_OVE;
	} else if (event == "Rea"){
		$('mdlTitle').innerHTML = TIT_REA;
		defaultMsg = DEFAULT_MSG_REA;
		defaultSub = DEFAULT_SUB_REA;
	} else if (event == "Ele"){
		$('mdlTitle').innerHTML = TIT_ELE;
		defaultMsg = DEFAULT_MSG_ELE;
		defaultSub = DEFAULT_SUB_ELE;
	} else if (event == "Del"){
		$('mdlTitle').innerHTML = TIT_DEL;
		defaultMsg = DEFAULT_MSG_DEL;
		defaultSub = DEFAULT_SUB_DEL;
	}
	
	spModalCal.show(true);
	if (text == null) text = defaultMsg;
	if(sub == null) sub = defaultSub;
	$('msgText').value = text;
	$('msgSubject').value = sub;
	spModalCal.hide(true);
}

function closeMsgNotificationsModal(){
    var mdlMsgNotificationsContainer = $('mdlMsgNotificationsContainer');
    
    if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlMsgNotificationsContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlMsgNotificationsContainer.addClass('hiddenModal');
			mdlMsgNotificationsContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlMsgNotificationsContainer.blockerModal.hide();
			if (mdlMsgNotificationsContainer.onModalClose) mdlMsgNotificationsContainer.onModalClose();
			
			if(NOTIFICATIONMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlMsgNotificationsContainer.addClass('hiddenModal');
		
	    mdlMsgNotificationsContainer.blockerModal.hide();
		if (mdlMsgNotificationsContainer.onModalClose) mdlMsgNotificationsContainer.onModalClose();
		
		if(NOTIFICATIONMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
    
    
}