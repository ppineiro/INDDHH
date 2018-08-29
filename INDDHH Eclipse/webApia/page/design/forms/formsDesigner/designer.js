var minRows = 15, minCols = 4, maxCols = 8;
var rows = minRows, cols = minCols;

var grid;
var gridInfo = { }
var gridScroller;
var formProperties = { }

var droppableElements = [];

var layoutOptions = { 
	addItems 	: { left : {}, top: {} }, 
	deleteItems : { left : {}, top: {} }
}
var layoutEnable = false;

//Se utiliza para validad campos de propiedades
var frmValidator;

var firstTime=true;

var tooltipInfo;
var tooltipFX;
var topPropsFX, bottomPropsFX;

var spDesigner;

function initDesigner(){
	if (firstTime) firstTime=false;
	else return;
	
	//crear spinner de espere un momento
	spDesigner = new Spinner(document.body,{message:WAIT_A_SECOND});
	spDesigner.show(true);
		
	if(Browser.chrome) {
		$$('.gridContainerWithFilter').each(function(container){
			container.setStyle('padding-top','45px');
		})
	}
	
	/** ----------------- Se inicializa acciones sobre toolbar ------------------  **/
	var dropMenu = $('toolbar').MooDropMenu({
		openEvent : 'click',
		closeEvent: 'close',
		mouseoutDelay: 0,
		
		onOpen: function(el){			
			var moreEnable = !toBoolean($('moreBtn').getAttribute('data-enable'));
			if (moreEnable){
				$('moreBtn').addClass('more-black-icon');
				el.fade('in');
				$('moreBtn').setAttribute('data-enable', moreEnable);
			} else {
				$('moreToolbarItem').fireEvent('close');
			}
		},
		onClose: function(el){
			var moreEnable = toBoolean($('moreBtn').getAttribute('data-enable'));
			if (moreEnable){
				$('moreBtn').setAttribute('data-enable', false);
				$('moreBtn').removeClass('more-black-icon');
				el.fade('out');
			}
		},
		onInitialize: function(el){
			el.fade('hide').set('tween', {duration:500});
		}
	});
	
	$('layoutBtn').addEvent('click', function(e){
		if (e) e.stop();
		
		//Se deshabilita toolbar 'More'
		$('moreToolbarItem').fireEvent('close');
		
		layoutEnable = !toBoolean(this.getAttribute('data-enable'));
		if (layoutEnable){
			this.addClass('layout-black-icon');	
		} else {
			this.removeClass('layout-black-icon');
		}
		this.setAttribute('data-enable', layoutEnable);
		
		if (!layoutEnable){
			showLayoutOptionTop(null);
			showLayoutOptionLeft(null);	
		}
	})
	
	$('clearBtn').addEvents({
		'mousedown': function(e){
			//Se deshabilita toolbar 'More'
			$('moreToolbarItem').fireEvent('close');
			
			this.addClass('clear-black-icon');
		},
		'mouseup': function(e){
			if (gridSchema.length>0){
				showConfirm(LBL_CLEAR_FORM_TEXT, LBL_CLEAR_FORM_TITLE, 
						function(isConfirm){ if (isConfirm){ clearGridSchema(); } },
						'modalWarning');
			} else {
				this.removeClass('clear-black-icon');	
			}
		},
		'mouseout': function(e){
			this.removeClass('clear-black-icon');
		}
	})
	
	$('undoBtn').addEvents({
		'mousedown': function(e){
			if (e) { e.stop(); }
			
			if (this.getAttribute('disabled')) return;
			 
			//Se marca como disable mientra se aplica acción
			this.setAttribute('disabled', true);
			this.addClass('undo-black-icon');
			historyStackAction(true /*undo*/);			
		},
		'onActionComplete' : function(){
			this.removeClass('undo-black-icon');
			
			if (historyStack.undo.length==0){
				this.fade(0.4);
				this.setAttribute('disabled', true);
			} else {
				this.fade(1);
				this.removeAttribute('disabled');
			}
		}
	});
	$('redoBtn').addEvents({
		'mousedown': function(e){
			if (e) { e.stop(); }
			
			if (this.getAttribute('disabled')) return;
			 
			//Se marca como disable mientra se aplica acción
			this.setAttribute('disabled', true);
			this.addClass('redo-black-icon');
			historyStackAction(false /*redo*/);
		},
		'onActionComplete' : function(){
			this.removeClass('redo-black-icon');
			
			if (historyStack.redo.length==0){
				this.fade(0.4);
				this.setAttribute('disabled', true);
			} else {
				this.fade(1);
				this.removeAttribute('disabled');
			}
		}
	});
	
	
	checkHistoryStackActions();	
	/** -------------------------------------------------------------------------- **/
	
	grid = $('gridContainer');
	tooltipInfo = $('tooltipInfo');
	
	/*
	 * Se dibuja y carga información del grid
	 */
	drawGrid(cols, rows);
	droppableElements = $$('.drop');
		
	makeDraggableInstances($$('.drag'), false /*move*/);
	
	showTopOptions(true);
	showLeftOptions(true);
	
	//Se inicializa comportamiento de tabs Schema/Attributes/Properties
	$$('.tabbed ul li').addEvents({
		click : function(){
		  id = this.getAttribute('id');
		  if (id=='propsTab') return;
		  
		  $$('.tab-selectable').hide();
		  $(id+'Container').toggle();
		  
		  var clicked = this;
		  $$('.tabbed ul li').each(function(t){
			  if (t.getAttribute('id')=='propsTabMin') return;
			  if (clicked==t){
				  t.addClass('active');
				  if (t.getAttribute('id')=='schemaTab'){
					  setFilterGridSchema();
				  } else if (t.getAttribute('id')=='attsTab'){
					  setFilterAttSchema();
				  } else if (t.getAttribute('id')=='propsTabMax'){
					  propertiesScroller = addScrollTable( getPropsTable() );
				  }
			  } else {
				  t.removeClass('active');
			  }
		  })
	}});
	$("schemaTabContainer").show();
	
	//Se inicializa el validador de propiedades
	frmValidator = new FormCheck('frmData', {
		submit:false,
		display : {
			addClassErrorToField : 1,
			keepFocusOnError : 1,
			tipsPosition: 'left',
			tipsOffsetY: 0,
			tipsOffsetX: 0,
			fadeDuration : 300
		}
	})
	
	//Si inicializa grilla de esquema y atributos 
	initAttributes();
	initGridSchema();
	
	//Se carga información asociada al layout del formulario
	initFormProperties();
	
	
	/*  Se inicializa tooltip de mensajes  */
	tooltipFX= new Fx.Tween(tooltipInfo.getParent(), {
	    duration: 500,
	    property: 'opacity',
	    onComplete: function(){
	    	if (this.element.style.opacity=='0'){
	    		this.element.removeAttribute("style");
	    	}	
	    }
	});
	/* *********************************** */
	
	//onResize: se ajusta scrolls
	window.onresize = function() {
		var container = grid.getParent().getParent(); 	
		gridScroller = addHScrollDiv(container, container.getWidth(), true, 'ul', true, true);
		
		gridSchemaScroller = addScrollTable(tBodyGD);
		propertiesScroller = addScrollTable( getPropsTable() );
	}
}

