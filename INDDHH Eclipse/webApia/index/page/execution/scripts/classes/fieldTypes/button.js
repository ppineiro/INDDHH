/**
 * Campo Boton
 */
var Button = new Class({

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
		//Disable no es soportado, durante el procesamiento se lo trata como RO, se mantiene por compatibilidad para atras
		this.options[Field.PROPERTY_DISABLED] 			= null; 
		this.options[Field.PROPERTY_READONLY] 			= null;
		this.options[Field.PROPERTY_VISIBILITY_HIDDEN] 	= null;
		this.options[Field.PROPERTY_SIZE] 				= null;
		this.options[Field.PROPERTY_COL_WIDTH]		 	= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;
		//this.options[Field.PROPERTY_GRID_TITLE]			= null; //La usan los GridHeader
		
		this.options[Field.PROPERTY_VALUE]				= null;
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
	},
	
	booleanOptions: [Field.PROPERTY_DISABLED, Field.PROPERTY_READONLY, Field.PROPERTY_VISIBILITY_HIDDEN],
	
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
	 * Metodo de APIJS para establecer el foco a un campo
	 */
	apijs_setFocus: function() {
		var ele = this.content.getElement('button');
		if(ele && ele.focus)
			ele.focus();
	},
	
	getPrpsForGridReload: function() {
		var res = {};
		res[Field.PROPERTY_FONT_COLOR] = (this.options[Field.PROPERTY_FONT_COLOR] != null ? this.options[Field.PROPERTY_FONT_COLOR] : '');
		res[Field.PROPERTY_TOOLTIP] = (this.options[Field.PROPERTY_TOOLTIP] != null ? this.options[Field.PROPERTY_TOOLTIP] : '');
		res[Field.PROPERTY_READONLY] = this.options[Field.PROPERTY_READONLY];
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
		
		//var prp_number_value = Number.from(prp_value);		
		
		if(prp_name == Field.PROPERTY_NAME) {
			//throw new Error('Property can not be changed.')
		} else if(prp_name == Field.PROPERTY_VALUE) {
			this.content.getElement('span').set('html', prp_value);
		} else if(prp_name == Field.PROPERTY_SIZE) {
			this.content.getElement('button').getParent().setStyle('width', Number.from(prp_value));
		} else if(prp_name == Field.PROPERTY_FONT_COLOR) {	
			if(prp_value) {
				this.content.getElement('div').getElement('div')
					.setStyle('color', prp_value)
					.getElement('button').setStyle('color', 'inherit');
			} else {
				this.content.getElement('div').getElement('div')
					.setStyle('color', prp_value)
					.getElement('button').setStyle('color', null);
			}
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_TOOLTIP) {
			this.content.getElement('div').getElement('div').tooltip(prp_value, { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
			this.options[Field.PROPERTY_TOOLTIP] = prp_value;
		} else if(prp_name == Field.PROPERTY_READONLY) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_READONLY] == false) {
				this.content.getElement('div').getElement('div')		
					.addClass('apia-disabled-rounded-button')
					.getElement('button').set('disabled', true);
				this.options[Field.PROPERTY_READONLY] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_READONLY]) {
				this.content.getElement('div').getElement('div')		
					.removeClass('apia-disabled-rounded-button')
					.getElement('button').set('disabled', false);
				this.options[Field.PROPERTY_READONLY] = false;
			}
		} else if(prp_name == Field.PROPERTY_VISIBILITY_HIDDEN) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN] == false) {
				this.content.addClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				this.content.removeClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = false;
			}
		} else if(prp_name == Field.PROPERTY_DISPLAY_NONE) {
			//NOT SUPPORTED
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
			//throw new Error('Property not found or not available for this field.')
		}
	},
	
	/**
	 * Dispara el evento de click del boton
	 */
	apijs_fireClickEvent: function() {
		var divs = this.content.getElements('div');
		if(divs && divs.length > 1)
			divs[1].fireEvent('click');
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
		
		var button_width = 100;
		
		if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0)
			button_width = Number.from(this.options[Field.PROPERTY_SIZE]);
		
		var button = new Element('div').setStyle('width', button_width);
		
		if(this.xml.getAttribute(Field.PROPERTY_VALUE))
			button.appendText(this.xml.getAttribute(Field.PROPERTY_VALUE));
		else if(this.options[Field.PROPERTY_VALUE])
			button.appendText(this.options[Field.PROPERTY_VALUE]);
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		Generic.setButton(button);

		if(this.options[Field.PROPERTY_FONT_COLOR]) {
			button.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			button.getElement('button').setStyle('color', 'inherit');
		}
		
		if(this.options[Field.PROPERTY_DISABLED])
			this.options[Field.PROPERTY_READONLY] = "true";
		
		if(this.options[Field.PROPERTY_READONLY]) {
			button.getElement('button').set('disabled', 'disabled');
			button.addClass('apia-disabled-rounded-button');
		}
		/*
		if(Browser.ie)
			button.getElement('button').setStyle('filter', 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'' + CONTEXT + '/css/' + STYLE + '/img/button/back_button_normal.gif\', sizingMethod=\'scale\')');
		*/
		var div = new Element('div');
		button.inject(div);
		div.inject(this.content);
		
		//Si estoy en monitor, solo coloco el texto
		if(this.form.readOnly) {
			//if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				button.getElement('button').set('disabled', 'disabled');
				button.addClass('monitor-button');
			//}
			return;
		}
		
		if(this.options[Field.PROPERTY_TOOLTIP])
			button.tooltip(this.options[Field.PROPERTY_TOOLTIP], { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});

		//onclick
