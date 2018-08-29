function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByPerm','orderByName','orderByDesc','orderByExecutable','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','typeFilter','execFilter','regUsrFilter','regUsrFilter'].each(setAdmFilters);
	['orderByName','orderByDesc','orderByExecutable','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	
	$('regDateFilter').setFilter = setFilter;
	$('regDateFilter').addEvent("change", function(e) {
		this.setFilter();
	});
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','descFilter','typeFilter','execFilter','projectFilter','regUsrFilter'].each(clearFilter);		
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	});
	
	var btnEnaDis = $('btnEnaDis');
	if (btnEnaDis){
		btnEnaDis.addEvent("click", function(e) {
			if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				e.stop();
				var selected = getSelectedRows($('tableData'));
				var selection = "";
				for(i=0; i<selected.length; i++){
					selection+=selected[i].getRowId();
					if(i<selected.length-1){
						selection+=";";
					}
				}
				var currPage = parseInt($('navBarCurrentPage').value);
				var request = new Request({
					method: 'post',
					data:{id:selection},
					url: CONTEXT + URL_REQUEST_AJAX+'?action=enableDisable&isAjax=true&pageNumber='+currPage + TAB_ID_REQUEST,
					onRequest: function() { sp.show(true); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
				}).send();
			}
		});
	}
	
	var btnTest = $('btnTest');
	if (btnTest){
		btnTest.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
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
					data:{ids:selection},
					url: CONTEXT + URL_REQUEST_AJAX+'?action=testList&isAjax=true'+ TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
				}).send();
			}
		});
	}
	
	initAdminActions();
	customizeBtnUpdate();
	initNavButtons();	
	callNavigate();
}


//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtName: $('nameFilter').value,
			txtDesc: $('descFilter').value,			
			cmbType: $('typeFilter').value,
			txtExe: $('execFilter').value,
			selPrj: $('projectFilter').value,
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value
		},null);
}

function customizeBtnUpdate(){
	var btnUpdate = $('btnUpdate');
	if (btnUpdate) {
		btnUpdate.removeEvents("click");
		
		btnUpdate.addEvent("click", function(e) {
			e.stop();
			// verificar que solo un usuario esté seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var uneditableTR = getSelectedRows($('tableData'))[0].get('uneditableTR') == "false" ? true : false;
				uneditableTR = uneditableTR || getSelectedRows($('tableData'))[0].hasClass('uneditableTR');
				
				if (uneditableTR) {
					showConfirm(
						MSG_NO_UPDATE_WS_PUB, 
						"Apia", 
						function(ret) {  
							if (ret) {
								ADMIN_SPINNER.show(true);
								var id = getSelectedRows($('tableData'))[0].getRowId();
								window.location = CONTEXT + URL_REQUEST_AJAX + '?action=update&onlyRead=true&id=' + id + TAB_ID_REQUEST;
							} 
						}, 
						"modalWarning"
					);
				} else {
					// obtener el usuario seleccionado
					ADMIN_SPINNER.show(true);
					var id = getSelectedRows($('tableData'))[0].getRowId();
					
					window.location = CONTEXT + URL_REQUEST_AJAX + '?action=update&id=' + id + TAB_ID_REQUEST;
				}
			}
		});
	}
}

