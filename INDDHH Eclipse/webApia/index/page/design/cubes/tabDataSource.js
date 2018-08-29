function initDataSourceTab(mode) {
	
	var btnAddTableCol = $('btnAddTableCol');
	
	if (btnAddTableCol){
		//Al presionar el bot�n Agregar se recupera un string con nombre de tablas separdos por , y se procesan en el metodo processXMLmodalAddTables()
		btnAddTableCol.addEvent("click",function(e){
			e.stop();
			var params = '&selConn=' + $('selConn').get('value');
			var request = new Request({
				method: 'post',			
				url: CONTEXT + URL_REQUEST_AJAX+'?action=getTables&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { sp.show(true); },
				onComplete: function(resText, resXml) { processXMLmodalAddTables(resXml); sp.hide(true); }
			}).send(params);
		});
	}
	
	addColumnsToContainer($('selCols').value, "");
}

//Recibe un xml con el titulo del modal y los nombres de tablas separados por , y muestra un modal 
function processXMLmodalAddTables(ajaxCallXml){
	if (ajaxCallXml != null) {		
		var tables = ajaxCallXml.getElementsByTagName("lis");	
		if (tables != null && tables.length > 0 && tables.item(0) != null) {
			
			var formAction =  URL_REQUEST_AJAX+'?action=getTableColumns&isAjax=true' + TAB_ID_REQUEST;
			var formMethod = "POST";
			var form = new Element('form',{id:'frmModalPanelAjax',action:formAction,method:formMethod});
			
			var result = ajaxCallXml.getElementsByTagName("result");	
			var title = result.item(0).getAttribute("title");
			tables = tables.item(0).getElementsByTagName("li");
			var element;
			if (SYS_PANELS.hasActive()){
				element = SYS_PANELS.getActive();
			}else{
				element = SYS_PANELS.newPanel();
			}
			var div = new Element('div');
			var ul = new Element('ul');
			ul.inject(div);
			for(var i = 0; i < tables.length; i++) {
				var table = tables.item(i);
				var extra = {
						action:table.getAttribute("action"),
						tooltip:table.getAttribute("tooltip"),
						text: table.getAttribute("text")
				}
				addAttLi(extra,ul);
			}
			
			element.addClass("addClass");
			div.inject(form);			
			if (title && title != "") element.header.innerHTML = title;
			element.footer.innerHTML = "<div onclick=\"saveSelectedColumns();\" class='button'>"+LBL_CON+"</div>";
			SYS_PANELS.addClose(element, true, null); 
			form.inject(element.content);	
			SYS_PANELS.adjustVisual()
		}
	}
}

function saveSelectedColumns(){
	var selCols = $('selCols').value; //Columnas seleccionadas
	var dbConId = $('selConn').value; //Conexi�n seleccionada en este momento
	extra = {'selCols':selCols, 'dbConId': dbConId };
	
	var request = new Request({
		method: 'post',			
		data:extra,
		url: CONTEXT + URL_REQUEST_AJAX+'?action=refreshSelectedColumns&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) {processUpdateSelColsResultXML(resXml);  }
	}).send();
}

function addAttLi(extra,ul){
	
	var li = new Element('li',{title:extra.tooltip,'class':'li'});
	var tableName = extra.text;
	
	var div = new Element('div',{'class':'showChilds'});
	div.setAttribute("onclick","doLIAction(this,'"+extra.action+"','"+extra.text+"')");
	div.addClass("plusMinus");
	div.inject(li);
	
	var span = new Element('span',{html:extra.text,title:extra.tooltip});
	span.inject(li);
	
//	for (var i=0;i<extra.inputs.length;i++){
//		var ex = extra.inputs[i];
//		var hidden = new Element('input',{type:ex.type,name:ex.name,id:ex.id,value:ex.value});
//		hidden.inject(li); 
//	}
	li.inject(ul);
	
}

function doLIAction(aEvent, action, name){
	var element = aEvent;
	if (action=="showColumns"){
		var close = false;
		if(element.hasClass("showChilds")){
			//Estaba cerrado --> hay que abrir			
			element.className='hideChilds';//show open			
		}else{ //Estaba abierto --> hay que cerrar
			element.className='showChilds';//show open
			close=true;
		}
	}
	if(!close){
		if (action=="showColumns"){
			openTableData(element, name);
		}/*else if (type == "task"){
			openTaskForms(element,isDimension);
		}else{
			openData(element,type,isDimension);
		}*/
	}else{
		closeData(element);
	}
}

