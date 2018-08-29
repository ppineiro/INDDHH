var formChecker;
var formCheckerRemember;
var formCheckerChange;
var tipCapsLockUsu;
var sp;
var TOKEN_ID;

document.msCapsLockWarningOff = true;

window.addEvent('load', function() {
	var IN_IFRAME	= window != window.parent && window.parent != null && window.parent.document != null;
	
	if (!(IS_EXTERNAL=="true") && IN_IFRAME) window.parent.document.location = CONTEXT + "/page/login/login.jsp";
	
	//imagen de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	if(Browser.ie) {
		sp.content.getParent().setStyles({top:0, left: 0});
		//$(document.body).setStyle('overflow-y', 'hidden');
		$(document.body).getElement('div.spinner-img').setStyles({
			width: '100%',
			backgroundPosition: 'center'
		}).set('scroll', 'auto');
	}
	
	//tooltips para links de la pagina
	var loginRemember = $('loginRemember');
	if (loginRemember) loginRemember.tooltip(LOGIN_REMEMBER_TITLE, { mode: 'auto', width: 140, hook: 1 });
	var tipDoLogin = $('doLogin').tooltip(DO_LOGIN, { mode: 'auto', width: 140, hook: 1 });
	
	tipCapsLockUsu = $('loginUsr').tooltip(CAPS_TITLE, { mode: 'auto', width: 200, hook: 0, mouse:false, click:false });
	
	formChecker = new FormCheck(
			'loginForm',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetX: -10
				}
			}
	);

	formCheckerRemember = new FormCheck(
			'requestForm',
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
	
	formCheckerChange = new FormCheck(
			'passwordForm',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: -12,
					tipsOffsetX: -10,
					titlesInsteadNames : 1
				}
			}
	);
	
	
	Generic.setButton($("login")).addEvent("click", function(e) {
		if(e) e.stop();
		$("messageContainer").addClass("hidden");
		
		if(!formChecker.isFormValid()){
			return;
		}
		
		if(Generic.hasNotificationPermission()) {
			login();
		} else {
			Generic.requestNotificationPermission(login);
		}
	});
	
	Generic.setButton($("rememberBtn")).addEvent("click", function(e) {
		e.stop();
		$("messageContainer").addClass("hidden");
		
		if(!formCheckerRemember.isFormValid()){
			return;
		}
		
		
		var request = new Request({
			method: 'post',
			url: CONTEXT + '/apia.security.LoginAction.run?action=remember&tokenId=' + TOKEN_ID,
			data: {
				login: $('rememberUser').value,
				email: $('rememberEmail').value
			},
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) {processXMLRememberResponse(resXml);sp.hide(true); }
		}).send();
	});
	 
	Generic.setButton($("changePwd")).addEvent("click", function(e) {
		e.stop();
		$("messageContainer").addClass("hidden");
		
		if(!formCheckerChange.isFormValid()){
			return;
		}
		
		
		var request = new Request({
			method: 'post',
			url: CONTEXT + '/apia.security.LoginAction.run?action=changePwd&tokenId=' + TOKEN_ID,
			data: {
				pwd: $('currentPassword').value,
				newPassword: $('newPassword').value
			},
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) {processXMLChangeResponse(resXml);sp.hide(true); }
		}).send();
	});
	
	$("loginUsr").addEvent("keydown" , function(evt){checkCapsLock(evt);});
	if($("loginPassword")){
		$("loginPassword").addEvent("keydown" , function(evt){checkCapsLock(evt);});
	}
	
	if("true" != SHOW_ENV_COMBO){
		var loginEnvironmentName = $("loginEnvironmentName");
		if (loginEnvironmentName) loginEnvironmentName.addEvent("keydown" , function(evt){checkCapsLock(evt);}); 
	} else {
		var loginEnvironment = $('loginEnvironment');
		if (loginEnvironment) loginEnvironment.addEvent("keydown", function(e) {
			if (e.key == "enter") {
				e.stop();
				$("login").click();
				return true;
			}
		});
	}
	
 
	var loginRemember = $("loginRemember");
	if (loginRemember) loginRemember.addEvent("click", switchForms);
	
	$("doLogin").addEvent("click", switchForms);
	
	Generic.setButton($("cancelChangePwd")).addEvent("click", gotoLogin);
	
	//$('loginUsr').focus();
	$('loginUsr').focus();
	
	if(isAuthenticated && ENV_ID!=""){
		$('loginEnvironment').value = ENV_ID; 
		login();
	}

});

