function initPage(){
	
	initQueryButtons();

	var btnActions = $('btnActions');
	var btnGoBack = $('btnGoBack');
	
	if (btnActions) {
		btnActions.addEvent('click', function(evt){
			var tableData = $('tableData');
			
			if (selectionCount(tableData) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + "?action=viewActions" + TAB_ID_REQUEST,
					onRequest: function() { /* ADMIN_SPINNER.show(true); */ },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send('id=' + id);

			}
			
		});
	}
	
	if (btnGoBack) {
		btnGoBack.addEvent('click', function(evt){
			SYS_PANELS.showLoading();
			document.location = CONTEXT + URL_REQUEST_AJAX + "?action=returnAction"  + TAB_ID_REQUEST;
		});
	}
	
	$('modalAccessFilters').addEvent('click', function(ele) {
		$('optionsContainer').toggleClass('open');
	});
	
	initNavButtons();
	customizeRefresh();

	//Se agrega evento doble-click usado en modal de consultas
	var tableData = $('tableData');
	if (tableData){
		tableData.getParent().addEvent("dblclick", function(e){
			$(window.frameElement).fireEvent('confirmModal');
		});
	}
	
	callNavigateRefresh();
	
	if(OPEN_FILTER_ON_LOAD && !EXECUTED_FILTER) {
		$('optionsContainer').addClass('open');
	}
}

function getModalReturnValue() {
	var tableData = $('tableData');
	
	if (selectionCount(tableData) > 1) {
		showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		return null;
	} else if (selectionCount($('tableData')) == 0) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		return null;
	} else {
		var id = getSelectedRows($('tableData'))[0].getRowId();
		return id;
	}
}
