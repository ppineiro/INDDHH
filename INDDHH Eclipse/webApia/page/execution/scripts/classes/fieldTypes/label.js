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
		this.options[Field.PROPERTY_VISIBILITY_HIDDEN] 	= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;
		
		this.options[Field.PROPERTY_VALUE] 				= null; //Para grilla
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
	},
	
	booleanOptions: [Field.PROPERTY_BOLD, Field.PROPERTY_UNDERLINED],
	
	/**
	 * Retorna el valor para la APIJS
	 */
	apijs_getFieldValue: function() {
		return this.content.getElement('*.labelField').get('html');
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_setFieldValue: function(value) {
		this.content.getElement('*.labelField').set('html', value + "");
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
		
		if(prp_name == Field.PROPERTY_NAME) {
			//throw new Error('Property can not be changed.')
		} else if(prp_name == Field.PROPERTY_VALUE) {
			this.apijs_setFieldValue(prp_value);
		} else if(prp_name == Field.PROPERTY_FONT_COLOR) {
			this.content.getElement('*.labelField').setStyle('color', prp_value);
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_TOOLTIP) {
			this.content.getElement('*.labelField').set('title', prp_value);
			this.options[Field.PROPERTY_TOOLTIP] = prp_value;
		} else if(prp_name == Field.PROPERTY_BOLD) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_BOLD] == false) {
				this.content.getElement('*.labelField').setStyle('font-weight', 'bold');
				this.options[Field.PROPERTY_BOLD] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_BOLD]) {
				this.content.getElement('*.labelField').setStyle('font-weight', 'normal');
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
				this.content.getElement('*.labelField').setStyle('text-align', 'right');
				this.options[Field.PROPERTY_ALIGNMENT] = "right";
			} else if("center" == prp_value) {
				this.content.getElement('*.labelField').setStyle('text-align', 'center');
				this.options[Field.PROPERTY_ALIGNMENT] = "center";
			} else {
				this.content.getElement('*.labelField').setStyle('text-align', 'left');
				this.options[Field.PROPERTY_ALIGNMENT] = "left";
			}
		} else if(prp_name == Field.PROPERTY_UNDERLINED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_UNDERLINED] == false) {
				this.content.getElement('*.labelField').setStyle('text-decoration', 'underline');
				this.options[Field.PROPERTY_UNDERLINED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_UNDERLINED]) {
				this.content.getElement('*.labelField').setStyle('text-decoration', '');
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
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		var label;
		
		var innerText = '';		
		if(this.xml.getAttribute(Field.PROPERTY_VALUE)) {
			innerText = this.xml.getAttribute(Field.PROPERTY_VALUE);
		} else if(this.options[Field.PROPERTY_VALUE]) {
			innerText = this.options[Field.PROPERTY_VALUE];
		}
		
		if(innerText.endsWith('>')) {
			if(innerText.startsWith) { 
				if(innerText.startsWith('<')) {
					label = new Element('div.labelField');
				}
			} else {
				if(innerText.lastIndexOf('<', 0) === 0) {
					label = new Element('div.labelField');
				}
			}
		}
		
		if(!label)
			 label = new Element('span.asLabel.labelField')
		
		label.set('html', innerText);
		
		if(this.form.readOnly)
			label.addClass('monitor-label');
		
		if(this.options[Field.PROPERTY_BOLD])
			label.setStyle('font-weight', 'bold');
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN] && this.options[Field.PROPERTY_VISIBILITY_HIDDEN]=='T')
			this.content.addClass('visibility-hidden');
		
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
			label.set('title', this.options[Field.PROPERTY_TOOLTIP]);
		
		this.content.addClass('exec_field_label');
	},
	
	parseXMLforGrid: function(td_container, grid_index, isGridReadonly) {
		this.content = td_container;
		this.index = grid_index;
		
		if(!this.gridHeader.col_fld_id)
			this.gridHeader.col_fld_id = this.fldId;
		
		this.updateProperties();
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.addClass(clase);
			}.bind(this));
		
		var label;
		
		var innerText = '';
		if(this.options[Field.PROPERTY_VALUE])
			innerText = this.options[Field.PROPERTY_VALUE];
		else if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
			innerText = this.row_xml.getAttribute(Field.PROPERTY_VALUE);
			
		if(innerText.endsWith('>')) {
			if(innerText.startsWith) { 
				if(innerText.startsWith('<')) {
					label = new Element('div.labelField');
				}
			} else {
				if(innerText.lastIndexOf('<', 0) === 0) {
					label = new Element('div.labelField');
				}
			}
		}
		
		if(!label)
			 label = new Element('span.asLabel.labelField').setStyles({
				'margin-left': 5,
				'margin-right': 5
			});
		
		label.set('html', innerText);
		
		if(this.form.readOnly || isGridReadonly)
			label.addClass('monitor-label');
			
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
		
		if(this.options[Field.PROPERTY_TOOLTIP])
			label.set('title', this.options[Field.PROPERTY_TOOLTIP]);
		
		var div = new Element('div.gridMinWidth');
		label.inject(div);
		div.inject(this.content);
	},
	
	getPrintHTML: function(formContainer) {
		var label = this.content.getElement('span.asLabel').clone()
		if(!label.getStyle('font-weight'))
			label.setStyle('font-weight', 'normal');
		label.inject(this.parsePrintXMLposition(formContainer));
	},
	
	getPrintHTMLForGrid: function() {
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var a = new Element('div');
			
			new Element('span.asLabel').appendText(this.content.getElement('*.labelField').get('html') + ':')
				.inject(new Element('td.left-cell').inject(a));
			
			var label = this.content.getElement('*.labelField').clone();
			if(!label.getStyle('font-weight'))
				label.setStyle('font-weight', 'normal');
			
			label.inject(new Element('td').inject(a));
			
			return a.get('html');
		}
		return '';
	},
	
	getValueHTMLForGrid: function() {
		var a = new Element('div');
		
		var label = this.content.getElement('*.labelField').clone();
		if(!label.getStyle('font-weight'))
			label.setStyle('font-weight', 'normal');
		
		label.inject(a);
		
		return a.get('html');
	}
});