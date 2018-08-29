function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//$$("div.button").each(setAdmEvents);
	
	['orderByName','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByName','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','groupTypeFilter','regUsrFilter','regUsrFilter'].each(setAdmFilters);
	
	$('regDateFilter').setFilter = setFilter;
	$('regDateFilter').addEvent("change", function(e) {
		this.setFilter();
	});
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','descFilter','groupTypeFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	});
	
	$('btnDownload').addEvent("click",function(e){
		e.stop();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=createExcelFile&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	});
	
	$('btnUpload').addEvent("click",function(e){
		e.stop();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=ajaxUploadStart&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	});
	
	initAdminActions();
	initNavButtons();
	
	callNavigate();
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtName: $('nameFilter').value,
			txtDesc: $('descFilter').value,
			selTip: $('groupTypeFilter').value,			
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value
		},null);
}

function downloadFile(){
	SYS_PANELS.closeAll();
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","","","",null);
}

