var Property = new Class({
	name 	: null,
	label	: null,
	type 	: null,
	datatype: null,
	value	: null,
	prpId	: null,
	prpType	: null,
	values 	: [],
	
	/*Opcional: usado para información de selección de modal*/
	dataId : null,
	
	/*Opcionales: usados por eventos*/
	events	: [],
	evtName	: null,
	evtId	: null,
	
	/*Opcionales: usados para binding de entidades */
	entityBinding : null
})

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

var ApiaEntityBinding = new Class({
	entityId	: null,
	entityName	: null,
	entityTitle	: null,
	attId		: null,
	mappings 	: [],
	
	initialize  : function(entityId, entityName, entityTitle, attId){
		this.entityId=entityId;
		this.entityName=entityName;
		this.entityTitle=entityTitle;
		this.attId=attId;
	}
})

var ApiaEntityMapping = new Class({
	ent_att	: null,
	frm_att	: null,
	att_name: null,
	
	initialize  : function(ent_att, frm_att, att_name){
		this.ent_att=ent_att;
		this.frm_att=frm_att;
		this.att_name=att_name;
	}
})




/*
 * var fieldProperties = {
 *	'INPUT' : [{
 *		groupName : "",
 *		properties: [Properties],
 *
 *		//Optional
 *		busEntId: '' ~> binding
 *	}]
 *	...
 *}
*/
var fieldProperties = {}

//Usada para compartir información con modales
var currentFieldProperty = null;

//Se mantiena para cada entidad consultada, lista de atributos usados en combobox para binding
var entBindingAttributes = { /* key: busEntId, value: [attribute List] */ }

//Se mantiene referencia al scroll de la tabla de propiedades
var propertiesScroller;

function initFormProperties(){
	var request = new Request({
		method: 'get',
		url: 'page/design/forms/formsDesigner/bin/element_attributes.jsp?' + TAB_ID_REQUEST,
		onSuccess: function(resText, resXml) {
			if (!resXml) return;
			var elements = resXml.getElementsByTagName('element');

			for(var i=0; i<elements.length; i++) {
				var ele = elements[i];				
				var currentEle = [];
				var groups = ele.getElementsByTagName('attGroup');
				if (!groups) continue;
				
				for(var j=0; j<groups.length; j++){
					var group = groups[j];
					
					var currentGroup = {
						'groupName':group.getAttribute('name'),
						'properties':[]
					} 
					currentEle.push(currentGroup);

					var attributes = group.getElementsByTagName('attribute');
					if (!attributes) continue;
					
					for(var k=0; k<attributes.length; k++){
						var att = attributes[k];
						processAttribute(att, currentGroup);
					}
				}
				
				if (!fieldProperties) fieldProperties = {};
				fieldProperties[getFieldIdByName(ele.getAttribute('name'))]=currentEle;
			}
			
			initPropsTabModeAction();

			formProperties = fieldProperties[TYPE_FORM].clone();
			
			loadForm($('txtMap'));
			
			spDesigner.hide();
		}
	}).send();
}


function processAttribute(attribute, group){
	if (!attribute) return;

	var prop = new Property();	
	var tags = ['name', 'label', 'type', 'value', 'prpId', 'prpType', 'datatype', 'only_for_grid', 'evtName', 'evtId'];
	
	for(var i=0; i<tags.length; i++){
		var tag = tags[i];		
		var ele = attribute.getAttribute(tag);
		if (ele){
			prop[tag] = ele;	
		}
	}
	
	var values = attribute.getElementsByTagName('value');
	if (values){
		var attValues=[]
		for (var i=0; i<values.length; i++){
			var current = values[i];
			
			var info = {};
			['value', 'label', 'not_for_grid'].each(function(tag){
				var ele=current.getAttribute(tag);
				if (ele){
					info[tag] = ele;
				}	
			})
			attValues.push(info);
		}
		prop.values = attValues;
	}
	
	group.properties.push(prop);
}


function loadProperties(cell, dontAvoidSetScroll, scrollToProperty, dontAvoidScroll){
	var tBody = getPropsTable();
	var grid= tBody.getParent('#gridBody');
	var scrollToPropertyTR;
	
	var widths=[];
	grid.getElements('th').each(function(th){
		var w = th.getAttribute('width');
		if (w.indexOf('px')==-1){
			w+='px';
		}		
		widths.push(w);
	})
	
	tBody.empty();
	//Se resetean validaciones
	frmValidator.validations.empty();
	
	if (cell==null){//Form properties
		var groups = formProperties;
	} else {
		var groups = cell.field.properties;
	}
	
	for (var i=0; i<groups.length; i++){
		var group = groups[i];
		var tr = new Element('tr.groupTR').inject(tBody);
		
		var label = new Element('div',{html:group.groupName});
		label.inject(new Element('td',{'colspan':'2'}).inject(tr));
		
		var properties = group.properties;
		var isOdd=true;
		for (var j=0; j<properties.length; j++){
			var property = properties[j];
			
			if (!property.only_for_grid || cell.isTableElement){
				var tr = new Element('tr.selectableTR').inject(tBody);
				if (isOdd) tr.addClass('trOdd');
				isOdd = isOdd==false;
				
				var label = new Element('div',{html:property.label, styles:{'min-height': '17px', 'word-wrap': 'break-word', 'width':widths[0]}});
				label.inject(new Element('td').inject(tr));

				var tdType = new Element('td').inject(tr);
				var divContainer = new Element('div',{styles:{'width':widths[1]}}).inject(tdType);
				loadPropertyType(property, divContainer, cell);
				
				if (scrollToProperty && isSameProperty(scrollToProperty, property)){ 
					scrollToPropertyTR = tr; }
				
			}
		}
	}
	//--Scroll
	if (!dontAvoidScroll){
		if (dontAvoidSetScroll){
			propertiesScroller = addScrollTable(tBody, false /*avoidSetScroll*/, true /*clearAllEvents*/);	
		} else {
			propertiesScroller = addScrollTable(tBody, true /*avoidSetScroll*/, true /*clearAllEvents*/);
		}	
	}
	
	if (scrollToPropertyTR && propertiesScroller.v){
		propertiesScroller.v.showTrElement(scrollToPropertyTR,25);
	}
}

