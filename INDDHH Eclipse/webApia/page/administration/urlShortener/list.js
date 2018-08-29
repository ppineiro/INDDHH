function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	

	['orderByCode','orderByUrl', 'orderByRegUser', 'orderByRegDate'].each(setAdmOrder);
	['orderByCode','orderByUrl', 'orderByRegUser', 'orderByRegDate'].each(setAdmListTitle);
	['codeFilter','urlFilter', 'regUsrFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['codeFilter','urlFilter', 'regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('codeFilter').setFilter();
	});
	
	
	
	//Create
	$('btnCreate').addEvent('click', function(e){
		e.stop();		
		hideMessage();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=startCreateURL&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();		
	});
	
	$('btnUpdate').addEvent('click', function(e){
		e.stop();
		var count = selectionCount($('tableData'));
		if (count > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if (count == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var id = getSelectedRows($('tableData'))[0].getRowId();
			if(PRIMARY_SEPARATOR_IN_BODY) {
				new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=startUpdate&isAjax=true' + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send('id=' + id);	
			} else {
				new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=startUpdate&isAjax=true&id=' + id + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();	
			}
		}
	});
	
	$('btnRemove').addEvent('click', function(e){
		
		
		SYS_PANELS.newPanel();
		var panel = SYS_PANELS.getActive();
		panel.addClass("modalWarning");
		panel.content.innerHTML = CONFIRM_ELEMENT_DELETE;
		panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnDeleteClickConfirm();\">"
				+ GNR_NAV_ADM_DELETE + "</div>";
		SYS_PANELS.addClose(panel);

		SYS_PANELS.refresh();
		
			
	});
	
	initAdminFav();
	initNavButtons();
	
	callNavigate();
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('data-src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
}

function btnDeleteClickConfirm(){
	hideMessage();
	if (selectionCount($('tableData')) == 0) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
	} else {			
		var id = getSelectedRows($('tableData'))[0].getRowId();
		if(PRIMARY_SEPARATOR_IN_BODY) {
			new Request({
				method : 'post',
				url : CONTEXT + URL_REQUEST_AJAX + '?action=deleteUrl&isAjax=true' + TAB_ID_REQUEST,
				onRequest : function() { sp.show(true); },
				onComplete : function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
			}).send('id=' + id);
		} else {
			new Request({
				method : 'post',
				url : CONTEXT + URL_REQUEST_AJAX + '?action=deleteUrl&isAjax=true&id=' + id + TAB_ID_REQUEST,
				onRequest : function() { sp.show(true); },
				onComplete : function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
			}).send();
		}
	}
}
//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtCode: $('codeFilter').value,
			txtUrl: $('urlFilter').value,
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value
		},null);
}

function reloadList(){
	SYS_PANELS.closeAll();
	setFilter();
}
