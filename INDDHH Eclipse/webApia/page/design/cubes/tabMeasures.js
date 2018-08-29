//Variables utilizadas para controlar cuando se modifica la tabla de hechos, si se cambia se deben eliminar y crear nuevamente las medidas
var radTableSelected;
var factTableTable;
var factTableAlias;
var factTableSQL;

function initMeasuresTab(mode) {
	
	var radFactTable1 = $('radFactTable1');
	var radFactTable2 = $('radFactTable2');
	
	if (radFactTable1){
		//Al presionar el bot�n Agregar se recupera un string con nombre de tablas separdos por , y se procesan en el metodo processXMLmodalAddTables()
		radFactTable1.addEvent("click",function(e){
			if (($('gridMeasures').rows.length == 0) || canChangeFactTable(1)){
				changeRadFact(1);	
				radTableSelected=true;
			}else {
				$('radFactTable1').checked = false;
				$('radFactTable2').checked = true;
			}
		});
	}
	
	if (radFactTable2){
		//Al presionar el bot�n Agregar se recupera un string con nombre de tablas separdos por , y se procesan en el metodo processXMLmodalAddTables()
		radFactTable2.addEvent("click",function(e){
			if (($('gridMeasures').rows.length == 0) || canChangeFactTable(2)){
				changeRadFact(2);
				radTableSelected=false;
			}else {
				$('radFactTable1').checked = true;
				$('radFactTable2').checked = false;
			}
		});
	}
	
	loadFactTables(); //Cargamos las tablas que se pueden usar como tabla de hechos
	
	if ($('btnTest')){
		$('btnTest').addEvent("click", function(e){
			testSQL(false,'');
		});
	}
	$('panelOptions').style.display = 'none';
		
	
	if ($('selFactTable')){
		$('selFactTable').addEvent("change", function(e){
			if (($('gridMeasures').rows.length > 0) && !canChangeFactTable()){ //Si hay medidas y no se desea modificar
				$('selFactTable').set('value', factTableTable); //Volvemos al valor que estaba antes
			}
		});
	}
	
	if ($('txtViewAlias')){
		$('txtViewAlias').addEvent("change", function(e){
			if (($('gridMeasures').rows.length > 0) && !canChangeFactTable()){
				$('txtViewAlias').value = factTableAlias;
			}
		});
	}
	
	if ($('txtFactTableView')){
		$('txtFactTableView').addEvent("change", function(e){
			if (($('gridMeasures').rows.length > 0) && !canChangeFactTable()){
				$('txtFactTableView').value = factTableSQL;
			}
		});
	}
	
	$('measuresTable').getElement('div.gridBody').addEvent('scroll', function() {
		if(Browser.ie7) {
			$('measuresTable').getElement('div.gridHeader').scrollTo(this.scrollLeft, 0);
		} else {
			$('measuresTable').getElement('div.gridHeader').getElement('table').setStyle('left', - this.scrollLeft);				
		}
	});
	
	loadFactTableVariables();
	gridControl();
	loadMeasures();
	
	$('gridBodyMeasures').addEvent('custom_scroll', function(left) {			
		$('measuresTable').getElement('div.gridHeader').getElement('table').setStyle('left', left);
	});
	
}

function gridControl() {
	var btnAddMea = $('btnAddMea');
	if (btnAddMea){
		btnAddMea.addEvent("click",function(e){
			e.stop();
//			SYS_PANELS.showLoading();
			btnAddMeasure_click();
//			SYS_PANELS.showLoading = false;
		});
	}
	
	var btnDeleteMea = $('btnDeleteMea');
	if (btnDeleteMea){
		btnDeleteMea.addEvent("click",function(e){
			e.stop();
			deleteRow('gridMeasures');
			//Corregir grilla
			addScrollTable($('gridMeasures'));
		});
	}
}

