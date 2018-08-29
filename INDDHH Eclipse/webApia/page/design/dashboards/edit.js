
var cantSections;
var pnlSelectedOpts;
var templateSelected;
var PANEL_OPTIONS_MODAL_HIDE_OVERFLOW  = true;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});

	confirmChangeTemplate($('dshTemp').value);	
	
	
	var dshImage = $('dshImage');
	if (dshImage) {
		dshImage.addEvent('click', function(evt) {
			showImagesModal(processModalImageConfirm,null);
		});
	}
	
	var btnResetImage = $('btnResetImage');
	if(btnResetImage) {
		btnResetImage.addEvent('click', function(evt) {
			var path = CONTEXT + '/images/uploaded/' + DEFAULT_IMAGE;
			$('dshImage').setStyle('background-image', 'url(' + path + ')');
			$('imgPath').value = DEFAULT_IMAGE;		
		});
	}
	
	var btnResetDshConf = $('btnResetDsh'); 
	if (btnResetDshConf) {
		btnResetDshConf.addEvent('click', function(e) {
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=reloadDashboardForUsers&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		})
	}
	
	if ($('btnConf') && !MODE_CREATE) {
		btnResetDshConf.style.display = '';
	} else if (!MODE_CREATE) {
		btnResetDshConf.style.display = 'none';
	}
	
	if ($('flagLand').checked) {
		document.getElementById("flagLandDef").disabled = false;
	}
	else {
		document.getElementById("flagLandDef").disabled = true;
	}		

	$('btnAddPnl').addEvent('click',function(e){
		e.stop();
		if (selectionCount($('tableDataDshPnls')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');			
		} else if (selectionCount($('tableDataDshPnls')) > 1){
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			ADDITIONAL_INFO_IN_TABLE_DATA = false;
			PANELMODAL_SELECTONLYONE = false;
			showPanelsModal(processPnlMdlRet);
		}		
	});
	['btnAddPnl'].each(setTooltip);

	
	
	
	pnlSelectedOpts = null;

	templateSelected = $('dshTemp').value;
	if (MODE_CREATE){
		cmbDshTempOnChange($('dshTemp'));
	}

//	onChangeLanging($('flagLand'));

	initAdminActionsEdition(executeBeforeConfirm);
	initAdminFav();
	initPanelMdlPage();
	initOptionsMdlPage();

	initEnvMdlPage();
	initProcMdlPage();
	initTaskMdlPage();
	initPoolMdlPage();
	initEntMdlPage();
	initCatMdlPage();
	initDashboardsMdlPage();
	initImgMdlPage();
	initAttMdlPage();
	initPrfMdlPage();
	
	initPermissions(true /*hide Project permissions */);	
	initAdminFieldOnChangeHighlight(false, false, false);
}

function getCantPanels(){
	var cant = 0;
	$('tableDataDshPnls').getElements("tr").each(function (tr){
		cant += tr.getElements("div.option").length;
	});
	return cant;
}


function cmbDshTempOnChange(cmbDshTemp){
	var idTemp = cmbDshTemp.value;
	var tooltip = cmbDshTemp.options[cmbDshTemp.selectedIndex].getAttribute("title");
	cmbDshTemp.title = tooltip;
	var cantPanels = getCantPanels();
	if (cantPanels > 0){
		SYS_PANELS.newPanel();
		var panel = SYS_PANELS.getActive();
		panel.addClass("modalWarning");
		panel.header.innerHTML = GNR_TIT_WARNING;
		panel.content.innerHTML = MSG_REM_PNLS;
		panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); confirmChangeTemplate("+idTemp+");\">" + BTN_CONFIRM + "</div>";
		SYS_PANELS.addClose(panel,true,"cancelChangeTemplate");
		SYS_PANELS.refresh();
	} else {
		confirmChangeTemplate(idTemp);	
	}
}

function cancelChangeTemplate(){
	$('dshTemp').value = templateSelected;
}

