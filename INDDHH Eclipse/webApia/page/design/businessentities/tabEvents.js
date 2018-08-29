var tdWidthsBC, tdWidthsSTA;

var currentInfo = {'BC' : [], 'STA' : [] };
var currentSelectedEvents;

var evtId, evtName, evtCondition, selectedClaId;

function initEventPage(){
	
	loadEventTypes();
	
	//Se obtienen anchos de columnas
	tdWidthsBC = getTdWidths($('tableDataBC'));
	tdWidthsSTA = getTdWidths($('tableDataSTA'));
	
	/*
	 * Botones de acciones
	 */
	["BC", "STA"].each(function(prefix){
		var btnAdd = $("btnAdd"+prefix);
		if (btnAdd){
			btnAdd.fade(0.4);
			btnAdd.title=LBL_ADD;
			btnAdd.addEvent('click', function(e){
				if (e) e.stop();
				
				if (this.getAttribute('data-disabled')=='true') return;
				
				if (prefix=='BC'){
					var id =  $('busClaSearchId').value;
					var name = $('busClaInputSearch').value
				} else {
					var selectedState = $('cmbStates').selectedOptions[0];
					var id =  selectedState.value;
					var name = selectedState.text;
					
					if (existsState(id)) {
						var eventName = $('cmbEvtTypesSTA').selectedOptions[0].text;
						var msg = MSG_EXISTS_STATE.replace('<TOK1>', name+' ('+eventName+')');
						showMessage(msg, null, 'modalWarning');
						return;
					}
				}
				addRowEvent(id, name, true, true /*selectRow*/, prefix);
			})
		}
		
		var btnRemove = $("btnRemove"+prefix);
		if (btnRemove){
			btnRemove.title=LBL_DEL;
			btnRemove.addEvent('click', function(e){
				if (e) e.stop();
				
				var tbody=$('tableData'+prefix);
				if (!tbody.lastSelected) {
					showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
					return null;
				} else {
					removeApiaEvent(tbody.lastSelected,prefix);
					tbody.lastSelected.destroy();
					tbody.lastSelected=null;
					
					//--Scroll
					addScrollTable(tbody);
				}
			})
		}
		
		var btnUp = $("btnUp"+prefix);
		if (btnUp){
			btnUp.title=LBL_UP;
			btnUp.addEvent('click', function(e){
				if (e) e.stop();
				
				var tbody=$('tableData'+prefix);
				if (!tbody.lastSelected) {
					showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
					return null;
				} else {
					var pos = tbody.lastSelected.getRowId();
					upRowEvent(parseInt(pos),prefix);
				}
			})
		}
		
		var btnDown = $("btnDown"+prefix);
		if (btnDown){
			btnDown.title=LBL_DOWN;
			btnDown.addEvent('click', function(e){
				if (e) e.stop();
				
				var tbody=$('tableData'+prefix);
				if (!tbody.lastSelected) {
					showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
					return null;
				} else {
					var pos = tbody.lastSelected.getRowId();
					downRowEvent(parseInt(pos),prefix);
				}
			})
		}
	})
	
	//Se inicializa buscador de clases
	var busClaInputSearch = $("busClaInputSearch");
	if (busClaInputSearch){
		setAutoCompleteBasic(busClaInputSearch, 'busClaSearchId', 'searchBusinessClasses', true, CONTEXT + '/AutoCompleteAction.run?', true);
		busClaInputSearch.addEvents({
			'optionNotSelected': function(evt) {
				btnAddBC.fade(0.4);
				btnAddBC.setAttribute('data-disabled', true);
			},
			'optionSelected': function(evt) {
				btnAddBC.fade(1);
				btnAddBC.setAttribute('data-disabled', false);
			}
		});
		$('busClaIconSearch').addEvent('click', function(e){
			busClaInputSearch.focus();
			(function(){ 
				busClaInputSearch.autocompleter.query();
			}).delay(200)
			
		})
	}
	
	//Se inicializan eventos actuales
	loadEvents($('txtMap'));
	currentInfo.BC.each(function(evt){
		addRowEvent(evt.class_id, evt.class_name, false, false, 'BC', evt.event_name);
	})
	
	//Se inicializan estados actuales
	loadStates($('txtEntityStateXML'));
	currentInfo.STA.each(function(evt){
		addRowEvent(evt.class_id, evt.class_name, false, false, 'STA', evt.event_name);
	})
	
}

