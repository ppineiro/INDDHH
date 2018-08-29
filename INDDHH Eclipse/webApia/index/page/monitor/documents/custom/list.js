function initPage(){
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});	
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	
	if (ONLY_ONE_DOC_TYPE_PRE_FILTER){
		loadAllDocMetadataFilters(FIRST_DOC_TYPE_ID_PRE_FILTER);
	} else {
		loadAllDocMetadataFiltersIntersect();
	}
	
	['orderByDocTypeId','orderByName','orderBySize','orderByRegUser','orderByRegDate'].each(function(ele){
		if ($(ele)) setAdmOrder(ele);
	});
	['orderByDocTypeId','orderByName','orderBySize','orderByRegUser','orderByRegDate'].each(function(ele){
		if ($(ele)) setAdmListTitle(ele);
	});	
	['cmbDocTypeId','nameFilter','descFilter','sizeMinFilter','sizeMaxFilter','regUsrFilter','ownerTitleFilter','instFilter','contentFilter',
	 	'ownerFilterTsk','ownerFilterPro','ownerFilterEnt','ownerFilterAtt','ownerFilterFrm'].each(function(ele){
		if ($(ele)) setAdmFilters(ele);
	});	
	
	var txtCreateFrom = $('txtCreateFrom');
	if (txtCreateFrom){
		txtCreateFrom.setFilter = setFilter;
		txtCreateFrom.addEvent("change", function(e) { this.setFilter(); });
	}
	var txtCreateTo = $('txtCreateTo');
	if (txtCreateTo){
		txtCreateTo.setFilter = setFilter;
		txtCreateTo.addEvent("change", function(e) { this.setFilter(); });
	}
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		var arrFil = new Array();
		var arrFilDte = new Array();
		
		if ($('cmbDocTypeId')) arrFil.push($('cmbDocTypeId'));
		if ($('nameFilter')) arrFil.push($('nameFilter'));
		if ($('descFilter')) arrFil.push(('descFilter'));
		if ($('sizeMinFilter')) arrFil.push($('sizeMinFilter'));
		if ($('sizeMaxFilter')) arrFil.push($('sizeMaxFilter'));
		if ($('cmbDocType')) arrFil.push($('cmbDocType'));
		if ($('regUsrFilter')) arrFil.push($('regUsrFilter'));
		var txtCreateFrom = $('txtCreateFrom');
		if (txtCreateFrom){
			arrFilDte.push(txtCreateFrom);
		}
		var txtCreateTo = $('txtCreateTo');
		if (txtCreateTo) {
			arrFil.push(txtCreateTo);
		}
		if ($('ownerTitleFilter')) arrFil.push($('ownerTitleFilter'));
		if ($('contentFilter')) arrFil.push($('contentFilter'));
		if ($('instFilter')) arrFil.push($('instFilter'));
		
		removeAllMetadataFilters(true,true);
		
		if ($('ownerFilterTsk')) arrFil.push($('ownerFilterTsk'));
		if ($('ownerFilterPro')) arrFil.push($('ownerFilterPro'));
		if ($('ownerFilterEnt')) arrFil.push($('ownerFilterEnt'));
		if ($('ownerFilterAtt')) arrFil.push($('ownerFilterAtt'));
		if ($('ownerFilterFrm')) arrFil.push($('ownerFilterFrm'));
		
		var cmbDocType = $('cmbDocType');
		if (cmbDocType){ 
			if (cmbDocType.options.length == 2){
				cmbDocType.selectedIndex = 1;
			}
			enableDisableFilters(cmbDocType); 
		}
		
		arrFil.each(clearFilter);
		arrFilDte.each(clearFilterDate);
		
		if (ONLY_ONE_DOC_TYPE_PRE_FILTER){
			loadAllDocMetadataFilters(FIRST_DOC_TYPE_ID_PRE_FILTER);
		} else {
			loadAllDocMetadataFiltersIntersect();
		}
		setFilter();		
	});
	
	var cmbDocType = $('cmbDocType');
	if (cmbDocType){ 
		if (cmbDocType.options.length == 2){
			cmbDocType.selectedIndex = 1;
		}
		enableDisableFilters(cmbDocType); 
	}
	
	if (FIL_METADATA){
		var addFreeMetadataFilter = $('addFreeMetadataFilter');
		if (addFreeMetadataFilter){
			addFreeMetadataFilter.addEvent("click",function(e){
				e.stop();
				addDocFreeMetadataFilter("","");		
			});
		}
	}
	
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
			showDocVersionsModal(id);
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
				createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","&id="+id,"","true",null);
			}
		}
	});
	
	//['btnInfo','btnHist','btnDown'].each(setTooltip)
	
	initDocInformationMdlPage();
	initDocVersionsMdlPage();
	initNavButtons();
	initAdminFav();
	callNavigate();
}


