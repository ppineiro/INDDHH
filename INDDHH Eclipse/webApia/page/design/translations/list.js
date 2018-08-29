function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	Generic.updateFncImages();

	['orderById','orderByName','orderByStatus'].each(setAdmOrder);
	['orderByType','orderById','orderByName','orderByStatus'].each(setAdmListTitle);
	['idFilter','objNameFilter'].each(setAdmFilters);
	
	 
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['objNameFilter','typeFilter','idFilter'].each(clearFilter);
		$('objNameFilter').setFilter();
	});
	
	$('btnTrans').addEvent("click", function(e){
		e.stop();		
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			// obtener el usuario seleccionado
			var id = getSelectedRows($('tableData'))[0].getRowId();
			var request = new Request({
				method : 'post',
				data:{'id':id},
				url : CONTEXT + URL_REQUEST_AJAX + '?action=translate&isAjax=true' + TAB_ID_REQUEST,
				onRequest : function() {sp.show(true);},
				onComplete : function(resText, resXml) {modalProcessXml(resXml);sp.hide(true);}
			}).send();
		}		
	});
	
	$('optionDownload').addEvent("click", function(e){
		e.stop();
		hideMessage();
		
		prepareModalDownload();
	});
	
	$('optionUpload').addEvent("click", function(e){
		e.stop();
		upload();		
	});
	
 
	initNavButtons();
	initAdminFav();
	callNavigate();
	
	
	['start', 'stop'].each(function(action){
		var btnAction = $('btn' + action.capitalize() + 'TraRec');
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
		txtTraObjName: $('objNameFilter').value,
		txtTraObjId: $('idFilter').value,
		cmbTraType: $('typeFilter').value

		},null);
}

function upload(){
	hideMessage();
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX+'?action=selectUpload&isAjax=true&' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}

function prepareModalDownload(langId){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=prepareModalDownload&isAjax=true&' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}


function doDownload(exportAll) {
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","&exportAll="+exportAll,"","",null);
}

function closeUploadModal(){
	SYS_PANELS.closeActive();
	var ajaxCallXml = getLastFunctionAjaxCall();
	var xmlGenerals = ajaxCallXml.getElementsByTagName('general');
	
	if (xmlGenerals != null) {
		
		for (var i = 0; i < xmlGenerals.length; i++) {
			var xmlGeneral = xmlGenerals[i];
			var msg = xmlGeneral.getAttribute("message");
			showMessage(msg, GNR_TIT_WARNING, 'modalWarning');
		}
	}
}

