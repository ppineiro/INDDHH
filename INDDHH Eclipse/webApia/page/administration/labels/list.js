function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	

	['orderByName','orderByDescription','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByName','orderByDescription','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','regUsrFilter','regUsrFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','descFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	initAdminActions(false,false,true,false,false);
	initNavButtons();
	
	callNavigate();
	
	['start', 'stop'].each(function(action){
		var btnAction = $('btn' + action.capitalize() + 'LblRec');
		if (btnAction){
			btnAction.addEvent('click', function(e){
				if (e){ e.stop(); }
				
				var request = new Request({
					method : 'post',
					url : CONTEXT + URL_REQUEST_AJAX + '?action=' + action + 'Recording&isAjax=true&' + TAB_ID_REQUEST,
					onRequest : function() { SYS_PANELS.showLoading(); },
					onComplete : function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			})
		}
	})

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

function viewNotFoundLabels(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=viewNotFoundLabels&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}

function clearNotFoundLabels(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=clearNotFoundLabels&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}
