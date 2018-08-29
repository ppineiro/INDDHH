function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition(verifyPermissions,false,false,false);
	initPermissions();
	
	//Testear conexion
	$('testConn').addEvent('click', function(e){
		e.stop();
		
		var form = $('frmData');
		if(!form.formChecker.isFormValid()){
			return;
		}
		
		var params = getFormParametersToSend(form);
		
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=testConnection&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send(params);
		
	});
	
	['testConn'].each(function(ele){
		ele = $(ele);
		ele.tooltip( ele.getAttribute("title"), { mode: 'auto', width: 100, hook: 0 });
	});
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

//Cargar imput de connection string
function setConnStr(connType){
	if (connType.value == 'M') {
		$('connStr').value = "jdbc:mysql://<server>:<port>/<db name>";
	} else  if (connType.value == 'O') {
		$('connStr').value = "jdbc:oracle:thin:@<server>:<port>:<db name>";
	} else if (connType.value == 'P') {
		$('connStr').value = "jdbc:postgresql://<server>:<port>/<db name>";
	} else if (connType.value == 'S'){
		$('connStr').value = "jdbc:sqlserver://<server>:<port>;DatabaseName=<db name>";
	} else if (connType.value == 'D') {
		$('connStr').value = "jdbc:db2://<server>:<port>/<db name>";
	} else {
		$('connStr').value = "";
	}
}










	
