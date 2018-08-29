/**
 * Campo Href
 */
var Href = new Class({
	
	Extends: Field,
	
	Implements: GridField,
	
	initialize: function(form, frmId, xml, rowXml) {
		//Establecer las opciones
		this.setDefaultOptions();		
		this.xml = xml;
		
		if(rowXml) {
			//Es de una grilla. Obtenemos las propiedades de rowXml
			this.parent(form, frmId, xml.getAttribute("id"), JSON.decode(rowXml.getAttribute(Field.FIELD_PROPERTIES)), xml.getAttribute("attId"));
			this.row_xml = rowXml;
		} else {
			//No es de una grilla
			this.parent(form, frmId, xml.getAttribute("id"), JSON.decode(xml.getAttribute(Field.FIELD_PROPERTIES)), xml.getAttribute("attId"));
			this.parseXML();
		}
	},
		
	setDefaultOptions: function() {
		this.options[Field.PROPERTY_NAME] 				= null;
		this.options[Field.PROPERTY_URL]				= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;
		
		this.options[Field.PROPERTY_VALUE] 				= null; //Para grilla
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
	},
	
	/**
	 * Retorna el valor para la APIJS
	 */
	apijs_getFieldValue: function() {
		return this.content.getElement('a').get('text')
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_setFieldValue: function(value) {
		if(this.form.readOnly) return;
		return this.content.getElement('a').set('text', value + "");
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_clearValue: function() {
		this.apijs_setFieldValue("");
	},
	
	getPrpsForGridReload: function() {
		var res = {};
		res[Field.PROPERTY_URL] = this.options[Field.PROPERTY_URL];
		return res;
	},
	
	/**
	 * Metodo de APIJS para establecer propiedades
	 */
	apijs_setProperty: function(prp_name, prp_value) {
		
		if(this.form.readOnly) return;
		
		if(prp_name == Field.PROPERTY_NAME) {
			//throw new Error('Property can not be changed.')
		} else if(prp_name == Field.PROPERTY_VALUE) {
			this.content.getElement('a').set('html', prp_value);
		} else if(prp_name == Field.PROPERTY_URL) {
			this.options[Field.PROPERTY_URL] = prp_value;
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
		
		//TODO: Field_PROPERTY_NAME
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		var link = new Element('a', {
			href: this.options[Field.PROPERTY_URL]
		});
		
		if(this.form.readOnly) {
			link.addClass('monitor-href');
			this.content.addClass('monitor_field');
		}

		if(this.xml.getAttribute(Field.PROPERTY_VALUE))
			link.appendText(this.xml.getAttribute(Field.PROPERTY_VALUE));
		
		link.addEvent('click', function(e) {
			e.stop();
			if(this.options[Field.PROPERTY_URL])
				window.open(this.options[Field.PROPERTY_URL]);
		}.bind(this));
		
		link.inject(this.content);
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
		
		var link = new Element('a', {
			href: this.options[Field.PROPERTY_URL]
		}).setStyles({
			'margin-left': 5,
			'margin-right': 5
		});
		
		if(this.form.readOnly || isGridReadonly)
			link.addClass('monitor-href');

//		if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
//			link.appendText(this.row_xml.getAttribute(Field.PROPERTY_VALUE));
//		else if(this.options[Field.PROPERTY_VALUE])
//			link.appendText(this.options[Field.PROPERTY_VALUE]);
		
		if(this.options[Field.PROPERTY_VALUE])
			link.set('html', this.options[Field.PROPERTY_VALUE]);
		else if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
			link.set('html', this.row_xml.getAttribute(Field.PROPERTY_VALUE));
		
		link.addEvent('click', function(e) {
			e.stop();
			if(this.options[Field.PROPERTY_URL])
				window.open(this.options[Field.PROPERTY_URL]);
		}.bind(this));
		
		
		var div = new Element('div.gridMinWidth');
		link.inject(div);
		div.inject(this.content);
		
		if(this.form.readOnly || isGridReadonly) {
			div.addClass('monitorGridCell');
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
	
	getPrintHTMLForGrid: function() {
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var a = new Element('div');
			
			var txt = '';
			
			if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
				txt = this.row_xml.getAttribute(Field.PROPERTY_VALUE);
			else if(this.options[Field.PROPERTY_VALUE])
				txt = this.options[Field.PROPERTY_VALUE];
			
			var label = new Element('label').appendText(txt + ':')
				.inject(new Element('td.left-cell').inject(a));
			
			var span = new Element('span', {text: txt})
				.setStyles({
					'text-decoration': 'underline',
					color: '#0000ee',
					'-webkit-touch-callout': 'none',
					'-webkit-user-select': 'none',
					'-khtml-user-select': 'none',
					'-moz-user-select': 'none',
					'-ms-user-select': 'none',
					'user-select': 'none',
					cursor: 'default'
				}).inject(new Element('td').inject(a));
			
			return a.get('html');
		}
		return '';
	},
	
	getValueHTMLForGrid: function() {
		var a = new Element('div');
		
		var txt = '';
		
		if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
			txt = this.row_xml.getAttribute(Field.PROPERTY_VALUE);
		else if(this.options[Field.PROPERTY_VALUE])
			txt = this.options[Field.PROPERTY_VALUE];
		
		var span = new Element('span', {text: txt})
		.setStyles({
			'text-decoration': 'underline',
			color: '#0000ee',
			'-webkit-touch-callout': 'none',
			'-webkit-user-select': 'none',
			'-khtml-user-select': 'none',
			'-moz-user-select': 'none',
			'-ms-user-select': 'none',
			'user-select': 'none',
			cursor: 'default'
		}).inject(a);
		
		return a.get('html');
	}
});