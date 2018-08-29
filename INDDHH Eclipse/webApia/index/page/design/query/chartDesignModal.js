
var URL_REQUEST_AJAX = '/apia.design.QueryAction.run';
var calSpinner = null;

window.addEvent('domready', function() {
	initChart();
	
	calSpinner = new Spinner('ifrChartSample', {
		destroyOnHide: true
		/*style: {width: cal_spinner_width, height: cal_spinner_height}*/
	});
	
	calSpinner.show();
});

function initPage(){//Funcion necesaria en todo jsp de la 3.0
	//Este método es invocado al princpio
} 

function initChart(){ //Este método es invocado luego de cargada la página
	loadSeriesEvents();
	
	var request = new Request({
		method: 'post',			
		data:{},
		url: CONTEXT + URL_REQUEST_AJAX+'?action=getChartData&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) {loadChartDesignFromXML(resXml); SYS_PANELS.closeAll(); }
	}).send();
	
}

/*
 	 * <result>
	 * 	<chart type="" subType="" title="" titleY="" titleX="" colorSchema="" viewGrid="" viewLegend="" viewValues="">
	 *  <columns>
	 *  	<column name="" attId="" busClaParId="" selected=""/>
	 *  	..
	 *  	<column name="" attId="" busClaParId="" selected=""/>
	 *  </columns>
	 *  <series>
	 *     <serie id="" name="" color="" show="" attId="" busClaParId=""/>
	 *     ..
	 *     <serie id="" name="" color="" show="" attId="" busClaParId=""/>
	 *  </series> 
	 *  <schemas>
	 *     <schema id="" name=""/>
	 *     ..
	 *     <schema id="" name=""/>
	 *  </schemas> 
	 * </result>
 */
function loadChartDesignFromXML(ajaxCallXml) {
	if (ajaxCallXml != null) {
		var chart = ajaxCallXml.getElementsByTagName("chart");
		if (chart==null || chart.item(0) == null) return;
		
		readColorsXML(ajaxCallXml);
		readColumnsXML(ajaxCallXml);
		
		if ("" == chart.item(0).getAttribute("type")) $('chtType').set('value', 0);
		else $('chtType').set('value', chart.item(0).getAttribute("type"));
		if ("" == chart.item(0).getAttribute("subtype")) $('chtSubType').set('value', 1);
		else $('chtSubType').set('value', chart.item(0).getAttribute("subtype"));
		$('chtTitle').set('value', chart.item(0).getAttribute("title"));
		$('chtTitleX').set('value', chart.item(0).getAttribute("titleX"));
		$('chtTitleY').set('value', chart.item(0).getAttribute("titleY"));
		$('chtColors').set('value', chart.item(0).getAttribute("colorSchema"));
		if (!("true" == chart.item(0).getAttribute("viewGrid"))) $('chkGrid').set('checked', false);
		if (!("true" == chart.item(0).getAttribute("viewLegend"))) $('chkLegend').set('checked', false);
		if (!("true" == chart.item(0).getAttribute("viewValues"))) $('chkValues').set('checked', false);
		
		readSeriesXML(ajaxCallXml);
		
		chtTypeChange(true);
		showChart();
	}
}

function showChart() {
	$('ifrChartSample').set('src', 'chartSample.jsp?chartType=' + $('chtType').get('value') + '&chtSubType='+ $('chtSubType').get('value') +
			'&chartSchema=' + $('chtColors').get('value') + '&seriesColor=' + getSeriesColors() +
			'&viewGrid=' + $('chkGrid').get('checked') + '&viewLegend=' + $('chkLegend').get('checked') + '&viewValues=' + $('chkValues').get('checked'));
	
	calSpinner.hide();
}

function loadSeriesEvents() {
	
	var btnUpSeries = $('btnUpSeries');
	if (btnUpSeries){
		btnUpSeries.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($("bodySeries")) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($("bodySeries"))[0].rowIndex;
				upRow(parseInt(pos),"bodySeries");
			}		
		});
	}
	
	var btnDownSeries = $('btnDownSeries');
	if (btnDownSeries){
		btnDownSeries.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($("bodySeries")) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($("bodySeries"))[0].rowIndex;
				downRow(parseInt(pos),"bodySeries");
			}
		});
	}
}

function processLoadInitChart(CHART_TYPE,CHART_SUB_TYPE){
	var resXml = getLastFunctionAjaxCall();
	
	/////////////////Cargamos la grafica por defecto/////////
	if ((CHART_TYPE != null) && (CHART_SUB_TYPE != null)){
		$("imgSample").src=typSamples[CHART_TYPE][CHART_SUB_TYPE];
	}else {
		$("imgSample").src=typSamples[0][1];
	}
	
	processTableSeries(resXml);
	
	changeChartLabelXLabel();
	
	$('confGraph').style.visibility='visible';
	$('btnCancel').style.visibility='visible';
	
	lockSerie();
}