function drawGrid(cols, rows){
	if (!gridInfo) return;
	
	//Se calcula el width máximo para las celdas
	var maxWidth = (grid.getWidth() - CELL_LAYOUT_OPT_SIZE - CELL_BORDER*(cols-1)) / cols; 
	if (maxWidth>0) CELL_WIDTH=maxWidth;
	
	initGridHeight();
	
	for (var x=0; x<=cols; x++) {		
		for (var y=0; y<=rows; y++) {
			if (!gridInfo[y]) gridInfo[y]={};
			if (!gridInfo[y][x]) gridInfo[y][x]={}
			
			if (!gridInfo[y][x].cell){
				var cell = createCell(x, y, grid);
				gridInfo[y][x] = { cell : cell, isEmpty : true };
			}	
		}
	}
	
	//Se agrega/actualiza scroll al container
	var container = grid.getParent().getParent(); 	
	gridScroller = addHScrollDiv(container, container.getWidth(), true, 'ul', true, true);
}

function clearAllSelectedCells(avoidCell, dontAvoidPropSetScroll){
	//Se deshabilita toolbar 'More'
	$('moreToolbarItem').fireEvent('close');
	
	grid.getElements('li').each(function(cell){
		if (avoidCell != cell){
			cell.removeClass('selected-cell');
		}
	})
	if (!avoidCell){
		loadProperties(null, dontAvoidPropSetScroll);
		unselectGridSchemaRows();
	}
}

function selectCellAction(cell, clearAll, force){
	if (!cell) return;
	
	if (clearAll) {
		clearAllSelectedCells(cell)
	}
	
	if (force || !cell.hasClass('selected-cell')){
		cell.addClass('selected-cell');
	} else {
		cell.removeClass('selected-cell');
	}
}


