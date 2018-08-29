var dblClicRow;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	$$('div.fncDescriptionImage').each(function(e){
		if (e.get('src') == '') return;
		var path = 'url(' + e.get('src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});	
	
	dblClicRow = null;
	
	//***************   Init Order By And Filters   ***************
	//Init Order By
	var allOrderBy = getOrders();
	if (allOrderBy.length > 0){ allOrderBy.each(setAdmOrder); allOrderBy.each(setAdmListTitle); }
	//Init No Date Filters
	var filters = getNoDateFilters();
	if (filters.length > 0) { filters.each(setAdmFilters); }
	//Init Date Filters
	filters = getDateFilters();
	if (filters.length > 0) { filters.each(setDateFilters); }
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		clearFilters();
		setFilter();
	});	
	
	$('bodyController').onTabFocus = function() {
		setFilter();
	}
	
	//*********************   Init Buttons   **********************
	//Capturar
	$('btnCap').addEvent("click", function(e) {
		e.stop();
		if (!rowsSelected("isReady")) {
			showMessage(LBL_MUST_SEL_FREE_TSK, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var selected = getSelectedRows($('tableData'));
			var ids = "";
			for (i = 0; i < selected.length; i++) {
				ids += selected[i].getRowId();
				if (i < selected.length - 1) {
					ids += ";";
				}
			}
			
			var row_id = 'id=' + encodeURIComponent(ids);
			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=adquireTasks&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send(row_id);
		}
	});
	//Trabajar
	$('btnWrk').addEvent("click", function(e) {
		if (e) e.stop();
		
		if (dblClicRow == null && selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING,'modalWarning');			
		} else {
			if (dblClicRow == null) {
				var selected = getSelectedRows($('tableData'));
				var ids = "";
				for (i = 0; i < selected.length; i++) {
					ids += selected[i].getRowId();
					if (i < selected.length - 1) {
						ids += ";";
					}
				}
			} else {
				var ids = dblClicRow.getRowId();
				dblClicRow = null;
			}
			
			var row_id = 'id=' + encodeURIComponent(ids);
			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=startWorkTasks&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { sp.show(true); },
				onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); processXmlWorkTasks(resXml); sp.hide(true); }
			}).send(row_id);
		}
	});
	//Liberar
	$('btnRel').addEvent("click", function(e) {
		e.stop();
		if (!rowsSelected("isAdquired")) {
			showMessage(LBL_MUST_SEL_ACQ_TSK, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var selected = getSelectedRows($('tableData'));
			var ids = "";
			for (i = 0; i < selected.length; i++) {
				ids += selected[i].getRowId();
				if (i < selected.length - 1) {
					ids += ";";
				}
			}	
			
			var row_id = 'id=' + encodeURIComponent(ids);
			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=releaseTasks&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send(row_id);
		}
	});
	//Columnas
	$('btnCol').addEvent("click", function(e) {
		e.stop();
		showTskLstColumnsModal(setColumns);
	});
	//Exportar
	$('btnExp').addEvent("click", function(e) {
		e.stop();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=createModalExport&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	});
	/*
	//Transferir
	$('btnTransfer').addEvent("click", function(e) {
		e.stop();
		if(!top.uiChat.isLogged()) {
			showMessage("Debe estar conectado al chat para transferir tareas", "Advertencia", "modalWarning");
			return;
		}
		var sel_count = selectionCount($('tableData'));
		if (sel_count == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');			
		} else if(sel_count > 1) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');			
		} else {	
			var ids = getSelectedRows($('tableData'))[0].getRowId().split('�');
			//Abrir modal, preguntando por la conversaci�n en la que se va a mandar
			
			
			var h = 370;
			var mdlUsrContainer = new Element('div.mdlContainer').setStyles({
				width: 370,
				height: h
			}).set('html', '<div class="mdlHeader">Transferir mediante chat</div>');
			
			var convContainer = new Element('div.mdlBody').setStyles({
				'height': h - 57,
				'overflow': 'auto'
			}).addEvent('click', function(event) {
				if(event.target.hasClass("chat-user")) {
					event.target.getParent().getChildren("div.chat-user").erase('checked').removeClass('selected');
					event.target.set('checked', 'true');
					event.target.addClass('selected');
				}
			});
			
			var conversationKeys = top.uiChat.listConversationsUi.getKeys();
			if(conversationKeys && conversationKeys.length) {
				conversationKeys.each(function(key) {
					new Element('div.chat-user').set('html', top.uiChat.listConversationsUi[key].options.label).set('convid', key).inject(convContainer);
				})
			}
			
			convContainer.inject(mdlUsrContainer);
			new Element('div.mdlFooter').set('html', '<div class="close">' + BTN_CLOSE + '</div><div class="modalButton">' + BTN_CONFIRM + '</div>').inject(mdlUsrContainer).getElement('div.close').addEvent('click', function() {
				mdlUsrContainer.destroy(); 
				blocker.destroy();
			}).getNext('div').addEvent('click', function() {
				//Obtener todos los elementos seleccionados
				var eles = convContainer.getElements('div.chat-user');
				if(eles && eles.length) {
					for(var i = 0; i < eles.length; i++) {
						if(eles[i].get('checked')) {
							var conversation_id = eles[i].get('convid');
							
							top.uiChat.mainUi.options.url.sendCommand(conversation_id, top.TRANSFER_TASK_COMMAND, CURRENT_ENVIRONMENT + " " + ids[0] + " " + ids[1])
							
							//owner.dialog.getElement('span.remover').click();
							break;
						}
					}
				}
				mdlUsrContainer.destroy();
				blocker.destroy();
			});
			var z_index = top.$('tab-2').getStyle('z-index');
			var blocker = new Element('div.chat-mask').setStyle('z-index', z_index).inject(top.document.body);
			mdlUsrContainer.setStyle('z-index', z_index).inject(top.document.body);
			mdlUsrContainer.position();
			
			
		}
	});
	*/
	//Tooltips
	//['btnCap','btnWrk','btnRel','btnCol','btnExp', 'btnTransfer'].each(setTooltip);
	
	//*********************   Table Events   **********************
	$('tableData').getParent().addEvent("dblClic", function(row){
		dblClicRow = row; 
		$('btnWrk').fireEvent('click');
	});
	
	
	//***************   Load No Visible Filters   *****************
	loadNoVisibleFilters();
	$('delAllNVF').tooltip("Eliminar Filtros", { mode: 'auto', width: 100, hook: false });
	$('delAllNVF').addEvent("click", function(e) {
		e.stop();
		this.OBJtooltip.hide();
		$('noVisibleFilters').getElements("div").each(function(nvf){
			deleteNotVisibleFilter(nvf);
		});		
	});
	
	
	initAdminFav();
	initNavButtons();	
	initTskLstColumnsMdlPage();
	
	callNavigate();
	
	//$('gridBody').getElement('table').addEvent('mousedown', tableMouseDown);
	
	table_drag_target = $('gridBody').getElement('table');
	if(!FORBID_TSK_TRANSFER) {
		table_drag_target.addEvent('mousedown', tableMouseDown);
	}
}