function changeChartLabelXLabel(){
	var selected = $("chtType").options[$("chtType").selectedIndex].text;
	if (selected==PIE_TYPE){
		$('labelX').innerHTML=CHART_CATEGORY;
		$("divTitX").style.display='none';
		$("divTitY").style.display='none';
	}else{
		$('labelX').innerHTML=CHART_LABELX;
		$("divTitX").style.display='block';
		$("divTitY").style.display='block';
	}
}

//vacia el combo pasado por parametro
function cleanCombo(cmbId) {
	if ($(cmbId)) {
		var options = $(cmbId).getElements('option');
		for ( var i = 0; i < options.length; i++) {
			options[i].destroy();
		}
	}
}

//Carga los esquemas de colores definidos
function loadColorSchemas() {
	cleanCombo('chtColors'); // vaciamos el combo de vistas
	new Element('option', {html : "Definida en cada serie", value : "0"}).inject($('chtColors'));
	var request = new Request({
		method : 'post', 
		url : CONTEXT + URL_REQUEST_AJAX + '?action=getColorSchemas&isAjax=true' + TAB_ID_REQUEST,
		onComplete : function(resText, resXml) {
			readColorsXML(resXml);
		}
	}).send();
}

// Lee el xml resultado de solicitar los schemas de colores por defecto
function readColorsXML(ajaxCallXml) {
	if (ajaxCallXml != null) {
		var schemas = ajaxCallXml.getElementsByTagName("schemas");
		if (schemas != null && schemas.length > 0 && schemas.item(0) != null) {
			var selColor = schemas.item(0).getAttribute("selSchema");
			schemas = schemas.item(0).getElementsByTagName("schema");
			var ele = new Element('option', {html : "", value : "0"}).inject($('chtColors'));
			for ( var i = 0; i < schemas.length; i++) {
				var schema = schemas.item(i);

				var schId = schema.getAttribute("id");
				var schName = schema.getAttribute("name");
				
				var ele = new Element('option', {html : schName, value : schId}).inject($('chtColors'));
				
				if (selColor == schId){
					ele.set('selected',true);
					lockColorSelect();
				}
			}
		}
	}
}

function readColumnsXML(ajaxCallXml) {
	if (ajaxCallXml!=null) {
		var columns = ajaxCallXml.getElementsByTagName("columns");
		if (columns != null && columns.length > 0 && columns.item(0) != null) {
			columns = columns.item(0).getElementsByTagName("column");
			
			for(var i = 0; i < columns.length; i++) {
				var column = columns.item(i);
				
				//var id = serie.getAttribute("id");
				var name = column.getAttribute("name");
				var selected = column.getAttribute("selected");
				
				var ele = new Element('option', {html : name, value : name}).inject($('chtColX'));
				
				if (selected){
					ele.set('selected',true);
				}
			}
		}
	}
}

function readSeriesXML(ajaxCallXml) {
	if (ajaxCallXml!=null) {
		var series = ajaxCallXml.getElementsByTagName("series");
		if (series != null && series.length > 0 && series.item(0) != null) {
			series = series.item(0).getElementsByTagName("serie");
			
			for(var i = 0; i < series.length; i++) {
				var serie = series.item(i);
				
				var id = serie.getAttribute("id");
				var name = serie.getAttribute("name");
				var color = serie.getAttribute("color");
				var show = serie.getAttribute("show");
				var attId = serie.getAttribute("attId");
				var busClaParId = serie.getAttribute("busClaParId");
				
				fncAddSeries(id, name, color, show, attId, busClaParId);
			}
			
			addScrollTable($('bodySeries'));
		}else {
			showMessage(MSG_WID_QRY_ERR, GNR_TIT_WARNING, 'modalWarning');
		}
	}
}