function makeDraggableInstances(draggablesElements, isGridElement, customCloneFunction) {
	if (!draggablesElements) return;

	
	draggablesElements.addEvent('mousedown', function(event){
		event.stop();
		
		if (customCloneFunction){
			var clone = customCloneFunction(this, event);
		} else {
			var clone = this.clone().setStyles(this.getCoordinates());
		}
		
		clone.store('parent', this)
				.addClass('ghost-container')
				.inject(document.body);
		clone.effect = new Fx.Morph(clone, {duration: 200});
		clone.hide();
		
		var tableElements=[];
		var droppables = droppableElements.clone();
		if (this.hasClass('table-element')){
			var cell = getParentCell(this.getParent('li'));
			var tableCell = cell.field.tableCell;
			var tableElements = tableCell.field.tableElements;
			if (tableElements.length>0){
				droppables.combine(tableElements.map(function(c){return c.element}));
				
				//Se agregan los botonos para avnazar/retrocer como droppables
				//para avanzar/retroceder automáticamente al pasar por encima de los mismos
				tableCell.field.makeTableScrollDroppable(droppables);
			}
		}
		
		if (isGridElement) clone.addClass('drag-and-move');
		
		var drag = new Drag.Move(clone, {
			//container : grid.getParent('.grid-layout'),

			droppables: droppables,

			onDrop: onDropAction,
			
			onStart: function(ele){
				this.element.show();
				
				//Se deshabilita toolbar 'More'
				$('moreToolbarItem').fireEvent('close');
				
				this.element.setStyle('z-index', 2);
				
				if (this.element.hasClass('drag-and-move')){
					var parent = this.element.retrieve('parent').getParent('li');
					var parentCell = getParentCell(parent);
					this.element.store('offset', parentCell.getOffsetSelection(event));
					parent.fireEvent('click', [null, true]);
					
					//Se obtiene funciones del scroll de elemento 'Table'
					if (parentCell.isTableElement){
						this.hScroll = parentCell.field.tableCell.field.hScroll;
						//Se agranda seccion de botones de scroll
						if (this.hScroll.next) this.hScroll.next.addClass('next-element-on-dragging');
						if (this.hScroll.prev) this.hScroll.prev.addClass('prev-element-on-dragging');
						
						this.nextScrollFunction = function(){
							if (this.hScroll.next) this.hScroll.next.fade(0.7);
							this.hScroll.nextSlide();
						}.bind(this);
						this.prevScrollFunction = function(){
							if (this.hScroll.prev) this.hScroll.prev.fade(0.7);
							this.hScroll.prevSlide();
						}.bind(this);
						
						this.startTableScroll = function(element){
							//Se agrega acción para avanzar/retroceder automáticamente
							if (element.hasClass('next-element') && !this.nextScrollPeriodical){						
								this.nextScrollPeriodical = this.nextScrollFunction.periodical(1000);
							}
							if (element.hasClass('prev-element') && !this.prevScrollPeriodical){						
								this.prevScrollPeriodical = this.prevScrollFunction.periodical(1000);
							}
						}
						this.stopTableScroll = function(element){
							if (this.hScroll.next) this.hScroll.next.removeClass('next-element-on-dragging');
							if (this.hScroll.prev) this.hScroll.prev.removeClass('prev-element-on-dragging');
							
							//Se detiene acción para avanzar/retroceder automáticamente
							if (element.hasClass('next-element') && this.nextScrollPeriodical){						
								clearInterval(this.nextScrollPeriodical);
								this.nextScrollPeriodical = null;
							}
							if (element.hasClass('prev-element') && this.prevScrollPeriodical){						
								clearInterval(this.prevScrollPeriodical);
								this.prevScrollPeriodical = null;
							}
						}
					}
				}
			},	
			
			onEnter: function(dragging, droppable){				
				if (droppable.hasClass('scroll-element')){
					this.startTableScroll(droppable);					
					return;
				}
								
				var droppableCell = getParentCell(droppable);
				
				if (droppableCell.isTableElement){
					//En caso de elementos de 'Table' al moverlos se actualizan
					var parent = this.element.retrieve('parent').getParent('li');
					if (parent==droppable) return;			

					getParentCell(parent).moveCellFromTable(droppableCell);
				
				} else if (this.element.hasClass('drag-and-move')){
					var parent = this.element.retrieve('parent').getParent('li');
					var offset = this.element.retrieve('offset');
					var parentCell = getParentCell(parent);
					
					var validElement = droppableCell.isTable() && 
						(droppableCell.mainCell==parentCell || isValidTableElement(parentCell.field.fieldType));
					if (droppableCell.isTable()){
						toggleCellStyle(droppableCell, null, true, null, null, validElement, true);
					} else {
						toggleElementContainerStyle(droppableCell, parentCell, true /*addStyle*/, offset, null, validElement, true);	
					}
				} else {
					var xSize = Number.from(dragging.getAttribute('data-x-size'));
					var ySize = Number.from(dragging.getAttribute('data-y-size'));
					
					if (dragging.getAttribute('data-field-type')==TYPE_GRID){
						//Se intenta con el ancho máximo de la fila actual
						var firstRowCell = gridInfo[droppableCell.y][1].cell;
						var checkResult = firstRowCell.checkEmptyCells(cols, ySize, parentCell);
						var errorCode = checkResult[1];	
						if (errorCode==0){						
							xSize=cols;
							var offset = {'x' : droppableCell.x-firstRowCell.x, 'y' : 0};
							this.element.store('offset', offset);
							droppableCell = firstRowCell;
						} else {
							this.element.eliminate('offset');
						}
						//Se almacena tamaño actual
						this.element.store('currentSize', {xSize:xSize, ySize:ySize});
					} else if (dragging.getAttribute('data-field-type')==TYPE_TITLE ||
							dragging.getAttribute('data-field-type')==TYPE_EDITOR) {
						//Se setea el máximo
						xSize=cols;
						dragging.setAttribute('data-x-size', cols);

						//Se almacena tamaño máximo
						this.element.store('currentSize', {xSize:xSize, ySize:ySize});
												
						var firstRowCell = gridInfo[droppableCell.y][1].cell;
						var offset = {'x' : droppableCell.x-firstRowCell.x, 'y' : 0};
						this.element.store('offset', offset);
						droppableCell = firstRowCell;
					}
					
					var draggingAttribute = dragging.hasClass('drag-att')? true : null;
					var validElement = isValidTableElement(dragging.getAttribute('data-field-type'));
					if (xSize>1 || ySize>1){
						toggleCellStyleWithSize(droppableCell, null, true, null, draggingAttribute, xSize, ySize, validElement);
					} else {
						toggleCellStyle(droppableCell, null, true, null, draggingAttribute, validElement);	
					}
				}
			},
			
			onLeave: function(dragging, droppable){
				if (droppable.hasClass('scroll-element')){
					this.stopTableScroll(droppable);
					return;
				}
								
				var droppableCell = getParentCell(droppable);
				
				if (this.element.hasClass('drag-and-move')){
					var parent = this.element.retrieve('parent').getParent('li');
					var offset = this.element.retrieve('offset');
					var parentCell = getParentCell(parent);
					
					if (droppableCell.isTable()){
						toggleCellStyle(droppableCell, null, false, null, null, null, true);
					} else {
						toggleElementContainerStyle(droppableCell, parentCell, false /*addStyle*/, offset, null, null, true);	
					}					
				} else {
					var xSize = Number.from(dragging.getAttribute('data-x-size'));
					var ySize = Number.from(dragging.getAttribute('data-y-size'));

					if (dragging.getAttribute('data-field-type')==TYPE_GRID){//table
						//Se intenta con el ancho máximo
						var firstRowCell = gridInfo[droppableCell.y][1].cell;
						var checkResult = firstRowCell.checkEmptyCells(cols, ySize, parentCell);
						var errorCode = checkResult[1];	
						if (errorCode==0){							
							xSize=cols;						
							var offset = {'x' : droppableCell.x-firstRowCell.x, 'y' : 0};
							this.element.store('offset', offset);
							droppableCell = firstRowCell;
						} else {
							this.element.eliminate('offset');
						}
						//Se almacena tamaño actual
						this.element.store('currentSize', {xSize:xSize, ySize:ySize});
					} else if (dragging.getAttribute('data-field-type')==TYPE_TITLE ||
							dragging.getAttribute('data-field-type')==TYPE_EDITOR) {
						//Se setea el máximo
						xSize=cols;
						dragging.setAttribute('data-x-size', cols);
						
						var firstRowCell = gridInfo[droppableCell.y][1].cell;
						droppableCell = firstRowCell;
					}
					
					var draggingAttribute = dragging.hasClass('drag-att')? true : null;
					if (xSize>1 || ySize>1){
						toggleCellStyleWithSize(droppableCell, null, null, null, draggingAttribute, xSize, ySize);
					} else {
						toggleCellStyle(droppableCell, null, null, null, draggingAttribute);	
					}
				}
			},
			
			onCancel: function(dragging){
				dragging.destroy();
			}
		});
		drag.start(event);
	});
}