//		if(this.xml.getAttribute(Field.FUNC_CLICK) && !window.editionMode) {
		if(this.xml.getAttribute(Field.FUNC_CLICK)) {
			var fn_click = window[this.xml.getAttribute(Field.FUNC_CLICK)];
			var target = this;
			if (fn_click) {
				button.addEvent('click', function(e) {
					if(!this.options[Field.PROPERTY_READONLY]) {
						//fn_click(e);
						try {
							fn_click(new ApiaField(target));
						} catch(error) {}
					}
				}.bind(this));
			}
		}
		
		//Corregir visualizaci�n en caso de que el alto del span sea mayor que el del bot�n
		var real_btn = button.getElement('button');
		if(real_btn) {
			real_btn.setStyles({
				'min-height': real_btn.getStyle('height'),
				height: 'auto',
				width: '100%'
				/*,
				filter: 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'' + CONTEXT + '/css/' + STYLE + '/img/button/back_button_normal.gif\', sizingMethod=\'scale\')'*/
			});
		}
		
		
	},
	
	parseXMLforGrid: function(td_container, grid_index, isGridReadonly) {
		this.content = td_container;	
		this.index = grid_index;
		
		this.updateProperties();
		
		if(!this.options[Field.PROPERTY_NAME])
			this.options[Field.PROPERTY_NAME] = JSON.decode(this.xml.getAttribute(Field.FIELD_PROPERTIES))[Field.PROPERTY_NAME];
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.addClass(clase);
			}.bind(this));
		
		//BUTTON
		
		var button_width = 100;
		
		if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0)
			button_width = Number.from(this.options[Field.PROPERTY_SIZE]);
		
		var button = new Element('div').setStyles({'width': button_width, 'margin': 'auto'});
		
		if(this.options[Field.PROPERTY_VALUE])
			button.appendText(this.options[Field.PROPERTY_VALUE]);
		else if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
			button.appendText(this.row_xml.getAttribute(Field.PROPERTY_VALUE));
		
		if(this.options[Field.PROPERTY_DISABLED])
			this.options[Field.PROPERTY_READONLY] = "true";
		
		Generic.setButton(button);
		
		var real_btn = button.getElement('button');
		
		if(this.options[Field.PROPERTY_READONLY]) {
			real_btn.set('disabled', 'disabled');
			button.addClass('apia-disabled-rounded-button');
		} else {
			//button.addClass('apia-rounded-button');
			//button.addClass('fix-grid-button');
		}
		
		if(this.options[Field.PROPERTY_FONT_COLOR]) {
			button.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			button.getElement('button').setStyle('color', 'inherit');
		}
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		var div = new Element('div.gridMinWidth');
		
		if(Number.from(this.options[Field.PROPERTY_COL_WIDTH]))
			div.setStyle('width', Number.from(this.options[Field.PROPERTY_COL_WIDTH]));
		
		button.inject(div);
		div.inject(this.content);
				
		//Corregir visualizaci�n en caso de que el alto del span sea mayor que el del bot�n
		
		if(real_btn) {
			real_btn.setStyles({
				'min-height': Generic.getHiddenHeight(real_btn), //real_btn.getStyle('height'),
				height: 'auto',
				width: '100%'
			});
		}
		
		//Si estoy en monitor, solo coloco el texto
		if(this.form.readOnly || isGridReadonly) {
			//if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				//button.getElement('button').set('disabled', 'disabled');
				real_btn.set('disabled', 'disabled');
				button.addClass('monitor-button');
			//}
			return;
		}
		
		//onclick
//		if(this.xml.getAttribute(Field.FUNC_CLICK) && !window.editionMode) {
		if(this.xml.getAttribute(Field.FUNC_CLICK)) {
			var fn_click = window[this.xml.getAttribute(Field.FUNC_CLICK)];
			var target = this;
			if (fn_click) {
				//button.addEvent('click', fn_click);
				button.addEvent('click', function(e) {
					if(!this.options[Field.PROPERTY_READONLY]) {
						//fn_click(e);
						try {
							fn_click(new ApiaField(target, true));
						} catch(error) {}
					}
				}.bind(this));
			}
		}
		
		if(this.options[Field.PROPERTY_TOOLTIP]) {
			this.content.getElement('div').getElement('div').tooltip(this.options[Field.PROPERTY_TOOLTIP], { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
		}
	},
	
	getPrintHTML: function(formContainer) {
		
	},
	
	getPrintHTMLForGrid: function() {
		return '';
	}
});