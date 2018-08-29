var ContextMenu = new Class({
	
	Implements: [Events, Options],
	
	options: {
		event: 'contextmenu',
		position: 'right' //right, left
	},
	
	target: null,
	
	menu: null,
	
	initialize: function(target, menuOptions, options) {
		
		this.setOptions(options);
		
		this.showMenu = this.showMenu.bind(this);
		this.hideMenu = this.hideMenu.bind(this);
		
		
		$(document.body).addEvent('click', this.hideMenu);
		
		this.menu = new Element('div.contentMenu-container').setStyles({
			'top': 10,
			'left': 10,
			'display': 'none'
		}).inject(document.body);
		
		$each(menuOptions,  function(value, key) {
			this.addSubMenu(value, key);
		}.bind(this));	
		
		if(target)
			this.target = target.addEvent(this.options.event, this.showMenu);
	},
	
	addSubMenu: function(listener, name) {
		new Element('div.contextMenu-subMenu', {
			html: name
		}).addEvent('click', listener).inject(this.menu);
	},
	
	showMenu: function(event) {
		if(window.contextMenuOpened)
			window.contextMenuOpened.hideMenu();
		
		//if(options.event == 'contextmenu')
			event.stop();
		
		this.menu.setStyle('display', 'block');
		
		if(this.options.position == 'right') {
			this.menu.setStyles({
				left: event.page.x,
				top: event.page.y
			});
		} else {
			this.menu.setStyles({
				left: event.page.x - this.menu.getWidth() + 15,
				top: event.page.y + 5
			});
		}

		window.contextMenuOpened = this;
		
		this.fireEvent('show');
	},
	
	hideMenu: function() {
		this.menu.setStyle('display', 'none');
		window.contextMenuOpened = null;
		this.fireEvent('hide');
	},
	
	destroy: function() {
		if(this.target)
			this.target.removeEvent(this.options.event, this.showMenu);
		document.body.removeEvent('click', this.hideMenu);
		this.menu.destroy();
	},
	
	detach: function() {
		if(this.target)
			this.target.removeEvent(this.options.event, this.showMenu);
	},
	
	attach: function(target) {
		if(target)
			this.target = target.addEvent(this.options.event, this.showMenu);
	}
});

var ContextMenuModal = new Class({
	
	Implements: [Events, Options],
	
	options: {
		event: 'click',
		position: 'left' //right, left, center
//		hr: true
	},
	
	target: null,
	
	menu: null,
	
	initialize: function(target, menuOptions, options) {
		
		this.setOptions(options);
		
		this.showMenu = this.showMenu.bind(this);
		this.hideMenu = this.hideMenu.bind(this);
		
		
		$(document.body).addEvent('click', this.hideMenu);
		
		this.menu = new Element('div.contentMenu-container').setStyles({
			'top': 10,
			'left': 10,
			'display': 'none'
		}).inject(document.body).addEvent('click', function(e) {
			if(e.target.tagName != 'a' && e.target.tagName != 'A' && e.target.nodeName != 'A' && e.target.nodeName != 'a' && !e.target.getParent('a'))
				e.stop();
		});
		
//		var last_hr = null;
		$each(menuOptions,  function(value) {
			new Element('div.contextMenuModal-subMenu', {
				html: value
			}).inject(this.menu);
			
//			if(this.options.hr)
//				last_hr = new Element('hr').inject(this.menu);
		}.bind(this));
		
//		if(last_hr)
//			last_hr.destroy();
		
		if(target)
			this.target = target.addEvent(this.options.event, this.showMenu);
	},
	
	showMenu: function(event) {
		if(window.contextMenuOpened)
			window.contextMenuOpened.hideMenu();
		
		event.stop();
		
		this.menu.setStyle('display', 'block');
		
		if(this.options.position == 'right') {
			this.menu.setStyles({
				left: event.page.x,
				top: event.page.y
			});
		} else if(this.options.position == 'center') {
			this.menu.setStyles({
				left: event.page.x - this.menu.getWidth() / 2,
				top: event.page.y + 5
			});
		} else {
			this.menu.setStyles({
				left: event.page.x - this.menu.getWidth() + 45,
				top: event.page.y + 5
			});
		}

		window.contextMenuOpened = this;
		
		this.fireEvent('show');
	},
	
	hideMenu: function() {
		this.menu.setStyle('display', 'none');
		window.contextMenuOpened = null;
		this.fireEvent('hide');
	},
	
	destroy: function() {
		if(this.target)
			this.target.removeEvent(this.options.event, this.showMenu);
		document.body.removeEvent('click', this.hideMenu);
		this.menu.destroy();
	},
	
	detach: function() {
		if(this.target)
			this.target.removeEvent(this.options.event, this.showMenu);
	},
	
	attach: function(target) {
		if(target)
			this.target = target.addEvent(this.options.event, this.showMenu);
	}
});