function login() {
	if("true" == SHOW_ENV_COMBO){
		var loginEnvironment = $('loginEnvironment');
		var loginEnvironmentName = $('loginEnvironmentName');
		var pass = "";
		if($('loginPassword')){
			pass = $('loginPassword').value;	
		}
		
		var request = new Request({
			method: 'post',
			url: CONTEXT + '/apia.security.LoginAction.run?action=login',
			data: {
				login: $('loginUsr').value,
				pwd: pass,
				envId: loginEnvironment == null ? '' : loginEnvironment.value,
				envName: loginEnvironmentName == null ? '' : loginEnvironmentName.value,
				external: IS_EXTERNAL,
				tokenId: TOKEN_ID,
				tabId: TAB_ID,
				langId: USER_LANGUAGE_SELECION
			},
			onRequest: function() { 
				sp.show(true); 
			},
			onComplete: function(resText, resXml) { 
				if(resText.indexOf("<!DOCTYPE html") < 0) {
					processXMLLoginResponse(resXml);  
				} else {
					window.location = window.location;
				}
			}
		}).send();
	} else {
		var request = new Request({
			method: 'post',
			url: CONTEXT + '/apia.security.LoginAction.run?action=login',
			data: {
				login: $('loginUsr').value,
				pwd: $('loginPassword').value,
				envName: $('loginEnvironmentName').value,
				external: IS_EXTERNAL,
				tokenId: TOKEN_ID,
				tabId: TAB_ID,
				langId: USER_LANGUAGE_SELECION
			},
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) { processXMLLoginResponse(resXml); }
		}).send();
	}
}

function gotoLogin(){
	sp.show(true);
	window.location = CONTEXT + '/apia.security.LoginAction.run?action=init&tokenId=' + TOKEN_ID;
}

function gotoSplash(){
	sp.show(true);
	var form = new Element('form', {
		action: CONTEXT + '/apia.security.LoginAction.run',
		method: 'post'
	});
	new Element('input', {name: 'action', value: 'gotoSplash'}).inject(form);
	new Element('input', {name: 'tokenId', value: TOKEN_ID}).inject(form);
	form.inject(document.body);
	form.submit();
}	
	

function switchForms(e){
	$("loginForm").toggleClass("hidden");
	$("requestForm").toggleClass("hidden");
	
	if(!$("loginForm").hasClass("hidden")){
		$('loginUsr').focus();
	} else {
		$('rememberUser').focus();
	}
};

/*
Procesar el xml de respuesta del login
*/
function processXMLLoginResponse(ajaxCallXml){
	if (ajaxCallXml != null) {
		//obtener el codigo de retorno
		var code = ajaxCallXml.getElementsByTagName("code");
		code = code.item(0);
		TOKEN_ID = code.getAttribute('tokenId');
		
		//si el login fue exitoso, redirigir al splash
		if(LOGIN_OK == code.firstChild.nodeValue){
			if (IS_EXTERNAL=="true"){
				if("open"==EXTERNAL_TYPE){
					if("F"==TYPE){ //entidad
						sp.show(true);
						window.location = CONTEXT + '/apia.execution.EntInstanceListAction.run?action=confirmSelection&busEntId=' + ENT_CODE + "&tabId=" + TAB_ID + "&tokenId=" + TOKEN_ID;
					} else { //proceso
						sp.show(true);
						window.location = CONTEXT + '/apia.execution.TaskAction.run?action=startCreationProcess&busEntId=' + ENT_CODE + "&proId="+ PRO_CODE + "&tabId=" + TAB_ID + "&tokenId=" + TOKEN_ID;
					}					
				}
				if("work"==EXTERNAL_TYPE){
					sp.show(true);
					window.location = CONTEXT + '/page/externalAccess/workTask.jsp?env=' + ENV_ID + '&nomTsk='+NOM_TASK+'&numInst='+NUM_INST+'&txtUser=xxxx&logFromSession=true&logged=true'+ "&tabId=" + TAB_ID + "&tokenId=" + TOKEN_ID;
				}
				if("query"==EXTERNAL_TYPE){
					sp.show(true);
					window.location = CONTEXT + '/apia.query.UserAction.run?action=init&query=' + QRY_ID + "&tabId=" + TAB_ID + "&tokenId=" + TOKEN_ID + filters + "&fromExternal=true";
				}
			} else{
				gotoSplash();
			}
		} else if ( LOGIN_ERROR  == code.firstChild.nodeValue || LOGIN_USER_EXPIRED  == code.firstChild.nodeValue || LOGIN_USER_BLOCKED  == code.firstChild.nodeValue){
			//si el codigo es diferente de 0	
			var messages = ajaxCallXml.getElementsByTagName("messages");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("message");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);	
				}
			}
			sp.hide(true);
		} else if(LOGIN_CHANGE_PWD == code.firstChild.nodeValue){
			$("loginForm").toggleClass("hidden");
			$("passwordForm").toggleClass("hidden");
			$('currentPassword').focus();
			sp.hide(true);
		}
	}
	
}


