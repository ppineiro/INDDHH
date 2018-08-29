/**
 * Campo Image
 */
var Image = new Class({
	
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
		this.options[Field.PROPERTY_IMAGE]				= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
		this.options[Field.PROPERTY_VISIBILITY_HIDDEN] 	= null;
	},
	
	booleanOptions: [Field.PROPERTY_VISIBILITY_HIDDEN],
	
	getPrpsForGridReload: function() {
		var res = {};
		res[Field.PROPERTY_VISIBILITY_HIDDEN] = this.options[Field.PROPERTY_VISIBILITY_HIDDEN];
		return res;
	},
	
	/**
	 * Metodo de APIJS para establecer propiedades
	 */
	apijs_setProperty: function(prp_name, prp_value) {
		
		if(this.form.readOnly && prp_name != Field.PROPERTY_VISIBILITY_HIDDEN) return;
		
		var prp_boolean_value;
		if(prp_value == true || prp_value == "T")
			prp_boolean_value = true;
		else if(prp_value == false || prp_value == "F")
			prp_boolean_value = false;
		
		if(prp_name == Field.PROPERTY_IMAGE) {

			this.options[Field.PROPERTY_IMAGE] = prp_value;
			
			var img = this.content.getElement('img');
			if(img) {
				img.set('src', CONTEXT + '/images/uploaded/' + this.options[Field.PROPERTY_IMAGE]);
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
		} else if(prp_name == Field.PROPERTY_VISIBILITY_HIDDEN) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN] == false) {
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = true;

				if(this.row_xml) {
					this.content.getElement('div').addClass('visibility-hidden');
					this.gridHeader.checkVisibility();
				} else {
					this.content.addClass('visibility-hidden');
				}
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = false;

				if(this.row_xml) {
					this.gridHeader.checkVisibility();
				} else {
					this.content.removeClass('visibility-hidden');
				}
			}
		}
		
		//NOT SUPPORTED
	},
	
	/**
	 * Parsea el xml
	 */
	parseXML: function() {
		
		//Hace espacio en el formulario y ubica el campo en su lugar.
		this.parseXMLposition();
		
		//TODO: Field_PROPERTY_NAME
		//TODO: Field_PROPERTY_DISPLAY_NONE
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		var img = new Element('img', {
			src: CONTEXT + '/images/uploaded/' + this.options[Field.PROPERTY_IMAGE],
			tabIndex: ''
		});
		
		img.set('alt', this.options[Field.PROPERTY_NAME]);
		
		img.inject(this.content);
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		if(this.form.readOnly) {
			this.content.addClass('monitor_field');
		}
		
		//onclick
//		if(!this.form.readOnly && this.xml.getAttribute(Field.FUNC_CLICK) && !window.editionMode) {
		if(!this.form.readOnly && this.xml.getAttribute(Field.FUNC_CLICK)) {
			
			img.setStyle('cursor', 'pointer');
			
			var fn_click = window[this.xml.getAttribute(Field.FUNC_CLICK)];
			var target = this;
			if (fn_click) {
				img.addEvent('click', function() {
					try {
						fn_click(new ApiaField(target));
					} catch(error) {}
				});
			}
		}
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
		
		var img = new Element('img', {
			src: CONTEXT + '/images/uploaded/' + this.options[Field.PROPERTY_IMAGE],
			tabIndex: ''
		});
		
		img.set('alt', this.options[Field.PROPERTY_NAME]);
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		var div = new Element('div.gridMinWidth', {
			id: this.frmId + '_' + this.fldId + '_' + grid_index
		});
		
		img.inject(div);
		div.inject(this.content);
		
		//onclick
		if(this.form.readOnly || isGridReadonly) {
			//Imagen readonly
			
			div.addClass('monitorGridCell');
		
		} else {
//			if(this.xml.getAttribute(Field.FUNC_CLICK) && !window.editionMode) {
			if(this.xml.getAttribute(Field.FUNC_CLICK)) {
				var fn_click = window[this.xml.getAttribute(Field.FUNC_CLICK)];
				var target = this;
				if (fn_click) {
					img.addEvent('click', function() {
						try {
							fn_click(new ApiaField(target, true));
						} catch(error) {}
					});
				}
			}
		}
	},
	
	getPrintHTML: function(formContainer) {
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var fieldContainer = this.parsePrintXMLposition(formContainer);
			
			new Element('img', {
				src: CONTEXT + '/images/uploaded/' + this.options[Field.PROPERTY_IMAGE]
			}).inject(fieldContainer);
		}
	},
	
	getPrintHTMLForGrid: function() {
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var a = new Element('div');
			
			new Element('label').appendText('')
				.inject(new Element('td.left-cell').inject(a));
			
			new Element('img', {
				src: CONTEXT + '/images/uploaded/' + this.options[Field.PROPERTY_IMAGE]
			}).inject(new Element('td').inject(a));
			
			return a.get('html');
		}
		return '';
	},
	
	getValueHTMLForGrid: function() {
		var a = new Element('div');
		
		new Element('img', {
			src: CONTEXT + '/images/uploaded/' + this.options[Field.PROPERTY_IMAGE]
		}).inject(a);
		
		return a.get('html');
	}
});