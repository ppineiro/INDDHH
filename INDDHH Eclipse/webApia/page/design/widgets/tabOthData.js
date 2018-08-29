function initOthDataTab(mode) {

	if (mode == INSERT_MODE) {
		
	}else { //Estamos editando
		//Cargamos los checkbox
		if ($('chkWidLstUpdate') && othInfoLastUpdate == 'true') $('chkWidLstUpdate').set('checked', true);
		if ($('chkWidSource') && othInfoDataSource == 'true') $('chkWidSource').set('checked', true);
		loadInfoGrid();
	}
	
	//Seteamos la acci�n de boton agregar info de la grilla
	var btnAddInfo = $('btnAddInfo');
	if (btnAddInfo){
		btnAddInfo.addEvent("click",function(e){
			e.stop();
			btnAddInfo_click();
		});
	}
	
	//Seteamos la acci�n de boton eliminar info de la grilla
	var btnDeleteInfo = $('btnDeleteInfo');
	if (btnDeleteInfo){
		btnDeleteInfo.addEvent("click",function(e){
			e.stop();
			var count = selectionCount($('gridInfo'));
			if(count==0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (count>1){
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			}else{
				btnDelInfo_click();
			} 
		});
	}
	
	addScrollTable($('gridInfo'));
	
	addElementsOnChangeHighlight($$('#chkWidLstUpdate'), false);	
	addElementsOnChangeHighlight($$('#chkWidSource'), false);
}

function loadInfoGrid(){
	var request = new Request({
		method: 'post',			
		url: CONTEXT + URL_REQUEST_AJAX+'?action=getAdditionalInfo&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) {
			loadInfoXML(resXml);
			
			var table = $('gridInfo'); var footer = $('btnDeleteInfo');
			var notification = new Element('div', {id : 'editionNot'}); 
			footer.grab(notification, "top");
			initAdminModalHandlerOnChangeHighlight(table, false, false, notification);
		}
	}).send();
}

function loadInfoXML(ajaxCallXml){
	if (ajaxCallXml != null) {
		var infos = ajaxCallXml.getElementsByTagName("infos");
		if (infos != null && infos.length > 0 && infos.item(0) != null) {
			infos = infos.item(0).getElementsByTagName("info");
			for(var i = 0; i < infos.length; i++) {
				var info = infos.item(i);
				
				var type = info.getAttribute("type");
				var desc = info.getAttribute("desc");
				var visible = info.getAttribute("visible");
				
				fncAddInfo(type, desc, visible);
			}
		}
	}
}

function fncAddInfo (type, desc, visible) {
	var tdWidths =  getGridHeaderWidths('gridInfo');
	
	var oTd0 = new Element("TD"); //Tipo
	var oTd1 = new Element("TD"); //Descripcion
	var oTd2 = new Element("TD"); //Visible
	
	//Tipo
	var div = new Element('div', {styles: {width: tdWidths[0], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	var input = new Element('input',{type:'text',name:'widInfoType', maxlength:'50'});
	if (type==null) type='';
	input.set('value', type);
	input.setStyle('width', tdWidths[0]);
	input.setStyle('width',  Number.from(tdWidths[0]) - 5);
	input.inject(div);
	div.inject(oTd0);
	
	//Descripci�n
	div = new Element('div', {styles: {width: tdWidths[1], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	var input = new Element('input',{type:'text',name:'widInfoDesc'});
	if (desc==null) desc= '';
	input.set('value', desc);
	input.setStyle('width', tdWidths[1]);
	input.setStyle('width',  Number.from(tdWidths[1]) - 5);
	input.inject(div);
	div.inject(oTd1);

	//Visible
	div = new Element('div', {styles: {width: tdWidths[2], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	if (visible==null) visible = "true";
	input = new Element('input',{type:'checkbox',name:'visible',checked:visible=="true"});
	input.setStyle('width',  Number.from(tdWidths[2]) - 5);
	input.inject(div);
	div.inject(oTd2);
	
	var oTr = new Element("TR");
	
	oTd0.inject(oTr);
	oTd1.inject(oTr);
	oTd2.inject(oTr);
	
	oTr.addClass("selectableTR");
	oTr.getRowId = function () { return this.getAttribute("rowId"); };
	oTr.setRowId = function (a) { this.set("rowId",a); };
	oTr.set("rowId", $('gridInfo').rows.length);
	
	oTr.addEvent("click",function(e){myToggle(this)}); 
	
	if($('gridInfo').rows.length%2==0){
		oTr.addClass("trOdd");
	}
	
	oTr.inject($('gridInfo'));
	
	var rowIndx = oTr.rowIndex - 1;
	input.set('value',rowIndx); //le damos valor al checkbox para poder leer cuales fueron presionados desde el bean
	
	addElementsOnChangeHighlight(oTr.getElements('input'), false);
}

function btnAddInfo_click() {
	fncAddInfo(); //Agregamos una fila vacia	
	addScrollTable($('gridInfo'));
}

function btnDelInfo_click() {
	var selected = new Array(getSelectedRows($('gridInfo'))[0]);
	var table = $('gridInfo');
	for (var i=0;i<selected.length;i++){
		selected[i].dispose();	
	}
	
	for (var i=0;i<table.rows.length;i++){
		table.rows[i].setRowId(i);
		if (i%2==0){
			table.rows[i].addClass("trOdd");
		}else{
			table.rows[i].removeClass("trOdd");
		}
	}
	addScrollTable($('gridInfo'));
}

function myToggle(oTr){
	if (oTr.getParent().selectOnlyOne) {
		var parent = oTr.getParent();
		if (parent.lastSelected) parent.lastSelected.toggleClass("selectedTR");
		parent.lastSelected = oTr;
	}
	oTr.toggleClass("selectedTR"); 
}

