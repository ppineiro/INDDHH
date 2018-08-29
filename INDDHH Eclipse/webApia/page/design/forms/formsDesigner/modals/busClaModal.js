var tdWidths, tdWidthsParams;

var currentEvents = [];
var cmbTypeParams;

var evtId, evtName, evtCondition;

function initPage(){
	//Se obtienen anchos de columnas
	tdWidths = getTdWidths($('tableDataBC'));	
	tdWidthsParams = getTdWidths($('tableDataBCParams'));
	
	/*
	 * Botones de acciones
	 */
	var btnAddBC = $("btnAddBC");
	if (btnAddBC){
		btnAddBC.fade(0.4);
		btnAddBC.title=LBL_ADD;
		btnAddBC.addEvent('click', function(e){
			if (e) e.stop();
			
			if (this.getAttribute('data-disabled')=='true') return;
			
			var eleId = $('busClaSearchId');
			addRow(eleId.value, $('busClaInputSearch').value, eleId.getAttribute('data-additional'), null, true, true /*selectRow*/);
		})
	}
	var btnRemoveBC = $("btnRemoveBC");
	if (btnRemoveBC){
		btnRemoveBC.title=LBL_DEL;
		btnRemoveBC.addEvent('click', function(e){
			if (e) e.stop();
			
			var tbody=$('tableDataBC');
			if (!tbody.lastSelected) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
				return null;
			} else {
				removeApiaEvent(tbody.lastSelected);
				tbody.lastSelected.destroy();
				tbody.lastSelected=null;
				$('tableDataBCParams').empty();
				
				//--Scroll
				addScrollTable(tbody);
			}
		})
	}
	var btnUpBC = $("btnUpBC");
	if (btnUpBC){
		btnUpBC.title=LBL_UP;
		btnUpBC.addEvent('click', function(e){
			if (e) e.stop();
			
			var tbody=$('tableDataBC');
			if (!tbody.lastSelected) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
				return null;
			} else {
				var pos = tbody.lastSelected.getRowId();
				upRow(parseInt(pos));
			}
		})
	}
	var btnDownBC = $("btnDownBC");
	if (btnDownBC){
		btnDownBC.title=LBL_DOWN;
		btnDownBC.addEvent('click', function(e){
			if (e) e.stop();
			
			var tbody=$('tableDataBC');
			if (!tbody.lastSelected) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
				return null;
			} else {
				var pos = tbody.lastSelected.getRowId();
				downRow(parseInt(pos));
			}
		})
	}
	
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
	var currentFieldProperty = JSON.parse(parent.currentFieldProperty);
	currentEvents = currentFieldProperty? currentFieldProperty.events : [];
	currentEvents.each(function(evt){
		addRow(evt.class_id, evt.class_name, evt.ajax, evt.ajax, false);
	})
	
	//Se inicializa combo con opciones de tipo de parámetros
	cmbTypeParams = new Element('select',{styles:{'width':'100%'}});
	currentFieldProperty.values.each(function(v){
		new Element('option',{value:v.value, html:v.label}).inject(cmbTypeParams);
	})
	
	evtId = currentFieldProperty.evtId;
	evtName = currentFieldProperty.evtName;
	evtCondition = currentFieldProperty.evtCondition;
}

function getModalReturnValue() {
	return JSON.stringify(currentEvents);
}

function downRow(pos){
	var tbody = $('tableDataBC');
	if ((pos+1)==tbody.rows.length){
		return
	}else{
		tbody.rows[pos].parentNode.insertBefore(tbody.rows[pos+1],tbody.rows[pos]);
		tbody.rows[pos].setRowId(pos);
		tbody.rows[pos+1].setRowId(pos+1);
		
		var tmp = currentEvents[pos+1];
		currentEvents[pos+1] = currentEvents[pos];
		currentEvents[pos] = tmp;
		
		var tmpOrder = currentEvents[pos+1].order;
		currentEvents[pos+1].order = currentEvents[pos].order;
		currentEvents[pos].order = tmpOrder;
	}
	if (Scroller != null && Scroller.v != null){
		Scroller.v.showElement(tbody.rows[pos+1]);
	}
}

