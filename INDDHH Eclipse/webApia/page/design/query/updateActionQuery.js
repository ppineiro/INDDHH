var actionColsRequired, actionColsCmbs; 
		

//---
//--- Funciones para trabajar con las columnas del filtro
//---

function initQueryAction(){
	
	initQueryMdlPage();
	loadQueryAction();
	
	var btnAddActionQuery = $('btnAddActionQuery');
	if (btnAddActionQuery){		
		btnAddActionQuery.addEvent("click",function(e){
			e.stop();
			showQueryModal(processModalReturnQueryAction);			
		});
	}
	
	var btnDeleteActionQuery = $('btnDeleteActionQuery');
	if (btnDeleteActionQuery){
		btnDeleteActionQuery.addEvent("click",function(e){
			e.stop();
			if(selectionCount($('bodyActionQuery')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var rows = getSelectedRows($('bodyActionQuery'));
				for (var i=0;i<rows.length;i++){
					deleteRow(parseInt(rows[i].rowIndex),'bodyActionQuery');
				}
				Scroller_bodyActionQuery = addScrollTable($('bodyActionQuery'));
			} 
			
		});
	}
	
	var btnUpActionQuery = $('btnUpActionQuery');
	if (btnUpActionQuery){
		btnUpActionQuery.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($("bodyActionQuery")) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($("bodyActionQuery"))[0].rowIndex;
				var row = upRow(parseInt(pos),"bodyActionQuery");
				if (row && Scroller_bodyActionQuery != null && Scroller_bodyActionQuery.v != null){
					Scroller_bodyActionQuery.v.showElement(row);
				}
			}		
		});
	}
	
	var btnDownActionQuery = $('btnDownActionQuery');
	if (btnDownActionQuery){
		btnDownActionQuery.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($("bodyActionQuery")) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($("bodyActionQuery"))[0].rowIndex;
				var row = downRow(parseInt(pos),"bodyActionQuery");
				if (row && Scroller_bodyActionQuery != null && Scroller_bodyActionQuery.v != null){
					Scroller_bodyActionQuery.v.showElement(row);
				}
			}
		});
	}
	
	/*
	 * Variables usadas para modificar dinamicamente columnas requeridas en tab Acciones
	 */
	actionColsRequired = [
        	requiereActVieEntCol, requiereActVieProCol, requiereActVieTasCol,	
        	requiereActWorEntCol, requiereActWorTasCol,	requiereActAcqTasCol,
        	requiereActComTasCol
      ]
  	actionColsCmbs = [
  		$("chkActVieEnt"), $("chkActViePro"), $("chkActViwTas"),
  		$("chkActWorEnt"), $("chkActWorTas"), $("chkActAcqTas"),
  		$("chkActComTas") 
  	]
	requieredEntAttCols = requieredEntAttCols.map(function(ele){return ele.toLowerCase();})
	requieredProAttCols = requieredProAttCols.map(function(ele){return ele.toLowerCase();})
}

function chkActVieQry_click() {
	var status = $("chkActVieQry").checked?'visible':'hidden';
	$("btnUpActionQuery").style.visibility = status;
	$("btnDownActionQuery").style.visibility = status;
	$("btnAddActionQuery").style.visibility = status;
	$("btnDeleteActionQuery").style.visibility = status;
}

function processModalReturnQueryAction(ret){
	var trows = $('bodyActionQuery').rows;
	var count = 0;
	ret.each(function(e){
		var addRet = true;	
		var text = e.getRowContent()[0];
		var id = e.getRowId();
		for (i=0;i<trows.length && addRet;i++) {
			if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == text) {
				addRet = false;
			}
		}
		if (addRet) {
			
			var arrayTd = new Array();
			var arrayCell = new Array();
		
			var aux = {'type':'hidden',name:'chkactVieQryTo',value:'1'};
			arrayCell.push(aux);
			
			aux = {'type':'hidden',name:'actVieQryTo',value:id};
			arrayCell.push(aux);
			
			aux = {'type':'hidden',name:'actVieQryToName',value:text};
			arrayCell.push(aux);
			
			aux = {'type':'span',html:text};
			arrayCell.push(aux);
			
			arrayTd.push({'display':'','type':'td',arr:arrayCell});				
			
			arrayCell = new Array();
			
			aux = {'type':'checkbox',name:'actVieQryToAllowAutoFilter',id:'actVieQryToAllowAutoFilter',value:1};
			arrayCell.push(aux);
			
			arrayTd.push({'display':'','type':'td',arr:arrayCell});			
			
			addRowQueryAction($('bodyActionQuery'),arrayTd);					
		}			
	});	
}

function loadQueryAction(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadQueryAction&isAjax=true' + TAB_ID_REQUEST,	
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { 
			modalProcessXml(resXml); SYS_PANELS.closeAll();
			
			var table = $('bodyActionQuery');
			var footer = table.getParent('.fieldGroup').getElements('.listAddDel')[0];
			var notification = new Element('div', {id : 'editionNot'}); 
			footer.grab(notification, "top");
			initAdminModalHandlerOnChangeHighlight(table, true, false, notification);
		}
	}).send();
}

