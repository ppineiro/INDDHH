var DEFAULT_DELAY_IN_HIDE_DOWNLOAD_IFRAME = 1000 * 10;

function getRGBColor(colorHex){
	var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(colorHex);
	if (result==null) return "";
	var rgb = "rgb(" + parseInt(result[1],16) + "," + parseInt(result[2], 16) + "," + parseInt(result[3], 16) + ")";
	return rgb;
}

function replaceAll( text, busca, reemplaza ){
	while (text.toString().indexOf(busca) != -1)
		text = text.toString().replace(busca,reemplaza);
	return text;
}

/*
function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
}
*/

String.implement('endsWith', function (suffix) {
	return this.indexOf(suffix, this.length - suffix.length) !== -1;
});



function toBoolean(value) {
	if (value == null) return false;
	if (typeof(value) == "string") return "true" == value || "on" == value || "1" == value || "y" == value;
	if (typeof(value) == "boolean") return value;
	if (typeof(value) == "number") return 1 == value;
	if (typeof(value) == "object") return value != null;

	return false;
}

function showMessageObject(object, title, additionalClass) {
	var panel = SYS_PANELS.newPanel([]);

	if (title) panel.header.innerHTML = title;
	if (additionalClass) panel.addClass(additionalClass);
	
	object.inject(panel.content);
	SYS_PANELS.addClose(panel);
	SYS_PANELS.adjustVisual();

}

function showMessage(text, title, additionalClass){
	var panel = SYS_PANELS.newPanel([]);

	if (title) panel.header.innerHTML = title;
	if (additionalClass) panel.addClass(additionalClass);
	
	panel.content.innerHTML = text;
	SYS_PANELS.addClose(panel);
	SYS_PANELS.adjustVisual();
	
	if(window.frameElement && $(window.frameElement).hasClass('modal-content')) {
		$(window.frameElement).fireEvent('block');
	}
	
//	$("messageContainer").removeClass("hidden");
//	$("messageContainer").addClass("warning");
//	$("messageContainer").innerHTML="";
//	var htmlText = "<label id=\"messageText\">"+ text + "</label>"; 
//	new Element('label', {html: htmlText}).inject($('messageContainer'));
	
	return panel;
}


var hideFirst = true; //esto es para que en algun caso que se necesite, se pueda evitar el cerrado de mensajes antes de una accion


function hideMessage(){
	if(hideFirst){
		SYS_PANELS.closeActive();	
	}
//	$("messageContainer").innerHTML="";
//	$("messageContainer").addClass("hidden");
}

/**
 * Crea un modal de confirmaci�n. Se debe pasar una funcion para escuchar la confirmaci�n
 * @param {String} text Texto a mostrar
 * @param {String} title Titulo del modal
 * @param {Function} return_fnc Funci�n que ser� invocada al salir del modal. Se le pasa como par�metro true si se confirm� o false si se cerr�
 * @param {String} additionalClass Clases css adicionales para el panel
 */
function showConfirm(text, title, return_fnc, additionalClass){
	var panel = SYS_PANELS.newPanel([]);
	
	if (title) panel.header.innerHTML = title;
	if (additionalClass) panel.addClass(additionalClass);
	
	panel.content.innerHTML = text;
	SYS_PANELS.addConfirm(panel, function() {
		return_fnc(true);
	});
	SYS_PANELS.addClose(panel, false, function() {
		return_fnc(false);
	});
	SYS_PANELS.adjustVisual();
}

function getBodyController() {
	return ($('bodyController') != null) ? $('bodyController') : new Element('span', {'id': 'bodyController'}).inject(document.body);
}
	
function getTabContainerController() {
	var inIframe = window.parent != null && window.parent.document != null;
	var result = document.getElementById("tabContainer");
	if (result == null && inIframe) result = window.parent.document.getElementById("tabContainer");
	return result;
}

//cargar una tabla con un xml
function loadTable(object,xml, selectOnlyOne, personalizeTr){
	if (selectOnlyOne == "true") {
		selectOnlyOne = true;
	} else if (selectOnlyOne == "false" || selectOnlyOne == "") {
		selectOnlyOne = false;
	}
	if (! selectOnlyOne) selectOnlyOne = false;
	
	//-- IMPORTANTE ! object.innerHTML de un tbody no funciona en IE... 
	//-- por lo tanto se hace un c�digo que destruye el tag y lo vuelve a crear
	
	//object.innerHTML="";
	var newBody = new Element("tbody");
	newBody.id = object.id;
	newBody.addClass("tableData");
	//var parent = object.parentNode;
	var parent = object.getParent();
	object.dispose();
	newBody.inject(parent);
	object = newBody;
	object.selectOnlyOne = selectOnlyOne;
	
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	
	var tdWidths = headers ? new Array(headers.length) : null;
	var minTdWidth = null;
	
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].getStyle('width');
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
		
		minTdWidth = 0;
		for (var i = 0; i < tdWidths.length; i++) {
			value = tdWidths[i];
			if (value.indexOf("px") != -1) value = value.substring(0, value.indexOf("px"));
			value = parseInt(value);
			minTdWidth += value;
		}
	}
	
	/* INICIO - volver a su estado inicial los botones de crear y actualizar si existen - INICIO */
	var btnCreate = $('btnCreate');
	var btnCreateButton = (btnCreate) ? btnCreate.getChildren('button')[0] : null;
	var btnUpdate = $('btnUpdate');
	var btnUpdateButton = (btnUpdate) ? btnUpdate.getChildren('button')[0] : null;
	
	if (btnCreate) {
		btnCreate.addClass('suggestedAction');
		btnCreateButton.addClass('suggestedAction');
	}
	if (btnUpdate) {
		btnUpdate.removeClass('suggestedAction'); 
		btnUpdateButton.removeClass('suggestedAction');
	}
	/* FIN - volver a su estado inicial los botones de crear y actualizar si existen - FIN */
	
	var table = xml.getElementsByTagName("table");
	if (table != null && table.length > 0 && table.item(0) != null) {
		var rows = table.item(0).getElementsByTagName("row");
		for(var i = 0; i < rows.length; i++) {
			var row = rows.item(i);
			var id = row.getAttribute("id");
			var classToAdd = row.getAttribute("classToAdd");
			var unselectableTR = row.getAttribute("unselectableTR");
			var uneditableTR = row.getAttribute("uneditableTR");
			var selected = "true" == row.getAttribute("selected");
			var dblClic = "true" == row.getAttribute("dblclic");
			var boldType = "true" == row.getAttribute("boldType");
			
			var tr = new Element('tr', null);

			if(i%2==0) tr.addClass("trOdd");
			if (!unselectableTR) tr.addClass('selectableTR');
			if (uneditableTR == "true") tr.addClass('uneditableTR');
			if(selected) {
				tr.addClass("selectedTR");
				object.lastSelected = tr;
			}
			if (dblClic) { tr.addClass("dblClic"); }
			
			if (i == (rows.length - 1)) tr.addClass("lastTr");
			
			if (classToAdd) tr.className += " " + classToAdd;
			if (id != null && id != null) tr.setAttribute("rowId", id);
			
			tr.getRowId = function () { return this.getAttribute("rowId"); };
			tr.inject(object);
			
			//Agregado para que individualmente se pueda especificar una fila sin additional info
			var addInfo = true;
			if (row.getAttribute("additional_info_in_table_data")=="false"){
				addInfo = false;
			}
			
			//Esto es para consultas creadas por el usuario
			var showMoreInfo = false;
			if(row.getAttribute("showMoreInfo") == "t" || table[0].getAttribute("showMoreInfo") == "t")
				showMoreInfo = true
			
			
			processRowAttributes(tr,row);
			
			var moreInfoCells = [];
			var cellMoreInfo;
			
			var cells = row.getElementsByTagName("cell");
			for(var j = 0; j < cells.length; j++) {
				var cell = cells.item(j);
				var tdClassToAdd = cell.getAttribute("classToAdd");
				var content = cell.firstChild ? cell.firstChild.nodeValue : "";
				var tdAlign = cell.getAttribute("align");
				var tdTitle = cell.getAttribute("title");
				var isHTML = cell.getAttribute("isHTML");
				var isMoreInfo = cell.getAttribute("moreInfo");
				
				
					
				var additionalInfo = null;
				var withoutTitiled = toBoolean(cell.getAttribute("withoutTitiled"));
				
				if(showMoreInfo && j == 0) {
					//Additional info en consultas creadas por el usuario
					cellMoreInfo = new Element('div.additionalInfo').inject(new Element('div').setStyles({
						width: '30px',
						overflow: 'hidden',
						'white-space': 'pre'
					}).inject(new Element('td').setStyle('width', '30px').inject(tr))).addEvent('click', fncAdditionalInfo);
					cellMoreInfo.trParent = tr;
					cellMoreInfo.loaded = true;
					
				} else if (ADDITIONAL_INFO_IN_TABLE_DATA && j == 0 && addInfo) {
					additionalInfo = new Element("div", {'class': 'additionalInfo'});
					additionalInfo.trParent = tr;
					additionalInfo.loaded = false;
					additionalInfo.tdWidths = tdWidths ? tdWidths.length : 5;
					additionalInfo.minTdWidth = minTdWidth;
					additionalInfo.addEvent('click', fncAdditionalInfo);
				}
				
				if(isMoreInfo) {
					moreInfoCells.push(cell);
					continue;
				}
				
				//crear el TD
				if (tdWidths) {
					var td = new Element('td');
					td.setAttribute("textContent",content);
					var div = new Element('div', {styles: {width: tdWidths[j], overflow: 'hidden', 'white-space': 'pre'}});
					if (additionalInfo) additionalInfo.inject(div);
					if (j == 0) firstCell = div; //Referencia a la primer celda
					if (tdAlign) { td.setAttribute("align",tdAlign); }
					if (tdTitle) { td.title = tdTitle; }
					new Element('span', {html: (boldType?"<b>":"")+content+(boldType?"</b>":"")}).inject(div);
					div.inject(td);
					td.inject(tr);
					
					if (div.scrollWidth > div.offsetWidth && !withoutTitiled) {
						if(isHTML)
							td.title = div.getElement('span').get('text');
						else
							td.title = content;
						td.addClass("titiled");
					}
					if (tdClassToAdd) td.addClass(tdClassToAdd);
				} else {
					var td = new Element('td', {html: (boldType?"<b>":"")+content+(boldType?"</b>":"")});
					td.setAttribute("textContent",content);
					var tdClassToAdd = cell.getAttribute("classToAdd");
					if (tdClassToAdd) td.addClass(tdClassToAdd);
					if (tdAlign) { td.setAttribute("align",tdAlign); }
					if (tdTitle) { td.title = tdTitle; }
					td.inject(tr);
				}
			}
			
			if(moreInfoCells.length || showMoreInfo) {
				
				tr.getRowContent = function () {
					var ret = new Array();
					this.getElements('td').each(function (td, index){
						if(index > 0)
							ret.push(td.getAttribute("textContent"));
					});
					return ret;
				};
				
				tr = new Element('tr.info');
				if(i % 2 == 0) tr.addClass("trOdd");
				
				var td = new Element('td.additionalInfo').set('colspan', cells.length + 1 - moreInfoCells.length).inject(tr);
				
				for(j = 0; j < moreInfoCells.length; j++) {
					var div = new Element('div.container');
					new Element('div.title').set('html', table[0].getAttribute('colsTitle' + j) + ":").inject(div);
					new Element('div.content').set('html', moreInfoCells[j].firstChild ? moreInfoCells[j].firstChild.nodeValue : "").inject(div);
					div.inject(td);
				}
				
				cellMoreInfo.info = tr;
				
				td.inject(tr);
				tr.inject(object);
				
				tr.getRowContent = function () {
					var ret = new Array();
					return ret;
				};
			} else {
				tr.getRowContent = function () {
					var ret = new Array();
					this.getElements('td').each(function (td){
						ret.push(td.getAttribute("textContent"));
					});
					return ret;
				};
			}
			
		}
		initTable(object, personalizeTr);			
	}
	
	//--Scroll
	addScrollTable(object)
}

