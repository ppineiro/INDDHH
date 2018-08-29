var firstTimeMsg;

function initPage(){
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});	
	
	['orderByDocTypeId','orderByName','orderBySize','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByDocTypeId','orderByName','orderBySize','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['cmbDocTypeId','nameFilter','descFilter','sizeMinFilter','sizeMaxFilter','regUsrFilter','ownerTitleFilter','instFilter','contentFilter'].each(setAdmFilters);
	['txtCreateFrom', 'txtCreateTo'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['cmbDocTypeId','nameFilter','descFilter','sizeMinFilter','sizeMaxFilter','cmbDocType','regUsrFilter','ownerTitleFilter','contentFilter','instFilter'].each(clearFilter);
		['txtCreateFrom','txtCreateTo'].each(clearFilterDate);		
		removeAllMetadataFilters(true,true);		
		enableDisableFilters($('cmbDocType'));		
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	enableDisableFilters($('cmbDocType'));
	
	if (MODE_MONITOR){
		//Information
		$('btnInfo').addEvent('click', function(e){
			e.stop();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				showDocInformationModal(id);				
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
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var downloadDocId= getSelectedRows($('tableData'))[0].get("data-downloadDocId");
				showDocVersionsModal(id,downloadDocId);
			}
		});
		
		//Download
		$('btnDown').addEvent("click", function(e){
			e.stop();
			hideMessage();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var trSelected = getSelectedRows($('tableData'))[0];
				if (trSelected.hasClass("noDown")){
					showMessage(MSG_NO_PERM, GNR_TIT_WARNING, 'modalWarning');
				} else {
					var id = trSelected.getRowId();
					var downloadId = trSelected.get("data-downloadDocId");
					//CAM_12370
					new Request({
						method: 'post',
						url: CONTEXT + URL_REQUEST_AJAX + '?action=loadDownloadDocument&isAjax=true&id=' + encodeURIComponent(downloadId) + TAB_ID_REQUEST,
						onRequest: function() { SYS_PANELS.showLoading(); },
						onComplete: function(resText, resXml) {
							SYS_PANELS.closeAll();
							
							//En caso de error, se procesan							
							if (resXml==null || resXml.getElementsByTagName("sysMessages").length != 0 ||
										resXml.getElementsByTagName('sysExceptions').length>0)							
								modalProcessXml(resXml);
							else
								createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","&id="+encodeURIComponent(downloadId),"","true",null);
						}
					}).send();
				}
			}
		});
		
		//['btnInfo','btnHist','btnDown'].each(setTooltip);
	
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
			if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {				
				SYS_PANELS.newPanel();
				var panel = SYS_PANELS.getActive();
				panel.addClass("modalWarning");
				panel.header.innerHTML = GNR_TIT_WARNING;
				panel.content.innerHTML = UNLOCK_DOC_WARNING;
												
				panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); unlockDocuments();\">" + BTN_CONFIRM + "</div>";	
				SYS_PANELS.addClose(panel);
				SYS_PANELS.refresh();
			}
		});
		
		//['btnUnlock'].each(setTooltip);
	}
	
	$('addFreeMetadataFilter').addEvent("click",function(e){
		e.stop();
		addDocFreeMetadataFilter("","");
	});
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('data-src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	
	initDocInformationMdlPage();
	initDocVersionsMdlPage();
	initNavButtons();
	initAdminFav();

	
	if (!PRE_FILTER && MODE_MONITOR){
		//NO SE EJECUTA LA CONSULTA AL COMENZAR LA FUNCIONALIDAD
		//CAM_11316
		//callNavigate();
		var gridBody = $('gridBody');
		firstTimeMsg = new Element('div', {'class': 'noDataMessage', html: MSG_FIRST_TIME}).inject(gridBody);
		firstTimeMsg.setStyle('display','');
		firstTimeMsg.setStyle("width",gridBody.getStyle("width"));
		firstTimeMsg.position( {
			relativeTo: gridBody,
			position: 'upperLeft'
		});
		gridBody.noDataMessage = firstTimeMsg;
	} else {
		callNavigate();
	}	
	
	initPinGridOptions();
}