function openTableData(element, tableName){
	var dbConId = $('selConn').value; //Conexi�n seleccionada en este momento
	extra = {'table':tableName, 'dbConId': dbConId };
	
	var request = new Request({
		method: 'post',			
		data:extra,
		url: CONTEXT + URL_REQUEST_AJAX+'?action=getTableColumns&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) { readColumnsXML(resXml,element,tableName);  }
	}).send();
}

function closeData(element){
	var ul = element.parentNode.getElementsByTagName("UL");
	while(ul.length >0){
		ul[0].parentNode.removeChild(ul[0]);
	}
}

function readColumnsXML(ajaxCallXml, element, tableName){
//	var attsInfo = ajaxCallXml.getElementsByTagName("html").item(0).firstChild.nodeValue;
	var columns = "";
	
	if (ajaxCallXml) {		
		if(MSIE) {
			//IE friendly
			node = ajaxCallXml.childNodes[1];
			if(ajaxCallXml.childNodes[1] && ajaxCallXml.childNodes[1].text)
				columns = ajaxCallXml.childNodes[1].text;
		} else {
			if(ajaxCallXml.firstChild && ajaxCallXml.firstChild.textContent)
				columns = ajaxCallXml.firstChild.textContent;
		}
	}
	
	var colsArr = columns.split(","); //["COLNAME.COLTYPE", "COLNAME.COLTYPE", ... ]
	
	for(i=0; i<colsArr.length; i++){
		var colParts = colsArr[i].split("."); // "COLNAME.COLTYPE"
		var colName = colParts[0];
		var colType = colParts[1];
						
		var oUL = new Element("ul");
		var oLI = new Element("li",{'class':'li'}); 
	
		oLI.title = colName;
		//var isTask = false;
		//var aux = new Array({type:'hidden',name:'hidTskId',id:'hidTskId',value:objId});
		input = new Element('input',{type:'checkbox',checked:isColSelected(tableName+"."+colName),name:'chkCol',id:'chkCol'+colName,'onclick':'selUnselColumn(this,"' + tableName + '","'+colName+'", "' + colType + '")'});
		var label = new Element('label',{'for':'chkCol'+i,html:colName,'class':'label'});
		input.inject(oLI);
		label.inject(oLI);
		oLI.inject(oUL);
	
		oUL.inject(element.parentNode);				
	}
	
	xmlRoot = "";
	sXmlResult = "";
}

function isColSelected(colName){
	var selCols = $('selCols').value; //Columnas seleccionadas. Ej: "table1.col1.S,table2.col2.N,table2.col3.D"
	if (selCols.indexOf(colName)>=0){
		return true;
	}
	return false;
}

function selUnselColumn(obj, tableName, colName, colType){
	var selCols = $('selCols').value; //Columnas seleccionadas. Ej: "table1.col1.S,table2.col2.N,table2.col3.D"
	
	var li = obj.parentNode;
	var checked = li.getElementsByTagName("INPUT")[0].checked;
	var colSelected = tableName + "." + colName + "." + colType;
	
	if (checked){ //Si ahora esta seleccionado => Antes no estaba en la lista
		if (selCols == ""){
			$('selCols').set('value', colSelected);
		}else {
			$('selCols').set('value', selCols + "," + colSelected);
		}
	}else { //Si ahora no esta seleccionado => Debemos sacarlo de la lista
		var indx = selCols.indexOf(colSelected); 
		if (indx==0){
			var nextIndx = selCols.indexOf(',');
			$('selCols').set('value', selCols.substring(nextIndx+1, selCols.length));
		}else if (indx>0){
			var part1 = selCols.substring(0,indx-1);
			selCols = selCols.substring(indx, selCols.length);
			var nextIndx = selCols.indexOf(',');
			if (nextIndx>=0){
				selCols = selCols.substring(nextIndx, selCols.length);
				$('selCols').set('value', part1 + selCols);
			}else {
				$('selCols').set('value', part1);
			}
			
		}
	}
}

function processUpdateSelColsResultXML(ajaxCallXml){
	var result = "";
	
	var resultTAG = ajaxCallXml.getElementsByTagName("result");
	if (resultTAG != null && resultTAG.length > 0 && resultTAG.item(0) != null) {
		var row = resultTAG.item(0);
		var result = row.getAttribute("status");
		var addCols = row.getAttribute("addCols");
		var delCols = row.getAttribute("delCols");
		
		if (result=="OK"){
			addColumnsToContainer(addCols, delCols);
			SYS_PANELS.closeAll();
			return;
		}
	}

	showMessage(ERR_SAVING_COLUMNS, GNR_TIT_WARNING, 'modalWarning');
	
}

