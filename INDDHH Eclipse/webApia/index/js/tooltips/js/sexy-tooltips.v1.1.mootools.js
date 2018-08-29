/**
 * Sexy ToolTips - for mootools 1.2
 * @name      sexy-tooltips.js
 * @author    Eduardo D. Sada - http://www.coders.me/web-html-js-css/javascript/sexy-tooltips
 * @version   1.1
 * @date      16-Oct-2009
 * @copyright (c) 2009 Eduardo D. Sada (www.coders.me)
 * @license   MIT - http://es.wikipedia.org/wiki/Licencia_MIT
 * @example   http://www.coders.me/ejemplos/sexy-tooltips/
*/

var FixeadorZIndex = 70000;

Element.implement({
	css: function(params){ return this.setStyles(params);} // costumbre jQuery
});

Element.implement({
    tooltip: function(content, options) {
        if (!this.OBJtooltip) {
            this.OBJtooltip = new ToolTip(this, content, options);
        }
        return this.OBJtooltip;
    },
    tooltip_hide: function() {
        if (this.OBJtooltip) {
            this.OBJtooltip.hide();
        }
    }
});

var ToolTip = new Class({
    Implements: [Options, Events],
    initialize: function (trigger, content, options) {
        this.setOptions({
            duration     : 300,
            transition   : Fx.Transitions.linear,
            wait         : false,
            tooltipClass : 'sexy-tooltip',
            style        : 'default',
            width        : 250,
            mode         : 'auto',
            hook         : false,
            mouse        : true,
            click        : false,
            sticky       : 0,
            tip          :
            {
                x : 'c',
                y : 'b'
            }
        },
        options);
                
        this.open = false;
        this.trigger = document.id(trigger);
        this.trigger.set('title', '');
        
        if (this.options.mode != 'auto') {
            this.options.tip.y = this.options.mode.toLowerCase().charAt(0);
            this.options.tip.x = this.options.mode.toLowerCase().charAt(1);
        }

        if (this.options.hook || Browser.Engine.trident) {
            this.options.duration = 1; // not animation;
        }

        this.create(); // Crear maqueta html
        this.skeleton.middle.set('html', content);

        if (this.options.hook) {
            this.trigger.addEvent('mousemove', this.hook.bindWithEvent(this));
        }

        if (this.options.click) {
            this.trigger.addEvent('click', this.show.bindWithEvent(this));
        }

        if (this.options.mouse && !this.options.click) {
            this.trigger.addEvent('mouseenter', this.show.bindWithEvent(this));
            if (!this.options.sticky) {
                this.trigger.addEvent('mouseleave', this.hide.bindWithEvent(this));
            }
        }

        if (this.options.sticky) {
            this.skeleton.close.addEvent('mouseenter', this.hide.bindWithEvent(this))
        }
        
        window.addEvent('resize', function(){
            this.tooltip.css({
              opacity : 0,
              top     : 0,
              left    : 0
            });
            this.open = false;
        }.bindWithEvent(this));
            

    },
    
    create: function() {
        this.tooltip = new Element('div', { 'class': this.options.tooltipClass }).css({
          'position'  : 'absolute',
          'top'       : 0,
          'left'      : 0,
          'z-index'   : FixeadorZIndex,
          'visibility': 'hidden',
          'width'     : this.options.width
        }).injectInside(document.body);
        
        this.skeleton = {};
        
        this.skeleton.style     = new Element('div', { 'class': this.options.style }).injectInside(this.tooltip);
        
        this.skeleton.top_left  = new Element('div', { 'class': 'tooltip-tl', 'styles': { 'width': this.options.width } }).injectInside(this.skeleton.style);
        this.skeleton.top_right = new Element('div', { 'class': 'tooltip-tr' }).injectInside(this.skeleton.top_left); 
        this.skeleton.top       = new Element('div', { 'class': 'tooltip-t' }).injectInside(this.skeleton.top_right);

        this.skeleton.left      = new Element('div', { 'class': 'tooltip-l', 'styles': { 'width': this.options.width } }).injectAfter(this.skeleton.top_left);
        this.skeleton.right     = new Element('div', { 'class': 'tooltip-r' }).injectInside(this.skeleton.left);
        this.skeleton.middle    = new Element('div', { 'class': 'tooltip-m' }).injectInside(this.skeleton.right);

        this.skeleton.bottom_left   = new Element('div', { 'class': 'tooltip-bl', 'styles': { 'width': this.options.width } }).injectAfter(this.skeleton.left);
        this.skeleton.bottom_right  = new Element('div', { 'class': 'tooltip-br' }).injectInside(this.skeleton.bottom_left);
        this.skeleton.bottom        = new Element('div', { 'class': 'tooltip-b' }).injectInside(this.skeleton.bottom_right);

        this.skeleton.arrow  = new Element('div');

        if (this.options.tip.y == 't') {
            this.arrow('top');
        } else if (this.options.tip.y == 'b') {
            this.arrow('bottom');
        }
        if (this.options.tip.x == 'l') {
            this.arrow('left');
        } else if (this.options.tip.x == 'r') {
            this.arrow('right');
        } else if (this.options.tip.x == 'c') {
            this.arrow('center');
        }

        if (this.options.sticky) {
            this.skeleton.close = new Element('a', { 'class': 'tooltip-close' }).injectInside(this.skeleton.top_left);
        }
        
    },
    
    iesucks: function(skeleton) {
      $each(skeleton, function(el) {
        el.css({ 'background-image' : '' });
        if (el.getComputedStyle('background-image')) {
          el.css({ 'background-image' : el.getComputedStyle('background-image').replace('.png', '.gif') });
        }
      });
    },
    
    hook: function (event) {
        if (this.open) {
            this.pos = this.position(event);

            this.tooltip.css({
              'top'     : this.pos.top,
              'left'    : this.pos.left
            });            
        }
    },
    
    fireevents: function(type) {
        if (type == 1) {
            this.trigger.fireEvent('tooltipshow');
        } else if (type == 2) {
            this.trigger.fireEvent('tooltiphide');
        }
    },

    isOpen: function(event){
    	return this.open;
    },
    
    show: function (event) {
        if (!this.open) {
            this.pos = this.position(event);
            
            
            this.tooltip.css({
                'opacity' : 0,
                'z-index' : FixeadorZIndex,
                'top'     : this.pos.top,
                'left'    : this.pos.left
            });
            
            
            this.tooltip.set('morph', $extend(this.options, {onComplete: function() {this.fireevents(1)}.bind(this)}));
            this.tooltip.morph({ 'opacity': 1, 'top': (this.pos.top - 10) + 'px' });
            
            FixeadorZIndex += 1;
            
            this.open = true;

            if (Browser.Engine.trident4) this.iesucks(this.skeleton);

        }
        if (this.options.click) {
          event.stop();
        }
    },


    hide: function (event) {
        this.tooltip.set('morph', $extend(this.options, {onComplete: function() {
          this.open = false;
          this.tooltip.css({top:0, left:0});
          this.fireevents(2);
        }.bind(this)}));
        this.tooltip.morph({
          opacity : 0,
          top     : (this.pos.top - 20)
        });
    },


    position: function (event) {
        var position = this.trigger.getOffsets(), size = this.trigger.getSize();
        var trg  = {
          left    : position.x,
          top     : position.y,
          width   : size.x,
          height  : size.y,
          right   : position.x + size.x,
          bottom  : position.y + size.y
        };
        
        
        var tip  = this.tooltip.getCoordinates();
        var doc  = document.id(document).getCoordinates();
        var top  = 0;
        var left = 0;
        
        var doc = $extend(doc, document.id(document).getScroll());
        
        if (event) {
          var event = new Event(event);
          var trg = $extend(trg, {
              top   : event.page.y,
              left  : event.page.x,
              width : 0
          });
        }
        
        if (this.options.mode == 'auto') { // auto position
            
            top = trg.top - tip.height - 5; // (default)
            if (top > 0 && top > doc.y && top < (doc.y+doc.height)) { // Use bottom arrow (default)
                this.arrow('bottom');
            } else { // Use top arrow
                top = trg.top + 20;
                this.arrow('top');
            }
            
            if (trg.left + (trg.width) + this.options.width < doc.x + doc.right) { // Use left arrow (default)
                left = trg.left + (trg.width) - 20;
                this.arrow('left');
            } else if (trg.left - (tip.width / 2) + (trg.width / 2) + this.options.width < doc.x + doc.right ) { // Use center arrow
                left = trg.left - (tip.width / 2) + (trg.width / 2);
                this.arrow('center');
            } else { // use right arrow
                left = trg.left - (tip.width) + (trg.width) + 20;
                this.arrow('right');
            }
          
        } else { // fixed position

            if (this.options.tip.x=='c') {
              left = trg.left - (tip.width / 2) + (trg.width / 2);
            } else if (this.options.tip.x=='r') {
              left = trg.left - (tip.width) + (trg.width) + 20;
            } else {
              left = trg.left + (trg.width) - 20;
            }
            
            if (this.options.tip.y=='b') {
              top = trg.top - (tip.height) - 5;
            } else if (this.options.tip.y=='t') {
              top = trg.top + 20;
            }

        }
        return { 'top': top, 'left': left };
    },
    
    arrow: function(direction) {
        if (direction == "bottom") {
            if (!this.skeleton.bottom.hasChild(this.skeleton.arrow)) {
                this.skeleton.bottom.adopt(this.skeleton.arrow);
            }
        } else if (direction == "top") {
            if (!this.skeleton.top.hasChild(this.skeleton.arrow)) {
                this.skeleton.top.adopt(this.skeleton.arrow);
            }
        } else if (direction == "left") {
            this.skeleton.arrow.set('class', 'tooltip-l-arrow');
        } else if (direction == "right") {
            this.skeleton.arrow.set('class', 'tooltip-r-arrow');
        } else if (direction == "center") {
            this.skeleton.arrow.set('class', 'tooltip-c-arrow');
        }

        if (Browser.Engine.trident4) {
          this.skeleton.arrow.removeProperty('style');
          this.iesucks($splat(this.skeleton.arrow));
        }
        
    }

});