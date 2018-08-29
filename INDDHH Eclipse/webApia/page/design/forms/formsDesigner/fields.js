
/* IFldType */
var fieldMapping = {}
fieldMapping[TYPE_FORM]		= { type: 'FORM' };
fieldMapping[TYPE_INPUT]	= { type: 'INPUT', label:'INPUT', icon:'inputIcon.png' };
fieldMapping[TYPE_SELECT]	= { type: 'COMBOBOX', label:'COMBOBOX', icon:'comboIcon.png' };
fieldMapping[TYPE_CHECK]	= { type: 'CHECKBOX', label:'CHECKBOX', icon:'checkboxIcon.png' };
fieldMapping[TYPE_AREA]		= { type: 'TEXTAREA', label:'TEXTAREA', icon:'textareaIcon.png' };
fieldMapping[TYPE_FILE]		= { type: 'FILE', label:'FILE', icon:'fileIcon.png' };
fieldMapping[TYPE_RADIO]	= { type: 'OPTION',	label:'RADIO', icon:'radioIcon.png' };
fieldMapping[TYPE_BUTTON]	= { type: 'BUTTON',	label:'BUTTON', icon:'buttonIcon.png' };
fieldMapping[TYPE_LABEL]	= { type: 'LABEL', label:'LABEL', icon:'labelIcon.png' };
fieldMapping[TYPE_GRID]		= { type: 'GRID', label: 'TABLE', icon:'tableIcon.png' };
fieldMapping[TYPE_TITLE]	= { type: 'TITLE', label:'TITLE', icon:'titleIcon.png' };
fieldMapping[TYPE_PASSWORD]	= { type: 'PASSWORD', label:'PASSWORD', icon:'passwordIcon.png' };
fieldMapping[TYPE_IMAGE]	= { type: 'IMAGE', label: 'IMAGE', icon:'imageIcon.png' };
fieldMapping[TYPE_TREE]		= { type: 'TREE', label:'TREE', icon:'treeIcon.png' };
fieldMapping[TYPE_MULTIPLE]	= { type: 'LISTBOX', label:'LISTBOX', icon:'listIcon.png' };
fieldMapping[TYPE_EDITOR]	= { type: 'EDITOR', label:'EDITOR', icon:'editorIcon.png' };
fieldMapping[TYPE_HREF]		= { type: 'LINK', label:'LINK', icon:'linkIcon.png' };
fieldMapping[TYPE_HIDDEN]	= { type: 'HIDDEN',	label:'HIDDEN', icon:'hiddenIcon.png' };
fieldMapping[TYPE_CAPTCHA]	= {	type: 'CAPTCHA', label:'CAPTCHA', icon:'captchaIcon.png' };

var lastFieldId = 0;