function loadPropertyType(property, container, cell){
	if (!property || !container) return;
	
	var label, object, icons = [];
	var currentValue = property.value;
	
	switch(property.type){
	case 'combo':
		if (property.values){
			object = new Element('select',{styles:{width:'100%'}}).inject(container);
			var currentLabel = "";
			for (var v=0; v<property.values.length; v++){
				var current = property.values[v];
				if (current.not_for_grid=='true' && cell.isTableElement){ continue; }

				var option = new Element('option',{value:current.value, html:current.label}).inject(object);
				if (currentValue==current.value){
					currentLabel=current.label;
					option.selected=true;
				}
			}
			label = new Element('div', {html :currentLabel}).inject(container);
			
			object.hide();
			
			if (cell) cell.field.setPropertyValue(property.prpId, currentValue);
			
			object.addEvents({
				'blur': function(e){
					object.hide();
					label.show();
				},
				'change': function(e){
					if (this.options[this.selectedIndex].value!=currentValue){
						var selected=this.options[this.selectedIndex];
						
						storeUpdatePropertyAction(cell, property, {oldValue : property.value, newValue: selected.value}); 
						
						property.value=selected.value;
						label.innerHTML=selected.textContent;
						if (cell) cell.field.setPropertyValue(property.prpId, property.value);
						
						if (property.name=="type"){
							changeFieldType(cell, property.value);					
						}
					}
				}
			})
		}
		break;
		
	case 'text':
		object = new Element('input', {'maxlength': '255', styles:{width:'100%'}, 
			value: currentValue}).inject(container);
		if (property.prpType=='N' || property.datatype=='int'){
			object.addClass("validate['digit']");
			frmValidator.register(object);
		}
		object.hide();
		
		if (cell) cell.field.setPropertyValue(property.prpId, currentValue);
			
		var label = new Element('div.lbl-container', {title: currentValue, html:Generic.espapeHTML(currentValue)}).inject(container);
		object.addEvents({
			'blur':  function(e){
				if (frmValidator.isFormValid()){
					object.hide();
					
					var newValue = object.value;
					storeUpdatePropertyAction(cell, property, {oldValue : property.value, newValue: newValue});
					
					label.show();
					property.value = newValue;
					label.innerHTML = Generic.espapeHTML(newValue);
					label.title = object.value;
					if (cell) cell.field.setPropertyValue(property.prpId, property.value);
					
				}
			}
		})	
		
		break;
		
	case 'checkbox':
		container.addClass('checkbox-container');
		var chk = new Element('input',{type:'checkbox'}).inject(container);
		chk.checked=toBoolean(currentValue);
		var chkLbl = new Element('div.checkbok-label',{html: chk.checked? LBL_YES : LBL_NO}).inject(container);
		
		if (cell) cell.field.setPropertyValue(property.prpId, currentValue);
		
		chk.addEvents({
			'change':  function(e){	
				chkLbl.innerHTML = this.checked? LBL_YES : LBL_NO;
				
				storeUpdatePropertyAction(cell, property, {oldValue : property.value, newValue: this.checked.toString()});
				
				property.value = this.checked.toString();
				if (cell) cell.field.setPropertyValue(property.prpId, this.checked);
			}
		})
		chkLbl.addEvent('click', function(e){
			e.stop();
			chk.checked = !chk.checked;			
			chk.fireEvent('change');
		})
		break;
		
	case 'colorPicker':
		var isFontColorProp = property.prpId=='5';
		
		currentValue = currentValue? currentValue.toUpperCase() : '#000000';
		var colorLabel = new Element('div', {'class':'color-label', styles:{'background-color':currentValue}})
			.inject(container);
		var textLabel = new Element('div', {id : 'textLabel', html:currentValue, styles : {'width':'50px','float':'left'}})
			.inject(container);
		
		if (cell) cell.field.setPropertyValue(property.prpId, currentValue);
		
		var td = container.getParent('td');
		td.setStyle('position','relative');
		var paletteIconContainer = new Element('div.icon-container').inject(td);
		paletteIconContainer.setStyle('right', '42px');
		var removeIconContainer = new Element('div.icon-container').inject(td);
		
		icons[0] =new Element('div.icon-item.palette-icon').inject(paletteIconContainer);
				
		var rgb = hexToRgb(currentValue);
		var r = rgb != null ? rgb.r : 255;
		var g = rgb != null ? rgb.g : 0;
		var b = rgb != null ? rgb.b : 0;
		
		//Se elimina el picker anterior o de otras propiedades con mismo 'id'
		if ($('colorPicker'+property.prpId)){$('colorPicker'+property.prpId).dispose(); }
		
		property.picker = new MooRainbow(icons[0], {
			id: "colorPicker" + property.prpId,
			'startColor': [r, g, b],
			'imgPath': CONTEXT + '/js/colorpicker/images/',
			'onChange': function(color) {},
			'onComplete': function(color) {
				textLabel.innerHTML = color.hex.toUpperCase();
				colorLabel.setStyle('background-color', color.hex);
				
				storeUpdatePropertyAction(cell, property, {oldValue : property.value, newValue: textLabel.innerHTML});
				
				property.value=textLabel.innerHTML;				
				if (cell) cell.field.setPropertyValue(property.prpId, property.value);
			},
			'onCancel':function(color) { }
		});
				
		icons[1] = new Element('div.icon-item.remove-icon')
			.addEvent('click', function(e){
				if (e) e.stop();
				
				storeUpdatePropertyAction(cell, property, {oldValue : property.value, newValue: '#000000'});
				
				property.value = '#000000';
				textLabel.innerHTML = property.value;
				colorLabel.setStyle('background-color', property.value);
				property.picker.manualSet(property.value, 'hex');
				if (isFontColorProp) cell.field.setPropertyValue(property.prpId, property.value);
			})
			.inject(removeIconContainer);
		
		break;
		
	case 'modal':
		label = new Element('div.lbl-container.lbl-one-icon', {title:currentValue, html:currentValue}).inject(container);
		
		var td = container.getParent('td');
		td.setStyle('position','relative');
		var iconContainer = new Element('div.icon-container').inject(td);
		
		icons[0] = new Element('div.icon-item.search-icon')
			.addEvent('click', function(e){
				if (e) e.stop();
				
				if (property.name=="attr"){
					openModal(ATTRIBUTES_MODAL, null, 70, 75, function(attInfo){
						if(!attInfo) return;
						
						var oldCellField = cell.field.clone();
						var attId=attInfo[0], attName=attInfo[1], attLabel=attInfo[2];						
						cell.setAttribute(attId, attName, attLabel);
						
						var newCellField = cell.field.clone();
						storeUpdatePropertyAction(cell, property, {oldValue: oldCellField, newValue: newCellField})
					})
				} else if (property.name=="prpChildOrder"){
					currentFieldProperty = cell.isTableElement? cell.field.tableCell : cell;
					var tableCellField = currentFieldProperty.field;
					
					//Solo se abre modal si tiene elementos
					if (tableCellField.tableElements.length>0){
						openModal(TABLE_FLDS_SORT_MODAL, null, 55, '215px', function(tableOrder){
							if (!tableOrder) return;
							//Se retorna un array con el nuevo order.
							
							//Se obtiene el order original para aplicar undo
							var reverseOrder = tableOrder.map(function(ele, idx){
								return tableOrder.indexOf(idx.toString()).toString();
							})
							storeUpdatePropertyAction(cell, property, {oldValue : reverseOrder, newValue: tableOrder});
													
							sortTableElements(tableOrder, tableCellField);
							
							currentFieldProperty.fireEvent('click');
						})	
					}
				}
			})
			.inject(iconContainer);
		break;
		
	case 'modalErase':
		label = new Element('div.lbl-container.lbl-two-icons', {html:currentValue, title:currentValue}).inject(container);
		
		var td = container.getParent('td');
		td.setStyle('position','relative');
		var searchIconContainer = new Element('div.icon-container').inject(td);
		searchIconContainer.setStyle('right', '42px');
		var removeIconContainer = new Element('div.icon-container').inject(td);
		
		icons[0] = new Element('div.icon-item.search-icon')
			.addEvent('click', function(e){
				if (e) e.stop();

				if (property.name=="prpModal" || property.name=="prpEntity" || property.name=="prpDocType" ||
						property.name=="prpImg" || property.name=="prpParentIcon" || property.name=="prpLeafIcon" ||
						property.name=="entBinding" || property.name=="prpEditForm" || property.name=="prpQry"){
					
					var addParams = '&mdlType=' + property.prpId;
					if (cell.field.fieldType==TYPE_TREE) addParams += '&flagParam=6'; /* FLAG_IS_TREE_NODE */;
					if (property.name=="prpEditForm") addParams += '&flagPaging=true';
					
					openModal(MDL_DATA_MODAL, addParams, 60, 65, function(mdlDataInfo){
						if (!mdlDataInfo) return;
					
						var id = mdlDataInfo.id;
						var name = mdlDataInfo.name;

						storeUpdatePropertyAction(cell, property, {oldValue: property.value, newValue: name, dataId: id});
						
						label.title = name;
						label.innerHTML = name;
						property.value = name;
						property.dataId = id;

						if (property.name=="entBinding"){
							loadEntBindingAttributes(id, cell);
						}
					})
				}
			})
			.inject(searchIconContainer);
				
		icons[1] = new Element('div.icon-item.remove-icon')
			.addEvent('click', function(e){
				if (e) e.stop();
				
				storeUpdatePropertyAction(cell, property, {oldValue: property.value, newValue: null, dataId: property.dataId});
				
				label.innerHTML = null;
				property.value = null;
				property.dataId = null;
				
				if (property.name=="entBinding"){							
					//Se eliminan propiedades asociadas a atributos para binding					
					var bndGroup = findGroupPropertiesByName(cell.field.properties, "Binding");
					bndGroup.busEntId=null;
					bndGroup.properties.splice(1,bndGroup.properties.length-1);
					
					loadProperties(cell, true);
				}
			})
			.inject(removeIconContainer);
		
		break;
	
	case 'modalArray':
		label = new Element('div.lbl-container.lbl-one-icon').inject(container);
		
		//Se determina valor actual
		if (property.events.length>0){
			var classes=[];
			property.events.each(function(evt){
				classes.push(evt.class_name);
			})
			label.innerHTML = "[" + classes.join(', ') + "]";						
		} else {
			label.title = "";
		}
		label.title = label.innerHTML;

		var td = container.getParent('td');
		td.setStyle('position','relative');
		var iconContainer = new Element('div.icon-container').inject(td);
				
		icons[0] = new Element('div.icon-item.search-icon')
			.addEvent('click', function(e){
				if (e) e.stop();
												
				currentFieldProperty = JSON.stringify(property);
				var addParams = '&isFormProp=' + !cell + '&evtLabel=' + property.label;
				
				openModal(BUS_CLA_MODAL, addParams, 70, 75, function(events){					
					if (!events) return;
				
					storeUpdatePropertyAction(cell, property, {oldValue: property.events, newValue: JSON.parse(events)});
					
					//Se actualizan events de celda actual
					property.events = JSON.parse(events);
					currentFieldProperty = null;
					
					if (property.events.length>0){
						var classes=[];
						property.events.each(function(evt){
							classes.push(evt.class_name);
						})
						label.innerHTML = "[" + classes.join(', ') + "]";						
					} else {
						label.innerHTML = "";
					}
					label.title = label.innerHTML;
				})
				
			}).inject(iconContainer);
		break;
		

	default:
		console.log(property.type);
	}
	
	if (label && object){
		label.addEvent('click', function(e){
			label.hide();			
			object.show();
			object.focus();				
		})		
	}
	
	if (icons && icons.length>0){
		icons.each(function(i){ setSelectIconAction(i); })
	}
}