function processRowAttributes(tr,row) {
	var atts = row.attributes;
	for (var i=0; i < atts.length; i++) {
		if (atts[i].nodeName != "class" && atts[i].nodeName != "rowId" && atts[i].nodeName != "additional_info_in_table_data") {
			tr.setAttribute(atts[i].nodeName, atts[i].value);
		}
	}
}

function fncAdditionalInfo(evt){
	var addScroll = true;
	
	this.toggleClass("open");
	if (! this.loaded) {
		this.info = new Element("tr", {'class': 'info', 'id': ('adtInfoRow' + this.trParent.getRowId()), styles: {height: '50px'}});
		//this.info.spinner = new Spinner(this.info,{message:WAIT_A_SECOND});

		//var tdInfo = new Element("td", {'colSpan': this.tdWidths, html: '&nbsp;', 'class': 'additionalInfo'});
		var tdInfo = new Element("td", {'width': this.minTdWidth + 'px', 'colSpan': this.tdWidths, html: '', 'class': 'additionalInfo'});
		
		tdInfo.inject(this.info);
		
		this.info.inject(this.trParent, 'after');
		this.loaded = true;
		
		var parent = this.getParent();
		while (parent != null && parent.tagName.toLowerCase() != "tr") { 
			parent = parent.getParent();
		}
		
		if (parent && parent.hasClass("trOdd")) this.info.addClass("trOdd");
		
		var row_id = 'id=' + encodeURIComponent(this.trParent.getRowId());
		
		var request = new Request({
			//spinner : this.info.spinner,
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=adtInfo&isAjax=true'+ TAB_ID_REQUEST,
			onRequest: function() { 
				if  (this.options.spinner) this.options.spinner.show(true); 
			},
			onComplete: function(resText, resXml) { 
				modalProcessXml(resXml);
				//this.options.spinner.hide(true); 
			}
		}).send(row_id);
		
		addScroll = false;
	} 
	
	this.info.toggleClass("open");
	//if (! this.hasClass("open") || this.trParent.hasClass("selectedTR")) evt.stop();
	if (evt) evt.stopPropagation();
	
	
	//Si !addScroll se agrega el scroll luego de agregar la info adicional en navButtons.js callAdditionalProcessXmlInfoResponse()
	if (addScroll){
		var tbody = this.trParent.parentNode;
		addScrollTable(tbody);		
	}
}

