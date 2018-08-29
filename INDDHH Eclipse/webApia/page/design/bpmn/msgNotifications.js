var spModalCal;
var defaultMsg;
var defaultSub;

var NOTIFICATIONMODAL_HIDE_OVERFLOW	= true;

function initMsgNotificationsMdlPage(){
	var mdlMsgNotificationsContainer = $('mdlMsgNotificationsContainer');
	if (mdlMsgNotificationsContainer.initDone) return;
	mdlMsgNotificationsContainer.initDone = true;

	mdlMsgNotificationsContainer.blockerModal = new Mask();
	
	spModalCal = new Spinner($('mdlBodyNotif'),{message:WAIT_A_SECOND});
	
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
	DEFAULT_SUB_C = DEFAULT_SUB_C.replace("&#243;","�");
	DEFAULT_SUB_E = DEFAULT_SUB_E.replace("&#243;","�");
	DEFAULT_SUB_A = DEFAULT_SUB_A.replace("&#243;","�");
	DEFAULT_SUB_O = DEFAULT_SUB_O.replace("&#243;","�");
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
	
	if (event == "C"){
		$('mdlTitle').innerHTML = TIT_C;
		defaultMsg = DEFAULT_MSG_C;
		defaultSub = DEFAULT_SUB_C;
	} else if (event == "E"){
		$('mdlTitle').innerHTML = TIT_E;
		defaultMsg = DEFAULT_MSG_E;
		defaultSub = DEFAULT_SUB_E;
	} else if (event == "A"){
		$('mdlTitle').innerHTML = TIT_A;
		defaultMsg = DEFAULT_MSG_A;
		defaultSub = DEFAULT_SUB_A;
	} else {
		$('mdlTitle').innerHTML = TIT_O;
		defaultMsg = DEFAULT_MSG_O;
		defaultSub = DEFAULT_SUB_O;
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