function openModal(modalUrl, addParams, width, height, confirmCallback, closeCallback){
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
		.openWinModal(url, width, height, undefined, undefined, false, false, false)
		.setCloseLabel(LBL_CLOSE)
		.addEvent('confirm', confirmCallback);
	
	mdlController.modalWin.addEvent('customConfirm', function(params){
		this.fireEvent('confirm', params);
		this.closeModal();
	}.bind(mdlController));
		
	if (closeCallback)	mdlController.addEvent('close', closeCallback);
}

function findPropertyByName(properties, name, evtId){
	if (!properties) return;
	
	var filtered;
	properties.some(function(grp){
		if (grp.properties){
			filtered = grp.properties.filter(function(prp){
				if (evtId){
					if (prp.evtId==evtId){ return prp; }					
				} else if (prp.name==name){
					return prp;
				}
			})
			if (filtered && filtered.length>0) return true;
		}		
	})
	return filtered? filtered[0] : null;
}

function findEventPropertyById(properties, evtId){
	if (!properties) return;
	
	var filtered;
	properties.some(function(grp){
		if (grp.properties){
			filtered = grp.properties.filter(function(prp){
				if (prp.evtId && prp.evtId==evtId){
					return prp;
				}
			})
			if (filtered && filtered.length>0) return true;
		}		
	})
	return filtered? filtered[0] : null;
}