var Field = new Class({

	cell: null, //Se mantiene referencia sobre la celda asociada
	
	fieldId : null,
	fieldType: null,
	
	fieldLabel: null,
	labelElement: null,
	
	attId:null,
	attName:null,
	
	properties : null,
	
	events : null,
	
	//Caso 'Table': contiene celdas contenidas	
	tableElements: [],
	//Caso 'tableElement': contiene referencia a celda del elemento 'Table'
	tableCell : null,
	
	initialize: function(cell, fieldId, fieldType, container, isTableElement) {
		this.cell=cell;
		
		//Se determina el id
		if (fieldId){
			this.fieldId=fieldId;
			
			if (Number.from(fieldId)>Number.from(lastFieldId)){ lastFieldId=fieldId; }
		} else {
			lastFieldId++;
			this.fieldId=lastFieldId;
		}
		
		this.fieldType=fieldType;
		
		if (container){
			if (isTableElement) 
				this.initializeLabelTableElement(container);
			else
				this.initializeLabelElement(container);
		}
	},
	
	initializeLabelElement: function(container, avoidInitializeProperties) {
		//Se reinicializan variables asociadas a elemento Table
		this.tableElements = [];
		this.tableCell = null;
		this.labelHeaderElement = null;
		
		if (fieldMapping[this.fieldType] && container){
			this.fieldLabel=fieldMapping[this.fieldType].label;
			
			if (this.fieldType!=TYPE_BUTTON && this.fieldType!=TYPE_GRID && this.fieldType!=TYPE_IMAGE){
				this.labelElement=new Element('span.lbl-container', {html : this.fieldLabel}).inject(container);	
			}
			
			switch(this.fieldType){
			case TYPE_BUTTON : container.addClass('full-container-btn'); break; 
			case TYPE_LABEL : container.addClass('full-container'); break;
			case TYPE_GRID : container.addClass('table-item'); break;
			case TYPE_TITLE: 
				this.labelElement.setStyle('font-weight', 'bold');
				container.addClass('full-container'); break;
			case TYPE_EDITOR: this.labelElement.setStyle('text-align','center'); break;
			case TYPE_HREF: 
				this.labelElement.addClass('hyperlink');
				container.addClass('full-container'); break;
			}
			
			if (!avoidInitializeProperties){ this.properties = fieldProperties[this.fieldType].clone(); }
		}
	},
	
	/*
	 * Se inicializa cada elemento según cómo será mostrado en grilla
	 */
	initializeElement: function(container, isTableElement) {
		if (!container) return;

		switch(this.fieldType){
		case TYPE_INPUT: new Element('input.input-field').inject(container); break;
		case TYPE_SELECT: new Element('select.combo-field').inject(container); break;
		case TYPE_CHECK: new Element('input.input-field', {'type':'checkbox'}).inject(container); break;
		case TYPE_AREA: new Element('textarea').inject(new Element('div.full-container-with-label').inject(container)); break;
		case TYPE_FILE: 
			var doc = new Element('div.document').inject(container);
			['docUploadIcon','docDownloadIcon','docInfoIcon','docLockIconLocked','docEraseIcon'].each(function(className){
				new Element('div.docIconField.docIcon.'+className).inject(doc);	
			})
			break;
		case TYPE_RADIO: new Element('input.input-field', {'type':'radio'}).inject(container); break;
		case TYPE_BUTTON:
			this.labelElement = new Element('button.genericBtn').inject(new Element('div.inner-container').inject(container));
			this.setLabelText(this.fieldLabel);
			break;
		case TYPE_LABEL :
			if (isTableElement){ this.labelElement = new Element('span', {html : this.fieldLabel}).inject(container); }
			break;
		case TYPE_GRID:
			var tableContainer = new Element('div.table-container').inject(container);			
			tableContainer.innerHTML=
				"<div class='gridHeader' style='border-top:0px;'>"+
				"	<table>"+
				"		<thead>"+
				"			<tr class='header' style='height: 20px'>"+
				"				<th><div style='height:13px;' /></th>"+
				"			</tr>"+
				"		</thead>"+
				"	</table>"+
				"</div>"+
				"<div class='gridFooter' style='bottom:0px;border-bottom:0px;'>"+
				"	<div class='footer-element'>"+LBL_DEL+"</div>"+
				"	<div class='footer-element'>"+LBL_ADD+"</div>"+
				"	<div class='footer-element'>"+LBL_DOWN+"</div>"+
				"	<div class='footer-element'>"+LBL_UP+"</div>"+				
				"</div>"+
			
				"<div class='table-element-container'>" +
			    "	<div class='hScrollContainer'>"+
			    "		<div class='scroll-element next-element'></div>" +
				"		<div class='scroll-element prev-element'></div>" +
				"		<ul  style='width:8000px;height:100%;'></ul>" +
				"	</div>"+
				"</div>";


			this.hScroll = new slideGallery(tableContainer.getElements(".table-element-container"), {
				steps: 2,
				mode: 'line',
				holder: '.hScrollContainer',
				nextItem: '.next-element',
				prevItem: '.prev-element',
				nextDisableClass: 'scroll-element-disable',
				prevDisableClass: 'scroll-element-disable',
				slideMouseAction: 'mousedown',
				onComplete: function(){
					//Se realiza focus del elemento seleccionado para poder manipuar evento 'keyup' (delete)
					var selectedCell = this.holder.getElement('.selected-cell');
					if (selectedCell) { selectedCell.focus(); }
				}
			})
			
			break;			
		case TYPE_TITLE: break;
		case TYPE_PASSWORD: new Element('input.input-field', {type:'password', value:'********'}).inject(container); break;
		case TYPE_IMAGE : 
			if (isTableElement){ container.addClass('image-grid-element'); }
			new Element('div.image-field').inject(container); break;
		case TYPE_TREE: new Element('div.tree-field').inject(new Element('div.full-container-with-label.tree-container').inject(container)); break;
		case TYPE_MULTIPLE: 
			var listContainer = new Element('div.listbox-container').inject(new Element('div.full-container-with-label').inject(container)); 
			for (var i=0; i<3; i++){
				var op = new Element('div.list-element',{styles:{top:(i*20)+'px'}}).inject(listContainer);
				op.textContent='Option '+(i+1);	
								
				if (i==0) op.setStyle('border-top', '1px solid grey');
			}			
			new Element('div.list-element',{styles:{top:'0px',height:'100%'}}).inject(listContainer);
			break;
		case TYPE_EDITOR:	new Element('div.editor-field').inject(new Element('div.full-container-with-label').inject(container)); 	break;
		case TYPE_HREF:
			if (isTableElement){ this.labelElement = new Element('span.hyperlink', {html : this.fieldLabel}).inject(container); }
			break;
		case TYPE_HIDDEN: new Element('input.input-field').inject(container); break;
		case TYPE_CAPTCHA: 
			new Element('div.captcha-field').inject(container);
			new Element('input.input-field').inject(container); break;
		}
	},	
	
	setAttribute: function(attId, attName, attLabel){
		if ((this.labelElement || this.labelHeaderElement)&& 
				this.fieldType!=TYPE_LABEL && this.fieldType!=TYPE_TITLE && this.fieldType!=TYPE_IMAGE &&
				this.fieldType!=TYPE_HREF && this.fieldType!=TYPE_CAPTCHA){
			this.attId=attId;
			this.attName=attName;
			
			var attLabelEscape = Generic.espapeHTML(attLabel);
			this.attLabel=attLabelEscape;
			
			//Se actualiza label
			this.setLabelText(this.attLabel, this.tableCell);
			this.fieldLabel = attName;
			
			var attPrp = findPropertyByName(this.properties, "attr");
			if (attPrp) attPrp.value = attName;
		}
	},
	
	setLabelStyle: function(property, value, headerLabel) {
		if (this.labelHeaderElement && headerLabel){
			this.labelHeaderElement.setStyle(property,value);
		} else if (this.labelElement){
			this.labelElement.setStyle(property,value);
		}
	},
	
	setLabelText: function(text, headerLabel){
		if (this.labelHeaderElement && headerLabel){
			this.labelHeaderElement.innerHTML=Generic.espapeHTML(text);
			
		} else if (this.labelElement){
			this.labelElement.innerHTML=Generic.espapeHTML(text);
		} 
	},
	
	setPropertyValue: function(prpId, prpValue){
		switch(prpId){
		case '5': //color
			var headerLabel = this.fieldType!=TYPE_LABEL && this.fieldType!=TYPE_BUTTON;			
			this.setLabelStyle('color',prpValue, headerLabel);
			
			break;
		case '6': //value;
			if (!prpValue || prpValue.length==0) prpValue=this.fieldLabel;
			
			this.setLabelText(prpValue);
			
			if (this.tableCell){//Es un elemento de 'Table'
				var gridLblValue = this.getPropertyValue('65');
				if (!gridLblValue || gridLblValue.length==0){
					this.setLabelText(prpValue, true);
				}
			}
			break;
		
		case '13': //bold
			this.setLabelStyle('font-weight', toBoolean(prpValue)? 'bold' : null);
			break;
		
		case '14': //underline 
			this.setLabelStyle('text-decoration', toBoolean(prpValue)? 'underline' : null);
			break;
			
		case '15': //text align
			var align = null;
			switch(prpValue){
			case '0' : align="left"; break;
			case '1' : align="center"; break;
			case '2' : align="right"; break;
			}
			this.setLabelStyle('text-align', align);
			break;
			
		case '19': //name
			if (this.fieldType==TYPE_LABEL || this.fieldType==TYPE_BUTTON || this.fieldType==TYPE_IMAGE
					|| this.fieldType==TYPE_GRID || this.fieldType==TYPE_HREF){
				updateGridSchemaLabel(this.cell);
			}
			break;
		case '65': //Grid label
			if (prpValue && prpValue.length>0)
				this.setLabelText(prpValue, true);
			else if (this.attLabel)
				this.setLabelText(this.attLabel);
			else {
				var value = this.getPropertyValue('6');
				if (value && value.length>0){
					this.setLabelText(value, true);
				} else {
					this.setLabelText(this.fieldLabel, true);	
				}
			}
				
			break;
		}
	},
	
	getPropertyValue: function(prpId){
		if (this.properties){
			var filtered;
			this.properties.some(function(grp){
				if (grp.properties){
					filtered = grp.properties.filter(function(p){
						if (p.prpId==prpId) return p;
					})
					
					if (filtered && filtered.length>0) return true;
				}
			})
			if (filtered.length>0) return filtered[0].value;
		}
	},
	
	isTable: function(){
		return this.fieldType==TYPE_GRID;
	},
	
	clone: function(fullClone){
		var clone = new Field(this.cell, this.fieldId, this.fieldType, this.container, this.isTableElement);
		copyObjectValues(this, clone, ['attId','attLabel','attName','fieldLabel']);
		if (fullClone){ 
			clone.properties = this.properties;
			clone.events = this.events;
			clone.tableElements = this.tableElements;
			clone.tableCell = this.tableCell;
		}
		return clone;
	},
	
	
	/*
	 * Funciones caso elemento 'Table'
	 */	
	addElementToTable: function(tableCell, fieldType, cellToUpdate, fieldId, x, y){
		if (!this.isTable()) return;
		
		//Se crea/actualiza celda contenida en Table
		var tableContainer = tableCell.element.getElement('ul');
		var cellToAdd = createOrUpdateTableCellElement(fieldType, tableContainer, cellToUpdate, fieldId, x, y);		
		cellToAdd.field.tableCell = tableCell;	
		cellToAdd.setX(this.tableElements.length);
		cellToAdd.field.cell = cellToAdd;
		this.tableElements.push(cellToAdd);
		
		this.hScroll.addElement(cellToAdd.element, true);
		
		return cellToAdd;
	},
	
	containElement: function(element){
		if (!this.isTable()) return false;
		
		return this.tableElements.some(function(cell){
			if (cell.element==element) return true;
		})
	},
	
	removeElementFromTable: function(cellToRemove){
		if (!this.tableCell) return;
		
		//Se remueve del elemento padre y se actualizan índices
		var tableElements = this.tableCell.field.tableElements;		
		var idx = tableElements.indexOf(cellToRemove);
		if (idx>=0){
			tableElements.erase(cellToRemove);		
			this.tableCell.field.hScroll.removeElement(cellToRemove.element, true);
			
			for (var i=idx; i<tableElements.length; i++){
				tableElements[i].setX(i);
			}
		}
	},
	
	updateTableFieldSize: function(){
		if (!this.isTable()) return;		
		this.hScroll.updateDimensions();
	},
	
	moveTableScrollToElement: function(cellToSelect){
		if (!this.tableCell) return;
		
		this.tableCell.field.hScroll.moveToElement(cellToSelect.element);
	},
		
	makeTableScrollDroppable: function(droppables){
		if (!droppables && !this.hScroll) return;
		
		if (this.hScroll.next) { droppables.push(this.hScroll.next); }
		if (this.hScroll.prev) { droppables.push(this.hScroll.prev); }
	},
	
	//Mueve la celda de un elemento 'Table' a relative
	moveCellFromTable: function(cell, relative){
		if (!this.isTable()) return;
		
		var eIdx = this.tableElements.indexOf(cell);
		var rIdx = this.tableElements.indexOf(relative);
		var moved = Generic.moveElement(this.tableElements, eIdx, rIdx);
		if (!moved) { return; }
			
		//Se actualizan índices
		this.tableElements.each(function(cell, idx){ cell.setX(idx); });
		
		//Se actualiza el scroll
		if (this.hScroll) { this.hScroll.moveElement(cell.element, relative.element); }
		
		//Se actualiza esquema
		moveGridSchemaCell(cell, relative);
	},
	
	initializeLabelTableElement: function(container, avoidInitializeProperties, redrawField){
		if (fieldMapping[this.fieldType] && container){
			this.fieldLabel=fieldMapping[this.fieldType].type;			
			
			var tableEle = container.getElement('div.gridHeader.table-element');
			if (!redrawField || !tableEle) {
				tableEle = new Element('div.gridHeader.table-element').inject(container);	
			}
			tableEle.innerHTML =
				'<table>'+
				'	<thead>'+
				'		<tr class="header" style="border-top: 0px;height: 20px"><th><div class="lbl-container" id="lbl" style="color:black" /></th></tr>'+
				'	</thead>'+
				'	<tbody>'+
				'		<tr><td class="grid-element-container">'+
				'			<div class="grid-element"></div>'+
				'			<div class="blocker-container"></div>'+
				'		</td></tr>'+
				'	</tbody>'+
				'</table>';
				
			this.labelHeaderElement = tableEle.getElementById('lbl');
			this.labelHeaderElement.innerHTML = this.fieldLabel;
			
			if (!avoidInitializeProperties){ this.properties = fieldProperties[this.fieldType].clone(); }
		}
	},
	
	dispose: function(avoidLoadGridSchema){
		if (this.tableElements){
			//Se elimina cada elemento de 'Table' del esquema
			this.tableElements.each(function(ele){ 
				updateGridSchema(ele, true /*delete*/, true);
			})			
			this.tableElements.empty();
			
			if (!avoidLoadGridSchema){
				//Luego de borrar elementos, se actualiza esquema
				loadGridSchema();	
			}
		}
	}
	
})