//inicializa una tabla para setear el comportamiento de seleccion
function initTable(tbl, personalizeTr){
	
	var amountSelected = tbl.getElements('.selectedTR').length;
	
	var btnCreate = $('btnCreate');
	var btnCreateButton = (btnCreate) ? btnCreate.getChildren('button')[0] : null;
	var btnUpdate = $('btnUpdate');
	var btnUpdateButton = (btnUpdate) ? btnUpdate.getChildren('button')[0] : null;
	
	if (btnCreate) { 
		if (amountSelected == 0) {
			btnCreate.addClass('suggestedAction');
			btnCreateButton.addClass('suggestedAction');
		} else {
			btnCreate.removeClass('suggestedAction'); 
			btnCreateButton.removeClass('suggestedAction'); 
		}
	}
	
	if (btnUpdate) { 
		if (amountSelected == 1) {
			btnUpdate.addClass('suggestedAction'); 
			btnUpdateButton.addClass('suggestedAction'); 
		} else {
			btnUpdate.removeClass('suggestedAction'); 
			btnUpdateButton.removeClass('suggestedAction'); 
		}
	}
	
	tbl.getElements('.selectableTR').each(function(item, index){
	    item.addEvent("click",function(e){
	    	
    		var parent = this.getParent();
    		if(e && e.shift) {
    			if (parent.lastSelected && parent.lastSelected != this) {
    				
    				//Recorrer todas las rows y deseleccionarlas
    				var current_row = this;
    				var start_idx = -1, end_idx = -1;
    				parent.getChildren('tr').each(function(item, idx) {
    					if(item.hasClass("selectedTR")) {
    						item.removeClass("selectedTR").fireEvent('unSelected');
    						parent.getParent().fireEvent('rowUnSelected', item);
    					}
    					if(item == parent.lastSelected || item == current_row) {
    						if(start_idx == -1)
    							start_idx = idx;
    						else
    							end_idx = idx;
    					}
    					
    				}).each(function(item, idx) {
    					if(idx >= start_idx && idx <= end_idx) {
    						item.addClass("selectedTR");
    		    			parent.getParent().fireEvent('rowSelected', item); //se dispara en el parent del parent porque parent se regenera siempre
    		    			item.fireEvent('selected');
    					}
    				});
	    		} else {
	    			parent.lastSelected = this;
	    			if (!this.hasClass("selectedTR")) {
		    			this.addClass("selectedTR");
		    			parent.getParent().fireEvent('rowSelected', this); //se dispara en el parent del parent porque parent se regenera siempre
	    	    		this.fireEvent('selected');
	    	    	}
	    		}
	    		
    		} else if(e && e.control) {
    			if (this.getParent().selectOnlyOne && this.getParent().lastSelected != this) {
    	    		if (parent.lastSelected) {
    	    			parent.lastSelected.removeClass("selectedTR");
    	    			this.fireEvent('unSelected');
    	    			parent.getParent().fireEvent('rowUnSelected', parent.lastSelected); //se dispara en el parent del parent porque parent se regenera siempre
    	    		}
    	    		//parent.lastSelected = this;
    	    	}
    			
    			parent.lastSelected = this;
    			
    	    	this.toggleClass("selectedTR");
    	    	parent.getParent().fireEvent(this.hasClass('selectedTR') ? 'rowSelected' : 'rowUnSelected', this); //se dispara en el parent del parent porque parent se regenera siempre
    	    	
    	    	if (this.hasClass("selectedTR")) {
    	    		this.fireEvent('selected');
    	    	} else {
    	    		this.fireEvent('unSelected');
    	    	}
    		} else {
    			if (parent.lastSelected /*&& this.getParent().lastSelected != this*/) {
    				/*
	    			parent.lastSelected.removeClass("selectedTR");
	    			this.fireEvent('unSelected'); //por que dispara sobre this???? no deberia ser sobre parent.lastSelected????
	    			parent.getParent().fireEvent('rowUnSelected', parent.lastSelected); //se dispara en el parent del parent porque parent se regenera siempre
	    			*/
    				//Recorrer todas las rows y deseleccionarlas
    				var current_row = this;
    				parent.getChildren('tr').each(function(item) {
    					if(item.hasClass("selectedTR") && item != current_row) {
    						item.removeClass("selectedTR").fireEvent('unSelected');
    						parent.getParent().fireEvent('rowUnSelected', item);
    					}
    				});
	    		}
	    		parent.lastSelected = this;
	    		if (!this.hasClass("selectedTR")) {
	    			this.addClass("selectedTR");
	    			parent.getParent().fireEvent('rowSelected', this); //se dispara en el parent del parent porque parent se regenera siempre
    	    		this.fireEvent('selected');
    	    	}
    		}
    		
    		if (parent != null && parent != null) {
    			var amountSelected = parent.getChildren('tr.selectedTR').length;
    			
    			var btnCreate = $('btnCreate');
    			var btnCreateButton = (btnCreate) ? btnCreate.getChildren('button')[0] : null;
    			var btnUpdate = $('btnUpdate');
    			var btnUpdateButton = (btnUpdate) ? btnUpdate.getChildren('button')[0] : null;
    			
    			if (btnCreate) { 
    				if (amountSelected == 0) {
    					btnCreate.addClass('suggestedAction');
    					btnCreateButton.addClass('suggestedAction');
    				} else {
    					btnCreate.removeClass('suggestedAction'); 
    					btnCreateButton.removeClass('suggestedAction'); 
    				}
    			}
    			
    			if (btnUpdate) { 
    				if (amountSelected == 1) {
    					btnUpdate.addClass('suggestedAction'); 
    					btnUpdateButton.addClass('suggestedAction'); 
    				} else {
    					btnUpdate.removeClass('suggestedAction'); 
    					btnUpdateButton.removeClass('suggestedAction'); 
    				}
   				}
    		}
	    		    	
	    });
	    
	    if (item.hasClass("dblClic")){
	    	item.addEvent("dblclick",function(e){
	    		this.getParent().getParent().fireEvent('dblClic', this); //se dispara en el parent del parent porque parent se regenera siempre
	    	});
	    }
	    
	    if (personalizeTr) personalizeTr(item);
	});
}

//retorna la cantidad de elementos seleccionados
function selectionCount(tbl){
	var selectionsCount = 0;
	tbl.getChildren('.selectableTR').each(function(item, index){
	    if(item.hasClass("selectedTR")){
	    	selectionsCount++;
	    }
	});
	return selectionsCount;
}
//retorna los elementos seleccionados de la tabla
function getSelectedRows(tbl){
	var selectedItems = new Array();
	tbl.getChildren('.selectableTR').each(function(item, index){
	    if(item.hasClass("selectedTR")){
	    	selectedItems.push(item);
	    }
	});
	return selectedItems;
}

//--quita la seleccion de una tabla (todas los renglones seleccionados
function unSelectAllRows(tbl){
	tbl.getElements('.selectableTR').each(function(item, index){
	    if(item.hasClass("selectedTR")){
	    	item.removeClass("selectedTR");
	    }
	});

}

//--retorna un array con los id de los elementos que se encuentran en el contenedor de elementos (elementos con la x para eliminar que sustituye la antigua grilla)
function getActionElementsIds(container){
	container = $(container);
	var ret = new Array();
	container.getElements("DIV").each(function(item,index){
		if(item.getAttribute("id")){
			if(item.getAttribute("helper") && item.getAttribute("helper")=="false"){
				ret.push(item.getAttribute("id"));
			}
			
		}
	});
	return ret;
}

function claerActionElements(container){
	container = $(container);
	var ret = new Array();
	container.getElements("DIV").each(function(item,index){
		if("true" != item.getAttribute('helper')){
			item.destroy();
		}
	});
	return ret;
}
function hideActionElement(container,id){
	container.getElements("DIV").each(function(item,index){
		if(item.getAttribute("id")==id){
			item.addClass("hiddenActionElement");
		}
	});
}

function showActionElement(container,id){
	container.getElements("DIV").each(function(item,index){
		if(item.getAttribute("id")==id){
			item.removeClass("hiddenActionElement");
		}
	});
}

//--agrega un elemento al contenedor de elementos (elementos con la x para eliminar que sustituye la antigua grilla)
function addActionElement(container, text,id,inputName){
	return addActionElementAdmin(container, text,id, "false",true,inputName);
}
function addActionElementAdmin(container, text, id, helper, addRemove, inputName){
	var repeated = false;
	//primero verificar que no exista
	container.getElements("DIV").each(function(item,index){
		if(item.getAttribute("id")==id){
			repeated = true;
		}
	});
	
	if (repeated) return null;
	
	//si no est�, se agrega
	var divElement = new Element('div', {'class': 'option', html: text});
	divElement.setAttribute("id", id);
	divElement.setAttribute("helper",helper);
	
	var hiddenInput = new Element( 'input',{ type:'hidden'}).inject(divElement);
	hiddenInput.setProperty('name',inputName);
	hiddenInput.setProperty('value',id);
 	
	if(addRemove){
		divElement.container = container;
		divElement.addClass("optionRemove");
		divElement.addEvent("click", actionAlementAdminClickRemove);
		divElement.addEvent("mouseenter", actionElementAdminMouseOverToggleClasss);
		divElement.addEvent("mouseleave", actionElementAdminMouseOverToggleClasss);
	}
	
	var last = container.getLast();
	if (last) {
		divElement.inject(last,'before');	
	} else {
		divElement.inject(container);
	}
	
	
	return divElement;
}

function actionAlementAdminClickRemove(evt) { this.destroy(); if (this.container && this.container.onRemove) this.container.onRemove(); }
function actionElementAdminMouseOverToggleClasss(e){ this.toggleClass('optionRemoveOver'); }

