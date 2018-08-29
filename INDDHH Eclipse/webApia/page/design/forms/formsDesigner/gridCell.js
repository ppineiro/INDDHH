/*
 * Estructura para almacenar información sobre las celdas.
 * var gridInfo = { }
 * gridInfo[properties]
 * gridInfo[row][column]
 * 
 * cell: object -> puntero a la celda
 * isEmpty : boolean -> indica si es una celda libre
 * } 
 * 
 * IMPORTANTE: Se debe definir donde se vaya a usar
 */

var CELL_WIDTH				= 200;
var CELL_LAYOUT_PADDING		= 5;
var CELL_LAYOUT_OPT_SIZE	= 25;
var CELL_HEIGHT 			= 50;
var CELL_BORDER 			= 2;

var ERROR_CODE_USED_CELL 	= -1;
var ERROR_CODE_OUT_OF_RANGE	= -2;
var ERROR_CODE_MINIMUM_SIZE	= -3;
var ERROR_CODE_EMPTY_CELL	= -4;

var HOVER_CELL_COLOR 			= "#E2E2E2";
var HOVER_INVALID_CELL_COLOR	= "#FFE6E6";


var GridCell = new Class({
	
	Implements: [Events,Options],
	
	options: {},
	
	grid: null,
	
	element: null,
	
	x: null, /* column index */
	
	y: null, /* row index */
	
	xSize: 1,
	
	ySize: 1,
	
	minXSize: 1,
	minYSize: 1,
	
	field: null,
	
	initialize: function(x, y, grid, options, isTableElement, addStyleClass) {
		this.x = x;
		this.y = y;
		this.mainCell = this;
						
		if (options && options.xSize) this.xSize = options.xSize;
		if (options && options.ySize) this.ySize = options.ySize;
		
		this.element = 	new Element('li', {'tabindex':0 /*keyup event*/});
		
		this.isTableElement=isTableElement;		
		if (!isTableElement){
			this.element.addClass('grid-element');
			this.element.setAttribute('data-x', x);
			this.element.setAttribute('data-y', y);
			this.updateSize(this.xSize,this.ySize);
		} else {
			if (x) this.element.setAttribute('data-x', x);
			this.element.addClass('table-element');
		}
		
		if (options && options.classes) this.element.addClass(options.classes);
		if (addStyleClass) this.element.addClass(addStyleClass);
		
		this.element.addEvents({ 
			'click': function(e, options){ 
				if (e){e.stop();}
				this.fireEvent('click', [e,options]); 
			}.bind(this),
			'clickCell': function(e, options){ 
				if (e){e.stop();} 
				this.fireEvent('click', [e,options]);
			}.bind(this),			
			'keyup': function(e, options){ 
				if (e && e.key == "delete") 
					this.fireEvent('delete', e); 
			}.bind(this),
			'mousemove': function(e, options){ 
				this.fireEvent('mouseMove', e); 
			}.bind(this),
			'mouseover': function(e, options){ 
				if (this.timer){ clearTimeout(this.timer); }
				if (this.field && this.field.attId){
					this.timer = showTooltipMessage.delay(1000, null, [null, this.field.fieldLabel]);	
				}
			}.bind(this),
			'mouseout': function(e, options){
				if (this.timer){ clearTimeout(this.timer); }
			}.bind(this)
		});
		
		this.setGrid(grid);
		this.setOptions(options);
		this.options=options;
		
	},
	
	/*
	 * Se encarga de que la celda pueda cambiar de tamaño.
	 * Además se agrega el elemento que corresponda.
	 */
	makeResizable : function(fieldId, fieldType, droppableElements, forceCurrentSize, redrawField){
		var cellContainer = new Element('div.cell-container.hidden-element').inject(this.element);
		var itemCell = new Element('div.item-cell').inject(cellContainer);

		if (redrawField){
			this.redrawField(itemCell, null, true);
			
		} else {
			//Se agrega element según su tipo
			this.field = new Field(this, fieldId, fieldType, itemCell);
			this.field.initializeElement(itemCell);
		}

		//Se hace visible la celda
		cellContainer.set('tween', {
		    onComplete: function(){ 
		    	this.element.removeClass('hidden-element');  }
		}).fade(1);
		
		var cell=this;
		var resizableContainer = new Element('div',{'class':'resizable-container'}).inject(cellContainer);
		
		var resize = new MooResize(resizableContainer,{
			handleSize: 10,
			droppables : droppableElements,
			handleStyle: {
			},
			onHandleClick: function(e){
				this.elContainer.fireEvent('clickCell', [e, true]);
			},
			onEnter: function(droppable, mouse){
				var parentCell = getGridCell(this.elContainer);
				var overCell = getGridCell(droppable);

				var lastOverCell = this.el.retrieve('lastOverCell');
				if (!lastOverCell || lastOverCell.x!=overCell.x || lastOverCell.y!=overCell.y){
					//Control para caso borde					
					if (parentCell != overCell){
						this.el.store('lastOverCell', overCell);
					} else {
						var mouseOffset = overCell.getMouseOffsetSelection(mouse);						
						if ((mouseOffset.x==0 && mouseOffset.y==0) || (mouseOffset.x==1 && mouseOffset.y==0) 
								|| (mouseOffset.x==0 && mouseOffset.y==1)){
							this.el.store('lastOverCell', overCell);	
						}
					}
				}
				
				var expandX = !lastOverCell || overCell.x>=lastOverCell.x;
				var expandY = !lastOverCell || overCell.y>=lastOverCell.y;	
					
				if (expandX || expandY){
					parentCell.applyFunction(
						function(iterCell){	
							if (iterCell.belongsTo(parentCell)) return;
							toggleCellStyle(iterCell, null, true/*addStyle*/); },				
						overCell.x - parentCell.x + 1, overCell.y - parentCell.y + 1
					);						
				}
				
				if (overCell) {
					if(!expandX){
						overCell.getNextColumnCell(1).applyFunction(
							function(iterCell){ 
								toggleCellStyle(iterCell); },
							1, overCell.y, null, true /*reverse*/
						);
					}
					
					if(!expandY){
						overCell.getNextRowCell(1).applyFunction(
							function(iterCell){	
								toggleCellStyle(iterCell); },
							overCell.x, 1 , null, true /*reverse*/
						);
					}
				}
				
			},
			
			onDrop: function(droppable){
				var parentCell = getGridCell(this.elContainer);
				var droppableCell = getGridCell(droppable);
				
				var lastOverCell = this.el.retrieve('lastOverCell');
				if (lastOverCell){
					var newSize = {
							x: lastOverCell.x - parentCell.x + 1, 
							y: lastOverCell.y - parentCell.y + 1		
					}
				} else {
					var newSize = {x: parentCell.xSize, y: parentCell.ySize	}
				}
				
				//Control de errores: fuera de rango, minimo permitido, celda ocupada
				var errorCode = droppableCell? 0 : ERROR_CODE_OUT_OF_RANGE;
				if (newSize.x < parentCell.minXSize || newSize.y < parentCell.minYSize){
					errorCode = ERROR_CODE_MINIMUM_SIZE;
				} else if ((parentCell.field.fieldType == TYPE_EDITOR || parentCell.field.fieldType == TYPE_TITLE) &&
						newSize.x != cols){
					errorCode = ERROR_CODE_MINIMUM_SIZE;
				}
				
				if (errorCode==0){
					var lastOverCell = this.el.retrieve('lastOverCell');
					if (lastOverCell){
						var newSize = {
								x: lastOverCell.x - parentCell.x + 1, 
								y: lastOverCell.y - parentCell.y + 1		
						}
						var checkResult = parentCell.checkEmptyCells(newSize.x, newSize.y, parentCell);
						var functionReturn = checkResult[0]; 
						errorCode = checkResult[1];			
					}
				}
								
				if (errorCode<0) {
					parentCell.resizeCell(parentCell.xSize, parentCell.ySize, true);

					parentCell.applyFunction(
							function(iterCell){ toggleCellStyle(iterCell); },
							newSize.x, newSize.y
					);	
					
					showTooltipMessage(errorCode);
					
				} else{
					parentCell.resizeCell(newSize.x, newSize.y, true, true /*applyEffect*/);
					toggleElementContainerStyle(parentCell, null, null, null, true);	
				}	
				
				this.el.eliminate('lastOverCell');

			}
		});
		this.resizeHandler = resize;
		
		//Se ajusta el tamaño inicial
		this.setMinSize();
		
		if (forceCurrentSize){
			this.resizeCell(forceCurrentSize.xSize, forceCurrentSize.ySize, true, false, true /*avoidHistory*/);			
		} else {
			this.resizeCell(this.minXSize, this.minYSize, true, false, true /*avoidHistory*/);	
		}
	},
	
	/*
	 * Función que mueve la celda origen a la celda pasada por parámetro
	 * 
	 * Se asume que:
	 * 		- se puede mover a la celda indicada.
	 * 		- en caso de mover un conjunto representa la 1era celda (1era fila, 1era, columna)
	 * 		- en caso de mover un elemento desde o hacia un elemento 'Table' no se aplica efecto  
	 */
	moveCell: function(toCell, avoidHistory, relativeElementTable, avoidEffect){
		if (!toCell) return;
		
		var moveEffect;
		var current=this;
		if (!avoidEffect && !(toCell.isTable() && toCell.mainCell!=current) && !current.isTableElement){
			moveEffect = new Fx.Move(current.element,{
				   relativeTo: toCell.element,
				   duration: 300,
				   position: 'upperLeft',
				   transition: Fx.Transitions.Sine.easeIn,
				   onComplete: function() { 
					   toCell.dispose(true /*destroyCell*/);
					   gridInfo[toCell.y][toCell.x].isEmpty=false;
					   checkHistoryStackActions();
				   }
			})
		}

		var historyElement = { action: MOVE_ACTION, destination: {}	}
		
		current.element.setStyle('z-index', '9999');
	
		if (!current.isTableElement){
			//Se crea la celda inicial (aquella ocupada previamente por el elemento)
			var initialCell = current.clone();
			var cellsToCreate = [initialCell.element];
			gridInfo[initialCell.y][initialCell.x] = {cell: initialCell, isEmpty: true};
			initialCell.resizeCell(1, 1, false, false, true/*avoidHistory*/);

			historyElement.source = {x: current.mainCell.x, y: current.mainCell.y };
			
		} else {
			var tableCell = current.mainCell.field.tableCell;
			historyElement.source = { 
					x: tableCell.x, y: tableCell.y,
					tableElementPosition: tableCell.field.tableElements.indexOf(current)
			}
		}

		//Se determina celda a borrar (aquellas que ocupará el elemento)				
		if (!toCell.isTable()){
			var cellsToDelete = [toCell.element];
		} else {
			var cellsToDelete = [current.element];
			current.resizeCell(1, 1, false, false, true/*avoidHistory*/);
			historyElement.destination.isTable = true;
		}

		var callbackMove = function(cellsToDelete, cellsToCreate, historyElement){
			if (current.isTableElement){ 
				current.field.tableCell.element.setStyle('z-index', ''); 
				//Si el origen es otra Table se debe eliminar de conjunto de elementos asociados
				current.field.removeElementFromTable(current);
			}
			
			if (toCell.isTable()){
				current.element.setStyle('z-index','');
				current.element.removeClass('cell-with-data');
				updateGridSchema(current, true /*delete*/);

				//Se agrega celda ya creada a elemento 'Table'
				current = toCell.updateElementFromTable(current);
				updateGridSchema(current, false /*add*/);
				
				historyElement.destination.x = toCell.mainCell.x
				historyElement.destination.y = toCell.mainCell.y
				
			} else {
				if (current.isTableElement){
					updateGridSchema(current, true /*delete*/);
					
					//Se redibuja la celda fuera de elemento 'Table'.
					//Se agrega handler para redimensionar y eventos según corresponda
					current.convertToGridElement(toCell.grid, toCell.x, toCell.y);
					current.element.addClass('cell-with-data');
					current.makeResizable(null, null, droppableElements, null, true /*redrawField*/);
					makeDraggableInstances(current.element.getElement('.cell-container'), true /*moveElement*/);
					
					updateGridSchema(current, false /*add*/);
					//Se mueve la misma celda actualizada, es necesario hacerla droppable
					var cellsToCreate = [current.element];
				}
				
				//Se actualiza posición y tamaño de la celda
				current.x=toCell.x;
				current.y=toCell.y;
				gridInfo[current.y][current.x].cell = current;
				
				for(var y=0; y<current.ySize; y++) {
					for(var x=0; x<current.xSize; x++) {
						gridInfo[current.y+y][current.x+x].isEmpty = false;
						gridInfo[current.y+y][current.x+x].cell.mainCell = current;
					}
				}
				current.element.setAttribute('data-x', current.x);
				current.element.setAttribute('data-y', current.y);
				current.element.setStyle('z-index','');	
				
				historyElement.destination.x = current.mainCell.x
				historyElement.destination.y = current.mainCell.y
			}
			
			
			
			if (relativeElementTable) { current.moveCellFromTable(relativeElementTable, true); }
						
			current.fireEvent('moveComplete',[cellsToDelete, cellsToCreate]);
			current.fireEvent('click', [null, true]);

			if (!avoidHistory){ storeAction(historyElement); }
		}
		
		//Se mueve la celda según corresponda
		if (moveEffect){
			moveEffect.start().chain(callbackMove(cellsToDelete, cellsToCreate, historyElement));
		} else {
			callbackMove(cellsToDelete, cellsToCreate, historyElement);
			checkHistoryStackActions();
		}
	},
	
	/*
	 * Función que expande y/o reduce la celda (li's) según corresponda.
	 * Se pasa por parámetro celda y la cantidad de filas (ySize)
	 * y la cantidad de columnas (xSize) que debe ocupar dicha celda.
	 * Si el parámetro force=true, se fuerza la redimensión considerando la celda de 1x1.
	 *  
	 *  Se asume que se puede redimensionar al tamaño indicado.
	 */
	resizeCell: function(xSize, ySize, force, applyEffect, avoidHistory){
		var xSizeOri = this.xSize, ySizeOri = this.ySize; 
		
		this.reduceCell(xSize, ySize, force, applyEffect);
		var newExpandSize = this.expandCell(xSize, ySize, force, applyEffect);
		
		if (applyEffect) {
			var cell=this;
			new Fx.Morph(this.element,{ 
						duration: 300, 
						transition: Fx.Transitions.Sine.easeIn,						
						onFirstStep : function(){ this.element.fireEvent('click', [null, true]); },
						onComplete : function (){ 
							if (this.isTable()) this.field.updateTableFieldSize();
							
							if (!avoidHistory){
								//Se guarda si se cambio el tamaño
								if (xSizeOri!=this.xSize || ySizeOri!=this.ySize){
									var historyElement = { 
										action: RESIZE_ACTION,
										source: {x: this.x, y: this.y},
										currentSize: {xSize: this.xSize, ySize: this.ySize},
										newSize: {xSize: xSizeOri, ySize: ySizeOri}
									}
									storeAction(historyElement);
								}
							}
							
							checkHistoryStackActions();
						}.bind(this)
					})
				.start({
					"width": newExpandSize.width + 'px',
					"height": newExpandSize.height + 'px'
				});
		} else {
			this.fireEvent('resizeComplete');	
		}
	},
	
	expandCell: function (xSize, ySize, force, returnNewSize){
		if (xSize<0 || xSize>cols) return;
		if (ySize<0 || ySize>rows) return;
		
		if (!xSize) xSize=this.xSize;
		if (!ySize) ySize=this.ySize;
		
		if (xSize>this.xSize || ySize>this.ySize || force){
			for (var y=0; y<ySize; y++){		
				for (var x=0; x<xSize; x++){
					gridInfo[this.y+y][this.x+x].isEmpty=false;	
					gridInfo[this.y+y][this.x+x].cell.mainCell=this;
				}
			}
			
			return this.updateSize(xSize, ySize, true, returnNewSize);			
		}
	},

	reduceCell: function (xSize, ySize, force, returnNewSize){
		if (xSize<0 || xSize>cols) return;
		if (ySize<0 || ySize>rows) return;
		
		if (!xSize) xSize=this.xSize;
		if (!ySize) ySize=this.ySize;
		
		if (this.xSize>xSize || force){
			for (var i=this.xSize; i>xSize; i--){
				for (var j=0; j<this.ySize; j++){
					var currentCell = gridInfo[this.y+j][this.x+i-1];
					currentCell.isEmpty=true;
					currentCell.cell.mainCell=currentCell.cell;
				}
			}
			
			var newXSize = this.updateSize(xSize, null, true, returnNewSize);
		}
		
		if (this.ySize>ySize || force){
			for (var j=this.ySize; j>ySize; j--){
				for (var i=0; i<this.xSize; i++){
					var currentCell = gridInfo[this.y+j-1][this.x+i];
					currentCell.isEmpty=true;
					currentCell.cell.mainCell=currentCell.cell;	
				}
			}
			
			var newYSize = this.updateSize(null, ySize, true, returnNewSize);
		}
		
		if (returnNewSize) {
			return { width : newYSize.width, height: newXSize.height }
		}
	},
	
	clone: function(fullClone, avoidGrid){
		var clone = new GridCell(this.x, this.y, (!avoidGrid? this.grid : null), this.options, this.isTableElement);
		clone.xSize=this.xSize;
		clone.ySize=this.ySize;
		if (fullClone && this.field){ clone.field = this.field.clone(true); }
		return clone;
	},
	
	getNextRowCell: function(count){
		try {
			var next = gridInfo[this.y+count][this.x].cell;
			if (next.isLayoutOption()){
				return null;
			}
			return next;
		} catch (err) {
			return null;
		}
	},
	
	getNextColumnCell: function(count){
		try {
			var next = gridInfo[this.y][this.x+count].cell;
			if (next.isLayoutOption()){
				return null;
			}
			return next;
		} catch (err) {
			return null;
		}
	},
	
	/*
	 * Devuelve la celda partiendo de la actual y aplicando el 'offset' correspondiente.
	 * Se devuelve un hash con la celda resultado y además se incluye información 
	 * del offset pendiente
	 */
	getCell: function(offset){
		var cellOffset = {cell: this, offset : {x:0, y:0}};
		
		var next=cellOffset.cell;		
		if (offset && offset.y>0){
			cellOffset.offset.y = offset.y;
			for (var y=0; y<offset.y; y++){
				
				var next = next.getNextRowCell(-1); 
				if (next){
					cellOffset.offset.y--;
					cellOffset.cell = next;
				} else {
					break;
				}
			}
		}
		
		next=cellOffset.cell;
		if (offset && offset.x>0){
			cellOffset.offset.x = offset.x;
			for (var x=0; x<offset.x; x++){
				
				var next = next.getNextColumnCell(-1); 
				if (next){
					cellOffset.offset.x--;
					cellOffset.cell = next;
				} else {
					break;
				}
			}
		}
		
		return cellOffset;
	},
	
	isEmpty: function(){
		return this.element.getChildren().length==0 &&
				gridInfo[this.y][this.x].isEmpty;
	},
	
	/*
	 * Verifica que haya espacio suficiente para mover otra celda a la actual.
	 * Se indica el tamaño requerido en los parámetros.
	 * En caso de que la o las celdas destino pertenezcan a 'parentCell' se permite.
	 */
	checkEmptyCells: function(xSize, ySize, parentCell) {
		if (this.isLayoutOption()) {
			return [false, ERROR_CODE_OUT_OF_RANGE];
		}
		
		return this.applyFunction(function(iterCell){
					return iterCell.belongsTo(parentCell) || iterCell.isEmpty();
			}, xSize, ySize, true);
	},
	
	isLayoutOption: function() {
		return this.x==0 || this.y==0;
	},
	
	belongsTo: function (other){
		if (!other) return false;
		
		return (this.x>=other.x && this.x<(other.x+other.xSize)) &&
			 (this.y>=other.y && this.y<(other.y+other.ySize));
	},
	
	getOffsetSelection: function(event){		
		var pos = this.element.getPosition();
		var offset = {
				'x' : Math.floor( (event.page.x - pos.x) / CELL_WIDTH ),
				'y' : Math.floor( (event.page.y - pos.y) / CELL_HEIGHT )
		};
		return offset;
	},
	
	getMouseOffsetSelection: function(mouse){		
		var pos = this.element.getPosition();
		var offset = {
				'x' : Math.floor( (mouse.now.x - pos.x) / CELL_WIDTH ),
				'y' : Math.floor( (mouse.now.y - pos.y) / CELL_HEIGHT )
		};
		return offset;
	},
	
	updatePosition: function(x, y){
		if (x){
			this.x=x;
			this.element.setAttribute('data-x', x);
			this.element.style.left = CELL_LAYOUT_OPT_SIZE + (x-1) * (CELL_WIDTH + CELL_BORDER) + 'px';
		}
		if (y){
			this.y=y;
			this.element.setAttribute('data-y', y);
			this.element.style.top = CELL_LAYOUT_OPT_SIZE + (y-1) * (CELL_HEIGHT + CELL_BORDER) + 'px';
		}
	},
	
	updateSize: function(xSize, ySize, updateResizeContainerSize, returnNewSize){
		var newSize = {width : this.element.getWidth(), height : this.element.getHeight()}
		
		if (xSize){
			this.xSize=xSize;
			newSize.width = (CELL_WIDTH*xSize + CELL_BORDER*(xSize-1));
			if (!returnNewSize)
				this.element.style.width = newSize.width + 'px';	
		}
		if (ySize){
			this.ySize=ySize;
			newSize.height = (CELL_HEIGHT*ySize + CELL_BORDER*(ySize-1));
			if (!returnNewSize)
				this.element.style.height = newSize.height + 'px';	
		}
		
		this.updatePosition(this.x, this.y);
			
		if (this.resizeHandler){
			this.resizeHandler.setHandlerPosition(newSize.width-CELL_BORDER, newSize.height-CELL_BORDER);

			if (updateResizeContainerSize) { this.resizeHandler.setContainerSize(CELL_WIDTH, CELL_HEIGHT); }
		}
			
		if (returnNewSize) return newSize;
	},
	
	dispose: function(destroyCell, avoidLoadGridSchema){
		if (this.isTableElement){
			this.field.removeElementFromTable(this);
			this.element.destroy();
		} else {
			this.element.empty();
			this.element.removeClass('cell-with-data');
			this.element.removeClass('selected-cell');
			if (destroyCell) this.element.destroy();
			
			//Se resetea la celda
			this.resizeCell(1, 1);
			
			//Se elimina el elemento asociado
			if (this.field){
				this.field.dispose(avoidLoadGridSchema);
				this.field=null;
			}
						
			this.mainCell=this;
			gridInfo[this.y][this.x].isEmpty=true;
		}
	},
	
	
	/*
	 * Aplica la function pasada por parámetro a la celda actual, y a todas
	 * aquellas celdas contiguas según los tamaños indicados.
	 * 
	 * Si el parámetro 'checkFunctionReturn==true', se utiliza el resultado de la 
	 * invocación como condición de la iteración. Además se devuelve el siguente arreglo:
	 * 		result = [functionReturn, errorCode]
	 *  
	 */
	applyFunction: function(_function, xSize, ySize, checkFunctionReturn, reverse, forceFullScan){
		if(!_function) return null;
		
		if (!xSize) xSize=1;
		if (!ySize) ySize=1;

		var errorCode=0;		
		var iterCell = iterRow = this;
		
		if (reverse) {
			var x = xSize, y = ySize;
			var step = -1;
			var iterRowCond = y>0;		
			var iterColCond = x>0;	
		} else {
			var x = 0, y = 0;
			var step = 1;
			var iterRowCond = y<ySize;
			var iterColCond = x<xSize;
		}
		
		while(iterRowCond){			
			while(iterColCond){
				if (!iterCell){
					errorCode=ERROR_CODE_OUT_OF_RANGE;
					if (!forceFullScan){iterColCond = iterRowCond = false;}
					break;
				}
				
				//Se determina si se utiliza el resultado de la función como condición de la iteración
				var functionReturn = _function(iterCell);
				if (checkFunctionReturn && functionReturn == false){
					errorCode=ERROR_CODE_USED_CELL;
					if (!forceFullScan){iterColCond = iterRowCond = false;}
				}
				
				if (iterColCond) {								
					iterCell = iterCell.getNextColumnCell(step);
					if (x!=(xSize-step) && !iterCell){
						errorCode=ERROR_CODE_OUT_OF_RANGE;
						if (!forceFullScan){iterColCond = iterRowCond = false;}
					}
					x += step;
					iterColCond = (reverse? x>0 : x<xSize);
				}
			}
			
			if (iterRowCond){				
				iterCell = iterRow.getNextRowCell(step)
				if (y!=(ySize-step) && iterCell){
					iterRow = iterCell;
					if (!iterCell) errorCode=ERROR_CODE_OUT_OF_RANGE;
				}
				y += step;
				iterRowCond = (reverse? y>0 : y<ySize);
				
				//Se setean variables para próxima iteración
				if (reverse) {
					x = xSize;		
					iterColCond = x>0;	
				} else {
					x = 0;		
					iterColCond = x<xSize;
				}
			}

		}
		
		if (checkFunctionReturn){
			return [functionReturn, errorCode];			
		}
	},
	
	setAttribute: function(attId, attName, attLabel){
		this.field.setAttribute(attId, attName, attLabel);
		updateGridSchemaLabel(this);
		
		//Se verifica propiedades de todas las celdas
		var current=this;
		gridSchema.each(function(cell){
			checkCellProperties(cell, null, current!=cell);
		})
	},
	
	/*
	 * Caso de elemento 'Table': se agrega un nuevo elemento contenido
	 */
	addElementToTable: function(fieldType, fieldId, x, y){
		if (!this.isTable()) return;
		
		return this.mainCell.field.addElementToTable(this.mainCell, fieldType, false, fieldId, x, y);		
	},
	updateElementFromTable: function(cellToUpdate){
		if (!this.isTable()) return;
		
		return this.mainCell.field.addElementToTable(this.mainCell, null, cellToUpdate);		
	},	
	isTable: function(){
		return this.mainCell.field && this.mainCell.field.isTable()
			&& this.mainCell.element.getChildren().length>0;
	},
	containElement: function(element){
		if (!this.isTable()) return false;
		
		return this.mainCell.field.containElement(element);
	},
	convertToTableElement: function(grid, addStyleClass){		
		//Se actualiza elemento
		this.element.destroy();
		
		this.initialize(null, null, grid, this.options, true /*isTableElement*/, addStyleClass);
	},
	convertToGridElement: function(grid, x, y, addStyleClass){		
		//Se actualiza elemento
		this.element.destroy();

		this.initialize(x, y, grid, this.options, false, addStyleClass);
	},
	moveCellFromTable: function(relative, avoidHistory){
		if (!this.isTableElement) return;
		
		if (this == relative) return;

		var tableCell = this.field.tableCell;
		var historyElement = {
				action : MOVE_TABLE_ELE_ACTION,
				source: {x: tableCell.x, y: tableCell.y},
				tableElementPosition: tableCell.field.tableElements.indexOf(this),
				tableRelativeElementPosition: tableCell.field.tableElements.indexOf(relative)
		}
		
		//Se determina si debe ser insertado antes o después
		var where = this.element.getAllPrevious().contains(relative.element) ? 'before' : 'after';						
		this.element.inject(relative.element, where);
		
		tableCell.field.moveCellFromTable(this, relative);
				
		if (!avoidHistory){
			storeAction(historyElement);
		}
		
		checkHistoryStackActions();
	},
	setX: function(x){
		this.x=x;
		this.element.setAttribute('data-x', x);
	},
	setGrid: function(grid){
		if (grid) {
			this.grid=grid;
			this.element.inject(grid);
		}
	},
	setMinSize: function(){
		if (!this.field) return;
		
		var mins = getMinFieldSize(this.field.fieldType);
		this.minXSize = mins[0];
		this.minYSize = mins[1];
	},
	
	redrawField: function(itemCell, updateCurrent, keepProperties){
		if (this.field){
			//Se actualiza celda (control para undo/redo)
			this.field.cell = this;
			var currentField = this.field.clone(true);			
			
			var attLabel = this.field.attLabel;
			this.field.fieldLabel = attLabel;

			if (this.isTableElement){				
				if (updateCurrent){	this.element.getElement('.table-element').empty(); }
				this.field.initializeLabelTableElement(this.element, null, true);
				if (!itemCell){ itemCell = this.element.getElement('.grid-element'); }
				this.field.initializeElement(itemCell, true);
			} else {
				if (!itemCell){ itemCell = this.element.getElement('.item-cell'); }
				if (updateCurrent){	itemCell.empty(); }
				
				this.field.initializeLabelElement(itemCell);
				this.field.initializeElement(itemCell);
			}
			
			//Se actualiza label con atributo
			if (attLabel){
				this.field.setLabelText(attLabel);
				this.field.fieldLabel = this.field.attName;
			}
			
			//Se copia properties actuales
			if (keepProperties){ 
				copyProperties(currentField.properties, this.field.properties, ['type']);
			}
		}
	}
})