function getFieldIdByName(name){
	if (!name) return;
	
	var id=null;
	name = name.toUpperCase();
	Object.keys(fieldMapping).each(function(k){
		if (fieldMapping[k].type==name){
			id=k;
			return; 
		}
	})
	return id;
}

function createOrUpdateTableCellElement(fieldType, container, cellToUpdate, fieldId, x, y){
	if (cellToUpdate){
		var cell = cellToUpdate;
		cell.convertToTableElement(container, 'hidden-element');
		var attLabel = cell.field.attLabel; 
		cell.field.initializeLabelTableElement(cell.element, true);
		
		//Se actualiza label con atributo
		if (attLabel){
			cell.field.setLabelText(attLabel, true);
			cell.field.fieldLabel=cell.field.attName;
		}
	} else {
		var cell = createCell(x, y, container, true /*tableElement*/, 'hidden-element');
		
		//Se agrega element según su tipo
		cell.field = new Field(cell, fieldId, fieldType, cell.element, true);
	}
	
	cell.field.initializeElement(cell.element.getElement('.grid-element'), true /*tableElement*/);
	
	//Se hace visible la celda
	cell.element.set('tween', {
	    onComplete: function(){ this.element.removeClass('hidden-element');  }
	}).fade(1);
	
	makeDraggableInstances(cell.element.getElement('.table-element'), true /*moveElement*/, 
		//CustomClone
		function(element,event){
			var clone = element.clone();
			var coords = element.getCoordinates();
			clone.setStyles(coords);	
			clone.style.height=(CELL_HEIGHT + 20)+ 'px';
			clone.getElement('table').setStyle('table-layout','fixed');
			if (element.getElement('.image-grid-element')) clone.getElement('td').addClass('grid-image-clone');

			event.page.y-=event.event.offsetY;
			return clone;
		}
	);
	
	return cell;
}