function processAjaxExceptions(ajaxCallXml) {
	var messages = ajaxCallXml.getElementsByTagName("messages");
	if (messages != null && messages.length > 0 && messages.item(0) != null) {
		messages = messages.item(0).getElementsByTagName("message");
		for(var i = 0; i < messages.length; i++) {
			var message = messages.item(i);
			var text	= message.getAttribute("text");
			showMessage(text);	
		}
	}
	
	messages = ajaxCallXml.getElementsByTagName("exceptions");
	if (messages != null && messages.length > 0 && messages.item(0) != null) {
		messages = messages.item(0).getElementsByTagName("exception");
		for(var i = 0; i < messages.length; i++) {
			var message = messages.item(i);
			var text	= message.getAttribute("text");
			showMessage(text);	
		}
	}
	
	checkXmlResultCode(ajaxCallXml.getElementsByTagName("code"));
}

var XML_RESULT_LOGGED = true;

function checkXmlResultCode(codes) {
	XML_RESULT_LOGGED	= true;
	
	if (codes != null && codes.length == 0) codes == null;
	if (codes != null && codes.length > 0) codes = codes[0];
	
	if (codes != null && codes.firstChild.nodeValue == "-1") {
		XML_RESULT_LOGGED	= false;
		document.location = CONTEXT + "/page/login/login.jsp";
		return false;
	}
	
	return true;
}

var avoidRegExpLoopback = false;
function fieldRegExp(field) {
	if (avoidRegExpLoopback) return true;

	var regexp = field.getAttribute("regexp");
	if (regexp != null || regexp != "") {
		var regexperror = field.getAttribute("regExpMessage");
		if (regexperror == null || regexperror == "") regexperror = "El valor ingresado no es correcto";
		var value = field.value;

		if (! value.test(regexp)) {
			field.errors.push( regexperror );
			avlock = false;
			//avoidRegExpLoopback = true;
			return false;
		}
	}
	
	avoidRegExpLoopback = false;
	return true;
}


function arrayToString(arr){
	var ret = "";
	
	for(i=0;i<arr.length;i++){
		if(ret!=""){
			ret+=";";
		}
		ret+=arr[i];
	}
	return ret;
}


function createBlockerDiv(){
	var newDiv = new Element("div", {'class': 'modalBlocker'});
	newDiv.setStyle('width', '100%');
	newDiv.setStyle('height', '100%');
	newDiv.setStyle('position', 'fixed');
	newDiv.setStyle('top', '0px');
	newDiv.setStyle('left', '0px');
	newDiv.position();
	newDiv.inject(document.body);
	return newDiv;
}

var validNameLock = false;
function validName(s) {
	
	if( validNameLock )  return true;
	validNameLock = true;

	var re = new RegExp("^[a-zA-Z0-9_.]*$");
	//var re = /^[a-zA-Z0-9_.]*$/;

	if (!re.test(s.value)) {
		var errorMsg = GNR_INVALID_NAME;
		s.errors.push( errorMsg );
		validNameLock = false;
		return false;
	}

	validNameLock = false;
	return true;
}


function validNameLatin(s) {
	
	if( validNameLock )  return true;
	validNameLock = true;

	var re = new RegExp("^[a-z��A-Z0-9_.]*$");
	//var re = /^[a-zA-Z0-9_.]*$/;

	if (!re.test(s.value)) {
		var errorMsg = GNR_INVALID_NAME;
		s.errors.push( errorMsg );
		validNameLock = false;
		return false;
	}

	validNameLock = false;
	return true;
}


/*
 * Compara las fechas de inicio y fin
 * Retorna false si la fecha de inicio es mayor que la de fin
 * start: fecha inicio
 * end: fecha fin
*/
function verifyDates(start,end){
	var startDate = start.value;
	var endDate = end.value;
	
	var arrSD = new Array();
	var arrED = new Array();

	arrSD = startDate.split("/");
	arrED = endDate.split("/");
	var endYear = arrED[2];
	var endMonth =arrED[1];
	var endDay = arrED[0];
	var startYear = arrSD[2];
	var startMonth = arrSD[1];
	var startDay = arrSD[0];
	
	if (endYear < startYear){
		return false;
	} else if (endYear == startYear && endMonth < startMonth){
		return false;
	} else if (endYear == startYear && endMonth == startMonth && endDay < startDay){ 
		return false;
	}
	return true;
}

/*
 * verifica que la fecha date no sea menor que hoy
 * Retorna false si la fecha date es menor que hoy
 * date: objeto fecha
*/
function verifyDateNoEarlyToday(date){
	var todayDate = new Date();
	var day = todayDate.getDate();
	if (day < 10) { day = "0" + day; }
	var month = todayDate.getMonth() + 1;
	if (month < 10) { month = "0" + month; }
	var year = todayDate.getFullYear();
	var todayStr = day + "/" + month + "/" + year;
	var today = new Element("input", {'value': todayStr, 'type': 'hidden'});
	var ok = verifyDates(today,date);
	today.destroy();
	return ok; 
}

/*
 * Compara las fechas de date1 y date2
 * Retorna true son iguales 
*/
function equalsDates(date1,date2){
	var d1 = date1.value;
	var d2 = date2.value;
	
	var arrSD = new Array();
	var arrED = new Array();

	arrSD = d1.split("/");
	arrED = d2.split("/");
	var endYear = arrED[2];
	var endMonth =arrED[1];
	var endDay = arrED[0];
	var startYear = arrSD[2];
	var startMonth = arrSD[1];
	var startDay = arrSD[0];
	
	return (endYear == startYear && endMonth == startMonth && endDay == startDay);
}

/*
 * Compara date con la fecha de hoy
 * Retorna true si son iguales
*/
function equalsDateToday(date){
	var todayDate = new Date();
	var day = todayDate.getDate();
	if (day < 10) { day = "0" + day; }
	var month = todayDate.getMonth() + 1;
	if (month < 10) { month = "0" + month; }
	var year = todayDate.getFullYear();
	var todayStr = day + "/" + month + "/" + year;
	var today = new Element("input", {'value': todayStr, 'type': 'hidden'});
	var ok = equalsDates(today,date);
	today.destroy();
	return ok; 
}

function verifyHrMin(hrMinStart,hrMinEnd,timeSeparator){
	if (hrMinStart.value == "" || hrMinEnd.value == "") return true;
	
	if (!timeSeparator) { timeSeparator = ":"; }
	
	var start = hrMinStart.value;
	var end = hrMinEnd.value;
	
	var arrS = new Array();
	var arrE = new Array();

	arrS = start.split(timeSeparator);
	arrE = end.split(timeSeparator);
	var endHr = arrE[1];
	var endMin = arrE[0];
	var startHr = arrS[1];
	var startMin = arrS[0];
	
	if (endHr < startHr){
		return false;
	} else if (endHr == startHr && endMin < startMin){
		return false;
	}
	return true;
}


function setAdmDatePicker (datepicker) {
	if (datepicker == null) return;
	if (datepicker.get('hasDatepicker')) return;
	
	//Datepickers readonly de ejecucion
	//if(datepicker.hasClass('readonly')) return;
	
	datepicker.set('hasDatepicker', true);
	var img = new Element("img.datepickerSelector", {src: CONTEXT+"/css/"+STYLE+"/img/calendar.png"});
	img.inject(datepicker,"after");

	//var format = (datepicker.getAttribute("format") == null) ? 'd/m/Y' : datepicker.getAttribute("format");
	var format = (datepicker.getAttribute("format") == null) ? DATE_FORMAT : datepicker.getAttribute("format");
	
	var datepicker_opts = { 
		pickerClass: 'datepicker_vista', 
		allowEmpty: true, 
		format: format, 
		inputOutputFormat: format, 
		toggleElements: img, 
		toggleElementsDontAvoid: true,
		isReadonly: datepicker.hasClass('readonly'),
		onClose:function(dpk){
			dpk.fireEvent('change');
		}
	};

	if(window.LBL_DAYS) {
		datepicker_opts.days = window.LBL_DAYS;
	}
	if(window.LBL_MONTHS) {
		datepicker_opts.months = window.LBL_MONTHS;
	}
		
	var d = new DatePicker(datepicker, datepicker_opts);
	
	if(datepicker.get('fld_id')) {
		datepicker.store('datepicker', d);
		datepicker.getNext().set('id', datepicker.get('fld_id') + '_d');
	}
	
	if(datepicker.get('cusPar_id')) {
		datepicker.store('datepicker', d);
		datepicker.getNext().set('id', datepicker.get('cusPar_id') + '_d');
	}
}

