function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	

	['orderByName'].each(setAdmOrder);
	['orderByName'].each(setAdmListTitle);
	['nameFilter'].each(setAdmFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter'].each(clearFilter);
		$('nameFilter').setFilter();
	});
	
	
	
	$('btnUpload').addEvent('click', function(e){
		e.stop();		
		hideMessage();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=ajaxUploadStart&isAjax=true&outside=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();		
	});
//	
//	//Delete
//	$('btnDelete').addEvent('click', function(e){
//		e.stop();
//		hideMessage();
//		if (selectionCount($('tableData')) == 0) {
//			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
//		} else {
//			SYS_PANELS.newPanel();
//			var panel = SYS_PANELS.getActive();
//			panel.addClass("modalWarning");
//			panel.content.innerHTML = CONFIRM_ELEMENT_DELETE;
//			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnDeleteClickConfirm();\">" + GNR_NAV_ADM_DELETE + "</div>";
//			SYS_PANELS.addClose(panel);
//			SYS_PANELS.refresh();
//		}
//	});
//	
//	$('btnClose').addEvent("click", function(e) {
//		getTabContainerController().removeActiveTab();
//	})
//	
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
	
	
	
	initAdminActions(false, false, true, false, true, false);
	initAdminFav();
	initNavButtons();
	
//	hideBtnCre,hideBtnUpd,hideBtnClo,hideBtnDel,hideBtnDep, hideBtnClose
	
	
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('data-src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	
//	$('btnClone').style.display = "none";
//	$('btnDependencies').style.display = "none";
	$('btnUpdate').removeEvents('click');
	$('btnUpdate').addEvent("click", function(e) {
		if (e) e.stop();
		hideMessage();
		var id = getSelectedRows($('tableData'))[0].getRowId();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=checkCreateStyFunc&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { customStyleModalProcessXml(resXml); }
		}).send("id=" + id);	
	});
	
	callNavigate();
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
		onComplete: function(resText, resXml) { modalProcessXml(resXml); $('nameFilter').value=""; sp.hide(true); }
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

function customStyleModalProcessXml(xml) {
	var child = xml.getElementsByTagName("data").item(0);
	var canUpdate = toBoolean(child.getAttribute("canUpdate"));
	var styleName = child.getAttribute('styleId');
	if (canUpdate) {
		ADMIN_SPINNER.show(true);
		window.location = CONTEXT + URL_REQUEST_AJAX + '?action=update&isAjax=true&id=' + styleName + TAB_ID_REQUEST;
	} else {
		modalProcessXml(xml);
	}
}