function addColumnsToContainer(addCols, delCols) {
	var container = $('columnsContainer');
		
	//Borramos los que se deben borrar
	if (delCols!=""){
		var delColsArr = delCols.split(","); //["tabla.col.tipo", "tabla.col.tipo", .. ]
		var actualColsArr = $('selCols').get('value').split(",");
		var newCols = "";
		for (var i=0;i<actualColsArr.length;i++){
			var found=false;
			for (var j=0; j<delColsArr.length;j++) {
				if (actualColsArr[i] == delColsArr[j]){
					found = true;
					break;
				};
			}
			if (!found) {
				if (newCols == "") newCols = actualColsArr[i];
				else newCols += "," + actualColsArr[i];
			}
		}
		
		$('selCols').set('value', newCols);
	}
	
	//Agregamos las nuevas
	if (addCols!=""){
		var addColsArr = addCols.split(","); //[TABLE1.COL1.S, TABLE1.COL2.N, .. , TABLEN.COLN.D]
		for (var i=0;i<addColsArr.length;i++){
			var tabColArr = addColsArr[i].split('.');
			var tabCol = tabColArr[0] + '.' + tabColArr[1];
			var divElement = new Element('div', {'class': 'option', html: tabCol});
			divElement.setAttribute("id", tabCol);
			divElement.setAttribute("helper","true");
			
			var hiddenInput = new Element('input',{ type:'hidden','name':'chkColumn','value':tabCol}).inject(divElement);
			hiddenInput = new Element('input',{ type:'hidden','name':'colName','value':tabCol}).inject(divElement);
		 	
			divElement.container = container;
			divElement.addClass("optionRemove");
			
//			divElement.addEvent("click", function() {
//				var delCol = this.get('id'); //Columna a eliminar
//				var oldSelCols = $('selCols').value; //Columnas seleccionadas. Ej: "table1.col1.S,table2.col2.N,table2.col3.D"
//				var newSelCols = "";
//				
//				if (oldSelCols!=""){
//					var oldSelColsArr = oldSelCols.split(",");
//					for (var i=0;i<oldSelColsArr.length;i++){
//						if (oldSelColsArr[i] != delCol){
//							if (newSelCols == "") newSelCols = oldSelColsArr[i];
//							else newSelCols += "," + oldSelColsArr[i];
//						}
//					}
//					$('selCols').set('value', newSelCols);
//				}
//				
//				saveSelectedColumns(); //Mandamos al bean la modificacion realizada para que este actualizado
//			});
			
			divElement.addEvent("click", actionClickRemoveColumn);			
			
			divElement.addEvent("mouseenter", actionElementAdminMouseOverToggleClasss);
			divElement.addEvent("mouseleave", actionElementAdminMouseOverToggleClasss);
			
			divElement.inject(container.getLast(),'before');
			
			addFactTable(tabColArr[0]); //Agregamos la tabla al combo de tablas dispnibles para usar como tabla de hechos
		}
	}
	
	return divElement;
		
}

function actionClickRemoveColumn (evt) {
	var tableCol = evt.target.get('id');
	var tableColArr = tableCol.split('.');
	var tableName = tableColArr[0];
	var colName = tableColArr[1];
	
	//Creamos una nueva lista de columnas seleccionadas
	var lista = $('selCols').get('value');
	var listaArr = lista.split(',');
	var newLista = "";
	var cant=0;
	for (var i=0; i<listaArr.length; i++){
		var actTableCol = listaArr[i];
		var actTableColArr = actTableCol.split('.');
		if (actTableColArr[0] == tableName){
			cant++;
		}
		if (actTableColArr[0] == tableName && actTableColArr[1] == colName) {
			continue;//Si es la que estamos eliminando, seguimos con la siguiente
		}
		
		if (newLista == "") newLista = actTableCol;
		else newLista = newLista + "," + actTableCol;
	}
	
	//Nos fijamos si esta seleccionada la tabla de la columna seleccionada como tabla de hechos
	var tableSelected = $('radFactTable1').checked && tableName == $('selFactTable').value;
	if (tableSelected && $('gridMeasures').rows.length > 0){ //Si esta seleccionada la tabla de la columna seleccionada y hay medidas
		//Eliminamos la medida que utiliza la columna a eliminar
		var continuar = confirm("La columna seleccionada es utilizada en una medida. Si la elimina se eliminar� tambi�n la medida. �Desea continar?");
		if (!continuar){
			return;
		}else {
			//Eliminamos la medida
			borrarMedida(tableName+"."+colName);
			
			//Eliminamos la columna de los combos de columnas de cada medida
			trows=$('gridMeasures').rows;
			var i = 0;
			while (i<trows.length) {
				var tabCols = trows[i].getElements("TD")[0].getElements("SELECT")[0].getElements('option');
				for (var j=0; j<tabCols.length; j++){
					if (tabCols[j].get('value') == tableName + "." + colName){
						tabCols[j].destroy();
					}
				}
				i++;
			}
		}
	}
	
	//Si no hay mas columnas de la tabla de la columna eliminada, eliminamos la tabla de las tablas disponibles para usar como tabla de hechos  
	if (cant==1){//Solo habia una
		var tables = $('selFactTable').getElements('option');
		
		for (var i=0; i<tables.length; i++){
			if (tables[i].get('value') == tableName){
				tables[i].destroy();
			}
		}
	}
	
	//Guardamos la nueva lista de columna seleccionadas
	$('selCols').set('value', newLista);
	
	//Eliminamos la columna
	var f_binded = actionAlementAdminClickRemove.bind(this);
	f_binded(evt);
	
	saveSelectedColumns(); //Mandamos al bean la modificacion realizada para que este actualizado
}

