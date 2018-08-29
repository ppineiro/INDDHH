var Multiple = new Class({

	Extends: Field,
	
	HTMLselect: null,
	
	initialize: function(form, frmId, xml) {
		//Establecer las opciones
		this.setDefaultOptions();		
		this.parent(form, frmId, xml.getAttribute("id"), JSON.decode(xml.getAttribute(Field.FIELD_PROPERTIES)), xml.getAttribute("attId"));
		
		this.xml = xml;
		this.parseXML();
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
		this.options[Field.PROPERTY_ROWS] 				= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
	},
	
	booleanOptions: [Field.PROPERTY_REQUIRED, Field.PROPERTY_DISABLED, Field.PROPERTY_READONLY],
	
	getValue: function() {
		var res = new Array();
		this.HTMLselect.getElements('option').each(function(option) {
			if(option.get('selected'))
				res.push(option.get('value'));
		});
		return res;
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
		var values;
		if(typeOf(value) == "array") {
			values = value;
		} else if(typeOf(value) == "string" || typeOf(value) == "number") {
			values = [value + ""];
		} else {
			throw new Error('The function setFieldValue for a Multiple field only accepts array, int or string type for value parameter.');
		}
		if(values) {
			this.HTMLselect.getElements('option').each(function(option) {
				if(values.contains(option.get('value')))
					option.set('selected', true);
				else
					option.set('selected', false);
			});
			if(this.options[Field.PROPERTY_READONLY]) {
				this.content.getElements('span').each(function(option) {
					if(values.contains(option.get('optvalue')))
						option.setStyle('font-weight', 'bold');
					else
						option.setStyle('font-weight', '');
				});
			}
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
		var ele = this.content.getElement('select');
		if(ele && ele.focus)
			ele.focus();
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
		} else if(prp_name == Field.PROPERTY_SIZE) {
			
			this.options[Field.PROPERTY_SIZE] = Number.from(prp_value);
			var select = this.content.getElement('select');
			if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0) {				
				if(select)
					select.setStyle('width', this.options[Field.PROPERTY_SIZE]);
			} else {
				if(select)
					select.setStyle('width', '');
			}
			
		} else if(prp_name == Field.PROPERTY_ROWS) {
			
			this.options[Field.PROPERTY_ROWS] = Number.from(prp_value);
			
			var select = this.content.getElement('select');
			if(this.options[Field.PROPERTY_ROWS] || this.options[Field.PROPERTY_ROWS] === 0) {				
				if(select)
					select.set('size', this.options[Field.PROPERTY_ROWS]);
			} else {
				if(select)
					select.set('size', '');
			}
			
		} else if(prp_name == Field.PROPERTY_FONT_COLOR) {
			this.content.getElement('label').setStyle('color', prp_value);
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_TOOLTIP) {
			this.content.getElement('label').tooltip(prp_value, { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
			this.options[Field.PROPERTY_TOOLTIP] = prp_value;
		} else if(prp_name == Field.PROPERTY_VALUE_COLOR) {
			this.HTMLselect.setStyle('color', prp_value);
			this.options[Field.PROPERTY_VALUE_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_REQUIRED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_REQUIRED] == false) {
				this.HTMLselect.addClass('validate["required"]');
				this.content.addClass("required");
				this.options[Field.PROPERTY_REQUIRED] = true;
				//$('frmData').formChecker.register(this.content.getElement('select'));
				$('frmData').formChecker.register(this.HTMLselect);
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_REQUIRED]) {
				//this.content.getElement('select').removeClass('validate["required"]');
				this.HTMLselect.removeClass('validate["required"]');
				this.content.removeClass("required");
				this.options[Field.PROPERTY_REQUIRED] = false;
				//$('frmData').formChecker.dispose(this.content.getElement('select'));
				$('frmData').formChecker.dispose(this.HTMLselect);
			}
		} else if(prp_name == Field.PROPERTY_DISABLED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_DISABLED] == false) {
				this.content.getElement('select').set('disabled', 'disabled');
				this.options[Field.PROPERTY_DISABLED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_DISABLED]) {
				this.content.getElement('select').set('disabled', false);
				this.options[Field.PROPERTY_DISABLED] = false;
			}
		} else if(prp_name == Field.PROPERTY_TRANSIENT) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_READONLY) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_READONLY] == false) {
				
				var multiple = new Element('div', {
					fld_id: this.frmId + "_" + this.fldId
				}).setStyles({
			    	'padding-left': '15px'
				});
				
				if(this.options[Field.PROPERTY_VALUE_COLOR])
					multiple.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
				
				var option_html = '';
				this.HTMLselect.getElements('option').each(function (option) {
					if(option.get('selected')) {
						option_html += '<span style="font-weight: bold;" optvalue="' + option.get('value') + '">' + option.get('html') + '</span><br/>'; 
					} else {
						option_html += '<span optvalue="' + option.get('value') + '">' + option.get('html') + '</span><br/>';
					}
				});
				
				multiple.set('html', option_html);
				
				this.HTMLselect.dispose();
				multiple.inject(this.content);
				
				this.options[Field.PROPERTY_READONLY] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_READONLY]) {
				this.content.getElement('div').dispose();
				this.HTMLselect.inject(this.content);
				this.options[Field.PROPERTY_READONLY] = false;
			}
		} else if(prp_name == Field.PROPERTY_CSS_CLASS) {
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
	 * Metodo de APIJS para obtener los posibles valores del campo
	 * @param asObject Define si se debe retornar un objeto que contenga los pares valor a guardar y valor a mostrar; o un Array de elementos que contengan en la posici�n [0] el valor a guardar y en la posici�n [1] el valor a mostrar
	 */
	apijs_getOptions: function(asObject) {
		
		var result;
		if(asObject)
			result = {};
		else
			result = new Array();
		
		this.HTMLselect.getElements('option').each(function(option) {
			if(asObject) {
				result[option.get('value')] = option.get('html');
			} else {
				var current_opt = new Array();
				current_opt.push(String.from(option.get('value')));
				current_opt.push(String.from(option.get('html')));
				result.push(current_opt);
			}
		});
	
		return result;
	},
	
	/**
	 * Metodo de APIJS para eliminar todos los posibles valores del campo
	 */
	apijs_clearOptions: function() {
		this.HTMLselect.getElements('option').destroy();
		if(this.options[Field.PROPERTY_READONLY]) {			
			this.content.getElements('span').destroy();
			this.content.getElements('br').destroy();
		}
	},
	
	/**
	 * Metodo de APIJS para agregar un posible valor.
	 * allowRepeatedValue
	 * 		true: Ingresa la opcion sin realizar controles de valores duplicados
	 * 		false: En caso de que el valor ya se est� usando, se actualiza el valor a mostrar
	 */
	apijs_addOption: function(store_value, show_value, allowRepeatedValue) {
		if(allowRepeatedValue) {
			new Element('option', {
				value: store_value,
				html: show_value 
			}).inject(this.HTMLselect);
			
			if(this.options[Field.PROPERTY_READONLY]) {
				new Element('span', {
					value: store_value,
					html: show_value
				}).inject(this.content.getElement('div'));
				new Element('br').inject(this.content.getElement('div'));
			}
		} else {
			var found = false;
			this.HTMLselect.getChildren('option').each(function(opt) {
				if(opt.get('value') == store_value) {
					opt.set('html', show_value);
					found = true;
				}
			});
			if(this.options[Field.PROPERTY_READONLY]) {
				this.content.getElement('div').getChildren('span').each(function(spn) {
					if(opt.get('value') == store_value) {
						opt.set('html', show_value);
						found = true;
					}
				})
			}
			if(!found) {
				new Element('option', {
					value: store_value,
					html: show_value 
				}).inject(this.HTMLselect);
				
				if(this.options[Field.PROPERTY_READONLY]) {
					new Element('span', {
						value: store_value,
						html: show_value
					}).inject(this.content.getElement('div'));
					new Element('br').inject(this.content.getElement('div'));
				}
			}
		}
	},
	
	/**
	 * Metodo de APIJS para eliminar un posible valor
	 */
	apijs_removeOption: function(value) {
		
		var opts = this.HTMLselect.getElements('option');
		if(opts) {
			for(var i = 0; i < opts.length; i++) {
				if(opts[i].get('value') == value) {
					opts[i].destroy();
					break;
				}
			}
		}
		if(this.options[Field.PROPERTY_READONLY]) {
			opts = this.content.getElements('span');
			if(opts) {
				for(var i = 0; i < opts.length; i++) {
					if(opts[i].get('value') == value) {
						opts[i].getNext().destroy();
						opts[i].destroy();
						break;
					}
				}
			}
		}
		
		
	},
	
	/**
	 * Metodo de APIJS para obtener la opcion seleccionada
 	 * @param asObject Define si se debe retornar un objeto que contenga los pares valor a guardar y valor a mostrar; o un Array de elementos que contengan en la posici�n [0] el valor a guardar y en la posici�n [1] el valor a mostrar
	 */
	apijs_getSelectedOption: function(asObject) {
			
		var result;
		if(asObject)
			result = {};
		else
			result = new Array();
		
		this.HTMLselect.getElements('option').each(function(option) {
			if(option.get('selected')) {
				if(asObject) {
					result[option.get('value')] = option.get('html');
				} else {
					var current_opt = new Array();
					current_opt.push(String.from(option.get('value')));
					current_opt.push(String.from(option.get('html')));
					result.push(current_opt);
				}
			}
		});
		return result;
	},
	
	/**
	 * Parsea el xml
	 */
	parseXML: function() {
		
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
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				
				var label = new Element('label.monitor-lbl').appendText(this.xml.getAttribute("attLabel") + ':');
				if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
				label.inject(this.content);
				
				var multiple_ro = new Element('div.monitor-multiple', {
					fld_id: this.frmId + "_" + this.fldId
				}).setStyles({
			    	'padding-left': '15px'
				});
				
				option_html = "";
				
				Array.from(this.xml.childNodes).each(function (option_xml) {
					var inner_node = '';
					if(option_xml.childNodes[0])
						inner_node = option_xml.childNodes[0].nodeValue;
					
					if(option_xml.getAttribute('selected')) {
						option_html += '<span optvalue="' + option_xml.getAttribute(Field.PROPERTY_VALUE) + '">' + inner_node + '</span><br/>'; 
					}
				});
				multiple_ro.set('html', option_html);
				
				multiple_ro.inject(this.content);
				
				if(this.options[Field.PROPERTY_REQUIRED])
					this.content.addClass('required');
				
				if(this.options[Field.PROPERTY_VALUE_COLOR])
					multiple_ro.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
				
			}
			
			return;
		}

		//LABEL
		
		var label = new Element('label');
				
		if(this.options[Field.PROPERTY_FONT_COLOR])
			label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		
		label.appendText(this.xml.getAttribute("attLabel") + ':');
		
		//SELECT
		
		var multiple = new Element('select', {
			multiple: 'multiple',
			fld_id: this.frmId + "_" + this.fldId
		});
		
		if(this.options[Field.PROPERTY_SIZE])
			multiple.setStyle('width', Number.from(this.options[Field.PROPERTY_SIZE]));
		
		if(this.options[Field.PROPERTY_DISABLED])
			multiple.set('disabled', 'disabled');
		
		if(this.options[Field.PROPERTY_ROWS])
			multiple.set('size',this.options[Field.PROPERTY_ROWS]);
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			multiple.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		if(this.options[Field.PROPERTY_REQUIRED] && !this.options[Field.PROPERTY_READONLY] ) {
			multiple.addClass('validate["required"]');			
			this.content.addClass('required');
			$('frmData').formChecker.register(multiple);
		}
		
		var option_html = "";
		var defValue = "";
		
		Array.from(this.xml.childNodes).each(function (option_xml, index) {			
			option = new Element('option');
			if(option_xml.getAttribute("selected")) {
				option.set('selected', 'selected');
				if(defValue != "")
					defValue += "," + index;
				else
					defValue += index;
			}
			var inner_node = "";
			if(option_xml.childNodes[0])
				inner_node = option_xml.childNodes[0].nodeValue;
			
			option.set('value', option_xml.getAttribute(Field.PROPERTY_VALUE));
			option.appendText(inner_node);

			option.inject(multiple);
		});
		
		this.HTMLselect = multiple;
		
		label.inject(this.content);
		
		if(this.options[Field.PROPERTY_READONLY]) {
			var multiple_ro = new Element('div', {
				fld_id: this.frmId + "_" + this.fldId
			}).setStyles({
				'font-size': '13px',
		    	'padding-left': '15px'
			});
			
			option_html = "";
			
			Array.from(this.xml.childNodes).each(function (option_xml) {
				var inner_node = '';
				if(option_xml.childNodes[0])
					inner_node = option_xml.childNodes[0].nodeValue;
				
				if(option_xml.getAttribute('selected')) {
					option_html += '<span style="font-weight: bold;" optvalue="' + option_xml.getAttribute(Field.PROPERTY_VALUE) + '">' + inner_node + '</span><br/>'; 
				} else {
					option_html += '<span optvalue="' + option_xml.getAttribute(Field.PROPERTY_VALUE) + '">' + inner_node + '</span><br/>';
				}
			});
			multiple_ro.set('html', option_html);
			
			multiple_ro.inject(this.content);
		} else {
			multiple.inject(this.content);
		}
		
		this.content.addClass('AJAXfield');		
		
		if(this.xml.getAttribute("forceSync"))
			this.content.set(SynchronizeFields.SYNC_FAILED, 'true');
		
		if(this.options[Field.PROPERTY_TOOLTIP]) {
			label.tooltip(this.options[Field.PROPERTY_TOOLTIP], { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
		}
		
		//onchange
//		if(this.xml.getAttribute(Field.FUNC_CHANGE) && !window.editionMode) {
		if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
			var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
			var target = this;
			if (fn_change) {
				multiple.addEvent('change', function() {
					//SynchronizeFields.preJSexec(this.content);					
					//fn_change();
					try {
						fn_change(new ApiaField(target));
					} catch(error) {}
					//SynchronizeFields.posJSexec(this.content);
				});			
			} else {				
				if(console) console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
				
				multiple.addEvent('change', function() {
					SynchronizeFields.toSync(this.content, this.getValue());
				}.bind(this));
			}
		} else {
			multiple.addEvent('change', function() {
				SynchronizeFields.toSync(this.content, this.getValue());
			}.bind(this));
		}
	},
	
	getPrintHTML: function(formContainer) {
		var fieldContainer = this.parsePrintXMLposition(formContainer);
		
		var label = new Element('label').appendText(this.xml.getAttribute("attLabel") + ':');
		if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		label.inject(fieldContainer);
	
		if(this.form.readOnly) {
			Array.from(this.xml.childNodes).each(function (option_xml) {
				var inner_node = '';
				if(option_xml.childNodes[0])
					inner_node = option_xml.childNodes[0].nodeValue;
				
				if(option_xml.getAttribute('selected')) {
					var input = new Element('span', {html: option_xml.getAttribute(Field.PROPERTY_VALUE) + ' - ' + inner_node});
					if(this.options[Field.PROPERTY_VALUE_COLOR])
						input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
					input.inject(fieldContainer);
					new Element('br').inject(fieldContainer);
				}
			});
		} else {
			var opts = this.apijs_getSelectedOption(true);
			
			for(var value in opts) {
				var input = new Element('span', {html: value + ' - ' + opts[value]});
				if(this.options[Field.PROPERTY_VALUE_COLOR])
					input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
				input.inject(fieldContainer);
				new Element('br').inject(fieldContainer);
			}
		}
		
		if(this.options[Field.PROPERTY_REQUIRED])
			fieldContainer.addClass('required');
	},
	
	showFormListener: function() {
		if(this.HTMLselect)
			this.HTMLselect.erase('disabledCheck');
	},
	
	hideFormListener: function() {
		if(this.HTMLselect)
			this.HTMLselect.set('disabledCheck', 'true');
	}
});