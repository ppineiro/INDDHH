function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//$$("div.button").each(setAdmEvents);

	['orderByName','orderByDescription','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByPerm','orderByName','orderByDescription','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['projectFilter','nameFilter','descFilter','regUsrFilter','regUsrFilter'].each(setAdmFilters);
	
	$('regDateFilter').setFilter = setFilter;
	$('regDateFilter').addEvent("change", function(e) {
		this.setFilter();
	});
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','descFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	});
	
	initAdminActions(false, false, false, false, true);
	
	var btnExecute = $('btnExecute');
	if (btnExecute){
		btnExecute.addEvent("click",function(e){
			e.stop();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING,'modalWarning');
			} else {
				// obtener el usuario seleccionado
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method : 'post',
					data:{'id':id},
					url : CONTEXT + URL_REQUEST_AJAX+ '?action=simulate&isAjax=true' + TAB_ID_REQUEST,
					onRequest : function() {SYS_PANELS.showLoading();},
					onComplete : function(resText, resXml) {modalProcessXml(resXml);
					}
				}).send();
			}
		});
	}
	
	initNavButtons();
	
	callNavigate();
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtName: $('nameFilter').value,
			txtDesc: $('descFilter').value,		
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value
		},null);
}

function goToConf(){
	sp.show(true);
	window.location = CONTEXT + URL_REQUEST_AJAX + '?action=goToConf' + TAB_ID_REQUEST;
}