function removeAdmDatePicker (datepicker) {
	if (datepicker == null) return;
	if (!datepicker.get('hasDatepicker')) return;
	
	datepicker.erase('hasDatepicker');
	datepicker.getNext('img').destroy();
	
	datepicker.getNext('input').destroy();
	datepicker.setStyle('display', '');
	
	var d = datepicker.retrieve('datepicker');
	datepicker.eliminate('datepicker');
	d.destroy();
}
	
function setAdmListTitle(ele) {
	ele = $(ele);
	if (ele) ele.tooltip(GNR_ORDER_BY + ele.getAttribute("title"), { mode: 'auto', width: 100, hook: 0 });
}

function setTooltip(ele){
	ele = $(ele);
	if (ele && ele.getAttribute("title") != null) ele.tooltip( ele.getAttribute("title"), { mode: 'auto', width: 100, hook: 0 });
}

function setAdmFilters(ele) {
	ele = $(ele);
	if (ele) {
		ele.setFilter = setFilter;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilter.delay(200, this);
		});
	}
}

function setDateFilters(ele){
	ele = $(ele);
	if (ele){
		ele.setFilter = setFilter;
		ele.addEvent("change", function(e) { this.setFilter(); });
	}
}

function clearFilter(ele){
	ele = $(ele);
	if (ele){
		ele.value = "";
		ele.oldValue = "";
	}
}

function clearFilterDate(ele){
	ele = $(ele);
	if (ele){
		ele.value = "";
		ele.oldValue = "";
		
		ele = ele.getNext();
		if (ele){
			ele.value = "";
			ele.oldValue = "";
		}
	}
}

function setAdmOrder(ele) {
	ele = $(ele);
	if (ele) {
		ele.addEvent("click", function(e) {
			e.stop();
			callNavigateOrder(this.getAttribute('sortBy'),this);
		});
	}
}

function setHourField(ele){
	ele = $(ele);
	if (ele) {
		ele.addEvent("keyup",function(e){
			if (e && e.key == "backspace") return;
			if (ele.value != null && ele.value.length == 2){
				ele.value += HOUR_SEPARATOR;
			}
		});
	}
}

/* No se debe invocar mas esta funcion. Los botones se establecen automaticamente para todos los div.button
function setAdmEvents(ele) {
	ele.addEvent("mouseover", function(evt) {this.toggleClass("buttonHover")});
	ele.addEvent("mouseout", function(evt) {this.toggleClass("buttonHover")});
}
*/

function setOrderByClass(obj){
	obj.toggleClass("orderedBy");
	if(obj.hasClass("unsorted")){
		obj.removeClass("unsorted")
		obj.addClass("sortUp");
	} else {
		if(obj.hasClass("sortUp")){
			obj.removeClass("sortUp")
			obj.addClass("sortDown");
		}else{
			obj.addClass("sortUp")
			obj.removeClass("sortDown");
		}
	}
	
}

function removeOrderByClass(obj){
	$('trOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('trOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('trOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
	
}

function processXMLResponseReload(ajaxCallXml){
	if (ajaxCallXml != null) {
		//recargar la pagina--- no se llama a la funcion navigate para que no borre los mensajes
		var currPage = parseInt($('navBarCurrentPage').value);
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=page&isAjax=true&pageNumber='+currPage + TAB_ID_REQUEST,
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) { processXMLListResponse(resXml); sp.hide(true); }
		}).send();
		
		//obtener el codigo de retorno
		var code = ajaxCallXml.getElementsByTagName("code");
		if("0" == code.item(0).firstChild.nodeValue){
			
			
		} else {
			//si el codigo es diferente de 0	
			var messages = ajaxCallXml.getElementsByTagName("messages");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("message");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);	
				}
			}
			
			messages = ajaxCallXml.getElementsByTagName("exceptions");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("exception");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);	
				}
			}
		}
	}
}

function jsCaller(fnc,data) {
	fnc(data);
}


function setAutoCompleteGeneric(eleName, eleId, action, object, filter, id, show, showAllOnEmpty, likeSearch, allowLiveCreate, forceSelect, includeEnvId, adtFilters, extraSQL, distinctId) { //adtFilters: [colType.colName.colValue,...]
		 
	likeSearch = true; //pedido para que sea de esta forma
	eleName = $(eleName);
	eleId = $(eleId);
	
	if (!extraSQL) extraSQL = "";
	
	distinctId = toBoolean(distinctId);
	
//	eleName.showTip = showTip;
	
	eleName.autocompleter = new Autocompleter.Request.HTML(eleName, 'AutoCompleteAction.run?' + TAB_ID_REQUEST, {
		indicatorClass: 'autocompleter-loading',
		forceSelect: eleId != null || forceSelect,
		showAllOnEmpty: showAllOnEmpty,
		allowEmpty: true,
		filterSubset: likeSearch,
		emptyChoices: function() { /* eleName.showTip("No se han encontrado datos para mostrar."); */ },
		notEmptyChoices: function() { eleName.tooltip_hide(); },
		onBlur: function() { eleName.tooltip_hide(); },
		onFocus: function() {
			if (! showAllOnEmpty) { /*eleName.showTip("Empiece a escribir para obtener los posibles valores.");*/ }
			if (! this.firstTime && eleId != null) { 
				this.opted = this.observer.value; 
				this.observer.value = ""; 
				this.observer.changed(); 
				this.firstTime = true; 
				eleId.oldValue = eleId.value;
			}
		},
		cache: false,
		postData: {
			'action': action,
			'object': object,
			'filter': filter,
			'id': id,
			'show': show,
			'likeSearch': likeSearch,
			'allowLive': allowLiveCreate,
			'includeEnvId': includeEnvId
		},
		injectChoice: function(choice) {
			var text = choice.getFirst();
			var value = text.innerHTML;
			if (choice.get('searchId') != '-1') {
				choice.inputValue = value;
				text.set('html', this.markQueryValue(value));
				this.addChoiceEvents(choice);
			} else {
				this.queryValue = false;
			}
		},
		onSelection: function(element, selected, value, input, visible, fromClick, fromEnter) {
			if (eleId != null) {
				eleId.oldValue = eleId.value;
				eleId.value = (selected == null) ? "" : selected.getAttribute("searchId");
			}
			eleName.fireEvent('optionSelected',[visible,fromClick,fromEnter]);
		},
		onHide: function(element) {
			if (element.value.length == 0) {
				this.clearOpted();
				if (eleId != null) {
					eleId.value = "";
					eleId.oldValue = "";
				}
				eleName.fireEvent('optionNotSelected');
			}
		},
		onRequest: function() { eleName.toggleClass("loading"); },
		onComplete: function() {eleName.toggleClass("loading"); }
	});
	
	if (adtFilters && adtFilters.length > 0){
		for(var i = 0; i < adtFilters.length; i++){
			var values = adtFilters[i].split("."); //[colType,colName,colValue]
			eleName.autocompleter.options.postData["adtFilter"+"."+values[0]+"."+values[1]] = values[2];
		}		
	}
	
	if (extraSQL != ""){
		eleName.autocompleter.options.postData["extraSQL"] = extraSQL;
	}
	
	eleName.autocompleter.options.postData["distinctId"] = distinctId;	
	
}

var Generic = {};
Generic.showSearch = function (event) {
	if(event.code == 113 || event.code == 27) {
		event.stop();
		var win = window.parent || window;
		
		if (event.code == 113) {
			win.$('tabMenu').fireEvent('click');
			win.$('menuSearchInput').select();
		} else if (win.$('tabMenu').hasClass('activeMenu')) {
			win.$('tabMenu').fireEvent('click');
		}
	}
}
Generic.preventBackNavigation = function (event) {
	if(event.code == 8) {
		if(event.target.nodeName == 'BODY' || event.target.nodeName == 'DIV' || event.target.nodeName == 'TD' || event.target.nodeName == 'SELECT' || event.target.get('readonly')) {
			event.stop();
		}
	}
}