function downRowEvent(pos,prefix){
	var tbody = $('tableData'+prefix);
	if ((pos+1)==tbody.rows.length){
		return
	}else{
		tbody.rows[pos].parentNode.insertBefore(tbody.rows[pos+1],tbody.rows[pos]);
		tbody.rows[pos].setRowId(pos);
		tbody.rows[pos+1].setRowId(pos+1);
		
		var tmp = currentInfo[prefix][pos+1];
		currentInfo[prefix][pos+1] = currentInfo[prefix][pos];
		currentInfo[prefix][pos] = tmp;
		
		var tmpOrder = currentInfo[prefix][pos+1].order;
		currentInfo[prefix][pos+1].order = currentInfo[prefix][pos].order;
		currentInfo[prefix][pos].order = tmpOrder;
	}
	if (Scroller != null && Scroller.v != null){
		Scroller.v.showElement(tbody.rows[pos+1]);
	}
}

function upRowEvent(pos,prefix){
	var tbody = $('tableData'+prefix);
	if (pos==0){
		return
	}else{
		tbody.rows[pos].parentNode.insertBefore(tbody.rows[pos],tbody.rows[pos-1]);
		tbody.rows[pos-1].setRowId(pos-1);
		tbody.rows[pos].setRowId(pos);
		
		var tmp = currentInfo[prefix][pos-1];
		currentInfo[prefix][pos-1] = currentInfo[prefix][pos];
		currentInfo[prefix][pos] = tmp;
		
		var tmpOrder = currentInfo[prefix][pos-1].order;
		currentInfo[prefix][pos-1].order = currentInfo[prefix][pos].order;
		currentInfo[prefix][pos].order = tmpOrder;				
	}
	if (Scroller != null && Scroller.v != null){
		Scroller.v.showElement(tbody.rows[pos-1]);
	}
}