function confirmChangeTemplate(idTemp){
	templateSelected = $('dshTemp').value;
	var spTempView = new Spinner($('divTemplateView'));
	spTempView.show(true);
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadXmlHomePageTemplate&isAjax=true&id=' + idTemp + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { processXmlReturnTemplate(resXml); spTempView.hide(true); }
	}).send();	
}

function processXmlReturnTemplate(resXml){
	var homePageTemplate = resXml.getElementsByTagName("homePageTemplate")
	if (homePageTemplate != null && homePageTemplate.length > 0 && homePageTemplate.item(0) != null) {
		var xmlHtml = homePageTemplate.item(0).getElementsByTagName("html")[0];
		var xmlSections = homePageTemplate.item(0).getElementsByTagName("sections")[0];

		$('tempHtml').innerHTML = xmlHtml.getAttribute("value");
		cantSections = xmlSections.getAttribute("value");
	}
	loadPanels();
}

function cleanSections(){
	$('tableDataDshPnls').getElements("tr").each(function (tr){
		tr.destroy();
	});
	cleanRespOrderItems();
}

function loadPanels(){
	var spSections = new Spinner($('gridBody'));
	spSections.show(true);

	cleanSections();	

	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadPanels&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { 
			processXmlReturnPanels(resXml); spSections.hide(true);
			
			initAdminModalHandlerOnChangeHighlight($('tableDataDshPnls'), true);
		}
	}).send();
}

function processXmlReturnPanels(resXml){
	var tableData = $('tableDataDshPnls');

	var sections = resXml.getElementsByTagName("sections")
	if (sections != null && sections.length > 0 && sections.item(0) != null) {
		//sections = sections.item(0).getElements("section");
		sections = sections.item(0).getElementsByTagName("section");

		/* Grid */
		var thead = tableData.getParent().getFirst("thead");
		var theadTr = thead ? thead.getFirst("tr") : null;
		var headers = theadTr ? thead.getElements("th") : null;
		var tdWidths = headers ? new Array(headers.length) : null;

		if (headers) {
			for (var i = 0; i < headers.length; i++) {
				tdWidths[i] = headers[i].style.width;
				if (! tdWidths[i]) tdWidths[i] = headers[i].width;
				if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
			}
		}		

		/* Sections */
		for(var i = 0; i < sections.length; i++){
			var xmlSection = sections[i];

			var tr = getObjTrSection(xmlSection.getAttribute("sectionNum"));

			if (tr == null){
				tr = new Element("tr", {'class': 'selectableTR'});
				if (i % 2 == 0){ tr.addClass("trOdd"); }
				if (i == (sections.length -1)) { tr.addClass("lastTr"); }
				tr.setAttribute("rowId", xmlSection.getAttribute("sectionNum"));
				tr.setStyle("height","40px");
				tr.getRowId = function () { return this.getAttribute("rowId"); };
				tr.addEvent("click", function(evt) {
					$('tableDataDshPnls').getElements('tr').each(function (t){ t.removeClass('selectedTR'); });
					this.toggleClass("selectedTR"); 
					if (evt) { evt.stopPropagation(); } 
				});
				tr.setAttribute('id','trRowSec_'+xmlSection.getAttribute("sectionNum"));
				tr.inject(tableData);			

				/* td Section */
				var tdSection = new Element("td", { text: xmlSection.getAttribute("name"), 'styles': {width: tdWidths[0]} } );
				tdSection.inject(tr);

				/* td Panels */
				var tdPanels = new Element("td", { 'class': 'modalOptionsContainer', 'styles': {width: tdWidths[1]} } );
				tdPanels.inject(tr);			

			} else { //add panel from modal
				var tdPanels = tr.getElements("td")[1]; 
			}

			var panels = xmlSection.getElementsByTagName("panels")[0].getElementsByTagName("panel");
			for(var j = 0; j < panels.length; j++){
				/* Panel */
				var xmlPanel = panels[j];
				var objPanel = createPanel(xmlPanel);

				//Insert ordenado por posicion
				var nextObjPanel = getNextObjPanel(tdPanels,objPanel.getAttribute("pnlPosition"));
				if (nextObjPanel == null){
					objPanel.inject(tdPanels);
				} else {
					objPanel.inject(nextObjPanel,"before");
				}				

				tr.store(objPanel.getAttribute("pnlPosition"),objPanel);
			}			
		}		
	}	

	addScrollTable(tableData);

	loadDshPnlResponsive();
}

