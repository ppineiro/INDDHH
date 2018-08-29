function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	Generic.updateFncImages();
	
	['subjectFilter', 'participantFilter','messageFilter'].each(setAdmFilters);
	['dateFilterStart','dateFilterEnd'].each(function(ele){ $(ele).addEvent("change", setFilter); });
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['subjectFilter','participantFilter','messageFilter'].each(clearFilter);
		['dateFilterStart','dateFilterEnd'].each(clearFilterDate);		
		callNavigate();
	});
	
	var btnView = $('btnView');
	
	if (btnView) {
		btnView.addEvent('click', function(e) {
			e.stop();
			hideMessage();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				// obtener el usuario seleccionado
				sp.show(true);
				var id = getSelectedRows($('tableData'))[0].getRowId();
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=view&id=' + id + TAB_ID_REQUEST;
			}
		});
	}
	
	initNavButtons();
	initAdminFav();
	initPinGridOptions();
	callNavigate();
}

function btnDeleteClickConfirm() {
	var selected = getSelectedRows($('tableData'));
	var selection = "";
	for (i = 0; i < selected.length; i++) {
		selection += selected[i].getRowId();
		if (i < selected.length - 1) {
			selection += ";";
		}
	}
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=delete&isAjax=true&id=' + selection + TAB_ID_REQUEST,
		onRequest : function() {
			sp.show(true);
		},
		onComplete : function(resText, resXml) {
			modalProcessXml(resXml);
			sp.hide(true);
		}
	}).send();
}

//establecer un filtro
function setFilter(){
	var participantFilter = $('participantFilter');
	if(participantFilter)
		callNavigateFilter({
			txtSubject : $('subjectFilter').value,
			txtParticipant : participantFilter.value,
			txtFrom: $('dateFilterStart').value,
			txtTo: $('dateFilterEnd').value,
			txtMsg: $('messageFilter').value
		},null);
	else
		callNavigateFilter({
			txtSubject : $('subjectFilter').value,
			txtFrom: $('dateFilterStart').value,
			txtTo: $('dateFilterEnd').value,
			txtMsg: $('messageFilter').value
		},null);
}