/**
 * Cualquier window que defina esta funcion va a ser llamado cuando se acepta la transferencia de una tarea
 */
function fireTaskTransfer() {
	console.log("refreshing table...");
	$('navRefresh').fireEvent('click');
}

var table_drag_target;

function loadNoVisibleFilters(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getNotVisibleFiltersXml&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); processXmlNoVisibleFilters(resXml); sp.hide(true); }
	}).send();
}

function processXmlNoVisibleFilters(ajaxCallXml){
	if (ajaxCallXml != null) {
		var container = $('noVisibleFilters');
		var filters = ajaxCallXml.getElementsByTagName("filters");
		if (filters != null && filters.length > 0 && filters.item(0) != null) {
			filters = filters.item(0).getElementsByTagName("filter");
			
			for(var i = 0; i < filters.length; i++) {
				var filter = filters[i];
				
				var divContainer = new Element("div",{styles: {'margin-top': '3px', 'margin-bottom': '7px'}}).inject(container);
				divContainer.setAttribute("filterName",filter.getAttribute("id"));
				divContainer.setAttribute("filterType",filter.getAttribute("type"));
				
				var remove = new Element("div",{'class': 'removeFilter', html: filter.getAttribute("label") + " = " + filter.getAttribute("value")}).inject(divContainer);
				remove.tooltip(GNR_NAV_ADM_DELETE, { mode: 'auto', width: 100, hook: false });
				remove.addEvent('click', function(evt) { this.OBJtooltip.hide(); deleteNotVisibleFilter(this.parentNode); evt.stopPropagation(); });
				
				$('noVisibleFiltersPanel').setStyle("display","");
			}									
		}
	}	
}

function deleteNotVisibleFilter(nvf){
	var filter = $(nvf.getAttribute("filterName"));
	if (filter){
		filter.value = "";
		if (nvf.getAttribute("filterType") == "DTE"){ filter.getNext().value = ""; }
		setFilter();
	}
	nvf.destroy();
	
	if ($('noVisibleFilters').getElements("div").length == 0){
		$('noVisibleFiltersPanel').setStyle("display","none");
	}
}

function processXmlWorkTasks(ajaxCallXml){
	if (ajaxCallXml != null) {
		var tasks = ajaxCallXml.getElementsByTagName("tasks");
		if (tasks != null && tasks.length > 0 && tasks.item(0) != null) {
			tasks = tasks.item(0).getElementsByTagName("task");
			
			var tabsInfo = new Array();
			var tabContainer = window.parent.document.getElementById('tabContainer');
			
			for(var i = 0; i < tasks.length; i++) {
				var task = tasks[i];
				
				var tabTitle = task.getAttribute("title");
				var url = 'apia.execution.TaskAction.run?action=getTask&proInstId=' + task.getAttribute("proInstId") + '&proEleInstId=' + task.getAttribute("proEleInstId");
				
				tabsInfo[i] = {};
				tabsInfo[i].title = tabTitle;
				tabsInfo[i].url = url;
				tabsInfo[i].fncId = null;
				
				//tabContainer.addNewTab(tabTitle,url,null);
			}
			
			tabContainer.addNewTabs(tabsInfo);
		}
	}
	setTimeout(callNavigateRefresh,3000);
}

function setColumns(columns){
	sp.show(true);
	window.location = CONTEXT + URL_REQUEST_AJAX + '?action=confirmModalColumns&columns=' + columns + TAB_ID_REQUEST;
}

function rowsSelected(className){
	var ret = false;
	getSelectedRows($('tableData')).each(function(row){
		if (row.hasClass(className)){ ret = true; }
	});		
	return ret;
}

