function initPage(){
	
	initQueryButtons();
	initAdminFav();
	
	var btnTasks = $('btnTasks');
	var btnHistory = $('btnHistory');
	
	if (btnTasks) {
		btnTasks.addEvent('click', function(evt) {
			var tableData = $('tableData');
			
			if (selectionCount(tableData) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				ADMIN_SPINNER.show(true);
				document.location = CONTEXT + URL_REQUEST_AJAX + "?action=viewTasks&id=" + id + TAB_ID_REQUEST;	
			}
		});
	}
	
	if (btnHistory) {
		btnHistory.addEvent('click', function(evt) {
			var tableData = $('tableData');
			
			if (selectionCount(tableData) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				ADMIN_SPINNER.show(true);
				document.location = CONTEXT + URL_REQUEST_AJAX + "?action=viewHistory&id=" + id + TAB_ID_REQUEST;	
			}
		});
	}
	
	var btnDocuments = $('btnDocuments');
	if (btnDocuments){
		btnDocuments.addEvent("click",function(e){
			e.stop();
			//verificar que solo un registro esté seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=getQueryInfoForMonDocument&isAjax=true&id=' + id + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
	}
	
	//['btnSearch','btnExport','btnDetails','btnHistory','btnTasks','btnDocuments'].each(setTooltip);
	
	initNavButtons();
	customizeRefresh();
	callNavigateRefresh();
}

function openMonDocument(envId, procTitle, procRegInst, busEntTitle, busEntRegInst, qryTitle){
	SYS_PANELS.closeAll();
	var tabContainer = window.parent.document.getElementById('tabContainer');
	var url = CONTEXT + URL_REQUEST_AJAX_MON_DOCUMENT + '?action=init&favFncId=54&preFilQuery=true&envId=' + envId + '&procTitle=' + procTitle + '&procRegInst=' + procRegInst + '&busEntTitle=' + busEntTitle + '&busEntRegInst=' + busEntRegInst + '&qryTitle=' + qryTitle + TAB_ID_REQUEST;
	tabContainer.addNewTab(MON_DOC_TAB_TITLE,url,null);		
}