function addRowEvent(id, name, initializeEvent, selectRow, prefix, eventName){
	var tbody = $('tableData'+prefix);
	
	var tr = new Element('tr.selectableTR');
	tr.getRowId = function () { return this.getAttribute("data-rowId"); };
	tr.setRowId = function (rowId) { this.setAttribute("data-rowId",rowId); };
	tr.getId = function () { return this.getAttribute("data-id"); };
	tr.setId = function (id) { this.setAttribute("data-id",id); };
	
	tr.setId(id);
	tr.setRowId(tbody.rows.length);
	
	if(tbody.rows.length%2==0) tr.addClass("trOdd");
	
	var colCount = prefix=='BC'? 4 : 3;
	for (var i=0; i<colCount; i++){
		if (prefix=='BC')
			var td = new Element('td', {width: tdWidthsBC[i]});
		else 
			var td = new Element('td', {width: tdWidthsSTA[i]});
		var div = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre'}});

		if (i==0){
			var value = eventName? eventName : $('cmbEvtTypes'+prefix).selectedOptions[0].text;
			var span = new Element('span', {'html': value}).inject(div);
		} else if (i==1){
			var span = new Element('span', {'html': name}).inject(div);
		} else if (i==2){
			div.setStyle('text-align', 'center');
			var container = new Element('div.icon-container.icon-container-center').inject(div);
			new Element('div.icon-item.search-icon.icon-selected')
				.addEvent('click', function(e){
					if (e) e.stop();
					
					var tr = this.getParent('tr');
					var rowId = tr.getRowId();
					evtCondition=currentInfo[prefix][rowId].skip_cond;
					tr.fireEvent('click');
					
					openModal(CONDITION_MODAL, '&requestAction='+URL_REQUEST_AJAX, 55, 60, 
						function(cond){//Confirm
							if (!cond && cond!='') return;
							
							currentInfo[prefix][rowId].skip_cond = cond;
							evtCondition=null;
						}
					)
				})			
				.inject(container);
			
		} else if (i==3){
			div.setStyle('text-align', 'center');
			var container = new Element('div.icon-container.icon-container-center').inject(div);
			new Element('div.icon-item.binding-icon.icon-selected')
				.addEvent('click', function(e){
					if (e) e.stop();
					
					var tr = this.getParent('tr');
					selectedClaId=tr.getId();
					var rowId = tr.getRowId();
					currentSelectedEvents = JSON.stringify(currentInfo[prefix][rowId]);
					tr.fireEvent('click');
					
					openModal(PARAMS_MODAL, null, 65, 60, 
						function(events){//Confirm
							if (!events) return;
							
							currentInfo[prefix][rowId] = JSON.parse(events);
							currentSelectedEvents = null;
						}
					)
				})			
				.inject(container);
			
		}		
		div.inject(td);
		td.inject(tr);
		tr.inject(tbody);
	}

	//Se inicializa el nuevo evento
	if (initializeEvent) {
		evtId = $('cmbEvtTypes'+prefix).selectedOptions[0].value;
		evtName = $('cmbEvtTypes'+prefix).selectedOptions[0].text;
		var evt = new ApiaEvent(evtId, evtName);
		evt.order = tr.getRowId();
		evt.class_id = id;
		evt.class_name = name;
		currentInfo[prefix].push(evt);
	}	
	
	initTable(tbody);
	
		
	if (selectRow){ 
		//--Scroll
		addScrollTable(tbody);
		
		tr.fireEvent('click'); 
	}
}

function getTdWidths(tbody){
	if (!tbody) return;
	
	var thead = tbody.getParent("table").getFirst('thead');
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	
	return tdWidths;
}

function removeApiaEvent(tr,prefix){
	var tbody = $('tableData'+prefix);
	
	var found=false;
	for (var i = 0; i<tbody.rows.length; i++){		
		if (found){
			var evt = currentInfo[prefix][i-1];
			evt.order = (Number.from(evt.order)-1).toString();
			tbody.rows[i].setRowId(evt.order);
		} else{
			var evt = currentInfo[prefix][i];
			if (evt.class_id==tr.getId() && i==tr.getRowId()){		
				currentInfo[prefix].splice(i, 1);
				found=true;
			}
		}
	}
}

function loadEventTypes(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=xmlEvents&xml=true' + TAB_ID_REQUEST,		
		onComplete: function(resText, resXml) { 
			var rows = resXml.getElementsByTagName("ROW");
			if (rows != null && rows.length > 0) {
				var containers = [$('cmbEvtTypesBC'),$('cmbEvtTypesSTA')];
				containers.each(function(container){
					for(var i=0; i<rows.length; i++){
						var r = rows[i];
						var cols = r.getElementsByTagName('COL');
						new Element('option',{value:cols[0].textContent, html:cols[1].textContent}).inject(container);
					}	
				})
			}
		}
	}).send();
}

function updateStatesEventCombo(){
	var cmbSta = $("cmbStates");
	var container = $('statusContainer');
	
	cmbSta.empty();
	container.getElements('.option').each(function(sta){
		if (!sta.hasClass('optionAdd'))
			new Element('option',{value:sta.id, html:sta.textContent}).inject(cmbSta);	
	})
	
	var btnAdd = $('btnAddSTA');
	if (cmbSta.options.length>0){
		btnAdd.fade(1);
		btnAdd.setAttribute('data-disabled', false);	
	} else {
		btnAdd.fade(0.4);
		btnAdd.setAttribute('data-disabled', true);
	}
}