function startDownload(){
	SYS_PANELS.closeAll();
	var spinner = new Spinner($('bodyDiv'),{message:WAIT_A_SECOND});
	createDownloadIFrame(TSK_LST,DOWNLOADING,URL_REQUEST_AJAX,"download","","","",null);	
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
		txtWorkMode: $('filterColWorkMode') ? $('filterColWorkMode').value : "",
		txtPriority: $('filterColPri') ? $('filterColPri').value : "",
		txtProStatus: $('filterColProSta') ? $('filterColProSta').value : "",
		txtTskStatus: $('filterColTskSta') ? $('filterColTskSta').value : "",
		txtTskName: $('filterColNom') ? $('filterColNom').value : "",
		txtTskTitle: $('filterColTskTit') ? $('filterColTskTit').value : "",
		txtProIdNum: $('filterColNumPro') ? $('filterColNumPro').value : "",
		txtEntIdNum: $('filterColNumEnt') ? $('filterColNumEnt').value : "",
		txtProName: $('filterColPro') ? $('filterColPro').value : "",
		txtProTitle: $('filterColProTit') ? $('filterColProTit').value : "",
		txtProType: $('filterColTipPro') ? $('filterColTipPro').value : "",
		txtTskGroup: $('filterColGru') ? $('filterColGru').value : "",
		txtTskDte: $('filterColCreTar') ? $('filterColCreTar').value : "",
		txtProDte: $('filterColCrePro') ? $('filterColCrePro').value : "",
		txtProUser: $('filterColCreatePro') ? $('filterColCreatePro').value : "",
		txtEntStatus: $('filterColSta') ? $('filterColSta').value : "",
		txtUser: $('filterColUseAdq') ? $('filterColUseAdq').value : "",
		txtProInstAtt1: $('filterColProInstAtt1') ? $('filterColProInstAtt1').value : "",
		txtProInstAtt2: $('filterColProInstAtt2') ? $('filterColProInstAtt2').value : "",
		txtProInstAtt3: $('filterColProInstAtt3') ? $('filterColProInstAtt3').value : "",
		txtProInstAtt4: $('filterColProInstAtt4') ? $('filterColProInstAtt4').value : "",
		txtProInstAtt5: $('filterColProInstAtt5') ? $('filterColProInstAtt5').value : "",
		txtProInstAttNum1: $('filterColProInstAttNum1') ? $('filterColProInstAttNum1').value : "",
		txtProInstAttNum2: $('filterColProInstAttNum2') ? $('filterColProInstAttNum2').value : "",
		txtProInstAttNum3: $('filterColProInstAttNum3') ? $('filterColProInstAttNum3').value : "",
		txtProInstAttDte1: $('filterColProInstAttDte1') ? $('filterColProInstAttDte1').value : "",
		txtProInstAttDte2: $('filterColProInstAttDte2') ? $('filterColProInstAttDte2').value : "",
		txtProInstAttDte3: $('filterColProInstAttDte3') ? $('filterColProInstAttDte3').value : "",
		txtEntInstAtt1: $('filterColEntInstAtt1') ? $('filterColEntInstAtt1').value : "",
		txtEntInstAtt2: $('filterColEntInstAtt2') ? $('filterColEntInstAtt2').value : "",
		txtEntInstAtt3: $('filterColEntInstAtt3') ? $('filterColEntInstAtt3').value : "",
		txtEntInstAtt4: $('filterColEntInstAtt4') ? $('filterColEntInstAtt4').value : "",
		txtEntInstAtt5: $('filterColEntInstAtt5') ? $('filterColEntInstAtt5').value : "",
		txtEntInstAtt6: $('filterColEntInstAtt6') ? $('filterColEntInstAtt6').value : "",
		txtEntInstAtt7: $('filterColEntInstAtt7') ? $('filterColEntInstAtt7').value : "",
		txtEntInstAtt8: $('filterColEntInstAtt8') ? $('filterColEntInstAtt8').value : "",
		txtEntInstAtt9: $('filterColEntInstAtt9') ? $('filterColEntInstAtt9').value : "",
		txtEntInstAtt10: $('filterColEntInstAtt10') ? $('filterColEntInstAtt10').value : "",
		txtEntInstAttNum1: $('filterColEntInstAttNum1') ? $('filterColEntInstAttNum1').value : "",
		txtEntInstAttNum2: $('filterColEntInstAttNum2') ? $('filterColEntInstAttNum2').value : "",
		txtEntInstAttNum3: $('filterColEntInstAttNum3') ? $('filterColEntInstAttNum3').value : "",
		txtEntInstAttNum4: $('filterColEntInstAttNum4') ? $('filterColEntInstAttNum4').value : "",
		txtEntInstAttNum5: $('filterColEntInstAttNum5') ? $('filterColEntInstAttNum5').value : "",
		txtEntInstAttNum6: $('filterColEntInstAttNum6') ? $('filterColEntInstAttNum6').value : "",
		txtEntInstAttNum7: $('filterColEntInstAttNum7') ? $('filterColEntInstAttNum7').value : "", 
		txtEntInstAttNum8: $('filterColEntInstAttNum8') ? $('filterColEntInstAttNum8').value : "",
		txtEntInstAttDte1: $('filterColEntInstAttDte1') ? $('filterColEntInstAttDte1').value : "",
		txtEntInstAttDte2: $('filterColEntInstAttDte2') ? $('filterColEntInstAttDte2').value : "",
		txtEntInstAttDte3: $('filterColEntInstAttDte3') ? $('filterColEntInstAttDte3').value : "",
		txtEntInstAttDte4: $('filterColEntInstAttDte4') ? $('filterColEntInstAttDte4').value : "",
		txtEntInstAttDte5: $('filterColEntInstAttDte5') ? $('filterColEntInstAttDte5').value : "",
		txtEntInstAttDte6: $('filterColEntInstAttDte6') ? $('filterColEntInstAttDte6').value : ""		
	},null);
}