function getObjTrSection(sectNum){
	sectNum = parseInt(sectNum);
	var retTr = null;
	var trs = $('tableDataDshPnls').getElements("tr");
	for(var i = 0; i < trs.length; i++){
		var tr = trs[i];
		if (parseInt(tr.getRowId()) == sectNum){
			return tr; 
		}
	}	
	return retTr;
}

function getNextObjPanel(objTd,pnlPos){
	var next = null;
	pnlPos = parseInt(pnlPos);
	var pnlPosAux = getNextPosition(objTd.parentNode);
	objTd.getElements("div.option").each(function (pnl){
		var pnlPosActual = parseInt(pnl.getAttribute("pnlPosition")); 
		if (pnlPosActual > pnlPos && pnlPosActual < pnlPosAux){
			next = pnl;
			pnlPosAux = pnlPosActual;
		}
	});
	return next;
}

function createPanel(xmlPanel){
	/* Panel */
	var objPanel = new Element("div.option.optionWidth30.forceAlignOption", {
		title: xmlPanel.getAttribute("name"),
		'data-pnlId': xmlPanel.getAttribute("id"),
		pnlName: xmlPanel.getAttribute("name"),
		pnlDesc: xmlPanel.getAttribute("description"),
		pnlSection: xmlPanel.getAttribute("section"),
		pnlPosition: xmlPanel.getAttribute("position"),
		pnlOpRemove: xmlPanel.getAttribute("remove"),
		pnlOpVisible: xmlPanel.getAttribute("visible"),
		pnlOpVisibleInSitemap: xmlPanel.getAttribute("visibleInSitemap"),
		pnlOpEdit: xmlPanel.getAttribute("edit"),
		tempId: xmlPanel.getAttribute("tempId")
	});

	objPanel.addClass("panel_"+xmlPanel.getAttribute("tempId"));

	new Element("div.text",{text: xmlPanel.getAttribute("name")}).inject(objPanel);

	//Remover
//	objPanel.addEvent('click', function(evt) { removePanel(this); evt.stopPropagation(); });	

	//Opciones
	var opts = new Element("div.optionIcon.optionModify").addEvent('click', function(evt) { 
		var section = this.getParent().get('pnlSection');
		var tr = $('trRowSec_' + section);
		tr.fireEvent('click');
		showPanelOptions(this.getParent()); 
		evt.stopPropagation(); 
	}).inject(objPanel);
	
	new Element('div.optionRemove').setStyle('margin-top', "-13px").addEvent('click', removePanel).inject(objPanel);

	/* Parametros del panel */
	var parameters = xmlPanel.getElementsByTagName("parameters");
	if (parameters != null && parameters.length > 0 && parameters.item(0) != null) {
		parameters = parameters.item(0).getElementsByTagName("parameter");

		var arrayPnlParams = new Array();
		for (var i = 0; i < parameters.length; i++){
			var xmlParam = parameters[i];

			var arrPosVal = new Array();

			if (xmlParam.getAttribute("viewType") == PNL_PARAM_VIEW_TYPE_COMBOBOX || 
					xmlParam.getAttribute("viewType") == PNL_PARAM_VIEW_TYPE_MDL_ENV  || 
					xmlParam.getAttribute("viewType") == PNL_PARAM_VIEW_TYPE_MDL_PRO  ||
					xmlParam.getAttribute("viewType") == PNL_PARAM_VIEW_TYPE_MDL_ENT  ||
					xmlParam.getAttribute("viewType") == PNL_PARAM_VIEW_TYPE_MDL_CAT  ||
					xmlParam.getAttribute("viewType") == PNL_PARAM_VIEW_TYPE_MDL_TSK  ||
					xmlParam.getAttribute("viewType") == PNL_PARAM_VIEW_TYPE_MDL_DSH  || 
					xmlParam.getAttribute("viewType") == PNL_PARAM_VIEW_TYPE_MDL_ATT  ||
					xmlParam.getAttribute("viewType") == PNL_PARAM_VIEW_TYPE_MDL_POOL ||
					xmlParam.getAttribute("viewType") == PNL_PARAM_VIEW_TYPE_MDL_PRF  ||
					xmlParam.getAttribute("viewType") == PNL_PARAM_VIEW_TYPE_MDL_IMG){
				var xmlPosValCmb = xmlParam.getElementsByTagName("posValue");

				if (xmlPosValCmb != null && xmlPosValCmb.length > 0){
					for (var j = 0; j < xmlPosValCmb.length; j++){
						var xmlPosVal = xmlPosValCmb[j];
						var posVal = {
							value : xmlPosVal.getAttribute("value"),
							text  : xmlPosVal.getAttribute("text"),
							path  : xmlPosVal.getAttribute("path")
						}
						arrPosVal.push(posVal);

					}
				}
			}

			var param = {
				id : xmlParam.getAttribute("id"),
				name : xmlParam.getAttribute("name"),
				type : xmlParam.getAttribute("type"),
				value : xmlParam.getAttribute("value"),
				viewType : xmlParam.getAttribute("viewType"),
				description : xmlParam.getAttribute("description"),
				posValues : arrPosVal
			}
			arrayPnlParams.push(param);			
		}
		objPanel.store('parameters',arrayPnlParams);
	}

	/* Grupos que pueden ver el panel */
	var arrPools = new Array(); 
	var pools = xmlPanel.getElementsByTagName("pools");
	if (pools != null && pools.length > 0 && pools.item(0) != null) {
		pools = pools.item(0).getElementsByTagName("pool");

		for (var i = 0; i < pools.length; i++){
			var xmlPool = pools[i];
			var p = {'id':xmlPool.getAttribute("id"),'name':xmlPool.getAttribute("name")};
			arrPools.push(p);
		}
	}
	objPanel.store('pools',arrPools);

	return objPanel;
}

