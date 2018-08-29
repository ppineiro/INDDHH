function initPage() {
	if (forObj=="busclass"){
		var request = new Request({
			method: 'post',			
			data:{'busClaId':id},
			url: CONTEXT + URL_REQUEST_AJAX+'?action=getBusClaParams&isAjax=true' + TAB_ID_REQUEST,
			onComplete: function(resText, resXml) {
				loadBusClaParamsDataXML(resXml);
				fixTableModal();
				//Poner scroll a la grilla:
				addScrollTable($('paramGrid').getElement('tbody'));
			}
		}).send();
	}else if (forObj=="queryFilters") {
		var request = new Request({
			method: 'post',			
			data:{'qryId':id},
			url: CONTEXT + URL_REQUEST_AJAX+'?action=getQueryFilters&isAjax=true' + TAB_ID_REQUEST,
			onComplete: function(resText, resXml) {
				loadQueryFiltersDataXML(resXml);
				fixTableModal();
				//Poner scroll a la grilla:
				addScrollTable($('paramGrid').getElement('tbody'));
			}
		}).send();
	}else if (forObj=="queryShowCols") {
		var request = new Request({
			method: 'post',			
			data:{'qryId':id},
			url: CONTEXT + URL_REQUEST_AJAX+'?action=getQueryShowCols&isAjax=true' + TAB_ID_REQUEST,
			onComplete: function(resText, resXml) {
				loadQueryShowColsDataXML(resXml);
				fixTableModal();
				//Poner scroll a la grilla:
				addScrollTable($('paramGrid').getElement('tbody'));
			}
		}).send();
	}
}

function loadBusClaParamsDataXML(ajaxCallXml){
	if (ajaxCallXml != null) {
		var params = ajaxCallXml.getElementsByTagName("params");
		if (params != null && params.length > 0 && params.item(0) != null) {
			params = params.item(0).getElementsByTagName("param");
			var txtParams = "";
			var foundNumeric = false;
			for(var i = 0; i < params.length; i++) {
				var param = params.item(i);
				
				var id = param.getAttribute("id");
				var name = param.getAttribute("name");
				var type = param.getAttribute("type");
				var inOut = param.getAttribute("inOut");
				
				if (type == TYPE_NUMERIC) foundNumeric = true;
				
				fncAddBusClaParam(id, name, type, inOut, getBusClaParValue(id));
			}
			
			if (!foundNumeric) {
				showMessage(MSG_WID_BUS_CLA_ERR, GNR_TIT_WARNING, 'modalWarning');
				setTimeout(closeModal,4000);
				//this.closeModal();
			}
		}
	}
}

function loadQueryFiltersDataXML(ajaxCallXml) {
	if (ajaxCallXml != null) {
		var params = ajaxCallXml.getElementsByTagName("params");
		if (params != null && params.length > 0 && params.item(0) != null) {
			params = params.item(0).getElementsByTagName("param");
			var txtParams = "";
			var foundNumeric = false;
			for(var i = 0; i < params.length; i++) {
				var param = params.item(i);
				
				var id = param.getAttribute("id");
				var name = param.getAttribute("name");
				var type = param.getAttribute("type");
				var req = param.getAttribute("req");
				var defVal = param.getAttribute("value");
				
				fncAddQueryFilters(id, name, type, req, getFilterValue(id, defVal));
			}
		}
	}
}

function loadQueryShowColsDataXML(ajaxCallXml) {
	if (ajaxCallXml != null) {
		var params = ajaxCallXml.getElementsByTagName("params");
		if (params != null && params.length > 0 && params.item(0) != null) {
			params = params.item(0).getElementsByTagName("param");
			var txtParams = "";
			var foundNumeric = false;
			for(var i = 0; i < params.length; i++) {
				var param = params.item(i);
				
				var id = param.getAttribute("id");
				var name = param.getAttribute("name");
				var type = param.getAttribute("type");
				var hidden = param.getAttribute("hidden");
				
				if (type == TYPE_NUMERIC) foundNumeric = true;
				
				fncAddQueryShowCols(id, name, type, hidden, name==parValues);
			}
			
			if (!foundNumeric) {
				showMessage(MSG_WID_QRY_ERR, GNR_TIT_WARNING, 'modalWarning');
				setTimeout(closeModal,4000);
				//closeModal();
			}
		}
	}
}

