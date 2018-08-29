/**
 * Campo Password
 */
var Password = new Class({
	
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
		this.options[Field.PROPERTY_SIZE] 				= null;
		this.options[Field.PROPERTY_FONT_COLOR] 		= null;
		this.options[Field.PROPERTY_TOOLTIP] 			= null;
		this.options[Field.PROPERTY_VALUE_COLOR] 		= null;
		this.options[Field.PROPERTY_REQUIRED] 			= null;
		this.options[Field.PROPERTY_DISABLED] 			= null;
		//this.options[Field.PROPERTY_TRANSIENT] 			= null;
		this.options[Field.PROPERTY_READONLY] 			= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
		this.options[Field.PROPERTY_SHOW_TOOLTIP_AS_HELP]	= null;
	},

	booleanOptions: [Field.PROPERTY_REQUIRED, Field.PROPERTY_DISABLED, Field.PROPERTY_READONLY, Field.PROPERTY_SHOW_TOOLTIP_AS_HELP],
	
	getValue: function() {
		return this.content.getElement('input').get('value');
	},
	
	/**
	 * Retorna el valor para la APIJS
	 */
	apijs_getFieldValue: function() {
		return this.getValue();
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_setFieldValue: function(value) {
		if(this.form.readOnly) return;
		this.content.getElement('input').set('value', value + "");
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_clearValue: function() {
		this.apijs_setFieldValue("");
	},
	
	/**
	 * Metodo de APIJS para establecer el foco a un campo
	 */
	apijs_setFocus: function() {
		var ele = this.content.getElement('input');
		if(ele && ele.focus)
			ele.focus();
	},
	
	getPrpsForGridReload: function() {
		var res = {};
		res[Field.PROPERTY_TOOLTIP] = (this.options[Field.PROPERTY_TOOLTIP] != null ? this.options[Field.PROPERTY_TOOLTIP] : '');
		res[Field.PROPERTY_VALUE_COLOR] = (this.options[Field.PROPERTY_VALUE_COLOR] != null ? this.options[Field.PROPERTY_VALUE_COLOR] : '');
		res[Field.PROPERTY_REQUIRED] = this.options[Field.PROPERTY_REQUIRED];
		res[Field.PROPERTY_READONLY] = this.options[Field.PROPERTY_READONLY];
		res[Field.PROPERTY_DISABLED] = this.options[Field.PROPERTY_DISABLED];
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
		} else if(prp_name == Field.PROPERTY_SIZE) {
			
			this.options[Field.PROPERTY_SIZE] = Number.from(prp_value);
			var input = this.content.getElement('input')
			if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0) {				
				if(input)
					input.setStyle('width', this.options[Field.PROPERTY_SIZE]);
			} else {
				if(input)
					input.setStyle('width', '');
			}
			
		} else if(prp_name == Field.PROPERTY_FONT_COLOR && !this.row_xml) {
			this.content.getElement('span.asLabel').setStyle('color', prp_value);
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_TOOLTIP) {
			if(this.row_xml)
				this.content.getElement('input').set('title', prp_value);
			else
				this.content.getElement('span.asLabel').set('title', prp_value);
			this.options[Field.PROPERTY_TOOLTIP] = prp_value;
		} else if(prp_name == Field.PROPERTY_VALUE_COLOR) {
			this.content.getElement('input').setStyle('color', prp_value);
			this.options[Field.PROPERTY_VALUE_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_REQUIRED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_REQUIRED] == false) {
				this.content.getElement('input').addClass('validate["required"]');
				if(this.row_xml)
					this.content.getElement('div').addClass('gridCellRequired');
				else
					this.content.addClass('required');
				this.options[Field.PROPERTY_REQUIRED] = true;
				$('frmData').formChecker.register(this.content.getElement('input'));
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_REQUIRED]) {
				this.content.getElement('input').removeClass('validate["required"]');
				if(this.row_xml)
					this.content.getElement('div').removeClass('gridCellRequired');
				else
					this.content.removeClass('required');
				this.options[Field.PROPERTY_REQUIRED] = false;
				$('frmData').formChecker.dispose(this.content.getElement('input'));
			}
		} else if(prp_name == Field.PROPERTY_DISABLED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_DISABLED] == false) {
				this.content.getElement('input').set('disabled', 'disabled');
				this.options[Field.PROPERTY_DISABLED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_DISABLED]) {
				this.content.getElement('input').set('disabled', false);
				this.options[Field.PROPERTY_DISABLED] = false;
			}
		} else if(prp_name == Field.PROPERTY_TRANSIENT) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_READONLY) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_READONLY] == false) {
				this.content.getElement('input')
					.set('readonly', 'readonly')
					.addClass('readonly');
				this.options[Field.PROPERTY_READONLY] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_READONLY]) {
				this.content.getElement('input')
					.set('readonly', false)
					.removeClass('readonly');
				this.options[Field.PROPERTY_READONLY] = false;
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
	 * Parsea el xml
	 */
	parseXML: function() {
				
		//Hace espacio en el formulario y ubica el campo en su lugar.
		this.parseXMLposition();
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		//Seteamos el tipo de atributo
		if(this.xml.getAttribute("valueType"))
			this.options.valueType = this.xml.getAttribute("valueType");
		
		if(this.options.valueType == "N") {
			//No se aceptan atributos de tipo numerico
			this.content.set('html', Field.formatMsg(Field.WRONG_ATT_TYPE_ERROR, "number"));
			return;
		} else if(this.options.valueType == "D") {
			//No se aceptan atributos de tipo date
			this.content.set('html', Field.formatMsg(Field.WRONG_ATT_TYPE_ERROR, "date"));
			return;
		}
		
		//TODO: Field_PROPERTY_NAME
		
		//Si estoy en monitor, solo coloco el texto
		if(this.form.readOnly) {
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				
				this.content.addClass('monitor_field');
				
				var label = new Element('span.monitor-lbl').appendText(this.xml.getAttribute("attLabel") + ':');
				if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
				label.inject(this.content);
				
				var true_value = ''
				if(this.xml.getAttribute(Field.PROPERTY_VALUE))
					true_value = this.xml.getAttribute(Field.PROPERTY_VALUE);
				
				var value = '';
				(true_value.length).times(function(){value+='*';});
				
				var input = new Element('span.monitor-password').set('text', value);
				
				if(this.options[Field.PROPERTY_REQUIRED])
					this.content.addClass('required');
				
				if(this.options[Field.PROPERTY_VALUE_COLOR])
					input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
				
				input.inject(this.content);
			}
			
			return;
		}
		this.content.addClass(this.xml.getAttribute('attName'));
		//LABEL
		
		var label = new Element('label');
				
		var spanLabel = new Element('span.asLabel');
		
		if(this.options[Field.PROPERTY_FONT_COLOR])
			label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		
		spanLabel.appendText(this.xml.getAttribute("attLabel") + ':');
		
		//INPUT
		
		var input = new Element('input', {
			'data-fld_id': this.frmId + "_" + this.fldId,
			type: "password"
		});
		
		if(this.xml.getAttribute("length"))
			input.set("maxlength", this.xml.getAttribute("length"));
		
		if(this.xml.getAttribute(Field.PROPERTY_VALUE))
			input.set('value', this.xml.getAttribute(Field.PROPERTY_VALUE));
		
		if(this.options[Field.PROPERTY_READONLY]) {
			input.set('readonly', 'readonly');
			input.addClass('readonly');
		}
		
		if(this.options[Field.PROPERTY_DISABLED])
			input.set('disabled', 'disabled');
			
		if(this.options[Field.PROPERTY_REQUIRED]) {
			input.addClass('validate["required"]');			
			this.content.addClass('required');
			$('frmData').formChecker.register(input);
		}
		
		if(this.xml.getAttribute('regExp')) {
			
			input.addEvent('blur', function() {
				
				var value = input.get('value');
				if(input.get('data-empty_mask')) {
					if(input.get('data-empty_mask') == str) {
						value = "";
					} else if(input.get('data-unmasked_value')) {
						value = input.get('data-unmasked_value');
					}
				}
				 
				var result = Generic.testRegExp(value, this.xml.getAttribute('regExp'));
				
				if(!result) {
					if(this.options[Field.PROPERTY_REGEXP_MESSAGE])
						showMessage(this.options[Field.PROPERTY_REGEXP_MESSAGE]);
					else
						showMessage(MSG_INVALID_REG_EXP);
					
					input.set('value', '');
				   	if(input.get('data-unmasked_value'))
				   		input.set('data-unmasked_value', '');

					input.select();
				}
			}.bind(this));
		}
		
		if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0)
			input.setStyle('width', Number.from(this.options[Field.PROPERTY_SIZE]));
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		spanLabel.inject(label);
		input.inject(label);
		label.inject(this.content);
		
		this.content.addClass('AJAXfield');
		
		var multIdx = this.xml.getAttribute("multIdx");
		if(multIdx) {
			this.index = Number.from(multIdx);
		}
		
		if(this.xml.getAttribute("forceSync"))
			this.content.set(SynchronizeFields.SYNC_FAILED, 'true');
		
		if(this.options[Field.PROPERTY_TOOLTIP])
			label.set('title', this.options[Field.PROPERTY_TOOLTIP]);
		
		if(this.options[Field.PROPERTY_SHOW_TOOLTIP_AS_HELP])
			new Element('span.textTooltip', {text: this.options[Field.PROPERTY_TOOLTIP]}).inject(this.content);
		
		input.addEvent('change', function() {
			SynchronizeFields.toSync(this.content, this.getValue());
		}.bind(this));
		
		if(Browser.firefox) {
			//Firefox no dispara evento onchange al hacer drop. Deshabilitamos el drop hasta que corrijan bug 501152
			input.addEventListener('drop', function(e) {
				e.preventDefault();
				/*
				var t = $(e.explicitOriginalTarget);
				setTimeout(function() {
					t.focus();
					t.fireEvent('change');
				}, 100);
				*/
			})
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
		
		//Seteamos el tipo de atributo
		if(this.xml.getAttribute("valueType"))
			this.options.valueType = this.xml.getAttribute("valueType");

		//Si estoy en monitor, solo coloco el texto
		if(this.form.readOnly || isGridReadonly) {
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				
				var true_value = ''
				if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
					true_value = this.row_xml.getAttribute(Field.PROPERTY_VALUE);
				
				var value = '';
				(true_value.length).times(function(){value+='*';});
				
				var input = new Element('span.monitor-password').set('text', value);
				
				var div = new Element('div.gridMinWidth.monitorGridCell', {
					id: this.frmId + '_' + this.fldId + '_' + grid_index
				});
				div.addClass(this.xml.getAttribute('attName'));
				if(this.options[Field.PROPERTY_REQUIRED])
					div.addClass('gridCellRequired');
				
				if(this.options[Field.PROPERTY_VALUE_COLOR])
					input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
				
				input.inject(div);
				div.inject(this.content);
			} else {
				this.content.addClass('visibility-hidden');
			}
			
			return;
		}
		
		//INPUT
		
		var input = new Element('input', {
			'data-fld_id': this.frmId + "_" + this.fldId,
			type: "password",
			title: this.xml.getAttribute("attLabel")
		});		
		
		if(this.xml.getAttribute("length"))
			input.set("maxlength", this.xml.getAttribute("length"));
		
		if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
			input.set('value', this.row_xml.getAttribute(Field.PROPERTY_VALUE));
		
		if(this.options[Field.PROPERTY_READONLY]) {
			input.set('readonly', 'readonly');
			input.addClass('readonly');
		}
		
		if(this.options[Field.PROPERTY_REQUIRED]) {
			input.addClass('validate["required"]');
			
			if($('frmData').formChecker)
				$('frmData').formChecker.register(input);
			
			if(this.form.options[Form.PROPERTY_FORM_HIDDEN] == "true") {
				input.set('disabledCheck', 'true');
			}
		}

		if(this.options[Field.PROPERTY_DISABLED])
			input.set('disabled', 'disabled');
		
		if(this.xml.getAttribute('regExp')) {
			
			input.addEvent('blur', function() {
				
				var value = input.get('value');
				if(input.get('data-empty_mask')) {
					if(input.get('data-empty_mask') == str) {
						value = "";
					} else if(input.get('data-unmasked_value')) {
						value = input.get('data-unmasked_value');
					}
				}
				 
				var result = Generic.testRegExp(value, this.xml.getAttribute('regExp'));
				
				if(!result) {
					if(this.options[Field.PROPERTY_REGEXP_MESSAGE])
						showMessage(this.options[Field.PROPERTY_REGEXP_MESSAGE]);
					else
						showMessage(MSG_INVALID_REG_EXP);
					
					input.set('value', '');
				   	if(input.get('data-unmasked_value'))
				   		input.set('data-unmasked_value', '');

					input.select();
				}
			}.bind(this));
		}
		
		if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0)
			input.setStyle('width', Number.from(this.options[Field.PROPERTY_SIZE]));
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		
		if(this.options[Field.PROPERTY_TOOLTIP])
			input.set('title', this.options[Field.PROPERTY_TOOLTIP]);
		
		var div = new Element('div.gridMinWidth', {
			id: this.frmId + '_' + this.fldId + '_' + grid_index
		});
		
		div.addClass(this.xml.getAttribute('attName'));
		
		if(this.options[Field.PROPERTY_REQUIRED])
			div.addClass('gridCellRequired');
		
		input.addEvent('change', function() {
			SynchronizeFields.toSync(div, this.getValue());
		}.bind(this));
		
		input.inject(div);
		div.inject(this.content);
		div.store(Field.STORE_KEY_FIELD, this);
		
		div.addClass('AJAXfield');
		
		if(this.xml.getAttribute("forceSync"))
			div.set(SynchronizeFields.SYNC_FAILED, 'true');
		
		if(Browser.firefox) {
			//Firefox no dispara evento onchange al hacer drop. Deshabilitamos el drop hasta que corrijan bug 501152
			input.addEventListener('drop', function(e) {
				e.preventDefault();
				/*
				var t = $(e.explicitOriginalTarget);
				setTimeout(function() {
					t.focus();
					t.fireEvent('change');
				}, 100);
				*/
			})
		}
	},
	
	getPrintHTML: function(formContainer) {
		var fieldContainer = this.parsePrintXMLposition(formContainer);
		
		var label = new Element('span.asLabel').appendText(this.xml.getAttribute("attLabel") + ':');
		if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		label.inject(fieldContainer);
		
		var true_value = '';
			
		if(this.form.readOnly) {
			if(this.xml.getAttribute(Field.PROPERTY_VALUE))
				true_value = this.xml.getAttribute(Field.PROPERTY_VALUE);
		} else {
			true_value = this.getValue();
		}
		
		var value = '';
		(true_value.length).times(function(){value+='*';});
		
		var input = new Element('span').set('text', value);
		
		if(this.options[Field.PROPERTY_REQUIRED])
			fieldContainer.addClass('required');
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		input.inject(fieldContainer);
	},
	
	getPrintHTMLForGrid: function() {
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var a = new Element('div');
			
			var label = new Element('span.asLabel').set('html', (this.options[Field.PROPERTY_REQUIRED] ? '*' : '') + this.xml.getAttribute("attLabel") + ':');
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			
			label.inject(new Element('td.left-cell').inject(a));
			
			var true_value = '';
			if(this.form.readOnly) {
				if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
					true_value = this.row_xml.getAttribute(Field.PROPERTY_VALUE);
			} else {
				true_value = this.getValue();
			}
			
			var value = '';
			(true_value.length).times(function(){value+='*';});
			
			var input = new Element('span').set('text', value);
						
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			input.inject(new Element('td').inject(a));
			
			return a.get('html');
		}
		return '';
	},
	
	getValueHTMLForGrid: function() {
		var a = new Element('div');
		
		var true_value = '';
		if(this.form.readOnly) {
			if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
				true_value = this.row_xml.getAttribute(Field.PROPERTY_VALUE);
		} else {
			true_value = this.getValue();
		}
		
		var value = '';
		(true_value.length).times(function(){value+='*';});
		
		var input = new Element('span').set('text', value);
					
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		input.inject(a);
		
		return a.get('html');
	},
	
	showFormListener: function() {
		var input = this.content.getElement('input');
		if(input)
			input.erase('disabledCheck');
	},
	
	hideFormListener: function() {
		var input = this.content.getElement('input');
		if(input)
			input.set('disabledCheck', 'true');
	}
});