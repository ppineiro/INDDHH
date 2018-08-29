
var historyStack = {
		undo : [/*historyElement*/],
		redo : [/*historyElement*/]
}
/*
 * historyElement = {
 * 	action : ...,
 * 	cell: ..., {optional}
 * 	source: ..., {optional}
 * 	destination: ..., {optional},
 * 	currentSize: ..., {optional},
 * 	.... {additional info}
 *}
 */

var MAX_UNDO_ACTIONS = 5;
var CURRENT_UNDO_ACTIONS = 0;

// -- Action constants
var MOVE_ACTION				= 0;
var RESIZE_ACTION			= 1;
var CREATE_ACTION			= 2;
var DELETE_ACTION			= 3;
var ADD_ROW_ACTION			= 4;
var DEL_ROW_ACTION			= 5;
var ADD_COL_ACTION			= 6;
var DEL_COL_ACTION			= 7;
var UPDATE_PROPERTY_ACTION 	= 8;
var MOVE_TABLE_ELE_ACTION 	= 9;
var CLEAR_GRID_ACTION 		= 10;
var UNCLEAR_GRID_ACTION 	= 11;
		


/*
 * Funciones auxiliares para el manejo del stack de acciones (undo/redo)
 */

function storeAction(historyElement){
	historyStack.undo.push(historyElement);
	//No se contabiliza acciones en cascada
	if (!historyElement.onlyUndoAction){ CURRENT_UNDO_ACTIONS++; }
	
	if (CURRENT_UNDO_ACTIONS > MAX_UNDO_ACTIONS){
		//TODO ver si primera acción es en cascada, se debería eliminar completa
		historyStack.undo.splice(0, 1);
		CURRENT_UNDO_ACTIONS--;
	}	
	
	//Al agrega una nueva acción, se resetea acciones de redo
	historyStack.redo.empty();
	
	checkHistoryStackActions();
}

function checkHistoryStackActions(){
	$('undoBtn').fireEvent('onActionComplete');
	$('redoBtn').fireEvent('onActionComplete');
}