function getNoDateFilters(){
	var array = new Array();
	var i = 0;
	if ($('filterColPri')) 				{ array[i] = 'filterColPri'; i++; }  
	if ($('filterColProSta')) 			{ array[i] = 'filterColProSta'; i++; }  
	if ($('filterColTskSta'))			{ array[i] = 'filterColTskSta'; i++; }  
	if ($('filterColNom')) 				{ array[i] = 'filterColNom'; i++; }  
	if ($('filterColTskTit')) 			{ array[i] = 'filterColTskTit'; i++; }  
	if ($('filterColNumEnt')) 			{ array[i] = 'filterColNumEnt'; i++; }  
	if ($('filterColNumPro')) 			{ array[i] = 'filterColNumPro'; i++; }  
	if ($('filterColGru')) 				{ array[i] = 'filterColGru'; i++; }  
	if ($('filterColPro')) 				{ array[i] = 'filterColPro'; i++; }  
	if ($('filterColProTit')) 			{ array[i] = 'filterColProTit'; i++; }  
	if ($('filterColTipPro')) 			{ array[i] = 'filterColTipPro'; i++; }  
	if ($('filterColCreatePro')) 		{ array[i] = 'filterColCreatePro'; i++; }  
	if ($('filterColSta')) 				{ array[i] = 'filterColSta'; i++; }  
	if ($('filterColUseAdq')) 			{ array[i] = 'filterColUseAdq'; i++; }  
	if ($('filterColProInstAtt1')) 		{ array[i] = 'filterColProInstAtt1'; i++; }  
	if ($('filterColProInstAtt2')) 		{ array[i] = 'filterColProInstAtt2'; i++; }  
	if ($('filterColProInstAtt3')) 		{ array[i] = 'filterColProInstAtt3'; i++; }  
	if ($('filterColProInstAtt4'))		{ array[i] = 'filterColProInstAtt4'; i++; }  
	if ($('filterColProInstAtt5')) 		{ array[i] = 'filterColProInstAtt5'; i++; }  
	if ($('filterColProInstAttNum1')) 	{ array[i] = 'filterColProInstAttNum1'; i++; }  
	if ($('filterColProInstAttNum2')) 	{ array[i] = 'filterColProInstAttNum2'; i++; }  
	if ($('filterColProInstAttNum3')) 	{ array[i] = 'filterColProInstAttNum3'; i++; }  
	if ($('filterColEntInstAtt1'))		{ array[i] = 'filterColEntInstAtt1'; i++; }  
	if ($('filterColEntInstAtt2')) 		{ array[i] = 'filterColEntInstAtt2'; i++; }  
	if ($('filterColEntInstAtt3')) 		{ array[i] = 'filterColEntInstAtt3'; i++; }  
	if ($('filterColEntInstAtt4')) 		{ array[i] = 'filterColEntInstAtt4'; i++; }  
	if ($('filterColEntInstAtt5')) 		{ array[i] = 'filterColEntInstAtt5'; i++; }  
	if ($('filterColEntInstAtt6')) 		{ array[i] = 'filterColEntInstAtt6'; i++; }  
	if ($('filterColEntInstAtt7')) 		{ array[i] = 'filterColEntInstAtt7'; i++; }  
	if ($('filterColEntInstAtt8')) 		{ array[i] = 'filterColEntInstAtt8'; i++; }  
	if ($('filterColEntInstAtt9')) 		{ array[i] = 'filterColEntInstAtt9'; i++; }  
	if ($('filterColEntInstAtt10')) 	{ array[i] = 'filterColEntInstAtt10'; i++; }  
	if ($('filterColEntInstAttNum1')) 	{ array[i] = 'filterColEntInstAttNum1'; i++; }  
	if ($('filterColEntInstAttNum2')) 	{ array[i] = 'filterColEntInstAttNum2'; i++; }  
	if ($('filterColEntInstAttNum3')) 	{ array[i] = 'filterColEntInstAttNum3'; i++; }  
	if ($('filterColEntInstAttNum4')) 	{ array[i] = 'filterColEntInstAttNum4'; i++; }  
	if ($('filterColEntInstAttNum5')) 	{ array[i] = 'filterColEntInstAttNum5'; i++; }  
	if ($('filterColEntInstAttNum6')) 	{ array[i] = 'filterColEntInstAttNum6'; i++; }  
	if ($('filterColEntInstAttNum7')) 	{ array[i] = 'filterColEntInstAttNum7'; i++; }  
	if ($('filterColEntInstAttNum8')) 	{ array[i] = 'filterColEntInstAttNum8'; i++; }	
	if ($('filterColWorkMode')) 		{ array[i] = 'filterColWorkMode'; i++; }
	return array;
}

