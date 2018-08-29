
function initPage(){
	
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByDesc'].each(function(ele){ setAdmListTitle(ele); });
	['orderByName','orderByDesc'].each(function(ele){ setAdmOrder(ele); });
	['nameFilter','descFilter'].each(function(ele) { setAdmFilters(ele); });
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','descFilter'].each(clearFilter);
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
		txtDesc: $('descFilter').value					
	},null);
}

function loadDataPreview(name,desc,html){
	SYS_PANELS.closeAll();
	showHomeTemplateModal(name,desc,html);
}