//btn: Agregar Medida --> Abrega una medida
function btnAddMeasure_click() {
/*
Agregado de medidas: Hay dos tipos de medidas: Medidas comunes que utilizan una columna de la tabla de hechos y medidas calculadas que utilzan otras medidas
*/
	// agregamos como tipo Measure por defecto
	if ($('radFactTable2').checked){ //Si se ingreso una consulta como vista
		//Verificamos haya ingresado un alias
		if (document.getElementById("txtViewAlias").value == ""){
			showMessage(MSG_MUST_ENT_VW_ALIAS_FIRST, GNR_TIT_WARNING, 'modalWarning');
			return;
		}
		//Verificamos que la vista no tenga comillas dobles
		if (document.getElementById("txtFactTableView").value.indexOf("\"")>0){
			showMessage(MSG_ERROR_IN_SQL_VIEW_WITH_COMS, GNR_TIT_WARNING, 'modalWarning');
			return;
		}
	
		testSQL('btnAddMeasure', 'afterGetCols'); //Testeamos la sql, recuperamos las columnas y agregamos la medida
	}else{
		$('btnDeleteMea').erase('disabled');
		fncAddMeasure();
	}
}

//btn: Eliminar Medida --> Elimina una medida
function btnDelMeasure_click() {
	var selected = new Array(getSelectedRows($('gridMeasures'))[0]);
	deleteRowsMea(selected,'gridMeasures');
	
	//Corregir grilla
	addScrollTable($('gridMeasures'));
}	

function loadFactTableVariables() {
	if ($('radFactTable1').checked){
		factTableTable = $('selFactTable').value;
		factTableAlias = "";
		factTableSQL = "";
		radTableSelected=true;
		$('txtViewAlias').removeClass('validate["required"]');
	}else {
		factTableTable = "";
		factTableAlias = $('txtViewAlias').value;
		factTableSQL = $('txtFactTableView').value;
		radTableSelected=false;
		$('txtViewAlias').addClass('validate["required"]');
	}
}

//Retorna si hay que volver para atras o seguir
function canChangeFactTable(rad) {
	var changed=false;
	
	if (rad==1){ //Ahora se selecciono usar tabla
		if (!radTableSelected) changed = true //Si antes no se usaba tabla
		else if (factTableTable != $('selFactTable').value){ //Antes se usaba una tabla pero es distinta a la que hay ahora
			changed = true;
		}
		$('txtViewAlias').removeClass('validate["required"]'); //El input del alias ya no es requerido
		$('btnTest').set('disabled','disabled'); //Deshabilitamos el bot�n de testear la vista
		
	}else if (rad==2){//Ahora se selecciono usar vista
		if (radTableSelected) changed = true //Si antes se usaba tabla
		else if (factTableAlias != $('txtViewAlias').value || factTableSQL != $('txtFactTableView').value){ //Antes se usaba vista y ahora se modifico el alias o la sql
			changed = true;
		}
		$('txtViewAlias').addClass('validate["required"]');//El input del alias ahora es requerido
		$('btnTest').erase('disabled'); //Habilitamos el bot�n de testear la vista 

	}else { //La funci�n no se llamo al hacer click en un radioButton (se llam� al iniciar)
		if ($('radFactTable1').checked){ //Si ahora esta seleccionado usar tabla
			if (!radTableSelected) changed = true //Si antes no se usaba tabla
			else if (factTableTable != $('selFactTable').value){ //Antes se usaba una tabla pero es distinta a la que hay ahora
				changed = true;
			}
		}else {//Ahora esta seleccionada usar vista
			if (radTableSelected) changed = true //Si antes se usaba tabla
			else if (factTableAlias != $('txtViewAlias').value || factTableSQL != $('txtFactTableView').value){ //Antes se usaba vista y ahora se modifico el alias o la sql
				changed = true;
			}
		}
	}
	
	if (changed) {
		showConfirm (	MESSAGES_MSG_DEL_MEAS,
						MESSAGES_TIT, 	
						function(confirm) { 
							if (confirm) {
								//Borrar todas las medidas
								deleteAllMeasures();
								loadFactTableVariables();
								if (rad == 1 || rad == 2) {
									changeRadFact(rad);
									$('radFactTable' + rad).set('checked', true);
								}
								return true;
							} else {
								return false;
							}
						}
					)
//		
//		showConfirm('Hola');
//		var res = confirm("Si modifica la tabla de hechos seleccionada, se perder�n todas las medidas actuales. �Desea continuar?");
//		if (res){
//			//Borrar todas las medidas
//			deleteAllMeasures();
//			loadFactTableVariables();
//			return true;
//		}
	}
	
	return false;
}