function isValidTableElement(fieldType){
	if (fieldType==TYPE_RADIO || fieldType==TYPE_AREA || fieldType==TYPE_GRID || fieldType==TYPE_TITLE || 
			fieldType==TYPE_TREE ||	fieldType==TYPE_MULTIPLE || fieldType==TYPE_EDITOR || fieldType==TYPE_CAPTCHA){
		return false;
	}
	return true;
}
function isValidAttributeField(fieldType){
	if (fieldType==TYPE_LABEL || fieldType==TYPE_BUTTON || fieldType==TYPE_GRID || fieldType==TYPE_TITLE ||
			fieldType==TYPE_HREF || fieldType==TYPE_IMAGE ||fieldType==TYPE_CAPTCHA){
		return false;
	}
	return true;
}

function copyObjectValues(source, destination, keys){
	if (!source) return;	
	if (!destination){ destination={}; }
	if (!keys) { keys = Object.keys(source)	}
	
	keys.each(function(key){
		if (source[key]!=undefined){ destination[key] = source[key]; }
	})
	return destination;
}

function getMinFieldSize(fieldType){
	var minXSize, minXSize;
	switch(fieldType){
	case TYPE_AREA: minXSize = 1; minYSize = 3; break;
	case TYPE_GRID: minXSize = 2; minYSize = 3; break;
	case TYPE_TREE: minXSize = 1; minYSize = 3; break;
	case TYPE_MULTIPLE: minXSize = 1; minYSize = 3; break;		
	case TYPE_EDITOR: minXSize = cols; minYSize = 3; break;
	case TYPE_CAPTCHA: minXSize = 1; minYSize = 2; break;
	default: minXSize = 1; minYSize = 1;
	}
	
	return [minXSize,minYSize];
}