function getDateFilters(){
	var array = new Array();
	var i = 0;
	if ($('filterColCreTar')) 			{ array[i] = 'filterColCreTar'; i++; }  
	if ($('filterColCrePro')) 			{ array[i] = 'filterColCrePro'; i++; }  
	if ($('filterColProInstAttDte1')) 	{ array[i] = 'filterColProInstAttDte1'; i++; }  
	if ($('filterColProInstAttDte2')) 	{ array[i] = 'filterColProInstAttDte2'; i++; }  
	if ($('filterColProInstAttDte3')) 	{ array[i] = 'filterColProInstAttDte3'; i++; }  
	if ($('filterColEntInstAttDte1')) 	{ array[i] = 'filterColEntInstAttDte1'; i++; }  
	if ($('filterColEntInstAttDte2')) 	{ array[i] = 'filterColEntInstAttDte2'; i++; }  
	if ($('filterColEntInstAttDte3')) 	{ array[i] = 'filterColEntInstAttDte3'; i++; }  
	if ($('filterColEntInstAttDte4')) 	{ array[i] = 'filterColEntInstAttDte4'; i++; }  
	if ($('filterColEntInstAttDte5')) 	{ array[i] = 'filterColEntInstAttDte5'; i++; }  
	if ($('filterColEntInstAttDte6')) 	{ array[i] = 'filterColEntInstAttDte6'; i++; }	
	return array;
}

function getOrders(){
	var array = new Array();
	var i = 0;	
	if ($('orderByColPri')) 			{ array[i] = 'orderByColPri'; i++; }  
	if ($('orderByColProSta')) 			{ array[i] = 'orderByColProSta'; i++; }  
	if ($('orderByColTskSta'))			{ array[i] = 'orderByColTskSta'; i++; }  
	if ($('orderByColNom')) 			{ array[i] = 'orderByColNom'; i++; }  
	if ($('orderByColTskTit')) 			{ array[i] = 'orderByColTskTit'; i++; }  
	if ($('orderByColNumEnt')) 			{ array[i] = 'orderByColNumEnt'; i++; }  
	if ($('orderByColNumPro')) 			{ array[i] = 'orderByColNumPro'; i++; }  
	if ($('orderByColGru')) 			{ array[i] = 'orderByColGru'; i++; }  
	if ($('orderByColPro')) 			{ array[i] = 'orderByColPro'; i++; }  
	if ($('orderByColProTit')) 			{ array[i] = 'orderByColProTit'; i++; }  
	if ($('orderByColTipPro')) 			{ array[i] = 'orderByColTipPro'; i++; }  
	if ($('orderByColCreTar')) 			{ array[i] = 'orderByColCreTar'; i++; }  
	if ($('orderByColCrePro')) 			{ array[i] = 'orderByColCrePro'; i++; }  
	if ($('orderByColCreatePro')) 		{ array[i] = 'orderByColCreatePro'; i++; }  
	if ($('orderByColSta')) 			{ array[i] = 'orderByColSta'; i++; }  
	if ($('orderByColUseAdq')) 			{ array[i] = 'orderByColUseAdq'; i++; }  
	if ($('orderByColProInstAtt1')) 	{ array[i] = 'orderByColProInstAtt1'; i++; }  
	if ($('orderByColProInstAtt2')) 	{ array[i] = 'orderByColProInstAtt2'; i++; }  
	if ($('orderByColProInstAtt3')) 	{ array[i] = 'orderByColProInstAtt3'; i++; }  
	if ($('orderByColProInstAtt4'))		{ array[i] = 'orderByColProInstAtt4'; i++; }  
	if ($('orderByColProInstAtt5')) 	{ array[i] = 'orderByColProInstAtt5'; i++; }  
	if ($('orderByColProInstAttNum1')) 	{ array[i] = 'orderByColProInstAttNum1'; i++; }  
	if ($('orderByColProInstAttNum2')) 	{ array[i] = 'orderByColProInstAttNum2'; i++; }  
	if ($('orderByColProInstAttNum3')) 	{ array[i] = 'orderByColProInstAttNum3'; i++; }  
	if ($('orderByColProInstAttDte1')) 	{ array[i] = 'orderByColProInstAttDte1'; i++; }  
	if ($('orderByColProInstAttDte2')) 	{ array[i] = 'orderByColProInstAttDte2'; i++; }  
	if ($('orderByColProInstAttDte3')) 	{ array[i] = 'orderByColProInstAttDte3'; i++; }  
	if ($('orderByColEntInstAtt1'))		{ array[i] = 'orderByColEntInstAtt1'; i++; }  
	if ($('orderByColEntInstAtt2')) 	{ array[i] = 'orderByColEntInstAtt2'; i++; }  
	if ($('orderByColEntInstAtt3')) 	{ array[i] = 'orderByColEntInstAtt3'; i++; }  
	if ($('orderByColEntInstAtt4')) 	{ array[i] = 'orderByColEntInstAtt4'; i++; }  
	if ($('orderByColEntInstAtt5')) 	{ array[i] = 'orderByColEntInstAtt5'; i++; }  
	if ($('orderByColEntInstAtt6')) 	{ array[i] = 'orderByColEntInstAtt6'; i++; }  
	if ($('orderByColEntInstAtt7')) 	{ array[i] = 'orderByColEntInstAtt7'; i++; }  
	if ($('orderByColEntInstAtt8')) 	{ array[i] = 'orderByColEntInstAtt8'; i++; }  
	if ($('orderByColEntInstAtt9')) 	{ array[i] = 'orderByColEntInstAtt9'; i++; }  
	if ($('orderByColEntInstAtt10')) 	{ array[i] = 'orderByColEntInstAtt10'; i++; }  
	if ($('orderByColEntInstAttNum1')) 	{ array[i] = 'orderByColEntInstAttNum1'; i++; }  
	if ($('orderByColEntInstAttNum2')) 	{ array[i] = 'orderByColEntInstAttNum2'; i++; }  
	if ($('orderByColEntInstAttNum3')) 	{ array[i] = 'orderByColEntInstAttNum3'; i++; }  
	if ($('orderByColEntInstAttNum4')) 	{ array[i] = 'orderByColEntInstAttNum4'; i++; }  
	if ($('orderByColEntInstAttNum5')) 	{ array[i] = 'orderByColEntInstAttNum5'; i++; }  
	if ($('orderByColEntInstAttNum6')) 	{ array[i] = 'orderByColEntInstAttNum6'; i++; }  
	if ($('orderByColEntInstAttNum7')) 	{ array[i] = 'orderByColEntInstAttNum7'; i++; }  
	if ($('orderByColEntInstAttNum8')) 	{ array[i] = 'orderByColEntInstAttNum8'; i++; }  
	if ($('orderByColEntInstAttDte1')) 	{ array[i] = 'orderByColEntInstAttDte1'; i++; }  
	if ($('orderByColEntInstAttDte2')) 	{ array[i] = 'orderByColEntInstAttDte2'; i++; }  
	if ($('orderByColEntInstAttDte3')) 	{ array[i] = 'orderByColEntInstAttDte3'; i++; }  
	if ($('orderByColEntInstAttDte4')) 	{ array[i] = 'orderByColEntInstAttDte4'; i++; }  
	if ($('orderByColEntInstAttDte5')) 	{ array[i] = 'orderByColEntInstAttDte5'; i++; }  
	if ($('orderByColEntInstAttDte6')) 	{ array[i] = 'orderByColEntInstAttDte6'; i++; }
	if ($('orderByColWorkMode')) 		{ array[i] = 'orderByColWorkMode'; i++; }
	return array;
}