function findGroupPropertiesByName(properties, name){
	if (!properties) return;
	
	var filtered;
	properties.some(function(grp){
		if (grp.groupName==name){
			filtered = grp;
			return true;
		}		
	})
	return filtered;
}

function setSelectIconAction(icon){
	if (!icon) return;
	
	icon.addEvents({
		'mousedown': function(e){ this.addClass('icon-selected'); },
		'mouseup': function(e){ this.removeClass('icon-selected'); },
		'mouseout': function(e){ this.removeClass('icon-selected'); },
	})
}

function loadEntBindingAttributes(busEntId, cell, dontReloadProperties, onCompleteFunction){
	//Si ya existe información en memoria, se utiliza
	if (entBindingAttributes[busEntId]){
		checkCellProperties(cell, busEntId, dontReloadProperties);
		if (onCompleteFunction) onCompleteFunction();
		
	} else {
		var request = new Request({
			method: 'get',
			data : {busEntId : busEntId},
			url: CONTEXT + URL_REQUEST_AJAX + '?action=getEntitiesAttList' + TAB_ID_REQUEST,
			onSuccess: function(resText, resXml) {
				var values = [{value:"-1", label:""}];
				
				var valuesXml = resXml.getElementsByTagName('value');
				if (valuesXml){
					for(var i=0; i<valuesXml.length; i++){					
						var lvls = valuesXml[i].getElementsByTagName('level')
						var info = {};
						for (var j=0; j<lvls.length; j++){
							if (lvls[j].getAttribute('name')=='id'){
								info.value = lvls[j].getAttribute('value');
							} else if (lvls[j].getAttribute('name')=='label'){
								info.label = lvls[j].getAttribute('value');
							}
						}					
						values.push(info);
					}
					
					entBindingAttributes[busEntId] = values;
				}
				
				checkCellProperties(cell, busEntId, dontReloadProperties);
				
				if (onCompleteFunction) onCompleteFunction();
			}
		}).send();		
	}
}

/* Se verifica si es necesario agregar propiedades asociadas a atributos para binding
 * Luego por defecto se recarga todas las propiedades 
 */
