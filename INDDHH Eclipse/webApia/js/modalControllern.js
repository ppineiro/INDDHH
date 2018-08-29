ModalController = {
	
	modal_mask: null,
	
	modals: new Array(),
	
	/**
	 * Abre un modal. Si no se establece top/left se intena centrar horizontalmente/verticalmente
	 */
	openWinModal: function (url, width, height, top, left, hideTitle, hideConfirmBtn, hideCloseBtn) {
		
		if(width == undefined) width = 500;
		if(height == undefined) height = 400;
			
		var parent = $(document.body);
		
		var modal = new ModalWindow(true, parent, url, width, height, top, left, hideTitle, hideConfirmBtn, hideCloseBtn).showModal();
		
		this.modals.push(modal);
		
		if(this.modals.length == 1) {
			this.disableScroll();
		}
		
		if(!this.modal_mask) {
			this.modal_mask = new Mask($(document.body)).hide();
		}
		
		this.modal_mask.show();
		this.modal_mask.element.setStyle('width', '100%');
		
		if(navigator.userAgent.indexOf("OPR"))
			this.modal_mask.element.setStyle('height', Number.from(this.modal_mask.element.getStyle('height')) - 1);
		
		
		modal.modalWin.getElement('iframe').set('tabIndex', '0').setStyle('outline', 'none').focus();
		
		return modal;
	},
	
	/**
	 * Abre un modal. En lugar de pasarle una url, se le pasa el contenido que va a colocar adentro del modal
	 */
	openContentModal: function(content, width, height, top, left, hideTitle, hideConfirmBtn, hideCloseBtn) {
		
		if(!this.modal_mask) {
			this.modal_mask = new Mask($(document.body)).hide();
		}
		
		this.modal_mask.show();
		
		this.modal_mask.element.setStyle('width', '100%');
		
		if(navigator.userAgent.indexOf("OPR"))
			this.modal_mask.element.setStyle('height', Number.from(this.modal_mask.element.getStyle('height')) - 1);
		
		if(width == undefined) width = 500;
		if(height == undefined) height = 400;
			
		var parent = $(document.body);
		
		var modal = new ModalWindow(false, parent, content, width, height, top, left, hideTitle, hideConfirmBtn, hideCloseBtn).showModal();
		
		this.modals.push(modal);
		
		if(this.modals.length == 1) {
			this.disableScroll();
		}
		
		modal.modalWin.getElement('iframe').set('tabIndex', '0').setStyle('outline', 'none').focus();
		
		return modal;
	},

	closeWinModal: function(modal) {
		modal.closeModal();
	},
	
	disableScroll: function() {
		window.addEvent('mousewheel', this.scrollHandler);
		document.body.addClass('modal-disable-scroll');
	},
	
	enableScroll: function() {
		window.removeEvent('mousewheel', this.scrollHandler);
		document.body.removeClass('modal-disable-scroll');
	},
	
	scrollHandler: function(e) {
		e.preventDefault();
	},
	
	hideMask: function() {
		if(!this.modal_mask.hidden) {
			
			if(Browser.chrome || Browser.firefox || Browser.safari) {
				var morph = new Fx.Morph(this.modal_mask.element, {duration: 200, wait: false});
				
				var modal_mask = this.modal_mask;
				morph.start({
					opacity: 0
				}).chain(function() {
					modal_mask.hide();
					modal_mask.element.style.opacity = '';
					
					if(ModalController.modals.length == 0)
						ModalController.enableScroll();
				});
			} else{
				this.modal_mask.hide();
				
				if(ModalController.modals.length == 0)
					ModalController.enableScroll();
			}
		}
	}
};

/**
 * Eventos: show, close, confirm
 */
