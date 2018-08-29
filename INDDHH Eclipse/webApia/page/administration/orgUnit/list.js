function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	

	['orderByName','orderByPool','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByName','orderByPool','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','poolFilter','regUsrFilter','regDateFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','poolFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	initAdminActions(false,false,true,false,true);
	initNavButtons();
	
	callNavigate();
	
	$('optionUpload').addEvent('click', function(e) {
		e.stop();
		
		new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=ajaxUploadStart&isAjax=true&' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	});
	
	$('optionDownload').addEvent('click', function(e) {
		e.stop();
		$('downloadIframe').set('src', CONTEXT + URL_REQUEST_AJAX + '?action=downloadUnits' + TAB_ID_REQUEST);
		Generic.showWaitingForDownload();
	});
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtName: $('nameFilter').value,
			txtPool: $('poolFilter').value,
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value
		},null);
}