function checkCellProperties(cell, busEntId, dontReloadProperties){
	//Se deshabilita toolbar 'More'
	$('moreToolbarItem').fireEvent('close');
	
	var modifyProps = false;
	
	//Se verifica caso de bindings
	var bndGroup = findGroupPropertiesByName(cell.field.properties, "Binding");
	if (bndGroup){
		if (!busEntId) {
			busEntId=bndGroup.busEntId;
		} else {
			if (bndGroup.busEntId!=busEntId){
				bndGroup.busEntId=busEntId;
				//Se mantiene solo propiedades fijas
				bndGroup.properties.splice(1,bndGroup.properties.length-1);
			}
		}	
	}	
	
	if (!busEntId) {
		if (!dontReloadProperties) { loadProperties(cell); }
		return;
	}
	
	var attsCount=0;
	gridSchema.each(function(ele){
		//Se filtro aquellos fields con atributos
		if (bndGroup && ele != cell && ele.field.attId && ele.field.fieldType!=TYPE_HIDDEN){
			attsCount++;
			
			var filtered = bndGroup.properties.filter(function(p){
				if (p.entityBinding && p.entityBinding.attId == ele.field.attId){
					return p;
				}
			})

			if (filtered.length==0){
				modifyProps=true;
				
				var prop = new Property();
				prop.type='combo';
				prop.label=ele.field.fieldLabel;
				prop.entityBinding = new ApiaEntityBinding(busEntId, null, null, ele.field.attId);	
				prop.values = entBindingAttributes[busEntId];
				
				//Si existe algún cambio, se actualiza (si es necesario se reemplaza)
				var current = bndGroup.properties[attsCount];
				if (current) { delete current; }				
				bndGroup.properties[attsCount]=prop;
			} else {
				//Se actualiza posición si corresponde (control para cuando se borran atributos)
				bndGroup.properties[attsCount]=filtered[0];
			}
		}
	})
	
	//Control para cuando se borran atributos
	if (bndGroup && attsCount < bndGroup.properties.length-1){
		bndGroup.properties.splice(1+attsCount,bndGroup.properties.length-1);
	}
	
	//Si se agrega alguna propiedad, se recarga tabla
	if (modifyProps && !dontReloadProperties){ loadProperties(cell, true); }
	
}

//Se carga el formulario con información traída desde el servidor
function loadForm(strForm){
	var xmlForm;
	
	//Se carga el formulario como xml
	if(strForm && strForm.value!='') {
		//Obtener el xml del textarea		
		if (window.DOMParser) {
			var parser = new DOMParser();
			xmlForm = parser.parseFromString(strForm.value,"text/xml");
		} else {
			// Internet Explorer
			xmlForm = new ActiveXObject("Microsoft.XMLDOM");
			xmlForm.async = false;
			xmlForm.loadXML(strForm.value); 
		}
	} else {
		//Caso formulario vacío
		loadProperties(null);
		return;
	}
	
	if (!xmlForm) return;
		
	var formProps = getPropertiesFromXML(xmlForm, 'FORM_PROPERTY');
	var fields = xmlForm.getElementsByTagName('FORM_FIELD');

	/* Se actualiza dimensiones del grid */
	updateGridDimensions(formProps['79'], formProps['80'], fields);
	/* ******************************** */
	
	//Se setean valores de propiedades del form
	formProperties.each(function(grp){
		grp.properties.each(function(fProp){				
			var prp = formProps[fProp.prpId];
			if (prp){
				fProp.value=prp.value;
			}
		})
	})
	
	//Se cargan los eventos del form
	loadEventProperties(xmlForm.firstChild, formProperties);
	
	//Se cargan todos los field del form
	var bindingInfo = [];
	for (var i=0; i<fields.length; i++){
		var f=fields[i];		
		var x = Number.from(f.getAttribute('x')) + 1;
		var y = Number.from(f.getAttribute('y')) + 1;
		var fieldId	= f.getAttribute('fieldId');
		var fieldType = f.getAttribute('fieldType');
		var mins = getMinFieldSize(fieldType);
		
		var props = getPropertiesFromXML(f, 'PROPERTY', true);
		var size = {
			xSize : props['8']? Number.from(props['8'].value) : mins[0],
			ySize : props['9']? Number.from(props['9'].value) : mins[1]
		}
		
		var cellInfo = gridInfo[y][x];
		cellInfo.isEmpty = false;
		cellInfo.cell.element.addClass('cell-with-data');
		
		cellInfo.cell.makeResizable(fieldId, fieldType, droppableElements, size);
		makeDraggableInstances(cellInfo.cell.element.getElement('.cell-container'), true /*moveElement*/);
		
		updateGridSchema(cellInfo.cell, false /*add*/, null, true);
		
		loadFieldProperties(f, cellInfo.cell, props, bindingInfo);
		
		if (fieldType == TYPE_GRID){
			var fChildren = f.getElementsByTagName('FORM_FIELD_CHILD'), children = [];
			for (var k = 0; k < fChildren.length; k++) { children.push(fChildren[k]); }			

			children.sort(function(a, b) {
				if (Number.from(a.getAttribute('x')) > Number.from(b.getAttribute('x'))) return 1; 
				if (Number.from(a.getAttribute('x')) < Number.from(b.getAttribute('x'))) return -1;
				return 0;
			});
			
			for (var j=0; j<children.length; j++){
				var c=children[j];		
				var x = Number.from(c.getAttribute('x')) - 1;
				var fieldId	= c.getAttribute('fieldId');
				var fieldType = c.getAttribute('fieldType');
				
				var tableCell = cellInfo.cell.addElementToTable(fieldType, fieldId);
				tableCell.setX(x);
				updateGridSchema(tableCell, false /*add*/, null, true);
				
				var childProps = getPropertiesFromXML(c, 'PROPERTY', true);
				loadFieldProperties(c, tableCell, childProps, bindingInfo);
				
			}			
		}		
	}	
	
	/*
	 * Se carga información de bindings.
	 * Se realiza al final ya que todos los atributos fueron cargados
	 */
	bindingInfo.each(function(bnd){
		//Se cargan propiedades de atributos para binding a cada celda que corresponda
		loadEntBindingAttributes(bnd.entBinding.entityId, bnd.cell, false /*dontReloadProperties*/,
			function(){
				var bndGroup = findGroupPropertiesByName(bnd.cell.field.properties, "Binding");
				if (bndGroup){
					bndGroup.properties[0].value=bnd.entBinding.entityName;
					
					var mappings=bnd.entBinding.mappings;
					if (!mappings || mappings<=0) return;
					
					//Se recorre todos los atributos en busca de mapping
					for(var i=1; i<bndGroup.properties.length; i++){
						var prop=bndGroup.properties[i];
						
						//Se busca el atributo actual
						var entMap = mappings.filter(function(m){
							if (m.frm_att==prop.entityBinding.attId){
								return m;
							}
						})
						if (entMap && entMap.length>0){
							bnd.cell.element.addClass('cell-with-binding');
							prop.value=entMap[0].ent_att;
						}
					}	
				}
				
				//Se deseleccionan las celdas
				clearAllSelectedCells();
		});
	})
	
	clearAllSelectedCells();
}

