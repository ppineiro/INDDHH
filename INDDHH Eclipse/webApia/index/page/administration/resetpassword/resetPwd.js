function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//Confirmar
	$('confPass').addEvent('click', function(e){
		e.stop();
		
		var form = $('frmData');
		if(!form.formChecker.isFormValid()){
			return;
		}
		
		var auto = "";
		if (AUTOGENERATE){
			auto = '&autogenerate=true';
		}
		
		var params = getFormParametersToSend(form);
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=confirm&isAjax=true' + TAB_ID_REQUEST + auto,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml);}
		}).send(params);		
	});
	
	//Seleccionar
//	$('btnSelUsr').addEvent("click", function(e) {
//		e.stop();
//		ADDITIONAL_INFO_IN_TABLE_DATA = false;
//		USERMODAL_SELECTONLYONE = true;
//		showUsersModal(processUsersModalReturn);
//	});
	
	
	$('frmData').formChecker = new FormCheck(
			'frmData',
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
	
	if (AUTOGENERATE){
		$('chkEnvEma').checked = "checked";
	}
	

	//['confPass'].each(setTooltip);
	

	$('usrLogin').addEvent('optionSelected', function(evt) {
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=userSelected&isAjax=true' + TAB_ID_REQUEST,
			onComplete: function(resText, resXml) { modalProcessXml(resXml);}
		}).send("usrLogin=" + $('usrLogin').value);
	});
	
	if(SELF){
		$('usrLogin').fireEvent('optionSelected');
		$('usrLogin').setProperty('readOnly',true);
	} else {
		setAutoCompleteGeneric( $('usrLogin'), null, 'search', 'users', 'usr_login', 'usr_login', 'usr_login', false, true, false, true);
		$('usrLogin').addEvent('optionNotSelected', function(evt) {
			$('usrName').innerHTML = "";
			$('usrEmail').innerHTML = "";
		});
	}
 
	initAdminFav();		
}

//Reiniciar campos
function cleanFields(){
	$('usrLogin').value = "";
	$('usrName').innerHTML = "";
	$('usrEmail').innerHTML = "";
	
	if (!AUTOGENERATE){
		$('password').value = "";
		$('passwordConf').value = "";
		$('chkEnvEma').checked = "";
	} else {
		$('chkEnvEma').checked = "checked";
	}
	
	$('chkSolRes').checked = "";
}


function loadUserData(){
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		var messages = ajaxCallXml.getElementsByTagName("messages");
		if (messages != null && messages.length > 0) {
			messages = messages[0].getElementsByTagName("message");
			if (messages != null) {
				for (var i = 0; i < messages.length; i++) {
					var message = messages[i];
					$(message.getAttribute('name')).innerHTML = (message.firstChild != null) ? message.firstChild.nodeValue : ""
				}
			}
		}
	}
}	

function fieldRegExp(el){
	
	var re = new RegExp(PWD_REG_EXP);
	var str = el.value;
 
	if (re.test(str) != true) {
		el.errors.push( LBL_REG_EXP_FAIL );
		return false;
	} else {
		return true;
	}
}