var ModalWindow = new Class({
	
	Implements: Events,
	
	modalWin: null,
	
	initialize: function (isIframe, parent, data, width, height, top, left, hideTitle, hideConfirmBtn, hideCloseBtn) {
		
		this.modalWin = new Element('div.modalWin').setStyles({
			width: width,
			height: height
		});
		
		if(top == undefined || top == null) {
			this.modalWin.setStyles({
				top: '50%',
				'margin-top': -height/2
			});
		} else {
			this.modalWin.setStyle('top', top);
		}
		if(left == undefined || left == null) {
			this.modalWin.setStyles({
				left: '50%',
				'margin-left': -width/2
			});
		} else {
			this.modalWin.setStyle('left', left);
		}
		
		var top_bar = new Element('div.modalTopBar').inject(this.modalWin)
		if(hideTitle) {
//			top_bar.setStyle('height', 0);
//			top_bar.setStyle('display', 'none');
			top_bar.setStyle('height', 10);
		}
		var bottom_bar;
		if(!hideConfirmBtn || !hideCloseBtn)
			bottom_bar = new Element('div.modalBottomBar').inject(this.modalWin);		
		
		this.modalWin.inject(parent);
		
		var pos = this.modalWin.getPosition();
		this.modalWin.setStyles({
			top: parent.getScroll() ? parent.getScroll().y + pos.y : pos.y,
			left: pos.x,
			'margin-top': 0,
			'margin-left': 0
		});
		
		if(isIframe) {
			var ifrm = new Element('iframe.modal-content', {
				src: data,
				frameBorder: 0
			}).setStyle('height', height - Number.from(top_bar.getStyle('height')) - ( bottom_bar ? Number.from(bottom_bar.getStyle('height')) : 0)).inject(top_bar, 'after');
			
			ifrm.addEvent('confirmTask', function() {
				this.confirmTask();
			}.bind(this));
			
			ifrm.addEvent('confirmModal', function() {
				this.confirmModal();
			}.bind(this));
			
			ifrm.addEvent('closeModal', function() {
				this.closeModal();
			}.bind(this));
			
			ifrm.addEvent('block', function() {
				this.block();
			}.bind(this));
			
			ifrm.addEvent('unblock', function() {
				this.unblock();
			}.bind(this));
			
			ifrm.addEvent('load', function(evt) {
				if(evt.target && evt.target.contentDocument && evt.target.contentDocument.window) {
					if(evt.target.contentDocument.window.MODAL_HIDE_OVERFLOW) {
						evt.target.resizeIFrame = function() {
							
							evt.target.doResize = undefined;
							
							//Agrandar tamaño de la ventana
							var curr_height = Number.from(evt.target.getStyle('height'));
							var new_height = evt.target.contentDocument.body.scrollHeight;
							var diff_height = new_height - curr_height;
							
							if(Browser.firefox)
								diff_height = diff_height + 2;
							
							if(diff_height > 0) {
								this.modalWin.set('morph', {duration: 200});
								this.modalWin.morph({height: Number.from(this.modalWin.getStyle('height')) + diff_height, top: Number.from(this.modalWin.getStyle('top')) - diff_height / 2});
								
								if(this.footer_mask) {
									this.footer_mask.element.set('morph', {duration: 200});
									this.footer_mask.element.morph({top: Number.from(this.footer_mask.element.getStyle('top')) + diff_height});
								}
								
								
								evt.target.set('morph', {duration: 200});
								evt.target.morph({height: Number.from(evt.target.getStyle('height')) + diff_height});

							}
							
							
//							evt.target.doResize = true;
							
						}.bind(this);
						
						evt.target.timeout = setTimeout(evt.target.resizeIFrame, 500);
						evt.target.modalWin = this.modalWin;
						evt.target.doResize = true;
						
						evt.target.contentDocument.window.addEvent('resize', function() {
							if(evt.target.doResize) {
								clearTimeout(evt.target.timeout);
								evt.target.timeout = setTimeout(evt.target.resizeIFrame, 500);
							}
						});
					}
				}
				
			}.bind(this));
		} else {
			//data.setStyle('height', height - Number.from(top_bar.getStyle('height')) - Number.from(bottom_bar.getStyle('height'))).inject(top_bar, 'after');
			
			var ifrm = new Element('iframe.modal-content', {
				src: data.url,
				frameBorder: 0
			}).setStyle('height', height - Number.from(top_bar.getStyle('height')) - ( bottom_bar ? Number.from(bottom_bar.getStyle('height')) : 0)).inject(top_bar, 'after')
			.addEvent('load', function() {
				var body = $(ifrm.contentWindow.document.body).grab(data.content);
				this.fireEvent('load', body);
			}.bind(this))
			.addEvent('closeModal', function() {
				this.closeModal();
			}.bind(this))
			.addEvent('block', function() {
				this.block();
			}.bind(this))
			addEvent('unblock', function() {
				this.unblock();
			}.bind(this));
		}
		
		if(!hideTitle)
			new Element('div.modalCloseBtn').inject(top_bar).addEvent('click', this.closeModal.bind(this));
		
		if(!hideConfirmBtn || !hideCloseBtn) {
			if(!hideCloseBtn)
				Generic.setButton(new Element('div.modalBottomBarClose', {html: BTN_CANCEL}).inject(bottom_bar)).addEvent('click', this.closeModal.bind(this));
			if(!hideConfirmBtn)
				Generic.setButton(new Element('div.modalBottomBarConfirm.suggestedAction', {html: BTN_CONFIRM}).inject(bottom_bar)).addEvent('click', this.confirmModal.bind(this));
		}
		
		var dragInstance = new Drag(this.modalWin, {
			handle: top_bar
		});
	},
	
	showModal: function () {
		
		this.fireEvent('show');
		return this;
	},
	
	closeModal: function () {
		
		this.modalWin.getParent().focus();
		
		//this.modalWin.destroy();
		if(Browser.chrome || Browser.firefox || Browser.safari) {
			var morph = new Fx.Morph(this.modalWin, {duration: 200, wait: false});
			
			var modalWin = this.modalWin;
			morph.start({
				'margin-top': '-10px',
				'opacity': 0
			}).chain(function() {
				modalWin.destroy();
			});
		} else {
			this.modalWin.destroy();
		}
		
		ModalController.modals.splice(ModalController.modals.indexOf(this), 1);
		
		//ModalController.modal_mask.hide();
		ModalController.hideMask();
		
//		ModalController.modals.splice(ModalController.modals.indexOf(this), 1);
//		
//		if(ModalController.modals.length == 0)
//			ModalController.enableScroll();
		
		this.fireEvent('close');
		return this;
	},
	
	confirmModal: function () {
		var ifrm = this.modalWin.getElement('iframe.modal-content');
		if(ifrm && ifrm.contentWindow && ifrm.contentWindow.getModalReturnValue) {
			var res = ifrm.contentWindow.getModalReturnValue(this);
			if(res != null) {
				this.fireEvent('beforeConfirm', [res]);
				this.closeModal();
				this.fireEvent('confirm', [res]);
			}
		} else {
			this.fireEvent('beforeConfirm');
			this.closeModal();
			this.fireEvent('confirm');
		}
		return this;
	},
	
	setConfirmLabel: function (lbl) {
		var confirmButton = this.modalWin.getElement('div.modalBottomBarConfirm');
		
		if(confirmButton) {
			confirmButton.getElement('span').set('html', lbl);
		}
		
		return this;
	},
	
	block: function() {
		if(!this.title_mask)
			this.title_mask = new Mask(this.modalWin.getElement('div.modalTopBar')).hide();
		
		this.title_mask.show();
		
		if(!this.footer_mask)
			this.footer_mask = new Mask(this.modalWin.getElement('div.modalBottomBar')).hide();
		
		this.footer_mask.show();
		
	},
	
	unblock: function() {
		if(this.title_mask) {
			this.title_mask.hide();
			this.title_mask.destroy();
		}
		if(this.footer_mask) {
			this.footer_mask.hide();
			this.footer_mask.destroy();
		}
	},
	
	confirmTask: function () {
		var ifrm = this.modalWin.getElement('iframe.modal-content');
		if(ifrm && ifrm.contentWindow && ifrm.contentWindow.getModalReturnValue) {
			var res = ifrm.contentWindow.getModalReturnValue(this);
			if(res != null) {
				this.fireEvent('beforeConfirm', [res]);
				this.closeModal();
				this.fireEvent('confirm', [res]);
			}
		} else {
			this.fireEvent('beforeConfirm');
			this.closeModal();
			this.fireEvent('confirm');
		}
		
		var btnConf = $('btnConf');
		if(btnConf)
			btnConf.fireEvent('click');
		
		return this;
	},
});