function enableDisableFilters(cmb){
	//Filter Titulo
	if ("" != cmb.value){
		$('ownerTitleFilter').className = "";
		$('ownerTitleFilter').readOnly = false;
	} else {
		$('ownerTitleFilter').className = "readonly";
		$('ownerTitleFilter').readOnly = true;
		$('ownerTitleFilter').value = "";
	}	
	//Filter NroRegistro
	if (INST_PROC == cmb.value || INST_ENT == cmb.value || ATT_INST_PROC == cmb.value || ATT_INST_ENT == cmb.value){
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
	var docMetadataFilter = createStrDocMetadataFilter();
	var docFreeMetadataFilter = createStrDocFreeMetadataFilter();
	
	if (firstTimeMsg){
		firstTimeMsg.destroy();
		firstTimeMsg = null;
	}
	
	callNavigateFilter({
			txtName: $('nameFilter').value,
			txtDesc: $('descFilter').value,
			txtSizeFrom: $('sizeMinFilter').value,
			txtSizeTo: $('sizeMaxFilter').value,
			selType: $('cmbDocType').value,
			txtUser: $('regUsrFilter').value,
			txtRelTitle: $('ownerTitleFilter').value,
			txtContent: $('contentFilter').value,
			txtInst: $('instFilter').value,
			txtCreateFrom: $('txtCreateFrom').value,
			txtCreateTo: $('txtCreateTo').value,
			txtDocTypeId: $('cmbDocTypeId').value,
			strDocMetadata: docMetadataFilter,
			strDocFreeMetadata: docFreeMetadataFilter
		},null);
}

function removeAllMetadataFilters(docMetadata,docFreeMetadata){
	if (docMetadata){
		$('docMetadataFilters').getElement("div.content").innerHTML = "";
		$('docMetadataFilters').setStyle("display","none");
	}
	if (docFreeMetadata){
		$('docFreeMetadataFilters').getElement("div.content").innerHTML = "";
		$('docFreeMetadataFilters').setStyle("display","none");
	}	
}

function loadAllDocMetadataFilters(docTypeId){
	if (docTypeId == null || docTypeId == ""){
		removeAllMetadataFilters(true,true);
		setFilter();
		return;
	}
	
	//remove docMetadata --> no docFreeMetada por si el nuevo tiene metadatos libres
	removeAllMetadataFilters(true,false);
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadMetadata&isAjax=true&docTypeId=' + docTypeId + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { processXmlMetadata(resXml); }
	}).send();	
}

function processXmlMetadata(resXml){
	var allMetadata = resXml.getElementsByTagName("allMetadata");
	if (allMetadata != null && allMetadata.length > 0 && allMetadata.item(0) != null) {
		var docMetadata = allMetadata.item(0).getElementsByTagName("docMetadata");
		var docFreeMetadata = allMetadata.item(0).getElementsByTagName("docFreeMetadata");
	
		var docFreeMetadataAvailable = toBoolean(allMetadata.item(0).getAttribute("docFreeMetadataAvailable"));
		
		//DocMetadata
		if (docMetadata != null && docMetadata.length > 0 && docMetadata.item(0) != null) {
			docMetadata = docMetadata.item(0).getElementsByTagName("metadata");
			
			for (var i = 0; i < docMetadata.length; i++){
				var xmlFilter = docMetadata[i];
				var id = xmlFilter.getAttribute("id");
				var title = xmlFilter.getAttribute("title");
				var type = xmlFilter.getAttribute("type");
				var value = xmlFilter.getAttribute("value");
				var value2 = undefined;
				if (type == "D") { value2 = xmlFilter.getAttribute("value2"); }
				addDocMetadataFilter(id,title,type,value,value2);								
			}
		}
		
		//DocFreeMetadata
		if (docFreeMetadataAvailable){
			$('docFreeMetadataFilters').setStyle("display","");
		} else {
			removeAllMetadataFilters(false, true);
		}
		if (docFreeMetadata != null && docFreeMetadata.length > 0 && docFreeMetadata.item(0) != null) {
			docFreeMetadata = docFreeMetadata.item(0).getElementsByTagName("metadata");
				
			for (var i = 0; i < docFreeMetadata.length; i++){
				var xmlFilter = docMetadata[i];
				var title = xmlFilter.getAttribute("title");
				var value = xmlFilter.getAttribute("value");
				addDocFreeMetadataFilter(title, value);
			}
		}	
	} else {
		removeAllMetadataFilters(true, true);
	}
	setFilter();
}

function addDocMetadataFilter(id,title,type,value,value2){
	var content = $('docMetadataFilters').getElement("div.content");
	
	var divFilter = new Element("div",{'class':'filter'}).inject(content);
	divFilter.setAttribute("docTypeMetadataId",id);
	divFilter.setAttribute("docTypeMetadataType",type);
	new Element("span",{html:title+':&nbsp;'}).inject(divFilter);
	if (type == "D"){
		var inputValueFrom = new Element('input',{'type':'text','value':value,'class':'datePickerCustom filterInputDate','format':'d/m/Y','maxlength':'10',styles:{'width':'20%'}}).inject(divFilter);
		setAdmDatePicker(inputValueFrom);
		setDateFilters(inputValueFrom);
		new Element("span",{html:'&nbsp;&nbsp;-&nbsp;&nbsp;',styles:{'width':'18px'}}).inject(divFilter);
		var inputValueTo = new Element('input',{'type':'text','value':value2,'class':'datePickerCustom filterInputDate','format':'d/m/Y','maxlength':'10',styles:{'width':'20%'}}).inject(divFilter);
		setAdmDatePicker(inputValueTo);
		setDateFilters(inputValueTo);
	} else if (type == "N"){
		var inputValue = new Element('input',{'type':'text','value':value}).inject(divFilter);
		inputValue.addEvent("keypress",function(e){
			if (e.key < '0' || e.key > '9'){
				if (e.key != "delete" && e.key != "tab" && e.key != "backspace" && e.key != "left" && e.key != "right"){
					e.stop();
				}
			} 
		});
		setAdmFilters(inputValue);
	} else {
		var inputValue = new Element("input",{'type':'text','value':value}).inject(divFilter);
		setAdmFilters(inputValue);
	}
	
	$('docMetadataFilters').setStyle("display","");	
}

