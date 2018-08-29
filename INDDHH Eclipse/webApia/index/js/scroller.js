/**
 * Clase para generar un scroll custom
 */
var VScroller = new Class({
		
	scroll: null,
	
	reel: null,
	
	scroll_target: null,
	
	initialize: function(container, scroll_target) {
		
		var reel_height = container.getHeight()
		var reel = new Element('div.scroll-background').setStyle('height', reel_height);
		var scroll = new Element('div.scroll').inject(reel);
		
		this.reel = reel;
		this.scroll = scroll;
		this.scroll_target = scroll_target;
			
		reel.inject(container);
		
		container.setStyle('position', 'relative');
		
		var a = reel_height - scroll.getHeight();
		this.a = a;
		var b = scroll_target.getHeight() - reel_height;
		this.b = b;
		
		scroll.makeDraggable({
			limit: {x: [0, 0], y: [0, reel_height - scroll.getHeight()]},
			onDrag : function(el) {
				var res = (b * (a - Number.from(el.getStyle('top'))) / a) - b;
				scroll_target.setStyle('margin-top', res);
			}
		});

		reel.addEvent('mouseenter', function() {
			this.getElement('div.scroll').addClass('scroll-highlight');
		});
		reel.addEvent('mouseleave', function() {
			this.getElement('div.scroll').removeClass('scroll-highlight');
		});
		reel.addEvent('click', function(e){
			if(e.target == scroll)
				return;
			
			var top = (e.event.layerY || e.event.offsetY) - scroll.getHeight()/2;
			if(top < 0) top = 0
			else if(top > reel.getHeight() - scroll.getHeight()) top = reel.getHeight() - scroll.getHeight();
				
			scroll.setStyle('top', top);
			
			var res = (b * (a - top) / a) - b;
			scroll_target.setStyle('margin-top', res);
		});
		
		scroll_target.addEvent('mousewheel', function(e) {
			if(!scroll.getStyle) scroll = $(scroll);
			if(!reel.getHeight) reel = $(reel);
			
			var top = Number.from(scroll.getStyle('top'));
			if(e.wheel > 0) {
				//Hacia arriba
				if(Browser.ie)
					top -= 22;
				else
					top -= 15;
			} else {
				//Hacia abajo
				if(Browser.ie)
					top += 22;
				else
					top += 15;
			}
			
			if(top < 0) top = 0
			else if(top > reel.getHeight() - scroll.getHeight()) top = reel.getHeight() - scroll.getHeight();
				
			scroll.setStyle('top', top);
			
			var res = (b * (a - top) / a) - b;
			scroll_target.setStyle('margin-top', res);
		});
		
		//mobile-friendly
		/*
		var rec_move = null;
		scroll_target.addEvent("touchstart", function(e) {
			rec_move = {x: e.page.x, y: e.page.y};
		});
		
		scroll_target.addEvent("touchend", function(e) {
			rec_move = null;
		});
		
		scroll_target.addEvent("touchmove", function(e) {
			if(!scroll.getStyle) scroll = $(scroll);
			if(!reel.getHeight) reel = $(reel);
			
			var top = Number.from(scroll.getStyle('top'));
			
			if(e.page.y > rec_move.y) {
				//Hacia arriba
				top -= 18;
			} else {
				//Hacia abajo
				top += 18;
			}
			
			if(top < 0) top = 0
			else if(top > reel.getHeight() - scroll.getHeight()) top = reel.getHeight() - scroll.getHeight();
				
			scroll.setStyle('top', top);
			
			var res = (b * (a - top) / a) - b;
			scroll_target.setStyle('margin-top', res);
		});
		*/
		scroll_target.addEvent("verticalswipe", function(e) {
			if(!scroll.getStyle) scroll = $(scroll);
			if(!reel.getHeight) reel = $(reel);
			
			var top = Number.from(scroll.getStyle('top'));
			
			if(e.direction == "top") {
				//Hacia arriba
				top += 25;
			} else {
				//Hacia abajo
				top -= 25;
			}
			
			if(top < 0) top = 0
			else if(top > reel.getHeight() - scroll.getHeight()) top = reel.getHeight() - scroll.getHeight();
				
			scroll.setStyle('top', top);
			
			var res = (b * (a - top) / a) - b;
			scroll_target.setStyle('margin-top', res);
		});
	},
	
	clearScroll: function() {
		this.scroll_target.setStyle('margin-top', 0);
		$(this.reel).destroy();
	},
	
	getScroll: function() {
		//Number.from(this.scroll_target.getStyle('margin-top'));
		return Number.from($(this.scroll).getStyle('top', top));
	},
	
	setScroll: function(top) {
		//var top = this.a - ((res + this.b)*this.a/this.b);
		var reel = this.reel;
		var scroll = this.scroll;
		
		if(top < 0) top = 0
		else if(top > reel.getHeight() - scroll.getHeight()) top = reel.getHeight() - scroll.getHeight();
		
		var res = this.b == 0 ? 0 : (this.b * (this.a - top) / this.a) - this.b;
		
		this.scroll.setStyle('top', top);
		this.scroll_target.setStyle('margin-top', res);
		
		return this;
	},
	
	showElement: function(element) {
		//Verificar que element no este visible
		var scroll_container = this.scroll_target.getParent('div.scroll_container');
		var visible_height = Number.from(scroll_container.getStyle('height'));
		
		var margin_top = Number.from(this.scroll_target.getStyle('margin-top'));
		
		var ele_y = element.getHeight() * (element.getAllPrevious().length);
		//var ele_y = tr.getPosition().y + margin_top;
		
		//if(ele_y > visible_height) {
		if(ele_y >= (visible_height - margin_top)) {
			//Esta abajo			
			var res = -(ele_y + element.getHeight()) + visible_height;			
			var new_top = this.a - this.a * (res + this.b) / this.b;			
			this.setScroll(new_top);
		} else if(ele_y < - margin_top) {
			//Esta arriba
			var res =  -ele_y;
			var new_top = this.a - this.a * (res + this.b) / this.b;			
			this.setScroll(new_top);
		}
	}
});

