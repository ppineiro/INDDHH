var editor;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	initAdminFav();
	
	/****EDITOR PARA HTML******/
	editor = CodeMirror.fromTextArea(document.getElementById("shellCommCommand"), {
		lineNumbers: true,
		matchBrackets: true,
		extraKeys: {"Ctrl-Q": "toggleComment"},
		theme: "eclipse"
	}); 
	editor.setSize('100%', 100);
	
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
		
		sp.show(true);
		
		var command = editor.getValue();
		if (command == '' || command == null){
			showMessage(MSG_EMPTY_COMMAND, GNR_TIT_WARNING, 'modalWarning');
		} else {
			ApiaShellCommand.cleanResultContainer();
			
			var jsError = null;
			try {
				//Siempre es en modo cliente
				eval(command);
			} catch (e){
				jsError = e.message;
			}

			//Muestra resultados
			var lineBreak = '<br>';
			var buffer = '';
			var content = ApiaShellCommand.getResultContainer();
			if (content && content.length > 0){
				for (var i = 0; i < content.length; i++){
					var resComm = content[i];
					
					//Comando ejecutado
					buffer += '<b>' + resComm.command + '</b>'
					buffer += lineBreak;
					buffer += lineBreak;
					
					//Resultado del comando ejecutado
					if (resComm.result && resComm.result.length > 0){
						for (var j = 0; j < resComm.result.length; j++){
							buffer += resComm.result[j];
							buffer += lineBreak;
						}
					}
					buffer += lineBreak;
					
					if (i+1 < content.length){
						buffer += lineBreak;
						buffer += lineBreak;
					}
				}
			}
			
			var resultContainer = $('shellCommCommandResults');
			resultContainer.innerHTML += buffer;
			resultContainer.scrollTop = resultContainer.scrollHeight;
			
			if (jsError){ //muestra error de JS
				showMessage(jsError, GNR_TITILE_EXCEPTIONS, 'modalError');
			}
			
			editor.setValue('');
		}
		
		sp.hide(true);
	});
	
	//Borrar
	$('btnCleanResults').addEvent("click",function(e){
		e.stop();
		$('shellCommCommandResults').innerHTML = '';
	});
	
	//Cerrar
	$('btnCloseTab').addEvent("click", function(e) {
		btnCloseTab.addEvent('click', getTabContainerController().removeActiveTab());
	});
	
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

