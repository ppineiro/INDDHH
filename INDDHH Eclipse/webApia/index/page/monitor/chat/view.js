function initPage(){
	//crear spinner de espere un momento
	var btnBack = $('btnBack');
	
	if (btnBack) {
		btnBack.addEvent('click', function(e) {
			e.stop();
			hideMessage();
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=goBack' + TAB_ID_REQUEST;
		});
	}
	
	initAdminFav();
}

