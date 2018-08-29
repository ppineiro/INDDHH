function initPage(){
	
	if(window.frameElement && $(window.frameElement).hasClass('modal-content')) {
		$(window.frameElement).fireEvent('closeModal');
	}
	
	var filterByBusEnt = $('filBusEntId') && $('filBusEntId').value!='';
	if(ENT_LIST_TITLE_TAB && getTabContainerController() && !filterByBusEnt)
		getTabContainerController().changeTabTitle(TAB_ID, ENT_LIST_TITLE_TAB);
	
	if(!GLOBAL_ADMIN && filterByBusEnt && fncTAbName!=''){
		getTabContainerController().changeTabTitle(TAB_ID, fncTAbName);
	}
	
	//crear spinner de espere un momento
	$$('.allowFilter').each(setAdmFilters);
	
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//tooltips para orden
	['orderById','orderByType','orderByStatus','orderByCreateDate','orderByCreateUser'].each(setAdmListTitle);
	
	//eventos para orden
	$$('.allowSort').each(setAdmOrder);
	
	//asociar eventos para los filtros
	['idFilter','typeFilter','statusFilter','createUserFilter','fecCreStartFilter','fecCreEndFilter'].each(setAdmFilters);
	['fecCreStartFilter', 'fecCreEndFilter'].each(setDateFilters);	
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		if ($('typeFilter')) { ['typeFilter'].each(clearFilter); }	
		['idFilter','statusFilter','createUserFilter'].each(clearFilter);
		['fecCreStartFilter','fecCreEndFilter'].each(clearFilterDate);	
		
		$$('.allowFilter').each(function(ele) { 
			ele.value = "";
			ele.oldValue = "";
			if (ele.getNext()) {
				ele.getNext().value = "";
				ele.getNext().oldValue = "";
			}
		});
		
		$('idFilter').setFilter();		
	}).addEvent('keypress', Generic.enterKeyToClickListener);

//	hideBtnCre,hideBtnUpd,hideBtnClo,hideBtnDel,hideBtnDep, hideBtnClose
	
	var createButton = SHOW_CREATE_BUTTON;
	var updateButton = SHOW_UPDATE_BUTTON;
	var deleteButton = SHOW_DELETE_BUTTON;
	
	initAdminActions();
	initNavButtons();
	initCustomButtons();
//	initValidate();
//	setDatesChecker();
	
	if (!createButton && !GLOBAL_ADMIN)
		$('btnCreate').style.display = 'none';
	if (!updateButton && !GLOBAL_ADMIN)
		$('btnUpdate').style.display = 'none';
	if (!deleteButton && !GLOBAL_ADMIN)
		$('btnDelete').style.display = 'none';
	
	callNavigate();
}


//navegar a una pagina 


//establecer un filtro
function setFilter(){
	var values = {
			txtId: $('idFilter').value,
			entName: ($('typeFilter') == null) ? '' : $('typeFilter').value.toUpperCase(),	
			filStaEnt: $('statusFilter').value.toUpperCase(),		
			filFchDes: $('fecCreStartFilter').value,
			filFchHas: $('fecCreEndFilter').value,	
			filUsuCre: $('createUserFilter').value.toLowerCase(),
			filBusEntId: $('filBusEntId').value
		};
	
	$$('.allowFilter').each(function (ele){ values[ele.get('name')] = ele.get('value'); });
	
	callNavigateFilter(values,null);
}

