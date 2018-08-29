//Se agregan funcionalidades solo si el navegador es mobile
if(navigator.userAgent.match(/Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile/i)) {
	/*
	---
	
	name: Element.defineCustomEvent
	
	description: Allows to create custom events based on other custom events.
	
	authors: Christoph Pojer (@cpojer)
	
	license: MIT-style license.
	
	requires: [Core/Element.Event]
	
	provides: Element.defineCustomEvent
	
	...
	*/
	
	(function(){
	
	[Element, Window, Document].invoke('implement', {hasEvent: function(event){
		var events = this.retrieve('events'),
			list = (events && events[event]) ? events[event].values : null;
		if (list){
			for (var i = list.length; i--;) if (i in list){
				return true;
			}
		}
		return false;
	}});
	
	var wrap = function(custom, method, extended, name){
		method = custom[method];
		extended = custom[extended];
	
		return function(fn, customName){
			if (!customName) customName = name;
	
			if (extended && !this.hasEvent(customName)) extended.call(this, fn, customName);
			if (method) method.call(this, fn, customName);
		};
	};
	
	var inherit = function(custom, base, method, name){
		return function(fn, customName){
			base[method].call(this, fn, customName || name);
			custom[method].call(this, fn, customName || name);
		};
	};
	
	var events = Element.Events;
	
	Element.defineCustomEvent = function(name, custom){
	
		var base = events[custom.base];
	
		custom.onAdd = wrap(custom, 'onAdd', 'onSetup', name);
		custom.onRemove = wrap(custom, 'onRemove', 'onTeardown', name);
	
		events[name] = base ? Object.append({}, custom, {
	
			base: base.base,
	
			condition: function(event){
				return (!base.condition || base.condition.call(this, event)) &&
					(!custom.condition || custom.condition.call(this, event));
			},
	
			onAdd: inherit(custom, base, 'onAdd', name),
			onRemove: inherit(custom, base, 'onRemove', name)
	
		}) : custom;
	
		return this;
	
	};
	
	var loop = function(name){
		var method = 'on' + name.capitalize();
		Element[name + 'CustomEvents'] = function(){
			Object.each(events, function(event, name){
				if (event[method]) event[method].call(event, name);
			});
		};
		return loop;
	};
	
	loop('enable')('disable');
	
	})();
	
	/*
	---
	
	name: Swipe
	
	description: Provides a custom swipe event for touch devices
	
	authors: Christopher Beloch (@C_BHole), Christoph Pojer (@cpojer), Ian Collins (@3n)
	
	license: MIT-style license.
	
	requires: [Core/Element.Event, Custom-Event/Element.defineCustomEvent, Browser.Features.Touch]
	
	provides: Swipe
	
	...
	*/
	
	(function(){
	
	var name = 'swipe',
		distanceKey = name + ':distance',
		cancelKey = name + ':cancelVertical',
		dflt = 50;
	
	var start = {}, disabled, active;
	
	var clean = function(){
		active = false;
	};
	
	var events = {
	
		touchstart: function(event){
			if (event.touches.length > 1) return;
	
			var touch = event.touches[0];
			active = true;
			start = {x: touch.pageX, y: touch.pageY};
		},
		
		touchmove: function(event){
			event.preventDefault();
			if (disabled || !active) return;
			
			var touch = event.changedTouches[0];
			var end = {x: touch.pageX, y: touch.pageY};
			if (this.retrieve(cancelKey) && Math.abs(start.y - end.y) > Math.abs(start.x - end.x)){
				active = false;
				return;
			}
			
			var distance = this.retrieve(distanceKey, dflt),
				diff = end.x - start.x,
				isLeftSwipe = diff < -distance,
				isRightSwipe = diff > distance;
	
			if (!isRightSwipe && !isLeftSwipe)
				return;
			
			active = false;
			event.direction = (isLeftSwipe ? 'left' : 'right');
			event.start = start;
			event.end = end;
			
			this.fireEvent(name, event);
		},
	
		touchend: clean,
		touchcancel: clean
	
	};
	
	Element.defineCustomEvent(name, {
	
		onSetup: function(){
			this.addEvents(events);
		},
	
		onTeardown: function(){
			this.removeEvents(events);
		},
	
		onEnable: function(){
			disabled = false;
		},
	
		onDisable: function(){
			disabled = true;
			clean();
		}
	
	});
	
	})();
	
	/**
	 * Custom swipe vertical event
	 * 
	 */
	
	(function(){
	
	var name = 'verticalswipe',
		distanceKey = name + ':distance',
		cancelKey = name + ':cancelVertical',
		dflt = 50;
	
	var start = {}, disabled, active;
	
	var clean = function(){
		active = false;
	};
	
	var events = {
	
		touchstart: function(event){
			if (event.touches.length > 1) return;
	
			var touch = event.touches[0];
			active = true;
			start = {x: touch.pageX, y: touch.pageY};
		},
		
		touchmove: function(event){
			event.preventDefault();
			if (disabled || !active) return;
			
			var touch = event.changedTouches[0];
			var end = {x: touch.pageX, y: touch.pageY};
			if (this.retrieve(cancelKey) && Math.abs(start.x - end.x) > Math.abs(start.y - end.y)){
				active = false;
				return;
			}
			
			var distance = this.retrieve(distanceKey, dflt),
				diff = end.y - start.y,
				isToptSwipe = diff < -distance,
				isBottomSwipe = diff > distance;
	
			if (!isToptSwipe && !isBottomSwipe)
				return;
			
			active = false;
			event.direction = (isToptSwipe ? 'top' : 'bottom');
			event.start = start;
			event.end = end;
			
			this.fireEvent(name, event);
		},
	
		touchend: clean,
		touchcancel: clean
	
	};
	
	Element.defineCustomEvent(name, {
	
		onSetup: function(){
			this.addEvents(events);
		},
	
		onTeardown: function(){
			this.removeEvents(events);
		},
	
		onEnable: function(){
			disabled = false;
		},
	
		onDisable: function(){
			disabled = true;
			clean();
		}
	
	});
	
	})();
}