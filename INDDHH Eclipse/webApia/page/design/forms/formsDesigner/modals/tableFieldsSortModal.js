var container;
var droppableElements;
var hScroll;

function initPage(){
	
	var currentCell = parent.currentFieldProperty;
	container = currentCell.element.getElement('.table-element-container').clone();
	container.inject( $('tableContainer') );

	droppableElements = container.getElements('li');
	
	hScroll = new slideGallery(container, {
		steps: 2,
		mode: 'line',
		holder: '.hScrollContainer',
		nextItem: '.next-element',
		prevItem: '.prev-element',
		nextDisableClass: 'scroll-element-disable',
		prevDisableClass: 'scroll-element-disable',
		slideMouseAction: 'mousedown'
	})
	
	//Se inicializa eventos de seleccionar/des-seleccionar celdas
	droppableElements.addEvent('click', function(e){
		if (e) { e.stop(); }		
		selectAction(this, true, true);
	})
	$('gridContainerMdlData').addEvent('click', function(e){
		if (e) { e.stop(); }		
		clearAllSelected();
	})
	clearAllSelected();
	
	//Se inicializa controles para evento 'mousewheel'
	setHscrollTimerFunction(container, null, 50 /*delay*/);	
	
	container.addEvent('mousewheel', function(e) {
		if (e) { e.stop(); }

		/* Mousewheel UP */
		if (e.wheel > 0) {
			this.startTableScroll(null, false, true /*prev*/);			
		} 
		/* Mousewheel DOWN*/
		else if (e.wheel < 0) {
			this.startTableScroll(null, true /*next*/);
		}
	});
	
	
	//Se inicializan eventos para que celdas se pueda mover
	makeDraggableInstances(droppableElements,
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
	
}

function clearAllSelected(avoidElement){
	droppableElements.each(function(element){
		if (avoidElement != element){
			element.removeClass('selected-cell');
		}
	})
}

function selectAction(element, clearAll, force){
	if (!element) return;
	
	if (clearAll) {
		clearAllSelected(element)
	}
	
	if (force || !element.hasClass('selected-cell')){
		element.addClass('selected-cell');
	} else {
		element.removeClass('selected-cell');
	}
}

function getModalReturnValue() {
	var order = container.getElements('li').map(function(ele){ return ele.getAttribute('data-x'); })
	return order;
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
				.addClass('ghost-container').addClass('drag-and-move')
				.inject(document.body);
		clone.effect = new Fx.Morph(clone, {duration: 200});
		clone.hide();
		
		var droppables = droppableElements.clone();		

		//Se agregan los botonos para avnazar/retrocer como droppables
		//para avanzar/retroceder automáticamente al pasar por encima de los mismos
		if (hScroll.next) { droppables.push(hScroll.next); }
		if (hScroll.prev) { droppables.push(hScroll.prev); }
				
		var drag = new Drag.Move(clone, {

			droppables: droppables,

			onDrop: function(clone, droppable) {
				var parent = clone.retrieve('parent');
				if (droppable){
					if (droppable.hasClass('scroll-element')){
						this.stopTableScroll(droppable);
						revertDrag(clone, parent);
					} else {
						clone.destroy();
					}
				} else {
					revertDrag(clone, parent);
				}
			},
			
			onStart: function(ele){
				this.element.show();
				this.element.setStyle('z-index', 2);
				
				if (this.element.hasClass('drag-and-move')){
					var parent = this.element.retrieve('parent');
					parent.fireEvent('click', [null, true]);
					
					//Se agranda seccion de botones de scroll
					if (hScroll.next) hScroll.next.addClass('next-element-on-dragging');
					if (hScroll.prev) hScroll.prev.addClass('prev-element-on-dragging');
					
					setHscrollTimerFunction(this, 1000 /*period*/);
				}
			},	
			
			onEnter: function(dragging, droppable){				
				if (droppable.hasClass('scroll-element')){
					this.startTableScroll(droppable);
				} else {
					//En caso de elementos de 'Table' al moverlos se actualizan
					var parent = this.element.retrieve('parent');
					if (parent==droppable) return;			
					
					//Se determina si debe ser insertado antes o después
					var where = parent.getAllPrevious().contains(droppable) ? 'before' : 'after';						
					parent.inject(droppable, where);

					//(where=='before')? 0 : 1
					//droppableCell.field.tableCell.moveCellFromTable(getParentCell(parent), droppableCell, 0);
				}	
			},
			
			onLeave: function(dragging, droppable){
				if (droppable.hasClass('scroll-element')){
					this.stopTableScroll(droppable);
				}
			},
			
			onCancel: function(dragging){
				dragging.destroy();
			}
		});
		drag.start(event);
	});
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

function setHscrollTimerFunction(handler, period, delay){
	
	if (delay){
		hScroll.addEvent('onComplete', function(e){
			handler.nextScrollPeriodical = null;
			handler.prevScrollPeriodical = null;
		})	
	}
	
	//Se obtiene funciones del scroll de elemento 'Table'
	handler.nextScrollFunction = function(){
		if (hScroll.next) hScroll.next.fade(0.7);
		hScroll.nextSlide();
	}
	handler.prevScrollFunction = function(){
		if (hScroll.prev) hScroll.prev.fade(0.7);
		hScroll.prevSlide();
	}
	
	handler.startTableScroll = function(element, forceNext, forcePrev){
		//Se agrega acción para avanzar/retroceder automáticamente
		if ((forceNext || (element && element.hasClass('next-element'))) 
				&& !handler.nextScrollPeriodical){
			if (period){
				handler.nextScrollPeriodical = handler.nextScrollFunction.periodical(period);	
			} else if (delay){
				handler.nextScrollPeriodical = handler.nextScrollFunction.delay(delay);
			}
		}
		if ((forcePrev || (element && element.hasClass('prev-element')))
				&& !handler.prevScrollPeriodical){
			if (period){
				handler.prevScrollPeriodical = handler.prevScrollFunction.periodical(period);	
			} else if (delay){
				handler.prevScrollPeriodical = handler.prevScrollFunction.delay(delay);
			}				
		}
	}
	handler.stopTableScroll = function(element, stopNext, stopPrev){
		if (hScroll.next) hScroll.next.removeClass('next-element-on-dragging');
		if (hScroll.prev) hScroll.prev.removeClass('prev-element-on-dragging');
		
		//Se detiene acción para avanzar/retroceder automáticamente
		if ((stopNext || (element && element.hasClass('next-element')))
				&& handler.nextScrollPeriodical){						
			clearInterval(this.nextScrollPeriodical);
			this.nextScrollPeriodical = null;	
		}
		if ((stopPrev || (element && element.hasClass('prev-element')))
				&& handler.prevScrollPeriodical){						
			clearInterval(handler.prevScrollPeriodical);
			handler.prevScrollPeriodical = null;	
		}
	}
}