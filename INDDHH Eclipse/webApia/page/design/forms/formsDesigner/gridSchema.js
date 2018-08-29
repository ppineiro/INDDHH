var prefixGD = "GridSchema";
var containerGD, tBodyGD;
var gridSchema = [];
var gridSchemaScroller;

function initGridSchema(){
	containerGD = $('gridContainer'+prefixGD);
	tBodyGD = containerGD.getElement('#tableDataGridSchema');
	
	/* Auxiliares para filtros */
	$('clearFilters'+prefixGD).addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter'+prefixGD].each(clearFilter);
		$('nameFilter'+prefixGD).setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	setAdmFilters('nameFilter'+prefixGD, setFilterGridSchema);
	
	loadGridSchema();
}

function setFilterGridSchema(){
	loadGridSchema($('nameFilter'+prefixGD).value);
}

function updateGridSchema(cell, deleteCell, avoidLoadGridSchema, avoidClickEvent){
	if (!cell) return;
	
	if (deleteCell){
		gridSchema.erase(cell);
	} else {
		if (cell.isTableElement){
			var tableCell = cell.field.tableCell;			
			var eleIdx = Number.from(getRowByCell(tableCell).id);
			var tableEleCount = tableCell.field.tableElements.length;			
			gridSchema.splice(eleIdx+tableEleCount, 0, cell);
		} else {
			gridSchema.push(cell);	
		}
	}

	if (!avoidLoadGridSchema) loadGridSchema();
	
	if (!deleteCell && !avoidClickEvent){
		//Se selecciona fila agregada		
		cell.fireEvent('click', [null, false, true]);
	}
}

function clearGridSchema(avoidHistory){
	spDesigner.show(true);
	
	//Se obtiene copia del schema
	var auxSchema = gridSchema.slice();
	var i=auxSchema.length-1;
	var first = true;
	
	while(i>=0){	
		var currentCell = auxSchema[i--];
		if (!currentCell.isTableElement){		
			currentCell.fireEvent('delete', 
				[null, true, avoidHistory, false, !first /*cascadeAction*/, true /*onlyUndoAction*/]);
			first=false;
		}
	}
	gridSchema.empty();
	
	$('clearFilters'+prefixGD).click();
	loadProperties(null);
	
	if (!avoidHistory){
		var historyElement = {action: CLEAR_GRID_ACTION, cascadeAction: true}
		storeAction(historyElement);
	}
	
	spDesigner.hide();	
}

function loadGridSchema(filterByName){
	tBodyGD.empty();
	
	var isOdd=true;
	for(var i=0; i<gridSchema.length; i++){
		var cell=gridSchema[i];
		var label = getCellLabel(cell);
		
		if (filterByName && !label.toUpperCase().contains(filterByName.toUpperCase())){
			continue;
		}
		
		var tr = new Element('tr.selectableTR', {'id':i, 'tabindex':0}).inject(tBodyGD);
		if (isOdd) tr.addClass('trOdd');
		isOdd = isOdd==false;
		
		var td = new Element('td');
		var divContainer = new Element('div',{styles:{'position':'relative','padding-left':'30px'}})
			.inject(td.inject(tr));
		
		var iconPath='url("'+ IMG_FOLDER + '/schemaIcons/'+fieldMapping[cell.field.fieldType].icon+'")'
		new Element('div.schema-icon-container')
			.setStyle('background-image', iconPath)
			.inject(divContainer);

		var div = new Element('div',{id:'label', html:label}).inject(divContainer);
		
		if (cell.isTableElement){
			td.setStyle('padding-left', '20px');
			div.setStyle('font-size','85%');
		}
	}	

	//--Scroll
	gridSchemaScroller = addScrollTable(tBodyGD, true /*avoidSetScroll*/, true /*clearAllEvents*/);
	
	addTableActions(tBodyGD);
}

function addTableActions(tBody){
	tBodyGD.getElements('.selectableTR').each(function(item, index){
	    item.addEvents({
	    	'click': function(e){
	    		var parent = this.getParent();
	    		if (parent.lastSelected)  {
	    			//Recorrer todas las rows y deseleccionarlas
	    			unselectGridSchemaRows(this);
	    		}
	    		selectGridSchemaRow(this, gridSchema[this.id], [e, false, true /*forceMove*/], true);
	    	},
	    	'keyup': function(e){
				if (e && e.key == "delete"){
					gridSchema[this.id].fireEvent('delete');
				}
	    	}
		})
    });
}

function unselectGridSchemaRows(current_row){
	tBodyGD.getChildren('tr').each(function(item) {
		if(item.hasClass("selectedTR") && item != current_row) {
			item.removeClass("selectedTR");
		}
	})
	tBodyGD.lastSelected=null;
}

function selectGridSchemaRow(selectedTR, selectedCell, eventArgs, dontAvoidScrollGrid){
	var isRowSelected = selectedTR!=null;
	
	if (!isRowSelected){
		//Se busca por la celda
		selectedTR = getRowByCell(selectedCell);
	}
	if (!selectedTR) return;
	tBodyGD.lastSelected = selectedTR;
		
	if (!selectedTR.hasClass("selectedTR")) {
		selectedTR.addClass("selectedTR");
		if (gridSchemaScroller.v){ gridSchemaScroller.v.showElement(selectedTR); }
		if (dontAvoidScrollGrid && gridScroller.v){ showGridCell(gridScroller.v, selectedCell); }
		
		if (isRowSelected)
			selectedCell.fireEvent('click', eventArgs);
		else 
			selectedTR.fireEvent('click', eventArgs);
	}
}

function getCellLabel(cell){
	var label;
	if (cell.field.attName){
		label = cell.field.attName;
	} else {
		if (cell.field.fieldType==TYPE_LABEL || cell.field.fieldType==TYPE_BUTTON 
				|| cell.field.fieldType==TYPE_IMAGE || cell.field.fieldType==TYPE_GRID || cell.field.fieldType==TYPE_HREF){
			//Se valor de propiedad 'Nombre' 
			var prpNameValue = cell.field.getPropertyValue('19');
			if (prpNameValue && prpNameValue.length>0){
				return prpNameValue;
			}
		}			
		label = '&lt;' + cell.field.fieldLabel + '&gt;';
	}
	return label;
}

function getRowByCell(cell){
	var idx = gridSchema.indexOf(cell);
	var rows = tBodyGD.rows;
	for(var r=0;r<rows.length;r++){
		if (rows[r].id==idx){
			return rows[r];
		}
	}
}

function updateGridSchemaLabel(cell){
	var tr = getRowByCell(cell);
	if (tr)	tr.getElement('#label').innerHTML = getCellLabel(cell);
}

function moveGridSchemaCell(cell, relative){	
	var eIdx = gridSchema.indexOf(cell);
	var rIdx = gridSchema.indexOf(relative);
	Generic.moveElement(gridSchema, eIdx, rIdx);
	
	loadGridSchema();
	cell.fireEvent('click', [null, true, false]);
}