function enableDisableFilters(cmb){
	//Filter Titulo
	var ownerTitleFilter = $('ownerTitleFilter');
	if (ownerTitleFilter){
		if ("" != cmb.value && DOC_TYPE_ENVIRONMENT != cmb.value){
			ownerTitleFilter.className = "";
			ownerTitleFilter.readOnly = false;
		} else {
			ownerTitleFilter.className = "readonly";
			ownerTitleFilter.readOnly = true;
			ownerTitleFilter.value = "";
		}
	}
	
	//Filter NroRegistro
	var instFilter = $('instFilter');
	if (instFilter){
		if (DOC_TYPE_PROCESS_INST == cmb.value || DOC_TYPE_BUS_ENT_INST == cmb.value || DOC_TYPE_PRO_INST_ATTRIBUTE == cmb.value || DOC_TYPE_BUS_ENT_INST_ATTRIBUTE == cmb.value){
			instFilter.className = "";
			instFilter.readOnly = false;
		} else {
			instFilter.className = "readonly";
			instFilter.readOnly = true;
			instFilter.value = "";
		}
	}
	
	if ("" == cmb.value){
		[$('ownerFilterTsk'),$('ownerFilterPro'),$('ownerFilterEnt'),$('ownerFilterAtt'),$('ownerFilterFrm')].each(setDisabledFilterState);		
	} else if (DOC_TYPE_TASK == cmb.value){
		[$('ownerFilterPro'),$('ownerFilterEnt'),$('ownerFilterAtt'),$('ownerFilterFrm')].each(setDisabledFilterState);
		[$('ownerFilterTsk')].each(setEnabledFilterState);
	} else if (DOC_TYPE_PROCESS == cmb.value){
		[$('ownerFilterTsk'),$('ownerFilterEnt'),$('ownerFilterAtt'),$('ownerFilterFrm')].each(setDisabledFilterState);
		[$('ownerFilterPro')].each(setEnabledFilterState);
	} else if (DOC_TYPE_PROCESS_INST == cmb.value){
		[$('ownerFilterTsk'),$('ownerFilterEnt'),$('ownerFilterAtt'),$('ownerFilterFrm')].each(setDisabledFilterState);
		[$('ownerFilterPro')].each(setEnabledFilterState);
	} else if (DOC_TYPE_BUS_ENT == cmb.value){
		[$('ownerFilterPro'),$('ownerFilterTsk'),$('ownerFilterAtt'),$('ownerFilterFrm')].each(setDisabledFilterState);
		[$('ownerFilterEnt')].each(setEnabledFilterState);
	} else if (DOC_TYPE_BUS_ENT_INST == cmb.value){
		[$('ownerFilterPro'),$('ownerFilterTsk'),$('ownerFilterAtt'),$('ownerFilterFrm')].each(setDisabledFilterState);
		[$('ownerFilterEnt')].each(setEnabledFilterState);
	} else if (DOC_TYPE_FORM == cmb.value){
		[$('ownerFilterFrm')].each(setDisabledFilterState);
		[$('ownerFilterEnt'),$('ownerFilterPro'),$('ownerFilterTsk'),$('ownerFilterAtt')].each(setEnabledFilterState);
	} else if (DOC_TYPE_BUS_ENT_INST_ATTRIBUTE == cmb.value){
		[$('ownerFilterPro'),$('ownerFilterTsk'),$('ownerFilterFrm')].each(setDisabledFilterState);
		[$('ownerFilterEnt'),$('ownerFilterAtt')].each(setEnabledFilterState);
	} else if (DOC_TYPE_PRO_INST_ATTRIBUTE == cmb.value){
		[$('ownerFilterEnt'),$('ownerFilterTsk'),$('ownerFilterFrm')].each(setDisabledFilterState);
		[$('ownerFilterPro'),$('ownerFilterAtt')].each(setEnabledFilterState);
	} else if (DOC_TYPE_ENVIRONMENT == cmb.value){
		[$('ownerFilterTsk'),$('ownerFilterPro'),$('ownerFilterEnt'),$('ownerFilterAtt'),$('ownerFilterFrm')].each(setDisabledFilterState);
	}
} 

function setDisabledFilterState(ele){
	if (ele){
		ele.className = "readonly";
		ele.disabled = true;
		ele.value = "";
	}
}

function setEnabledFilterState(ele){
	if (ele){
		ele.className = "";
		ele.disabled = false;
	}
}

function documentVersionDownload(docId,docVer){
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","&id="+docId+"&version="+docVer,"","",null);	
}