onModifyAction = function(deletedCells, createdCells) {
	if (deletedCells){
		deletedCells.each(function(cell){
			droppableElements.erase(cell);	
		});
	}
	if (createdCells){
		createdCells.each(function(cell){
			droppableElements.push(cell);	
		});
	}
	
	//Se ordenan para mantener posiciones iniciales
	droppableElements.sort(function(d1, d2) {
		var x1 = Number.from(d1.getAttribute('data-x')), 
			x2 = Number.from(d2.getAttribute('data-x'));			
		
		if (x1>x2){
			return 1;
		} else if (x1==x2){
			var y1 = Number.from(d1.getAttribute('data-y')),
				y2 = Number.from(d2.getAttribute('data-y'));
			
			return y1>y2? 1 : 0;
		}
		return -1;
	});
			
	updateHandlersDroppableElements(droppableElements);

	//this.element.fireEvent('click', [null, true]);
}

onDropAction = function(clone, droppable) {
	if (clone.hasClass('drag-att')){
		onDropAttributeAction(clone, droppable);
		return;
	}
	
	var parent = clone.retrieve('parent');
	
	if (droppable) {
		if (droppable.hasClass('scroll-element')){
			this.stopTableScroll(droppable);
			
			revertDrag(clone, parent);
			return;
		}
		
		//Se obtiene la celda a cargar
		var offset = clone.retrieve('offset');	
		var droppableCell = getParentCell(droppable);
		var cellOffset = droppableCell.getCell(offset);
		var cell = cellOffset.cell;
		
		var parentCell = getParentCell(parent.getParent('li'));
		if (parentCell){
			var parentXSize = parentCell.xSize;
			var parentYSize = parentCell.ySize;
		} else {
			var parentXSize = Number.from(clone.getAttribute('data-x-size'));
			var parentYSize = Number.from(clone.getAttribute('data-y-size'));

			if (!parentXSize) parentXSize=1;
			if (!parentYSize) parentYSize=1;
		}
		var currentSize = this.element.retrieve('currentSize');
		var isTable = cell.isTable();
		
		if (cell==parentCell || (isTable && cell.containElement(parent.getParent('li'))) ){
			var element = cell.mainCell.element;
			if (element && !cell.isTableElement){ element.getElement('.resizable-container').removeClass('valid'); }
			revertDrag(clone, parent);
			return;		
		}		
		
		var fieldType  = parentCell? parentCell.field.fieldType : clone.getAttribute('data-field-type');
		
		if (cellOffset.offset.x!=0 || cellOffset.offset.y!=0){
			var errorCode = ERROR_CODE_OUT_OF_RANGE;
		} else {
			if (isTable && cell.mainCell!=parentCell){
				//Verificar que se un elemento valido para agregar al grid
				if (!isValidTableElement(fieldType) || !droppableCell.isTable()) {
					var errorCode = ERROR_CODE_USED_CELL;						
				}
			} else {
				var checkResult = cell.checkEmptyCells(parentXSize, parentYSize, parentCell);
				var functionReturn = checkResult[0]; 
				var errorCode = checkResult[1];	
			}
		}
		
		if (errorCode<0) {
			cell.applyFunction(
					function(iterCell){	toggleCellStyle(iterCell); },				
					parentXSize, parentYSize, null, null, true /*forceFullScan*/
			);
			
			showTooltipMessage(errorCode);
			revertDrag(clone, parent);
			return;				
		}

		var moveElement = clone.hasClass('drag-and-move');
		
		
		clone.destroy();
		
		if (parentCell){			
			cell.applyFunction(
				function(iterCell){ iterCell.element.tween('background-color', '', '#FFF'); },				
				parentCell.xSize, parentCell.ySize
			);
		} else {
			cell.applyFunction(
				function(iterCell){ iterCell.element.tween('background-color', '', '#FFF'); },				
				currentSize? currentSize.xSize : parentXSize,
				currentSize? currentSize.ySize : parentYSize
			);
		}
		toggleCellStyle(cell.mainCell);

		if (parentCell || !isTable){
			if (moveElement){
				parentCell.moveCell(cell);
			} else {
				gridInfo[cell.y][cell.x].isEmpty = false;
				cell.element.addClass('cell-with-data');
				
				cell.makeResizable(null/*fieldId*/, fieldType, droppableElements, currentSize);
				makeDraggableInstances(cell.element.getElement('.cell-container'), true /*moveElement*/);
				
				var historyElement = {action: CREATE_ACTION, cell: cell, source: {x: cell.x, y: cell.y } }
				storeAction(historyElement);
				
				updateGridSchema(cell, false /*add*/);
			}
			
		} else if (isTable) {
			cell = cell.addElementToTable(fieldType);
			var tableCell = cell.field.tableCell;
			tableCell.element.getElement('.resizable-container').removeClass('valid');
			
			var historyElement = {
					action: CREATE_ACTION, 
					cell: cell, 
					source: {x: tableCell.x, y: tableCell.y },
					tableElementPosition: tableCell.field.tableElements.length-1
			}
			storeAction(historyElement);
			
			updateGridSchema(cell, false /*add*/);
			
		}
		
		
	} else {
		showTooltipMessage(ERROR_CODE_OUT_OF_RANGE);
		revertDrag(clone, parent);
	}
}

