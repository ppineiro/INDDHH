function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	$('addProject').addEvent("click", function(e) {
		e.stop();
		showProjectModal(processProjectModalReturn);
	});
	
	$('btnAddQueryEnt').addEvent("click", function(e) {
		e.stop();
		showEntitiesModal(processQueryEntityModalReturn);
	});
	
	$('btnAddQueryPro').addEvent("click", function(e) {
		e.stop();
		showProcessModal(processQueryProcessModalReturn);
	});
	
	$('addEntitiy').addEvent("click", function(e) {
		e.stop();
		showEntitiesModal(processEntityModalReturn);
	});
	
	$('addBusEntInstance').addEvent("click", function(e) {
		e.stop();
		showEntitiesModal(processEntityInstanceModalReturn);
	});
	
	$('addProcess').addEvent("click", function(e) {
		e.stop();
		showProcessModal(processProcessModalReturn);
	});
	
	$('addProInstance').addEvent("click", function(e) {
		e.stop();
		STATUSMODAL_SHOWGLOBAL = false;		
		showProcessModal(processProcessInstanceModalReturn);
	});
	
	$('btnAddInitFilter').addEvent('click', addNewInitFilter);

	$('btnDeleteInitFilter').addEvent('click', function(evt) {
		getSelectedRows($('tableDataInitFilter')).each(function(ele){ ele.destroy(); });
		ajustInitFilterVisuals();
	});

	$('btnDeleteQuery').addEvent('click', function(evt) {
		getSelectedRows($('tableDataQuery')).each(function(ele){ ele.destroy(); });
		ajustQueryVisuals();
	});

	var tabQuery = $('tabQuery');
	if (tabQuery) tabQuery.addEvent('focus',function (evt){ initScrollQuerys(); });
	
	var tabParam = $('tabInitFilter');
	if (tabParam) tabParam.addEvent('focus',function (evt){ addScrollTable($('tableDataInitFilter')); });
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition(verifyPermissions,false,false,false);
	initPermissions();
	initAdminFav();
	
	initEntMdlPage();
	initProcMdlPage();
	initPrjMdlPage();
	
	loadExtraInformation();
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function loadExtraInformation() {
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadExtraInformation' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) { loadExtraInformationXml(resXml); }
	}).send();
}

function loadExtraInformationXml(xml) {
	var busEntities = xml.getElementsByTagName('busEntity');
	var processes = xml.getElementsByTagName('process');
	var busEntInstances = xml.getElementsByTagName('busEntInstance');
	var proInstnaces = xml.getElementsByTagName('proInstance');
	var projects = xml.getElementsByTagName('project');
	
	if (busEntities != null) {
		for (var i = 0; i < busEntities.length; i++) {
			var aElement = busEntities[i];
			var id = aElement.getAttribute('id');
			var name = aElement.getAttribute('name');
			addActionElement($('entitiesContainter'),name,id,"busEntId");
		}
	}
	if (projects != null) {
		for (var i = 0; i < projects.length; i++) {
			var aElement = projects[i];
			var id = aElement.getAttribute('id');
			var name = aElement.getAttribute('name');
			addActionElement($('projectsContainter'),name,id,"prjId");
		}
	}
	
	if (processes != null) {
		for (var i = 0; i < processes.length; i++) {
			var aElement = processes[i];
			var id = aElement.getAttribute('id');
			var name = aElement.getAttribute('name');
			addActionElement($('processesContainter'),name,id,"proId");
		}
	}
	
	if (proInstnaces != null) {
		for (var i = 0; i < proInstnaces.length; i++) {
			var aElement = proInstnaces[i];
			var id = aElement.getAttribute('id');
			var name = aElement.getAttribute('name');
			addActionElement($('proInstancesContainter'),name,id,"proInstId");
		}
	}
	
	if (busEntInstances != null) {
		for (var i = 0; i < busEntInstances.length; i++) {
			var aElement = busEntInstances[i];
			var id = aElement.getAttribute('id');
			var name = aElement.getAttribute('name');
			addActionElement($('busEntInstancesContainter'),name,id,"busEntInstId");
		}
	}
	
	var filters = xml.getElementsByTagName('filter');
	if (filters != null) {
		for (var i = 0; i < filters.length; i++) {
			var filter = filters[i];
			
			var id = filter.getAttribute('id');
			var name = filter.getAttribute('name');
			var title = filter.getAttribute('title');
			var type = filter.getAttribute('type');
			var defaultValue = filter.getAttribute('defaultValue');
			var required = "true" == filter.getAttribute('required');
			var hidden = "true" == filter.getAttribute('hidden');
			
			createNewInitFilter(id, name, title, type, defaultValue, required, hidden);
		}
		
		ajustInitFilterVisuals();
	}

	var qryBusEntities = xml.getElementsByTagName('queryBusEntity');
	if (qryBusEntities != null) {
		for (var i = 0; i < qryBusEntities.length; i++) {
			var qry = qryBusEntities[i];
			
			var id = qry.getAttribute('id');
			var name = qry.getAttribute('name');
			var type = qry.getAttribute('type');

			var q1 = {value: qry.getAttribute('qryName1'), id: qry.getAttribute('qryId1')};
			var q2 = {value: qry.getAttribute('qryName2'), id: qry.getAttribute('qryId2')};
			var q3 = {value: qry.getAttribute('qryName3'), id: qry.getAttribute('qryId3')};
			var q4 = {value: qry.getAttribute('qryName4'), id: qry.getAttribute('qryId4')};
			var q5 = {value: qry.getAttribute('qryName5'), id: qry.getAttribute('qryId5')};
			var q6 = {value: qry.getAttribute('qryName6'), id: qry.getAttribute('qryId6')};
			
			createNewQuery(type, id, name, q1, q2, q3, q4, q5, q6);
		}
	}
	
	var qryProcesses = xml.getElementsByTagName('queryProcess');
	if (qryProcesses != null) {
		for (var i = 0; i < qryProcesses.length; i++) {
			var qry = qryProcesses[i];
			
			var id = qry.getAttribute('id');
			var name = qry.getAttribute('name');
			var type = qry.getAttribute('type');

			var q1 = {value: qry.getAttribute('qryName1'), id: qry.getAttribute('qryId1')};
			var q2 = {value: qry.getAttribute('qryName2'), id: qry.getAttribute('qryId2')};
			var q3 = {value: qry.getAttribute('qryName3'), id: qry.getAttribute('qryId3')};
			var q4 = {value: qry.getAttribute('qryName4'), id: qry.getAttribute('qryId4')};
			var q5 = {value: qry.getAttribute('qryName5'), id: qry.getAttribute('qryId5')};
			var q6 = {value: qry.getAttribute('qryName6'), id: qry.getAttribute('qryId6')};
			
			createNewQuery(type, id, name, q1, q2, q3, q4, q5, q6);
		}
	}
	
	ajustQueryVisuals();

}