function closeModal() {
	var button = window.parent.document.body.getElement('div.modalBottomBar').getElement('div.modalBottomBarClose');
	if(button)
		button.fireEvent('click');
}

function fncAddBusClaParam(id, name, type, inOut, value, selectedForWidget){
	var parent = $('gridParams').getParent();
	$('gridParams').selectOnlyOne = false; 
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
	
	var oTd0 = new Element("TD"); //nombre
	var oTd1 = new Element("TD"); //valor
	var oTd2 = new Element("TD"); //tipo
	var oTd3 = new Element("TD"); //in/Out
	var oTd4 = new Element("TD"); //usar en widget
	var oTd5 = new Element("TD",{styles:{'border-right':'none'}}); //visible
	
	oTd0.setAttribute("busClaParId",id);
	oTd0.setAttribute("busClaParName",name);
	oTd0.setAttribute("busClaParType",type);
	oTd0.setAttribute("busClaInOut", inOut);
	
	//Id y Nombre en misma columna
	var div = new Element('div').setStyles({
		width: tdWidths[0], 
		overflow: 'hidden', 
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	
	var input = new Element('input',{type:'text',name:'paramId'});
	input.set('value',id);
	input.setStyle('width',0);
	input.setStyle('display','none');
	input.inject(div);
	
	var label = new Element('label',{type:'text',name:'paramName'});
	//label.set('value',name);
	label.set('html',name);
	label.setStyle('width', tdWidths[0]);
	label.setStyle('width',  Number.from(tdWidths[0]) - 5);
	label.inject(div);
	
	div.inject(oTd0);
	
	//Valor
	div = new Element('div').setStyles({
		width: tdWidths[1],
		overflow: 'hidden',
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	
	var inputValueType = 'text';
	if (inOut == 'O') inputValueType = 'hidden';
	
	var input = new Element('input',{type:inputValueType,name:'paramValue'});
	if (value=="null") value = "";
	input.set('value',value);
	input.setStyle('width', Number.from(tdWidths[1]) - 5);
	input.inject(div);
	//input.style.display='none';
	div.inject(oTd1);
	
	//Tipo
	var lblType = "";
	if (type == TYPE_NUMERIC) lblType = LBL_NUMERIC;
	else if (type == TYPE_STRING) lblType = LBL_STRING;
	else if (type == TYPE_DATE) lblType = LBL_DATE;
	else if (type == TYPE_INT) lblType = LBL_INT;
	
	div = new Element('div').setStyles({
		width: tdWidths[2],
		overflow: 'hidden',
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	label = new Element('label',{type:'text',name:'paramType'});
	label.set('html', lblType);
	label.setStyle('width', tdWidths[2]);
	label.setStyle('width', Number.from(tdWidths[2]) - 5);
	label.inject(div);
	div.inject(oTd2);
	
	//In/Out
	var lblInOut = LBL_IN;
	if (inOut=="O") lblInOut = LBL_OUT;
	else if (inOut == "Z") lblInOut = LBL_IN_OUT;
	
	div = new Element('div').setStyles({
		width: tdWidths[3],
		overflow: 'hidden',
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	label = new Element('label',{type:'text',name:'paramInOut'});
	label.set('html', lblInOut);
	label.setStyle('width', tdWidths[3]);
	label.setStyle('width', Number.from(tdWidths[3]) - 5);
	label.inject(div);
	div.inject(oTd3);
	
	//Utilizar en widget
	div = new Element('div').setStyles({
		width: tdWidths[4],
		overflow: 'hidden',
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	input = new Element('input', {type:'checkbox', name:'forWidget','onclick':'unselOthers(this)'});	
	
	if (isForWidget(id)=="true"){
		input.set('checked', true);
	}
	
	if (type == TYPE_NUMERIC || type == TYPE_INT) {
		if (forZone){
			if (inOut=="I" || inOut=="Z"){
			}else{
				input.set('disabled', true);
			}
		}else{
			if (inOut=="O" || inOut=="Z"){
				
			}else{
				input.set('disabled', true);
			}
		}
	}else {
		input.set('disabled', true);
	}
	
	input.inject(div);
	div.inject(oTd4);
	
	var oTr = new Element("TR");
	
	oTd0.inject(oTr);
	oTd1.inject(oTr);
	oTd2.inject(oTr);
	oTd3.inject(oTr);
	oTd4.inject(oTr);
	
	oTr.addClass("selectableTR");
	oTr.getRowId = function () { return this.getAttribute("rowId"); };
	oTr.setRowId = function (a) { this.set("rowId",a); };
	oTr.set("rowId", $('gridParams').rows.length);
	
	oTr.addEvent("click",function(e){myToggle(this)}); 
	
	if($('gridParams').rows.length%2==0){
		oTr.addClass("trOdd");
	}
	
	oTr.inject($('gridParams'));		
	
//	var rowIndx = oTr.rowIndex - 1;
//	input.set('value',rowIndx);
}

function fncAddQueryFilters(id, name, type, req, value){
	var parent = $('gridParams').getParent();
	$('gridParams').selectOnlyOne = false; 
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
	
	var oTd0 = new Element("TD"); //col
	var oTd1 = new Element("TD"); //type
	var oTd2 = new Element("TD"); //value
	var oTd3 = new Element("TD"); //req
	
	oTd0.setAttribute("qryColId",id);
	oTd0.setAttribute("qryColName",name);
	oTd0.setAttribute("qryColType",type);
	oTd0.setAttribute("qryColRequired", req);
	
	//Id y Nombre en misma columna
	var div = new Element('div').setStyles({
		width: tdWidths[0], 
		overflow: 'hidden', 
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	
	var input = new Element('input',{type:'text',name:'paramId'});
	input.set('value',id);
	input.setStyle('width',0);
	input.setStyle('display','none');
	input.inject(div);
	
	var label = new Element('label',{type:'text',name:'paramName'});
	//label.set('value',name);
	label.set('html',name);
	label.setStyle('width', tdWidths[0]);
	label.setStyle('width',  Number.from(tdWidths[0]) - 5);
	label.inject(div);
	
	div.inject(oTd0);
	
	//Tipo
	var lblType = "";
	if (type == TYPE_NUMERIC) lblType = LBL_NUMERIC;
	else if (type == TYPE_STRING) lblType = LBL_STRING;
	else if (type == TYPE_DATE) lblType = LBL_DATE;
	else if (type == TYPE_INT) lblType = LBL_INT;
	
	div = new Element('div').setStyles({
		width: tdWidths[1],
		overflow: 'hidden',
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	label = new Element('label',{type:'text',name:'paramType'});
	label.set('html', lblType);
	label.setStyle('width', tdWidths[1]);
	label.setStyle('width', Number.from(tdWidths[1]) - 5);
	label.inject(div);
	div.inject(oTd1);
	
	//Valor
	div = new Element('div').setStyles({
		width: tdWidths[2],
		overflow: 'hidden',
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	
	var input = new Element('input',{type:'text',name:'paramValue'});
	input.set('value',value);
	input.setStyle('width', Number.from(tdWidths[2]) - 5);
	input.inject(div);
	div.inject(oTd2);
	
	//Requerido
	div = new Element('div').setStyles({
		width: tdWidths[3],
		overflow: 'hidden',
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	label = new Element('label',{type:'text',name:'paramType'});
	if (req=="true") req = LBL_YES;
	else req = LBL_NO;
	label.set('html', req);
	label.setStyle('width', tdWidths[3]);
	label.setStyle('width', Number.from(tdWidths[3]) - 5);
	label.inject(div);
	div.inject(oTd3);
	
	var oTr = new Element("TR");
	
	oTd0.inject(oTr);
	oTd1.inject(oTr);
	oTd2.inject(oTr);
	oTd3.inject(oTr);
	
	oTr.addClass("selectableTR");
	oTr.getRowId = function () { return this.getAttribute("rowId"); };
	oTr.setRowId = function (a) { this.set("rowId",a); };
	oTr.set("rowId", $('gridParams').rows.length);
	
	oTr.addEvent("click",function(e){myToggle(this)}); 
	
	if($('gridParams').rows.length%2==0){
		oTr.addClass("trOdd");
	}
	
	oTr.inject($('gridParams'));		
	
//	var rowIndx = oTr.rowIndex - 1;
//	input.set('value',rowIndx);
}

function fncAddQueryShowCols(id, name, type, hidden, forWidget) {
	var parent = $('gridParams').getParent();
	$('gridParams').selectOnlyOne = false; 
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
	
	var oTd0 = new Element("TD"); //name
	var oTd1 = new Element("TD"); //type
	var oTd2 = new Element("TD"); //hidden
	var oTd3 = new Element("TD"); //forWidget
	
	oTd0.setAttribute("qryColId",id);
	oTd0.setAttribute("qryColName",name);
	oTd0.setAttribute("qryColType",type);
	
	//Id y Nombre en misma columna
	var div = new Element('div').setStyles({
		width: tdWidths[0], 
		overflow: 'hidden', 
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	
	var input = new Element('input',{type:'text',name:'paramId'});
	input.set('value',id);
	input.setStyle('width',0);
	input.setStyle('display','none');
	input.inject(div);
	
	var label = new Element('label',{type:'text',name:'paramName'});
	label.set('html',name);
	label.setStyle('width', tdWidths[0]);
	label.setStyle('width',  Number.from(tdWidths[0]) - 5);
	label.inject(div);
	
	div.inject(oTd0);
	
	//Tipo
	var lblType = "";
	if (type == TYPE_NUMERIC) lblType = LBL_NUMERIC;
	else if (type == TYPE_STRING) lblType = LBL_STRING;
	else if (type == TYPE_DATE) lblType = LBL_DATE;
	else if (type == TYPE_INT) lblType = LBL_INT;
	
	div = new Element('div').setStyles({
		width: tdWidths[1],
		overflow: 'hidden',
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	label = new Element('label',{type:'text',name:'paramType'});
	label.set('html', lblType);
	label.setStyle('width', tdWidths[1]);
	label.setStyle('width', Number.from(tdWidths[1]) - 5);
	label.inject(div);
	div.inject(oTd1);
	
	//Oculta
	div = new Element('div').setStyles({
		width: tdWidths[2],
		overflow: 'hidden',
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	
	input = new Element('input', {type:'checkbox', name:'forWidget', disabled:'true'});
	input.inject(div);
	div.inject(oTd2);
	
	if (hidden == "true") {
		input.set('checked', true);
	}
		
	//Utilizar en widget
	div = new Element('div').setStyles({
		width: tdWidths[3],
		overflow: 'hidden',
		'white-space': 'pre',
		'text-align':'center',
		'padding-left': 0
	});
	input = new Element('input', {type:'checkbox', name:'forWidget','onclick':'unselOthers(this)'});	
	
	if (forWidget){
		input.set('checked', true);
	}
	
	if (type == TYPE_STRING || type == TYPE_DATE){
		input.set('disabled', true);				
	}
	
	input.inject(div);
	div.inject(oTd3);
	
	var oTr = new Element("TR");
	
	oTd0.inject(oTr);
	oTd1.inject(oTr);
	oTd2.inject(oTr);
	oTd3.inject(oTr);
	
	oTr.addClass("selectableTR");
	oTr.getRowId = function () { return this.getAttribute("rowId"); };
	oTr.setRowId = function (a) { this.set("rowId",a); };
	oTr.set("rowId", $('gridParams').rows.length);
	
	oTr.addEvent("click",function(e){myToggle(this)}); 
	
	if($('gridParams').rows.length%2==0){
		oTr.addClass("trOdd");
	}
	
	oTr.inject($('gridParams'));		
	
//	var rowIndx = oTr.rowIndex - 1;
//	input.set('value',rowIndx);
}

//values: "busClaParId-busClaParName-busClaParType-busClaParForWidget-busClaParValue,busClaParId-busClaParName-busClaParType-busClaParForWidget-busClaParValue,.."
function getBusClaParValue(parId){
	var fin = 0;
	var control = 0;// Control por si la funcion llega a quedar en loop
	var values = parValues;
	while (values.indexOf("-")>0){
		if (control == 100) return "";
		var busClaParId = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParName = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParType = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParForWidget = values.substring(0,values.indexOf("-"));
		if (busClaParId == parId){
			values = values.substring(values.indexOf("-")+1, values.length);
			if (values.indexOf(",")>=0){
				return values.substring(0,values.indexOf(","));
			}else{
				return values;
			}
		}else{
			if (values.indexOf(",")>0){
				values = values.substring(values.indexOf(",")+1, values.length);
			}else return "";
		}
		control = control + 1;
	}
	return "";
}

//values: "qryColId-qryColType-qryColValue,qryColId-qryColType-qryColValue,.."
function getFilterValue(parId, defValue){
	var fin = 0;
	var values = parValues;
	var control = 0;// Control por si la funcion llega a quedar en loop
	while (values.indexOf("-")>0){
		if (control == 100) return "";
		var qryColId = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var qryColName = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var qryColType = values.substring(0,values.indexOf("-"));
		if (qryColId == parId){
			values = values.substring(values.indexOf("-")+1, values.length);
			if (values.indexOf(",")>=0){
				return values.substring(0,values.indexOf(","));
			}else{
				return values;
			}
		}else{
			if (values.indexOf(",")>0){
				values = values.substring(values.indexOf(",")+1, values.length);
			}else return defValue;
		}
		control = control + 1;
	}
	return defValue;
}

function isForWidget(parId){
	var fin = 0;
	var control = 0;// Control por si la funcion llega a quedar en loop
	var values = parValues;
	while (values.indexOf("-")>0){
		if (control == 100) return "";
		var busClaParId = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParName = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParType = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParForWidget = values.substring(0,values.indexOf("-"));
		if (busClaParId == parId){
			return busClaParForWidget;
		}else{
			if (values.indexOf(",")>0){
				values = values.substring(values.indexOf(",")+1, values.length);
			}else return false;
		}
		control = control + 1;
	}
	return "";
}

function myToggle(oTr){
	if (oTr.getParent().selectOnlyOne) {
		var parent = oTr.getParent();
		if (parent.lastSelected) parent.lastSelected.toggleClass("selectedTR");
		parent.lastSelected = oTr;
	}
	oTr.toggleClass("selectedTR"); 
}

function unselOthers(el){
	var oRows = document.getElementById("gridParams").rows;
	if (oRows != null) {
		var result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd = oRow.cells[oRow.cells.length-1];
			var input=oTd.getElementsByTagName("INPUT")[0];
			if(input!=el){
				input.checked=false;
				if (forZone){
					oTd = oRow.cells[1];
					input=oTd.getElementsByTagName("INPUT")[0]; 
					input.erase('disabled');
				}
			}else if (forZone){
				oTd = oRow.cells[1];
				input=oTd.getElementsByTagName("INPUT")[0];
				if (el.get('checked')) {
					input.set('value','');
					input.set('disabled', true);
				}else {
					input.erase('disabled');
				}
			}
		}
	}
}

//Devuelve los valores ingresados
//Si devuelve null no se cierra el modal
function getModalReturnValue() {
	if (forObj=="busclass") {
		return getModalBusClaReturnValue();
	}else if (forObj=="queryFilters" || forObj=="queryShowCols"){
		return getModalQueryReturnValue();
	}
}

function getModalBusClaReturnValue() {
	var oRows = document.getElementById("gridParams").rows;
	var parValues = "";
	var someParInEmpty = false;
	var someParChecked = false;
	if (oRows != null) {
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			
			if (forObj=="busclass") {
				var oTd = oRow.cells[0];
				var oTdChk = oRow.cells[4];
				var chkbox = oTdChk.getElementsByTagName("INPUT")[0];
				
				var id = oTd.getAttribute("busClaParId");
				var name = oTd.getAttribute("busClaParName");
				var type = oTd.getAttribute("busClaParType");
				var inOut = oTd.getAttribute("busClaInOut");
				var checked = oTdChk.getElementsByTagName("input")[0].checked; //forWidget
				var value = oRow.cells[1].getElementsByTagName("input")[0].value; //value
				
				if (parValues==""){ //id-name-type-checked-value
					parValues = id + "-" + name + "-" + type + "-" + checked + "-" + value;
				}else{
					parValues = parValues + "," + id + "-" + name + "-" + type + "-" + checked + "-" + value;			
				}
				
				if (checked) {
					someParChecked=true;
				}
				
				if ((inOut=="I" || inOut=="Z") && value=="" && !checked){
					someParInEmpty=true; //Indicamos que hay un parametro de entrada o entrada/salida al cual no se le seteeo valor
				}
			}
		}
		
		if (someParInEmpty) { //Si a algun parametro de entrada no se le asigno valor
			if (!confirm(MSG_PAR_NOT_VAL)){ //Alertamos al usuario
				return null;
			}
		}
		
		if (!someParChecked && !forZone) { //Si no se selecciono ninguno para utilizar en el widget
			if (!confirm(MSG_WID_MST_SEL_PAR)){ //Alertamos al usuario
				return null;
			}
		}
		return parValues; 
	} else {
		return null; //No cerrar el modal
	}
}

function getModalQueryReturnValue() {
	var oRows = document.getElementById("gridParams").rows;
	var parValues = "";
	if (oRows != null) {
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			
			if (forObj=="queryFilters"){
				parValues = getQueryFiltersFromGridRow(oRow, parValues);
				if (parValues==null) return null;
			}else if (forObj=="queryShowCols"){
				parValues = getQueryShowColsFromGridRow(oRow, parValues);
			}
		}
		return parValues; 
	} else {
		return null; //No cerrar el modal
	}
}

function getQueryFiltersFromGridRow(oRow, parValues) {
	var oTd = oRow.cells[0];
	var arr = new Array();
	
	arr[0] = oTd.getAttribute("qryColId");
	arr[1] = oTd.getAttribute("qryColName");
	arr[2] = oTd.getAttribute("qryColType");
	arr[3] = oRow.getElementsByTagName("INPUT")[1].value;
	var req = oTd.getAttribute("qryColRequired");
	
	if (arr[3] == "" && (req == "true" || req==true)){
		showMessage(MSG_MUST_SEL_COL_VALUE.replace("<TOK1>",arr[1]), GNR_TIT_WARNING, 'modalWarning');
		return null;
	}
	
	if (parValues==""){
		parValues = arr[0] + "-" + arr[1] + "-" + arr[2] + "-" + arr[3];
	}else{
		parValues = parValues + "," + arr[0] + "-" + arr[1] + "-" + arr[2] + "-" + arr[3];			
	}
	return parValues;
}

function getQueryShowColsFromGridRow(oRow, parValues) {
	var oTd = oRow.cells[0];
	var oTdChk = oRow.cells[3];
	var chkbox = oTdChk.getElementsByTagName("INPUT")[0];
	if (chkbox.checked){
		parValues = oTd.getAttribute("qryColName");
	}
	return parValues;	
}

function fixTableModal(){
	var trs = $('paramGrid').getElements("tr");
	if (trs.length > 0){
		var tr = trs[trs.length-1];
		tr.addClass("lastTr");
	}
}
