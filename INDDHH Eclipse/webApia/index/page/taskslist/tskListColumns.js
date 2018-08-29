var table;
var lastSelected;
var spModal;

var Scroller;

function initTskLstColumnsMdlPage() {
	spModal = new Spinner($('gridBodyModal').getParent(),{message:WAIT_A_SECOND});
	
	var mdlTskLstColumnsContainer = $('mdlTskLstColumnsContainer');
	if (mdlTskLstColumnsContainer.initDone) return;
	mdlTskLstColumnsContainer.initDone = true;
	
	$('frmModalTskLstColumns').formChecker = new FormCheck(
		'frmModalTskLstColumns',
		{
			submit:false,
			display : {
				keepFocusOnError : 1,
				tipsPosition: 'left',
				tipsOffsetX: -10
			}
		}
	);
	
	mdlTskLstColumnsContainer.blockerModal = new Mask();
	
	table = $('tskLstColumnsModalTableData');
	lastSelected = null;
		
	//Subir	
	$('btnUpTskLstColumnsModal').addEvent("click", function(e) {
		e.stop();
		if (lastSelected == null) {
			showMessage(GNR_CHK_AT_LEAST_ONE,GNR_TIT_WARNING,'modalWarning');
		} else {
			var row = getSelectedRows(table)[0];
			upRow(row);	
		}
	});
	//Bajar
	$('btnDownTskLstColumnsModal').addEvent("click", function(e) {
		e.stop();
		if (lastSelected == null) {
			showMessage(GNR_CHK_AT_LEAST_ONE,GNR_TIT_WARNING,'modalWarning');
		} else {
			var row = getSelectedRows(table)[0];
			downRow(row);
		}				
	});
	//Confirmar
	$('btnConfirmTskLstColumnsModal').addEvent("click", function(e) {
		e.stop();
		
		var form = $('frmModalTskLstColumns');
		if(!form.formChecker.isFormValid()){
			return;
		}
		
		if (mdlTskLstColumnsContainer.onModalConfirm){
			var ret = "";
			table.getElements("tr").each(function(tr){
				var content = tr.getRowContent();
				if (ret != "") { ret += PRIMARY_SEPARATOR}
				ret += content[1] + "_" + content[3] + "_" + content[4] + "_" + content[5];
			});		
			
			jsCaller(mdlTskLstColumnsContainer.onModalConfirm,ret);
		}		
		$('btnCloseTskLstColumnsModal').fireEvent("click");				
	});
	//Cerrar
	$('btnCloseTskLstColumnsModal').addEvent("click", function(e) {
		if (e) { e.stop(); }
		var form = $('frmModalTskLstColumns');
		table.getElements("tr").each(function(item){ 
			form.formChecker.dispose(item.getElements("td")[3].getElement("div").getElement("input"));
		});
		mdlTskLstColumnsContainer.addClass('hiddenModal');
		mdlTskLstColumnsContainer.blockerModal.hide();
	});	
	
	//Tooltips
	//['btnUpTskLstColumnsModal','btnDownTskLstColumnsModal','btnConfirmTskLstColumnsModal','btnCloseTskLstColumnsModal'].each(setTooltip);
}


function showTskLstColumnsModal(retFunction){
	mdlTskLstColumnsContainer.position();
	mdlTskLstColumnsContainer.blockerModal.show();
	mdlTskLstColumnsContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlTskLstColumnsContainer.removeClass('hiddenModal');
	mdlTskLstColumnsContainer.onModalConfirm = retFunction;	
	mdlTskLstColumnsContainer.set('tabIndex', '0').focus();
	spModal.show(true);	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadColumnsForModal&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); createTable(resXml); spModal.hide(true); }
	}).send();
}

function createTable(ajaxCallXml){
	if (ajaxCallXml != null) {
		var columns = ajaxCallXml.getElementsByTagName("columns");
		if (columns != null && columns.length > 0 && columns.item(0) != null) {
			columns = columns.item(0).getElementsByTagName("column");
			
			table.getElements("tr").each(function(item){ 
				item.destroy(); 
			});
			lastSelected = null;
						
			for(var i = 0; i < columns.length; i++) {
				var column = columns[i];
				createRow(i,column.getAttribute("id"),column.getAttribute("label"),column.getAttribute("show"),column.getAttribute("filter"),column.getAttribute("width"),column.getAttribute("default"));				
			}			
		}
	}
	Scroller = addScrollTable(table);	
}

