var formChecker;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	formChecker = new FormCheck(
		'frmClone',
		{
			submit:false,
			display : {
				keepFocusOnError : 1,
				tipsPosition: 'left',
				tipsOffsetY: -12,
				tipsOffsetX: -10
			}
		}
	);
	
	$("fncDescriptionText").innerHTML="";
	var htmlText = "<label id=\"messageText\">"+ FNC_DESCRIPTION + "</label>"; 
	new Element('label', {html: htmlText}).inject($('fncDescriptionText'));
	
	$('btnConf').addEvent("click", function(e) {
		e.stop();
		
		if(!formChecker.isFormValid()){
			return;
		}
		
		var request = new Request({
			method: 'post',
			data: {
				txtLogin: $('usrLogin').value,
				txtName: $('usrName').value,
				txtPwd: $('password').value,
				txtEmail: $('usrEmail').value,
				txtComments: $('usrComments').value
			},
			url: CONTEXT + '/apia.administration.UsersAction.run?action=confClone',
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) { processXMLResponse(resXml); sp.hide(true); }
		}).send();
	});
	
	$('btnRea').addEvent("click", function(e) {
		e.stop();
		
		if(!formChecker.isFormValid()){
			return;
		}
		
		var request = new Request({
			method: 'post',
			data: {
				txtLogin: $('usrLogin').value,
				txtName: $('usrName').value,
				txtPwd: $('password').value,
				txtEmail: $('usrEmail').value,
				txtComments: $('usrComments').value
			},
			url: CONTEXT + '/apia.administration.UsersAction.run?action=confReactivateClone',
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) { processXMLResponse(resXml); sp.hide(true); }
		}).send();
	});
	
	$('btnBack').addEvent("click", function(e) {
		e.stop();
		sp.show(true);
		window.location = CONTEXT + '/page/administration/users/list.jsp';
		
	});
	
	
	if(AUTH_METHOD == LDAP_METHOD && AUTH_FULL == "true" ){
		USERMODAL_EXTERNAL = true;
		USERMODAL_SELECTONLYONE	= true;
		initUsrMdlPage();
		
		$('usrName').addClass("readonly");
		$('usrEmail').addClass("readonly");
		$('password').addClass("readonly");
		$('passwordConf').addClass("readonly");
		
		$('usrName').setAttribute('readOnly','readonly');
		$('usrEmail').setAttribute('readOnly','readonly');
		$('password').setAttribute('readOnly','readonly');
		$('passwordConf').setAttribute('readOnly','readonly');
		
		
		$('imgSearchExt').removeClass("hidden");
		$('imgSearchExt').addEvent("click", function(e) {
			e.stop();

			showUsersModal(processUsersModalReturn);
			
		});
	}
}

function processUsersModalReturn(ret){
	ret.each(function(e){
		var login = e.getRowContent()[0];
		var name = e.getRowContent()[1];
		var mail = e.getRowContent()[2];
		$('usrLogin').value = login;
		$('usrName').value = name;
		$('usrEmail').value = mail;
		$('password').value = login;
		$('passwordConf').value = login;
		
	});
}

function  processXMLResponse(ajaxCallXml){
	if (ajaxCallXml != null) {
		//obtener el codigo de retorno
		var code = ajaxCallXml.getElementsByTagName("code");
		
		//0--> ok
		//1--> error
		//2--> reactivar
		if("0" == code.item(0).firstChild.nodeValue){
			sp.show(true);
			window.location = CONTEXT + '/apia.administration.UsersAction.run?action=list' + TAB_ID_REQUEST;
		} else if ("1" == code.item(0).firstChild.nodeValue){
			var messages = ajaxCallXml.getElementsByTagName("messages");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("message");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);	
				}
			}
		} else if ("2" == code.item(0).firstChild.nodeValue) {

			var messages = ajaxCallXml.getElementsByTagName("messages");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("message");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);	
				}
			}
			//poner visible el boton reactivar
			$('btnConf').addClass('hidden');
			$('btnRea').removeClass('hidden');
		
		}
	}
	
}