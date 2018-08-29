
function initAsociations() {
	if(!kb) {
		initEntInstMdlPage();
		loadAsociations();
	}
	var btnAddAsoc = $('btnAddAsoc');
	if (btnAddAsoc && !window.IS_READONLY) {		
		btnAddAsoc.addEvent("click", function(e) {
			e.stop();
			addRowAsoc($('tableDataAsoc'),null);
		});
	}
	
	var btnDeleteDesc = $('btnDeleteAsoc');
	if (btnDeleteDesc && !window.IS_READONLY) {
		btnDeleteDesc.addEvent("click", function(e) {
			e.stop();			
			var selected = new Array(getSelectedRows($('tableDataAsoc'))[0]);
			if (selected){
				disposeValidation(selected);
			}
			deleteRow($('tableDataAsoc'));
		});
	}
	
	var gridButtons = $('idGridButtons');
	if (gridButtons && window.IS_READONLY){
		gridButtons.destroy();
	}
}

function loadAsociations(){
	SYS_PANELS.closeAll();
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadAsociations&isAjax=true' + TAB_ID_REQUEST,		
		onComplete: function(resText, resXml) { 
			processAsociationsXml(resXml);			
		}
	}).send();
}

function processAsociationsXml(resXml){
	var structure = resXml.getElementsByTagName("asociations");
	
	if (structure != null && structure.length > 0 && structure.item(0) != null) {				
		var asocs = structure.item(0).getElementsByTagName("asociation");
		
		for (var i = 0; i < asocs.length; i++) {
			var xmlAsociation = asocs[i];
			var extra = new Element('input');
			extra.asocId = xmlAsociation.getAttribute("asocId");
			extra.asocName = xmlAsociation.getAttribute("asocName");
			extra.asocRelName = xmlAsociation.getAttribute("asocRelName");
			
			addRowAsoc($('tableDataAsoc'),extra);			
		}
	}
}

function addRowAsoc(table,extra){
	
	var parent = table.getParent();
	table.selectOnlyOne = true;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
//			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
//			if (! tdWidths[i]) tdWidths[i] = headers[i].get("width");
			if (! tdWidths[i]) tdWidths[i] = headers[i].getStyle("width");
		}
	}
	
	var headerTable = table.getParent('div.gridBody').getPrevious().getElement('table');
	var headerTexts = headerTable.getElements('th').get('text');
	
	var i = 0;
	var tr = new Element('tr.selectableTR');
	tr.addEvent("click", function(e) { myToggle(this) });
	tr.getRowId = function () { return this.get("data-rowId"); };
	tr.setRowId = function (a) { this.set("data-rowId",a); };
	var rowId = table.rows.length;
	tr.set("data-rowId", rowId);
	
	var td = new Element('td');	
	var input = new Element("input", {
		name: "asocName",
		id: "asocName"+ rowId,
		type: 'text',
		style: 'width: 90%;',
		readonly: true,
		title: headerTexts[0]
	});
	div = new Element('div.gridMinWidth.gridCellRequired', {
		styles: {
			width: tdWidths[i],
			overflow: 'hidden',
			'white-space': 'pre',
			'text-align': 'center'
		}
	});
	if (extra != null) {
		input.set('value', extra.asocName);
	}
	input.inject(div);
	registerValidation(input);
	
	var input = new Element("input", {
		name: "asocId",
		id: "asocId"+ rowId,
		type: 'hidden'
	});
	
	if (extra != null) {
		input.set('value', extra.asocId);
	}
	
	input.inject(div);		
		
	divMdl = new Element('div.mdl-btn');
	
	divMdl.addEvent("click",function(e){
		e.stop();
		
		//Guardo fila seleccionada
		rowIdSelected = e.target.getParent().getParent().getParent().get("data-rowid");
		
		//abrir modal instancias de entidad
		showEntInstModal(processEntInstanceModalReturn);
	});
	
	divMdl.inject(div);
	
	div.inject(td);
	
	td.inject(tr);
	i++;
	
	var td = new Element('td');	
	var input = new Element("input", {
		name: "asocRelName",
		id: "asocRelName"+ rowId,
		type: 'text',
		style: 'width: 90%;',
		title: headerTexts[1]
	});
	div = new Element('div.gridMinWidth.gridCellRequired', {
		styles: {
			width: tdWidths[i],
			overflow: 'hidden',
			'white-space': 'pre',
			'text-align': 'center'
		}
	});
	
	if (extra != null) {
		input.set('value', extra.asocRelName);
	}
	
	input.inject(div);
	registerValidation(input);	
	
	div.inject(td);	
	td.inject(tr);
	if(table.rows.length % 2 == 0){
		tr.addClass("trOdd");
	}
	
	tr.inject(table);
}

function registerValidation(obj){
	obj.className="validate['required']";
	var frmData = $('frmData');
	frmData.formChecker.register(obj);
}

function disposeValidation(objCol){
	objCol.each(function(obj) {
		inputs = obj.getElements("input");
		inputs.each(function(item) {
			$('frmData').formChecker.dispose(item);
		});
	});
}

function myToggle(oTr){
	if (oTr.getParent().selectOnlyOne) {
		var parent = oTr.getParent();
		if (parent.lastSelected) parent.lastSelected.toggleClass("selectedTR");
		parent.lastSelected = oTr;
	}
	oTr.toggleClass("selectedTR"); 
}

function processEntInstanceModalReturn(ret) {
	ret.each(function(e) {		
		var id = e.getRowId();
		var name = e.getRowContent()[0];
		$("asocName" + rowIdSelected).set('value', name);
		$("asocId" + rowIdSelected).set('value', id);
	});
}