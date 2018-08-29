function initPage(){
	
	var adtFilRegDateSince = $('');
	
	initQueryButtons();
	initAdminFav();
	
	var btnView = $('btnView');
	
	if (btnView) {
		btnView.addEvent('click', function(evt) {
			var tableData = $('tableData');
			
			if (selectionCount(tableData) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				//---
				//verificar que tengan valores los campos requeridos
				var reqs = new Array();
				var filters = $$('.checkForView');
				for (var i = 0; i < filters.length; i++){
					var f = filters[i];
					if (f.value == '' && f.getStyle("display") != "none"){
						reqs.push(f.getPrevious('span').innerHTML);					
					}
				}
				if (reqs.length > 0){
					var msg = lblQryMustFil + ": ";
					for (var i = 0; i < reqs.length; i++){
						if (i != 0){
							msg += ", ";
						}
						msg += "'" + reqs[i] + "'";
					}
					showMessage(msg, GNR_TIT_WARNING, 'modalWarning');
					return;
				}
				//---
				
				
				var id = getSelectedRows($('tableData'))[0].getRowId();
				ADMIN_SPINNER.show(true);
				document.location = CONTEXT + URL_REQUEST_AJAX + "?action=view&id=" + id + TAB_ID_REQUEST;	
			}
		});
	}
	
	var btnDocuments = $('btnDocuments');
	if (btnDocuments){
		btnDocuments.addEvent("click",function(e){
			e.stop();
			//verificar que solo un registro esté seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=getQueryInfoForMonDocument&isAjax=true&id=' + id + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
	}
	
	//['btnSearch','btnExport','btnView','btnDocuments'].each(setTooltip);
	
	var nameFilReq = null;
	var allFilReq = $$('div.filterRequired');
	if (allFilReq.length > 0) { nameFilReq = new Array(); }
	for (var i = 0; i < allFilReq.length; i++){
		allFilReq[i].getElements(".queryFilter").each(function (fil){
			nameFilReq.push(fil.get("id"));
		});		
	}
	initNavButtons(URL_REQUEST_AJAX,'',nameFilReq);	
	customizeRefresh();
	callNavigateRefresh();
}

function openMonDocument(envId, busEntTitle, busEntRegInst, qryTitle){
	SYS_PANELS.closeAll();
	var tabContainer = window.parent.document.getElementById('tabContainer');
	var url = CONTEXT + URL_REQUEST_AJAX_MON_DOCUMENT + '?action=init&favFncId=54&preFilQuery=true&envId=' + envId + '&busEntTitle=' + busEntTitle + '&busEntRegInst=' + busEntRegInst + '&qryTitle=' + qryTitle + TAB_ID_REQUEST;
	tabContainer.addNewTab(MON_DOC_TAB_TITLE,url,null);		
}
