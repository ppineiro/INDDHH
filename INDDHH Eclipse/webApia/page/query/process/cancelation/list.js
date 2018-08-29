function initPage(){
	initQueryButtons();
	initAdminFav();
	
	var btnCancel = $('btnCancel');
	
	if (btnCancel) {
		btnCancel.addEvent('click', function(evt) {
			var tableData = $('tableData');
			
			if (selectionCount(tableData) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				ADMIN_SPINNER.show(true);
				document.location = CONTEXT + URL_REQUEST_AJAX + "?action=cancel&id=" + id + "&proId=" + PRO_ID + TAB_ID_REQUEST;
				/*
				var busEntinstId = id.split("-")[0];
				var proInstCancelId = id.split("-")[1]; 	
				window.location = "apia.execution.TaskAction.run?action=startCancelProcess&busEntInstId=" + busEntinstId + "&proInstCancelId=" + proInstCancelId + "&proId=" + PRO_ID + TAB_ID_REQUEST;
				*/
			}
		});
	}
	
	var btnCloseTab = $('btnCloseTab');
	if (btnCloseTab) {
		btnCloseTab.addEvent('click', function() {
			if(FROM_MINISITE) {
				SYS_PANELS.showLoading();
				window.parent.location = 'apia.security.LoginAction.run?action=gotoMinisiteQueries' + TAB_ID_REQUEST;
			} else {	
				getTabContainerController(true).removeActiveTab();
			}
		});
	}
	
	initNavButtons();
	customizeRefresh();
	callNavigateRefresh();
}