function clearFilters(){
	/*if ($('filterColPri')) 				{ $('filterColPri').value = ""; }  
	if ($('filterColProSta')) 			{ $('filterColProSta').value = ""; }  
	if ($('filterColTskSta'))			{ $('filterColTskSta').value = ""; }  
	if ($('filterColNom')) 				{ $('filterColNom').value = ""; }  
	if ($('filterColTskTit')) 			{ $('filterColTskTit').value = ""; }  
	if ($('filterColNumEnt')) 			{ $('filterColNumEnt').value = ""; }  
	if ($('filterColNumPro')) 			{ $('filterColNumPro').value = ""; }  
	if ($('filterColGru')) 				{ $('filterColGru').value = ""; }  
	if ($('filterColPro')) 				{ $('filterColPro').value = ""; }  
	if ($('filterColProTit')) 			{ $('filterColProTit').value = ""; }  
	if ($('filterColTipPro')) 			{ $('filterColTipPro').value = ""; }  
	if ($('filterColCreTar')) 			{ $('filterColCreTar').value = ""; $('filterColCreTar').getNext().value = ""; }  
	if ($('filterColCrePro')) 			{ $('filterColCrePro').value = ""; $('filterColCrePro').getNext().value = ""; }  
	if ($('filterColCreatePro')) 		{ $('filterColCreatePro').value = ""; }  
	if ($('filterColSta')) 				{ $('filterColSta').value = ""; }  
	if ($('filterColUseAdq')) 			{ $('filterColUseAdq').value = ""; }  
	if ($('filterColProInstAtt1')) 		{ $('filterColProInstAtt1').value = ""; }  
	if ($('filterColProInstAtt2')) 		{ $('filterColProInstAtt2').value = ""; }  
	if ($('filterColProInstAtt3')) 		{ $('filterColProInstAtt3').value = ""; }  
	if ($('filterColProInstAtt4'))		{ $('filterColProInstAtt4').value = ""; }  
	if ($('filterColProInstAtt5')) 		{ $('filterColProInstAtt5').value = ""; }  
	if ($('filterColProInstAttNum1')) 	{ $('filterColProInstAttNum1').value = ""; }  
	if ($('filterColProInstAttNum2')) 	{ $('filterColProInstAttNum2').value = ""; }  
	if ($('filterColProInstAttNum3')) 	{ $('filterColProInstAttNum3').value = ""; }  
	if ($('filterColProInstAttDte1')) 	{ $('filterColProInstAttDte1').value = ""; $('filterColProInstAttDte1').getNext().value = ""; }  
	if ($('filterColProInstAttDte2')) 	{ $('filterColProInstAttDte2').value = ""; $('filterColProInstAttDte2').getNext().value = ""; }  
	if ($('filterColProInstAttDte3')) 	{ $('filterColProInstAttDte3').value = ""; $('filterColProInstAttDte3').getNext().value = ""; }  
	if ($('filterColEntInstAtt1'))		{ $('filterColEntInstAtt1').value = ""; }  
	if ($('filterColEntInstAtt2')) 		{ $('filterColEntInstAtt2').value = ""; }  
	if ($('filterColEntInstAtt3')) 		{ $('filterColEntInstAtt3').value = ""; }  
	if ($('filterColEntInstAtt4')) 		{ $('filterColEntInstAtt4').value = ""; }  
	if ($('filterColEntInstAtt5')) 		{ $('filterColEntInstAtt5').value = ""; }  
	if ($('filterColEntInstAtt6')) 		{ $('filterColEntInstAtt6').value = ""; }  
	if ($('filterColEntInstAtt7')) 		{ $('filterColEntInstAtt7').value = ""; }  
	if ($('filterColEntInstAtt8')) 		{ $('filterColEntInstAtt8').value = ""; }  
	if ($('filterColEntInstAtt9')) 		{ $('filterColEntInstAtt9').value = ""; }  
	if ($('filterColEntInstAtt10')) 	{ $('filterColEntInstAtt10').value = ""; }  
	if ($('filterColEntInstAttNum1')) 	{ $('filterColEntInstAttNum1').value = ""; }  
	if ($('filterColEntInstAttNum2')) 	{ $('filterColEntInstAttNum2').value = ""; }  
	if ($('filterColEntInstAttNum3')) 	{ $('filterColEntInstAttNum3').value = ""; }  
	if ($('filterColEntInstAttNum4')) 	{ $('filterColEntInstAttNum4').value = ""; }  
	if ($('filterColEntInstAttNum5')) 	{ $('filterColEntInstAttNum5').value = ""; }  
	if ($('filterColEntInstAttNum6')) 	{ $('filterColEntInstAttNum6').value = ""; }  
	if ($('filterColEntInstAttNum7')) 	{ $('filterColEntInstAttNum7').value = ""; }  
	if ($('filterColEntInstAttNum8')) 	{ $('filterColEntInstAttNum8').value = ""; }  
	if ($('filterColEntInstAttDte1')) 	{ $('filterColEntInstAttDte1').value = ""; $('filterColEntInstAttDte1').getNext().value = ""; }  
	if ($('filterColEntInstAttDte2')) 	{ $('filterColEntInstAttDte2').value = ""; $('filterColEntInstAttDte2').getNext().value = ""; }  
	if ($('filterColEntInstAttDte3')) 	{ $('filterColEntInstAttDte3').value = ""; $('filterColEntInstAttDte3').getNext().value = ""; }  
	if ($('filterColEntInstAttDte4')) 	{ $('filterColEntInstAttDte4').value = ""; $('filterColEntInstAttDte4').getNext().value = ""; }  
	if ($('filterColEntInstAttDte5')) 	{ $('filterColEntInstAttDte5').value = ""; $('filterColEntInstAttDte5').getNext().value = ""; }  
	if ($('filterColEntInstAttDte6')) 	{ $('filterColEntInstAttDte6').value = ""; $('filterColEntInstAttDte6').getNext().value = ""; }  
	if ($('filterColWorkMode')) 		{ $('filterColWorkMode').value = ""; }
	*/
	getNoDateFilters().each(clearFilter);
	getDateFilters().each(clearFilterDate);
	
	$('noVisibleFilters').getElements("div").each(function(div){ div.destroy(); });
	$('noVisibleFiltersPanel').setStyle("display","none");	
}