function createRow(i,rowId,label,show,filter,width,defaultValue){
	rowId = "col"+rowId;
	var tr = new Element("tr",{'class': 'selectableTR'});
	var row = getRow(i+1);
	if (row) { tr.inject(row,"before"); } else { tr.inject(table); }
	if (i % 2 == 0){ tr.addClass("trOdd"); }
	tr.setAttribute("rowNumber",i);
	tr.getRowNumber = function () { return this.getAttribute("rowNumber"); };
	tr.setAttribute("rowId",rowId);
	tr.getRowId = function () { return this.getAttribute("rowId"); };
	tr.addEvent("click", function(evt) { selectRow(this); evt.stopPropagation(); });				
									
	var td1 = new Element("td", {styles: {width: '125px'}}).inject(tr);
	td1.setAttribute("textContent",label);
	var div1 = new Element('div', {styles: {width: '125px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
	new Element('span', {html: label}).inject(div1);	
	
	var td2 = new Element("td", {'align': 'center',styles: {width: '190px'}}).inject(tr);
	td2.setAttribute("textContent",show);
	var div2 = new Element('div', {styles: {width: '190px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
	var select = new Element("select", {styles: {width: '190px'}, 'value': show}).inject(div2);
	select.setAttribute("chk","chk"+rowId);
	select.addEvent("click", function(evt) { evt.stopPropagation(); });
	select.addEvent("change", function(evt) { showOnChange(this); evt.stopPropagation(); });
	var option1 = new Element("option", {'value': '-1', html: 'No mostrar' }).inject(select);
	var option2 = new Element("option", {'value': '1', html: 'Visible' }).inject(select);
	var option3 = new Element("option", {'value': '0', html: 'Informaci&#243;n adicional' }).inject(select);
	var option4 = new Element("option", {'value': '2', html: 'Informaci&#243;n adicional (nueva linea)' }).inject(select);
	select.selectedIndex = (show == "-1") ? 0 : ((show == "1") ? 1 : ((show == "0") ? 2 : 3));
					
	var td3 = new Element("td", {'align': 'center',styles: {width: '40px'}}).inject(tr);
	td3.setAttribute("textContent",filter);
	var div3 = new Element('div', {styles: {width: '40px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td3);
	var input = new Element("input",{'type': 'checkbox', 'id': "chk"+rowId}).inject(div3);
	if (show == "-1") { input.disabled = true; } else if (filter == "S"){ input.checked = true; }	
	input.addEvent("click", function(evt) { evt.stopPropagation(); });
	input.addEvent("change", function(evt) { filterOnChange(this); evt.stopPropagation(); });
	
	var td4 = new Element("td", {'align': 'center',styles: {width: '60px'}}).inject(tr);
	td4.setAttribute("textContent",width);
	var div4 = new Element('div', {styles: {width: '60px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td4);
	var input2 = new Element("input",{'type': 'text', 'id': "txt"+rowId, 'class':"validate['digit[1,-1]']", 'value':width, styles: {width: '40px'} }).inject(div4);
	input2.setAttribute("defaultValue",defaultValue);
	input2.addEvent("change", function(evt) { widthChange(this); evt.stopPropagation(); });
	input2.addEvent("blur", function (){ if (this.value == ""){ this.value = this.getAttribute("defaultValue"); } });
	$('frmModalTskLstColumns').formChecker.register(input2);
	tr.getDefaultWidth = function () { return this.getElements("td")[3].getElement("input").getAttribute("defaultValue"); } 
	
	tr.getRowContent = function () {
		var ret = new Array();
		ret.push(this.getRowNumber());
		ret.push(this.getRowId().split("col")[1]);
		this.getElements('td').each(function (td){ ret.push(td.getAttribute("textContent")); });
		ret.push(this.getDefaultWidth());
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

function showOnChange(cmb){
	var chk = $(cmb.getAttribute("chk"));
	if (cmb.value == '-1'){
		chk.disabled = true;
		chk.checked = false;
		filterOnChange(chk);
		chk.parentNode.parentNode.setAttribute("textContent","false");		
	} else {
		chk.disabled = false;		
	}
	cmb.parentNode.parentNode.setAttribute("textContent",cmb.value);
}

function filterOnChange(chk){
	chk.parentNode.parentNode.setAttribute("textContent",chk.checked ? "S" : "N");	
}

function widthChange(txt){
	txt.parentNode.parentNode.setAttribute("textContent",txt.value);
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
	
	createRow(parseInt(rowToUpContent[0]),rowToDownContent[1],rowToDownContent[2],rowToDownContent[3],rowToDownContent[4],rowToDownContent[5],rowToDownContent[6]);
	createRow(parseInt(rowToDownContent[0]),rowToUpContent[1],rowToUpContent[2],rowToUpContent[3],rowToUpContent[4],rowToUpContent[5],rowToUpContent[6]);
	
	lastSelected = null;
	var row = getRow(parseInt(rowToDownContent[0]));
	selectRow(row);	
	Scroller.v.showElement(row);
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
	
	createRow(parseInt(rowToUpContent[0]),rowToDownContent[1],rowToDownContent[2],rowToDownContent[3],rowToDownContent[4],rowToDownContent[5],rowToDownContent[6]);
	createRow(parseInt(rowToDownContent[0]),rowToUpContent[1],rowToUpContent[2],rowToUpContent[3],rowToUpContent[4],rowToUpContent[5],rowToUpContent[6]);
	
	lastSelected = null;
	var row = getRow(parseInt(rowToUpContent[0]));
	selectRow(row);	
	Scroller.v.showElement(row);	
}

