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
	
	var btnConf = $('btnConf');
	if (btnConf) {
		btnConf.addEvent("click", function(e) {
			$('pnlCode').set('value', editor.getValue());
		});
	}
	
	
	initAdminActionsEdition(setParameters);
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