function borrarMedida(value){
	trows=$('gridMeasures').rows;
	var to_delete = new Array();
	var i = 0;
	while (i<trows.length) {
		if (trows[i].getElements("TD")[0].getElements("SELECT")[0].value == value) {
			to_delete.push(trows[i]);
		}
		i++;
	}
	
	to_delete.each(function(obj){obj.destroy();});
}

//Devuelve un string con el formato: ",Tabla.Columna,Tabla.Columna,Tabla.Columna, .." con todas las Tablas y Columnas seleccionadas en el tab de Origen de los datos
function getColumns() {
	var ret = "";
	if ($('selCols')){
		var tabCols = $('selCols').value; //Tabla.Columna.Tipo,Tabla.columna.tipo,..
		if (tabCols){
			var tabColsArr = tabCols.split(",");
			
			for (var i=0; i<tabColsArr.length;i++) {
				var tabCol = tabColsArr[i].split(".");
				ret += "," + tabCol[0] + "." + tabCol[1];
			}
		}
	}
	
	if ($('radFactTable2').checked && $('viewSQLColumns')) {
		var factTableColumns = getFactTableColumns();
		var tabColsArr = factTableColumns.split(",");
		
		for (var i=0; i<tabColsArr.length;i++) {
			var tabCol = tabColsArr[i].split(".");
			if (tabCol!="" && ret.indexOf(tabCol[0] + "." + tabCol[1]) < 0)	ret += "," + tabCol[0] + "." + tabCol[1];
		}
		
		//if (factTableColumns) ret = ret + factTableColumns;
	}
	
	return ret;
}

//Devuelve un string con el formato: ",Tabla.Columna,Tabla.Columna,Tabla.Columna, .." con todas las columnas de la tabla de hechos
function getFactTableColumns() {
	var factTable = "";
	var isView = false;
	if ($('radFactTable1').checked){ //Si ahora esta seleccionado usar tabla
		factTable = $('selFactTable').get('value');
	}else {
		factTable = $('txtViewAlias').get('value');
		isView = true;
	}
	
	var ret = "";
	if (!isView && $('selCols')){
		var tabCols = $('selCols').value; //Tabla.Columna.Tipo,Tabla.columna.tipo,..
		if (tabCols==null) return "";
		var tabColsArr = tabCols.split(",");
		
		for (var i=0; i<tabColsArr.length;i++) {
			var tabCol = tabColsArr[i].split(".");
			if (tabCol[0] == factTable) ret += "," + tabCol[0] + "." + tabCol[1];
		}
	}else if ($('viewSQLColumns')) {
		var tabCols = $('viewSQLColumns').value; //Columna.Tipo, columna.tipo,..
		if (tabCols==null) return "";
		var tabColsArr = tabCols.split(",");
		
		for (var i=0; i<tabColsArr.length;i++) {
			var tabCol = tabColsArr[i].split(".");
			ret += "," + factTable + "." + tabCol[0];
		}
	}
	return ret;
}

//Debe devolver un string con el formato: ",tabla1,tabla2,tabla3,..."
function getTables() {
	var ret = "";
	if ($('selCols')){
		var tabCols = $('selCols').value; //Tabla.Columna.Tipo,Tabla.columna.tipo,..
			
		var fields = tabCols.split(',');
		var table_hash = {};
		var tables = new Array();
		
		for(var i = 0; i < fields.length; i++) {
			var tbl = fields[i].split('.')[0];
			var fld = fields[i].split('.')[1];
			if(!table_hash[tbl]) {
				table_hash[tbl] = new Array();
				tables.push(tbl);
			}
			table_hash[tbl].push(fld);
		}
		
		for (var i=0; i<tables.length; i++) {
			ret += "," + tables[i];
		}
	}
	return ret;
}