Generic.getHiddenWidth = function(obj) {
	if(obj) {
		var clone = obj.clone();
	    clone.setStyle('visibility','hidden');
	    clone.inject(document.body);
	    var width = clone.getWidth();
	    clone.dispose();
		return width;
	}
}

Generic.getHiddenHeight = function(obj) {
	if(obj) {
		var clone = obj.clone();
	    clone.setStyle('visibility','hidden');
	    if(clone.getStyle('display', 'none'))
	    	clone.setStyle('display', '');
	    clone.inject(document.body);
	    var height = clone.getHeight();
	    clone.dispose();
		return height;
	}
}

/**
 * Establece look&feel de botones, pasando el contenido del mismo 
 */
Generic.setButton = function (ele) {
	
	var span_txt = ele.get('html');
	
	var divButton = new Element('button.genericBtn', {
		type: 'button'
	}).inject(ele.set('html', ''));
	
	if(ele.hasClass('suggestedAction')){
		divButton.addClass('suggestedAction');
	}
	var span = new Element('span', {
		'html': span_txt
	}).inject(divButton);
	
	return ele;
}

/*Version con DIV's
Generic.setButton = function (ele) {
	
	var span_txt = ele.get('html');
	
	var divButton = new Element('div.genericDivBtn')
	.set('tabindex', 0)
	.addEvents({
		'keyup': function(event) {
			if(event && (event.key == 'space' || event.key == 'enter'))
				this.getParent().fireEvent('click', event);
		},
		'focus': function(event) {
			//event.target.addClass('focus');
		},
		'blur': function(event) {
			//event.target.removeClass('focus');
		},
		'mousedown': function(event) {
			event.target.getParent().getElements('*').addClass('pressed');
		},
		'mouseup': function(event) {
			event.target.getParent().getElements('*').removeClass('pressed');
		},
		'mouseleave': function(event) {
			event.target.getParent().getElements('*').removeClass('pressed');
		}
	}).inject(ele.set('html', ''));
	
	var span = new Element('span', {
		'html': span_txt
	}).addEvents({
		'mousedown': function(event) {
			event.target.getParent().getParent().getElements('*').addClass('pressed');
		},
		'mouseup': function(event) {
			event.target.getParent().getParent().getElements('*').removeClass('pressed');
		}
	}).inject(divButton);
	
	if(Browser.ie7 || Browser.ie8) {
		divButton.addEvents({
			'mouseenter': function(event) {
				event.target.getParent().getElements('*').addClass('hover');
			},
			'mouseleave': function(event) {
				event.target.getParent().getElements('*').removeClass('hover');
			}
		});
	}
	
	if(!Modernizr.borderradius) {
		new Element('b.t1').inject(divButton, 'before');
		new Element('b.t2').inject(divButton, 'before');
		new Element('b.t3').inject(divButton, 'before');
		new Element('b.t4').inject(divButton, 'before');
		new Element('b.b1').inject(divButton, 'after');
		new Element('b.b2').inject(divButton, 'after');
		new Element('b.b3').inject(divButton, 'after');
		new Element('b.b4').inject(divButton, 'after');
		
	}
	
	return ele;
}
*/

/**
 * Crea un elemento contenedor de elementos, para mostrarlo en forma de grilla.
 * Al presionar la cruz, se dispara el evento crossclicked.
 * Recibe una cantidad dinamica de elementos a agregar
 * @param cross define si se le agrega una cruz al contenedor 
 */
Generic.createListItem = function(cross) {
	if(arguments.length > 1) {
		var total_width = 50;
		var max_height = 16;
		
		var div_container = new Element('div.list-container');
		
		var list_item = new Element('div.list-item');			
		
		total_width += Number.from(arguments[1].getStyle('width'));
		max_height = Number.max(max_height, Number.from(arguments[1].getStyle('height')));
		
		var first_ele = new Element('div.list-item-firstcontainer');
		
		if(cross) {
			new Element('div.list-item-lastcontainer').inject(list_item)
				.addEvent('click', function(event) {
				this.getParent().getParent().fireEvent('crossclicked');
			});
			total_width += 16;
		}
		
		for(var i = arguments.length - 1; i > 1; i--) {
			total_width += Number.from(arguments[i].getStyle('width'));
			max_height = Number.max(max_height, Number.from(arguments[i].getStyle('height')));
			arguments[i].inject(new Element('div.list-item-container').inject(list_item));
		}
		
		arguments[1].inject(first_ele.inject(list_item));
		list_item.inject(div_container);
		
		if(!Modernizr.borderradius) {
			new Element('b.t1').inject(list_item, 'before');
			new Element('b.t2').inject(list_item, 'before');
			new Element('b.t3').inject(list_item, 'before');
			new Element('b.t4').inject(list_item, 'before');
			new Element('b.b1').inject(list_item, 'after');
			new Element('b.b2').inject(list_item, 'after');
			new Element('b.b3').inject(list_item, 'after');
			new Element('b.b4').inject(list_item, 'after');
		}
		return div_container.setStyle('width', total_width);
	}
	return null;
}

Generic.hasNotificationPermission = function() {
	if(navigator.userAgent.indexOf('OPR') >= 0 || Browser.ie) {
		return true;
	} else if(window.webkitNotifications && window.webkitNotifications.checkPermission) {
		if (window.webkitNotifications.checkPermission() == 0)
			return true;
		else
			return false;
	} else if(window.Notification) {
		return window.Notification.permission == 'granted';
	} else {
		return true; //Simular que tiene permiso
	}
} 

Generic.requestNotificationPermission = function(fnCallback) {
	if(navigator.userAgent.indexOf('OPR') >= 0 || Browser.ie)
		fnCallback();
	else if(window.webkitNotifications && window.webkitNotifications.requestPermission)
		window.webkitNotifications.requestPermission(function() {
			setTimeout(fnCallback, 100);
		});
	else if(window.Notification && window.Notification.requestPermission)
		window.Notification.requestPermission(function() {	
			setTimeout(fnCallback, 100);
		});
}

Generic.createNotification = function(title, msg, fnClick) {
	if(navigator.userAgent.indexOf('OPR') >= 0 || Browser.ie)
		return;
	else if(window.webkitNotifications && window.webkitNotifications.checkPermission) {
		if (window.webkitNotifications.checkPermission() == 0) {
			var notification = window.webkitNotifications
					.createNotification(
							CONTEXT + '/css/' + STYLE + '/img/notif/logo_notif.png',
							title, msg);
	
			//notification.onclick = fnClick;
			notification.addEventListener('click', fnClick);
			notification.show();
		}
	} else if(window.Notification && window.Notification.permission === 'granted') {
		var notification = new window.Notification(title, {
			body: msg,
			icon: CONTEXT + '/css/' + STYLE + '/img/notif/logo_notif.png'
		});
		notification.addEventListener('click', fnClick);
	}
}

Generic.showCurrentWindow = function() {
	window.focus();
}
/////////////////////// Funciones genericas de grillas /////////////////////

//Elimina la fila seleccionada de la grilla pasada por parametro
function deleteRow(gridName){
	var selected = new Array(getSelectedRows($(gridName))[0]);
	var table = $(gridName);
	var count = selectionCount($(gridName));
	if(count==0) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
	} else if (count>1){
		showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
	}else{
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
	}
}

//Baja de posici�n la fila seleccionada de la grilla pasada por parametro
function downRow(gridName){
	var table = $(gridName);
	var count = selectionCount(table);
	if(count==0) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
	} else if (count>1){
		showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
	}else{
		var pos = Number.from(getSelectedRows(table)[0].getRowId());
		if ((Number.from(pos)+1)==table.rows.length){
			return
		}else{
			var rows = table.getElements('tr'); 
			rows[pos].inject(rows[Number.from(pos) + 1], 'after');
			
			rows[pos].setRowId(Number.from(pos) + 1);
			rows[Number.from(pos) + 1].setRowId(Number.from(pos));
			
			return rows[Number.from(pos)];
		}
	} 
}