function removePanel(evt){
	var objPanel = evt.target.getParent();
	if (objPanel){
		var tr = getObjTrSection(objPanel.getAttribute("pnlSection"));
		tr.store(objPanel.getAttribute("pnlPosition"),null);

		var tempId = objPanel.getAttribute("tempId");
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=removePanel&isAjax=true&tempId=' + tempId + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();

		objPanel.destroy();

		removeDshPnlResponsive(tempId);

		addScrollTable($('tableDataDshPnls'));
		
		//Se marca la sección como modificada
		tr.getElement('td').addClass('highlighted custom-highlighted');
	}
}

function updatePanel(objPanel){
	if (objPanel){
		var tempId = objPanel.getAttribute("tempId");
		var pnlPos = objPanel.getAttribute("pnlPosition");
		var flags = (objPanel.getAttribute("pnlOpEdit")=="true"?"1":"0") + 
					(objPanel.getAttribute("pnlOpVisible")=="true"?"1":"0") + 
					(objPanel.getAttribute("pnlOpRemove")=="true"?"1":"0") +
					(objPanel.getAttribute("pnlOpVisibleInSitemap")=="true"?"1":"0");

		var params = "";
		var arrParams = objPanel.retrieve('parameters');
		if (arrParams != null && arrParams.length > 0){
			for (var i = 0; i < arrParams.length; i++){
				var pnlParam = arrParams[i];
				if (params != "") params += ";";
				params += pnlParam.id + PRIMARY_SEPARATOR + pnlParam.type + PRIMARY_SEPARATOR + pnlParam.value;
			}
		}

		var pools = "";
		var arrPools = objPanel.retrieve('pools');
		if (arrPools != null && arrPools.length > 0){
			for (var i = 0; i < arrPools.length; i++){
				var p = arrPools[i];
				if (pools != "") pools += ";";
				pools += p.id + PRIMARY_SEPARATOR + p.name;
			}
		}

		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=updatePanel&isAjax=true&tempId=' + tempId + '&pnlPos=' + pnlPos + '&flags=' + flags + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send('&params=' + encodeURIComponent(params) + '&pools=' + pools);
	}
}

