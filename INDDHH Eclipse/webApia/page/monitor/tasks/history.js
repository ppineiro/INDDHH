function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	 
	var btnBackToList = $('btnBackToList');
	if (btnBackToList){
		btnBackToList.addEvent("click", function(e) {
			e.stop();
			sp.show(true);
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=back' + TAB_ID_REQUEST+"&reset=true";			
		});
	}	
	
	var btnExport = $('btnExport');
	if (btnExport){
		btnExport.addEvent("click", function(e) {
		e.stop();
		hideMessage();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=prepareModalDownloadHistory&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send(); 
		});
	}
	
	var btnTasks = $('btnDetails');
	if (btnTasks){
		btnTasks.addEvent("click", function(e) {
			e.stop();
			//verificar que solo un registro esté seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				SYS_PANELS.showLoading();
				var aux = getSelectedRows($('tableData'))[0].getRowId();
				var id = aux.split(PRIMARY_SEPARATOR)[0];				
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=detailsHistory&id=' + id + TAB_ID_REQUEST;
			}
			
		});
	}
	
	initNavButtons();
	initAdminFav();
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadTableHistory&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send(); 
}

var backId = 0;

function loadHistory(){
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		var messages = ajaxCallXml.getElementsByTagName("messages");
		ajaxCallXml = null;
		if (messages != null && messages.length > 0) {
			ajaxCallXml = messages[0].getElementsByTagName("result")[0];
		}
		loadTable($('tableData'),ajaxCallXml,true);
	}		
};

function download(){
	
	var pdf = $('pdf'); 
	var excel = $('excel'); 
	var format = "csv";

	if (pdf.checked){
		format="pdf";
	}else if (excel.checked){
		format = "excel";
	}	
	
	hideMessage();
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"downloadHistory","&format="+format+"&idProcess="+backId,"","",null);
}

function processXMLResponseReload(ajaxCallXml){
	if (ajaxCallXml != null) {
		//recargar la pagina--- no se llama a la funcion navigate para que no borre los mensajes
		var currPage = parseInt($('navBarCurrentPage').value);
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX+'?action=page&isAjax=true&pageNumber='+currPage + TAB_ID_REQUEST,
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) { processXMLListResponse(resXml); sp.hide(true); }
		}).send();
		
		//obtener el codigo de retorno
		var code = ajaxCallXml.getElementsByTagName("code");
		if("0" == code.item(0).firstChild.nodeValue){
			
			
		} else {
			//si el codigo es diferente de 0	
			var messages = ajaxCallXml.getElementsByTagName("messages");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("message");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);	
				}
			}
			
			messages = ajaxCallXml.getElementsByTagName("exceptions");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("exception");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);	
				}
			}
		}
	}
}