function openModal(modalUrl, addParams, width, height, confirmCallback, closeCallback, parent){
	if (typeof(width) == 'number'){//percentage
		var bodyWidth = Number.from(frameElement.getParent("body").clientWidth);
		width = (width*bodyWidth)/100; //%
	} else {
		width = width.replace('px','');
	}
	if (typeof(height) == 'number'){//percentage
		var bodyHeight = Number.from(frameElement.getParent("body").clientHeight);
		height = (height*bodyHeight)/100; //%	
	} else {
		height = height.replace('px','');
	}
	
	var url = modalUrl + '?' + TAB_ID_REQUEST;
	if (addParams) url += addParams;
	
	var mdlController = ModalController
		.openWinModal(url, width, height, undefined, undefined, false, false, false, parent)
		.setCloseLabel(LBL_CLOSE)
		.addEvent('confirm', confirmCallback);
	
	mdlController.modalWin.addEvent('customConfirm', function(params){
		this.fireEvent('confirm', params);
		this.closeModal();
	}.bind(mdlController));
			
	if (closeCallback)	mdlController.addEvent('close', closeCallback);
}


function loadEvents(strEvents){	
	var xml;
	
	//Se carga eventos como xml
	if(strEvents && strEvents.value!='') {
		//Obtener el xml del textarea		
		if (window.DOMParser) {
			var parser = new DOMParser();
			xml= parser.parseFromString(strEvents.value,"text/xml");
		} else {
			// Internet Explorer
			xml = new ActiveXObject("Microsoft.XMLDOM");
			xml.async = false;
			xml.loadXML(strEvents.value); 
		}
	} else {
		//Caso vacío
		return;
	}

	if (!xml) return;
		
	var events = []
	try {
		for(var i=0; i< xml.children.length; i++){
			var evts=xml.children[i];
			if (evts.tagName=='ENTITY_DEFINITION'){
				events = evts.getElementsByTagName('EVENT');
				break;
			}
		}
	} catch (err){}

	currentInfo.BC = [];
	for (var j=0; j<events.length; j++){
		var e = events[j];
		var evt = new ApiaEvent();
		loadFromElementAttributes(evt, e, ['event_id','event_name','order','class_id','class_name','skip_cond','bnd_id']);
		
		var bindings = e.getElementsByTagName('BINDING');
		for (var k=0; k<bindings.length; k++){
			var b = bindings[k];
			var bnd = new ApiaEventBinding();
			loadFromElementAttributes(bnd, b, ['param_id','param_name','param_type','att_id','att_type','att_label','att_name']);
			if (bnd.att_type!='E' && bnd.att_type!='P') {
				bnd.att_type = 'V';
				bnd.value = b.textContent; 
			}
			evt.bindings.push(bnd);
		}

		currentInfo.BC.push(evt);
	}
	
	//Se ordenan eventos según el valor de 'order'
	currentInfo.BC.sort(function(a, b) {
		if (Number.from(a.order) > Number.from(b.order)) return 1; 
		if (Number.from(a.order) < Number.from(b.order)) return -1;
		return 0;
	})
}

function loadStates(strStates){	
	var xml;
	
	//Se carga estados como xml
	if(strStates && strStates.value!='') {
		//Obtener el xml del textarea		
		if (window.DOMParser) {
			var parser = new DOMParser();
			xml= parser.parseFromString(strStates.value,"text/xml");
		} else {
			// Internet Explorer
			xml = new ActiveXObject("Microsoft.XMLDOM");
			xml.async = false;
			xml.loadXML(strStates.value); 
		}
	} else {
		//Caso vacío
		return;
	}

	if (!xml) return;
		
	var events = []
	try {
		for(var i=0; i< xml.children.length; i++){
			var evts=xml.children[i];
			if (evts.tagName=='ENTITY_DEFINITION'){
				events = evts.getElementsByTagName('EVENT');
				break;
			}
		}
	} catch (err){}

	currentInfo.STA = [];
	for (var j=0; j<events.length; j++){
		var e = events[j];
		var evt = new ApiaEvent();		
		loadFromElementAttributes(evt, e, ['event_id','event_name','order','skip_cond']);
		evt.class_id = e.getAttribute('status_id');
		evt.class_name = e.getAttribute('status_name');
		currentInfo.STA.push(evt);
	}
	
	//Se ordenan eventos según el valor de 'order'
	currentInfo.STA.sort(function(a, b) {
		if (Number.from(a.order) > Number.from(b.order)) return 1; 
		if (Number.from(a.order) < Number.from(b.order)) return -1;
		return 0;
	})
}