/*
 * ***** FUNCIONES AUXILIARES *****
 */
function createCell(x, y, grid, isTableElement, addStyleClass){
	/*
	 * Layout option cells
	 */
	if (x==0 && y==0) {
		var cell =  new GridCell(x, y, grid, {
			classes  	: 'layout-option layout-option-left layout-option-top',
			onMouseMove	: onMouseMoveAction
		});
	} else if (x==0) {
		var cell =  new GridCell(x, y, grid, {
			classes  	: 'layout-option layout-option-left',
			onClick  : function (e, force){
				if (e){ e.stop(); };				
				clearAllSelectedCells();
			},
			onMouseMove	: onMouseMoveAction
		});			
	} else if (y==0){
		var cell =  new GridCell(x, y, grid, {
			classes  	: 'layout-option layout-option-top',
			onClick  : function (e, force){
				if (e){ e.stop(); };				
				clearAllSelectedCells();
			},
			onMouseMove	: onMouseMoveAction
		});	
		
		
	} else {
		var cell = new GridCell(x, y, grid, {
			classes  : 'drop',
			onClick  : function (e, force, forceMove, dontAvoidPropSetScroll, scrollToProperty){
				if (e){ e.stop(); };
				
				if (this.isEmpty()){
					clearAllSelectedCells();
				} else {
					/*
					 * Se hace focus para soporte de evento keyup.
					 * En caso de elementos de 'Table' se evita por error en hScroll
					 */
					if (!this.isTableElement){	this.element.focus(); }
					
					selectCellAction(this.element, true, true /*force*/);
					loadProperties(this, dontAvoidPropSetScroll, scrollToProperty);
					selectGridSchemaRow(null, this, [null, false, forceMove]);
					if (this.isTableElement && (e || forceMove)){
						this.field.moveTableScrollToElement(this);
					}
				}
			},
			onDelete : function(e, force, avoidHistory, forceDispose, cascadeAction, onlyUndoAction){
				if (force || this.element.hasClass('selected-cell')){
					updateGridSchema(this, true /*delete*/);
					
					if (!avoidHistory){
						var historyElement = { 
							action: DELETE_ACTION,
							cell: this.clone(true /*fullClone*/, true),
							currentSize: {xSize: this.xSize, ySize: this.ySize}
						}
						if (cascadeAction){ historyElement.cascadeAction = cascadeAction; }
						if (onlyUndoAction){ historyElement.onlyUndoAction = onlyUndoAction; }
						
						if (this.isTableElement){
							var tableCell = this.mainCell.field.tableCell;
							historyElement.source = {x: tableCell.x, y: tableCell.y};
							historyElement.tableElementPosition = tableCell.field.tableElements.indexOf(this);
						} else {
							historyElement.source = {x: this.mainCell.x, y: this.mainCell.y};
							
							if (this.isTable() && this.mainCell.field.tableElements){
								historyElement.tableElements = this.mainCell.field.tableElements.map(function(ele){
									return ele.clone(true /*fullClone*/, true);
								})
							}
						}
						storeAction(historyElement);
						
						this.dispose(forceDispose);
						
					} else {
						this.dispose(forceDispose || this.isTableElement);
					}					
					
					//Se verifica propiedades de todas las celdas
					var current=this;
					gridSchema.each(function(cell){
						checkCellProperties(cell, null, current!=cell);
					})
					
					clearAllSelectedCells();
					
					checkHistoryStackActions();
				}
			},
			
			/* Funciones de acciones definidas globales */
			onMouseMove 		: onMouseMoveAction,				
			onResizeComplete	: onModifyAction,
			onMoveComplete 	 	: onModifyAction
			
		}, isTableElement, addStyleClass);
	}
	
	return cell;
}

