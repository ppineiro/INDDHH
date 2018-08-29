/**
 * Formulario
 */
var Form = new Class({
	
	Implements: Options,
	
	options: {},
	
	id: null,
	
	frmType: null, //E, P
	
	wrapper: null,
	
	cols: 4,
	
	fields: [],
	
	DOMform: null,
	
	xml: null,
	
	readOnly: false,
	
	closed: false,
	
	/*signable: false,*/
	
	signRequired: false,
	
	markedToSign: false,
	
	signed: false,
	
	contentTab: null, //Utilizado solo si es de tipo tab
	tabContent: null, //Utilizado solo si es de tipo tab
	
	form_tab_parent: null, //Form de tipo tab padre del form actual
	
	initialize: function(contentDIV) {
		
		this.DOMform = contentDIV;
		
		//Parsear XML
		var xmlDoc;
		if (window.DOMParser) {
			parser = new DOMParser();
			xmlDoc = parser.parseFromString(contentDIV.getAttribute("xml"),"text/xml");
		} else {
			// Internet Explorer
			xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async = false;
			xmlDoc.loadXML(contentDIV.getAttribute("xml")); 
		}
		
		this.xml = xmlDoc.childNodes[0];
		
		/*
		this.options[Form.PROPERTY_FORM_INVISIBLE] 	= null;
		this.options[Form.PROPERTY_FORM_HIDDEN] 	= null;
		this.options[Form.PROPERTY_FORM_CLOSED] 	= null;
		this.options[Form.PROPERTY_FORM_TAB] 		= null;
		this.options[Form.PROPERTY_FORM_HIGHLIGHT] 	= null;
		this.options[Form.PROPERTY_FORM_DONT_FIRE] 	= null;
		*/		
		this.options = JSON.decode(this.xml.getAttribute(Field.FIELD_PROPERTIES));
		
		if(!this.options){
			this.options = {};
		}
		
		if(this.xml.getAttribute(Form.LANGUAGES) && !isMonitor)
			this.langs = JSON.decode(this.xml.getAttribute(Form.LANGUAGES));
		
		
		//if(IN_MONITOR)
		//	this.readOnly = true;
		//else
			this.readOnly = this.xml.getAttribute("readOnly") == "true";
		
		this.options[Form.PROPERTY_FORM_READONLY] = this.xml.getAttribute("readOnly");
			
		this.options[Form.PROPERTY_FORM_CLOSED] = this.xml.getAttribute("prpFrmClosed");
		this.closed = this.xml.getAttribute("prpFrmClosed") == "true"; 
		
		contentDIV.set('html', '');
		contentDIV.erase('xml');
		
		contentDIV.store(Field.STORE_KEY_FORM, this);
		
		if(window.editionMode) {
			contentDIV.setStyle('padding-top', '15px');
		}
		
		var frmType = this.DOMform.get('id').split("_")[0];
		this.frmType = frmType;
	},
	
	/**
	 * Parsea el xml generando el formulario
	 */
	parseXML: function(form_tab_parent) {
		
		
		this.frmName = this.xml.getAttribute("formName");
			
		var frmType = this.DOMform.get('id').split("_")[0];
		var frmId = this.xml.getAttribute("id");
		
		//this.frmType = frmType;
		
		this.id = frmType + "_" + this.xml.getAttribute("id"); 
		
		this.isGridEditionForm = this.xml.getAttribute("editModal") == "true";
		this.gridEditionIndex = Number.from(this.xml.getAttribute("modalIndex"));
		
		if(this.isGridEditionForm)
			this.DOMform.addClass('gridEditionForm');
		
		if(this.options[Form.PROPERTY_FORM_HIDDEN]) {
			this.hideForm();
		}
		
		if(this.options[Form.PROPERTY_FORM_TAB] == "true") {
			
			//Crea el tab
			this.contentTab = $('tabComponent').add(this.xml.getAttribute("formTitle"));
			this.frmTitle = this.xml.getAttribute("formTitle");
			this.tabContent = new Element('div.tabContent').inject(this.contentTab);
			
			if(form_tab_parent) {
				if(form_tab_parent.tabTitle) {
					if(currentContentTab)
						this.contentTab.tabTitle.inject(currentContentTab, 'after');
					else
						this.contentTab.tabTitle.inject(form_tab_parent.tabTitle, 'after');
				} else if(form_tab_parent.contentTab.tabTitle) {
					this.contentTab.tabTitle.inject(form_tab_parent.contentTab.tabTitle, 'after');
				}
			}
			
			currentContentTab = this.contentTab.tabTitle;
			
			if(this.options[Form.PROPERTY_FORM_HIGHLIGHT] == "true") {
				this.contentTab.tabTitle.addClass('highlight-tab');
			} else {
				this.contentTab.tabTitle.removeClass('highlight-tab');
			}
			
			Form.addCollapseFunctions(this);
			
		} else {
			
			//if(this.DOMform == null) {
				//this.DOMform = new Element('div');
			
				if(form_tab_parent) {
					this.form_tab_parent = form_tab_parent;
					if(instanceOf(form_tab_parent, Form)) {
						this.DOMform.dispose().inject(this.form_tab_parent.tabContent);
						
						if(this.options[Form.PROPERTY_FORM_HIGHLIGHT] == "true")
							this.form_tab_parent.contentTab.tabTitle.addClass('highlight-tab');
					} else {
						if(this.options[Form.PROPERTY_FORM_HIGHLIGHT] == "true")
							this.form_tab_parent.tabTitle.addClass('highlight-tab');
					}
				}
			
				this.DOMform.addClass('fieldGroup');
					
				var subTit = new Element('div');
				subTit.addClass('title').addClass('form-title');
				
				this.frmTitle = this.xml.getAttribute("formTitle");
				
				subTit.appendText(this.xml.getAttribute("formTitle"));
				
				var cols = Number.from(this.xml.getAttribute("cols"));
				var rows = Number.from(this.xml.getAttribute("rows"));
				
				this.cols = cols;
				
				var DOMtable = new Element("table", {
					id: "tbl" + this.id
				}).setStyle('table-layout', 'fixed');
				
				var DOMtBody = new Element("tbody");
				//DOMtable.appendChild(DOMtBody);
				DOMtBody.inject(DOMtable);
				
				for(var r = 0; r < rows; r++) {
					
					var tr = new Element('tr');
					for(var c = 0; c < cols; c++) {
						var td = new Element('td', {
							id: this.id + "_gr_" + r + "_" + c
						});
						
						td.inject(tr);
						//tr.appendChild(td);
					}
					//DOMtBody.appendChild(tr)
					tr.inject(DOMtBody);
				}		
				
				DOMtable.setStyle('width', '100%');
				
				//DOMtable.style.width = "100%";
				//DOMtable.id = "tbl" + this.id;			
				
				var signatureDiv;
				
				//Formularios firmables
				if(this.xml.getAttribute(Form.SIGNABLE_FORM) == "true") {
					this.signableForm = true;
					var sign_class = 'uncheck-img';
									
					if(this.xml.getAttribute(Form.MARKED_TO_SIGN) == "true") {
						this.markedToSign = true;
						var sign_class = 'check-img';
					}
					
					signatureDiv = new Element('div').setStyles({
						float: 'right'/*,
						'margin-top': '-10px'*/
					});
					
					/*var margin_top = (!Browser.ie ? 'style="margin-top: 3px"' : '');*/
					/*
					this.buttonSign = Generic.setButton(new Element('div.mark-to-sign', {
						html: '<table cellspacing="0" cellpadding="0" ' +  margin_top + '><tbody><tr><td class="no-padding"><span style="line-height:15px;">' + BTN_MARK_FRM_TO_SIGN + '</span></td><td class="no-padding"><div style="line-height:17px;" class="' + sign_class + '"></div></td></tr></tbody></table>'
					})).inject(signatureDiv);
					*/
					
					if(!isMonitor && !window.kb && !IS_READONLY && !this.readOnly) {
						this.buttonSign = new Element('div.mark-to-sign', {
							//html: '<table cellspacing="0" cellpadding="0" ' +  margin_top + '><tbody><tr><td class="no-padding"><span style="line-height:15px;">' + BTN_MARK_FRM_TO_SIGN + '</span></td><td class="no-padding"><div style="line-height:17px;" class="' + sign_class + '"></div></td></tr></tbody></table>'
							html: '<table cellspacing="0" cellpadding="0"><tbody><tr><td class="no-padding"><span style="line-height:15px;">' + BTN_MARK_FRM_TO_SIGN + '</span></td><td class="no-padding" style="padding-left: 3px;"><div style="line-height:17px;" class="' + sign_class + '"></div></td></tr></tbody></table>'
						}).inject(signatureDiv);
						
						if(this.xml.getAttribute(Form.REQUIRED_SIGN) == "true") {
							this.signRequired = true;
							//El formulario tiene firma requerida, se marca para firmar y se lo deshabilita
							this.signed = true;
						} else {
							//Se agrega la funcion para marcar para firmar
							this.buttonSign.addEvent('click', this.signForm.bind(this));
						}
					}
					
					/*
					var buttonVerify = Generic.setButton(new Element('div.verify-signature', {
						html: BTN_VERIFY_FRM_SIGN
					})).inject(signatureDiv).addEvent('click', function() {
						ModalController.openWinModal(CONTEXT +  '/apia.execution.FormAction.run?action=viewSigns&frmId=' + frmId + '&frmParent=' + frmType + TAB_ID_REQUEST, 700, 460, null, null, true,true,false);
					});
					*/
					if(!window.hideSignVerification) {
						var buttonVerify = new Element('div.verify-signature', {
							html: BTN_VERIFY_FRM_SIGN
						}).inject(signatureDiv).addEvent('click', function() {
							ModalController.openWinModal(CONTEXT +  '/apia.execution.FormAction.run?action=viewSigns&frmId=' + frmId + '&frmParent=' + frmType + TAB_ID_REQUEST, 700, 460, null, null, true,true,false);
						});
					}
					signatureDiv.inject(subTit);
					
					//subTit.setStyle('height', '25px');
				}
				
//				if(this.langs && !isMonitor && !this.readOnly) {
//					if(!signatureDiv) {
//						signatureDiv = new Element('div').setStyle('float', 'right').inject(subTit);
//					}
//					
//					new Element('div.langIco', {title: 'Mostrar traduccion de contenido'}).inject(signatureDiv).addEvent('click', function(evt) {
//						evt.target.toggleClass('active');
//						DOMtable.toggleClass('hideTranslation');
//					});
//					
//					DOMtable.toggleClass('hideTranslation');
//					
//				}
				
				var domform = this.DOMform;
				
				this.collapseBtn = (new Element('div.collapseForm')).inject(this.DOMform);
				this.collapseBtn.addEvent('click', this.callAjaxCollapse.bind(this));
				
				
				//DOMform.appendChild(subTit);
				subTit.inject(this.DOMform);
				//DOMform.appendChild(DOMtable);
				DOMtable.inject(this.DOMform);
				//this.wrapper.appendChild(DOMform);
				//no es necesario
				//this.DOMform.inject(this.wrapper);
			//}
				
			for(var i = 0; i < this.xml.childNodes.length; i++) {
				
				//TODO: pasar el this.gridEditionIndex al field si this.isGridEditionForm
				var field = this.parseField(this.xml.childNodes[i]);
				
				//this.fields.push(field);
				if(field)
					this.fields.include(field);
			}
			
			if(this.closed) {
				this.max_height = Generic.getHiddenHeight(this.DOMform) + 15;
				this.DOMform.getChildren('table')[0].setStyles({
					'opacity': 0,
					'display': 'none'
				});
				this.DOMform.setStyle('height', 23);
				
				this.collapseBtn.toggleClass('collapseForm').toggleClass('expandForm');
			}
			
			this.DOMform.addEvent('validateFailure', this.validateFailure.bind(this));
		
		}
		
		//Se comenta porque ya se hace en el initPage
//		if(this.xml.getAttribute(Form.FUNC_LOAD)) {
//			var fn_load = window[this.xml.getAttribute(Form.FUNC_LOAD)];
//			if(fn_load)
//				fn_load();
//		}
		
		//Se comenta porque ya se hace en el initPage
//		if(this.xml.getAttribute(Form.FUNC_RELOAD)) {
//			var fn_reload = window[this.xml.getAttribute(Form.FUNC_RELOAD)];
//			if(fn_reload)
//				fn_reload();
//		}
		
		if(this.options[Form.PROPERTY_FORM_HIDDEN]) {
			if(this.fields) this.fields.each(function(field) {field.hideFormListener();});
		}
	},
	
	/**
	 * Crea un nuevo campo
	 */
	parseField: function(xml) {
		
		var field;
		
		switch (xml.getAttribute("fieldType")) {
			
			case Field.TYPE_INPUT:
				field = new Input(this, this.id, xml);				
				break;
			case Field.TYPE_SELECT:
				field = new Select(this, this.id, xml);
				break;
			case Field.TYPE_RADIO:
				field = new Radio(this, this.id, xml);			
				break;
			case Field.TYPE_CHECK:
				field = new Check(this, this.id, xml);
				break;
			case Field.TYPE_BUTTON:
				field = new Button(this, this.id, xml);			
				break;
			case Field.TYPE_AREA:
				field = new Area(this, this.id, xml);				
				break;
			case Field.TYPE_LABEL:
				field = new Label(this, this.id, xml);				
				break;
			case Field.TYPE_TITLE:
				field = new Title(this, this.id, xml);				
				break;
			case Field.TYPE_FILE:
				field = new Fileinput(this, this.id, xml);				
				break;
			case Field.TYPE_MULTIPLE:
				field = new Multiple(this, this.id, xml);				
				break;
			case Field.TYPE_HIDDEN:
				field = new Hidden(this, this.id, xml);
				break;
			case Field.TYPE_PASSWORD:
				field = new Password(this, this.id, xml);
				break;
			case Field.TYPE_GRID:
				field = new Grid(this, this.id, xml);
				break;
			case Field.TYPE_IMAGE:
				field = new Image(this, this.id, xml);
				break;
			case Field.TYPE_HREF:
				field = new Href(this, this.id, xml);
				break;
			case Field.TYPE_EDITOR:
				field = new Editor(this, this.id, xml);
				break;
			case Field.TYPE_TREE:
				field = new Tree(this, this.id, xml);
				break;
		}
		
		return field;
	},
	
	hideForm: function() {
		this.DOMform.setStyle('display', 'none');
		this.options[Form.PROPERTY_FORM_HIDDEN] = "true";
		if(this.fields) this.fields.each(function(field) {field.hideFormListener();});
	},
	
	showForm: function() {
		this.DOMform.setStyle('display', '');
		this.options[Form.PROPERTY_FORM_HIDDEN] = "false";
		if(this.fields) this.fields.each(function(field) {field.showFormListener();});
	},
	
	setHighlight: function(value) {
		
		this.options[Form.PROPERTY_FORM_HIGHLIGHT] = String.from(value);
		
		if(this.options[Form.PROPERTY_FORM_TAB] == "true") {
			if(this.options[Form.PROPERTY_FORM_HIGHLIGHT] == "true")
				this.contentTab.tabTitle.addClass('highlight-tab');
			else
				this.contentTab.tabTitle.removeClass('highlight-tab');
		} else {			
			if(instanceOf(this.form_tab_parent, Form)) {
				if(this.options[Form.PROPERTY_FORM_HIGHLIGHT] == "true")
					this.form_tab_parent.contentTab.tabTitle.addClass('highlight-tab');
				else
					this.form_tab_parent.contentTab.tabTitle.removeClass('highlight-tab');
			} else {
				if(this.options[Form.PROPERTY_FORM_HIGHLIGHT] == "true")
					this.form_tab_parent.tabTitle.addClass('highlight-tab');
				else
					this.form_tab_parent.tabTitle.removeClass('highlight-tab');
			}
		}
	},
	
	collapseBtn: null, 
	
	transitioning: false,
	
	max_height: 0,
	
	expandIconClick: function(noFx) {
		if(!this.transitioning) {
			this.transitioning = true;
			
			if(this.collapseBtn.hasClass('collapseForm')) {
				this.collapseForm(noFx);
			} else {
				this.expandForm(noFx);
			}
		}
	},
	
	collapseForm: function(noFx) {
		
		var current_form = this;
		
		current_form.max_height = Generic.getHiddenHeight(current_form.DOMform) + 15;//current_form.DOMform.getHeight();
			
		//Collapse form			
		var fx = new Fx.Morph(current_form.DOMform.getChildren('table')[0], {
			duration: noFx ? 10 : 400,
			transition: Fx.Transitions.Quart.easeIn
		});
		
		if(this.form_tab_parent && this.form_tab_parent.fireFormCollapseInit)
			this.form_tab_parent.fireFormCollapseInit(this);
			
		fx.start({
			'opacity': 0
		}).chain(function() {
			(new Fx.Morph(current_form.DOMform, {
				duration: noFx ? 10 : 600
			})).start({
				'height': 23
			}).chain(function() {
				
				current_form.DOMform.getChildren('table')[0].setStyle('display', 'none');				
				
				current_form.collapseBtn.toggleClass('collapseForm').toggleClass('expandForm');
				current_form.transitioning = false;
				
				if(current_form.form_tab_parent && current_form.form_tab_parent.fireFormCollapseEnd)
					current_form.form_tab_parent.fireFormCollapseEnd(current_form);
				
				current_form.options[Form.PROPERTY_FORM_CLOSED] = "true";
		    });
	    });
	},
	
	expandForm: function(noFx) {

		var current_form = this;
		
		if(this.form_tab_parent && this.form_tab_parent.fireFormCollapseInit)
			this.form_tab_parent.fireFormCollapseInit(this);
		
		//Expand form			
		var fx = new Fx.Morph(current_form.DOMform, {
			duration: noFx ? 10 : 600,
			transition: Fx.Transitions.Quart.easeOut
		});
		
		current_form.DOMform.getChildren('table')[0].setStyle('display', '');
		
		fx.start({
			'height': current_form.max_height
		}).chain(function() {
			(new Fx.Morph(current_form.DOMform.getChildren('table')[0], {
				duration: noFx ? 10 : 400
			})).start({
				'opacity': 1
			}).chain(function() {						

				current_form.collapseBtn.toggleClass('collapseForm').toggleClass('expandForm');
				current_form.transitioning = false;
				
				if(current_form.form_tab_parent && current_form.form_tab_parent.fireFormCollapseEnd)
					current_form.form_tab_parent.fireFormCollapseEnd(current_form);
				
				current_form.options[Form.PROPERTY_FORM_CLOSED] = "false";
		    });
	    });
	},
	
	callAjaxCollapse: function() {
			
		if(isMonitor) {
			this.expandIconClick();
		} else {
			var frmId = this.id.split('_')[1];
			var frmParent = this.id.split('_')[0];
			var form = this;
			var collapse = !this.closed;
			
			if(this.isGridEditionForm)
				frmParent += '&editionMode=true';
					
			new Request({
				url: 'apia.execution.FormAction.run?action=closeForm&frmId=' +  frmId + '&frmParent=' + frmParent + '&collapse=' + collapse + TAB_ID_REQUEST,
			    
				onSuccess: function(responseText, responseXML) {
			    	
					//TODO: parsearErrores y mensajes
					if(responseXML && responseXML.childNodes && responseXML.childNodes.length){
						if(responseXML.childNodes[0].tagName == 'result') {
							if(responseXML.childNodes[0].getAttribute('success') == 'true') {
								if(!form.closed) {
									form.expandIconClick();
									form.closed = true;
								} else {
									form.expandIconClick();
									form.closed = false;
								}
							}
						} else if(responseXML.childNodes[1].tagName == 'result') {
							//IE friendly
							if(responseXML.childNodes[1].getAttribute('success') == 'true') {
								if(!form.closed) {
									
									form.expandIconClick();
									form.closed = true;
								} else {
									
									form.expandIconClick();
									form.closed = false;
								}
							}
						}
					} else {
						//Fallo el llamado
						//TODO: Mostrar error
					}
			    },
			    
			    onFailure: function(xhr) {
			    	//TODO: onFailure
			    }
			}).send();
		}
	},
	
	signForm: function(e) {
		
		var sign = "true";
		if(this.signed)
			sign = "false";
		
		var frmId = this.id.split('_')[1];
		var frmParent = this.id.split('_')[0];
		var form = this;
		
		new Request({
			url: 'apia.execution.FormAction.run?action=markFormToSign&frmId=' +  frmId + '&frmParent=' + frmParent + '&sign=' + sign + TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
		    	
				//TODO: parsearErrores y mensajes
				if(responseXML && responseXML.childNodes && responseXML.childNodes.length){
					if(responseXML.childNodes[0].tagName == 'result') {
						if(responseXML.childNodes[0].getAttribute('success') == 'true') {
							if(!form.signed) {
								//Cambiar css de div a check-img
								var divImgs = form.buttonSign.getElements('div.uncheck-img');
								if(divImgs && divImgs.length) {
									divImgs[0].removeClass('uncheck-img').addClass('check-img');
								}
								
								form.signed = true;
							} else {
								//Cambiar css de div a uncheck-img
								var divImgs = form.buttonSign.getElements('div.check-img');
								if(divImgs && divImgs.length) {
									divImgs[0].removeClass('check-img').addClass('uncheck-img');
								}
								
								form.signed = false;
							}
						}
					} else if(responseXML.childNodes[1].tagName == 'result') {
						//IE friendly
						if(responseXML.childNodes[1].getAttribute('success') == 'true') {
							if(!form.signed) {
								//Cambiar css de div a check-img
								var divImgs = form.buttonSign.getElements('div.uncheck-img');
								if(divImgs && divImgs.length) {
									divImgs[0].removeClass('uncheck-img').addClass('check-img');
								}
								
								form.signed = true;
							} else {
								//Cambiar css de div a uncheck-img
								var divImgs = form.buttonSign.getElements('div.check-img');
								if(divImgs && divImgs.length) {
									divImgs[0].removeClass('check-img').addClass('uncheck-img');
								}
								
								form.signed = false;
							}
						}
					}
				}
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO: onFailure
		    }
		}).send();
	},
	
	getPrintHTML: function() {
		
		//var frmType = this.DOMform.get('id').split("_")[0];
		//var frmId = this.xml.getAttribute("id");
		
		//this.id = frmType + "_" + this.xml.getAttribute("id"); 
		/*
		if(this.options[Form.PROPERTY_FORM_INVISIBLE]) {
			this.hideForm();
		}
		*/
		if(this.options[Form.PROPERTY_FORM_TAB] != "true") {
			
			//this.DOMform.addClass('fieldGroup');
				
			var subTit = new Element('div.title', {html: this.frmTitle});
			
			//this.frmTitle = this.xml.getAttribute("formTitle");
			
			//subTit.appendText(this.xml.getAttribute("formTitle"));
			
			//this.cols = cols;
			var rows = Number.from(this.xml.getAttribute("rows"));
			
						
			var DOMtable = new Element("table", {
				id: "tbl" + this.id
			});	
			var DOMtBody = new Element("tbody");
			
			DOMtBody.inject(DOMtable);
			
			for(var r = 0; r < rows; r++) {
				
				var tr = new Element('tr');
				for(var c = 0; c < this.cols; c++) {
					var td = new Element('td', {
						id: this.id + "_gr_" + r + "_" + c
					});
					
					td.inject(tr);
					
				}
				tr.inject(DOMtBody);
			}		
			
			DOMtable.setStyle('width', '100%');
			
			
			//Formularios firmables
			if(this.xml.getAttribute(Form.SIGNABLE_FORM) == "true") {
				this.signableForm = true;
				var sign_class = 'uncheck-img';
								
				if(this.xml.getAttribute(Form.MARKED_TO_SIGN) == "true") {
					this.markedToSign = true;
					var sign_class = 'check-img';
				}
				
				var signatureDiv = new Element('div').setStyles({
					float: 'right',
					'margin-top': '-10px'
				});
				
				var margin_top = (!Browser.ie ? 'style="margin-top: 3px"' : '');
				
				Generic.setButton(new Element('div.mark-to-sign', {
					html: '<table cellspacing="0" cellpadding="0" ' +  margin_top + '><tbody><tr><td class="no-padding"><span style="line-height:15px;">' + BTN_MARK_FRM_TO_SIGN + '</span></td><td class="no-padding"><div style="line-height:17px;" class="' + sign_class + '"></div></td></tr><tbody></table>'
				})).inject(signatureDiv);
				
				var buttonVerify = Generic.setButton(new Element('div.verify-signature', {
					html: BTN_VERIFY_FRM_SIGN
				})).inject(signatureDiv);
				
				signatureDiv.inject(subTit);
				
			}
			
			var domform = new Element('div');
			subTit.inject(domform);
			DOMtable.inject(domform);
			
			for(var i = 0; i < this.fields.length; i++) {
				try {
					this.fields[i].getPrintHTML(domform);
				} catch(e) {
					if(window.console && console.log) console.log(e.message);
				}
			}
			
			if(this.closed) {
				this.max_height = Generic.getHiddenHeight(this.DOMform);			
				this.DOMform.getChildren('table')[0].setStyles({
					'opacity': 0,
					'display': 'none'
				});
				this.DOMform.setStyle('height', 23);
				
				this.collapseBtn.toggleClass('collapseForm').toggleClass('expandForm');
			}
		
			return '<div class="fieldGroup">' + domform.get('html') + '</div>';
		}
		
		return '';
	},
	
	validateFailure: function(event) {
		if(!this.collapseBtn.hasClass('collapseForm'))
			this.expandIconClick();
	}
});

