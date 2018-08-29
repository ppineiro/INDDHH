var table;
var lastSelected;
var spModal;

var Scroller;

function initQryTskLstColumnsMdlPage() {
	spModal = new Spinner($('qryTskListColumnsModalBody').getParent(),{message:WAIT_A_SECOND});
	
	var mdlQryTskLstColumnsContainer = $('mdlQryTskLstColumnsContainer');
	if (mdlQryTskLstColumnsContainer.initDone) return;
	mdlQryTskLstColumnsContainer.initDone = true;
	
	mdlQryTskLstColumnsContainer.blockerModal = new Mask();
	
	table = $('qryTskListColumnsModalTableData');
	lastSelected = null;
		
	//Subir	
	$('btnUpQryTskLstColumnsModal').addEvent("click", function(e) {
		e.stop();
		if (lastSelected == null) {
			showMessage(GNR_CHK_AT_LEAST_ONE,GNR_TIT_WARNING,'modalWarning');
		} else {
			var row = getSelectedRows(table)[0];
			upRow(row);	
		}
	});
	//Bajar
	$('btnDownQryTskLstColumnsModal').addEvent("click", function(e) {
		e.stop();
		if (lastSelected == null) {
			showMessage(GNR_CHK_AT_LEAST_ONE,GNR_TIT_WARNING,'modalWarning');
		} else {
			var row = getSelectedRows(table)[0];
			downRow(row);
		}				
	});
	//Confirmar
	$('btnConfirmQryTskLstColumnsModal').addEvent("click", function(e) {
		e.stop();
		
		if (mdlQryTskLstColumnsContainer.onModalConfirm){
			var ret = "";
			table.getElements("tr").each(function(tr){
				var content = tr.getRowContent();
				if (ret != "") { ret += ";"}
				ret += content[1] + PRIMARY_SEPARATOR + content[2] + PRIMARY_SEPARATOR + content[3]; //colName·colLabel·show
			});		
			
			jsCaller(mdlQryTskLstColumnsContainer.onModalConfirm,ret);
		}		
		$('btnCloseQryTskLstColumnsModal').fireEvent("click");				
	});
	
	//Cerrar
	$('btnCloseQryTskLstColumnsModal').addEvent("click", function(e) {
		if (e) { e.stop(); }
		mdlQryTskLstColumnsContainer.addClass('hiddenModal');
		mdlQryTskLstColumnsContainer.blockerModal.hide();
	});	
}


function showQryTskLstColumnsModal(workingMode, retFunction){
	mdlQryTskLstColumnsContainer.position();
	mdlQryTskLstColumnsContainer.blockerModal.show();
	mdlQryTskLstColumnsContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlQryTskLstColumnsContainer.removeClass('hiddenModal');
	mdlQryTskLstColumnsContainer.workingMode = workingMode;
	mdlQryTskLstColumnsContainer.onModalConfirm = retFunction;	
	mdlQryTskLstColumnsContainer.set('tabIndex', '0').focus();
	spModal.show(true);	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadModalCookieColumns&isAjax=true&workingMode=' + workingMode + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); createTable(resXml); spModal.hide(true); }
	}).send();
}

function createTable(ajaxCallXml){
	table.getElements("tr").each(function(item){ 
		item.destroy(); 
	});
	lastSelected = null;	
	
	if (ajaxCallXml != null) {
		var columns = ajaxCallXml.getElementsByTagName("columns");
		if (columns != null && columns.length > 0 && columns.item(0) != null) {
			columns = columns.item(0).getElementsByTagName("column");
									
			for(var i = 0; i < columns.length; i++) {
				var column = columns[i];
				createRow(i,column.getAttribute("colName"),column.getAttribute("label"),toBoolean(column.getAttribute("show")));				
			}			
		}
	}
	Scroller = addScrollTable(table);	
	
	fixLastTr();
}