function historyStackAction(isUndoAction){
	if (isUndoAction){
		var last = historyStack.undo.pop();
	} else {
		var last = historyStack.redo.pop();
	}
	
	if (!last) return;

	/*
	 * Se obtiene acción inversa para agregar a coleccion de undo/redo
	 */
	var revert = getRevertHistoryElement(last);				
	if (isUndoAction){
		historyStack.redo.push(revert);
	} else {
		historyStack.undo.push(revert);
	}
	
	//Se descarta la acción si sólo es válida para 'undo'. 
	//Se realiza la siguiente acción
	if (last.onlyUndoAction && !isUndoAction){ historyStackAction(isUndoAction); }
	
	switch(last.action){
	case MOVE_ACTION:
		var toCell = gridInfo[last.source.y][last.source.x].cell;
		var fromCell = gridInfo[last.destination.y][last.destination.x].cell;
		
		/*
		 * Controles al mover elemento desde 'Tables'
		 */
		if (last.destination.isTable){
			fromCell = fromCell.field.tableElements.getLast();
		} else if (last.destination.tableElementPosition>=0){
			fromCell = fromCell.field.tableElements[last.destination.tableElementPosition];
		}		
		if (last.source.tableElementPosition>=0){
			var relativeElementTable = toCell.field.tableElements[last.source.tableElementPosition];
		}
		
		fromCell.moveCell(toCell, true /*avoidHistory*/, relativeElementTable);
		
		break;
		
	case RESIZE_ACTION:
		gridInfo[last.source.y][last.source.x].cell.resizeCell(last.newSize.xSize, last.newSize.ySize, true, true, true/*avoidHistory*/);
		
		break;
	
	case CREATE_ACTION:
		if (!last.tableElementPosition && last.tableElementPosition!=0){
			var toDelete = [last.cell.element];
			last.cell.fireEvent('delete', [null, true, true /*avoidHistory*/]);
			
			//Se actualiza lista de droppables
			var toCreate = [last.cell.element];
			onModifyAction(toDelete, toCreate);
		} else {
			var tableCell = gridInfo[last.source.y][last.source.x].cell;
			var cellToDelete = tableCell.field.tableElements[last.tableElementPosition];
			cellToDelete.fireEvent('delete', [null, true, true /*avoidHistory*/]);
		}
		
		break;
		
	case DELETE_ACTION:
		if (last.tableElementPosition>=0){
			//Es un elemento de Table
			var tableCell = gridInfo[last.source.y][last.source.x].cell;
			last.cell = tableCell.updateElementFromTable(last.cell);
			updateGridSchema(last.cell, false /*add*/);
			
			//Se actualiza posición si corresponde
			var relativeElementTable = tableCell.field.tableElements[last.tableElementPosition];
			last.cell.moveCellFromTable(relativeElementTable, true /*avoidHistory*/);
			
		} else {
			last.cell.setGrid(grid);
			
			if (last.cell.field){
				last.cell.element.addClass('cell-with-data');
				last.cell.makeResizable(null, null, droppableElements, last.currentSize, true /*redrawField*/);
				makeDraggableInstances(last.cell.element.getElement('.cell-container'), true /*moveElement*/);
				updateGridSchema(last.cell, false /*add*/);	
				
				if (last.cell.isTable() && last.tableElements) {
					//Se agregan todos los elementos a Table
					var tableCell = last.cell;
					last.tableElements.each(function(ele){
						ele = tableCell.updateElementFromTable(ele);
						updateGridSchema(ele, false /*add*/, false, true);	
					})
					tableCell.fireEvent('click');
				}
				
			} else {
				//Caso celda vacía				
				last.cell.resizeCell(1, 1, true, false, true /*avoidHistory*/);
				gridInfo[last.cell.y][last.cell.x].isEmpty = true;
			}
			
			//Se actualiza lista de droppables
			var toCreate = [last.cell.element];
			var toDelete = [gridInfo[last.cell.y][last.cell.x].cell.element];
			onModifyAction(toDelete, toCreate);
			
			//Se elimina elemento previo
			gridInfo[last.cell.y][last.cell.x].cell.element.destroy();
			gridInfo[last.cell.y][last.cell.x].cell = last.cell;
		}
		
		if (last.cascadeAction){ historyStackAction(isUndoAction); }
		
		checkHistoryStackActions();
		break;	
	
	case ADD_ROW_ACTION: onModifyLayout( deleteRow(last.y, true /*avoidHistory*/) ); break;	
	case DEL_ROW_ACTION: onModifyLayout( addRow(last.y, true /*avoidHistory*/) ); break;	
	case ADD_COL_ACTION: onModifyLayout( deleteColumn(last.x, true /*avoidHistory*/) ); break;
	case DEL_COL_ACTION: 
		var errorCode = addColumn(last.x, true /*avoidHistory*/);
		if (!errorCode && last.cascadeAction){ historyStackAction(isUndoAction); }		
		onModifyLayout(errorCode);
		
		break;	
	
	case UPDATE_PROPERTY_ACTION:
		//Se actualiza la propiedad y se vuelven a cargar
		
		if (last.source){		
			if (last.tableElementPosition>=0){
				//Es un elemento de Table
				var tableCell = gridInfo[last.source.y][last.source.x].cell;
				var cell = tableCell.field.tableElements[last.tableElementPosition];
			} else{
				var cell = gridInfo[last.source.y][last.source.x].cell;			
			}
		} else {
			/*Caso propiedad de formulario*/
		}
		
		
		if (last.property.evtId){
			last.property.events = last.oldValue;
			
		} else {
			if (last.property.name=='attr'){
				cell.setAttribute(last.oldValue.attId, last.oldValue.attName, last.oldValue.attLabel);
				
				if (!last.oldValue.attId){
					//Se actualiza label del field 
					cell.field.setLabelText(last.oldValue.fieldLabel, cell.isTableElement);
					cell.field.fieldLabel = last.oldValue.fieldLabel;
					updateGridSchemaLabel(cell);
				}
			} else  if (last.property.name=="entBinding"){
				if (last.oldValue!=null && last.oldValue!=last.newValue){//Se actualiza la entidad
					loadEntBindingAttributes(last.dataId, cell);	
				} else {
					//Se eliminan propiedades asociadas a atributos para binding					
					var bndGroup = findGroupPropertiesByName(cell.field.properties, "Binding");				
					bndGroup.busEntId=null;
					bndGroup.properties.splice(1,bndGroup.properties.length-1);
				}
				
			} else if (last.property.name=="prpChildOrder"){
				sortTableElements(last.oldValue, tableCell.field);
				last.oldValue = null; //Evita escribir en tabla de propiedades
			} else if (last.property.name=='type'){
				changeFieldType(cell, last.oldValue, true);
			
			} else {
				if (last.property.entityBinding){
					//Se busca la propiedad actual asociada a un mapping
					var bndGroup = findGroupPropertiesByName(cell.field.properties, "Binding");
					var filtered = bndGroup.properties.filter(function(p){
						if (p.label==last.property.label){ return p; }
					})
					if (filtered.length>0){ last.property = filtered[0]; }
				}
			}
			
			last.property.value = last.oldValue;
			
		}
		
		if (cell) {
			cell.fireEvent('click', [null, true, false, true, last.property]);
		} else if (tableCell){
			tableCell.fireEvent('click', [null, true, false, true, last.property]);
		} else {
			clearAllSelectedCells(null, true);
		}
		
		checkHistoryStackActions();
		
		break;
	
	case MOVE_TABLE_ELE_ACTION:	
		var tableCell = gridInfo[last.source.y][last.source.x].cell;
		var toMove = tableCell.field.tableElements[last.tableElementPosition];
		var relative = tableCell.field.tableElements[last.tableRelativeElementPosition];
		toMove.moveCellFromTable(relative, true /*avoidHistory*/);
		relative.fireEvent('click');
		break;
		
	case CLEAR_GRID_ACTION:
		//Crea celdas en cascada
		if (last.cascadeAction){ historyStackAction(isUndoAction); }		
		break;
		
	case UNCLEAR_GRID_ACTION: clearGridSchema(true /*avoidHistory*/); break;
	
	}
}

