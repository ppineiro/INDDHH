function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	

	['orderByName','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByName','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','regUsrFilter','regDateFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','descFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	//eventos para opciones
	$('optionUnset').addEvent("click", function(e) {
		e.stop();
		var selCount = selectionCount($('tableData'));
		
		if (selCount > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if (selCount == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var selection = getSelectedRows($('tableData'))[0].getRowId();
			new Request({
				method: 'post',
				url: CONTEXT + '/apia.administration.OrganizationalRoleAction.run?action=startFreeRole&isAjax=true&id=' + selection + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { 
					modalProcessXml(resXml);
				}
			}).send();
		}
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
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value
		},null);
}

function generateFreeRoleDoc(e) {
	var selection = getSelectedRows($('tableData'))[0].getRowId();
	new Request({
		url: CONTEXT + '/apia.administration.OrganizationalRoleAction.run?action=generateReleaseRoleDoc&isAjax=true&id=' + selection + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete:	function(resText, responseXML) { 
			SYS_PANELS.closeLoading();
			if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
	    		var anchor = new Element('a', {
	    			href: 'page/administration/orgRole/downloadChanges.jsp?path=' + responseXML.childNodes[responseXML.childNodes.length - 1].getAttribute('URL')
	    		});
	    		anchor.inject(document.body);
	    		if(anchor.click) {
	    			anchor.click();
	    		} else if(document.createEvent) {
	    		    var eventObj = document.createEvent('MouseEvents');
	    		    eventObj.initEvent('click', true, true);
	    		    anchor.dispatchEvent(eventObj);
	    		}
	    		SYS_PANELS.closeActive();
	    		
	    		new Request({
					method: 'post',
					url: CONTEXT + '/apia.administration.OrganizationalRoleAction.run?action=askConfirmationReleaseRoleDoc&isAjax=true&id=' + selection + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) {
						modalProcessXml(resXml);
					}
				}).send();
	    		
	    	}
		}
	}).send();
}