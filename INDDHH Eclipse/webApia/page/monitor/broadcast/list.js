function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	Generic.updateFncImages();
	
	//$$("div.button").each(setAdmEvents);

	['orderByDate','orderByUser','orderByMessage'].each(setAdmOrder);
	['orderByDate','orderByUser','orderByMessage'].each(setAdmListTitle);
	
	['byFilter', 'messageFilter'].each(setAdmFilters);
	['blockFilter', 'dateFilterStart', 'dateFilterEnd', 'seenFilter'].each(function(ele){ $(ele).addEvent("change", setFilter); });
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['byFilter','messageFilter','seenFilter','blockFilter'].each(clearFilter);
		['dateFilterStart','dateFilterEnd'].each(clearFilterDate);
		$('seenFilter').selectedIndex = 0;
		$('blockFilter').selectedIndex = 0;		
		$('byFilter').callNavigate();
	});
	
	var btnView = $('btnView');
	var btnDelete = $('btnDelete');
	
	if (btnView) {
		btnView.addEvent('click', function(e) {
			e.stop();
			hideMessage();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method : 'post',
					url : CONTEXT + URL_REQUEST_AJAX + '?action=view&isAjax=true&id=' + id + TAB_ID_REQUEST,
					onComplete : function(resText, resXml) {
						modalProcessXml(resXml);
					}
				}).send();
			}
		});
	}
	
	if (btnDelete) {
		btnDelete.addEvent("click", function(e) {
			e.stop();
			hideMessage();
			if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE,
						GNR_TIT_WARNING, 'modalWarning');
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
	callNavigateFilter({
		byUser : $('byFilter').value,
		cmbBlock : $('blockFilter').options[$('blockFilter').selectedIndex].value,
		txtMsg : $('messageFilter').value,
		txtFrom: $('dateFilterStart').value,
		txtTo: $('dateFilterEnd').value,
		cmbSeen: $('seenFilter').value
	},null);
}