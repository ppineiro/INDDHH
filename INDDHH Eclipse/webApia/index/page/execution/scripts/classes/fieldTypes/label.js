/**
 * Campo Label
 */
var Label = new Class({
	
	Extends: Field,
	
	Implements: GridField,
	
	initialize: function(form, frmId, xml, rowXml) {
		//Establecer las opciones
		this.setDefaultOptions();		
		this.xml = xml;
		
		if(rowXml) {
			//Es de una grilla. Obtenemos las propiedades de rowXml
			this.parent(form, frmId, xml.getAttribute("id"), JSON.decode(rowXml.getAttribute(Field.FIELD_PROPERTIES)));
			this.row_xml = rowXml;
		} else {
			//No es de una grilla
			this.parent(form, frmId, xml.getAttribute("id"), JSON.decode(xml.getAttribute(Field.FIELD_PROPERTIES)));
			this.parseXML();
		}
	},
		
	setDefaultOptions: function() {
		this.options[Field.PROPERTY_NAME] 				= null;
		this.options[Field.PROPERTY_FONT_COLOR] 		= null;
		this.options[Field.PROPERTY_TOOLTIP] 			= null;
		
		this.options[Field.PROPERTY_BOLD] 				= null;
		this.options[Field.PROPERTY_ALIGNMENT] 			= 'left';
		this.options[Field.PROPERTY_UNDERLINED] 		= null;

		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;
		
		this.options[Field.PROPERTY_VALUE] 				= null; //Para grilla
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
	},
	
	booleanOptions: [Field.PROPERTY_BOLD, Field.PROPERTY_UNDERLINED],
	
	/**
	 * Retorna el valor para la APIJS
	 */
	apijs_getFieldValue: function() {
		return this.content.getElement('label').getElement('div').get('html');
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_setFieldValue: function(value) {
		this.content.getElement('label').getElement('div').set('html', value + "");
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_clearValue: function() {
		this.apijs_setFieldValue("");
	},
	
	getPrpsForGridReload: function() {
		var res = {};
		res[Field.PROPERTY_FONT_COLOR] = (this.options[Field.PROPERTY_FONT_COLOR] != null ? this.options[Field.PROPERTY_FONT_COLOR] : '');
		res[Field.PROPERTY_TOOLTIP] = (this.options[Field.PROPERTY_TOOLTIP] != null ? this.options[Field.PROPERTY_TOOLTIP] : '');
		res[Field.PROPERTY_BOLD] = this.options[Field.PROPERTY_BOLD];
		res[Field.PROPERTY_ALIGNMENT] = this.options[Field.PROPERTY_ALIGNMENT];
		res[Field.PROPERTY_UNDERLINED] = this.options[Field.PROPERTY_UNDERLINED];
		return res;
		
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
			this.content.getElement('label').setStyle('color', prp_value);
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_TOOLTIP) {
			this.content.getElement('label').tooltip(prp_value, { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
			this.options[Field.PROPERTY_TOOLTIP] = prp_value;
		} else if(prp_name == Field.PROPERTY_BOLD) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_BOLD] == false) {
				this.content.getElement('label').setStyle('font-weight', 'bold');
				this.options[Field.PROPERTY_BOLD] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_BOLD]) {
				this.content.getElement('label').setStyle('font-weight', 'normal');
				this.options[Field.PROPERTY_BOLD] = false;
			}
		} else if(prp_name == Field.PROPERTY_ALIGNMENT) {
			if(prp_value == '0')
				prp_value = 'left';
			else if(prp_value == '1')
				prp_value = 'center';
			else if(prp_value == '2')
				prp_value = 'right';
			
			if("right" == prp_value) {
				this.content.getElement('label').setStyle('text-align', 'right');
				this.options[Field.PROPERTY_ALIGNMENT] = "right";
			} else if("center" == prp_value) {
				this.content.getElement('label').setStyle('text-align', 'center');
				this.options[Field.PROPERTY_ALIGNMENT] = "center";
			} else {
				this.content.getElement('label').setStyle('text-align', 'left');
				this.options[Field.PROPERTY_ALIGNMENT] = "left";
			}
		} else if(prp_name == Field.PROPERTY_UNDERLINED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_UNDERLINED] == false) {
				this.content.getElement('label').setStyle('text-decoration', 'underline');
				this.options[Field.PROPERTY_UNDERLINED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_UNDERLINED]) {
				this.content.getElement('label').setStyle('text-decoration', '');
				this.options[Field.PROPERTY_UNDERLINED] = false;
			}
		} else if(prp_name == Field.PROPERTY_CSS_CLASS) {
			var p;
			if(this.row_xml)
				p = this.content.erase('class');
			else
				p = this.content.getParent().erase('class');
			
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
		
		var label = new Element('label');
		
		if(this.form.readOnly)
			label.addClass('monitor-label');
		/*
		if(this.xml.getAttribute(Field.PROPERTY_VALUE))
			label.appendText(this.xml.getAttribute(Field.PROPERTY_VALUE));
		else if(this.options[Field.PROPERTY_VALUE])
			label.appendText(this.options[Field.PROPERTY_VALUE]);
		*/
		var innerText = '';		
		if(this.xml.getAttribute(Field.PROPERTY_VALUE)) {
			innerText = this.xml.getAttribute(Field.PROPERTY_VALUE);
		} else if(this.options[Field.PROPERTY_VALUE]) {
			innerText = this.options[Field.PROPERTY_VALUE];
		}
		
		new Element('div').set('html', innerText).inject(label);
		
		if(this.options[Field.PROPERTY_BOLD])
			label.setStyle('font-weight', 'bold');
		
		if(this.options[Field.PROPERTY_ALIGNMENT]) {
			if(this.options[Field.PROPERTY_ALIGNMENT] == '0')
				label.setStyle('text-align', 'left');
			else if(this.options[Field.PROPERTY_ALIGNMENT] == '1')
				label.setStyle('text-align', 'center');
			else if(this.options[Field.PROPERTY_ALIGNMENT] == '2')
				label.setStyle('text-align', 'right');
		}
		
		
		if(this.options[Field.PROPERTY_UNDERLINED])
			label.setStyle('text-decoration', 'underline');
		
		if(this.options[Field.PROPERTY_FONT_COLOR])
			label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		
		label.inject(this.content);
		
		
		var scripts = label.getElements('div.javaScript');
		if(scripts) scripts.each(function(script) {
			eval(script.get('html'));
			script.destroy();
		});
		
		if(this.options[Field.PROPERTY_TOOLTIP])
			label.tooltip(this.options[Field.PROPERTY_TOOLTIP], { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
	},
	
	parseXMLforGrid: function(td_container, grid_index, isGridReadonly) {
		this.content = td_container;
		this.index = grid_index;
		
		this.updateProperties();
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.addClass(clase);
			}.bind(this));
		
		var label = new Element('label').setStyles({
			'margin-left': 5,
			'margin-right': 5
		});
		
		if(this.form.readOnly || isGridReadonly)
			label.addClass('monitor-label');
		
		/*
		if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
			label.appendText(this.row_xml.getAttribute(Field.PROPERTY_VALUE));
		else if(this.options[Field.PROPERTY_VALUE])
			label.appendText(this.options[Field.PROPERTY_VALUE]);
		*/
//		if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
//			new Element('div', {html: this.row_xml.getAttribute(Field.PROPERTY_VALUE)}).inject(label);
//		else if(this.options[Field.PROPERTY_VALUE])
//			new Element('div', {html: this.options[Field.PROPERTY_VALUE]}).inject(label);
		
		if(this.options[Field.PROPERTY_VALUE])
			new Element('div', {html: this.options[Field.PROPERTY_VALUE]}).inject(label);
		else if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
			new Element('div', {html: this.row_xml.getAttribute(Field.PROPERTY_VALUE)}).inject(label);
			
		if(this.options[Field.PROPERTY_BOLD])
			label.setStyle('font-weight', 'bold');
		
		if(this.options[Field.PROPERTY_ALIGNMENT]) {
			if(this.options[Field.PROPERTY_ALIGNMENT] == '0')
				label.setStyle('text-align', 'left');
			else if(this.options[Field.PROPERTY_ALIGNMENT] == '1')
				label.setStyle('text-align', 'center');
			else if(this.options[Field.PROPERTY_ALIGNMENT] == '2')
				label.setStyle('text-align', 'right');
		}
		
		//label.setStyle('text-align', this.options[Field.PROPERTY_ALIGNMENT]);
		
		if(this.options[Field.PROPERTY_UNDERLINED])
			label.setStyle('text-decoration', 'underline');
		
		if(this.options[Field.PROPERTY_FONT_COLOR])
			label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		
		if(this.options[Field.PROPERTY_TOOLTIP])
			label.tooltip(this.options[Field.PROPERTY_TOOLTIP], { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
		
		var div = new Element('div.gridMinWidth');
		label.inject(div);
		div.inject(this.content);
	},
	
	getPrintHTML: function(formContainer) {
		var label = this.content.getElement('label').clone()
		if(!label.getStyle('font-weight'))
			label.setStyle('font-weight', 'normal');
		label.inject(this.parsePrintXMLposition(formContainer));
	},
	
	getPrintHTMLForGrid: function() {
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var a = new Element('div');
			
			new Element('label').appendText(this.content.getElement('label').getElement('div').get('html') + ':')
				.inject(new Element('td.left-cell').inject(a));
			
			var label = this.content.getElement('label').clone()
			if(!label.getStyle('font-weight'))
				label.setStyle('font-weight', 'normal');
			
			label.inject(new Element('td').inject(a));
			
			return a.get('html');
		}
		return '';
	},
	
	getValueHTMLForGrid: function() {
		var a = new Element('div');
		
		var label = this.content.getElement('label').clone()
		if(!label.getStyle('font-weight'))
			label.setStyle('font-weight', 'normal');
		
		label.inject(a);
		
		return a.get('html');
	}
});