function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//$$("div.button").each(setAdmEvents);

	['orderByName'].each(setAdmOrder);
	['orderByName'].each(setAdmListTitle);
	['nameFilter'].each(setAdmFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter'].each(clearFilter);
		$('nameFilter').setFilter();
	});
	
	
	//['btnCreate','btnDelete','btnDownload'].each(setTooltip);
	
	//Create
	$('btnCreate').addEvent('click', function(e){
		e.stop();		
		hideMessage();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=ajaxUploadStart&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();		
	});
	
	//Delete
	$('btnDelete').addEvent('click', function(e){
		e.stop();
		hideMessage();
		if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = CONFIRM_ELEMENT_DELETE;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnDeleteClickConfirm();\">" + GNR_NAV_ADM_DELETE + "</div>";
			SYS_PANELS.addClose(panel);
			SYS_PANELS.refresh();
		}
	});
	
	//Download
	$('btnDownload').addEvent("click", function(e) {
		e.stop();
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if(selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			sp = new Spinner($('tableData'),{message:WAIT_A_SECOND});
			var id = getSelectedRows($('tableData'))[0].getRowId();
			createDownloadIFrame(TIT_DOWNLOAD,DOWNLOADING,URL_REQUEST_AJAX,"downloadStyle","&id=" + id,"","",null);
		}
	});
	
	initAdminFav();
	initNavButtons();
	
	callNavigate();
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtName: $('nameFilter').value			
		},null);
}

function btnDeleteClickConfirm() {
	var selected = getSelectedRows($('tableData'));
	var selection = "";
	for(i=0; i<selected.length; i++){
		selection+=selected[i].getRowId();
		if(i<selected.length-1){
			selection+=";";
		}
	}
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=delete&isAjax=true&id='+selection + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();
}

function modalReplace(){
	hideMessage();
	SYS_PANELS.newPanel();
	var panel = SYS_PANELS.getActive();
	panel.addClass("modalWarning");
	panel.content.innerHTML = OVERRIDE_STYLE;
	panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnConfirmReplace();\">" + BTN_CONFIRM + "</div>";
	SYS_PANELS.addClose(panel);
	SYS_PANELS.refresh();
}

function btnConfirmReplace() {
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=confirmReplace&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();
}