function getGridCell(element) {
	try {
		var x = element.getAttribute('data-x');
		var y = element.getAttribute('data-y');
		
		return gridInfo[y][x].cell;
	} catch (err){
		return null;
	}
}

function toggleElementContainerStyle(cell, parentCell, addStyle, offset, onResize, validElement, forceFullScan){
	var xSize = parentCell? parentCell.xSize : cell.xSize;
	var ySize = parentCell? parentCell.ySize : cell.ySize;
	var cellOffset = cell.getCell(offset);
		
	cellOffset.cell.applyFunction(
		function(iterCell){	
			toggleCellStyle(iterCell, parentCell, addStyle, onResize, null, validElement); },				
		xSize-cellOffset.offset.x, ySize-cellOffset.offset.y, null, null, forceFullScan
	);
}

function toggleCellStyleWithSize(cell, parentCell, addStyle, onResize, draggingAttribute, xSize, ySize, validElement){
	cell.applyFunction(
		function(iterCell){	toggleCellStyle(iterCell, parentCell, addStyle, onResize, draggingAttribute, validElement); },				
		xSize, ySize
	);
}

function toggleCellStyle(cell, parentCell, addStyle, onResize, draggingAttribute, validElement){
	if (!cell || cell.isLayoutOption()) return;
	
	var itself = cell.belongsTo(parentCell);
	if (itself) return;
	
	var element = cell.element;
	if (cell.isEmpty() || onResize){
		if (!addStyle){
			element.tween('background-color', '#FFF');
		} else {
			element.tween('background-color', draggingAttribute? HOVER_INVALID_CELL_COLOR : HOVER_CELL_COLOR);
		}
	} else {
		var resizable = cell.mainCell.element.getElement('.resizable-container');
		if (!resizable) return;
		
		if (draggingAttribute==false || !validElement || (!draggingAttribute && !cell.isTable())
				|| (draggingAttribute && !isValidAttributeField(cell.mainCell.field.fieldType))){
			var classToCheck = 'invalid'; 
		} else {
			//cualquier otro caso (dragging, tables)
			var classToCheck = 'valid';
		}
		
		if (!addStyle){
			resizable.removeClass('valid');
			resizable.removeClass('invalid');
		} else {
			resizable.addClass(classToCheck);
		}
	}	
}
function initGridHeight(){
	var initialHeight = CELL_LAYOUT_OPT_SIZE + (rows-1)*CELL_BORDER + (rows)*CELL_HEIGHT;
	initialHeight += CELL_LAYOUT_OPT_SIZE; /*padding-bottom*/
	grid.setStyle('height', initialHeight + 'px');
}
function updateGridHeight(deleteRow){
	var currentHeight = grid.getHeight();
	if (deleteRow){
		grid.setStyle('height', currentHeight - CELL_BORDER - CELL_HEIGHT + 'px');	
	} else {
		grid.setStyle('height', currentHeight + CELL_BORDER + CELL_HEIGHT + 'px');
	}
}

function showGridCell(scroller, cell) {	
	//Verificar que element no este visible
	var scroll_container = scroller.scroll_target.getParent('div.grid-container');
	var visible_height = Number.from(scroll_container.getStyle('height'));
	
	var margin_top = Number.from(scroller.scroll_target.getStyle('margin-top'));
	
	if (cell.isTableElement){ cell=cell.field.tableCell; }
	
	var element = cell.element;
	var ele_y = (CELL_HEIGHT + CELL_BORDER*2) * (cell.mainCell.y);
	
	if(ele_y >= (visible_height - margin_top)) {
		//Esta abajo			
		var res = -(ele_y + CELL_HEIGHT + element.getHeight()) + visible_height;			
		var new_top = scroller.a - scroller.a * (res + scroller.b) / scroller.b;			
		scroller.setScroll(new_top);
	} else if(ele_y < - margin_top) {
		//Esta arriba
		var res = -(ele_y + element.getHeight()) + visible_height;
		var new_top = scroller.a - scroller.a * (res + scroller.b) / scroller.b;			
		scroller.setScroll(new_top);
	}
}