//Sube de posici�n la fila seleccionada de la grilla pasada por parametro
function upRow(gridName){
	var table = $(gridName);
	var count = selectionCount(table);
	if(count==0) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
	} else if (count>1){
		showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
	}else{
		var pos = getSelectedRows(table)[0].getRowId();
		if (pos==0){
			return
		}else{
			
			var rows = table.getElements('tr'); 
			rows[pos].inject(rows[Number.from(pos) - 1], 'before');
			
			rows[Number.from(pos) - 1].setRowId(pos);
			rows[pos].setRowId(Number.from(pos) - 1);
			
			return rows[Number.from(pos)];
		}	
	} 
}

//Agrega el nuevo scroll a la tabla pasada como paramatero
function addScrollTable(table){
	if (table){
		var container = table.getParent('div');
		var target = table.getParent('table');
		var table_scroller = container.retrieve('custom_v_scroller');
		var scrollTo = 0;
		if(table_scroller) {
			scrollTo = table_scroller.getScroll();
			table_scroller.clearScroll();
		}
		table_scroller = container.retrieve('custom_h_scroller');
		if(table_scroller) {
			table_scroller.clearScroll();
		}
		var aux_v = null;
		if(target.getHeight() > container.getHeight()) {
			aux_v = new VScroller(container, target);
			aux_v.setScroll(scrollTo);
			container.store('custom_v_scroller', aux_v);
		} else if(target.getHeight() == 0 && container.getHeight() == 0 && Generic.getHiddenHeight(target) > Generic.getHiddenHeight(container)) {
			//-Control de ocultos
			aux_v = new VScroller(container, target);
			aux_v.setScroll(scrollTo);
			container.store('custom_v_scroller', aux_v);
		} else {
			container.store('custom_v_scroller', null);
		}
	
		//if (!table_scroller){
			var aux_h = new HScroller(container, target);
			container.store('custom_h_scroller', aux_h);
		//}
			
		
		container.getParent().getParent().getElement('div.gridHeader').getElement('table').setStyle('left', 0);
		
		return {h: aux_h, v: aux_v};
	}
}

function addHScrollDiv(div,width,useOldPosition){
	if (div){
		div.setStyles({
			overflow: 	'hidden',
			width:		width + 'px'
		});
		
		var container = div; //div		
		var target = div.getElement("div"); //
		
		var oldPos = null;
		
		var table_scroller = container.retrieve('custom_v_scroller');
		var hasOldVScroll = false;
		if (table_scroller) {
			oldPos = table_scroller.getScroll();
			table_scroller.clearScroll();
			hasOldVScroll = true;
		}
		
		if (!hasOldVScroll){
			div.getElement("div").setStyles({
				'padding-bottom': '10px',
				'padding-right': '10px'
			});;
		} else {
			div.setStyle('width',width+10);
		}
		
		var hasNewHScroll = false;
		var aux;
		if(target.getHeight() > container.getHeight()) {
			aux = new VScroller(container, target);
			container.store('custom_v_scroller', aux);
			hasNewHScroll = true;
		} else if(target.getHeight() == 0 && container.getHeight() == 0 && Generic.getHiddenHeight(target) > Generic.getHiddenHeight(container)) {
			//-Control de ocultos
			aux = new VScroller(container, target);
			container.store('custom_v_scroller', aux);
			hasNewHScroll = true;
		} else {
			container.store('custom_v_scroller', null);
		}
		
		if (!hasNewHScroll){
			div.getElement("div").setStyles({
				'padding-right': '0px'
			});
		} else {
			if (useOldPosition && oldPos != null){
				aux.setScroll(oldPos);
			}
		}
	}
}


var SITE_ESCAPE_AJAX = false;

function getFormParametersToSend(form) { //se realiza el encoding de todos los parametros que se envian: encodeURIComponent
	var params = "";
	if (form.childNodes.length > 0) {
		for (var i = 0; i < form.elements.length; i++) {
			var formElement = form.elements[i];
			if($(formElement.parentNode).hasClass('AJAXfield')){
				continue;
			}
			var formEleName = formElement.name;
			var formEleValue = formElement.value;
			var avoidSend = toBoolean(formElement.getAttribute("avoidSend"));
			var doEscapeAmp = toBoolean(formElement.getAttribute("doEscapeAmp"));
			
			if (avoidSend) continue;
			if (formEleName == null || formEleName == "") continue;
			
			if (formElement.tagName == "TEXTAREA" && toBoolean(formElement.getAttribute("isEditor"))) {
				var inst = tinyMCE.getInstanceById(formElement.id);
				formEleValue = inst.getContent();
				tinyMCE.execCommand('mceRemoveControl', false, formElement.id);
			}
			
			if (formElement.type == "select-multiple") {
				for ( var j = 0; j < formElement.options.length; j++) {
					if (formElement.options[j].selected) {
						if (params != "") params += "&";
						params += formEleName + "=" + encodeURIComponent(formElement.options[j].value);
					}
				}
			} else if ((formElement.type == "checkbox" && formElement.checked) || (formElement.type == "radio" && formElement.checked) || (formElement.type != "radio" && formElement.type != "checkbox"))  {
				if (params != "") params += "&";
				if (! SITE_ESCAPE_AJAX && doEscapeAmp) formEleValue = formEleValue.replace(/&/g, "%26").replace(/\+/g,"%2B");
				if (SITE_ESCAPE_AJAX) formEleValue = escape(formEleValue);
				params += formEleName + "=" + encodeURIComponent(formEleValue);
			}
		}
	}
	return params;	
}


function StringtoXML(text){
	if (window.ActiveXObject){
		var doc=new ActiveXObject('Microsoft.XMLDOM');
		doc.async='false';
		doc.loadXML(text);
	} else {
		var parser=new DOMParser();
		var doc=parser.parseFromString(text,'text/xml');
	}
	return doc;
}

function getStageWidth(){
	if(navigator.userAgent.indexOf("MSIE")>0){
		return document.body.parentNode.clientWidth-5;	
	}else{
		return document.body.offsetWidth-5;
	}
}
function getStageHeight(){
	if(navigator.userAgent.indexOf("MSIE")>0){
		var height=document.body.parentNode.clientHeight;
		if(document.body.parentNode.clientHeight==0){
			height=document.body.clientHeight;
		}
		return height;
	}else{
		return height=window.innerHeight;
	}
}

Generic.testRegExp = function(str, reg_exp_str) {
	if (str != "")
		return new RegExp(reg_exp_str).test(str); 
	
	return true;
}

Generic.testPasswordRegExp = function(value, reg_exp_str) {
	
}

Generic.htmlDecode = function(input) {
	var e = document.createElement('div');
	e.innerHTML = input;
	return e.childNodes.length === 0 ? "" : e.childNodes[0].nodeValue;
}

Generic.checkDateFormat = function(value, format) {
	var date = value.split('/');
	if(date.length != 3)
		return;
	
	var day_str;
	var month_str;
	var year_str;
	var day;
	var month;
	var year;
	
	if(format == 'd-m-Y' || format == 'd/m/Y') {
		day_str = date[0];
		month_str = date[1];
		year_str = date[2];
	} else if(format == 'm-d-Y' || format == 'm/d/Y') {
		day_str = date[1];
		month_str = date[0];
		year_str = date[2];
	} else if(format == 'Y-m-d' || format == 'Y/m/d') {
		day_str = date[2];
		month_str = date[1];
		year_str = date[0];
	}
	
	day = Number.from(day_str);
	month = Number.from(month_str);
	year = Number.from(year_str);
	
	if(day_str.length == 2 && (String.from(day).length == 2 || String.from(day).length == 1 && day_str[0] == '0') && day < 32 &&
			month_str.length == 2 && (String.from(month).length == 2 || String.from(month).length == 1 && month_str[0] == '0') && month < 13)
		return true;
	else
		return false;	
}