function fncAddSeries(id, name, color, show, attId, busClaParId) {
	var parent = $('bodySeries').getParent();
	$('bodySeries').selectOnlyOne = false; 
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			//tdWidths[i] = headers[i].getStyle('width');
			if (! tdWidths[i]) tdWidths[i] = headers[i].get('width');
		}
	}
	
	var oTd0 = new Element("TD"); //name
	var oTd1 = new Element("TD"); //color
	var oTd2 = new Element("TD"); //show
	
	oTd0.setAttribute("colId", id);
	oTd0.setAttribute("attId", attId);
	oTd0.setAttribute("busClaParId", busClaParId);
	
	//Nombre
	var div = new Element('div').setStyles({
		width: tdWidths[0], 
		overflow: 'hidden', 
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	
	var label = new Element('label',{type:'text',name:'chtSerColName',id:'chtSerColName'});
	label.set('html',name);
	label.setStyle('width', tdWidths[0]);
	label.setStyle('width',  Number.from(tdWidths[0]) - 5);
	label.inject(div);
	
	div.inject(oTd0);
	
	//Color
	div = new Element('div', {styles: {width: tdWidths[1], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	
	var inputColorHexId = 'zneColorHex' + $('bodySeries').getElements('tr').length;
	var inputHex = new Element('input',{type:'text', name:inputColorHexId, id:inputColorHexId});
	if (color==null) color= "#808080";
	inputHex.set('value', color);
	inputHex.setStyle('width',  Number.from(tdWidths[1]) / 2 - 5);
	inputHex.inject(div);
	
	var imgId = 'img' + $('bodySeries').getElements('tr').length;
	
	var img = new Element('img', {id:imgId, styles: {width: 15, height:13, marginLeft: 2, marginRight: 2}, src: PALETTE}).inject(div);
	
	var inputColorId = 'zneColor' + $('bodySeries').getElements('tr').length;
	var inputColor = new Element('input',{type:'text', name:inputColorId, id:inputColorId});
	inputColor.setStyle('background-color', color);
	inputColor.setStyle('width',  Number.from(tdWidths[1]) / 2 - 5);
	inputColor.setStyle('display', 'inline-block');
	inputColor.inject(div);
	
	div.inject(oTd1);
	
	//Mostrar
	div = new Element('div').setStyles({
		width: tdWidths[2],
		overflow: 'hidden',
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	
	var id=$("chtColX").options[$("chtColX").selectedIndex].text;
		
	input = new Element('input', {type:'checkbox', name:'chtSerShow', id:'chtSerShow'});
	input.inject(div);
	div.inject(oTd2);
	
	if (show == "true") {
		input.set('checked', true);
	}
	
	if(id == name) {
		img.setStyle('visibility', 'hidden');
		input.set('value', false)
			.set('checked', false)
			.set('disabled', true);
	}
	
	var oTr = new Element("TR");
	
	oTd0.inject(oTr);
	oTd1.inject(oTr);
	oTd2.inject(oTr);
	
	oTr.addClass("selectableTR");
	oTr.getRowId = function () { return this.getAttribute("rowId"); };
	oTr.setRowId = function (a) { this.set("rowId",a); };
	oTr.set("rowId", $('bodySeries').rows.length);
	
	oTr.addEvent("click",function(e){myToggle(this)}); 
	
	if($('bodySeries').rows.length%2==0){
		oTr.addClass("trOdd");
	}
	
	oTr.inject($('bodySeries'));	
	
	//Creamos el objeto colorPicker asociado a la imagen
	createZneColorPalette(inputColorHexId, imgId, inputColorId);
	
	inputHex.addEvent("change",function(e){
		inputColor.setStyle('background-color', this.get('value'));
		if (this.get('value')!="") showChart();
	});
}

var palettes = new Array();
function createZneColorPalette(inputHexId, imgId, inputId){
	var zneColorPalette = new MooRainbow(imgId, {
		id: imgId + "picker", //Asignar un id diferente si hay muchas paletas
		'startColor': [80, 80, 80],
		'imgPath': CONTEXT + '/js/colorpicker/images/',
		'onChange': function(color) {
			//showChart();
		},
		'onComplete': function(color) {
			//Sin confirma guardo los colores y refreso chart
			$(inputHexId).value = color.hex;
			$(inputId).setStyle('background-color', color.hex);
			$('chtColors').set('value','0');
			showChart();
		},
		'onCancel':function(color) {
			//showChart(); //No es necesario pq no se esta actualizando el color de la zona a medida que modifica color
			var oldColor = $(inputHexId).value;
			zneColorPalette.manualSet(oldColor.substring(1, oldColor.length),'hex');
		}		
	});
  palettes.push(zneColorPalette);
}

//--- Funciones para el modal del dise?o de la gr?fica
//var selectedColor = null;
//var colorElement = null;

function chtTypeChange(cleanComboSubType){
	
	var chtSubType = $('chtSubType');
	var vals = chtSubType.getElements('option').get('value');
	if (!cleanComboSubType){
		cleanCombo(chtSubType);
	}	
	var chtType = $('chtType').get('value');
	
	if (chtType==BAR_VER_TYPE_ID){//BARRAS VERTICALES
		
		if (cleanComboSubType){
			if(!vals.contains(b2D_SUBTYPE_ID))
				new Element('option', {html : b2D_SUBTYPE, value : b2D_SUBTYPE_ID}).inject($('chtSubType'));
			if(!vals.contains(b3D_SUBTYPE_ID))
				new Element('option', {html : b3D_SUBTYPE, value : b3D_SUBTYPE_ID}).inject($('chtSubType'));			
		}
		else{
			new Element('option', {html : b2D_SUBTYPE, value : b2D_SUBTYPE_ID}).inject($('chtSubType'));			
			new Element('option', {html : b3D_SUBTYPE, value : b3D_SUBTYPE_ID}).inject($('chtSubType'));			
		}
		
		showXYProps(true);
		$('labelX').innerHTML= AXE_X + ':';
	}else if (chtType==BAR_HOR_TYPE_ID){//BARRAS HORIZONTALES
		
		if (cleanComboSubType){
			if(!vals.contains(b2D_SUBTYPE_ID))
				new Element('option', {html : b2D_SUBTYPE, value : b2D_SUBTYPE_ID}).inject($('chtSubType'));
			if(!vals.contains(b3D_SUBTYPE_ID))
				new Element('option', {html : b3D_SUBTYPE, value : b3D_SUBTYPE_ID}).inject($('chtSubType'));			
		}
		else{
			new Element('option', {html : b2D_SUBTYPE, value : b2D_SUBTYPE_ID}).inject($('chtSubType'));			
			new Element('option', {html : b3D_SUBTYPE, value : b3D_SUBTYPE_ID}).inject($('chtSubType'));			
		}
		
		showXYProps(true);
		$('labelX').innerHTML= AXE_X + ':';
		
	}else if (chtType==LINE_TYPE_ID){//LINEAS
		
		cleanCombo(chtSubType);
		new Element('option', {html : b2D_SUBTYPE, value : b2D_SUBTYPE_ID}).inject($('chtSubType'));
		showXYProps(true);
		
	}else if (chtType==WFALL_TYPE_ID){//CASCADA	
		
		cleanCombo(chtSubType);
		new Element('option', {html : b2D_SUBTYPE, value : b2D_SUBTYPE_ID}).inject($('chtSubType'));
		showXYProps(true);
		$('labelX').innerHTML= AXE_X + ':';
		
	}else if (chtType==PIE_TYPE_ID){//TORTA
		
		if (cleanComboSubType){
			if(!vals.contains(b2D_SUBTYPE_ID))
				new Element('option', {html : b2D_SUBTYPE, value : b2D_SUBTYPE_ID}).inject($('chtSubType'));
			if(!vals.contains(b3D_SUBTYPE_ID))
				new Element('option', {html : b3D_SUBTYPE, value : b3D_SUBTYPE_ID}).inject($('chtSubType'));			
		}
		else{
			new Element('option', {html : b2D_SUBTYPE, value : b2D_SUBTYPE_ID}).inject($('chtSubType'));			
			new Element('option', {html : b3D_SUBTYPE, value : b3D_SUBTYPE_ID}).inject($('chtSubType'));			
		}
		
		
		showXYProps(false);
		$('labelX').style.visibility = '';
		$('chtColX').style.visibility = '';
		$('labelX').innerHTML=CATEGORIA + ':';
	}
	
	showChart();
}

function showXYProps(show) {
	if (show) {
		$('lblTitY').style.visibility = '';
		$('chtTitleY').style.visibility = '';
		$('labelX').style.visibility = '';
		$('chtColX').style.visibility = '';
		$('lblTitX').style.visibility = '';
		$('chtTitleX').style.visibility = '';
		$('lblGrid').style.visibility = '';
		$('chkGrid').style.visibility = '';
	}else {
		$('lblTitY').style.visibility = 'hidden';
		$('chtTitleY').style.visibility = 'hidden';
		$('labelX').style.visibility = 'hidden';
		$('chtColX').style.visibility = 'hidden';
		$('lblTitX').style.visibility = 'hidden';
		$('chtTitleX').style.visibility = 'hidden';
		$('lblGrid').style.visibility = 'hidden';
		$('chkGrid').style.visibility = 'hidden';
	}
}

function chtSubTypeChange(){
	showChart();
}

function lockSerie(){
	var id=$("chtColX").options[$("chtColX").selectedIndex].text;
	var rows = $("bodySeries").getElements('tr');
	
	for(var i = 0; i < rows.length; i++) {
		var rowId = rows[i].getElement('label').get('html');
		var tds = rows[i].getElements('td');
		
		if(id == rowId) {
			tds[1].getElement('img').setStyle('visibility', 'hidden');
			tds[2].getElement('input')
				.set('value', false)
				.set('checked', false)
				.set('disabled', true);
		} else {
			tds[1].getElement('img').setStyle('visibility', '');
			tds[2].getElement('input').set('disabled', false);
		}
	}
} 

//Retorna un string con los colores utilizados en las series a mostrar
//ret: #343434;#454434
function getSeriesColors() {
	var rows = $("bodySeries").getElements('tr');
	var colors = "";
	for(var i = 0; i < rows.length; i++) {
		if (rows[i].getElements('td')[2].getElements('input')[0].get('checked')) {
			if (colors!="") colors = colors + ";";
			var color = rows[i].getElements('td')[1].getElements('input')[0].get('value');
			color = color.substring(1, color.length);
			colors = colors + color;
		}
	}
	
	return colors;
}

function openColorPicker(){
	colorPicker(this);
};

function openColorPickerErrMsg() {
	showMessage(MSG_SCH_COL_SELECTED, GNR_TIT_WARNING, 'modalWarning');
}

function lockColorSelect(){
	var id=$("chtColors").options[$("chtColors").selectedIndex].value;
	var rows = $("bodySeries").getElements('tr');
	
	for(var i = 0; i < rows.length; i++) {
		if (id != "0") {
			
			rows[i].getElements('td')[1].getElements('input')[0].set('value','');
			rows[i].getElements('td')[1].getElements('input')[1].setStyle('background-color', 'white')
		}
	}
	
	showChart();
}

var return_value = null;

function checkDataBeforeConfirm() {
	//1. Titulo
	if ($('chtTitle').get('value')=="") {
		showMessage(MSG_ENT_CHT_TITLE, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
	
	//2. Series
	var cant=0;
	var rows = $("bodySeries").getElements('tr');
	
	for(var i = 0; i < rows.length; i++) {
		var show =	rows[i].getElements('td')[2].getElement('input');
		if (show.get('checked')){
			cant++;
		}
	}
	
	if (cant==0) {
		showMessage(MSG_SEL_SOME_SERIE, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
	
	return true;
}

//Devuelve los valores ingresados
//Si devuelve null no se cierra el modal
function getModalReturnValue(current_modal) {
	
	if (checkDataBeforeConfirm()) {
		if(!return_value) {
			var params = getFormParameters();
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=confChartDesign&isAjax=true' + TAB_ID_REQUEST,	
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { 
					modalProcessXml(resXml);
					SYS_PANELS.closeAll();
					return_value = chartId + ";" + isInDB + ";" + $('chtTitle').get('value');
					current_modal.confirmModal();
					
				}
			}).send(params);
		}
		
	}
	
	return return_value;
}

function getFormParameters() {
	var params = "";
	
	params = "chtType=" + $('chtType').get('value');
	params += "&chtSubType=" + $('chtSubType').get('value');
	params += "&chtTitle=" + $('chtTitle').get('value');
	params += "&chtTitleX=" + $('chtTitleX').get('value');
	params += "&chtTitleY=" + $('chtTitleY').get('value');
	params += "&chtColors=" + $('chtColors').get('value');
	params += "&chtColX=" + $('chtColX').get('value');
	params += "&viewGrid=" + $('chkGrid').get('checked');
	params += "&viewLegend=" + $('chkLegend').get('checked');
	params += "&viewValues=" + $('chkValues').get('checked');
	
	var rows = $("bodySeries").getElements('tr');
	
	for(var i = 0; i < rows.length; i++) {
		
		params += "&chtSerColId=" + rows[i].getElements('td')[0].getAttribute('colId');
		params += "&chtSerAttId=" + rows[i].getElements('td')[0].getAttribute('attId');
		params += "&chtSerBusClaParId=" + rows[i].getElements('td')[0].getAttribute('busClaParId');
		params += "&chtSerColName=" + rows[i].getElements('td')[0].getElement('label').get('text');
		params += "&chtSerColor=" + rows[i].getElements('td')[1].getElement('input').get('value');
		params += "&chtSerShow=" + rows[i].getElements('td')[2].getElement('input').get('checked');
		
	}
	
	return params;
}

function showChecked(element) {
	element.previousSibling.value = element.checked?1:0;
} 

function myToggle(oTr){
	if (oTr.getParent().selectOnlyOne) {
		var parent = oTr.getParent();
		if (parent.lastSelected) parent.lastSelected.toggleClass("selectedTR");
		parent.lastSelected = oTr;
	}
	oTr.toggleClass("selectedTR"); 
}

