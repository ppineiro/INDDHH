var actionsAtConfirm = ["initProcess","debug","importXPDL","regCube","regConds","lockUnlockProc"];

function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByPerm','orderByLock','orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(function(ele){ setAdmListTitle(ele); });
	['orderByLock','orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(function(ele){ setAdmOrder(ele); });
	//['optionInit','optionRegCube','optionRegConds','optionImport','optionVersions','optionDebug','optionLock'].each(setTooltip);
	['nameFilter','titleFilter','descFilter','regUsrFilter','regUsrFilter','lockByUsrFilter'].each(function(ele) { setAdmFilters(ele); });
	$('regDateFilter').setFilter = setFilter;
	$('regDateFilter').addEvent("change", function(e) { this.setFilter(); });	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','titleFilter','descFilter','projectFilter','regUsrFilter','actionFilter','cubeFilter','lockFilter','lockByUsrFilter','proBPMNFilter'].each(clearFilter);		
		['regDateFilter'].each(clearFilterDate);
		onChangeCmbLockFilter($('lockFilter'),true);
	});
		
	/********************************** Botones **********************************/
	//Inicializar
	$('optionInit').addEvent("click", function(e) {
		e.stop();
		if (isCountSelectedOk(false)){
			showModalConfirm(GNR_INIT_RECORD,0);
		}			
	});
	//Versiones
	$('optionVersions').addEvent("click", function(e) {
		e.stop();
		if (isCountSelectedOk(true)){
			var row = getSelectedRows($('tableData'))[0];
			showVersionsModal(row.getRowId(),row.getRowContent()[2],callNavigate);
		}
	});
	//Debug
	$('optionDebug').addEvent("click", function(e) {
		e.stop();
		if (isCountSelectedOk(true)){
			var trSelected = getSelectedRows($('tableData'))[0];
			if (!trSelected.hasClass("isBpmn")){
				showMessage(MSG_SEL_BPMN_DEBUG, GNR_TIT_WARNING, 'modalWarning');				
			} else {
				ADMIN_SPINNER.show(true);
				var id = trSelected.getRowId();
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=debug&id=' + id + '&debug=true' + TAB_ID_REQUEST;
			}						
		}		
	});
	//Importar XPDL
	$('optionImport').addEvent("click", function(e) {
		e.stop();
		doActionConfirm(2);
	});
	//Regenerar Cubo
	$('optionRegCube').addEvent("click", function(e) {
		e.stop();
		if (isCountSelectedOk(false)){
			showModalConfirm(MSG_REG_CUBE,3);
		}				
	});	
	//Regenerar Condiciones
	$('optionRegConds').addEvent("click", function(e) {
		e.stop();
		if (isCountSelectedOk(false)){
			doActionConfirm(4);
		}	
	});
	//Bloquear o Desbloquear
	$('optionLock').addEvent("click", function(e) {
		e.stop();
		if (isCountSelectedOk(false)){
			doActionConfirm(5);
		}	
	});	
	
	onChangeCmbLockFilter($('lockFilter'),false);
	
	
	initAdminActions();	
	initNavButtons();
	initVersionsMdlPage();
	
	setBtnUpdateEventClick();
	
	customizeBtnClone();
	
	callNavigate();
}

function setFilter(){
	callNavigateFilter({
			txtName: $('nameFilter').value,
			txtTitle: $('titleFilter').value,
			txtDesc: $('descFilter').value,					
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value,
			selPrj: $('projectFilter').value,			
			cmbAction: $('actionFilter').value,
			cubeType: $('cubeFilter').value,
			cmbLock: $('lockFilter').value,
			txtLockUsr: $('lockByUsrFilter').value,
			selIsBpmn: $('proBPMNFilter').value
		},null);
}

function onChangeCmbLockFilter(cmb,callSetFilter){
	var lockByUsrFilter = $('lockByUsrFilter');
	var divLockByUstFilter = $('divLockByUstFilter');
	
	if (cmb.value == "2"){
		divLockByUstFilter.setStyle("display","");
	} else {
		divLockByUstFilter.setStyle("display","none");
		lockByUsrFilter.value = "";
		if (callSetFilter){
			setFilter();
		}		
	}
}