/**
* Crea el Iframe para comenzar la descarga, luego lo oculta autom�ticamente el panel.
* @param {string} title: Titulo del panel de descarga, valor por defecto: ��
* @param {string} content: Contenido del panel, valor por defecto: etiqueta lblDownloadingFile
* @param {string} url_req_ajax: Ruta del action correspondiente, valor por defecto: URL_REQUEST_AJAX
* @param {string} action: Acci�n a realizar, valor por defecto: �download�
* @param {string} otherParamsToSend: Par�metros que se pueden agregar a la url que se env�a, debe estar en el formato �&param1=val1&param2=val2��, valor por defecto: ��
* @param {string} addClosePanelFncName: Nombre de una funci�n a ejecutar si se cierra el panel, valor por defecto: ��
* @param {string} addClosePanelCloseAll: Indica si al presionar en cerrar se deben cerrar todos los paneles, valor posibles: �true� o �false�, valor por defecto: �false�
* @param {function} otherFncInOnLoad: Funci�n adicional que se quiere ejecutar en el onload del IFrame, valor por defecto: null
**/
//TODO: Probada en Firefox y Chrome
function createDownloadIFrame(title,content,url_req_ajax,action,otherParamsToSend,addClosePanelFncName,addClosePanelCloseAll,otherFncInOnLoad){ //otherParamsToSend: &param1=val1&param2=val2...
	if (!title) title = "";
	if (!content) content = DOWNLOADING;
	if (!url_req_ajax) url_req_ajax = URL_REQUEST_AJAX;
	if (!action) action = "download";
	if (!otherParamsToSend) otherParamsToSend = "";	
	if (!addClosePanelFncName) addClosePanelFncName = "";
	if (!addClosePanelCloseAll) addClosePanelCloseAll = "false";
	if (!otherFncInOnLoad) otherFncInOnLoad = null;
	
	var panel = SYS_PANELS.newPanel();
	if (addClosePanelFncName == ""){
		SYS_PANELS.addClose(panel);
	} else {
		addClosePanelCloseAll = toBoolean(addClosePanelCloseAll);
		SYS_PANELS.addClose(panel,addClosePanelCloseAll,addClosePanelFncName);
	}
	panel.header.innerHTML = title;
	panel.content.innerHTML = content;
	var ifrm = new IFrame({
	    src:  CONTEXT + url_req_ajax + "?action=" + action + otherParamsToSend + TAB_ID_REQUEST,
	    styles: {
	       display: 'none'
	    },
	    events: {
	        load: function(){
	        	SYS_PANELS.closeAll.delay(DEFAULT_DELAY_IN_HIDE_DOWNLOAD_IFRAME,SYS_PANELS);
	        	if (otherFncInOnLoad != null){
	        		otherFncInOnLoad();
	        	}
	        },
	        domready: function() {
	        	SYS_PANELS.closeAll.delay(DEFAULT_DELAY_IN_HIDE_DOWNLOAD_IFRAME,SYS_PANELS);
	        	if (otherFncInOnLoad != null){
	        		otherFncInOnLoad();
	        	}
	        }	 
	    }	 
	});
	panel.content.grab(ifrm);
	panel.position();
	SYS_PANELS.refresh();
} 

function initPinOptions() {
	var panelPinShow = $('panelPinShow');
	if (! panelPinShow) return;
	
	var panelPinHidde = $('panelPinHidde');
	if (! panelPinHidde) return;
	
	var frmData = $('frmData');
	if (! frmData) return;
	
	panelPinShow.addEvent('click', function(evt) { 
		frmData.removeClass('autoHideActions'); 
		frmData.removeClass('temporalyShowActions');
		frmData.getElement('div.dataContainer').removeClass('max-size')
		window.fireEvent('resize');
	});
	panelPinHidde.addEvent('click', function(evt) { 
		frmData.addClass('autoHideActions');
		frmData.getElement('div.dataContainer').addClass('max-size')
		window.fireEvent('resize');
	});
	
	var optionsContainer = panelPinShow.getParent('div.optionsContainer');
	
	optionsContainer.addEvent('mouseover', function(evt) {
		if (frmData.hasClass('autoHideActions')) {
			frmData.addClass('temporalyShowActions')
		}
	} );
	optionsContainer.addEvent('mouseout', function(evt) {
		if (frmData.hasClass('autoHideActions')) {
			frmData.removeClass('temporalyShowActions')
		}
	} );
}

// Mostrar/Ocultar men� para los listados
function initPinGridOptions(){
	
	if($('panelPinHidde') && $('panelPinShow')){
		var pinHide = $('panelPinHidde').addEvent('click', function() {
			handlerGridOptionsContainer(true, 'none');
		});
		var pinShow = $('panelPinShow').addEvent('click', function() {
			this.setStyle('display', 'none');
			pinHide.setStyle('display', 'block');
			handlerGridOptionsContainer(false, '');
		});	
	}
	
	
}

function handlerGridOptionsContainer(block, style) {
	//Ajusta tama�o de men�
	var divs = $('optionsContainer').setStyles({
		width:	block?30:style,
		height:	block?20:style
	}).getChildren();
	
	//Se distingue caso del div que contiene bot�n
	var infoDiv = divs[0].getChildren();
	infoDiv[0].setStyle('border-bottom', style).getChildren().each(function(ele) {				
		if(ele.get('id') == 'panelPinShow')
			ele.setStyle('display', block?'block':style);
		else
			ele.setStyle('display', style);
	});
	infoDiv[1].setStyle('display', style);
	
	//Oculto posibles restantes opciones del men�
	for(var i=1; i<divs.length; i++){
		divs[i].setStyle('display', style);
	}
	
	//Agrando/reduzco grilla seg�n corresponda
	$('gridContainer').setStyle('margin-right', block?'40px':style);
	
	//Se actualiza scroll de la tabla, se distingue el caso que se encuentra dentro de un tab
	if ($('tableData')){
		var contentTab = $('tableData').getParent('.contentTab');
		if (contentTab){
			if (contentTab.className.contains('active')){
				addScrollTable($('tableData'));			
			}
		} 
		else{
			addScrollTable($('tableData'));
		}
	}
}


Generic.setAdmGridBtnWidth = function(btn) {
	btn.setStyle('width', Number.from(Generic.getHiddenWidth(btn.clone().setStyle('display', 'inline-block'))) + 18);
}

/**
 * message - String
 * params - String[]
 */
Generic.parseMessage = function(message, params) {
	var res = null;
	var strAux = "";

	// if the message has dinamic data to insert in it, 
	// the message is parsed and the <TOK1>, <TOK2>, ... are replaced with
	// the data in the collection received in the messageVo object.
	if (params != null) {
		var size = params.length;
		res = message;
		for (var i = 1; i <= size; i++) {
			if (res.indexOf("<TOK" + i) == -1) continue;
			res = res.substring(0, res.indexOf("<TOK" + i)) + params[i - 1] + res.substring(res.indexOf("<TOK" + i) + "<TOK".length + new String(i).length + ">".length);
		}
	} else {
		res = message;
	}
	
	return res;
}

Generic.isMobile = navigator.userAgent.match(/Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile/i) != null;

/**
 * Muestra loading mientras no este la cookie
 * fnc_callback - Function
 */
Generic.showWaitingForDownload = function(fnc_callback) {
	SYS_PANELS.showLoading();
	
	WaitForIFrame();

    function WaitForIFrame() {
    	if(Cookie.read(TAB_ID)) {
    		//Cookie.dispose(TAB_ID);
    		document.cookie = TAB_ID +"=;expires=Wed 01 Jan 1970";
    		SYS_PANELS.closeAll();
    		if(fnc_callback)
    			fnc_callback();
    	} else {
    		setTimeout(WaitForIFrame, 200);
    	}
    }
}

/**
 * Cambia los TOK por valores string. Es invocable a partir de varios argumentos
 * @returns String
 */
Generic.formatMsg = function(msg) {
	var res = msg;
	for(var i = 1; i < arguments.length; i++) {
		res = res.replace('<TOK' + i + '>', arguments[i]);
	}
	return res;
}