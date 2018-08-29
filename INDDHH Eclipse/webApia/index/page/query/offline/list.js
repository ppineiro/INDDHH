var canDownload = false;
var canView = false;

function initPage(){
	//crear spinner de espere un momento
	ADMIN_SPINNER = new Spinner($('gridBody'),{message:WAIT_A_SECOND});

	var optionView = $('optionView');
	if (optionView){
		optionView.addEvent('click', function(evt){
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var trSelected = getSelectedRows($('tableData'))[0]; 
				if (trSelected.canView){
					var id = trSelected.getRowId();
					window.location = CONTEXT + URL_REQUEST_AJAX + '?action=openResult&id=' + id + TAB_ID_REQUEST;
				} else {
					showMessage(MSG_NO_VIEW, GNR_TIT_WARNING, 'modalWarning');
					return;
				}				
			}
		});
	}
	
	var optionDownload = $('optionDownload');
	if (optionDownload){
		optionDownload.addEvent('click', function(evt){
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var trSelected = getSelectedRows($('tableData'))[0];
				if (trSelected.canDownload){
					var id = trSelected.getRowId();
					window.location = CONTEXT + URL_REQUEST_AJAX + '?action=downloadResult&id=' + id + TAB_ID_REQUEST;
				} else {
					showMessage(MSG_NO_DOWNLOAD, GNR_TIT_WARNING, 'modalWarning');
					return;
				}				
			}
		});
	}
	
	$('navRefresh').addEvent('click', function(evt){
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=getList&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { ADMIN_SPINNER.show(true); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); ADMIN_SPINNER.hide(true); }
		}).send();
	});
	
	$('navRefresh').fireEvent('click');
	
	initPinGridOptions();
}

function callNavigateProcessXmlListResponse(){
	canDownload = false;
	canView = false;
	var ajaxCallXml = getLastFunctionAjaxCall();	
	if (ajaxCallXml != null) {
		var messages = ajaxCallXml.getElementsByTagName("messages");
		
		ajaxCallXml = null;
		
		if (messages != null && messages.length > 0) {
			ajaxCallXml = messages[0].getElementsByTagName("result")[0];
		}	
		
		loadTable($('tableData'),ajaxCallXml,true, personalizeTr);		
		
		updateButtons();				
	}
}

function personalizeTr(tr) {
	tr.canDownload = tr.hasClass('canDownload');
	tr.canView = tr.hasClass('canView');
	
	canDownload = canDownload || tr.canDownload;
	canView = canView || tr.canView;
	
	//Cuando la lista contiene registros en distintos formatos, puede ser necesario
	//cambiar visibilidad de botones
	tr.addEvent('click', function (){
			canDownload = tr.canDownload;
			canView = tr.canView;
			updateButtons(); 
		}
	);
}

function updateButtons(){
	if (canDownload && canView){
		$('optionDownload').setStyle("display","");
		$('optionDownload').getElement("button").addClass("suggestedAction");
		$('optionView').setStyle("display","");
		$('optionView').getElement("button").removeClass("suggestedAction");
	} else if (canDownload){
		$('optionDownload').setStyle("display","");
		$('optionDownload').getElement("button").addClass("suggestedAction");
		$('optionView').setStyle("display","none");
		$('optionView').getElement("button").removeClass("suggestedAction");
	} else if (canView){
		$('optionDownload').setStyle("display","none");
		$('optionDownload').getElement("button").removeClass("suggestedAction");
		$('optionView').setStyle("display","");
		$('optionView').getElement("button").addClass("suggestedAction");
	} else {
		$('optionDownload').setStyle("display","none");
		$('optionDownload').getElement("button").removeClass("suggestedAction");
		$('optionView').setStyle("display","none");
		$('optionView').getElement("button").removeClass("suggestedAction");
	}			
}