function upRow(pos){
	var tbody = $('tableDataBC');
	if (pos==0){
		return
	}else{
		tbody.rows[pos].parentNode.insertBefore(tbody.rows[pos],tbody.rows[pos-1]);
		tbody.rows[pos-1].setRowId(pos-1);
		tbody.rows[pos].setRowId(pos);
		
		var tmp = currentEvents[pos-1];
		currentEvents[pos-1] = currentEvents[pos];
		currentEvents[pos] = tmp;
		
		var tmpOrder = currentEvents[pos-1].order;
		currentEvents[pos-1].order = currentEvents[pos].order;
		currentEvents[pos].order = tmpOrder;				
	}
	if (Scroller != null && Scroller.v != null){
		Scroller.v.showElement(tbody.rows[pos-1]);
	}
}

function addRow(id, name, haveAjaxProp, isAjax, initializeEvent, selectRow){
	var tbody = $('tableDataBC');
	
	var tr = new Element('tr.selectableTR').addEvent('selected', function(){
		loadBCParameters(this.getRowId(), this.getId());
	})	
	
	tr.getRowId = function () { return this.getAttribute("data-rowId"); };
	tr.setRowId = function (rowId) { this.setAttribute("data-rowId",rowId); };
	tr.getId = function () { return this.getAttribute("data-id"); };
	tr.setId = function (id) { this.setAttribute("data-id",id); };
	
	tr.setId(id);
	tr.setRowId(tbody.rows.length);
	
	if(tbody.rows.length%2==0) tr.addClass("trOdd");
	
	var colsCount = IS_FORM_PROP? 2 : 3; 
	for (var i=0; i<colsCount; i++){
		var td = new Element('td', {width: tdWidths[i]});
		var div = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre'}});

		if (i==0){
			var span = new Element('span', {'html': name}).inject(div);
		} else if (i==1){
			div.setStyle('text-align', 'center');
			var container = new Element('div.icon-container.icon-container-center').inject(div);
			new Element('div.icon-item.search-icon.icon-selected')
				.addEvent('click', function(e){
					if (e) e.stop();
					
					var tr = this.getParent('tr');
					var rowId = tr.getRowId();
					evtCondition=currentEvents[rowId].skip_cond;
					tr.fireEvent('click');
					
					var footerMask = new Mask(parent.ModalController.modals[0].modalWin.getElement('.modalBottomBar'));
					footerMask.show();
					
					openModal(CONDITION_MODAL, null, 55, 60, 
						function(cond){//Confirm
							if (!cond && cond!='') return;
							
							currentEvents[rowId].skip_cond = cond;
							evtCondition=null
							
							footerMask.destroy();
						}, 
						function(){//Close
							footerMask.destroy();
						}
					)
				})			
				.inject(container);
			
		} else if (i==2){
			if (haveAjaxProp!=undefined){
				var container = new Element('div.checkbox-container').inject(div);
				
				if (isAjax==false){
					var chk = new Element('input',{type:'checkbox',checked:false}).inject(container);
					var chkLbl = new Element('div.checkbox-label',{'html':LBL_NO}).inject(container);
				} else {
					var chk = new Element('input',{type:'checkbox',checked:true}).inject(container);
					var chkLbl = new Element('div.checkbox-label',{'html':LBL_YES}).inject(container);
				}
				
				chk.addEvent('change', function(e){	
					chkLbl.innerHTML = this.checked? LBL_YES : LBL_NO;
					updateEventAjaxProp(this.getParent('tr'), this.checked);
				})
				chkLbl.addEvent('click', function(e){
					e.stop();
					chk.checked = !chk.checked;			
					chk.fireEvent('change');
				})
			}
		}
		
		div.inject(td);
		td.inject(tr);
		tr.inject(tbody);
	}

	//Se inicializa el nuevo evento
	if (initializeEvent) {
		var evt = new ApiaEvent(evtId, evtName);
		evt.order = tr.getRowId();
		evt.class_id = id;
		evt.class_name = name;
		if (haveAjaxProp) evt.ajax = isAjax!=false;  
		currentEvents.push(evt);
	}	
	
	initTable(tbody);
	
	//--Scroll
	addScrollTable(tbody);
	
	if (selectRow){ tr.fireEvent('click'); }
}

