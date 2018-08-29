var sp;
var browser			= navigator.userAgent;
var browserRegex	= /(Android|BlackBerry|IEMobile|Nokia|iP(ad|hone|od)|Opera M(obi|ini))/;
var isMobile		= false;

if(browser.match(browserRegex)) {
	isMobile			= true;
	addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false);
	function hideURLbar(){
		window.scrollTo(0,1);
	}
}

window.addEvent('load', function() {
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	/*
	var formChecker = new FormCheck(
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
	*/
	
	var loginUsr = $('loginUsr');
	loginUsr.addEvent('keypress', function() {this.erase('class')});
	var loginPassword = $('loginPassword');
	loginPassword.addEvent('keypress', function() {this.erase('class')});
	
	setTimeout(function() {
		console.log(loginUsr.get('value'));
	}, 100);
	
	
	//load cookies
	
	var cookieUsr = Cookie.read('ApiaMinisiteUsr');
	var cookiePwd = Cookie.read('ApiaMinisitePwd');
	var cookieEnv = Cookie.read('ApiaMinisiteEnv');
	var cookieRem = Cookie.read('ApiaMinisiteRem');
	
	if(cookieUsr!=null){
		$('loginUsr').value = cookieUsr;
	}
	if(cookiePwd!=null){
		$('loginPassword').value = cookiePwd;
	}
	if(cookieEnv!=null){
		$('loginEnvironment').value = cookieEnv;
	}
	if(cookieRem!=null){
		$('chkRemember').checked = cookieRem;
	} else {
		$('chkRemember').checked = true;
	}
	
	$('btnLogin').addEvent('click', function(e) {
		e.stop();
//		if(!formChecker.isFormValid()){
//			return;
//		}
		var valid = true;
		if(loginUsr.get('value') == "") {
			loginUsr.addClass("required-failed");
			valid = false;
		}
		if(loginPassword.get('value') == "") {
			loginPassword.addClass("required-failed");
			valid = false;
		}
		
		if(!valid) {
			showMessage(LBL_REQ);
			return;
		}
		
		if($('chkRemember').checked){
			saveCookie($('loginUsr').value,$('loginPassword').value,$('loginEnvironment').value,$('chkRemember').checked);
		} else {
			deleteCookies();
		}
		
		var request = new Request({
			method: 'post',
			url: CONTEXT + '/apia.security.LoginAction.run?action=login',
			data: {
				login: $('loginUsr').value,
				pwd: $('loginPassword').value,
				envId: $('loginEnvironment').value,
				tokenId: TOKENID,
				langId: langId,
				fromMinisite: true
			},
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) { processXMLLoginResponse(resXml);  }
		}).send();
	});
});

function saveCookie(usr,pwd,env,rem){
	Cookie.write('ApiaMinisiteUsr', usr, {duration: 300});
	Cookie.write('ApiaMinisitePwd', pwd, {duration: 300});
	Cookie.write('ApiaMinisiteEnv', env, {duration: 300});
	Cookie.write('ApiaMinisiteRem', rem, {duration: 300});
}

function deleteCookies(){
	Cookie.dispose('ApiaMinisiteUsr');
	Cookie.dispose('ApiaMinisitePwd');
	Cookie.dispose('ApiaMinisiteEnv');
	Cookie.dispose('ApiaMinisiteRem');
}

function processXMLLoginResponse(ajaxCallXml){
	if (ajaxCallXml != null) {
		//obtener el codigo de retorno
		var code = ajaxCallXml.getElementsByTagName("code");
		//si el login fue exitoso, redirigir al splash
		if(LOGIN_OK == code.item(0).firstChild.nodeValue){
			sp.show(true);
			TOKENID = code.item(0).getAttribute("tokenId");
			window.location = CONTEXT + '/apia.security.LoginAction.run?action=gotoMinisite&tokenId=' + TOKENID;
		} else if ( LOGIN_ERROR  == code.item(0).firstChild.nodeValue || LOGIN_USER_EXPIRED  == code.item(0).firstChild.nodeValue || LOGIN_USER_BLOCKED  == code.item(0).firstChild.nodeValue){
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
		} else if(LOGIN_CHANGE_PWD == code.item(0).firstChild.nodeValue){
			alert("cambio de pass hacerlo por sitio  full");
			sp.hide(true);
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



/*
window.addEvent('load',function(){
	(function($) {

		this.IPhoneCheckboxes = new Class({

			//implements
			Implements: [Options],

			//options
			options: {
				checkedLabel: LBL_YES,
				uncheckedLabel: LBL_NO,
				background: '#fff',
				containerClass: 'iPhoneCheckContainer',
				labelOnClass: 'iPhoneCheckLabelOn',
				labelOffClass: 'iPhoneCheckLabelOff',
				handleClass: 'iPhoneCheckHandle',
				handleBGClass: 'iPhoneCheckHandleBG',
				handleSliderClass: 'iPhoneCheckHandleSlider',
				elements: 'input[type=checkbox]'
			},

			//initialization
			initialize: function(options) {
				//set options
				this.setOptions(options);
				//elements
				this.elements = $$(this.options.elements);
				//observe checkboxes
				this.elements.each(function(el) {
					this.observe(el);
				},this);
			},

			//a method that does whatever you want
			observe: function(el) {
				//turn off opacity
				el.set('opacity',0);
				//create wrapper div
				var wrap = new Element('div',{
					'class': this.options.containerClass
				}).inject(el.getParent());
				//inject this checkbox into it
				el.inject(wrap);
				//now create subsquent divs and labels
				var handle = new Element('div',{'class':this.options.handleClass}).inject(wrap);
				var handlebg = new Element('div',{'class':this.options.handleBGClass,'style':this.options.background}).inject(handle);
				var handleSlider = new Element('div',{'class':this.options.handleSliderClass}).inject(handle);
				var offLabel = new Element('label',{'class':this.options.labelOffClass,text:this.options.uncheckedLabel}).inject(wrap);
				var onLabel = new Element('label',{'class':this.options.labelOnClass,text:this.options.checkedLabel}).inject(wrap);
				var rightSide = wrap.getSize().x - 39;
				//fx instances
				el.offFx = new Fx.Tween(offLabel,{'property':'opacity','duration':200});
				el.onFx = new Fx.Tween(onLabel,{'property':'opacity','duration':200});
				//mouseup / event listening
				wrap.addEvent('mouseup',function() {
					var is_onstate = !el.checked; //originally 0
					var new_left = (is_onstate ? rightSide : 0);
					var bg_left = (is_onstate ? 34 : 0);
					handlebg.hide();
					new Fx.Tween(handle,{
						duration: 100,
						'property': 'left',
						onComplete: function() {
							handlebg.setStyle('left',bg_left).show();
						}
					}).start(new_left);
					//label animations
					if(is_onstate) {
						el.offFx.start(0);
						el.onFx.start(1);
					}
					else {
						el.offFx.start(1);
						el.onFx.start(0);
					}
					//set checked
					el.set('checked',is_onstate);
				});
				//initial load
				
				if(el.checked){
					offLabel.set('opacity',0);
					onLabel.set('opacity',1);
					handle.setStyle('left',rightSide);
					handlebg.setStyle('left',34);
				} else {
					onLabel.set('opacity',0);
					handlebg.setStyle('left',0);
				}
				
				onLabel.setStyle('visibility', '');
				offLabel.setStyle('visibility', '');
			}
		});

	})(document.id);

	// usage
	var chx = new IPhoneCheckboxes();
});
*/