var modeGloblal = true;

function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//$$("div.button").each(setAdmEvents);
	
	modeGlobal = $('cmbEnvFilter') != null;
	
	['orderByDteFrom','orderByDteTo','orderByMessage','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByDteFrom','orderByDteTo','orderByMessage','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['dteFromFilter','dteToFilter','msgFilter','regUsrFilter','regDateFilter'].each(setAdmFilters);
	if (modeGlobal) {
		['orderByEnv'].each(setAdmOrder);
		['orderByEnv'].each(setAdmListTitle);
		['cmbEnvFilter'].each(setAdmFilters);
	}
	
	['dteFromFilter','dteToFilter','regDateFilter'].each(function(ele){
		ele = $(ele);
		ele.setFilter = setFilter;
		ele.addEvent("change", function(e) { this.setFilter(); });
	});
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		if (modeGlobal) { ['cmbEnvFilter'].each(clearFilter); }
		['dteFromFilter','dteToFilter','regDateFilter'].each(clearFilterDate);		
		['msgFilter','regUsrFilter'].each(clearFilter);
		$('msgFilter').setFilter();
	});
	
	//Create
	$('btnCreate').addEvent("click", function(e) {
		e.stop();
		sp.show(true);
		window.location = CONTEXT + URL_REQUEST_AJAX + '?action=create' + TAB_ID_REQUEST;
	});
	
	//Update
	$('btnUpdate').addEvent("click", function(e) {
		e.stop();
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if(selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			sp.show(true);
			var id = getSelectedRows($('tableData'))[0].getRowId();
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=update&id=' + id + TAB_ID_REQUEST;
		}
	});
	
	//Delete	
	$('btnDelete').addEvent("click", function(e) {
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
	
	//Initialize
	$('btnInit').addEvent("click", function(e) {
		e.stop();
		hideMessage();
		SYS_PANELS.newPanel();
		var panel = SYS_PANELS.getActive();
		panel.addClass("modalWarning");
		panel.content.innerHTML = MSG_INIT_MSG;
		panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnInitializeClickConfirm();\">" + BTN_CONFIRM + "</div>";
		SYS_PANELS.addClose(panel);
		SYS_PANELS.refresh();
	});
	
	//['btnCreate','btnUpdate','btnDelete','btnInit'].each(setTooltip);
	initAdminActions();
	initNavButtons();
	
	callNavigate();
	initAdminFav();
}

//establecer un filtro
function setFilter(){
	var env = "";
	if (modeGlobal) { env = $('cmbEnvFilter').value; }
	callNavigateFilter({
			dteFrom: $('dteFromFilter').value,
			dteTo: $('dteToFilter').value,
			txtMsg: $('msgFilter').value,
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value,
			cmbEnvId: env
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

function btnInitializeClickConfirm() {
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=initializeMessages&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();
}


