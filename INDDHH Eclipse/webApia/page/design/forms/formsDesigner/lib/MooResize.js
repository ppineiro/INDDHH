/*
---
description: You can resize elements easilly with MooResize

authors:
  - Arian Stolwijk

license:
  - MIT-style license

requires:
  core/1.2.4: [Class.Extras,Element.Style]
  more/1.2.4: [Drag]

provides:
  - [MooResize]
...
*/


var MooResize = new Class({

	Implements: [Options,Events],
	
	options: {
		handleSize: 10/*,
		minSize: false, // object with x and y or false
		maxSize: false, // object with x and y or false
		ratio: false, // false, true or any number (ratio = width/height)
		dragOptions: {},
		handleStyle: {},
		
		onStart: $empty,
		onResize: $empty,
		onComplete: $empty*/
	},
	
	initialize: function(el,options){
		this.setOptions(options);
		this.el = el;
		this.elContainer = el.getParent('li');
		this.elSize = this.elContainer.getSize();		
		this.setContainerSize(this.elSize.x, this.elSize.y);
		
		this.origRatio = this.elCoords.width / this.elCoords.height;
		this.setRatio(this.options.ratio);
		
		this.handles = {
			corner: {
				el: new Element('div').setStyle('cursor','se-resize'),
				dragOptions: {
					droppables : options.droppables,
					onDrag: function(el,e){
						this.setSize({
							x: e.page.x - this.elCoords.left,
							y: e.page.y - this.elCoords.top
						});
					}.bind(this),
					onEnter: function(dragging, droppable, event){
						this.fireEvent('enter',[droppable, event]);
					}.bind(this)
					
					,onDrop: function(dragging, droppable){
						this.clearStyles();
						this.fireEvent('drop',[droppable]);
					}.bind(this)
					
				},
				setPosition: function(width,height){
					this.handles.corner.el.setStyles({
						'left': width - this.options.handleSize,
						'top': height - this.options.handleSize
					});
				}.bind(this)
			}
		};
	
		$each(this.handles,function(handle,key){
			handle.el.addClass('resize-handler');
			handle.el.setStyles($merge({
				'z-index': 9999
			},this.options.handleStyle,{
				position: 'absolute',
				width: this.options.handleSize,
				height: this.options.handleSize
			})).inject(this.elContainer);

			handle.setPosition(this.elCoords.width,this.elCoords.height);

			handle.drag = new Drag.Move(
				handle.el,
				$merge(this.options.dragOptions,handle.dragOptions)
			);	

			handle.el.addEvents({
				'click': function(e){ handle.drag.fireEvent('click', e); },
				'mousedown': function(e){ handle.drag.fireEvent('click', e); }
			});

			handle.drag.addEvents({
				'click': function(e){
					this.fireEvent('onHandleClick', e);
				}.bind(this),
				'start': function(){
					this.fireEvent('start',[this.getSize()]);
				}.bind(this),
				'complete': function(handler,event){
					this.fireEvent('complete',[handler,event]);
				}.bind(this)
			});
		}.bind(this));
	},
	
	clearStyles: function() {
		this.el.removeAttribute('style');
	},
	
	setSize: function(width,height, force){
		var size = $type(width) == 'object' ? {x: width.x, y: width.y} : {x: width, y: height},
			minSize = $type(this.options.minSize) != 'object' ? {x:0,y:0} : this.options.minSize,
			maxSize = this.options.maxSize;
		
		for(dir in size){
			size[dir] = (function(mag,dir){
				if(!mag && mag !== 0) mag = null;
				if(mag === null) return mag;
				if(mag < minSize[dir]){					
					return minSize[dir];
				}else if(maxSize && mag > maxSize[dir]){
					return maxSize[dir];
				}
				return mag;		
			})(size[dir],dir);
		}

		if (size.x === null && size.y !== null){
			size.x = this.ratio ? size.y * this.ratio : this.elCoords.width;  
		} else if (size.y === null && size.x !== null){
			size.y = this.ratio ? size.x / this.ratio : this.elCoords.height; 
		} else if (size.x !== null && size.y !== null && this.ratio){
			size.y = size.x / this.ratio;
		}
		
		for(dir in size) size[dir] = size[dir].round();
		this.el.setStyles({
			width: size.x,
			height: size.y
		});

		$each(this.handles,function(handle){
			handle.setPosition(size.x,size.y);
		});
		
		this.elCoords = this.el.getCoordinates();
		this.fireEvent('resize',[size,this.el]);
		return this;
	},
	
	getSize: function(){
		return {
			x: this.elCoords.width,
			y: this.elCoords.height
		};
	},
	
	setRatio: function(ratio){
		this.ratio = $type(ratio) == 'boolean' ?
			(ratio ? this.origRatio : false) : ratio;
		return this;
	},
	
	getRatio: function(){
		return this.ratio;
	},
	
	setContainerSize: function(xSize, ySize){
		if (xSize) { this.elSize.x = xSize, this.elSize.x -= CELL_BORDER;};
		if (ySize) { this.elSize.y = ySize, this.elSize.y -= CELL_BORDER;};
		this.elCoords = this.el.getCoordinates();
	},
	
	setHandlerPosition: function(width,height){
		this.handles.corner.setPosition(width,height);
	},
	
	updateHandlersDroppableElements: function(droppables){
		this.handles.corner.drag.droppables=droppables;
	},
	
	dispose: function(){
		$each(this.handles,function(handle){
			handle.el.dispose();
		});
		this.handles = null;
	}
});