function loadBCParameters(trId, clsId){
	$('tableDataBCParams').empty();
	
	var request = new Request({
		method: 'get',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getBusClassBindingsList' + TAB_ID_REQUEST + '&clsId=' + clsId,
		onSuccess: function(resText, resXml) {
			var values = resXml.getElementsByTagName('value');
			if (values){
				for(var i=0; i<values.length; i++){
					var id, inout, type, param, desc;
					
					var levels=values[i].getElementsByTagName('level');
					if (levels){
						for(var l=0; l<levels.length; l++){
							switch(levels[l].getAttribute('name')){
							case "id": id=levels[l].getAttribute('value'); break;
							case "inout": inout=levels[l].getAttribute('value'); break;
							case "type": type=levels[l].getAttribute('value'); break;
							case "param": param=levels[l].getAttribute('value'); break;
							case "desc": desc=levels[l].getAttribute('value'); break;
							}
						}
					}
					
					var evt = currentEvents[trId];
					var bnd = getEventBinding(evt, id);
					if (!bnd){
						bnd = new ApiaEventBinding(id, param, type, 'V');
						bnd.param_desc=desc;
						evt.bindings.push(bnd);
					}
					
					addParameterRow(inout, bnd);
				}
				
				//Ajuste visual con scroll
				var tbodyContainer = $('tableDataBCParams').getParent('div');
				if (tbodyContainer.getElement('div.scroll-background')){
					$('tableDataBCParams').getElements('tr').each(function(tr){
						var lastTd = tr.getLast();
						lastTd.setStyle('padding-right', '15px');
						
						var icon = lastTd.getElement('.icon-container');
						if (icon) { icon.setStyle('right','15px'); }
					})
				}
			}
		}
	}).send();
}

