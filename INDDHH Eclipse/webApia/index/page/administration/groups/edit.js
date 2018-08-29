function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
		
	if($('addEnvironment')){
		$('addEnvironment').addEvent("click", function(e) {
			e.stop();
			showEnvironmentsModal(processEnvsModalReturn);
		});
	}
	
	var poolImage = $('poolImage');
	if (poolImage) {
		poolImage.addEvent('click', function(evt) {
			showImagesModal(processModalImageConfirm,null);
		});
	}

	$('btnResetImage').addEvent('click', function(evt) {
		var path = CONTEXT + '/images/uploaded/' + POOL_DEFAULT_IMAGE;
		$('poolImage').setStyle('background-image', 'url(' + path + ')');
		$('imgPath').value = POOL_DEFAULT_IMAGE;		
	});
	
	if(isGlobal=="true"){
		loadEnvs();
	}
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition();
	initEnvMdlPage();
	initImgMdlPage();
	initAdminFav();
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function loadEnvs(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getEnvironments' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processXMLEnvs(resXml); sp.hide(true); }
	}).send();
}

function processEnvsModalReturn(ret){
	ret.each(function(e){
		var text = e.getRowContent()[0];
		var id = e.getRowId();
		addEnvironmentToContainer(text,id);
	});
}

function processXMLEnvs(ajaxCallXml){
	if (ajaxCallXml != null) {
		var envs = ajaxCallXml.getElementsByTagName("environments");
		if (envs != null && envs.length > 0 && envs.item(0) != null) {
			envs = envs.item(0).getElementsByTagName("environment");
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				
				var text = env.getAttribute("text");
				var id = env.getAttribute("id");
				
				addEnvironmentToContainer(text,id);
			}
		}
	}
}

function addEnvironmentToContainer(text, id) {
	var element = addActionElement($('envContainter'),text,id,"envId");
	element.removeEvent('click', actionAlementAdminClickRemove);
	element.addEvent('click', function(evt) {
		this.destroy();
		if ($('envContainter').getElements("DIV").length == 3) $('envContainterAll').show();
	});
	$('envContainterAll').hide();
}

function processModalImageConfirm(image) {
	var poolImage = $('poolImage');
	
	$('poolImage').setStyle('background-image', 'url(' + image.path + ')');
	$('imgPath').value = image.id;
}