onDropAttributeAction = function(clone, droppable) {
	var parent = clone.retrieve('parent');
	
	if (droppable) {
		//Se obtiene la celda a cargar
		var cellOffset = getGridCell(droppable);
		var cell = cellOffset.mainCell;

		toggleCellStyle(cell, null, null, null, true);
		
		if (cell.isEmpty()){
			showTooltipMessage(ERROR_CODE_EMPTY_CELL);
			revertDrag(clone, parent);
			return;			
		} else if (!isValidAttributeField(cell.field.fieldType)){				
			revertDrag(clone, parent);
			return;
		}
		
		var span = clone.getElement('span');
		var attId = span.getAttribute('data-id');
		var attName = span.textContent;
		var attLabel = span.getAttribute('data-label');
		cell.setAttribute(attId, attName, attLabel);
		
		clone.destroy();
		
		cell.fireEvent('click');

		
	} else {
		revertDrag(clone, parent);
	}
}

function revertDrag(clone, parent){
	var dim = parent.getStyles('width', 'height'),
		pos = clone.computePosition(parent.getPosition(clone.getOffsetParent()));

	clone.effect.start({
		top: pos.top,
		left: pos.left,
		width: dim.width,
		height: dim.height,
		opacity: 0.25
	}).chain(function(){
		clone.destroy();
	});
}

function updateHandlersDroppableElements(droppableElements){
	$each(Object.keys(gridInfo), function(y){
		$each(Object.keys(gridInfo[y]),function(x){
			var current = gridInfo[y][x].cell; 
			if (!current.isEmpty() && current.resizeHandler){
				current.resizeHandler.updateHandlersDroppableElements(droppableElements);
			}
		})
	})
}

/*
 * Funciones auxiliares para el manejo de opciones de Layout
 */
var ITEM_SIZE = 18;

function createLayoutOptionItem(top, left, additionalClasses, container){
	
	var item = new Element('div', {
		'class': 'layout-option-item',
		'styles' : {'top': top+'px', 'left': left+'px', 'width' : ITEM_SIZE + 'px', 'height' : ITEM_SIZE + 'px' }
	});
	if (additionalClasses) item.addClass(additionalClasses);
	if (container) item.inject(container);
	
	item.addEvent('click', function(e){
		if (e) e.stop();

		//Se deshabilita toolbar 'More'
		$('moreToolbarItem').fireEvent('close');
		
		var x = Number.from(this.getParent('li').getAttribute('data-x'));
		var y = Number.from(this.getParent('li').getAttribute('data-y'));
		var add = this.hasClass('add-item');
		
		if (add){
			if (parseInt(this.style.left,10)==CELL_LAYOUT_PADDING){
				addRow(y+1);
			} else {
				addColumn(x+1);
			}
		} else {
			if (parseInt(this.style.left,10)==CELL_LAYOUT_PADDING){
				deleteRow(y);
			} else {
				checkBeforeDeleteColumn(x);
			}
		}
	})
	
	return item;
}