function showPanelOptions(objPanel){
	pnlSelectedOpts = objPanel;
	var positions = getAvailablePositions(objPanel);
	showOptionsModal(objPanel,positions,updatePosition);
}

function updatePosition(positions){ // positions = {'lastPos': lastPos,'newPos':newPos}
	var lastPos = positions.lastPos; 
	var newPos = positions.newPos;
	if (lastPos != newPos){
		var tr = getSelectedRows($('tableDataDshPnls'))[0];
		tr.store(lastPos,null);
		tr.store(newPos,pnlSelectedOpts);
	}

	updatePanel(pnlSelectedOpts);
	
	//Si se modifica algún parámetro, el panel queda marcado como modificado
	var modElements = $('mdlOptionsContainer').getElements('*.highlighted');
	if (modElements.length>0){
		pnlSelectedOpts.addClass('highlighted');
	}
	
	if(PANEL_OPTIONS_MODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', '');
	}
}

function getAvailablePositions(objPanel){
	var positions = new Array();
	if (objPanel){
		var tr = getObjTrSection(objPanel.getAttribute("pnlSection"));
		var nextPos = getNextPosition(tr);
		var space = false;

		positions.push(null); //no usado, pos = 0		

		for (var i = 1; i < nextPos; i++){
			var key = String(i);
			if (tr.retrieve(key) == null){
				positions.push(true); //libre
				space = true; 
			} else {
				positions.push(false); //usada				
			}
		}
		if (parseInt(objPanel.getAttribute("pnlPosition")) != nextPos-1){ //no es el ultimo panel
			positions.push(true); //nextPos
		}

		positions[parseInt(objPanel.getAttribute("pnlPosition"))] = true; //habilito la Position actual del panel 
	}	
	return positions;
}

function processPnlMdlRet(ret){
	var ids = ""
		ret.each(function (panel){
			if (ids != "") ids += ";";
			ids += panel.getRowId();
		});
	if (ids != ""){
		var spSections = new Spinner($('gridBody'));
		spSections.show(true);

		var trSelected = getSelectedRows($('tableDataDshPnls'))[0];
		var sectNum = trSelected.getRowId();
		var nextPos = getNextPosition(trSelected);
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=addPanels&isAjax=true&sectNum=' + sectNum + '&id=' + ids + '&nextPos=' + nextPos + TAB_ID_REQUEST,
			onRequest: function() { },
			onComplete: function(resText, resXml) { processXmlReturnPanels(resXml); spSections.hide(true); }
		}).send();
	}
}

function getNextPosition(objTr){
	var nextPos = 0;
	if (objTr){
		var td2 = objTr.getElements("td")[1];
		td2.getElements("div.option").each(function (panel){
			var posAux = parseInt(panel.getAttribute("pnlPosition")); 
			if (posAux > nextPos){
				nextPos = posAux;
			}
		});
	}
	nextPos++
	return nextPos;
}

//function onChangeLanging(chkLanging){
//	var flagResp = $('flagResp');
//	if (chkLanging.checked){
//		flagResp.disabled = false;
//	} else {
//		cleanRespOrderItems();
//		flagResp.checked = false;
//		flagResp.disabled = true;
//	}
//};

//function onChangeResponsive(chkResponsive){
//	if (chkResponsive.checked){
//		loadDshPnlResponsive();
//	} else {
//		cleanRespOrderItems();
//	}
//};

