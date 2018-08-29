
function initPage(){
	
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByDesc','orderByRegUser','orderByRegDate'].each(function(ele){ setAdmListTitle(ele); });
	['orderByName','orderByDesc','orderByRegUser','orderByRegDate'].each(function(ele){ setAdmOrder(ele); });
	['nameFilter','descFilter','regUsrFilter'].each(function(ele) { setAdmFilters(ele); });
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','descFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	});
	
	var btnPreview = $('btnPreview');
	if (btnPreview){
		btnPreview.addEvent("click",function(e){
			e.stop();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else{
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method : 'post',
					url : CONTEXT + URL_REQUEST_AJAX + '?action=loadDataPreview&isAjax=true&id=' + id + TAB_ID_REQUEST,
					onRequest : function() { SYS_PANELS.showLoading(); },
					onComplete : function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			} 
		});
	}
		
	initAdminActions();	
	initNavButtons();
	initHomeTemplateMdlPage();
	
	callNavigate();
}

function setFilter(){
	callNavigateFilter({
		txtName: $('nameFilter').value,
		txtDesc: $('descFilter').value,
		txtRegUser: $('regUsrFilter').value,
		txtRegDate: $('regDateFilter').value
	},null);
}

function loadDataPreview(name,desc,html){
	SYS_PANELS.closeAll();
	showHomeTemplateModal(name,desc,html);
}