function addDocFreeMetadataFilter(title,value){
	var content = $('docFreeMetadataFilters').getElement("div.content");
	
	var divFilter = new Element("div",{'class':'filter'}).inject(content);
	var remFilter = new Element("div.addRemoveFilter.removeFilter",{}).inject(divFilter);
	remFilter.addEvent("click",function(e){
		e.stopPropagation();
		var parent = this.getParent("div.filter");
		var inputTit = parent.getElement("input.freeMetFilterTit").value;
		var inputVal = parent.getElement("input.freeMetFilterVal").value;
		this.getParent("div.filter").destroy();
		if (inputTit != "" && inputVal != "") { setFilter(); }
	});
	var inputTitle = new Element("input.freeMetFilterTit",{'type':'text','value':title,'title':LBL_TITLE}).inject(divFilter);
	inputTitle.addClass("autocomplete");
	var inputTitleKey = new Element("input",{'type':'hidden','value':title}).inject(divFilter);
	inputTitle.inputTitleKey = inputTitleKey;
	var inputValue = new Element("input.freeMetFilterVal",{'type':'text','value':value,'title':LBL_VALUE}).inject(divFilter); 
	setDocFreeMetadataFilterEvents(inputTitle, inputValue);
	$('docFreeMetadataFilters').setStyle("display","");
}

function setDocFreeMetadataFilterEvents(inputTitle,inputValue){
	//Titulo
	inputTitle.inputValue = inputValue;
	inputTitle.setFilter = setFilter;
	setAutoCompleteGeneric(inputTitle, inputTitle.inputTitleKey, 'search', 'doc_free_metadata', 'doc_free_metadata_title', 'doc_free_metadata_title', 'doc_free_metadata_title', false, true, false, true, true, null, "", true);
	inputTitle.addEvent('optionNotSelected', function(evt) {
		this.value = "";
		this.inputTitleKey.value = "";
		if (this.inputValue.value != ""){
			setFilter();
		}
	});
	inputTitle.addEvent('optionSelected', function(evt) {
		if (this.inputValue.value != ""){
			setFilter();
		}
	});
	inputTitle.addEvent('change', function(evt) {
		if (this.value == "")
		this.fireEvent("optionNotSelected");
	});	
	
	//Valor
	inputValue.setFilter = setFilter;
	inputValue.oldValue = inputValue.value;
	inputValue.inputTitle = inputTitle;
	inputValue.addEvent("keyup", function(e) {
		if (this.oldValue == this.value) return;
		if (this.inputTitle.inputTitleKey.value == "") return;
		if (this.timmer) $clear(this.timmer);
		this.oldValue = this.value;
		this.timmer = this.setFilter.delay(200, this);
	});
}

function createStrDocMetadataFilter(){ //id�tipo�valor;id�tipo�valor;...
	var str = "";
	$('docMetadataFilters').getElement("div.content").getElements("div.filter").each(function (filter){
		var value = filter.getElement("input").value;
		var type = filter.getAttribute("docTypeMetadataType");
		var id = filter.getAttribute("docTypeMetadataId");
		if (value != null && value != ""){
			if (str != "") str += ";";
			str += id + PRIMARY_SEPARATOR + type + PRIMARY_SEPARATOR + value;
		}
		if (type == "D"){
			value = filter.getElements("input")[2].value;
			if (value != null && value != ""){
				if (str != "") str += ";";
				str += "-" + id + PRIMARY_SEPARATOR + type + PRIMARY_SEPARATOR + value;
			}
		}
	});
	return str;
}

function createStrDocFreeMetadataFilter(){ //titulo�valor;titulo�valor...
	var str = "";
	$('docFreeMetadataFilters').getElement("div.content").getElements("div.filter").each(function (filter){
		var inputs = filter.getElements("input");
		if (inputs.length == 3 && inputs[1].value != "" && inputs[2].value != ""){
			var title = inputs[1].value;
			var value = inputs[2].value;
			if (str != "") str += ";";
			str += title + PRIMARY_SEPARATOR + value;
		}
	});
	return str;
}

function unlockDocuments(){
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