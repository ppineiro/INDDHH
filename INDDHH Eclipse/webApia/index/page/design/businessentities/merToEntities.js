function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	/*
	$$("div.button").each(function(ele){
		setAdmEvents(ele);
	});
	*/
	$('frmData').formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: 10,
					tipsOffsetX: -10
				}
			}
	);
	
	var loadFrom = $('loadFrom');
	loadFrom.addEvent("change",function(e){
		e.stop();
		change(loadFrom);
	});
	
	var btnCont = $('btnCont');
	if (btnCont){
		btnCont.addEvent("click",function(e){
			e.stop();
			
			if (!canContinue){
				return
			}
			
			var form = $('frmData');
			if(!form.formChecker.isFormValid()){
				return;
			}
			
			
			var params = getFormParametersToSend(form);
			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=setParamsMER&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { cont(); }
			}).send(params);
			
		});
	}
	
	var btnUploadEnt = $('btnUploadEnt');
	if (btnUploadEnt){
		btnUploadEnt.addEvent("click", function(e) {
			e.stop();
			hideMessage();
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX+'?action=ajaxUploadStartMER&isAjax=true&' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();	
		});
	}
	
	if ($('connectionsCombo')){
		$('connectionsCombo').addEvent("change",function(e){
			e.stop();
			if ($('connectionsCombo').value!=-1){
				var request = new Request({
					method: 'post',
					data:{id:$('connectionsCombo').value},
					url: CONTEXT + URL_REQUEST_AJAX+'?action=testConnection&isAjax=true&' + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { processTest(resXml); }
				}).send();	
			}		
		});
		disposeValidation($('connectionsCombo'));
	}
	
	var btnBackToList = $('btnBackToList');
	if (btnBackToList){
		btnBackToList.addEvent("click",function(e){
			e.stop();
			
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = GNR_PER_DAT_ING;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); clickGoBack();\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel);
			SYS_PANELS.refresh();			
		});
	}
	
	
	if ($('cmbTipAdmDef')){
		$('cmbTipAdmDef').addEvent("change",function(e){
			e.stop();
			if ($('cmbTipAdmDef').value=='F'){
				$('chkAddCrePro').checked= false;
				$('chkAddAltPro').checked= false;													
			}
			
			$('chkAddCrePro').disabled = $('cmbTipAdmDef').value=='F';
			$('chkAddAltPro').disabled = $('cmbTipAdmDef').value=='F';			
		});
	}
	
	change(loadFrom);
}


var canContinue = false;
function processTest(xml){
	
	if (xml.getElementsByTagName("sysMessages").length != 0) {
		processXmlMessages(xml.getElementsByTagName("sysMessages").item(0), true);
	}else{
		canContinue =  true;
		SYS_PANELS.closeAll();
	} 
	
}

function cont(){
	window.location = CONTEXT + URL_REQUEST_AJAX+'?action=continueMER&isAjax=true&' + TAB_ID_REQUEST;
}

function ajaxUploadCallStatusUrlMER() {
	new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + "?action=ajaxUploadFileStatusMER&isAjax=true" + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) {
			modalProcessXml(resXml); }
		}).send();
} 

function setFileName(){
	 var ajaxCallXml = getLastFunctionAjaxCall();
	 if (ajaxCallXml != null) {
		 var messages = ajaxCallXml.getElementsByTagName("messages");
		 if (messages != null && messages.length > 0 && messages.item(0) != null) {
			 messages = messages.item(0).getElementsByTagName("message");
			 var message = messages.item(0);
			 if (message.firstChild != null) text = message.firstChild.nodeValue;
			 var fileName = text;
			 $('txtUpload').value=fileName;	 			 			 			 
		 }
	 }
	 SYS_PANELS.closeAll();
}

function registerValidation(obj){
	obj.className="validate['required']";
	$('frmData').formChecker.register(obj);
}

function disposeValidation(obj){
	$('frmData').formChecker.dispose(obj);
}

function change(loadFrom){
	canContinue=true;
	disposeValidation($('txtUpload'));
	disposeValidation($('connectionsCombo'));
	if (loadFrom.value == LOAD_FROM_FILE) {
		$('divFile').style.display='';
		$('divSep').style.display='';			
		registerValidation($('txtUpload'));
		$('divConn').style.display='none';
		$('panelOptions').style.display='';
		canContinue=true;
	} else {
		$('divConn').style.display='';
		registerValidation($('connectionsCombo'));			
		$('divFile').style.display='none';			
		$('divSep').style.display='none';
		$('panelOptions').style.display='none';
		if (DB_SELECTED==''){
			canContinue=false;
		}
	}
}

function clickGoBack(){
	sp.show(true);
	window.location = CONTEXT + URL_REQUEST_AJAX + '?action=list' + TAB_ID_REQUEST;	
}