function addParameterRow(inout, bnd){
	var tbody = $('tableDataBCParams');
	
	var tr = new Element('tr');	
	tr.getId = function () { return this.getAttribute("data-id"); };
	tr.setId = function (id) { this.setAttribute("data-id",id); };
	tr.setId(bnd.param_id);
	
	if(tbody.rows.length%2==0) tr.addClass("trOdd");
		
	var inputValue, lblInput, lblCmb, lblAtt, cmbType;
	var divInput, divAttModal;

	
	for (var i=0; i<6; i++){
		var td = new Element('td', {width: tdWidthsParams[i]});
		var div = new Element('div', {styles: {width: '100%', 'height': '17px', overflow: 'hidden', 'white-space': 'pre'}});

		if (i==0){//In-Out
			div.setStyle('text-align', 'center');
			
			switch(inout){
			case 'In' : new Element('img.icon-container-full',{src:"../img/paramIn.png"}).inject(div); break;
			case 'In/Out' : new Element('img.icon-container-full',{src:"../img/paramInOut.png"}).inject(div); break;
			case 'Out' : new Element('img.icon-container-full',{src:"../img/paramOut.png"}).inject(div); break;
			};
			
		} else if (i==1){//Tipo
			div.setStyle('text-align', 'center');			
			switch(bnd.param_type){
			case 'S' : new Element('img.icon-container-full',{src:"../img/stringIcon.png"}).inject(div); break;
			case 'N' : new Element('img.icon-container-full',{src:"../img/numericIcon.png"}).inject(div); break;
			case 'D' : new Element('img.icon-container-full',{src:"../img/dateIcon.png"}).inject(div); break;
			case 'I' : new Element('img.icon-container-full',{src:"../img/integerIcon.png"}).inject(div); break;
			}		
		} else if (i==2){//Nombre
			var span = new Element('span', {'html': bnd.param_name}).inject(div);
		} else if (i==3){//Descripción
			div.setStyle('text-overflow','ellipsis');
			var span = new Element('span', {title:bnd.param_desc, 'html': bnd.param_desc}).inject(div);
		} else if (i==4){//Tipo Valor
			cmbType = cmbTypeParams.clone().inject(div);
			cmbType.hide();		
			
			var currentValueType = "";
			switch(bnd.att_type){
			case 'V' : cmbType.selectedIndex=0; break;
			case 'E' : cmbType.selectedIndex=1; break;
			case 'P' : cmbType.selectedIndex=2; break;
			}
			currentValueType = cmbType.options[cmbType.selectedIndex].textContent;
			
			cmbType.addEvents({
				'blur': function(e){
					this.hide();
					lblCmb.show();
				},
				'change': function(e){
					lblCmb.innerHTML = this.options[this.selectedIndex].textContent;
					this.hide();
					lblCmb.show();
					
					switch(this.selectedIndex){
					case 0: bnd.att_type='V'; break;
					case 1: bnd.att_type='E'; break;
					case 2: bnd.att_type='P'; break;
					}
					
					if (bnd.att_type=="V"){
						divInput.show();
						divAttModal.hide();
					} else {
						divAttModal.show();
						divInput.hide();
					}
					
					//Se resetean valores
					bnd.reset();
					lblInput.textContent='';
					inputValue.value='';
					lblAtt.textContent='';
				}
			})
			
			lblCmb = new Element('div', {styles:{'cursor':'pointer'}, html: currentValueType})
				.addEvent('click', function(e){
					lblCmb.hide();			
					cmbType.show();
					cmbType.focus();				
				})	
				.inject(div);
			
		} else if (i==5){//Valor

			divInput=new Element('div').inject(div);
			divAttModal=new Element('div').inject(div);
			
			divInput.hide();
			divAttModal.hide();
			
			/* divInput */
			inputValue = new Element('input', {styles:{width:'96%'}, value:Generic.unespapeHTML(bnd.value)}).inject(divInput);
			inputValue.hide();
			
			lblInput = new Element('div.lbl-container', {title: Generic.unespapeHTML(bnd.value), html:bnd.value})
				.addEvent('click', function(e){
					lblInput.hide();			
					inputValue.show();
					
					inputValue.focus();
				})	
				.inject(divInput);
			
			inputValue.addEvents({
				'blur':  function(e){
					inputValue.hide();
					lblInput.show();
					var newValue = Generic.espapeHTML(inputValue.value);
					lblInput.innerHTML = newValue;
					lblInput.title = inputValue.value;
					bnd.value=newValue;
				}
			})
			/* Fin divInput */
			
			
			/* divAttModal */				
			lblAtt = new Element('div.lbl-container', {title: bnd.att_name,html:bnd.att_name,styles:{'margin-right': '20px'}})
				.inject(divAttModal);
			
			td.setStyle('position','relative');
			var iconContainer = new Element('div.icon-container',{styles:{'right':'5px'}}).inject(divAttModal);
			
			new Element('div.icon-item.search-icon')
				.addEvent('click', function(e){
					if (e) e.stop();
					
					var footerMask = new Mask(parent.ModalController.modals[0].modalWin.getElement('.modalBottomBar'));
					footerMask.show();
					
					openModal(ATTRIBUTES_MODAL, null, 60, 65, 
						function(attInfo){//Confirm
							if (!attInfo) return;
							var attId=attInfo[0], attName=attInfo[1], attLabel=attInfo[2];
														
							lblAtt.textContent = attName;
							lblAtt.title = attName;
							bnd.att_id=attId;
							bnd.att_name=attName;
							bnd.att_label=attLabel;
							
							footerMask.destroy();
						}, 
						function(){//Close
							footerMask.destroy();
						}
					)
				})
				.inject(iconContainer);
			/* Fin divAttModal */
			
			
			if (bnd.att_type=="V" || bnd.att_type=="null"){
				divInput.show();	
			} else {
				divAttModal.show();
			}
		}
		
		div.inject(td);
		td.inject(tr);
		tr.inject(tbody);
	}
	
	//--Scroll
	addScrollTable(tbody);	
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

/* Funciones sobre variable de eventos */
function updateEventAjaxProp(tr, ajaxPropValue){
	currentEvents.each(function(evt){
		if (evt.class_id==tr.getId() && evt.order==tr.getRowId()){
			evt.ajax=ajaxPropValue;
		}
	})
}

function removeApiaEvent(tr){
	var tbody = $('tableDataBC');
	
	var found=false;
	for (var i = 0; i<tbody.rows.length; i++){		
		if (found){
			var evt = currentEvents[i-1];
			evt.order = (Number.from(evt.order)-1).toString();
			tbody.rows[i].setRowId(evt.order);
		} else{
			var evt = currentEvents[i];
			if (evt.class_id==tr.getId() && i==tr.getRowId()){		
				currentEvents.splice(i, 1);
				found=true;
			}
		}
	}
}

function getEventBinding(event, paramId){
	if (event && event.bindings){
		for(var i=0; i<event.bindings.length; i++){
			if (event.bindings[i].param_id==paramId){
				var bnd = new ApiaEventBinding();
				bnd.initializeFromObject(event.bindings[i]);
				event.bindings[i]=bnd;
				return bnd;
			}
		}
	}
	return null;
}

