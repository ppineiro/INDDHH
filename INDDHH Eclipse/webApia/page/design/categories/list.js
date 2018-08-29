function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//$$("div.button").each(setAdmEvents);

	['orderByName','orderByDesc','orderByFather', 'orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByName','orderByDesc','orderByFather', 'orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','padFilter', 'regUsrFilter','regUsrFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','descFilter','padFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	initAdminActions();
	initNavButtons();
	
	callNavigate();
	
	$('btnDown').addEvent('click', function(evt){
		evt.stop();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=createModalExport&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	});
	
	$('btnUp').addEvent('click', function(evt){
		evt.stop();
		hideMessage();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=ajaxUploadStart&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	});  
}

//establecer un filtro
function setFilter(){
	callNavigateFilterAtt({
		txtName: $('nameFilter').value,
		txtDesc: $('descFilter').value,
		txtFather: $('padFilter').value,
		txtRegUser: $('regUsrFilter').value,
		txtRegDate: $('regDateFilter').value			
	},null);
}

function callNavigateFilterAtt(objParams, strParams,url){
	hideMessage();
	if(!url){
	url = URL_REQUEST_AJAX;
	}
	var request = new Request({
	method: 'post',
	data: objParams,
	url: CONTEXT + url + '?action=filterAtt&isAjax=true' + TAB_ID_REQUEST,
	onRequest: function() { sp.show(true); },
	onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send(strParams);
} 

function startDownload(){
	var spinner = new Spinner($('bodyDiv'),{message:WAIT_A_SECOND});
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","","","",null);
}