/*
Procesar el xml de respuesta del remember
*/
function processXMLRememberResponse(ajaxCallXml){
	if (ajaxCallXml != null) {
		//obtener el codigo de retorno
		var code = ajaxCallXml.getElementsByTagName("code");
		//si el login fue exitoso, redirigir al splash
		if(LOGIN_OK == code.item(0).firstChild.nodeValue){
			showMessage(REMEMBER_MAIL_SENDED);	
		} else if ( LOGIN_ERROR  == code.item(0).firstChild.nodeValue){
			//si el codigo es diferente de 0	
			var messages = ajaxCallXml.getElementsByTagName("messages");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("message");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);							
				}
			}
		}
	}
}



/*
Procesar el xml de respuesta del change password
*/
function processXMLChangeResponse(ajaxCallXml){
	if (ajaxCallXml != null) {
		//obtener el codigo de retorno
		var code = ajaxCallXml.getElementsByTagName("code");
		//si el login fue exitoso, redirigir al splash
		if(LOGIN_OK == code.item(0).firstChild.nodeValue){
			gotoSplash();	
		} else if ( LOGIN_ERROR  == code.item(0).firstChild.nodeValue){
			//si el codigo es diferente de 0	
			var messages = ajaxCallXml.getElementsByTagName("messages");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("message");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);							
				}
			}
		}
	}
}


function showMessage(text){
	$("messageContainer").removeClass("hidden");
	$("messageContainer").addClass("warning");
	$("messageContainer").innerHTML="";
	var htmlText = "<label id=\"messageText\">"+ text + "</label>"; 
	new Element('label', {html: htmlText}).inject($('messageContainer'));
}


function checkCapsLock(e) {
	var value = e.target.value;

	if(value.length==0){
		return;
	}
	
	value = value.substr(value.length-1,value.length);
	var code=value.charCodeAt(0);
	
	if (e.key == "enter") { // && $('loginPassword').value != null && $('loginPassword').value != "" && $('loginUsr').value != null && $('loginUsr').value != "") {
		//$("login").click();
		if(Browser.firefox)
			$("login").click();
		else
			$("login").fireEvent("click");
		return true;
	}

	//console.log(shift + " " +code);
	 if ( ( code >= 65 && code <= 90 )  ) {
		tipCapsLockUsu.show();
	}else{
		if(tipCapsLockUsu.isOpen()){
			tipCapsLockUsu.hide();
		}

	}
}


var avoidRegExpLoopback = false;
function fieldRegExp(field) {
	if (avoidRegExpLoopback) return true;

	var regexp = field.getAttribute("regexp");
	if (regexp != null || regexp != "") {
		var regexperror = field.getAttribute("regExpMessage");
		if (regexperror == null || regexperror == "") regexperror = "El valor ingresado no es correcto";
		var value = field.value;

		if (! value.test(regexp)) {
			field.errors.push( regexperror );
			avlock = false;
			//avoidRegExpLoopback = true;
			return false;
		}
	}
	
	avoidRegExpLoopback = false;
	return true;
}