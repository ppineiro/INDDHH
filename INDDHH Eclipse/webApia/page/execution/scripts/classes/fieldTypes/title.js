/**
 * Campo Title
 */
var Title = new Class({
	
	Extends: Field,
	
	initialize: function(form, frmId, xml) {
		//Establecer las opciones
		this.setDefaultOptions();		
		this.parent(form, frmId, xml.getAttribute("id"), JSON.decode(xml.getAttribute(Field.FIELD_PROPERTIES)));
		
		this.xml = xml;
		this.parseXML();
	},
		
	setDefaultOptions: function() {
		this.options[Field.PROPERTY_NAME] 				= null;
		this.options[Field.PROPERTY_FONT_COLOR] 		= null;
		this.options[Field.PROPERTY_TOOLTIP] 			= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
	},
	
	/**
	 * Retorna el valor para la APIJS
	 */
	apijs_getFieldValue: function() {
		return this.content.getElement('span').get('html');
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_setFieldValue: function(value) {
		if(this.form.readOnly) return;
		this.content.getElement('span').set('text', value + "");
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_clearValue: function() {
		this.apijs_setFieldValue("");
	},
	
	/**
	 * Metodo de APIJS para establecer propiedades
	 */
	apijs_setProperty: function(prp_name, prp_value) {
		
		if(this.form.readOnly) return;
		
		var prp_boolean_value;
		if(prp_value == true || prp_value == "T")
			prp_boolean_value = true;
		else if(prp_value == false || prp_value == "F")
			prp_boolean_value = false;
		
		//var prp_number_value = Number.from(prp_value);
		
		if(prp_name == Field.PROPERTY_NAME) {
			//throw new Error('Property can not be changed.')
		} else if(prp_name == Field.PROPERTY_VALUE) {
			this.apijs_setFieldValue(prp_value);
		} else if(prp_name == Field.PROPERTY_FONT_COLOR) {
			this.content.getElement('span').setStyle('color', prp_value);
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_TOOLTIP) {
			this.content.getElement('span').set('title', prp_value);
			this.options[Field.PROPERTY_TOOLTIP] = prp_value;
		} else if(prp_name == Field.PROPERTY_CSS_CLASS) {
			var p = this.content.getParent().erase('class');
			this.options[Field.PROPERTY_CSS_CLASS] = prp_value;
			if(this.options[Field.PROPERTY_CSS_CLASS])
				this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
					if(clase) p.addClass(clase);
				});
		}
	},
	
	/**
	 * Parsea el xml
	 */
	parseXML: function() {
		
		//Hace espacio en el formulario y ubica el campo en su lugar.
		this.parseXMLposition();
		
		//TODO: Field_PROPERTY_NAME
		//TODO: Field_PROPERTY_DISPLAY_NONE
		/*
		var parentColspan = Number.from(this.content.getParent('td').get('colspan'));
		var current_width = Number.from(this.content.getStyle('width'));
		if(parentColspan > 1) {
			this.content.removeClass('field4').removeClass('field5').removeClass('field6').removeClass('field7').removeClass('field8');		
			this.content.setStyle('width', current_width * parentColspan);
		}
		*/
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		var span = new Element('span');
		span.addClass('labelTitle');
		
		if(this.form.readOnly) {
			span.addClass('monitor-title');
			this.content.addClass('monitor_field');
		}
		
		if(this.options.value)
			span.appendText(this.options.value);		
		
		if(this.options[Field.PROPERTY_FONT_COLOR])
			span.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		
		span.inject(this.content);
		
		if(this.options[Field.PROPERTY_TOOLTIP]) {
			span.set('title', this.options[Field.PROPERTY_TOOLTIP]);
		}
	},
	
	getPrintHTML: function(formContainer) {
		
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var fieldContainer = this.parsePrintXMLposition(formContainer);
			
			this.content.getElement('span').clone().inject(fieldContainer);
		}
	}
});