Form.FUNC_LOAD					= "onload";
Form.FUNC_RELOAD				= "onreload";

Form.PROPERTY_FORM_INVISIBLE	= "frmInvisible";
Form.PROPERTY_FORM_HIDDEN 		= "frmHidden";
Form.PROPERTY_FORM_CLOSED 		= "frmClosed";
Form.PROPERTY_FORM_TAB 			= "frmTab";
Form.PROPERTY_FORM_HIGHLIGHT 	= "frmHighlight";
Form.PROPERTY_FORM_DONT_FIRE	= "frmDontFire";
Form.PROPERTY_FORM_READONLY		= "frmReadonly"; //ESTA PROPIEDAD SOLO PUEDE SER LEIDA 

Form.SIGNABLE_FORM				= "signableForm";
Form.MARKED_TO_SIGN				= "markedToSign";
Form.REQUIRED_SIGN				= "requiredSignableForm";

Form.LANGUAGES					= "langs";

Form.addCollapseFunctions = function(tab) {
	if(!tab) return;
	
	if(!tab.addFormCollapseListener) {
		/**
		 * listener must be a function
		 */
		tab.addFormCollapseListener = function(listener) {
			if(!tab.listeners) tab.listeners = new Array();
			tab.listeners.push(listener);
		}
	}
	if(!tab.removeFormCollapseListener) {
		/**
		 * listener must be a function
		 */
		tab.removeFormCollapseListener = function(listener) {
			if(tab.listeners && tab.listeners.indexOf(listener) > 0)
				tab.listeners.splice(tab.listeners.indexOf(listener), 1);
		}
	}
	if(!tab.fireFormCollapseInit) {
		tab.fireFormCollapseInit = function(source) {
			if(tab.listeners) {
				for(var i = 0; i < tab.listeners.length; i++) {
					tab.listeners[i]('init', source);
				}
			}
		}
	}
	if(!tab.fireFormCollapseEnd) {
		tab.fireFormCollapseEnd = function(source) {
			if(tab.listeners) {
				for(var i = 0; i < tab.listeners.length; i++) {
					tab.listeners[i]('end', source);
				}
			}
		}
	}
}