function loadFromElementAttributes(object, element, keys){
	if (!keys) return;
	if (!object) object={};
	
	keys.each(function(key){ 
		if (element.getAttribute(key)){	object[key] = element.getAttribute(key); } 
	})
}

function loadFromObjectAttributes(object, element, keys){
	if (!keys) return;
	if (!element) return;
	
	keys.each(function(key){ 
		if (object[key]){ element.setAttribute(key, Generic.unespapeHTML(object[key]));	}
	})
}

//Se genera XML de eventos/estados para ser enviado al servidor
function getEventsLayout(prefix){
	var layout = document.implementation.createDocument(null, "ENTITY_DEFINITION", null).documentElement;
	var events = document.createElementNS(null, "EVENTS");
	
	//Se recorren todos los eventos/estados	
	var i=0;
	for(var i=0; i<currentInfo[prefix].length; i++){
		var current = currentInfo[prefix][i];
		
		var event = document.createElementNS(null, "EVENT");			
		loadFromObjectAttributes(current, event, ['event_id','event_name','order','skip_cond'])
		
		if (prefix=='BC'){
			event.setAttribute('class_id', Generic.unespapeHTML(current.class_id));
			event.setAttribute('class_name', Generic.unespapeHTML(current.class_name));
			event.setAttribute('bnd_id', Generic.unespapeHTML(current.bnd_id));
			
			current.bindings.each(function(bnd){
				var binding = document.createElementNS(null, "BINDING");
				loadFromObjectAttributes(bnd, binding, 
						['param_id','param_name','order','param_type','att_type','att_id','att_name']);
				if (bnd.att_type!='E' && bnd.att_type!='P') { binding.textContent = bnd.value; }
				
				event.appendChild(binding);
			})
			
		} else if (prefix=='STA'){
			event.setAttribute('status_id', Generic.unespapeHTML(current.class_id));
			event.setAttribute('status_name', Generic.unespapeHTML(current.class_name));
		}		

		events.appendChild(event);
	}
	
	layout.appendChild(events);
	
	if(window.XMLSerializer) {
		return new XMLSerializer().serializeToString(layout);
	} else {
		return layout.xml;
	}
}

/*
* Clases para manipular eventos/estados
*/
var ApiaEvent = new Class({
	event_id	: null,
	event_name	: null,
	order 		: null,
	class_id	: null,
	class_name	: null,
	skip_cond	: null,
	ajax		: null,
	bnd_id 		: null,
	bindings	: [],
	
	initialize : function(id, name){
		this.event_id=id;
		this.event_name=name;
	}
})

var ApiaEventBinding = new Class({
	param_id	: null,
	param_name	: null,
	param_type	: null,
	att_id	 	: null,
	att_type 	: null,
	att_label	: null,
	att_name	: '',
	value		: '',
	
	initialize  : function(param_id, param_name, param_type, att_type, value){
		this.param_id=param_id;
		this.param_name=param_name;
		this.param_type=param_type;
		this.att_type=att_type;
		this.value=value;
	},
	reset : function(){
		this.att_id = null;
		this.att_label = null;
		this.att_name = '';
		this.value = '';
	},
	initializeFromObject : function(object){
		if (!object) return;
				
		var current=this;
		Object.keys(object).each(function(key){
			current[key]=object[key];
		})
	}
})

function existsState(stateId){
	var eventId = $('cmbEvtTypesSTA').selectedOptions[0].value;	
	var exists  = false;
	currentInfo.STA.each(function(s){
		if (s.event_id == eventId && s.class_id == stateId){
			exists = true;
			return;
		}		
	})
	return exists;
}