function isCountSelectedOk(onlyOne){
	var count = selectionCount($('tableData'));	
	if (count == 0){
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		return false;
	} else if (onlyOne && count > 1){
		showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
	return true;
}

function showModalConfirm(msg,action){
	SYS_PANELS.newPanel();
	var panel = SYS_PANELS.getActive();
	panel.addClass("modalWarning");
	panel.content.innerHTML = msg;
	panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll();doActionConfirm("+action+");\">" + BTN_CONFIRM + "</div>";
	SYS_PANELS.addClose(panel);
	SYS_PANELS.refresh();
}

function doActionConfirm(action){
	action = parseInt(action);
	action = actionsAtConfirm[action];
	
	var selected = getSelectedRows($('tableData'));
	var selection = "";
	for(i=0; i<selected.length; i++){
		var uneditableTR = false;
		
		if(action == 'lockUnlockProc') {
			uneditableTR = (selected[i].get('uneditableTR') == "false" ? true : false) || selected[i].hasClass('uneditableTR');
			
			var img = selected[i].getElement('td').getElement('span').getElement('img');
			if(img && img.get('src').contains('lock'))
				uneditableTR = false;
		} 
		
		if(!uneditableTR) {
			selection += selected[i].getRowId();
			if(i < selected.length - 1)
				selection+=";";
		}
	}
	if(selection != "") {
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=' + action + '&isAjax=true&id=' + selection + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	}
}

function changeCmbImportXPDL(cmb){
	var input = $('entName1');
	var select = $('entName2');
	var inputTr = input.parentNode.parentNode;
	var selectTr = select.parentNode.parentNode;
	
	var fakeName = "xxxxx";
	
	if (cmb.value == "1"){
		//Ocultar combo
		selectTr.setStyle("display","none");
		select.selectedIndex = 0;
		//Mostrar input
		input.value = "";
		inputTr.setStyle("display","");		 
	} else if (cmb.value == "2"){
		//Ocultar input
		inputTr.setStyle("display","none");		 
		input.value = fakeName;
		//Mostrar combo
		selectTr.setStyle("display","");		 
	} else {
		//Ocultar combo e input
		selectTr.setStyle("display","none");		 
		select.selectedIndex = 0;
		inputTr.setStyle("display","none");		 
		input.value = fakeName;
	}
}

function onLoadImportXPDL(){
	var select = $('entName2');	
	var selectTr = select.parentNode.parentNode;
	selectTr.setStyle("display","none");	
	select.selectedIndex = 0;
	cmbProjectOnChange($("project"));
}

function cmbProjectOnChange(cmbProject){
	var chkPermsProj = $("permsProject");
	if (cmbProject.value == "") {
		chkPermsProj.disabled = true;
		chkPermsProj.checked = false;
	} else {
		chkPermsProj.disabled = false;
	}	
}

function requiredEnt(el){
	var visible = el.parentNode.parentNode.style.display == "";
	
	if (!visible) {
		return true;
	} else if (el.value == "" || el.value == null){
		//el.errors.push("Este campo es requerido.");
		el.errors.push(formcheckLanguage.required);
		return false;		
	} else {
		return true;
	}	
}

function setBtnUpdateEventClick(){
	var btnUpdate = $('btnUpdate');
	btnUpdate.removeEvents('click'); //Elimina evento generico para customizarlo
	btnUpdate.addEvent("click", function(e) {
		e.stop();
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var selected = getSelectedRows($('tableData'))[0].getRowId();
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=checkLockProcess&isAjax=true&id=' + selected + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); processUpdateXml(resXml); }
			}).send();
		}
	});	
}

function processUpdateXml(resXml){
	var infoUpdate = resXml.getElementsByTagName("infoUpdate")
	if (infoUpdate != null && infoUpdate.length > 0 && infoUpdate.item(0) != null) {
		infoUpdate = infoUpdate.item(0).getElementsByTagName("result")[0];
		
		var mode = parseInt(infoUpdate.getAttribute("mode"));
		var message = infoUpdate.getAttribute("message");
		
		if (mode == 0 || mode == 1){ //Sin bloquear o Bloqueado por otro usuario
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = message;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); doUpdate(true);\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel);
			SYS_PANELS.refresh();
		} else { //Bloqueado por el usuario actual
			doUpdate(false);
		}				
	}
}

function doUpdate(readOnly){
	readOnly = readOnly ? "true" : "";
	ADMIN_SPINNER.show(true);
	var id = getSelectedRows($('tableData'))[0].getRowId();
	window.location = CONTEXT + URL_REQUEST_AJAX + '?action=update&id=' + id + '&readOnly=' + readOnly + TAB_ID_REQUEST;
}

function customizeBtnClone(){
	var btnClone = $('btnClone');
	if (btnClone) {
		btnClone.removeEvents("click");
		
		btnClone.addEvent("click", function(e) {
			e.stop();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var trSelected = getSelectedRows($('tableData'))[0];
				if (!trSelected.hasClass("isBpmn")){
					showMessage(MSG_SEL_BPMN_CLONE, GNR_TIT_WARNING, 'modalWarning');
				} else {
					var id = trSelected.getRowId();
					var request = new Request({
						method : 'post',
						url : CONTEXT + URL_REQUEST_AJAX + '?action=clone&isAjax=true' + TAB_ID_REQUEST,
						onRequest : function() { SYS_PANELS.showLoading(); },
						onComplete : function(resText, resXml) { SYS_PANELS.closeAll(); modalProcessXml(resXml); }
					}).send('id=' + id);
				}
			}
		});
	}
}