function onModifyLayout(errorCode){
	if (errorCode<0){
		showTooltipMessage(errorCode);
		
	} else {
		checkHistoryStackActions();
		
		//Se agrega/actualiza scroll al container
		var container = grid.getParent().getParent(); 	
		gridScroller = addHScrollDiv(container, container.getWidth(), true, 'ul', true, true);
		
		updateHandlersDroppableElements(droppableElements);			
	}
}

//Agrega una fila en la posición y
function addRow(y, avoidHistory){
	var cellToResize = [];
	
	for(var x=cols; x>=0; x--){
		var cell = createCell(x, y, grid);
		if (!cell.isLayoutOption()){
			droppableElements.include(cell.element);
		}
		
		for(var iterY=rows+1; iterY>y; iterY--){			
			var iterCell = gridInfo[iterY-1][x].cell; 
			
			if (!gridInfo[iterY]) gridInfo[iterY]={};
			gridInfo[iterY][x] = { cell: iterCell, isEmpty: gridInfo[iterY-1][x].isEmpty };
			
			if (!gridInfo[iterY][x].isEmpty){
				//Se determina si se debe modificar elementos en celdas
				if (iterCell==iterCell.mainCell){
					cellToResize.erase(iterCell);
				} else {
					cellToResize.include(iterCell.mainCell);
				}
			}
			
			iterCell.updatePosition(null, iterY);
		}	
		
		if (!gridInfo[y]) gridInfo[y]={};
		gridInfo[y][x] = { cell: cell, isEmpty: true };
	}
	
	//Se redimensionan celdas si corresponde
	cellToResize.each(function(cell){
		cell.resizeCell(null, cell.ySize+1, true, false, true /*avoidHistory*/);
	})
	
	rows++;
	updateGridHeight();
	
	showLeftOptions(true);
	
	if (!avoidHistory){
		var historyElement = {action: ADD_ROW_ACTION, y: y}
		storeAction(historyElement);
	}	
	
	onModifyLayout(0);
}

//Agrega una columna en la posición x
function addColumn(x, avoidHistory){
	CELL_WIDTH = (CELL_WIDTH * cols - 2/*margin adicional*/) / (cols+1);
	
	var cellToResize = [];
	var cellToMove = [];
	
	for(var y=rows; y>=0; y--){
		for(var iterX=cols+1; iterX>0; iterX--){
			var iterCell = gridInfo[y][iterX-1].cell;
			
			if (iterX>x){				
				if (!gridInfo[y]) gridInfo[y]={};
				gridInfo[y][iterX] = { cell: iterCell, isEmpty: gridInfo[y][iterX-1].isEmpty };
				
				if (!gridInfo[y][iterX].isEmpty){
					//Se determina si se debe modificar elementos en celdas
					if (iterCell==iterCell.mainCell){
						cellToResize.erase(iterCell);
					} else {
						cellToResize.include(iterCell.mainCell);
					}
				}				
				iterCell.updatePosition(iterX, null);
				
			} else if (iterX==x) {
				var cell = createCell(x, y, grid);
				if (!cell.isLayoutOption()){
					droppableElements.include(cell.element);
				}
				gridInfo[y][x] = { cell: cell, isEmpty: true };
				
				//Control para elementos con ancho máximo: TITLE, EDITOR
				if (iterX==cols+1 && !gridInfo[y][iterX-1].isEmpty) { //Caso máximo
					if (iterCell.mainCell.field.fieldType == TYPE_EDITOR || iterCell.mainCell.field.fieldType == TYPE_TITLE){
						cellToResize.include(iterCell.mainCell);					
					}
				} else if (iterX==1 && !gridInfo[y][iterX+1].isEmpty){//Caso mínimo
					var currentCell = gridInfo[y][iterX+1].cell.mainCell;					
					if (currentCell.field.fieldType == TYPE_EDITOR || currentCell.field.fieldType == TYPE_TITLE){
						cellToMove.include(currentCell);
						cellToResize.include(currentCell);	
					}
				}
			}

			iterCell.updateSize(iterCell.xSize, null, true);
		}				
	}

	cols++;
	
	//Se mueven celda un lugar a la izquierda
	cellToMove.each(function(cell){
		var toCell = cell.getNextColumnCell(-1);
		cell.moveCell(toCell, true /*avoidHistory*/, null, true);
		cell.updatePosition(1, null);
		toCell.element.destroy();
	})
	
	//Se redimensionan celdas si corresponde
	cellToResize.each(function(cell){
		cell.resizeCell(cell.xSize+1, null, true, false, true /*avoidHistory*/);
	})	
	
	showTopOptions(true);
	
	if (!avoidHistory){
		var historyElement = {action: ADD_COL_ACTION, x: x}
		storeAction(historyElement);
	}
	
	onModifyLayout(0);
}