/*
function tableMouseDown(evt) {
	console.log("mousedown");
	evt.stop();
	evt.event.currentTarget.addEvent('mousemove', tableMouseMove);
	document.body.addEvent('mouseup', tableMouseUp);
}

var ico;

function tableMouseMove(evt) {
	console.log("mousemove");
	evt.event.currentTarget.removeEvent('mousemove', tableMouseMove);
	ico = new Element('div.drag-task').setStyles({
		top: evt.client.y,
		left: evt.client.x
	}).inject(document.body);
	
	if(window.frameElement && window.frameElement.getElement('body'))
		window.frameElement.getElement('body').addEvent('mousemove', dragTask);
	else 
		document.body.addEvent('mousemove', dragTask);
}

function dragTask(evt) {
	ico.setStyle('top', evt.client.y - 5);
	ico.setStyle('left', evt.client.x - 5);
}

function tableMouseUp(evt) {
	if(window.frameElement && window.frameElement.getElement('body'))
		window.frameElement.getElement('body').removeEvent('mousemove', dragTask);
	else 
		document.body.removeEvent('mousemove', dragTask);
	
	ico.destroy();
}
*/
function tableMouseDown(event) {
	event.stop();
	table_drag_target.addEvent('mousemove', tableMouseMove);
	document.body.addEvent('mouseup', tableMouseUp);
}

function tableMouseUp(event) {
	event.stop();
	table_drag_target.removeEvent('mousemove', tableMouseMove);
	document.body.removeEvent('mouseup', tableMouseUp);
}

var ico;
var aux;
var aux_coordinates;
var parent_body;
var THRESHOLD = 15;
	
