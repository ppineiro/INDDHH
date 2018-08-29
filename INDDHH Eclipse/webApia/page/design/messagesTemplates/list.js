function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderbyPerm', 'orderByName','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','regUsrFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','descFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('projectFilter').value = '';
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	var btnSend = $('btnSend');
	if (btnSend) {
		btnSend.addEvent ('click', function (e) {
			e.stop;
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			}
			else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			}
			else {
				SYS_PANELS.closeAll();
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=prepareEmailSending&isAjax=true&id=' + id + TAB_ID_REQUEST + '&isInside=false',
					onComplete: function(resText, resXml) { 
						modalProcessXml(resXml); } 
				}).send();
			}
		})
	}	
	
	initAdminActions(false,false,false,false,true,false);
	initNavButtons();
	
	callNavigate();
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
		txtMesTemName: $('nameFilter').value,
		txtMesTemDesc: $('descFilter').value,			
		txtPrjId: $('projectFilter').value,
		txtRegUsr: $('regUsrFilter').value,
		txtRegDte: $('regDateFilter').value
	},null);
}

function showModalIfError () {
	SYS_PANELS.closeAll();
	var code = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("message")[0];
	var msg = code.getAttribute('name');
	if (msg == 'noEmailAdresses') {
		showMessage(GNR_EMPTY_EMAIL_LIST, GNR_TIT_WARNING, 'modalWarning');
	}
}

function reloadMessages(elem) {
	var value = elem.value;
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=reloadPreviewMessage&isAjax=true&value=' + value + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) { 
			modalUpdateXml(resXml); } 
	}).send();
}

function modalUpdateXml(xml) {
	var elements = xml.getElementsByTagName("element");
	if (elements[0].getAttribute('type') == 'hidden') {
		$('msgSubject').textContent = elements[1].getAttribute('value');
		$('msgMessage').innerHTML = Generic.unespapeHTML(elements[2].getAttribute('value'));
		$('idiomaEnvio').selectedIndex = elements[3].getAttribute('value');
		showMessage(GNR_NO_VALUE_AVAILABLE, GNR_TIT_WARNING, 'modalWarning');
	} else {
		$('msgSubject').textContent = elements[0].getAttribute('value');
		$('msgMessage').innerHTML = Generic.unespapeHTML(elements[1].getAttribute('value'));
	}
}