//establecer un filtro
function setFilter(){
	var docMetadataFilter = createStrDocMetadataFilter();
	var docFreeMetadataFilter = createStrDocFreeMetadataFilter();
	
	callNavigateFilter({
			txtName: $('nameFilter') ? $('nameFilter').value : "",
			txtDesc: $('descFilter') ? $('descFilter').value : "",
			txtSizeFrom: $('sizeMinFilter') ? $('sizeMinFilter').value : "",
			txtSizeTo: $('sizeMaxFilter') ? $('sizeMaxFilter').value : "",
			selType: $('cmbDocType') ? $('cmbDocType').value : "",
			txtUser: $('regUsrFilter') ? $('regUsrFilter').value : "",
			txtRelTitle: $('ownerTitleFilter') ? $('ownerTitleFilter').value : "",
			txtContent: $('contentFilter') ? $('contentFilter').value : "",
			txtInst: $('instFilter') ? $('instFilter').value : "",
			txtCreateFrom: $('txtCreateFrom') ? $('txtCreateFrom').value : "",
			txtCreateTo: $('txtCreateTo') ? $('txtCreateTo').value : "",
			txtDocTypeId: $('cmbDocTypeId') ? $('cmbDocTypeId').value : "",
			strDocMetadata: docMetadataFilter,
			strDocFreeMetadata: docFreeMetadataFilter,
			txtOwnerFilterTsk: $('ownerFilterTsk') ? $('ownerFilterTsk').value : "",
			txtOwnerFilterPro: $('ownerFilterPro') ? $('ownerFilterPro').value : "",
			txtOwnerFilterEnt: $('ownerFilterEnt') ? $('ownerFilterEnt').value : "",
			txtOwnerFilterAtt: $('ownerFilterAtt') ? $('ownerFilterAtt').value : "",
			txtOwnerFilterFrm: $('ownerFilterFrm') ? $('ownerFilterFrm').value : ""
		},null);
}

function removeAllMetadataFilters(docMetadata,docFreeMetadata){
	if (FIL_METADATA){
		var docMetadataFilters = $('docMetadataFilters');
		if (docMetadata){
			docMetadataFilters.getElement("div.content").innerHTML = "";
			docMetadataFilters.setStyle("display","none");
		}
		var docFreeMetadataFilters = $('docFreeMetadataFilters');
		if (docFreeMetadata){
			docFreeMetadataFilters.getElement("div.content").innerHTML = "";
			docFreeMetadataFilters.setStyle("display","none");
		}
	}
}

function loadAllDocMetadataFilters(docTypeId){
	if (docTypeId == null || docTypeId == "" || docTypeId == "null"){
		removeAllMetadataFilters(true,true);
		//setFilter();
		
		loadAllDocMetadataFiltersIntersect();
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

function loadAllDocMetadataFiltersIntersect(){
	//remove docMetadata --> no docFreeMetada por si el nuevo tiene metadatos libres
	removeAllMetadataFilters(true);
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadMetadata&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { processXmlMetadata(resXml); }
	}).send();	
}

function processXmlMetadata(resXml){
	if (FIL_METADATA){
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
	}
	setFilter();
}

function addDocMetadataFilter(id,title,type,value,value2){
	if (FIL_METADATA){
		var content = $('docMetadataFilters').getElement("div.content");
		
		var divFilter = new Element("div",{'class':'filter'}).inject(content);
		divFilter.setAttribute("docTypeMetadataId",id);
		divFilter.setAttribute("docTypeMetadataType",type);
		new Element("span",{html:title+':&nbsp;'}).inject(divFilter);
		if (type == "D"){
			var inputValueFrom = new Element('input',{'type':'text','value':value,'class':'datePickerCustom filterInputDate','format':'d/m/Y','maxlength':'10',styles:{'width':'20%'}}).inject(divFilter);
			setAdmDatePicker(inputValueFrom);
			inputValueFrom.setFilter = setFilter;
			inputValueFrom.addEvent("change", function(e) { this.setFilter(); });
			new Element("span",{html:'&nbsp;&nbsp;-&nbsp;&nbsp;',styles:{'width':'18px'}}).inject(divFilter);
			var inputValueTo = new Element('input',{'type':'text','value':value2,'class':'datePickerCustom filterInputDate','format':'d/m/Y','maxlength':'10',styles:{'width':'20%'}}).inject(divFilter);
			setAdmDatePicker(inputValueTo);
			inputValueTo.setFilter = setFilter;
			inputValueTo.addEvent("change", function(e) { this.setFilter(); });
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
}

function addDocFreeMetadataFilter(title,value){
	if (FIL_METADATA){
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
}

function setDocFreeMetadataFilterEvents(inputTitle,inputValue){
	if (FIL_METADATA){
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
}

function createStrDocMetadataFilter(){ //id·tipo·valor;id·tipo·valor;...
	var str = "";
	if (FIL_METADATA){
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
	}
	return str;
}

function createStrDocFreeMetadataFilter(){ //titulo·valor;titulo·valor...
	var str = "";
	if (FIL_METADATA){
		$('docFreeMetadataFilters').getElement("div.content").getElements("div.filter").each(function (filter){
			var inputs = filter.getElements("input");
			if (inputs.length == 3 && inputs[1].value != "" && inputs[2].value != ""){
				var title = inputs[1].value;
				var value = inputs[2].value;
				if (str != "") str += ";";
				str += title + PRIMARY_SEPARATOR + value;
			}
		});		
	}
	return str;
}
