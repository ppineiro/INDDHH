
function initPage(){
	//getTabContainerController().changeTabState(TAB_ID, false); 
	
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(function(ele){ setAdmListTitle(ele); });
	['orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(function(ele){ setAdmOrder(ele); });
	['nameFilter','titleFilter','descFilter','regUsrFilter','execFilter'].each(function(ele) { setAdmFilters(ele); });
	$('regDateFilter').setFilter = setFilter;
	$('regDateFilter').addEvent("change", function(e) { this.setFilter(); });	
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','titleFilter','descFilter','regUsrFilter'].each(clearFilter);
		$('cmbLand').selectedIndex = 0;
		$('cmbResp').selectedIndex = 0;
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	});
	
	$('setDefault').addEvent("click", function (e){
		e.stop();
		if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');			
		} else if (selectionCount($('tableData')) > 1){
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var id = getSelectedRows($('tableData'))[0].getRowId();
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=startSetDefaultDashboard&isAjax=true&id=' + id + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		}	
	});
	//['setDefault'].each(setTooltip);
	
	initAdminActions();	
	initNavButtons();
	
	callNavigate();
}

function setFilter(){
	callNavigateFilter({
		txtName: $('nameFilter').value,
		txtTitle: $('titleFilter').value,
		txtDesc: $('descFilter').value,
		txtRegUsr: $('regUsrFilter').value,
		txtRegDte: $('regDateFilter').value,
		txtLand: $('cmbLand').value,
		txtResp: $('cmbResp').value
	},null);
}


