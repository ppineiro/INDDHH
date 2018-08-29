var fullWidth;
var forceConfirm = false;

function initPage(){
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	$('btnResetLang').addEvent("click",function(e){
		var langId = $$('li.translations.active')[0].getAttribute("langId");
		$('subject_'+langId).value = '';
		$('body_'+langId).set('value', '');
		tinyMCE.get('body_'+langId).setContent('');
	});
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition(beforeConfirm);	
	initPermissions();
	initAdminFav();
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
	
	$$('li.translations').each(function (li){
		li.addEvent("click",function(e){
			if (e) e.stop();
			var langId = this.getAttribute("langId");
			$$('li.translations').each(function(l){
				l.removeClass("active");
			});
			this.addClass("active");
			$$('div.lang-trans-content').each(function(divContent){
				divContent.setStyle("display","none");
			});
			$('lang_trans_'+langId).setStyle("display","");
			if (!this.fixed){
				this.fixed = true;
				$('body_'+this.getAttribute("langId")+'_tbl').setStyle("width",fullWidth+"px");
			}
		});
	});
	
	loadTranslations();
}

function onChangeDefLang(cmbDefLang){
	var defLang = cmbDefLang.value;
	
	//sacar el requerido
	$$('div.fieldTranslations').each(function(divField){
		divField.removeClass("required");
	});
	//focus en el lenguage por defecto
	$('lang_'+defLang).fireEvent("click");
	//agregar requerido
	$('field_subject_'+defLang).addClass("required");
	$('field_body_'+defLang).addClass("required");
	
	//ver el tema de validadores
}

function loadTranslations(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadTranslations&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { sp.show(true); modalProcessXml(resXml); sp.hide(true); }
	}).send();
}

function processXMLTranslations(){
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		var translations = ajaxCallXml.getElementsByTagName("translations");
		
		if (translations != null && translations.length > 0 && translations.item(0) != null) {
			var languages = translations.item(0).getElementsByTagName("language");
			
			if (languages != null && languages.length > 0 && languages.item(0) != null) {
				for (var i = 0; i < languages.length; i++){
					var langId = languages[i].getAttribute("id");
					var langName = languages[i].getAttribute("name");
					var subject = languages[i].getAttribute("subject");
					var body = languages[i].getAttribute("body");
					
					var subjectMessage = $('subject_'+langId);
					var bodyMessage = $('body_'+langId);
					
					subjectMessage.value = subject;
					bodyMessage.set('value', body);
					tinyMCE.execCommand("mceAddEditor", false, 'body_'+langId);
				}
				
				
				//acomodar ancho de editor de texto
				var defLang = $('defLang').value;
				fullWidth = $('field_body_'+defLang).getWidth() + 21;
				$('lang_'+defLang).fixed = true;
			}
		}
	}
	
	onChangeDefLang($('defLang'));
}

function beforeConfirm(){
	var ok = true;
	if (!forceConfirm){
		ok = hasValuesLang();
	}
	forceConfirm = false;
	if (ok) {
		ok = checkDefLangValues();
	}
	return ok;
}

function hasValuesLang(){
	var langs = $('defLang').options;
	for (var i = 0; i < langs.length; i++){
		var langId = langs[i].value;
		if ($('subject_'+langId).value == '' || $('body_'+langId).value == ''){
			showConfirm(MSG_NO_ALL_VAL,GNR_TIT_WARNING,function(ret) {  
						if (ret) {
							forceConfirm = true;
							setTimeout(function() {
								btnConf.fireEvent('click', new Event({
									type: 'click'
								}));
							}, 100);
							
						} else {
							forceConfirm = false;
						} 
					}, 
				"modalWarning"
			);			
			return false;
		}
	}
	return true;
}

function checkDefLangValues(){
	var defLang = $('defLang').value;
	if ($('subject_'+defLang).value == '' || $('body_'+defLang).value == ''){
		$('lang_'+defLang).fireEvent("click");
		showMessage(MSG_DEF_REQ, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
	return true;	
}