function loadEventProperties(xml, properties){
	var events = []
	try {
		for(var i=0; i< xml.childNodes.length; i++){
			var evts=xml.childNodes[i];
			if (evts.tagName=='EVENTS'){
				events = evts.getElementsByTagName('EVENT');
				break;
			}
		}
	} catch (err){}

	var eventsInfo = {};
	for (var j=0; j<events.length; j++){
		var e = events[j];
		var evt = new ApiaEvent();		
		loadFromElementAttributes(evt, e, ['event_id','event_name','order','class_id','class_name','skip_cond','bnd_id']);
		if (e.getAttribute('ajax')) evt.ajax = toBoolean(e.getAttribute('ajax'));
		
		var bindings = e.getElementsByTagName('BINDING');
		for (var k=0; k<bindings.length; k++){
			var b = bindings[k];
			var bnd = new ApiaEventBinding();
			loadFromElementAttributes(bnd, b, ['param_id','param_name','param_type','att_id','att_type','att_label','att_name']);
			if (bnd.att_type=='V') bnd.value = b.textContent; 
			
			evt.bindings.push(bnd);
		}
		
		if (!eventsInfo[evt.event_id]){
			eventsInfo[evt.event_id] = findEventPropertyById(properties, evt.event_id);
		}
		if (eventsInfo[evt.event_id]){
			eventsInfo[evt.event_id].events.push(evt);
		}
	}
	
	//Se ordenan eventos según el valor de 'order'
	Object.keys(eventsInfo).each(function(key){
		eventsInfo[key].events.sort(function(a, b) {
			if (Number.from(a.order) > Number.from(b.order)) return 1; 
			if (Number.from(a.order) < Number.from(b.order)) return -1;
			return 0;
		});
	})
}