function deleteRow(y, avoidHistory){
	//Control al eliminar fila, si está ocupada no se elimina
	for(var x=cols; x>0; x--){
		if (!gridInfo[y][x].cell.isEmpty()){
			onModifyLayout(ERROR_CODE_USED_CELL);
			return;
		}	
	}
	
	var cellToResize = [];
	for(var x=cols; x>=0; x--){
		for(var iterY=1; iterY<=rows; iterY++){
			var iterCell = gridInfo[iterY][x].cell;
			
			if (iterY>y){
				gridInfo[iterY-1][x] = { cell: iterCell, isEmpty: gridInfo[iterY][x].isEmpty };
				iterCell.updatePosition(null, iterY-1);
			} else if (iterY==y) {
				if (!gridInfo[iterY][x].isEmpty){
					//Se determina si se debe modificar elementos en celdas
					if (iterCell!=iterCell.mainCell){
						cellToResize.include(iterCell.mainCell);
					}
				}
				
				droppableElements.erase(iterCell.element);
				if (iterCell.isLayoutOption()){ 
					iterCell.dispose(true);
				} else {
					iterCell.fireEvent('delete', [null, true, true /*avoidHistory*/, true]);
				}
			}
		}				
	}
	
	//Se redimensionan celdas si corresponde
	cellToResize.each(function(cell){
		cell.resizeCell(null, cell.ySize-1, true, false, true /*avoidHistory*/);
	})
	
	rows--;
	updateGridHeight(true /*deleteRow*/);
	
	showLeftOptions(true);
	
	if (!avoidHistory){
		var historyElement = {action: DEL_ROW_ACTION, y: y}
		storeAction(historyElement);
	}
	onModifyLayout(0);
}

function checkBeforeDeleteColumn(x){
	//Control al eliminar columna, si está ocupada se alerta 
	//y si tiene ancho mínimo no se elimina
	var emptyColumn=true;
	for(var y=rows; y>0; y--){
		var currentCell = gridInfo[y][x].cell; 
		if (!currentCell.isEmpty()){
			if (currentCell.x!=currentCell.mainCell.x && currentCell.mainCell.minXSize>1 && 
					currentCell.mainCell.xSize==currentCell.mainCell.minXSize){
				showMessage(LBL_MIN_WIDTH_REACHED, LBL_DEL_COLUMN, 'modalWarning');
				return;
			} 
			if (currentCell.x!=currentCell.mainCell.x && 
					(currentCell.mainCell.field.fieldType == TYPE_EDITOR || 
							currentCell.mainCell.field.fieldType == TYPE_TITLE)){
				continue;
			}
			
			emptyColumn=false;
			break;
		}	
	}
	
	if (!emptyColumn){
		showConfirm(LBL_COL_WITH_FIELDS, LBL_DEL_COLUMN, 
			function(isConfirm){ if (isConfirm){ deleteColumn(x); } },
			'modalWarning');
	} else {
		deleteColumn(x);
	}
}

function deleteColumn(x, avoidHistory){
	CELL_WIDTH = (CELL_WIDTH * cols + 2/*margin adicional*/) / (cols-1);
	
	var cellToResize = [];
	for(var y=0; y<=rows; y++){
		for(var iterX=1; iterX<=cols; iterX++){
			var iterCell = gridInfo[y][iterX].cell;
			
			if (iterX>x){
				gridInfo[y][iterX-1] = { cell: iterCell, isEmpty: gridInfo[y][iterX].isEmpty };
				iterCell.updatePosition(iterX-1, null);
			} else if (iterX==x) {
				if (!gridInfo[y][iterX].isEmpty){
					//Se determina si se debe modificar elementos en celdas
					if (iterCell!=iterCell.mainCell){
						cellToResize.include(iterCell.mainCell);
					}
				}
				
				droppableElements.erase(iterCell.element);
				if (iterCell.isLayoutOption()){ 
					iterCell.dispose(true);
				} else {
					//Se indica para eliminar en cascada. Usado para undo/redo
					iterCell.fireEvent('delete', [null, true, avoidHistory, true, y!=1 /*cascadeAction*/, true /*onlyUndoAction*/]);
				}
			}

			iterCell.updateSize(iterCell.xSize, null, true);
		}				
	}
	
	cols--;
	
	//Se redimensionan celdas si corresponde
	cellToResize.each(function(cell){
		cell.resizeCell(cell.xSize-1, null, true, false, true /*avoidHistory*/);
	})
	
	showTopOptions(true);
	
	if (!avoidHistory){
		var historyElement = {action: DEL_COL_ACTION, x: x, cascadeAction: true}
		storeAction(historyElement);
	}
	onModifyLayout(0);
}

function showTopOptions(clearAll){
	if (clearAll){
		for (var i=0; i<=cols; i++){
			if (layoutOptions.addItems.top[i]){
				layoutOptions.addItems.top[i].dispose();
			}
			if (layoutOptions.deleteItems.top[i]){
				layoutOptions.deleteItems.top[i].dispose();
			}
		}
	}

	for (var i=1; i<=cols; i++){
		var position = (CELL_WIDTH - ITEM_SIZE) / 2;
		layoutOptions.deleteItems.top[i] = createLayoutOptionItem(CELL_LAYOUT_PADDING, position, 'delete-item', gridInfo[0][i].cell.element);
	}
	
	for (var i=0; i<=cols; i++){
		var position = (i==0? CELL_LAYOUT_OPT_SIZE : CELL_WIDTH) - (ITEM_SIZE/2);
		layoutOptions.addItems.top[i] = createLayoutOptionItem(CELL_LAYOUT_PADDING, position, 'add-item', gridInfo[0][i].cell.element);
	}
}

