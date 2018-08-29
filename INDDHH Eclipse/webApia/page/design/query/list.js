function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByPerm','orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter', 'titleFilter','descFilter','regUsrFilter','txtView'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		$('nameFilter').value="";
		$('titleFilter').value="";
		$('descFilter').value="";
		$('projectFilter').value="";
		$('regUsrFilter').value ="";
		$('regDateFilter').value ="";
		$('txtView').value ="";
		$('cmbSource').value ="";
		$('regDateFilter').getNext().value ="";
		$('typeQuery').value ="";
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	initAdminActions();
	
	btnUpdate.removeEvent("click");
	btnUpdate.addEvent("click", function(e) {
		e.stop();
		// verificar que solo un usuario este seleccionado
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING,'modalWarning');
		} else {
			var uneditableTR = getSelectedRows($('tableData'))[0].get('uneditableTR') == "false" ? true : false;
			uneditableTR = uneditableTR || getSelectedRows($('tableData'))[0].hasClass('uneditableTR');
			
			if (uneditableTR) {
				showConfirm(MSG_ELE_ONLY_READ,  GNR_TIT_WARNING,  function(ret) {  
					if (ret) {
						ADMIN_SPINNER.show(true);
						var id = getSelectedRows($('tableData'))[0].getRowId();
						window.location = CONTEXT + URL_REQUEST_AJAX + '?action=updateQuery&onlyRead=true&id=' + id + TAB_ID_REQUEST;
					} 
				}, "modalWarning");
			} else {
				// obtener el usuario seleccionado
				ADMIN_SPINNER.show(true);
				var id = getSelectedRows($('tableData'))[0].getRowId();
				window.location = CONTEXT + URL_REQUEST_AJAX+ '?action=updateQuery&id=' + id + TAB_ID_REQUEST;
			}
		}
	}); 
	
	initNavButtons();
	
	callNavigate();
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
		txtName: $('nameFilter').value,
		txtTitle: $('titleFilter').value,
		txtDesc: $('descFilter').value,
		selPrj: $('projectFilter').value,
		txtRegUser: $('regUsrFilter').value,
		txtRegDate: $('regDateFilter').value,
		txtView: $('txtView').value,
		cmbSource: $('cmbSource').value,
		cmbType:$('typeQuery').value
	},null);
}