function createRow(i,colName,label,show){
	var tr = new Element("tr",{'class': 'selectableTR'});
	var row = getRow(i+1);
	if (row) { tr.inject(row,"before"); } else { tr.inject(table); }
	if (i % 2 == 0){ tr.addClass("trOdd"); }
	tr.setAttribute("rowNumber",i);
	tr.getRowNumber = function () { return this.getAttribute("rowNumber"); };
	tr.setAttribute("colName",colName);
	tr.getRowId = function () { return this.getAttribute("colName"); };
	tr.addEvent("click", function(evt) { selectRow(this); evt.stopPropagation(); });				
									
	var td1 = new Element("td", {styles: {width: '200px'}}).inject(tr);
	td1.setAttribute("textContent",label);
	var div1 = new Element('div', {styles: {width: '200px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
	new Element('span', {html: label}).inject(div1);	
	
	var td2 = new Element("td", {'align': 'center',styles: {width: '50px'}}).inject(tr);
	td2.setAttribute("textContent",show);
	var div2 = new Element('div', {styles: {width: '50px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
	var input = new Element("input",{'type': 'checkbox', 'id': "chk_"+colName}).inject(div2);
	input.checked = toBoolean(show);	
	input.addEvent("click", function(evt) { evt.stopPropagation(); });
	input.addEvent("change", function(evt) { this.getParent("td").setAttribute("textContent",this.checked ? "true" : "false"); evt.stopPropagation(); });
	
	tr.getRowContent = function () {
		var ret = new Array();
		ret.push(this.getRowNumber());
		ret.push(this.getRowId());
		this.getElements('td').each(function (td){ ret.push(td.getAttribute("textContent")); });		
		return ret;
	};
}

function getRow(rowNumber){
	var retTr = null;
	table.getElements("tr").each(function(tr){
		if (parseInt(tr.getRowNumber()) == rowNumber){
			retTr = tr;
		}
	});
	return retTr;
}

function selectRow(row){
	if (lastSelected != null){
		lastSelected.toggleClass("selectedTR");
	}
	
	if (lastSelected == row){
		lastSelected = null;
		return;
	}
	
	row.toggleClass("selectedTR");
	lastSelected = row;
}

function upRow(row){
	if (parseInt(row.getRowNumber()) == 0) return;
	
	var rows = table.getElements("tr");
	var rowToUp = rows[parseInt(row.getRowNumber())];
	var rowToDown = rows[parseInt(row.getRowNumber())-1];
	
	var rowToUpContent = rowToUp.getRowContent();
	var rowToDownContent = rowToDown.getRowContent();
	
	rowToUp.destroy();
	rowToDown.destroy();
	
	createRow(parseInt(rowToUpContent[0]),rowToDownContent[1],rowToDownContent[2],rowToDownContent[3]);
	createRow(parseInt(rowToDownContent[0]),rowToUpContent[1],rowToUpContent[2],rowToUpContent[3]);
	
	lastSelected = null;
	var row = getRow(parseInt(rowToDownContent[0]));
	selectRow(row);
	if (Scroller && Scroller.v){
		Scroller.v.showElement(row);
	}
	
	fixLastTr();
}

function downRow(row){
	if (parseInt(row.getRowNumber()) == table.getElements("tr").length-1) return;	
	
	var rows = table.getElements("tr");
	var rowToDown = rows[parseInt(row.getRowNumber())];
	var rowToUp = rows[parseInt(row.getRowNumber())+1];
	
	var rowToDownContent = rowToDown.getRowContent();
	var rowToUpContent = rowToUp.getRowContent();
	
	rowToDown.destroy();
	rowToUp.destroy();
	
	createRow(parseInt(rowToUpContent[0]),rowToDownContent[1],rowToDownContent[2],rowToDownContent[3]);
	createRow(parseInt(rowToDownContent[0]),rowToUpContent[1],rowToUpContent[2],rowToUpContent[3]);
	
	lastSelected = null;
	var row = getRow(parseInt(rowToUpContent[0]));
	selectRow(row);	
	if (Scroller && Scroller.v){
		Scroller.v.showElement(row);	
	}
	
	fixLastTr();
}

function fixLastTr(){
	var trs = table.getElements("tr");
	trs.each(function(tr){ tr.removeClass("lastTr"); });
	trs[trs.length-1].addClass("lastTr");
}