var HScroller = new Class({
	
	scroll: null,
	
	reel: null,
	
	scroll_target: null,
	
	a: 0,
	
	b: 0,
	
	drag: null,
	
	new_container: null,
	
	spinner: null,
	
	initialize: function(container, scroll_target) {
		
		var reel = new Element('div.hscroll-background');
		var scroll = new Element('div.hscroll').inject(reel);
		
		this.new_container = new Element('div.scroll_container').setStyles({
			position: 'relative',
			width: container.hasClass('gridBody') ? '100%' : container.getStyle('width'),
			height: container.getHeight()
		}).inject(container, 'before').grab(container.setStyle('width', '100%'));
		
		var header_width = undefined;
		var aux_gridHeader = this.new_container.getPrevious('div.gridHeader');
		if (aux_gridHeader != null) {
			var aux_gridHeader_table = aux_gridHeader.getChildren('table')[0];
			header_width = aux_gridHeader_table.getWidth();
			if(!aux_gridHeader_table.get("blurEventsAdded")) {
				var inp = aux_gridHeader_table.getElements('input');
				var sel = aux_gridHeader_table.getElements('select');
				inp.append(sel).addEvent('keydown', function(e) {
					if(e.key == 'tab')
						e.stop();
				});
				aux_gridHeader_table.set("blurEventsAdded", "true");
			}
		}
		
		this.spinner = container.get('spinner');
			
		this.reel = reel;
		this.scroll = $(scroll);
		this.scroll_target = scroll_target;
		this.container = container;
		
		reel.inject(this.new_container);
		
		var reel_width = container.getWidth();
		
		$(this.spinner.content).getParent().setStyle('width', reel_width);
		
		this.a = reel_width - scroll.getWidth();
		this.b = scroll_target.getWidth() - reel_width;
		
		this.drag = scroll.makeDraggable({
			limit: {y: [0, 0], x: [0, reel_width - scroll.getWidth()]},
			onDrag : function(el) {
				var res = (this.b * (this.a - Number.from(el.getStyle('left'))) / this.a) - this.b;
				scroll_target.setStyle('margin-left', res);
				$(this.spinner.content).getParent().setStyle('width', reel_width);
				this.container.fireEvent('custom_scroll', res);
			}.bind(this)
		});

		reel.addEvent('mouseenter', function() {
			this.getElement('div.hscroll').addClass('scroll-highlight');
		});
		reel.addEvent('mouseleave', function() {
			this.getElement('div.hscroll').removeClass('scroll-highlight');
		});
		reel.addEvent('click', function(e){
			if(e.target == scroll)
				return;
			
			var left = (e.event.layerX || e.event.offsetX) - scroll.getWidth()/2;
			if(left < 0) left = 0
			else if(left > reel.getWidth() - scroll.getWidth()) left = reel.getWidth() - scroll.getWidth();
				
			scroll.setStyle('left', left);
			
			var res = (this.b * (this.a - left) / this.a) - this.b;
			scroll_target.setStyle('margin-left', res);
			$(this.spinner.content).getParent().setStyle('width', reel_width);
			this.container.fireEvent('custom_scroll', res);
			
		}.bind(this));
		
		var f = function() {
			
			if(!this.container.hasClass('gridBody'))					
				this.new_container.setStyle('width', this.container.getStyle('width'));
			
			if(container.getWidth() < scroll_target.getWidth()) {
				$(this.reel).setStyle('visibility', 'visible');
				var reel_width = container.getWidth();
				
				this.a = reel_width - $(scroll).getWidth();
				this.b = scroll_target.getWidth() - reel_width;
				
				this.drag.detach().stop();
				
				this.drag = this.scroll.makeDraggable({
					limit: {y: [0, 0], x: [0, reel_width - $(scroll).getWidth()]},
					onDrag : function(el) {
						var res = (this.b * (this.a - Number.from(el.getStyle('left'))) / this.a) - this.b;
						scroll_target.setStyle('margin-left', res);
						$(this.spinner.content).getParent().setStyle('width', reel_width);
						this.container.fireEvent('custom_scroll', res);
					}.bind(this)
				}); 
					
					
				//this.drag.limit = {y: [0, 0], x: [0, reel_width - scroll.getWidth()]};
				$(this.new_container).setStyle('margin-bottom', this.scroll.getHeight());
			} else {					
				$(this.reel).setStyle('visibility', 'hidden');
				$(this.new_container).setStyle('margin-bottom', 0);
			}
			
			$(this.scroll).setStyle('left', 0);
			scroll_target.setStyle('margin-left', 0);
			this.container.fireEvent('custom_scroll', 0);
			
		}.bind(this);
		
		window.addEvent('resize', function() {
			if(this.timer) clearTimeout(this.timer);
			this.timer = f.delay(50);				
		}.bind(this));
		
		if(container.getWidth() >= scroll_target.getWidth()) {
			if(header_width != undefined && container.getWidth() >= header_width) {
				$(this.reel).setStyle('visibility', 'hidden');
				$(this.new_container).setStyle('margin-bottom', 0);
			} else {
				scroll_target.setStyle('width', header_width);
				if(scroll_target.getHeight() == 0)
					scroll_target.setStyle('height', 1);					
				$(this.new_container).setStyle('margin-bottom', scroll.getHeight());
				f.delay(50);
			}
		} else {
			$(this.new_container).setStyle('margin-bottom', scroll.getHeight());
		}
		
		//mobile-friendly
		/*
		var rec_move = null;
		scroll_target.addEvent("touchstart", function(e) {
			rec_move = {x: e.page.x, y: e.page.y};
		});
		
		scroll_target.addEvent("touchend", function(e) {
			rec_move = null;
		});
		
		var _this = this;
		
		scroll_target.addEvent("touchmove", function(e) {
			if(!scroll.getStyle) scroll = $(scroll);
			if(!reel.getWidth) reel = $(reel);			
				
			var left = Number.from(scroll.getStyle('left'));
			
			if(e.page.x > rec_move.x) {
				//Hacia la izq
				left -= 18;
			} else {
				//Hacia la der
				left += 18;
			}
			
			if(left < 0) left = 0
			else if(left > reel.getWidth() - scroll.getWidth()) left = reel.getWidth() - scroll.getWidth();
			
			var res = (_this.b * (_this.a - left) / _this.a) - _this.b;
			scroll_target.setStyle('margin-left', res);
			//$(_this.spinner.content).getParent().setStyle('width', reel_width);
			_this.container.fireEvent('custom_scroll', res);
		});
		*/
		var _this = this;
		scroll_target.addEvent("swipe", function(e) {
			if(!scroll.getStyle) scroll = $(scroll);
			if(!reel.getWidth) reel = $(reel);			
				
			var left = Number.from(scroll.getStyle('left'));
			
			if(e.direction == "left") {
				//Hacia la izq
				left += 70;
			} else {
				//Hacia la der
				left -= 70;
			}
			
			if(left < 0) left = 0
			else if(left > reel.getWidth() - scroll.getWidth()) left = reel.getWidth() - scroll.getWidth();
			
			scroll.setStyle('left', left);
			
			var res = (_this.b * (_this.a - left) / _this.a) - _this.b;
			scroll_target.setStyle('margin-left', res);
			//$(_this.spinner.content).getParent().setStyle('width', reel_width);
			_this.container.fireEvent('custom_scroll', res);
		});
	},
	
	timer: null,
	
	clearScroll: function() {
		this.scroll_target.setStyle('margin-left', 0);
		
		$(this.new_container).getChildren()[0].inject(this.new_container, 'before');
		
		this.new_container.destroy();
		$(this.reel).destroy();
	},
	
	setScroll: function(left) {
		var reel = this.reel;
		var scroll = this.scroll;
		
		if(left < 0) left = 0
		else if(left > reel.getWidth() - scroll.getWidth()) left = reel.getWidth() - scroll.getWidth();
		
		var res = (this.b * (this.a - left) / this.a) - this.b;
		
		this.scroll.setStyle('left', left);
		this.scroll_target.setStyle('margin-left', res);
		
		return this;
	},
	
	showElement: function(element) {
		//Verificar que element no este visible
		var scroll_container = this.scroll_target.getParent('div.scroll_container');
		//var visible_width = Number.from(scroll_container.getStyle('width'));
		var visible_width = scroll_container.getWidth();
		
		var margin_left = Number.from(this.scroll_target.getStyle('margin-left'));
		
		var ele_x = element.getWidth() * (element.getAllPrevious().length - 1);
		//var ele_y = tr.getPosition().y + margin_top;
		
		//if(ele_y > visible_height) {
		if(ele_x >= (visible_width - margin_left)) {
			//Esta a la derecha			
			var res = -(ele_x + element.getWidth()) + visible_width;			
			var new_left = this.a - this.a * (res + this.b) / this.b;			
			this.setScroll(new_left);
		} else if(ele_x < - margin_left) {
			//Esta a la izquierda
			var res =  -ele_x;
			var new_left = this.a - this.a * (res + this.b) / this.b;			
			this.setScroll(new_left);
		}
	}
});