function getRevertHistoryElement(historyElement){
	var revert = copyObjectValues(historyElement);
	
	switch(historyElement.action){
	case MOVE_ACTION:
		revert.source = historyElement.destination;
		revert.destination = historyElement.source;
		break;
		
	case RESIZE_ACTION:
		revert.currentSize = historyElement.newSize;
		revert.newSize = historyElement.currentSize;
		break;
	
	case CREATE_ACTION:
		if (historyElement.cell.field==null){
			//Se perdió referencia al borrar celda previamente
			//Se intenta obtener la del grid
			historyElement.cell = gridInfo[historyElement.source.y][historyElement.source.x].cell;
		}
		revert.action = DELETE_ACTION;
		revert.currentSize = historyElement.currentSize?
				historyElement.currentSize :
				{xSize: historyElement.cell.xSize, ySize: historyElement.cell.ySize};
		
		if (historyElement.tableElementPosition>=0){
			revert.tableElementPosition = historyElement.tableElementPosition;
			revert.cell = historyElement.cell.clone(true /*fullClone*/, true /*avoidGrid*/);
		} else {
			revert.cell = historyElement.cell.clone(true /*fullClone*/, true);
		}
		break;
		
	case DELETE_ACTION:
		revert.action = CREATE_ACTION;
		revert.currentSize = historyElement.currentSize?
				historyElement.currentSize :
				{xSize: historyElement.cell.xSize, ySize: historyElement.cell.ySize};
		break;	
	
	case ADD_ROW_ACTION: revert.action = DEL_ROW_ACTION; break;
	case DEL_ROW_ACTION: revert.action = ADD_ROW_ACTION; break;
	case ADD_COL_ACTION: revert.action = DEL_COL_ACTION; break;
	case DEL_COL_ACTION: revert.action = ADD_COL_ACTION; break;
		
	case UPDATE_PROPERTY_ACTION:
		revert.newValue = historyElement.oldValue;
		revert.oldValue = historyElement.newValue;
		break;
	
	case MOVE_TABLE_ELE_ACTION:	break;
	
	case CLEAR_GRID_ACTION:		revert.action = UNCLEAR_GRID_ACTION; break;
	case UNCLEAR_GRID_ACTION:	revert.action = CLEAR_GRID_ACTION; break;
	
	}
	
	return revert;
}


