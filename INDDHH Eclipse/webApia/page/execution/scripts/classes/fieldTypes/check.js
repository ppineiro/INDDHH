var Check = new Class({
	
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
		this.options[Field.PROPERTY_COL_WIDTH] 			= null;
		this.options[Field.PROPERTY_FONT_COLOR] 		= null;
		this.options[Field.PROPERTY_TOOLTIP] 			= null;
		this.options[Field.PROPERTY_REQUIRED] 			= null;
		this.options[Field.PROPERTY_DISABLED] 			= null;
		//this.options[Field.PROPERTY_TRANSIENT] 			= null;
		this.options[Field.PROPERTY_READONLY] 			= null;
		this.options[Field.PROPERTY_VISIBILITY_HIDDEN] 	= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;
		this.options[Field.PROPERTY_CHECKED]		 	= null;
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
		this.options[Field.PROPERTY_SHOW_TOOLTIP_AS_HELP]		= null;
	},
	
	booleanOptions: [Field.PROPERTY_REQUIRED, Field.PROPERTY_DISABLED, Field.PROPERTY_READONLY, Field.PROPERTY_VISIBILITY_HIDDEN, Field.PROPERTY_CHECKED, Field.PROPERTY_SHOW_TOOLTIP_AS_HELP],
	
	getValue: function() {
		if(this.options.valueType == "N") {
			if(this.content.getElement('input').get('checked')) {
				return 1;
			} else {
				return 0;
			}
		} else {
			return this.content.getElement('input').get('checked');
		}
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
		if(typeOf(value) == "boolean") {
			this.content.getElement('input').set('checked', value);
		} else if(typeOf(value) == "string") {
			if(value == "" || value.toUpperCase() == "FALSE")
				this.content.getElement('input').set('checked', false);
			else
				this.content.getElement('input').set('checked', true);
		} else {
			throw new Error('The function setFieldValue for a Checkbox field only accepts boolean or string type for value parameter.');
		}
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
		res[Field.PROPERTY_REQUIRED] = this.options[Field.PROPERTY_REQUIRED];
		res[Field.PROPERTY_READONLY] = this.options[Field.PROPERTY_READONLY];
		res[Field.PROPERTY_DISABLED] = this.options[Field.PROPERTY_DISABLED];
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
		} else if(prp_name == Field.PROPERTY_FONT_COLOR && !this.row_xml) {
			this.content.getElement('span.asLabel').setStyle('color', prp_value);
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_TOOLTIP) {
			if(this.row_xml)
				this.content.getElement('input').set('title', prp_value);
			else
				this.content.getElement('span.asLabel').set('title', prp_value);
			this.options[Field.PROPERTY_TOOLTIP] = prp_value;
		}  else if(prp_name == Field.PROPERTY_REQUIRED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_REQUIRED] == false) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					var inp = this.content.getElement('input').addClass('validate["required"]');
					if(this.row_xml != undefined) {
						this.content.getElement('div').addClass('gridCellRequired');
						inp.setStyles({
							display: '',
							'margin-left': Generic.getHiddenWidth(this.content.getElement('div')) / 2 - Generic.getHiddenWidth(inp) / 2
						});
					} else {
						this.content.addClass('required');
					}
					$('frmData').formChecker.register(inp);
				}
				this.options[Field.PROPERTY_REQUIRED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_REQUIRED]) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					var inp = this.content.getElement('input').removeClass('validate["required"]');
					if(this.row_xml != undefined) {
						this.content.getElement('div').removeClass('gridCellRequired');
						inp.setStyles({
							display: '',
							'margin-left': Generic.getHiddenWidth(this.content.getElement('div')) / 2 - Generic.getHiddenWidth(inp) / 2
						});
					} else {
						this.content.removeClass('required');
					}
					$('frmData').formChecker.dispose(inp);
				}
				this.options[Field.PROPERTY_REQUIRED] = false;
			}
		} else if(prp_name == Field.PROPERTY_READONLY) {
			if((prp_boolean_value == true || "true" == prp_value) && this.options[Field.PROPERTY_READONLY] == false) {
				this.content.getElement('input').set('disabled', 'disabled');					
				this.options[Field.PROPERTY_READONLY] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_READONLY]) {
				if(this.options[Field.PROPERTY_DISABLED] == false)
					this.content.getElement('input').set('disabled', false);					
				this.options[Field.PROPERTY_READONLY] = false;
			}
		} else if(prp_name == Field.PROPERTY_DISABLED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_DISABLED] == false) {
				this.content.getElement('input').set('disabled', 'disabled');					
				this.options[Field.PROPERTY_DISABLED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_DISABLED]) {
				if(this.options[Field.PROPERTY_READONLY] == false)
					this.content.getElement('input').set('disabled', false);					
				this.options[Field.PROPERTY_DISABLED] = false;
			}	
		} else if(prp_name == Field.PROPERTY_VISIBILITY_HIDDEN) {
			if((prp_boolean_value == true || "true" == prp_value) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN] == false) {
				
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = true;

				if(this.row_xml) {
					this.content.getElement('div').addClass('visibility-hidden');
					this.gridHeader.checkVisibility();
				} else {
					this.content.addClass('visibility-hidden');
				}
				
				//Si es requerido, desregistrarlo
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					var inp = this.content.getElement('input').removeClass('validate["required"]');
					if(this.row_xml != undefined) {
						this.content.getElement('div').removeClass('gridCellRequired');
						inp.setStyles({
							display: 'block',
							margin: 'auto'
						});
					} else {
						this.content.removeClass('required');
					}
					$('frmData').formChecker.dispose(inp);
				}
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {

				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = false;

				if(this.row_xml) {
					this.gridHeader.checkVisibility();
				} else {
					this.content.removeClass('visibility-hidden');
				}
				
				//Verificar si era requerido
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					var inp = this.content.getElement('input').addClass('validate["required"]');
					if(this.row_xml != undefined) {
						this.content.getElement('div').addClass('gridCellRequired');
						inp.setStyles({
							display: '',
							'margin-left': Generic.getHiddenWidth(this.content.getElement('div')) / 2 - Generic.getHiddenWidth(inp) / 2
						});
					} else {
						this.content.addClass('required');
					}
					$('frmData').formChecker.register(inp);
				}
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
		
		//Seteamos el tipo de atributo
		if(this.xml.getAttribute("valueType"))
			this.options.valueType = this.xml.getAttribute("valueType");
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		//Si estoy en monitor, solo coloco el texto
		if(this.form.readOnly) {
			if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
				this.content.addClass('visibility-hidden');
			
			this.content.addClass('monitor_field');
			
			var label = new Element('label');
			
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			label.inject(this.content);
			
			var span = new Element('span').appendText(this.xml.getAttribute("attLabel"));
			
			var input = new Element('input.monitor-checkbox', {type: 'checkbox'});
			
			if(this.xml.getAttribute(Field.PROPERTY_VALUE) && this.xml.getAttribute(Field.PROPERTY_VALUE) == "true")
				input.setAttribute('checked', 'checked');
			else if(!this.xml.getAttribute(Field.PROPERTY_VALUE) && this.options[Field.PROPERTY_CHECKED])
				input.setAttribute('checked', 'checked');
			
			input.set('disabled', 'disabled');
			
			if(this.options[Field.PROPERTY_REQUIRED])
				this.content.addClass('required');
			
			this.content.addClass('exec_field_check');
			
			input.inject(label);
			span.inject(label);
			
			return;
		}
		
		var uniqueId = this.makeUniqueId();
		this.content.addClass(this.xml.getAttribute('attName'));
		//LABEL
		
		var label = new Element('label');
		label.set('for',uniqueId);	
		if(this.options[Field.PROPERTY_FONT_COLOR])
			label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		
		var span = new Element('span');
		
		span.appendText(this.xml.getAttribute("attLabel"));
		
		//CHECK
		
		var check = new Element('input', {
			'data-fld_id':	this.frmId + "_" + this.fldId,
			type:	'checkbox'
		});
		
		check.set('data-attLabel', this.xml.getAttribute("attLabel"));
		check.set('id',uniqueId);
		if(this.xml.getAttribute(Field.PROPERTY_VALUE) && (this.options.valueType == "S" && this.xml.getAttribute(Field.PROPERTY_VALUE) == "true" || this.options.valueType == "N" && this.xml.getAttribute(Field.PROPERTY_VALUE).contains('1')))
			check.set('checked', 'checked');
		else if(!this.xml.getAttribute(Field.PROPERTY_VALUE) && this.options[Field.PROPERTY_CHECKED])
			check.set('checked', 'checked');
		
		if(this.options[Field.PROPERTY_READONLY])
			check.set('disabled', 'disabled');
		
		if(this.options[Field.PROPERTY_DISABLED])
			check.set('disabled', 'disabled');
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		if(this.options[Field.PROPERTY_REQUIRED]) {
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				check.addClass('validate["required"]');
				this.content.addClass('required');
				$('frmData').formChecker.register(check);
			}
		}
		
		check.inject(label);
		span.inject(label);
		label.inject(this.content);
		
		this.content.addClass('AJAXfield');
		this.content.addClass('exec_field_check');
		
		var multIdx = this.xml.getAttribute("multIdx");
		if(multIdx) {
			this.index = Number.from(multIdx);
		}
		
		//Obligamos siempre a sincronizar el valor de los checks
		if(this.xml.getAttribute("forceSync"))
			this.content.set(SynchronizeFields.SYNC_FAILED, 'true');
		
		if(this.options[Field.PROPERTY_TOOLTIP])
			label.set('title', this.options[Field.PROPERTY_TOOLTIP]);
		
		if(this.options[Field.PROPERTY_SHOW_TOOLTIP_AS_HELP])
			new Element('span.textTooltip', {text: this.options[Field.PROPERTY_TOOLTIP]}).inject(this.content);
		
		//onchange
		if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
			var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
			var target = this;
			if (fn_change) {
				check.addEvent('change', function() { 
					try {
						fn_change(new ApiaField(target));
					} catch(error) {}
				});			
			} else {				
				console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
				
				check.addEvent('change', function() {
					SynchronizeFields.toSync(this.content, this.getValue());
				}.bind(this));
			}
		} else {
			check.addEvent('change', function() {
				SynchronizeFields.toSync(this.content, this.getValue());
			}.bind(this));
		}
		
		if(this.xml.getAttribute(Field.FUNC_CLICK)) {
			var fn_click = window[this.xml.getAttribute(Field.FUNC_CLICK)];
			var target = this;
			if (fn_click) {
				check.addEvent('click', function() { 
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
		
		//Seteamos el tipo de atributo
		if(this.xml.getAttribute("valueType"))
			this.options.valueType = this.xml.getAttribute("valueType");
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.addClass(clase);
			}.bind(this));
		
		//Si estoy en monitor, solo coloco el texto
		if(this.form.readOnly || isGridReadonly) {
			if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
				this.content.addClass('visibility-hidden');
			
			var input = new Element('input.monitor-checkbox', {type: 'checkbox'});
			
			if(this.row_xml.getAttribute(Field.PROPERTY_VALUE) && this.row_xml.getAttribute(Field.PROPERTY_VALUE) == "true")
				input.setAttribute('checked', 'checked');
			else if(!this.row_xml.getAttribute(Field.PROPERTY_VALUE) && this.options[Field.PROPERTY_CHECKED])
				input.setAttribute('checked', 'checked');
			
			input.set('disabled', 'disabled');
			
			var div = new Element('div.gridMinWidth.monitorGridCell', {
				id: this.frmId + '_' + this.fldId + '_' + grid_index
			});
			
			if(this.options[Field.PROPERTY_REQUIRED]) {
				div.addClass('gridCellRequired');
				input.setStyle('margin-left', Generic.getHiddenWidth(div) / 2 - Generic.getHiddenWidth(check) / 2);
			} else {
				input.setStyles({
					display: 'block',
					margin: 'auto'
				});
			}
			
			if(Number.from(this.options[Field.PROPERTY_COL_WIDTH]))
				div.setStyle('width', Number.from(this.options[Field.PROPERTY_COL_WIDTH]));
			
			input.inject(div);
			div.inject(this.content);
			
			return;
		}
		
		var check = new Element('input', {
			'data-fld_id':	this.frmId + "_" + this.fldId,
			type:	'checkbox',
			title: this.xml.getAttribute("attLabel")
		});	
		
		if(this.row_xml.getAttribute(Field.PROPERTY_VALUE) && (this.options.valueType == "S" && this.row_xml.getAttribute(Field.PROPERTY_VALUE) == "true" || this.options.valueType == "N" && this.row_xml.getAttribute(Field.PROPERTY_VALUE).contains('1')))
			check.set('checked', 'checked');
		else if(!this.row_xml.getAttribute(Field.PROPERTY_VALUE) && this.options[Field.PROPERTY_CHECKED])
			check.set('checked', 'checked');
		
		if(this.options[Field.PROPERTY_REQUIRED]) {
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				check.addClass('validate["required"]');
				
				if($('frmData').formChecker)
					$('frmData').formChecker.register(check);
			}
			
			if(this.form.options[Form.PROPERTY_FORM_HIDDEN] == "true") {
				check.set('disabledCheck', 'true');
			}
		} else {
			check.setStyles({
				display: 'block',
				margin: 'auto'
			});
		}

		if(this.options[Field.PROPERTY_TOOLTIP])
			check.set('title', this.options[Field.PROPERTY_TOOLTIP]);
		
		if(this.options[Field.PROPERTY_READONLY])
			check.set('disabled', 'disabled');
		
		if(this.options[Field.PROPERTY_DISABLED])
			check.set('disabled', 'disabled');
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		var div = new Element('div.gridMinWidth', {
			id: this.frmId + '_' + this.fldId + '_' + grid_index
		});
		div.addClass(this.xml.getAttribute('attName'));
		if(Number.from(this.options[Field.PROPERTY_COL_WIDTH]))
			div.setStyle('width', Number.from(this.options[Field.PROPERTY_COL_WIDTH]));
		
		check.inject(div);
		div.inject(this.content);
		
		if(this.options[Field.PROPERTY_REQUIRED]) {
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				div.addClass('gridCellRequired');
				check.setStyle('margin-left', Generic.getHiddenWidth(div) / 2 - (Generic.getHiddenWidth(check,true) + 8) / 2);
			}
		}
		
		div.store(Field.STORE_KEY_FIELD, this);
		div.addClass('AJAXfield');
		
		//Obligamos siempre a sincronizar el valor de los checks
		if(this.xml.getAttribute("forceSync"))
			div.set(SynchronizeFields.SYNC_FAILED, 'true');
		
		//onchange
		if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
			var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
			var target = this;
			if (fn_change) {
				check.addEvent('change', function() { 
					try {
						fn_change(new ApiaField(target, true));
					} catch(error) {}
				});
			} else {				
				console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
				
				check.addEvent('change', function() {
					SynchronizeFields.toSync(div, this.getValue());
				}.bind(this));
			}
		} else {
			check.addEvent('change', function() {
				SynchronizeFields.toSync(div, this.getValue());
			}.bind(this));
		}
		
		if(this.xml.getAttribute(Field.FUNC_CLICK)) {
			var fn_click = window[this.xml.getAttribute(Field.FUNC_CLICK)];
			var target = this;
			if (fn_click) {
				check.addEvent('click', function() { 
					try {
						fn_click(new ApiaField(target, true));
					} catch(error) {}
				});			
			}
		}
	},
	
	getPrintHTML: function(formContainer) {
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var fieldContainer = this.parsePrintXMLposition(formContainer);
			
			var label = new Element('label');
			
			var span = new Element('span').appendText(this.xml.getAttribute("attLabel"));
			
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			label.inject(fieldContainer);
			
			var input = new Element('input', {type: 'checkbox'});
			
			if(this.form.readOnly) {
				if(this.xml.getAttribute(Field.PROPERTY_VALUE) && this.xml.getAttribute(Field.PROPERTY_VALUE) == "true")
					input.setAttribute('checked', 'checked');
				else if(!this.xml.getAttribute(Field.PROPERTY_VALUE) && this.options[Field.PROPERTY_CHECKED])
					input.setAttribute('checked', 'checked');
			} else {
				if(this.getValue())
					input.setAttribute('checked', 'checked');
			}
			
			input.set('disabled', 'disabled');
			
			if(this.options[Field.PROPERTY_REQUIRED])
				fieldContainer.addClass('required');
			
			fieldContainer.addClass('exec_field_check');
			
			input.inject(label);
			span.inject(label);
		}
	},
	
	getPrintHTMLForGrid: function() {
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var a = new Element('div');
			
			var label = new Element('span.asLabel').set('html', (this.options[Field.PROPERTY_REQUIRED] ? '*' : '') + this.xml.getAttribute("attLabel") + ':');
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			
			label.inject(new Element('td.left-cell').inject(a));
			
			var input = new Element('input', {type: 'checkbox', title: this.xml.getAttribute("attLabel")});
			
			if(this.form.readOnly) {
				if(this.row_xml.getAttribute(Field.PROPERTY_VALUE) && this.row_xml.getAttribute(Field.PROPERTY_VALUE) == "true")
					input.setAttribute('checked', 'checked');
				else if(!this.row_xml.getAttribute(Field.PROPERTY_VALUE) && this.options[Field.PROPERTY_CHECKED])
					input.setAttribute('checked', 'checked');
			} else {
				if(this.getValue())
					input.setAttribute('checked', 'checked');
			}
			
			input.set('disabled', 'disabled');
			
			input.inject(new Element('td').inject(a));
			
			return a.get('html');
		}
		return '';
	},
	
	getValueHTMLForGrid: function() {
		var a = new Element('div');
		
		var input = new Element('input', {type: 'checkbox'});
		
		if(this.form.readOnly) {
			if(this.row_xml.getAttribute(Field.PROPERTY_VALUE) && this.row_xml.getAttribute(Field.PROPERTY_VALUE) == "true")
				input.setAttribute('checked', 'checked');
			else if(!this.row_xml.getAttribute(Field.PROPERTY_VALUE) && this.options[Field.PROPERTY_CHECKED])
				input.setAttribute('checked', 'checked');
		} else {
			if(this.getValue())
				input.setAttribute('checked', 'checked');
		}
		
		input.set('disabled', 'disabled');
		
		input.inject(a);
		
		return '<div style="width: 22px; margin: auto;">' + a.get('html') + '</div>';
	},
	
	showFormListener: function() {
		var input = this.content.getElementsByTagName('input')[0] || (this.content.getChildren('div')[0] ? this.content.getChildren('div')[0].getChildren('input')[0] : null);
		if(input)
			input.erase('disabledCheck');
	},
	
	hideFormListener: function() {
		var input = this.content.getElementsByTagName('input')[0] || (this.content.getChildren('div')[0] ? this.content.getChildren('div')[0].getChildren('input')[0] : null);
		if(input)
			input.set('disabledCheck', 'true');
	}
});