var editor;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//testear ejecutable
	var btnTest = $('btnTest');
	if (btnTest){
		btnTest.addEvent("click",function(e){
			e.stop();
			
			var pnlExecutable = $('pnlExecutable');
			var pnlType = $('pnlType');
			
			if (!setParameters()) { return; }
				
			//se deben completar los campos requeridos
			var form = $('frmData');
			if(!form.formChecker.isFormValid()){
				return;
			}
			var params = getFormParametersToSend(form);
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=test&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send(params);				
		});
	}
	//['btnTest'].each(setTooltip);
	
	
	initAdminActionsEdition(executeBeforeConfirm);
	var btnConf = $('btnConf');
	if (btnConf) {
		btnConf.removeEvents('click');		
		btnConf.addEvent("click", function(e) { beforeConfirm(e); });
	}

	
	initAdminFav();
	initTabParameters();
	
	cmbPnlTypeOnChange($('pnlType'));
	
	initAdminFieldOnChangeHighlight(false, false);
	
	/****EDITOR PARA HTML******/
	CodeMirror.commands.autocomplete = function(cm) {
		CodeMirror.showHint(cm, CodeMirror.hint.html);
    }
	 
	editor = CodeMirror.fromTextArea(document.getElementById("pnlCode"), {
		lineNumbers: true,
		matchBrackets: true,
		mode: "text/html",
		extraKeys: {"Ctrl-Space": "autocomplete"/*"Ctrl-Q": "toggleComment", "Ctrl-Space": "autocomplete"*/},
		theme: "eclipse"
	}); 
	
	initAdminEditorOnChangeHighlight(editor);
	
	initPermissions(true /*hide Project permissions */);
}

function cmbPnlTypeOnChange(cmbPnlType){
	var value = cmbPnlType.value;
	
	var divPnlExecutable = $('divPnlExecutable');
	var pnlExecutable = $('pnlExecutable');
	
	var divPnlCode = $('divPnlCode');
	var pnlCode = $('pnlCode');
	
	if (value == TYPE_HTML){
		//ocultar ejecutable
		divPnlExecutable.style.visibility = "hidden";
		$('frmData').formChecker.dispose(pnlExecutable);
		
		//ocultar testear
		$('panelOptions').style.visibility = "hidden";
		$('btnTest').style.visibility = "hidden";
		
		//mostrar codigo
		if (!pnlCode.hasClass("validate['required','target:divPnlCode']")){
			pnlCode.addClass("validate['required','target:divPnlCode']");
		}
		$('frmData').formChecker.register(pnlCode);
		divPnlCode.style.visibility = "";
		
		showTabParameters(false);
	} else {
		//mostrar ejecutable
		if (!pnlExecutable.hasClass("validate['required']")){
			pnlExecutable.addClass("validate['required']");
		}
		$('frmData').formChecker.register(pnlExecutable);
		divPnlExecutable.style.visibility = "";
		
		//mostrar testear
		$('panelOptions').style.visibility = '';
		$('btnTest').style.visibility = '';
				
		//ocultar codigo
		divPnlCode.style.visibility = "hidden";
		$('frmData').formChecker.dispose(pnlCode);
		
		showTabParameters(true);
	}	
}

function processXmlPanelTest(){
	SYS_PANELS.closeAll();
	
	var width = Number.from(frameElement.getParent("body").clientWidth);
	var height = Number.from(frameElement.getParent("body").clientHeight);
	width = (width*50)/100; //50%
	height = (height*50)/100; //50%
	
	var modal = ModalController.openWinModal(CONTEXT + '/page/design/panels/resultTestPanel.jsp?' + TAB_ID_REQUEST, width, height, undefined, undefined, true, true, false);													
}

function beforeConfirm(e){
	if (e) e.stop();
	
	//En caso de ser usado por algún dashboard, se notifica
	var request = new Request({
		method: 'get',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=checkDashboardsDeps&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); processCheckConfirm(resXml); }
	}).send();
}

function processCheckConfirm(resXml){
	var infoUpdate = resXml.getElementsByTagName("infoUpdate")
	if (infoUpdate != null && infoUpdate.length > 0 && infoUpdate.item(0) != null) {
		infoUpdate = infoUpdate.item(0).getElementsByTagName("result")[0];
		
		var totalDeps = 0; 
		try {
			var totalDeps = parseInt(infoUpdate.getAttribute("totalRecords"));				
		} catch (err) {}
		
		if (totalDeps>0){
			var message = infoUpdate.getAttribute("message");
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = message;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); executeConfirm();\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel);
			SYS_PANELS.refresh();
		} else {
			executeConfirm();
		}				
	}
}

function executeConfirm(){
	if (!setParameters()) { return; }
	
	$('pnlCode').set('value', editor.getValue());
	
	var form = $('frmData');
	if(!form.formChecker.isFormValid()){
		return;
	}
	
	var params = getFormParametersToSend(form);
	//params += "&ctrlKeyPressedOnConfirm=" + e.control;
		
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=confirm&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send(params);	
}

function executeBeforeConfirm(){
	if(!verifyPermissions()){
		return false;
	}
	return true;
}