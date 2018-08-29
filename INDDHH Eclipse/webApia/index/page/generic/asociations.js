

function initAsociations() {
	initEntInstMdlPage();

	loadAsociations();
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
		
		for (var i = 0; i < asocs.length; i++){
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
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	var i=0;
	var tr = new Element('tr');
	tr.addClass("selectableTR");
	tr.addEvent("click",function(e){myToggle(this)});
	tr.getRowId = function () { return this.getAttribute("rowId"); };
	tr.setRowId = function (a) { this.setAttribute("rowId",a); };
	var rowId = table.rows.length;
	tr.setAttribute("rowId", rowId);
	
	var td = new Element('td',{'align': 'center'});	
	var input = new Element("input");
	div = new Element('div', {styles: {width: tdWidths[i], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	div.addClass("gridMinWidth");
	div.addClass("gridCellRequired");	
	input.setAttribute("name","asocName");
	input.setAttribute("id","asocName"+ rowId );
	input.setAttribute('type','text');
	input.setAttribute('style','width:90%');
	input.setAttribute('readonly',true);	
	if (extra!=null){
		input.setAttribute('value',extra.asocName);
	}
	input.inject(div);
	registerValidation(input);
	
	var input = new Element("input");
	input.setAttribute("name","asocId");
	input.setAttribute("id","asocId"+ rowId );
	input.setAttribute('type','hidden');
	if (extra!=null){
		input.setAttribute('value',extra.asocId);
	}
	input.inject(div);		
		
	divMdl = new Element('div');
	divMdl.addClass("mdl-btn");
	divMdl.addEvent("click",function(e){
		e.stop();
		
		//Guardo fila seleccionada
		rowIdSelected=e.target.getParent().getParent().getParent().getAttribute("rowid");
		
		//abrir modal instancias de entidad
		showEntInstModal(processEntInstanceModalReturn);
	});
	divMdl.inject(div);
	
	div.inject(td);
	
	td.inject(tr);
	i++;
	
	var td = new Element('td',{'align': 'center'});	
	var input = new Element("input");
	div = new Element('div', {styles: {width: tdWidths[i], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	div.addClass("gridMinWidth");
	div.addClass("gridCellRequired");
	input.setAttribute("name","asocRelName");
	input.setAttribute("id","asocRelName");
	input.setAttribute('type','text');
	input.setAttribute('style','width:90%');
	if (extra!=null){
		input.setAttribute('value',extra.asocRelName);
	}
	input.inject(div);
	registerValidation(input);	
	
	div.inject(td);	
	td.inject(tr);
	if(table.rows.length%2==0){
		tr.addClass("trOdd");
	}
	
	tr.inject(table);
}

function registerValidation(obj){
	obj.className="validate['required']";
	$('tableDataAsoc').formChecker.register(obj);
}

function disposeValidation(objCol){
	objCol.each(function(obj) {
		inputs = obj.getElements("input");
		inputs.each(function(item) {
			$('tableDataAsoc').formChecker.dispose(item);
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
		$("asocName"+rowIdSelected).value = name
		$("asocId"+rowIdSelected).value = id
	});
}