function processLoadQueryAction(){
	var resXml = getLastFunctionAjaxCall(); 
	var tableDOM = resXml.getElementsByTagName("table");
	if (tableDOM!=null){
		var rows = tableDOM.item(0).getElementsByTagName("row");
		var arrayRow = new Array();
		for (var i=0;i<rows.length;i++){
			var row = rows.item(i);
			var displayRow = toBoolean(row.getAttribute("display"));
			var arrayTd = new Array();
			var cells = row.getElementsByTagName("cell");
			var k = 0;			
			while (k < cells.length){		
				var cell = cells.item(k);
				var type = cell.getAttribute("type");
				var tdDisplay = cell.getAttribute("display");
				lCount = 0;	
				
				auxTd = processTd(cell);
				arrayTd.push({'display':tdDisplay,'type':'td',arr:auxTd});				
							
				k +=lCount;
				k++;
			}
			addRowQueryAction($('bodyActionQuery'),arrayTd);			
		}		
	}
}

function addRowQueryAction(table,arrTable){
	var parent = table.getParent();
	table.selectOnlyOne = false;
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

	var rowDOM = new Element('tr');
	for (var j=0;j<arrTable.length;j++){
		var td = arrTable[j];
		var div = new Element('div',{styles:{'width':tdWidths[j]}});
		d = addRowQueryActionTd(td,div);
			
		var tdDOM = new Element('td',{styles:{'display':td.display}});
		d.inject(tdDOM);
		if (j==1) tdDOM.setAttribute("align","center");
		tdDOM.inject(rowDOM);				
	}
	
	rowDOM.addClass("selectableTR");
	rowDOM.addEvent("click",function(e){myToggle(this)});
	rowDOM.getRowId = function () { return this.getAttribute("rowId"); };
	rowDOM.setRowId = function (a) { this.setAttribute("rowId",a); };
	rowDOM.setAttribute("rowId", table.rows.length);
	
	if(table.rows.length%2==0){
		rowDOM.addClass("trOdd");
	}
	
	rowDOM.inject(table);	
	
	Scroller_bodyActionQuery = addScrollTable(table);
}

function addRowQueryActionTd(temp,div){
	var td = temp.arr;
	for (var i=0;i<td.length;i++){
		var aux = td[i];
		if (aux.type=="span"){
			domElement = new Element('span',{html:aux.html});
		}else if (aux.type=="checkbox"){
			domElement = new Element('input',{type:'checkbox',name:aux.name,id:aux.id,checked:aux.checked});
		}else if (aux.type=="hidden"){
			domElement = new Element('input',{type:'hidden',name:aux.name,id:aux.id});
			domElement.setAttribute("value",aux.value);
		}
		domElement.inject(div);		
		severalProperties(domElement,aux);
	}
	return div;
}

function checkActionColumnsRequired(){
	if (!actionColsRequired || !actionColsCmbs) return;
	
	var existsEntAtt=false, 
		existsProAtt=false;

	var attCmbs = $('tblShows').getElements('#cmbShoAttFrom');
	if (attCmbs){
		for(var i=0; i<attCmbs.length; i++){
			if (attCmbs[i].getAttribute('data-isAttribute')!='true') continue;
			
			existsEntAtt = existsEntAtt || attCmbs[i].value=="1";
			existsProAtt = existsProAtt || attCmbs[i].value=="0";
		}
	}
	
	if (!existsEntAtt && !existsProAtt){
		var currentColsRequired = actionColsRequired;	
	} else {
		//Se actualizan requeridas
		var currentColsRequired = actionColsRequired.clone();
		
		for(var i=0; i<currentColsRequired.length; i++){			
			if (existsEntAtt)
				requieredEntAttCols.each(function(r){ currentColsRequired[i].erase(r); })
			if (existsProAtt)
				requieredProAttCols.each(function(r){ currentColsRequired[i].erase(r); })
		}
	} 
	
	for(var i=0; i<actionColsCmbs.length; i++){
		var lbl = actionColsCmbs[i].nextElementSibling;
		var colsRequired = currentColsRequired[i].join('\", \"');
		lbl.textContent = lbl.textContent.replace(/[(](.*)[)]/, '(\"'+colsRequired+'\")'); 
	}
	
	requiereActVieEntCol=currentColsRequired[0];
	requiereActVieProCol=currentColsRequired[1]; 
	requiereActVieTasCol=currentColsRequired[2];	
  	requiereActWorEntCol=currentColsRequired[3]; 
  	requiereActWorTasCol=currentColsRequired[4];	
  	requiereActAcqTasCol=currentColsRequired[5];
  	requiereActComTasCol=currentColsRequired[6];
}