function changeRadFact(val){
	if (val == 1){
		$('selFactTable').set('disabled',false);
		$('txtViewAlias').set('disabled',true);
		$('txtFactTableView').set('disabled',true);
		$('panelOptions').style.display='none'; //Ocultamos panel de opciones 
		$('radFactTable2').set('checked',false);
	}else {
		$('txtFactTableView').set('disabled',false);
		$('txtViewAlias').set('disabled',false);
		$('panelOptions').style.display=''; //Mostramos panel de opciones 
		$('selFactTable').set('disabled',true);
		$('radFactTable1').set('checked',false);
	}
	loadFactTableVariables();
}

function loadFactTables() {
	var selCols = $('selCols').value; //Columnas seleccionadas
	var selColsArr = selCols.split(",");
	var tables = "";
	
	addFactTable("");
	
	for (var i=0;i<selColsArr.length;i++){
		var tableName = selColsArr[i].split(".")[0];
		addFactTable(tableName);
	}
}

//Agrega la tabla al combo de tablas disponibles para usar como tabla de hechos (si ya no se agrego)
function addFactTable(newTableName){
	var selFactTable = $('selFactTable');
	var tables = selFactTable.getElements('option');
	
	for (var i=0; i<tables.length; i++){
		if (tables[i].value == newTableName){
			return;
		}
	}
	
	//Agregamos la tabla al combo
	var opt = new Element('option', {
		  html: newTableName,
		  value: newTableName
	}).inject(selFactTable);
	
	if(selFactTable.get('initVal') == newTableName)
		opt.set('selected', 'true');
}