function showLeftOptions(clearAll){
	if (clearAll){
		for (var i=0; i<=rows; i++){
			if (layoutOptions.addItems.left[i]){
				layoutOptions.addItems.left[i].dispose();	
			}
			if (layoutOptions.deleteItems.left[i]){
				layoutOptions.deleteItems.left[i].dispose();	
			}
		}
	}

	for (var i=1; i<=rows; i++){
		var position = (CELL_HEIGHT - ITEM_SIZE) / 2;
		layoutOptions.deleteItems.left[i] = createLayoutOptionItem(position, CELL_LAYOUT_PADDING, 'delete-item', gridInfo[i][0].cell.element); 
	}
	
	for (var i=0; i<=rows; i++){
		var position = (i==0? CELL_LAYOUT_OPT_SIZE : CELL_HEIGHT) - (ITEM_SIZE/2);
		layoutOptions.addItems.left[i] = createLayoutOptionItem(position, CELL_LAYOUT_PADDING, 'add-item', gridInfo[i][0].cell.element); 
	}
}

onMouseMoveAction = function(event){
	if (!layoutEnable){	return;	}
	
	var x = Number.from(this.x);
	var y = Number.from(this.y);
	var ele_pos = this.element.getPosition();
	
	if (x==0){
		var addColumn = 0;
		var delColumn = 1;
	} else {			
		var mouse_pos_x = Math.abs(event.page.x - ele_pos.x); 
		var half_width = this.element.getWidth() / 2 / this.xSize;	
		var half_grid_column = Math.floor(mouse_pos_x / half_width);
		var addColumn = half_grid_column + x - 1;	
		var delColumn = this.getOffsetSelection(event).x + x;
		
		if (this.xSize>1) {
			var offset = Math.floor(mouse_pos_x / (half_width*2));
			addColumn -= offset;
	    } else if (mouse_pos_x >= half_width*2){/*border*/
	    	addColumn--;
	    }
	}
	showLayoutOptionTop(addColumn, delColumn);
	
	
	if (y==0){
		var addRow = 0;
	} else {
		var mouse_pos_y = Math.abs(event.page.y - ele_pos.y); 
		var half_height = this.element.getHeight() / 2 / this.ySize;	
		var half_grid_row = Math.floor(mouse_pos_y / half_height);
		var addRow = half_grid_row + y - 1;
		var delRow = this.getOffsetSelection(event).y + y;
		
		if (this.xSize>1) {
			var offset = Math.floor(mouse_pos_y / (half_height*2));
			addRow -= offset;
	    } else if (mouse_pos_y >= half_height*2){/*border*/
	    	addRow--;
	    }
	}
	showLayoutOptionLeft(addRow, delRow);
    	
}

function showLayoutOptionTop(addColumnToCompare, delColumnToCompare){
	for (var i=0; i<=cols; i++){
		var addItem = layoutOptions.addItems.top[i];
		if (i==addColumnToCompare && cols<maxCols){
			addItem.addClass('show-item');			
		} else {
			addItem.removeClass('show-item');
		}
		
		var delItem = layoutOptions.deleteItems.top[i];
		if (!delItem) continue;
		
		if (i==delColumnToCompare && minCols<cols){
			delItem.addClass('show-item');
		} else {
			delItem.removeClass('show-item');
		}
	}
}

function showLayoutOptionLeft(addRowToCompare, delRowToCompare){
	for (var i=0; i<=rows; i++){
		var addItem = layoutOptions.addItems.left[i];
		if (i==addRowToCompare){
			addItem.addClass('show-item');
		} else {
			addItem.removeClass('show-item');
		}
		
		var delItem = layoutOptions.deleteItems.left[i];
		if (!delItem) continue;
		
		if (i==delRowToCompare && minRows<rows){
			delItem.addClass('show-item');
		} else {
			delItem.removeClass('show-item');
		}
	}
}

function getParentCell(parent){
	if (!parent) return null;
	
	if (parent.hasClass('table-element')){
		//Se filtra por todos los elementos del elemento 'Table'
		parentGrid = parent.getParent('li');
		var parentGridCell = getGridCell(parentGrid);
		
		var filterCell = parentGridCell.field.tableElements.filter(function(cell){
			if (cell.element==parent) return cell;
		})
		if (filterCell) return filterCell[0];
		
	} else {
		var parentCell = getGridCell(parent);
	}
	
	return parentCell;
}

function showTooltipMessage(errorCode, message){
	//Se cancela efecto actual/pendiente
	tooltipFX.cancel();
	
	if (!message){
		switch (errorCode) {
		case ERROR_CODE_USED_CELL: message = LBL_CELL_OCCUPIED; break;
		case ERROR_CODE_OUT_OF_RANGE: message = LBL_OUT_OF_BOUNDS; break;
		case ERROR_CODE_MINIMUM_SIZE: message = LBL_MIN_NOT_REACHED; break;
		case ERROR_CODE_EMPTY_CELL: message = LBL_CELL_EMPTY; break;
		}
		if (!message) return;
	}
	
	tooltipInfo.innerHTML = message;
	
	tooltipInfo.getParent().show();
	tooltipFX.start(0, 1);
	
	//Se espera para ocultar
	(function(){ tooltipFX.start(1, 0); }).delay(1500);
}