function processProjectModalReturn(ret) {
	ret.each(function(e){
		var text = e.getRowContent()[0];
		addActionElement($('projectsContainter'),text,e.getRowId(),"prjId");
	});
}

function processProcessModalReturn(ret) {
	ret.each(function(e){
		var text = e.getRowContent()[0];
		addActionElement($('processesContainter'),text,e.getRowId(),"proId");
	});
}

function processEntityModalReturn(ret) {
	ret.each(function(e){
		var text = e.getRowContent()[0];
		addActionElement($('entitiesContainter'),text,e.getRowId(),"busEntId");
	});
}

function processQueryEntityModalReturn(ret) {
	ret.each(function(e){
		var id = e.getRowId();
		var text = e.getRowContent()[0];
		
		createNewQuery('E', id, text, null, null, null, null, null, null);
	});
	ajustQueryVisuals();
}

function processQueryProcessModalReturn(ret) {
	ret.each(function(e){
		var id = e.getRowId();
		var text = e.getRowContent()[0];
		
		createNewQuery('P', id, text, null, null, null, null, null, null);
	});
	ajustQueryVisuals();
}

function processProcessInstanceModalReturn(ret){
	ret.each(function(e){
		var text = e.getRowContent()[0];
		addActionElement($('proInstancesContainter'),text,e.getRowId(),"proInstId");
	});
}

function processEntityInstanceModalReturn(ret){
	ret.each(function(e){
		var text = e.getRowContent()[0];
		addActionElement($('busEntInstancesContainter'),text,e.getRowId(),"busEntInstId");
	});
}

function addNewInitFilter(evt) {
	createNewInitFilter(null, null, null, 'S', null, false, false);
	ajustInitFilterVisuals();
}

function ajustInitFilterVisuals() {
	var table = $('tableDataInitFilter');
	if (lastInitFilterAdded) lastInitFilterAdded.removeClass('lastTr');
	$$('tr.selectableTR').each(function(tr, index){
		if(index%2==0) tr.addClass("trOdd"); else tr.removeClass("trOdd");
		lastInitFilterAdded = tr;
	});
	if (lastInitFilterAdded != null) lastInitFilterAdded.addClass('lastTr');
	addScrollTable($('tableDataInitFilter'));
}

