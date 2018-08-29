function initPage(){
	
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByDesc','orderByType','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['orderByName','orderByDesc','orderByType','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['nameFilter','descFilter','regUsrFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','descFilter','regUsrFilter','typeFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);	
	
	initAdminActions();	
	initNavButtons();
		
	callNavigate();
	
	//Ejecutar
	$('btnExecute').addEvent("click",function(e){
		e.stop();
		
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			ApiaShellCommand.cleanResultContainer();
			
			var id = getSelectedRows($('tableData'))[0].getRowId();
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=command&isAjax=true&id=' + id + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		}
	});
	
	$('btnView').addEvent("click",function(e){
		e.stop();
		createDownloadIFrame(TIT_DOWNLOAD,DOWNLOADING,URL_REQUEST_AJAX,"download","","","",null);
	});
	
	initResultsMdlPage();
	
}

function setFilter(){
	callNavigateFilter({
		txtName: $('nameFilter').value,
		txtDesc: $('descFilter').value,
		txtRegUsr: $('regUsrFilter').value,
		txtRegDte: $('regDateFilter').value,
		txtType: $('typeFilter').value
	},null);
}

function processCommandToExecute(command){
	SYS_PANELS.closeAll();
	
	var ajaxCallXml = getLastFunctionAjaxCall();
	var result = ajaxCallXml.getElementsByTagName("result"); //tag: result
	var type = result[0].getElementsByTagName("type"); //tag: type
	var command = result[0].getElementsByTagName("command"); //tag: command
	
	var jsError = null;
	if ("client" == type[0].innerHTML){
		try {
			eval(command[0].innerHTML);
		} catch (e){
			jsError = e.message;
		}
	} else if ("server" == type[0].innerHTML){
		ApiaShellCommand.executeCommand(command[0].innerHTML);
	}
	
	showResultsModal(); //muestra modal con resultados
	
	if (jsError){ //muestra error de JS
		showMessage(jsError, GNR_TITILE_EXCEPTIONS, 'modalError');
	}
}


