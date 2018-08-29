
function initPage(){
	//getTabContainerController().changeTabState(TAB_ID, false); 
	
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByPerm','orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['nameFilter','titleFilter','descFilter','regUsrFilter','execFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','titleFilter','descFilter','regUsrFilter'].each(clearFilter);
		$('cmbLand').selectedIndex = 0;
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
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
	
	var gridBody = $('gridBody');
	if (gridBody){
		gridBody.addEvent('onCompleteTable', function(){
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=checkDefaultDashboards&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { 
					var data = resXml.getElementsByTagName('data')[0];
					if (data.getAttribute('defaultConflicts')=='true'){
						modalProcessXml(resXml);	
					} else {
						SYS_PANELS.closeAll();
					}
				 }
			}).send();
		})
	}
}

function setFilter(){
	callNavigateFilter({
		txtName: $('nameFilter').value,
		txtTitle: $('titleFilter').value,
		txtDesc: $('descFilter').value,
		txtRegUsr: $('regUsrFilter').value,
		txtRegDte: $('regDateFilter').value,
		txtLand: $('cmbLand').value,
	},null);
}


