function initPage(){
	initQueryButtons();
	initAdminFav();
	
	var btnAlter = $('btnAlter');
	
	if (btnAlter) {
		btnAlter.addEvent('click', function(evt) {
			var tableData = $('tableData');
			
			if (selectionCount(tableData) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				ADMIN_SPINNER.show(true);
				document.location = CONTEXT + URL_REQUEST_AJAX + "?action=alter&id=" + id + "&proId=" + PRO_ID + TAB_ID_REQUEST;	
			}
		});
	}
	
	initNavButtons();
	customizeRefresh();
	callNavigateRefresh();
}