var TreeHScroller = new Class({
	
	scroll: null,
	
	reel: null,
	
	scroll_target: null,
	
	a: 0,
	
	b: 0,
	
	drag: null,
	
	new_container: null,
	
	spinner: null,
	
	initialize: function(container, scroll_target, hasVScroller) {
		
		var reel = new Element('div.hscroll-background.tree-scroll');
		var scroll = new Element('div.hscroll').inject(reel);
		
		var added_width = hasVScroller ? 15 : 0;
		
		this.new_container = new Element('div.scroll_container').setStyles({
			position: 'relative',
			width: container.getWidth(),
			height: container.getHeight()
		}).inject(container, 'before').grab(container.setStyle('width', '100%'));
		
		var header_width = container.getWidth();
		
		//this.spinner = container.get('spinner');
			
		this.reel = reel;
		this.scroll = $(scroll);
		this.scroll_target = scroll_target;
		this.container = container;
		
		reel.inject(this.new_container);
		
		var reel_width = container.getWidth();
		
		//$(this.spinner.content).getParent().setStyle('width', reel_width);
		
		this.a = reel_width - scroll.getWidth();
		this.b = scroll_target.getWidth() + added_width - reel_width;
		
		this.drag = scroll.makeDraggable({
			limit: {y: [0, 0], x: [0, reel_width - scroll.getWidth()]},
			onDrag : function(el) {
				var res = (this.b * (this.a - Number.from(el.getStyle('left'))) / this.a) - this.b;
				scroll_target.setStyle('margin-left', res);
				//$(this.spinner.content).getParent().setStyle('width', reel_width);
				this.container.fireEvent('custom_scroll', res);
			}.bind(this)
		});

		reel.addEvent('mouseenter', function() {
			this.getElement('div.hscroll').addClass('scroll-highlight');
		});
		reel.addEvent('mouseleave', function() {
			this.getElement('div.hscroll').removeClass('scroll-highlight');
		});
		reel.addEvent('click', function(e){
			if(e.target == scroll)
				return;
			
			var left = (e.event.layerX || e.event.offsetX) - scroll.getWidth()/2;
			if(left < 0) left = 0
			else if(left > reel.getWidth() - scroll.getWidth()) left = reel.getWidth() - scroll.getWidth();
				
			scroll.setStyle('left', left);
			
			var res = (this.b * (this.a - left) / this.a) - this.b;
			scroll_target.setStyle('margin-left', res);
			//$(this.spinner.content).getParent().setStyle('width', reel_width);
			this.container.fireEvent('custom_scroll', res);
			
		}.bind(this));
		
		var f = function() {
			
			//if(!this.container.hasClass('gridBody'))					
				//this.new_container.setStyle('width', this.container.getStyle('width'));
				this.new_container.setStyle('width', this.container.getWidth());
			
			if(container.getWidth() < (scroll_target.getWidth() + added_width)) {
				$(this.reel).setStyle('visibility', 'visible');
				var reel_width = container.getWidth();
				
				this.a = reel_width - $(scroll).getWidth();
				this.b = scroll_target.getWidth() + added_width - reel_width;
				
				this.drag.detach().stop();
				
				this.drag = this.scroll.makeDraggable({
					limit: {y: [0, 0], x: [0, reel_width - $(scroll).getWidth()]},
					onDrag : function(el) {
						var res = (this.b * (this.a - Number.from(el.getStyle('left'))) / this.a) - this.b;
						scroll_target.setStyle('margin-left', res);
						//$(this.spinner.content).getParent().setStyle('width', reel_width);
						this.container.fireEvent('custom_scroll', res);
					}.bind(this)
				}); 
					
					
				//this.drag.limit = {y: [0, 0], x: [0, reel_width - scroll.getWidth()]};
				$(this.new_container).setStyle('margin-bottom', this.scroll.getHeight());
			} else {					
				$(this.reel).setStyle('visibility', 'hidden');
				$(this.new_container).setStyle('margin-bottom', 0);
			}
			
			$(this.scroll).setStyle('left', 0);
			scroll_target.setStyle('margin-left', 0);
			this.container.fireEvent('custom_scroll', 0);
			
		}.bind(this);
		
		window.addEvent('resize', function() {
			if(this.timer) clearTimeout(this.timer);
			this.timer = f.delay(50);				
		}.bind(this));
		
		var cont_width = container.getWidth();
		if(cont_width >= (scroll_target.getWidth() + added_width)) {
			//if(container.getWidth() >= header_width) {
				$(this.reel).setStyle('visibility', 'hidden');
				$(this.new_container).setStyle('margin-bottom', 0);
			/*} else {
				//scroll_target.setStyle('width', header_width);
				scroll_target.setStyle('width', cont_width);
				if(scroll_target.getHeight() == 0)
					scroll_target.setStyle('height', 1);					
				$(this.new_container).setStyle('margin-bottom', scroll.getHeight());
				f.delay(50);
			}*/
		} else {
			$(this.new_container).setStyle('margin-bottom', scroll.getHeight());
		}
	},
	
	timer: null,
	
	clearScroll: function() {
		this.scroll_target.setStyle('margin-left', 0);
		
		$(this.new_container).getChildren()[0].inject(this.new_container, 'before');
		
		this.new_container.destroy();
		$(this.reel).destroy();
	}
});