function ajustQueryVisuals() {
	var table = $('tableDataQuery');
	if (lastQueryAdded) lastQueryAdded.removeClass('lastTr');
	$$('tr.selectableTR').each(function(tr, index){
		if(index%2==0) tr.addClass("trOdd"); else tr.removeClass("trOdd");
		lastQueryAdded = tr;
	});
	if (lastQueryAdded != null) lastQueryAdded.addClass('lastTr');
	
	addScrollTable($('tableDataQuery'));
}

var lastInitFilterAdded = null;
var lastQueryAdded = null;

function createNewInitFilter(id, name, title, type, defaultValue, required, hidden) {
	if (lastInitFilterAdded) lastInitFilterAdded.removeClass('lastTr');
	
	if (id == null) id = "";
	if (name == null) name = "";
	if (title == null) title = "";
	if (type == null) type = "S";
	if (defaultValue == null) defaultValue = "";
	
	var table = $('tableDataInitFilter');
	
	if (! table.parentTdIwdths) {
		var parent = table.getParent();
		
		var thead = parent.getFirst("thead");
		var theadTr = thead ? thead.getFirst("tr") : null;
		var headers = theadTr ? thead.getElements("th") : null;
		
		var tdWidths = headers ? new Array(headers.length) : null;
		var minTdWidth = null;
		
		if (headers) {
			for (var i = 0; i < headers.length; i++) {
				tdWidths[i] = headers[i].style.width;
				if (! tdWidths[i]) tdWidths[i] = headers[i].width;
				if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
			}
		}
		table.parentTdIwdths = tdWidths;
	}
	
	var tdWidths = table.parentTdIwdths;
	
	var tds = [];
	
	var tdName = new Element('td');
	tds.push(tdName);
	new Element('input', {'type': 'hidden', 'name': 'monBusFilId', 'value': id}).inject(tdName);
	var inputName = new Element('input', {'class': "validate['required']", 'type': 'text', 'value': name, 'name': 'monBusFilName'});
	inputName.inject(tdName);
	inputName.setStyle('width', '100%');
	inputName.setStyle('paddingRight', '0px');
	inputName.addEvent('click', function(evt){ evt.stop(); });
	
	var tdTitle = new Element('td');
	tds.push(tdTitle);
	var inputTitle = new Element('input', {'class': "validate['required']", 'type': 'text', 'value': title, 'name': 'monBusFilTitle'});
	inputTitle.inject(tdTitle);
	inputTitle.setStyle('width', '100%');
	inputTitle.setStyle('paddingRight', '0px');
	inputTitle.addEvent('click', function(evt){ evt.stop(); });
	
	var tdType = new Element('td', {align: 'center'});
	tds.push(tdType);
	var selectType = new Element('select', {'name' : 'monBusFilType'});
	selectType.inject(tdType);
	new Element('option', {'value': 'S', 'text': LBL_TYPE_STRING}).inject(selectType);
	new Element('option', {'value': 'N', 'text': LBL_TYPE_NUMERIC}).inject(selectType);
	new Element('option', {'value': 'D', 'text': LBL_TYPE_DATE}).inject(selectType);
	if  (type == "S") selectType.selectedIndex = 0;
	if  (type == "N") selectType.selectedIndex = 1;
	if  (type == "D") selectType.selectedIndex = 2;
	
	var tdDefaultValue = new Element('td');
	tds.push(tdDefaultValue);
	var inputDefaultValue = new Element('input', {'type': 'text', 'value': defaultValue, 'name': 'monBusFilValue'});
	inputDefaultValue.inject(tdDefaultValue);
	inputDefaultValue.setStyle('width', '100%');
	inputDefaultValue.setStyle('paddingRight', '0px');
	inputDefaultValue.addEvent('click', function(evt){ evt.stop(); });

	var tdRequired = new Element('td', {align: 'center'});
	tds.push(tdRequired);
	var selectRequired = new Element('select', {'name': 'monBusFilFlag0'});
	selectRequired.inject(tdRequired);
	new Element('option', {'value': 'true', 'text': LBL_YES}).inject(selectRequired);
	new Element('option', {'value': 'false', 'text': LBL_NO}).inject(selectRequired);
	if (required) selectRequired.selectedIndex = 0;
	if (! required) selectRequired.selectedIndex = 1;
	
	var tdHidden = new Element('td', {align: 'center'});
	tds.push(tdHidden);
	var selectHidden = new Element('select', {'name': 'monBusFilFlag1'});
	selectHidden.inject(tdHidden);
	new Element('option', {'value': 'true', 'text': LBL_YES}).inject(selectHidden);
	new Element('option', {'value': 'false', 'text': LBL_NO}).inject(selectHidden);
	if (hidden) selectHidden.selectedIndex = 0;
	if (! hidden) selectHidden.selectedIndex = 1;
	
	lastInitFilterAdded = new Element('tr', {'class': 'selectableTR lastTr'});
	for (var i = 0; i < tds.length; i++) {
		if (tdWidths) tds[i].setStyle('width', tdWidths[i]);
		tds[i].inject(lastInitFilterAdded);
	}
	
	lastInitFilterAdded.addEvent('click', function(evt){
		this.toggleClass("selectedTR");
	});

	
	lastInitFilterAdded.inject(table);
}

