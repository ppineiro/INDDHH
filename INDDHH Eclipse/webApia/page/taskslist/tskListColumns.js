var table;
var lastSelected;
var spModal;

var Scroller;

function initTskLstColumnsMdlPage() {
	spModal = new Spinner($('gridBodyModal').getParent(),{message:WAIT_A_SECOND});
	
	var mdlTskLstColumnsContainer = $('mdlTskLstColumnsContainer');
	if (mdlTskLstColumnsContainer.initDone) return;
	mdlTskLstColumnsContainer.initDone = true;
	
	var frmModalTskLstColumns = $('frmModalTskLstColumns');
	frmModalTskLstColumns.formChecker = new FormCheck(
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
		if(e) e.stop();
		if (lastSelected == null) {
			showMessage(GNR_CHK_AT_LEAST_ONE,GNR_TIT_WARNING,'modalWarning');
		} else {
			var row = getSelectedRows(table)[0];
			upRow(row);	
		}
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	//Bajar
	$('btnDownTskLstColumnsModal').addEvent("click", function(e) {
		if(e) e.stop();
		if (lastSelected == null) {
			showMessage(GNR_CHK_AT_LEAST_ONE,GNR_TIT_WARNING,'modalWarning');
		} else {
			var row = getSelectedRows(table)[0];
			downRow(row);
		}				
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	//Confirmar
	$('btnConfirmTskLstColumnsModal').addEvent("click", function(e) {
		if(e) e.stop();
		
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
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	//Cerrar
	$('btnCloseTskLstColumnsModal').addEvent("click", function(e) {
		if (e) { e.stop(); }
		
		var form = $('frmModalTskLstColumns');
		table.getElements("tr").each(function(item){ 
			form.formChecker.dispose(item.getElements("td")[3].getElement("div").getElement("input"));
		});
		mdlTskLstColumnsContainer.addClass('hiddenModal');
		mdlTskLstColumnsContainer.blockerModal.hide();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	var ths = frmModalTskLstColumns.getElement('div.gridHeader').getElements('th');
	thLabels = [];
	ths.each(function(item, index) { thLabels[index] = item.get('title'); });
}

var thLabels;


function showTskLstColumnsModal(retFunction){
	mdlTskLstColumnsContainer.position();
	mdlTskLstColumnsContainer.blockerModal.show();
	mdlTskLstColumnsContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlTskLstColumnsContainer.removeClass('hiddenModal');
	mdlTskLstColumnsContainer.onModalConfirm = retFunction;	
	mdlTskLstColumnsContainer.focus();
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
	var tr = new Element("tr.selectableTR");
	var row = getRow(i+1);
	if (row) { 
		tr.inject(row, "before");
	} else {
		tr.inject(table);
	}
	if (i % 2 == 0)
		tr.addClass("trOdd");
	
	tr.set("data-rowNumber",i);
	tr.getRowNumber = function () { return this.get("data-rowNumber"); };
	
	tr.set("data-rowId",rowId);
	tr.getRowId = function () { return this.get("data-rowId"); };
	
	tr.addEvent("click", function(evt) { selectRow(this); evt.stopPropagation(); });				
									
	var td1 = new Element("td", {styles: {width: '125px'}}).inject(tr);
	td1.set("data-textContent", label);
	var div1 = new Element('div', {styles: {width: '125px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
	new Element('span', {html: label}).inject(div1);	
	
	var td2 = new Element("td", {styles: {align: 'center', width: '190px'}}).inject(tr);
	td2.set("data-textContent", show);
	var div2 = new Element('div', {styles: {width: '190px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
	
	var select = new Element("select", {title: thLabels[1], styles: {width: '190px'}, 'value': show}).inject(div2);
	select.set("data-chk", "chk" + rowId);
	select.addEvent("click", function(evt) { evt.stopPropagation(); });
	select.addEvent("change", function(evt) { showOnChange(this); evt.stopPropagation(); });
	var option1 = new Element("option", {value: '-1', html: LBL_NO_SHOW }).inject(select);
	var option2 = new Element("option", {value: '1', html: LBL_VISIBLE }).inject(select);
	var option3 = new Element("option", {value: '0', html: LBL_ADDITIONAL_INFO }).inject(select);
	var option4 = new Element("option", {value: '2', html: LBL_ADDITIONAL_INFO_NEW_LINE }).inject(select);
	select.selectedIndex = (show == "-1") ? 0 : ((show == "1") ? 1 : ((show == "0") ? 2 : 3));
					
	var td3 = new Element("td", {styles: {align: 'center', width: '40px'}}).inject(tr);
	td3.set("data-textContent",filter);
	var div3 = new Element('div', {styles: {width: '40px', overflow: 'hidden', 'white-space': 'pre', margin: '4px 0px'}}).inject(td3);
	var input = new Element("input", {title: thLabels[2], type: 'checkbox', id: "chk"+rowId}).inject(div3);
	if (show == "-1") { input.disabled = true; } else if (filter == "S"){ input.checked = true; }	
	input.addEvent("click", function(evt) { evt.stopPropagation(); });
	input.addEvent("change", function(evt) { filterOnChange(this); evt.stopPropagation(); });
	
	var td4 = new Element("td", {styles: {align: 'center', width: '60px'}}).inject(tr);
	td4.set("data-textContent",width);
	var div4 = new Element('div', {styles: {width: '60px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td4);
	var input2 = new Element("input", {title: thLabels[3], type: 'text', id: "txt" + rowId, 'class': "validate['digit[1,-1]']", value: width, styles: {width: '40px'} }).inject(div4);
	input2.set("data-defaultValue", defaultValue);
	input2.addEvent("change", function(evt) { widthChange(this); evt.stopPropagation(); });
	input2.addEvent("blur", function (){ if (this.value == ""){ this.value = this.get("data-defaultValue"); } });
	$('frmModalTskLstColumns').formChecker.register(input2);
	tr.getDefaultWidth = function () { return this.getElements("td")[3].getElement("input").get("data-defaultValue"); } 
	
	tr.getRowContent = function () {
		var ret = new Array();
		ret.push(this.getRowNumber());
		ret.push(this.getRowId().split("col")[1]);
		this.getElements('td').each(function (td){ ret.push(td.getAttribute("data-textContent")); });
		ret.push(this.getDefaultWidth());
		return ret;
	};
	
	
	tr.set('tabIndex', '');
	
	tr.addEvent('keydown', function(e) {
		if(e.target == this && e.key == 'down') {
			e.preventDefault();
			var next = this.getNext('tr');
			
			if(next) {
				next.set('tabIndex').focus();
			}
		} else if(e.target == this && e.key == 'up') {
			e.preventDefault();
			var prev = this.getPrevious('tr'); 
			
			if(prev) {				
				prev.set('tabIndex').focus();
			}
		}
	}.bind(tr)).addEvent('keypress', function(e) {
		if(e.target == this && e.key == 'space') {
			e.preventDefault();
			this.fireEvent('click', e);
		}
	}.bind(tr));
	
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
	var chk = $(cmb.getAttribute("data-chk"));
	if (cmb.value == '-1'){
		chk.disabled = true;
		chk.checked = false;
		filterOnChange(chk);
		chk.parentNode.parentNode.set("data-textContent","false");		
	} else {
		chk.disabled = false;		
	}
	cmb.parentNode.parentNode.set("data-textContent",cmb.value);
}

function filterOnChange(chk){
	chk.parentNode.parentNode.set("data-textContent",chk.checked ? "S" : "N");	
}

function widthChange(txt){
	txt.parentNode.parentNode.set("data-textContent",txt.value);
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