function getPropertiesFromXML(xml, tag, onlySearchFirstLevel){
	var props = {};
	var propList = [];
	
	if (onlySearchFirstLevel){
		var children = xml.childNodes;
		for(var i=0; i< children.length; i++){
			if (children[i].tagName == tag){ propList.push(children[i]); }
		}		
	} else {
		propList = xml.getElementsByTagName(tag);
	}
	
	if (propList){
		for (var p=0; p<propList.length; p++){
			var prop=propList[p];
			props[prop.getAttribute('prpId')] = {
				value : prop.getAttribute('value'),
				dataId : prop.getAttribute('dataId'),
				type : prop.getAttribute('type')
			}
		}		
	}
	
	return props;
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

//Se genera XML del formulario para ser enviado al servidor
function getModelLayout(){
	var layout = document.implementation.createDocument(null, "FORM_LAYOUT", null).documentElement;

	//Se recorren todos los elementos agregados al grid
	var i=0;
	while (i<gridSchema.length){
		var cell = gridSchema[i];
	
		var field = document.createElementNS(null, "FORM_FIELD");
		loadFromObjectAttributes(cell.field, field, ['fieldId','fieldType','fieldLabel','attId','attName'])
				
		//Propiedades fijas: tamaño y ubicación de celda
		field.setAttribute('x', cell.x-1); 
		field.setAttribute('y', cell.y-1);
				
		if (cell.xSize>1) {
			var property = document.createElementNS(null, "PROPERTY");
			property.setAttribute('type','N');
			property.setAttribute('prpId','8');
			property.setAttribute('value', cell.xSize); 
			field.appendChild(property);
		}
		if (cell.ySize>1) {
			var property = document.createElementNS(null, "PROPERTY");
			property.setAttribute('type','N');
			property.setAttribute('prpId','9');
			property.setAttribute('value', cell.ySize); 
			field.appendChild(property); 
		}
		// *********************************************
		
		//Se procesan todas las propiedades asociadas a la celda		
		processProperties(cell.field.properties, field, false /*isFormProperty*/);
		
		//Caso que la celda se un elemento 'Table' se procesan celdas contenidas
		if (cell.isTable()){
			var children = cell.field.tableElements;
			for (var j=0; j<children.length; j++){
				var child = document.createElementNS(null, "FORM_FIELD_CHILD");
				loadFromObjectAttributes(children[j].field, child, ['fieldId','fieldType','fieldLabel','attId','attName'])
				child.setAttribute('x', children[j].x+1);
				child.setAttribute('y', 0);
				
				//Se procesan todas las propiedades asociadas a la celda		
				processProperties(children[j].field.properties, child, false /*isFormProperty*/);
				
				field.appendChild(child);
			}
			
			i+= 1+children.length;
			
		} else {
			i++;
		}
		
		layout.appendChild(field);
	}
	
	
	//Propiedades fijas: cantidad de filas y columnas
	var property = document.createElementNS(null, "FORM_PROPERTY");
	property.setAttribute('type','N');
	property.setAttribute('prpId','79');
	property.setAttribute('value', cols); 
	layout.appendChild(property);

	var property = document.createElementNS(null, "FORM_PROPERTY");
	property.setAttribute('type','N');
	property.setAttribute('prpId','80');
	property.setAttribute('value', rows); 
	layout.appendChild(property);
	// *********************************************
	
	//Se procesan todas las propiedades asociadas al formulario
	processProperties(formProperties, layout, true /*isFormProperty*/);
	
	if(window.XMLSerializer) {
		return new XMLSerializer().serializeToString(layout);
	} else {
		return layout.xml;
	}
}

function processProperties(properties, element, isFormProperty){
	
	var events = document.createElementNS(null, "EVENTS");
	var entBinding = null;
	
	properties.each(function(grp){
		grp.properties.each(function(prp){
			if (prp.evtId){
				 //Si está asociada a un evento, se determina cada uno 
				 //incluyendo bindings con parámetros
				prp.events.each(function(evt){
					var event = document.createElementNS(null, "EVENT");
					loadFromObjectAttributes(evt, event, 
							['event_id','event_name','order','class_id','class_name','bnd_id','skip_cond','ajax']);
											
					evt.bindings.each(function(bnd){
						var binding = document.createElementNS(null, "BINDING");
						loadFromObjectAttributes(bnd, binding, 
								['param_id','param_name','order','param_type','att_type','att_id','att_name']);
						if (bnd.att_type=='V' && bnd.value) { binding.textContent = bnd.value; }
						
						event.appendChild(binding);
					})

					events.appendChild(event);
				})

			} else if (prp.entityBinding){
				//Se controla que exista mapeo de atributos
				if (!isFormProperty && prp.value){
					if (!entBinding){
						entBinding = document.createElementNS(null, "ENTITY_BINDING");
						entBinding.setAttribute('entityId', prp.entityBinding.entityId);
					}
					
					var mapping = document.createElementNS(null, "MAPPING");
					mapping.setAttribute('ent_att', prp.value);
					mapping.setAttribute('frm_att', prp.entityBinding.attId);
					entBinding.appendChild(mapping);	
				}
			} else if (prp.prpId && prp.prpType && prp.value){
				var property = document.createElementNS(null, (isFormProperty?'FORM_':'')+"PROPERTY");
				loadFromObjectAttributes(prp, property, ['prpId','value','dataId']);
				property.setAttribute('type', prp.prpType);
				
				//Si es de tipo checkbox y es false, no se agrega
				//En todos los otros casos, se agrega
				if (prp.type!='checkbox' || toBoolean(prp.value)){
					element.appendChild(property);	
				}						
			}
		})
	})
	
	//Si existen eventos, se agregan
	if (events.childElementCount>0){ element.appendChild(events); }
	
	//Si existe binding con entidades, se agrega
	if (!isFormProperty && entBinding){ element.appendChild(entBinding); }
	
}


/*
 * Se carga en la celda la información obtenida de element: propiedades, eventos y bindings
 */
function loadFieldProperties(element, cell, props, bindingInfo){
	//Se setea el atributo
	if (element.getAttribute('attId') && element.getAttribute('attId')!='0'){
		cell.setAttribute(element.getAttribute('attId'), element.getAttribute('attName'), element.getAttribute('fieldLabel'));
	}
	
	//Se setean valores de propiedades
	cell.field.properties.each(function(grp){
		grp.properties.each(function(fProp){
			var prp = props[fProp.prpId];
			if (prp){
				fProp.value=prp.value;
				fProp.dataId=prp.dataId;
				cell.field.setPropertyValue(fProp.prpId, prp.value);
			}
		})
	})
	
	//Se cargan los eventos de fields
	loadEventProperties(element, cell.field.properties);
	
	//Se guarda información de bindings
	var entBindingTag = element.getElementsByTagName('ENTITY_BINDING');
	if (entBindingTag && entBindingTag.length>0){
		var eBnd = entBindingTag[0];
		var entBinding = new ApiaEntityBinding();
		loadFromElementAttributes(entBinding, eBnd, ['entityId','entityName','entityTitle']);
		
		var mappings = eBnd.getElementsByTagName('MAPPING');
		if (mappings && mappings.length>0){
			for(var j=0; j<mappings.length; j++){
				var mEle = mappings[j];
				var entMapping = new ApiaEntityMapping();
				loadFromElementAttributes(entMapping, mEle, ['ent_att','frm_att','att_name']);
				entBinding.mappings.push(entMapping);
			}
		}
	
		bindingInfo.push({
			cell : cell,
			entBinding: entBinding
		})
	}
}

function sortTableElements(tableOrder, tableCellField){
	//La posición en el array representa la posición previa y el dato la nueva posición
	var prevTableElements = tableCellField.tableElements.slice();
	
	for (var i=0; i<tableOrder.length; i++){
		var from = tableOrder[i];
		var to = i;
			
		//dest[to] = source[from]
		var fromCell = prevTableElements[from];
		var toCell = tableCellField.tableElements[to];
		fromCell.moveCellFromTable(toCell, true /*avoidHistory*/);
	}
}

function copyProperties(source, destination, avoidProperties){
	for(var i=0; i<destination.length; i++){
		for(var j=0; j<destination[i].properties.length; j++){
			var prp = destination[i].properties[j];
			var property = findPropertyByName(source, prp.name, prp.evtId);
			if (property && !avoidProperties.contains(prp.name)){ 
				destination[i].properties[j] = property;
			}
		}
	}
}

function changeFieldType(cell, type, avoidLoadProperties){
	//Se actualiza field con el nuevo tipo
	switch(type){
	case '0': cell.field.fieldType = TYPE_INPUT; break;
	case '1': cell.field.fieldType = TYPE_SELECT; break;
	case '2': cell.field.fieldType = TYPE_CHECK; break;
	case '3': cell.field.fieldType = TYPE_RADIO; break;
	case '4': cell.field.fieldType = TYPE_HIDDEN; break;
	case '5': cell.field.fieldType = TYPE_PASSWORD; break;
	}

	cell.redrawField(null, true, true);
	updateGridSchemaLabel(cell);
	
	if (!avoidLoadProperties){ loadProperties(cell, true); }
}

function storeUpdatePropertyAction(cell, property, additional){
	var historyElement = { 
			action: UPDATE_PROPERTY_ACTION,
			property: property
	}
	if (cell){
		if (cell.isTableElement){
			var tableCell = cell.mainCell.field.tableCell;
			historyElement.source = {x:tableCell.x, y:tableCell.y};
			historyElement.tableElementPosition = tableCell.field.tableElements.indexOf(cell);
		} else {
			historyElement.source = {x:cell.x, y:cell.y};
		}	
	}
	storeAction(Object.append(historyElement, additional));
}

function hexToRgb(hex) {
    // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
    var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
    hex = hex.replace(shorthandRegex, function(m, r, g, b) {
        return r + r + g + g + b + b;
    });

    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}

function isSameProperty(p1, p2){
	if (!p1) return !p2;
	if (!p2) return !p1;
	
	if (p1.prpId==p2.prpId) return true;
	
	if (p1.name==p2.name){
		if (p1.evtId==p2.evtId || p1.name=='attr' || p1.name=='entBinding' ||
				p1.name=='prpChildOrder' || p1.name=='type'){
			return true;
		}
	}
	
	return false;
}

function updateGridDimensions(parCols, parRows, fields){
	//Se obtiene datos de propiedades de elementos
	var newCols = 0, newRows = 0;
	for (var i=0; i<fields.length; i++){
		var f=fields[i];
		var fieldType = f.getAttribute('fieldType');
		var mins = getMinFieldSize(fieldType);
		var x = Number.from(f.getAttribute('x')) + mins[0];
		if (x > newCols) newCols = x;
		var y = Number.from(f.getAttribute('y')) + mins[1];
		if (y > newRows) newRows = y;
	}
	
	//Se obtiene datos de parámetros
	if (parCols){
		var nCols = Number.from(parCols.value);
		if (nCols > newCols) newCols = nCols;		
	}
	
	if (parRows){
		var nRows = Number.from(parRows.value);
		if (nRows > newRows) newRows = nRows;
	}
	
	//Se actualiza si corresponde
	if (cols<newCols){
		for(var i=cols; cols<newCols; i++){ addColumn(1, true /*avoidHistory*/); }
		cols=newCols;		
		showTopOptions(true);	
	}
	
	if (rows<newRows){
		for(var i=rows; rows<newRows; i++){ addRow(1, true /*avoidHistory*/); }
		rows=newRows;
		showLeftOptions(true);
		
		//Se agrega scroll al container
		var container = grid.getParent().getParent(); 	
		gridScroller = addHScrollDiv(container, container.getWidth(), true, 'ul', true, true);		
	}
}


function getPropsTable(){
	var container;
	$$('.tableDataFormProps').each(function(t){
		if (t.getAttribute('data-is-visible')=='true'){
			container = t;
			return;
		}
	})
	return container;
}

function initPropsTabModeAction(){
	$('bottomOptsContainer').getElement('.tableDataFormProps').setAttribute('data-is-visible','true');
	
	bottomPropsFX = new Fx.Tween('bottomOptsContainer', {
	    duration: 500,
	    property: 'opacity',
	    onStart: function(){
	    	$('propsTabMax').toggle();
	    	
	    	var maxMode = $('propsTabMax').isVisible();
	    	if (maxMode){
	    		$('propsTabMax').click();	
	    	} else if ($('propsTabMax').hasClass('active')) {
	    		$('attsTab').click();
	    	}
	    	
	    	$('topOptsContainer').getElement('.tableDataFormProps').setAttribute('data-is-visible', maxMode);
			$('bottomOptsContainer').getElement('.tableDataFormProps').setAttribute('data-is-visible', !maxMode);
	    	
			var cell = null;
			var selected = tBodyGD.getElement('.selectedTR')
			if (selected){ cell = gridSchema[selected.id]; }	    	
	    	loadProperties(cell, null, null, maxMode);

	    },	    
	    onComplete: function(){
	    	var maxMode = $('propsTabMax').isVisible();
	    	
	    	//Se actualizan scrolls
			propertiesScroller = addScrollTable( getPropsTable() );			
			if (!maxMode){
				addScrollTable($('gridContainerFormAtts').getElement('#tableData'));
			}
	    }
	})
	
	topPropsFX = new Fx.Tween('topOptsContainer', {
	    duration: 500,
	    transition: Fx.Transitions.Sine.easeOut,
	    property: 'height',
	    unit: '%'
	})
	
	
	$('maxPropsTab').addEvent('click',function(e){
		if (e) e.stop();
		bottomPropsFX.start(1, 0);		
		topPropsFX.start(50, 100);
	})
	
	$('minPropsTab').addEvent('click',function(e){
		if (e) e.stop();
		bottomPropsFX.start(0, 1);
		topPropsFX.start(100, 50);
	})
}
