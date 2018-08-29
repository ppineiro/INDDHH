var editor;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	var btnConf = $('btnConf');
	if (btnConf) {
		btnConf.addEvent("click", function(e) {
			$('hptHtml').set('value', editor.getValue());
		});
	}
	
	$('btnPreview').addEvent('click',function(e){
		e.stop();
		$('hptHtml').set('value', editor.getValue());
		var html = $('hptHtml').value;
		if (html == ""){
			showMessage(MSG_ADD_HTML, GNR_TIT_WARNING, 'modalWarning');
		} else {
			showHomeTemplateModal(null,null,html);
		}		
	});
	//['btnPreview'].each(setTooltip);
		
	initAdminActionsEdition(null,false,false,false);
	initAdminFav();
	initHomeTemplateMdlPage(true);
	
	/****EDITOR PARA HTML******/
	CodeMirror.commands.autocomplete = function(cm) {
		CodeMirror.showHint(cm, CodeMirror.hint.html);
    }
	 
	editor = CodeMirror.fromTextArea(document.getElementById("hptHtml"), {
		lineNumbers: true,
		matchBrackets: true,
		mode: "text/html",
		extraKeys: {"Ctrl-Space": "autocomplete"/*"Ctrl-Q": "toggleComment", "Ctrl-Space": "autocomplete"*/},
		theme: "eclipse"
	});
	
	initAdminFieldOnChangeHighlight(false, false, true);
	addElementsOnChangeHighlight($$('#hptDesc'));
	initAdminEditorOnChangeHighlight(editor);
	
}