function testSQL(onConfirm, afterAction) {
	var sql = $('txtFactTableView').value;
	var selConn = $('selConn').value; //Conexi�n seleccionada en este momento
	var alias = $('txtViewAlias').value; //Alias
	extra = {'sql':sql, 'selConn': selConn, 'onConfirm':onConfirm, 'afterAction':afterAction, 'alias':alias};
	
	if (alias=="") {
		showMessage(MSG_ALIAS_NOT_FOUND, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
	
	if (sql=="") {
		showMessage(MSG_VIEW_NOT_FOUND, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
	
	var request = new Request({
		method: 'post',			
		data:extra,
		url: CONTEXT + URL_REQUEST_AJAX+'?action=sqlTest&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) {modalProcessXml(resXml); }
	}).send();
}

function loadMeasures() {
	var request = new Request({
		method: 'post',			
		url: CONTEXT + URL_REQUEST_AJAX+'?action=getCubeMeasures&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) {loadMeasuresXML(resXml);  }
	}).send();
}

function loadMeasuresXML(ajaxCallXml){
	if (ajaxCallXml != null) {
		var measures = ajaxCallXml.getElementsByTagName("measures");
		if (measures != null && measures.length > 0 && measures.item(0) != null) {
			measures = measures.item(0).getElementsByTagName("measure");
			for(var i = 0; i < measures.length; i++) {
				var measure = measures.item(i);
				
				var column = measure.getAttribute("src");
				var name = measure.getAttribute("name");
				var showName = measure.getAttribute("showName");
				var type = measure.getAttribute("type");
				var funcion = measure.getAttribute("function");
				var format = measure.getAttribute("format");
				var visible = measure.getAttribute("visible");
				
				fncAddMeasure(column,name,showName,type,funcion,format,visible);
			}
		}
	}
}

function afterGetCols(xml){
	var ajaxCallXml = getLastFunctionAjaxCall();
	var colsInfo = ajaxCallXml.getElementsByTagName("html").item(0).firstChild.nodeValue;
	
	if (colsInfo == "NOK"){
		showMessage(MSG_ERROR_IN_SQL, GNR_TIT_WARNING, 'modalWarning');
		return;
	}else {//Se recuperaron las columnas correctamente!
		$('viewSQLColumns').set('value', colsInfo);
		
		//document.getElementById("btnDelMeasure").disabled = false;
		fncAddMeasure();
	}
	SYS_PANELS.closeActive();
}

function fncAddMeasure(column, measureName, measureNameToShow, typeMeasure, funcion, format, visible){
	var parent = $('gridMeasures').getParent();
	$('gridMeasures').selectOnlyOne = false; 
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].getStyle('width');
			if (! tdWidths[i]) tdWidths[i] = headers[i].get('width');
		}
	}
	
	if (measureName==null) {
		measureName = "MEASURE" + (document.getElementById("gridMeasures").rows.length + 1);
		measureNameToShow = measureName;
	}
	var useTable = $('radFactTable1').checked; //Si ahora esta seleccionado usar tabla
	
	var oTd0 = new Element("TD"); //campo fuente
	var oTd1 = new Element("TD"); //nombre
	var oTd2 = new Element("TD"); //nombre a mostrar
	var oTd3 = new Element("TD"); //tipos de medida
	var oTd4 = new Element("TD"); //funci�n
	var oTd5 = new Element("TD"); //formato
	var oTd6 = new Element("TD"); //formula
	var oTd7 = new Element("TD",{styles:{'border-right':'none'}}); //visible
	
	var div = new Element('div', {styles: {width: tdWidths[0], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	var tdWidth = Number.from(tdWidths[0]) - 5;
	var selector = new Element('select', {name:'selColumn','onchange':'changeFunction(this)'}).setStyle('width', tdWidth);
	
	var selType = null;
	if (typeMeasure==null) typeMeasure = 'standard';
	
	//Valores para el campo fuente (segun si se selecciono una tabla o una vista)
	if (useTable){ //Usa tabla existente
		//Obtenemos todas las columnas seleccionadas:
		var cols = $('selCols').value; //"TABLA1.COL1.S,TABLA1.COL2.N,...,TABLA1.COL4.D"
		var tableSelected = $('selFactTable').value;
		if (cols == "NOK"){return;}
		var colsArr = cols.split(',');
		for (var id=0; id<colsArr.length; id++){
			var colsParts = colsArr[id].split('.');
			var optNom = colsParts[0] + "." + colsParts[1];
			var tableName = colsParts[0];
			
			if (tableName == tableSelected) {
				var optionDOM = new Element('option');
				optionDOM.set('value',optNom);
				if (column!=null && column == colsParts[1]) optionDOM.set('selected', 'selected');
				optionDOM.appendText(optNom);
				optionDOM.inject(selector);
				
				if (selType==null) selType = colsParts[2];
			}
		}
		if (typeMeasure!='standard') {
			selector.style.display='none';
		}
		selector.inject(div);
		div.inject(oTd0);
	}else{ //Usa una vista
		//Recuperamos las columnas de la vista
		var cols = $('viewSQLColumns').value; //Lista de columnas con su tipo: "COLUMNA1.S,COLUMNA2.N,..,COLUMNAX.S"
		var alias = $('txtViewAlias').value;
		
		if (cols == "NOK"){return;}
		var colsArr = cols.split(',');
		for (var id=0; id<colsArr.length; id++){
		//while (cols.indexOf(",")>-1){
			var colsParts = colsArr[id].split('.');
			//var colName = colsParts[0] + "." + colsParts[1];//cols.substring(0,cols.indexOf(",")); //COLUMNA1.S
			var optNom = alias + "." + colsParts[0]; //ALIAS.COLUMNA1
			
			var optionDOM = new Element('option');
			optionDOM.set('value',optNom);
			if (column!=null && column == colsParts[0]) optionDOM.set('selected', 'selected');
			optionDOM.appendText(optNom);
			optionDOM.inject(selector);
			
			if (selType==null) selType = colsParts[1];
		}
		
		if (typeMeasure!='standard') {
			selector.style.display='none';
		}
		selector.inject(div);
		div.inject(oTd0);
	}
	
	//Nombre
	div = new Element('div', {styles: {width: tdWidths[1], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	var input = new Element('input',{type:'text',name:'name','onchange':'chkMeasName(this)'});
	input.set('value',measureName);
	input.setStyle('width', tdWidths[1]);
	input.setStyle('width',  Number.from(tdWidths[1]) - 5);
	input.inject(div);
	div.inject(oTd1);
	
	//Nombre a mostrar 
	div = new Element('div', {styles: {width: tdWidths[2], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	input = new Element('input',{type:'text',name:'dispName','onchange':'chkMeasName(this)'});
	input.set('value',measureNameToShow);
	input.setStyle('width',  Number.from(tdWidths[2]) - 5);
	input.inject(div);
	if (typeMeasure!='standard') {
		input.style.display='none';
	}
	div.inject(oTd2);
	
	//Tipo de medida
	div = new Element('div', {styles: {width: tdWidths[3], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	var tdWidth = tdWidths[3].substring(0, tdWidths[3].indexOf('px')) - 5;
	selector = new Element('select',{name:'selTypeMeasure','onchange':'changeMeasureType(this)'}).setStyle('width', tdWidth);;
	
	var optionDOM = new Element('option');
	optionDOM.set('value',0);
	optionDOM.appendText(LBL_MEAS_STANDARD);
	if (typeMeasure=='standard') optionDOM.set('selected','selected');
	optionDOM.inject(selector);
	
	optionDOM = new Element('option');
	optionDOM.set('value',1);
	optionDOM.appendText(LBL_MEAS_CALCULATED);
	if (typeMeasure!='standard') optionDOM.set('selected','selected');
	optionDOM.inject(selector);
	
	selector.inject(div);
	div.inject(oTd3);
	
	//Funci�n
	div = new Element('div', {styles: {width: tdWidths[4], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	var tdWidth = tdWidths[4].substring(0, tdWidths[4].indexOf('px')) - 5;
	//if (typeMeasure=='standard') {
		selector = new Element('select',{name:'selAgregator'}).setStyle('width', tdWidth);
		//if (selType == "S" || selType == "D"){
		var numericFunctions = true;
		if (funcion) {
			if (funcion == "COUNT" || funcion == "DISTINCT COUNT") {
				numericFunctions = false;
			}
		}else if (selType == "S" || selType == "D") {
			numericFunctions = false;
		}
		
		if (!numericFunctions) {
			optionDOM = new Element('option');
			optionDOM.set('value',2);
			if (funcion!=null && funcion == 'COUNT') optionDOM.set('selected', 'selected');
			optionDOM.appendText('COUNT');							
			optionDOM.inject(selector);
			
			optionDOM = new Element('option');
			optionDOM.set('value',5);
			if (funcion!=null && funcion == 'DISTINCT COUNT') optionDOM.set('selected', 'selected');
			optionDOM.appendText('DISTINCT COUNT');	
			
			if (typeMeasure!='standard') {
				selector.style.display='none';
			}
			optionDOM.inject(selector);
			
		}else{
			optionDOM = new Element('option');
			optionDOM.set('value',0);
			optionDOM.appendText('SUM');
			if (funcion!=null && funcion == 'SUM') optionDOM.set('selected', 'selected');
			optionDOM.inject(selector);
			
			optionDOM = new Element('option');
			optionDOM.set('value',1);
			optionDOM.appendText('AVG');
			if (funcion!=null && funcion == 'AVG') optionDOM.set('selected', 'selected');
			optionDOM.inject(selector);
			
			optionDOM = new Element('option');
			optionDOM.set('value',2);
			optionDOM.appendText('COUNT');
			if (funcion!=null && funcion == 'COUNT') optionDOM.set('selected', 'selected');
			optionDOM.inject(selector);
			
			optionDOM = new Element('option');
			optionDOM.set('value',3);
			optionDOM.appendText('MIN');
			if (funcion!=null && funcion == 'MIN') optionDOM.set('selected', 'selected');
			optionDOM.inject(selector);
			
			optionDOM = new Element('option');
			optionDOM.set('value',4);
			optionDOM.appendText('MAX');
			if (funcion!=null && funcion == 'MAX') optionDOM.set('selected', 'selected');
			optionDOM.inject(selector);
			
			optionDOM = new Element('option');
			optionDOM.set('value',5);
			optionDOM.appendText('DISTINCT COUNT');
			if (funcion!=null && funcion == 'DISTINCT COUNT') optionDOM.set('selected', 'selected');
			
			if (typeMeasure!='standard') {
				selector.style.display='none';
			}
			optionDOM.inject(selector);
		}
		selector.inject(div);
	//}
	div.inject(oTd4);

	//Formato
	div = new Element('div', {styles: {width: tdWidths[5], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	input = new Element('input',{type:'text',name:'format'});
	if (format==null) format = '#,###.0';
	input.set('value', format);
	if (typeMeasure!='standard') {
		input.setStyle('display', 'none');
	}
	input.setStyle('width',  Number.from(tdWidths[5]) - 5);
	
	input.inject(div);
	div.inject(oTd5);
	
	//Formula
	div = new Element('div', {styles: {width: tdWidths[6], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	input = new Element('input',{type:'text', name:'formula', title:'[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos','onchange':'chkFormula(this,null)'});
	if (typeMeasure=='standard') {
		input.setStyle('display', 'none');
	} else if (funcion!=null) {
		input.set("value", funcion); //la misma variable es utilizada para la formula
	}
	input.setStyle('width',  Number.from(tdWidths[6]) - 5);
	input.inject(div);
	div.inject(oTd6);
	
	//Visible
	div = new Element('div', {styles: {width: tdWidths[7], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	if (visible==null) visible = "true";
	input = new Element('input',{type:'checkbox',name:'visible',checked:visible=="true"});							
	input.inject(div);
	div.inject(oTd7);
	
	var oTr = new Element("TR");
	
	oTd0.inject(oTr);
	oTd1.inject(oTr);
	oTd2.inject(oTr);
	oTd3.inject(oTr);
	oTd4.inject(oTr);
	oTd5.inject(oTr);
	oTd6.inject(oTr);
	oTd7.inject(oTr);
	
	oTr.addClass("selectableTR");
	oTr.getRowId = function () { return this.getAttribute("rowId"); };
	oTr.setRowId = function (a) { this.set("rowId",a); };
	oTr.set("rowId", $('gridMeasures').rows.length);
	
	oTr.addEvent("click",function(e){myToggle(this)}); 
	
	if($('gridMeasures').rows.length%2==0){
		oTr.addClass("trOdd");
	}
	
	oTr.inject($('gridMeasures'));		
	
	var rowIndx = oTr.rowIndex - 1;
	input.set('value',rowIndx); //le damos valor al checkbox para poder leer cuales fueron presionados desde el bean
	
	//Correccion de grilla
	addScrollTable($('gridMeasures'));
}


function changeFunction(obj){
	var name = obj.options[obj.selectedIndex].text; //ALIAS.COLUMNA
	name = name.substring(name.indexOf('.')+1, name.length);
	//chgHidValue(obj,name);
	
	//Segun el tipo de la columna seleccionada --> son los tipos de funciones que se pueden utilizar
	var type = getColType(name); //Obtenemos el tipo de la columna seleccionada

	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
		
	var selector = father.getElementsByTagName("SELECT")[2];
	
	if (type == "N" || type =="S" || type == "D"){
		//1- Borramos todas las funciones del combo Agregador
		while(selector.options.length>0){
			selector.options[0].parentNode.removeChild(selector.options[0]);
		}
		
		//2- Agregamos segun el tipo de la columna seleccionada
		var opt;
		if (type=="N"){
			
			var optionDOM = new Element('option');
			optionDOM.set('value',0);
			optionDOM.appendText('SUM');							
			optionDOM.inject(selector);
			
			optionDOM = new Element('option');
			optionDOM.set('value',1);
			optionDOM.appendText('AVG');							
			optionDOM.inject(selector);
			
			optionDOM = new Element('option');
			optionDOM.set('value',2);
			optionDOM.appendText('COUNT');							
			optionDOM.inject(selector);
			
			optionDOM = new Element('option');
			optionDOM.set('value',3);
			optionDOM.appendText('MIN');							
			optionDOM.inject(selector);
			
			optionDOM = new Element('option');
			optionDOM.set('value',4);
			optionDOM.appendText('MAX');							
			optionDOM.inject(selector);
			
			optionDOM = new Element('option');
			optionDOM.set('value',5);
			optionDOM.appendText('DIST. COUNT');							
			optionDOM.inject(selector);
			
		}else{
			optionDOM = new Element('option');
			optionDOM.set('value',2);
			optionDOM.appendText('COUNT');							
			optionDOM.inject(selector);
			
			optionDOM = new Element('option');
			optionDOM.set('value',5);
			optionDOM.appendText('DIST. COUNT');							
			optionDOM.inject(selector);
		}
	}
}

function getColType(name) {
	
	var cols = "";
	if ($('radFactTable1').checked){ //Si ahora esta seleccionado usar tabla
		cols = $('selCols').value;
	}else {
		cols = $('viewSQLColumns').value; //Lista de columnas con su tipo: "COLUMNA1.S,COLUMNA2.N,..,COLUMNAX.S"	
	}
	
	if (cols==null || cols=="") return "";
	var colsArr = cols.split(','); //["COLUMNA1.S","COLUMNA2.N",..]
	for (var i=0;i<colsArr.length;i++){
		coli = colsArr[i];
		var colName = "";
		var coliArr = coli.split('.');
		var indx = 0;
		if (coliArr.length>2){
			indx=1; 
		}
		
		if (coliArr[indx] == name){
			return coliArr[indx+1];
		}
	}
	return "";
}

//Funcion llamada cuando se cambia el tipo de una medida
function changeMeasureType(obj){
	var val = obj.value;
	var selColumn = obj.getParent('TR').getChildren()[0].getElement('SELECT');
	var inputFormula = obj.getParent('TR').getChildren()[6].getElement('INPUT');
	var selFuncion = obj.getParent('TR').getChildren()[4].getElement('SELECT');
	var inputFormato = obj.getParent('TR').getChildren()[5].getElement('INPUT');
	
	if (val == 0){ //Measure
		selColumn.setStyle('display',''); //mostramos campo fuente
		inputFormula.setStyle('display', 'none'); //ocultamos formula
		selFuncion.setStyle('display',''); //mostramos aggregator
		inputFormato.setStyle('display',''); //mostramos formato
		
	}else { //Calculated Member
		selColumn.setStyle('display','none'); //ocultamos campo fuente
		inputFormula.setStyle('display', '');
		selFuncion.setStyle('display','none');
		inputFormato.setStyle('display','none');//ocultamos formato
	}
}

function myToggle(oTr){
	if (oTr.getParent().selectOnlyOne) {
		var parent = oTr.getParent();
		if (parent.lastSelected) parent.lastSelected.toggleClass("selectedTR");
		parent.lastSelected = oTr;
	}
	oTr.toggleClass("selectedTR"); 
}

function deleteAllMeasures(){
	$('gridMeasures').getElements('TR').destroy();
}