function cleanRespOrderItems(){
	$$('div.dshPnlRespOrd').each(function(d){
		d.destroy();
	});
	$('dshPnlRespNoItems').setStyle('display','');
}

function loadDshPnlResponsive(){
	var nowResp = true; 
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadDshPanelsResponsive&isAjax=true&nowResp=' + nowResp + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { processXMLDshPnlResponsive(resXml);  }
	}).send();
}

function processXMLDshPnlResponsive(resXml){
	var responsive = resXml.getElementsByTagName("result")
	if (responsive != null && responsive.length > 0 && responsive.item(0) != null) {
		responsive = responsive.item(0).getElementsByTagName("panel");

		for (var i = 0; i < responsive.length; i++){
			var resp = responsive[i];
			createDshPnlRespOrd(resp.getAttribute('id'), resp.getAttribute('name'), resp.getAttribute('hidden'));
		}

		createSorteable();
	}
	SYS_PANELS.closeAll();
	
	initAdminFieldOnChangeHighlight(false, true, true, $('modalOptionsContainer'));
}

function createDshPnlRespOrd(id, name, hidden){
	if (!$('dshPnlResp_'+id)){
		var container = $('modalOptionsContainer');
		var pnlResp = new Element("div",{'id': "dshPnlResp_"+id, html: name, 'class': 'option optionWidth50 optionRemoveNoImg dshPnlRespOrd'}).inject($('modalOptionsContainer'));
		pnlResp.setAttribute("dshPnlRespOrdId",id);
		pnlResp.addEvent("mouseover",function(e){
			var tempId = this.getAttribute('dshPnlRespOrdId');
			var panel = $$('div.panel_'+tempId)[0];
			if (panel){
				var sec = panel.getAttribute('pnlSection')
				var pos = panel.getAttribute('pnlPosition');
				this.title = lblSection + ': ' + sec + ' / ' + lblPosition + ': ' + pos; 
			}
		});
		pnlResp.addEvent("mouseout",function(e){
			this.title = '';
		});
		
		var panelIcon = new Element("div",{'class': 'pnlRespMoveIcon moveIcon'}).inject(pnlResp);	
		
		var pnlVisibility = new Element('input', {type: 'checkbox'}).inject(new Element('label.optionField', {html: lblVisible + ':'}).inject(pnlResp))
		if(hidden != "true")
			pnlVisibility.set('checked', true);
		
		$('dshPnlRespNoItems').setStyle('display','none');		
	}
}

function createSorteable(){
	new Sortables($$('.optionPnlRespContainer'), {
		clone: true,
		revert: true,
		handle: 'div.pnlRespMoveIcon',
		opacity: 0.7		
	});
}

function removeDshPnlResponsive(id){
	var toRemove = $('dshPnlResp_'+id);
	if (toRemove){
		toRemove.destroy();
		if ($$('div.dshPnlRespOrd').length == 0){ //no quedan paneles
			$('dshPnlRespNoItems').setStyle('display','');
		}
	}
} 

function executeBeforeConfirm(){
	var order = '';
	var hiddens = '';
	$$('div.dshPnlRespOrd').each(function(d){
		if (order != '') order += ';';
		order += d.getAttribute('dshPnlRespOrdId');
		
		if (hiddens != '') hiddens += ';';
		hiddens += d.getElement('input').get('checked') ? '0' : '1';
	});
	$('dshPnlRespOrder').value = order;
	$('dshPnlRespVisibility').value = hiddens;
	
	if(!verifyPermissions()){
		return false;
	}
	
	return true;
}


function processModalImageConfirm(image) {
	if (image){
		var dshImage = $('dshImage');
		$('dshImage').setStyle('background-image', 'url(' + image.path + ')');
		$('imgPath').value = image.id;
	}
}

function habilitarCheck (value) {
	if (value) {
		document.getElementById("flagLandDef").disabled = false;
		
	}
	else {
		document.getElementById("flagLandDef").disabled = true;
	}		
}