function initCustomButtons() {
	
	//Update
	var btnUpdate = $('btnUpdate'); 
	btnUpdate.removeEvents('click');
	btnUpdate.addEvent("click", function(e) {
		e.stop();
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var uneditableTR = getSelectedRows($('tableData'))[0].get('uneditableTR') == "false" ? true : false;
			uneditableTR = uneditableTR || getSelectedRows($('tableData'))[0].hasClass('uneditableTR');
			
			if (uneditableTR) {
				showConfirm(MSG_ELE_ONLY_READ,  GNR_TIT_WARNING,  function(ret) {  
					if (ret) {
						ADMIN_SPINNER.show(true);
						var id = getSelectedRows($('tableData'))[0].getRowId();
						window.location = CONTEXT + URL_REQUEST_AJAX + '?action=update&onlyRead=true&id=' + id + TAB_ID_REQUEST;
					} 
				}, "modalWarning");
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method : 'post',
					url : CONTEXT + URL_REQUEST_AJAX + '?action=checkAction&isAjax=true&op=update' + TAB_ID_REQUEST,
					onRequest : function() { SYS_PANELS.showLoading(); },
					onComplete : function(resText, resXml) { SYS_PANELS.closeAll(); customModalProcessXml(resXml, id); }
				}).send('id=' + id);
			}
		}
	});
	
	//Delete
	var btnDelete = $('btnDelete');
	btnDelete.removeEvents('click');
	btnDelete.addEvent('click', function(e) {
		e.stop();
		hideMessage();
		if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var rows = getSelectedRows($('tableData'));
			var uneditableTR = false;
			if(rows && rows.length) {
				for(var i = 0; i < rows.length; i++) {
					uneditableTR = uneditableTR || rows[i].get('uneditableTR') == "true" || rows[i].hasClass('uneditableTR');
				}
			}
			if (uneditableTR) {
				showMessage(MSG_ELE_CANT_DELETE, GNR_TIT_WARNING, "modalWarning");
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method : 'post',
					url : CONTEXT + URL_REQUEST_AJAX + '?action=checkAction&isAjax=true&op=delete' + TAB_ID_REQUEST,
					onRequest : function() { SYS_PANELS.showLoading(); },
					onComplete : function(resText, resXml) { SYS_PANELS.closeAll(); customModalProcessXml(resXml, id); }
				}).send('id=' + id);
			}
		}
	})
}

function customModalProcessXml(resXml, id) {
	var mainTag = resXml.getElementsByTagName('checkResult');
	if (mainTag && mainTag.length > 0 && mainTag.item(0) != null) {
		var tagResult = mainTag.item(0).getElementsByTagName("operation")[0];
		var opType = tagResult.getAttribute("opType");
		var allowOp = tagResult.getAttribute("allowOp");
		if (opType == 'update') {
			if (allowOp == 'true') {
				ADMIN_SPINNER.show(true);
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=update&id=' + id + TAB_ID_REQUEST;
			} else
				showMessage(MSG_CANT_UPDATE_INSTANCE, GNR_TIT_WARNING, 'modalWarning');
		} else if (opType == 'delete') {
			if (allowOp == 'true') {
				SYS_PANELS.newPanel();
				var panel = SYS_PANELS.getActive();
				panel.addClass("modalWarning");
				panel.content.innerHTML = CONFIRM_ELEMENT_DELETE;
				panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnDeleteClickConfirm();\">"
						+ GNR_NAV_ADM_DELETE + "</div>";
				SYS_PANELS.addClose(panel);
				SYS_PANELS.refresh();
			} else 
				showMessage(MSG_CANT_DELETE_INSTANCE, GNR_TIT_WARNING, 'modalWarning');
		}
	}
}

function validateDates(obj){
	var dteStart = $('fecCreStartFilter');
	var dteEnd = $('fecCreEndFilter');
	
	var datesOk = verifyDates(dteStart,dteEnd);
	var checkTime = true;
	if (!datesOk || (datesOk && !checkTime)){
		showMessage(MSG_ERROR_DATE, GNR_TIT_WARNING, 'modalWarning');
		var toClear;
		if (obj == dteStart){
			toClear = dteStart;
		} else if (obj == dteEnd){
			toClear = dteEnd;
		}
		toClear.value = "";
		if (toClear == dteStart || toClear == dteEnd){
			toClear.getNext().value = "";		
		}
	}
}
