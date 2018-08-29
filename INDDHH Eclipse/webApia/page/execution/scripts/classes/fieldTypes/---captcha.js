/**
 * Campo Href
 */
var Captcha = new Class({
	
	Extends: Field,
	
	initialize: function(form, frmId, xml, rowXml) {
		//Establecer las opciones
		this.setDefaultOptions();		
		this.xml = xml;
		
		//No es de una grilla
		this.parent(form, frmId, xml.getAttribute("id"), JSON.decode(xml.getAttribute(Field.FIELD_PROPERTIES)), xml.getAttribute("attId"));
		this.parseXML();
		
	},
		
	setDefaultOptions: function() {
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
	},
	
	/**
	 * Metodo de APIJS para establecer propiedades
	 */
	apijs_setProperty: function(prp_name, prp_value) {
		
		if(this.form.readOnly) return;
		
		if(prp_name == Field.PROPERTY_CSS_CLASS) {
			
			var p = this.content.getParent().erase('class');
			
			this.options[Field.PROPERTY_CSS_CLASS] = prp_value;
			if(this.options[Field.PROPERTY_CSS_CLASS])
				this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
					if(clase) p.addClass(clase);
				});
		} else {
			//throw new Error('Property not found or not available for this field.');
		}
	},
	
	/**
	 * Parsea el xml
	 */
	parseXML: function() {
		
		//Hace espacio en el formulario y ubica el campo en su lugar.
		this.parseXMLposition();
		
		//TODO: Field_PROPERTY_NAME
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		if(!this.form.readOnly) {
			var link = new Element('a', {
				href: '#'
			});
			
			
			link.addClass('monitor-href');
			this.content.addClass('monitor_field');
			
			
			var label = new Element('label');
			
			var spanLabel = new Element('span.asLabel');			
			spanLabel.appendText(this.xml.getAttribute("attLabel") + ':');
			
			var img = new Element('img', {
				'data-fld_id': this.frmId + "_" + this.fldId,
				type: "text",
				src: CONTEXT + '/captchaImg?captchaName=' + TAB_ID + this.frmId + '&t=' + new Date().getTime()
			});
			
			var input = new Element('input', {
				'data-fld_id': this.frmId + "_" + this.fldId,
				'data-attLabel': this.xml.getAttribute("attLabel") ,
				type: "text"
			}).addClass('validate["required"]');
			
			this.content.addClass('required');
			
			spanLabel.inject(label);
			img.inject(label);
			input.inject(label);
			label.inject(this.content);
			
			var frmData = $('frmData');
			
			if(!frmData.captchas)
				frmData.captchas = [];
			
			frmData.captchas.push(this);
			frmData.formChecker.register(input);
		}
	},
	
	getPrintHTML: function(formContainer) {
		
		var fieldContainer = this.parsePrintXMLposition(formContainer);
		
		var span = new Element('span', {text: this.xml.getAttribute(Field.PROPERTY_VALUE)});
		
		span.setStyles({
			'text-decoration': 'underline',
			color: '#0000ee',
			'-webkit-touch-callout': 'none',
			'-webkit-user-select': 'none',
			'-khtml-user-select': 'none',
			'-moz-user-select': 'none',
			'-ms-user-select': 'none',
			'user-select': 'none',
			cursor: 'default'
		});
		
		span.inject(fieldContainer);
		
	},
	
	processSubmit: function(frmData) {
		var previousField = $('captcha' + TAB_ID + this.frmId);
		if(previousField) {
			previousField.set('value', this.content.getElement('input').get('value'));
		} else {
			new Element('input', {
				name: TAB_ID + this.frmId,
				id: 'captcha' + TAB_ID + this.frmId,
				value: this.content.getElement('input').get('value')
			}).setStyle('display', 'none').inject(frmData);
		}
	},
	
	reloadContent: function () {
		var prevCaptcha = this.content.getElementsByTagName('img')[0];
		prevCaptcha.setAttribute('src', CONTEXT + '/captchaImg?captchaName=' + TAB_ID + this.frmId + '&t=' + new Date().getTime());
		this.content.getElementsByTagName('input')[0].value='';
		
	},
	
	showFormListener: function() {
		var cap = this.content.getElementsByTagName('input')[0];
		if(cap)
			cap.erase('disabledCheck');
	},
	
	hideFormListener: function() {
		var cap = this.content.getElementsByTagName('input')[0];
		if(cap)
			cap.set('disabledCheck', 'true');
	}
});