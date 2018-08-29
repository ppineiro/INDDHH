var editor;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	initAdminActionsEdition(executeBeforeConfirm);
	initAdminFav();
	
	/****EDITOR PARA HTML******/
	editor = CodeMirror.fromTextArea(document.getElementById("shellCommCommand"), {
		lineNumbers: true,
		matchBrackets: true,
		extraKeys: {"Ctrl-Q": "toggleComment"},
		theme: "eclipse"
	}); 
	
	initAdminFieldOnChangeHighlight(false, false, true);
	addElementsOnChangeHighlight($$('#shellCommDesc'));
	initAdminEditorOnChangeHighlight(editor);
	
	getURL(ECMA_URL, function(err, code) {
		if (err) throw new Error("Request for " + ECMA_FILE_NAME + ": " + err);
		server = new CodeMirror.TernServer({defs: [JSON.parse(code)]});
		editor.setOption("extraKeys", {
			"Ctrl-Space": function(cm) { server.complete(cm); },
			"Ctrl-I": function(cm) { server.showType(cm); },
			"Alt-.": function(cm) { server.jumpToDef(cm); },
			"Alt-,": function(cm) { server.jumpBack(cm); },
			"Ctrl-Enter": function(cm) { $('btnExecute').fireEvent('click'); }
		})
		editor.on("cursorActivity", function(cm) { server.updateArgHints(cm); });
	});
	
	//Ejecutar
	$('btnExecute').addEvent("click",function(e){
		if (e) e.stop();
		
		var command = editor.getValue();
		if (command == '' || command == null){
			showMessage(MSG_EMPTY_COMMAND, GNR_TIT_WARNING, 'modalWarning');
		} else {
			ApiaShellCommand.cleanResultContainer();
			
			var jsError = null;
			var commandType = $('shellCommType').value; 
			var clientNoError = true;
			if (commandType == '0'){ //0 - Cliente
				try {
					eval(command);
				} catch (e){
					clientNoError = false;
					jsError = e.message;
				}
			} else { //1 - Servidor
				ApiaShellCommand.executeCommand(command);
			}

			if (clientNoError)
				showResultsModal(); //muestra modal con resultados
			
			if (jsError){ //muestra error de JS
				showMessage(jsError, GNR_TITILE_EXCEPTIONS, 'modalError');
			}
		}
	});
	
	//Cargar ayuda
	loadHelpTab();
	
	initPermissions(true /*hide Project permissions */);
	initResultsMdlPage();
	
	if (document.getElementsByClassName("CodeMirror")) {
		document.getElementsByClassName("CodeMirror")[0].style.width = '980px';
		document.getElementsByClassName("CodeMirror-hscrollbar")[0].style.left = '29px';
		document.getElementsByClassName("CodeMirror-hscrollbar")[0].style.display = 'block';
		document.getElementsByClassName("CodeMirror-hscrollbar")[0].style.right = '0px';
	}
		
	
}

function executeBeforeConfirm(){
	if(!verifyPermissions()){
		return false;
	}
	
	//Se carga el valor del editor en el comando
	$('shellCommCommand').set('value', editor.getValue());
	
	return true;
}

function getURL(url, c) {
	var xhr = new XMLHttpRequest();
	xhr.open("get", url, true);
	xhr.send();
	xhr.onreadystatechange = function() {
		if (xhr.readyState != 4) return;
		if (xhr.status < 400) return c(null, xhr.responseText);
		var e = new Error(xhr.responseText || "No response");
		e.status = xhr.status;
		c(e);
	};
}	

function loadHelpTab(){
	ApiaShellCommand.cleanResultContainer();
	ApiaShellCommand.executeCommandHelp();
	
	var lineBreakHelp = '<br>';
	
	var help = '';
	var content = ApiaShellCommand.getResultContainer();
	if (content && content.length > 0){
		for (var i = 0; i < content.length; i++){
			var resComm = content[i];
			
			//Resultado del comando ejecutado
			if (resComm.result && resComm.result.length > 0){
				for (var j = 0; j < resComm.result.length; j++){
					help += resComm.result[j];
					help += lineBreakHelp;
				}
			}
			help += lineBreakHelp;
			
			if (i+1 < content.length){
				help += lineBreakHelp;
				help += lineBreakHelp;
			}
		}
	}
	
	$('shellCommHelp').innerHTML = help;
	
}


