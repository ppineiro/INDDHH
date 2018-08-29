function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//$$("div.button").each(setAdmEvents);
	
	$("fncDescriptionText").innerHTML="";
	var htmlText = "<label id=\"messageText\">"+ FNC_DESCRIPTION + "</label>"; 
	new Element('label', {html: htmlText}).inject($('fncDescriptionText'));
	
	['orderByName','orderBySize','orderByDocType','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByName','orderBySize','orderByDocType','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','cmbDocType','sizeMinFilter','sizeMaxFilter','regUsrFilter','titleFilter','instFilter','contentFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		$('nameFilter').value="";
		$('descFilter').value="";
		$('sizeMinFilter').value="";
		$('sizeMaxFilter').value="";
		$('cmbDocType').value="";
		$('regUsrFilter').value="";
		$('regDateFilter').value="";
		$('regDateFilter').getNext().value ="";
		
		$('titleFilter').value="";
		$('contentFilter').value="";
		$('instFilter').value="";
		
		enableDisableFilters($('cmbDocType'));
		
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	enableDisableFilters($('cmbDocType'));
	
	if (!UNLOCK){
		//Information
		$('btnInfo').addEvent('click', function(e){
			e.stop();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=information&isAjax=true&id=' + id + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
		
		//History
		$('btnHist').addEvent("click", function(e) {
			e.stop();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=history&isAjax=true&id=' + id + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
		
		//Download
		$('btnDown').addEvent("click", function(e){
			e.stop();
			hideMessage();
			e.stop();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","&id="+id,"","true",null);
			}
		});
		
		//['btnInfo','btnHist','btnDown'].each(setTooltip)
	
	} else {
		//Unlock
		
		//Cambiar valor de opciones para mapear la vista de unlock
		var opts = $('cmbDocType').getElements('option');
		for(var i = 0; i < opts.length; i++) {
			if(opts[i].get('value') == 'EA')
				opts[i].set('value', 'EIA');
			else if(opts[i].get('value') == 'PA')
				opts[i].set('value', 'PIA');
		}
		
		$('btnUnlock').addEvent("click", function(e){
			e.stop();
			hideMessage();
			e.stop();
			if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
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
					url: CONTEXT + URL_REQUEST_AJAX + '?action=unlock&isAjax=true&unlock=true&id=' + selection + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
		
		//['btnUnlock'].each(setTooltip);
	
	}
	initNavButtons();
	initAdminFav();
	callNavigate();
}


function enableDisableFilters(cmb){
	//Filter Titulo
	if ("" != cmb.value){
		$('titleFilter').className = "";
		$('titleFilter').readOnly = false;
	} else {
		$('titleFilter').className = "readonly";
		$('titleFilter').readOnly = true;
		$('titleFilter').value = "";
	}	
	//Filter NroRegistro
	if (INST_PROC == cmb.value || INST_ENT == cmb.value){
		$('instFilter').className = "";
		$('instFilter').readOnly = false;
	} else {
		$('instFilter').className = "readonly";
		$('instFilter').readOnly = true;
		$('instFilter').value = "";
	}
} 

function documentVersionDownload(docId,docVer){
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","&id="+docId+"&version="+docVer,"","",null);
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
		txtName: $('nameFilter').value,
		txtDesc: $('descFilter').value,
		txtSizeFrom: $('sizeMinFilter').value,
		txtSizeTo: $('sizeMaxFilter').value,
		selType: $('cmbDocType').value,
		txtUser: $('regUsrFilter').value,
		txtCreate: $('regDateFilter').value,
		txtRelTitle: $('titleFilter').value,
		docContent: $('contentFilter').value,
		txtInst: $('instFilter').value
	},null);
}