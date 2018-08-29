function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	var btnBackToList = $('btnBackToList');
	if (btnBackToList){
		btnBackToList.addEvent("click", function(e) {
			e.stop();
			if (toBoolean(fromEntity)){
				var tabContainer = window.parent.document.getElementById('tabContainer');
				tabContainer.removeTab(tabContainer.activeTab);
			}else{
				sp.show(true);
				//CAM_11589
				//window.location = CONTEXT + URL_REQUEST_AJAX + '?action=back' + TAB_ID_REQUEST + "&back=true";
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=back' + TAB_ID_REQUEST + "&back=true&fromTask=true";								
			}
		});
	}
	
	var btnTasks = $('btnTasks');
	if (btnTasks){
		btnTasks.addEvent("click", function(e) {
			e.stop();
			//verificar que solo un registro est� seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				//obtener el registro seleccionado
				var selected = getSelectedRows($('tableData'))[0];
				if (selected.hasClass("isSubProcess")){
					SYS_PANELS.showLoading();
					var id = selected.getRowId();				
					window.location = CONTEXT + URL_REQUEST_AJAX + '?action=task&sub=true&id=' + id + TAB_ID_REQUEST+"&show="+$('showCombo').value;
				}else{
					showMessage(NOT_SUBPROCESS, GNR_TIT_WARNING, 'modalWarning');
				}
			}
		});
	}
	
	var btnReloadTasks = $('btnReloadTasks');
	if (btnReloadTasks){
		btnReloadTasks.addEvent("click", function(e) {
			loadShow();
		});		
	}
	
	var btnBack = $('btnBack');
	if (btnBack){		
		btnBack.addEvent("click", function(e) {
			e.stop();
			sp.show(true);
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=task&sub=true&back=true&id=' + backId + TAB_ID_REQUEST+"&show="+$('showCombo').value;			
		});
	}
	
	var btnExport = $('btnExport');
	if (btnExport){
		btnExport.addEvent("click", function(e) {
		e.stop();
		hideMessage();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=prepareModalDownloadTask&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send(); 
		});
	}
	
	var btnDetails = $('btnDetails');
	if (btnDetails){
		btnDetails.addEvent("click", function(e) {
			e.stop();
			//verificar que solo un registro est� seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				//obtener el registro seleccionado				
				
				SYS_PANELS.showLoading();
				var id = getSelectedRows($('tableData'))[0].getRowId();
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=taskDetails&id=' + id + TAB_ID_REQUEST;
			}
			
		});
	}
	
	var btnOrganize = $('btnOrganize');
	if (btnOrganize){
		btnOrganize.addEvent("click", function(e) {
			e.stop();
			SYS_PANELS.showLoading();
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=organize&sub=true&back=true&id=' + backId + TAB_ID_REQUEST+"&show="+$('showCombo').value+"&visMonOrder=true";			
		});
	}
	
	var btnReOrganize = $('btnReOrganize');
	if (btnReOrganize){
		btnReOrganize.addEvent("click", function(e) {
			e.stop();
			SYS_PANELS.showLoading();
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=organize&sub=true&back=true&id=' + backId + TAB_ID_REQUEST+"&show="+$('showCombo').value+"&visMonShuffle=true";			
		});
	}
	
	/*
	$$("div.button").each(function(ele){
		setAdmEvents(ele);
	});
	*/
	initNavButtons();
	
	loadShow();
	
	initPinGridOptions();
	
	 if (typeof VUSUAL_ELEMENTS !== 'undefined')
		 initVisualElements();
}

function loadShow(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadTable&isAjax=true' + TAB_ID_REQUEST+"&proMaxDur="+PRO_MAX_DUR,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();	
}


var backId = 0;
function loadTableState(aux,id){
	setBack(aux,id);
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		var messages = ajaxCallXml.getElementsByTagName("messages");
		ajaxCallXml = null;
		if (messages != null && messages.length > 0) {
			ajaxCallXml = messages[0].getElementsByTagName("result")[0];
		}
		loadTable($('tableData'),ajaxCallXml); 
	}		
};

function setBack(aux,id){
	if (!aux){
		$('btnBack').style.visibility='hidden';
	}
	backId = id;
}

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
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"downloadTask","&format="+format+"&idProcess="+backId,"","",null);
}
var cmpWidth = screen.availWidth-600;

function setShow(value){
	window.location = CONTEXT + URL_REQUEST_AJAX + '?action=task&sub='+($('btnBack').style.visibility=='hidden'?false:true)+'&id=' + backId + TAB_ID_REQUEST+"&show="+value+"&add=false&width="+cmpWidth+"&fromEntity="+toBoolean(fromEntity)+"&timeline-use-local-resources";
}

function visual(){
	//$('flashTable').style.width=cmpWidth+"px";	
//	$('flashTable').style.width="100%";
	$('jsonTable').style.width = "100%";
}

function timeline(time,intervalUnit1,intervalUnit2){
	$('timeLineDiv').style.width=cmpWidth+"px";	
	onLoad(time,intervalUnit1,intervalUnit2);
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