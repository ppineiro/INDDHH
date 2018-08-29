function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//$$("div.button").each(setAdmEvents);

	['orderByName','orderByDesc','orderByLabel','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByName','orderByDesc','orderByLabel','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','orderByLabel','regUsrFilter','regUsrFilter'].each(setAdmFilters);
	
	$('regDateFilter').setFilter = setFilter;
	$('regDateFilter').addEvent("change", function(e) {
		this.setFilter();
	});
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','descFilter','labelFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	});
	
	
	//['btnInit','btnParam'].each(setTooltip);
	//Inicializar
	$('btnInit').addEvent("click", function(e) {
		e.stop();
		hideMessage();
		if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {			
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = CONFIRM_ELEMENT_INIT;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnInitClickConfirm();\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel);			
			SYS_PANELS.refresh();
		}
	});
	//Parametros
	$('btnParam').addEvent("click", function(e) {
		e.stop();
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if(selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var id = getSelectedRows($('tableData'))[0].getRowId();
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=getEnvName&isAjax=true&id=' + id + TAB_ID_REQUEST,
				onRequest: function() { sp.show(true); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
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
			cmbLblSet: $('labelFilter').value,			
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value
		},null);
}

function enableDisableAsocFunc(chk3,idChk4){
	var chk4 = $(idChk4);
	chk4.disabled = !chk3.checked;
}

function btnInitClickConfirm(){
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
		url: CONTEXT + URL_REQUEST_AJAX + '?action=initEnvironment&isAjax=true&id=' + selection + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();
}

function processXMLInitEnvParam(){
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];
	if (ajaxCallXml != null && ajaxCallXml.getElementsByTagName("environment")) {
		var xmlEnv = ajaxCallXml.getElementsByTagName("environment")[0];
		var id = xmlEnv.getAttribute("id");
		var tabTitle = TITLE_TAB + " - " + xmlEnv.getAttribute("name") + " 3.0";
		var tabContainer = window.parent.document.getElementById('tabContainer');
		var url = CONTEXT + URL_REQUEST_AJAX_ENV_PARAMS + '?action=init&envId=' + id;
		tabContainer.addNewTab(tabTitle,url,null);
	}
}