function canAddNewQuery(type, id) {
	var table = $('tableDataQuery');
	var rows = $$('tr.selectableTR');
	
	for (var i = 0; i < rows.length; i++) {
		var row = rows[i];
		if (row.eleType == type && row.eleId == id) return false;
	}
	
	return true;
}

function createNewQuery(type, id, name, q1, q2, q3, q4, q5, q6) {
	if (type == null || type == "") return;

	if (! canAddNewQuery(type, id)) return;
	
	if (lastQueryAdded) lastQueryAdded.removeClass('lastTr');
	
	if (id == null) id = "";
	if (name == null) name = "";
	
	var table = $('tableDataQuery');
	
	if (! table.parentTdIwdths) {
		var parent = table.getParent();
		
		var thead = parent.getFirst("thead");
		var theadTr = thead ? thead.getFirst("tr") : null;
		var headers = theadTr ? thead.getElements("th") : null;
		
		var tdWidths = headers ? new Array(headers.length) : null;
		var minTdWidth = null;
		
		if (headers) {
			for (var i = 0; i < headers.length; i++) {
				tdWidths[i] = headers[i].style.width;
				if (! tdWidths[i]) tdWidths[i] = headers[i].width;
				if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
			}
		}
		table.parentTdIwdths = tdWidths;
	}
	
	var tdWidths = table.parentTdIwdths;
	
	var tds = [];
	
	if (type == "E") {
		tds.push(new Element('td', {'html': TYPE_BUS_ENTITY_DESC}));
	} else if (type == "P") {
		tds.push(new Element('td', {'html': TYPE_PROCESS_DESC}));
	}
	
	var tdName = new Element('td', {'html': name});
	tds.push(tdName);
	new Element('input', {'type': 'hidden', 'name': 'eleViewType', 'value': type}).inject(tdName);
	new Element('input', {'type': 'hidden', 'name': 'eleViewId', 'value': id}).inject(tdName);

	[q1, q2, q3, q4, q5, q6].each(function(q, index) {
		index ++;
		var tdQ = new Element('td');
		tds.push(tdQ);
		
		var input = new Element('input', {'type': 'text', 'name': 'qryNameQ' + index, 'class': 'autocomplete'});
		input.inject(tdQ);
		input.setStyle('width', '100%');
		input.setStyle('paddingRight', '0px');
		input.addEvent('click', function(evt){ evt.stop(); });
		
		var hidden = new Element('input', {'type': 'hidden', 'name': 'qryIdQ' + index});
		hidden.inject(tdQ);
		
		if (q != null) {
			input.value = q.value;
			hidden.value = q.id;
		}
		
		setAutoCompleteGeneric( input , hidden, 'search', 'query', 'qry_name', 'qry_id_auto', 'qry_name', false, true, false, true, true);
	});
	
	
	lastQueryAdded = new Element('tr', {'class': 'selectableTR lastTr'});
	lastQueryAdded.eleType = type;
	lastQueryAdded.eleId = id;
	for (var i = 0; i < tds.length; i++) {
		if (tdWidths) tds[i].setStyle('width', tdWidths[i]);
		tds[i].inject(lastQueryAdded);
	}
	
	lastQueryAdded.addEvent('click', function(evt){
		this.toggleClass("selectedTR");
	});

	
	lastQueryAdded.inject(table);
}

function initScrollQuerys() {
	var gridHeader = $('gridHeaderQuery');
	if (gridHeader && ! gridHeader.scollInitDone) {
		gridHeader.scollInitDone = true;
		var table = gridHeader.getChildren('table');
		if (table) {
			var gridBody = $('gridBodyQuery');
			gridBody.tableHeader = table;
			gridBody.addEvent('scroll', function() {			
				this.tableHeader.setStyle('left', - this.scrollLeft);
			});
			gridBody.addEvent('custom_scroll', function(left) {			
				this.tableHeader.setStyle('left', left);
			});
		}
	}
	
	addScrollTable($('tableDataQuery'));
}