function tableMouseMove(event) {
	//window.frameElement.getParent('body').fireEvent('dragtask', event);
	
	table_drag_target.removeEvent('mousemove', tableMouseMove);
	document.body.removeEvent('mouseup', tableMouseUp);
	
	event.stop();
	
	event.target.getParent('tr').fireEvent('click');
	/*
	parent_body = window.frameElement.getParent('body');
	
	ico = new Element('div.drag-task').setStyles({
		top: event.client.y - 24,
		left: event.client.x - 24,
		opacity: 0.7,
		position: 'absolute'
    }).inject(parent_body);
	
	
	aux = parent_body.getElements('div.chatContent');
	aux.addEvent('mouseover', chatMouseEnter);
	
	document.body.addEvent('mousemove', dragTask);
	document.body.addEvent('mouseup', dragTaskEnd);
	
	*/
	
	var clone = new Element('div.drag-task').setStyles({
		top: event.client.y - 24,
		left: event.client.x - 24,
		opacity: 0.7,
		position: 'absolute'
    }).inject(document.body);
	
	/*
	var aux = window.frameElement.getParent('body').getElements('div.chatContent');
	aux_coordinates = [];
	aux.each(function(item, index) {
		aux_coordinates[index] = item.getCoordinates();
	});
	aux.addEvent('mouseover', chatMouseEnter);
	
	document.body.addEvent('mousemove', function(evt) {
		var i;
		aux.setStyle('background-color', '');
		for(i = 0; i < aux_coordinates.length; i++) {
			if(evt.client.x > aux_coordinates[i].left - THRESHOLD && evt.client.x < aux_coordinates[i].left + aux_coordinates[i].width + THRESHOLD &&
					evt.client.y > aux_coordinates[i].top - THRESHOLD && evt.client.y < aux_coordinates[i].top + aux_coordinates[i].height + THRESHOLD) {
				aux[i].setStyle('background-color', 'red');
			}
		}
	});

	//Se hace un custom drag, porque los droppables est�n en otro iframe
    var drag = new Drag.Move(clone, {

      droppables: [],

      onDrop: function(dragging, cart) {
        dragging.destroy();
       
        setTimeout(function() {
        	aux.removeEvent('mouseover', chatMouseEnter);
        }, 50);
        
      },
      onEnter: function(dragging, cart){
    	//console.log('onEnter');
        //cart.tween('background-color', '#98B5C1');
      },
      onLeave: function(dragging, cart){
        //cart.tween('background-color', '#FFF');
      },
      onCancel: function(dragging){
          dragging.destroy();
    	  aux.removeEvent('mouseover', chatMouseEnter);
      }
    });
    drag.start(event);
    */
	
	var aux = window.frameElement.getParent('body').getElements('div.chat-window');
	var dropps = [];
	aux.each(function(chat) {
		var chat_clone = chat.clone();
		var chatContent = chat_clone.getElement('div.chatContent').set('html', '');
		new Element('div').setStyles({
			display: 'block',
			width: '100%',
			height: 10
		}).inject(chatContent);
		new Element('div.chat-droppable', {html: '<div class="chat-droppable-text">' + LBL_DROP_TASK + '</div>'}).inject(chatContent);
		chat_clone.inject(document.body);
		dropps.push(chat_clone);
		chat.setStyle('display', 'none');
	})
	
	//Se hace un custom drag, porque los droppables est�n en otro iframe
    var drag = new Drag.Move(clone, {

      droppables: dropps,

      onDrop: function(dragging, cart) {
        dragging.destroy();
        
        for(var i = dropps.length -1; i >= 0; i--) {
        	if(cart == dropps[i]) {
        		transfer(cart.getElement('div.chatContent').get('cid'));
        	}
        	dropps[i].destroy();
        	if(aux[i].getElement('div.chat-content').getStyle('display') == 'none')
        		aux[i].getElement('span.minimizer').fireEvent('click');
        	aux[i].setStyle('display', '');
        }        
      },
      onEnter: function(dragging, cart) {
    	if(cart.getElement('div.chat-content').getStyle('display') == 'none') {
    		//abrir el chat
    		cart.getElement('div.chat-content').setStyle('display', '');
    		cart.setStyle('height', '');
    	}
    	
        cart.getElement('div.chat-droppable').tween('border-color', '#707070');
        
      },
      onLeave: function(dragging, cart){
    	cart.getElement('div.chat-droppable').tween('border-color', '#E0E0E0');
      },
      onCancel: function(dragging){
          dragging.destroy();
          for(var i = dropps.length -1; i >= 0; i--) {
          	dropps[i].destroy();
          	aux[i].setStyle('display', '');
          }    
    	  //aux.removeEvent('mouseover', chatMouseEnter);
      }
    });
    drag.start(event);
}
/*
function dragTask(evt) {
	ico.setStyle('top', evt.client.y - 24);
	ico.setStyle('left', evt.client.x - 24);
}

function dragTaskEnd() {
	document.body.removeEvent('mousemove', dragTask);
	document.body.removeEvent('mouseup', dragTaskEnd);
	aux.removeEvent('mouseover', chatMouseEnter);
	ico.destroy();
	//TODO: Procesar el drop
}
*/
/*
function chatMouseEnter(event) {
	
	//console.log("Mouse enter");
	
	event.stop();
	
	//return;
	
	if(!top.uiChat.isLogged()) {
		showMessage("Debe estar conectado al chat para transferir tareas", "Advertencia", "modalWarning");
		return;
	}
	var sel_count = selectionCount($('tableData'));
	if (sel_count == 0) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');			
	} else if(sel_count > 1) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');			
	} else {	
		var ids = getSelectedRows($('tableData'))[0].getRowId().split('�');
		//Abrir modal, preguntando por la conversaci�n en la que se va a mandar
		var conversation_id = event.event.currentTarget.getNext().owner.options.id
		top.uiChat.mainUi.options.url.sendCommand(conversation_id, top.TRANSFER_TASK_COMMAND, CURRENT_ENVIRONMENT + " " + ids[0] + " " + ids[1])
	}
}
*/
function transfer(conversation_id) {
	if(!top.uiChat.isLogged()) {
		showMessage(ERR_TSK_TRANSFER_NOT_IN_CHAT, GNR_TIT_WARNING, "modalWarning");
		return;
	}
	var table_data = $('tableData');
	var sel_count = selectionCount(table_data);
	if (sel_count == 0) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
	} else if(sel_count > 1) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
	} else {
		var ids = getSelectedRows(table_data)[0].getRowId().split('�');
		top.uiChat.mainUi.options.url.sendCommand(conversation_id, top.TRANSFER_TASK_COMMAND, CURRENT_ENVIRONMENT + " " + ids[0] + " " + ids[1])
	}
}