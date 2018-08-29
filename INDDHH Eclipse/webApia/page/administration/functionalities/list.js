function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByTitle','orderByType','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByTitle','orderByType','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['titleFilter','typeFilter','regUsrFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['titleFilter','regUsrFilter','typeFilter','fatherFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('titleFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	//Arbol
	$('btnTree').addEvent("click", function(e) {
		e.stop();
		ADMIN_SPINNER.show(true);
		window.location = CONTEXT + URL_REQUEST_AJAX + '?action=tree' + TAB_ID_REQUEST;
	});
	
	initAdminActions();
	initNavButtons();
	
	
	//New Event for btnDelete
	btnDelete.removeEvents('click');
	btnDelete.addEvent("click", function(e) {
		e.stop();
		
		if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING,'modalWarning');
		} else {
			var selected = getSelectedRows($('tableData'));
			var selection = "";
			for (i = 0; i < selected.length; i++) {
				selection += selected[i].getRowId();
				if (i < selected.length - 1) {
					selection += ";";
				}
			}
			var request = new Request({
				method : 'post',
				url : CONTEXT + URL_REQUEST_AJAX + '?action=initProcessDelete&isAjax=true&id=' + selection + TAB_ID_REQUEST,
				onRequest : function() { },
				onComplete : function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		}
	});
	
	callNavigate();
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtFncFather: $('fatherFilter').value,
			txtFncTitle: $('titleFilter').value,
			txtFncType: $('typeFilter').value,
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value
		},null);
}