var DivHScroller = new Class({
	
	scroll: null,
	
	reel: null,
	
	scroll_target: null,
	
	a: 0,
	
	b: 0,
	
	drag: null,
	
	new_container: null,
	
	spinner: null,
	
	initialize: function(container, scroll_target, hasVScroller) {
		
		var reel = new Element('div.hscroll-background');
		var scroll = new Element('div.hscroll').inject(reel);
		
		var added_width = hasVScroller ? 15 : 0;
		
		this.new_container = new Element('div.scroll_container').setStyles({
			position: 'relative',
			width: container.getWidth(),
			height: container.getHeight()
		}).inject(container, 'before').grab(container.setStyle('width', '100%'));
		
		var header_width = container.getWidth();
		
		//this.spinner = container.get('spinner');
			
		this.reel = reel;
		this.scroll = $(scroll);
		this.scroll_target = scroll_target;
		this.container = container;
		
		reel.inject(this.new_container);
		
		var reel_width = container.getWidth();
		
		//$(this.spinner.content).getParent().setStyle('width', reel_width);
		
		this.a = reel_width - scroll.getWidth();
		this.b = scroll_target.getWidth() + added_width - reel_width;
		
		this.drag = scroll.makeDraggable({
			limit: {y: [0, 0], x: [0, reel_width - scroll.getWidth()]},
			onDrag : function(el) {
				var res = (this.b * (this.a - Number.from(el.getStyle('left'))) / this.a) - this.b;
				scroll_target.setStyle('margin-left', res);
				//$(this.spinner.content).getParent().setStyle('width', reel_width);
				this.container.fireEvent('custom_scroll', res);
			}.bind(this)
		});

		reel.addEvent('mouseenter', function() {
			this.getElement('div.hscroll').addClass('scroll-highlight');
		});
		reel.addEvent('mouseleave', function() {
			this.getElement('div.hscroll').removeClass('scroll-highlight');
		});
		reel.addEvent('click', function(e){
			if(e.target == scroll)
				return;
			
			var left = (e.event.layerX || e.event.offsetX) - scroll.getWidth()/2;
			if(left < 0) left = 0
			else if(left > reel.getWidth() - scroll.getWidth()) left = reel.getWidth() - scroll.getWidth();
				
			scroll.setStyle('left', left);
			
			var res = (this.b * (this.a - left) / this.a) - this.b;
			scroll_target.setStyle('margin-left', res);
			//$(this.spinner.content).getParent().setStyle('width', reel_width);
			this.container.fireEvent('custom_scroll', res);
			
		}.bind(this));
		
		var f = function() {
			
			//if(!this.container.hasClass('gridBody'))					
				//this.new_container.setStyle('width', this.container.getStyle('width'));
				this.new_container.setStyle('width', this.container.getWidth() - added_width - 1);
			
			if(container.getWidth() < (scroll_target.getWidth() + added_width)) {
				$(this.reel).setStyle('visibility', 'visible');
				var reel_width = container.getWidth();
				
				this.a = reel_width - $(scroll).getWidth();
				this.b = scroll_target.getWidth() + added_width - reel_width;
				
				this.drag.detach().stop();
				
				this.drag = this.scroll.makeDraggable({
					limit: {y: [0, 0], x: [0, reel_width - $(scroll).getWidth()]},
					onDrag : function(el) {
						var res = (this.b * (this.a - Number.from(el.getStyle('left'))) / this.a) - this.b;
						scroll_target.setStyle('margin-left', res);
						//$(this.spinner.content).getParent().setStyle('width', reel_width);
						this.container.fireEvent('custom_scroll', res);
					}.bind(this)
				}); 
					
					
				//this.drag.limit = {y: [0, 0], x: [0, reel_width - scroll.getWidth()]};
				$(this.new_container).setStyle('margin-bottom', this.scroll.getHeight());
			} else {					
				$(this.reel).setStyle('visibility', 'hidden');
				$(this.new_container).setStyle('margin-bottom', 0);
			}
			
			$(this.scroll).setStyle('left', 0);
			scroll_target.setStyle('margin-left', 0);
			this.container.fireEvent('custom_scroll', 0);
			
		}.bind(this);
		
		window.addEvent('resize', function() {
			if(this.timer) clearTimeout(this.timer);
			this.timer = f.delay(50);				
		}.bind(this));
		
		var cont_width = container.getWidth();
		if(cont_width >= (scroll_target.getWidth() + added_width)) {
			//if(container.getWidth() >= header_width) {
				$(this.reel).setStyle('visibility', 'hidden');
				$(this.new_container).setStyle('margin-bottom', 0);
			/*} else {
				//scroll_target.setStyle('width', header_width);
				scroll_target.setStyle('width', cont_width);
				if(scroll_target.getHeight() == 0)
					scroll_target.setStyle('height', 1);					
				$(this.new_container).setStyle('margin-bottom', scroll.getHeight());
				f.delay(50);
			}*/
		} else {
			$(this.new_container).setStyle('margin-bottom', scroll.getHeight());
		}
	},
	
	timer: null,
	
	clearScroll: function() {
		this.scroll_target.setStyle('margin-left', 0);
		
		$(this.new_container).getChildren()[0].inject(this.new_container, 'before');
		
		this.new_container.destroy();
		$(this.reel).destroy();
	}
});