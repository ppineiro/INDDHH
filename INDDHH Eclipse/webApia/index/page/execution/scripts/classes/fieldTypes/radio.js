var Radio = new Class({
	
	Extends: Field,
	
	radio_opts: null,
	
	initialize: function(form, frmId, xml) {
		//Establecer las opciones
		this.setDefaultOptions();		
		this.parent(form, frmId, xml.getAttribute("id"), JSON.decode(xml.getAttribute(Field.FIELD_PROPERTIES)), xml.getAttribute("attId"));
		
		this.xml = xml;
		this.parseXML();
	},

	setDefaultOptions: function() {
		
		this.options[Field.PROPERTY_NAME] 				= null;
		this.options[Field.PROPERTY_FONT_COLOR] 		= null;
		this.options[Field.PROPERTY_TOOLTIP] 			= null;
		this.options[Field.PROPERTY_VALUE_COLOR] 		= null;
		this.options[Field.PROPERTY_REQUIRED] 			= null;
		this.options[Field.PROPERTY_DISABLED] 			= null;
		//this.options[Field.PROPERTY_TRANSIENT] 			= null;
		this.options[Field.PROPERTY_READONLY] 			= null;
		this.options[Field.PROPERTY_VISIBILITY_HIDDEN] 	= null;
		this.options[Field.PROPERTY_DONT_BREAK_RADIO]	= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
	},
	
	booleanOptions: [Field.PROPERTY_REQUIRED, Field.PROPERTY_DISABLED, Field.PROPERTY_READONLY, Field.PROPERTY_VISIBILITY_HIDDEN],
	
	getValue: function() {
		var res = '';
		
		this.content.getElements('input').each(function(input) {
			if(input.get('checked') === true)
				res = input.get('value');
		});
		
		return res;
	},
	
	/**
	 * Retorna el valor para la APIJS
	 */
	apijs_getFieldValue: function() {
		if(this.form.readOnly) {
			return this.xml.getAttribute(Field.PROPERTY_VALUE);
		}
		return this.getValue();
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_setFieldValue: function(value) {
		if(this.form.readOnly) return;
		var val = value + "";
		//this.content.getElement('label').set('html', value + "");
		/*this.content.getElements('input').each(function(option) {
			if(option.get('value') == val) {
				option.set('checked', true);
			}
		});*/
		var options = this.content.getElements('input');
		for(var i = 0; i < options.length; i++) {
			if(options[i].get('value') == val) {
				if(this.options[Field.PROPERTY_READONLY]) {
					this.apijs_setProperty(Field.PROPERTY_READONLY, false);
					options[i].set('checked', true);
					this.apijs_setProperty(Field.PROPERTY_READONLY, true);
				} else {
					options[i].set('checked', true);
				}
				break;
			}
		}
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_clearValue: function() {	
		//this.content.getElement('label').set('html', value + "");
		if(this.options[Field.PROPERTY_READONLY]) {
			this.apijs_setProperty(Field.PROPERTY_READONLY, false);
			this.content.getElements('input').each(function(option) {
				option.set('checked', false);
			});
			this.apijs_setProperty(Field.PROPERTY_READONLY, true);
		} else {
			this.content.getElements('input').each(function(option) {
				option.set('checked', false);
			});
		}
		
	},
	
	/**
	 * Metodo de APIJS para establecer el foco a un campo
	 */
	apijs_setFocus: function() {
		var ele = this.content.getElement('input');
		if(ele && ele.focus)
			ele.focus();
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
		} else if(prp_name == Field.PROPERTY_FONT_COLOR) {
			this.content.getElement('label').setStyle('color', prp_value);
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_TOOLTIP) {
			this.content.getElement('label').tooltip(prp_value, { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
			this.options[Field.PROPERTY_TOOLTIP] = prp_value;
		} else if(prp_name == Field.PROPERTY_VALUE_COLOR) {
			this.content.getElements('span').setStyle('color', prp_value);
			this.options[Field.PROPERTY_VALUE_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_REQUIRED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_REQUIRED] == false) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					this.content.addClass('required');
					this.content.getElements('input').addClass('validate["required"]');
					var options = this.content.getElements('input');
					if(options) {
						var frmData = $('frmData');
						options.each(function(opt) {
							frmData.formChecker.register(opt);
						});
					}
				}
				this.options[Field.PROPERTY_REQUIRED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_REQUIRED]) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					this.content.removeClass('required');
					this.content.getElements('input').removeClass('validate["required"]');
					var options = this.content.getElements('input');
					if(options) {
						var frmData = $('frmData');
						options.each(function(opt) {
							frmData.formChecker.dispose(opt);
						});
					}
				}
				this.options[Field.PROPERTY_REQUIRED] = false;
			}
		} else if(prp_name == Field.PROPERTY_DISABLED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_DISABLED] == false) {
				this.content.getElements('input').set('disabled', 'disabled');
				this.options[Field.PROPERTY_DISABLED] = true;				
				
				if(!this.options[Field.PROPERTY_VALUE_COLOR])
					this.content.getElements('span').setStyle('color', 'grey');
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_DISABLED]) {
				this.content.getElements('input').set('disabled', false);
				this.options[Field.PROPERTY_DISABLED] = false;
			}
		} else if(prp_name == Field.PROPERTY_TRANSIENT) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_READONLY) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_READONLY] == false) {
				/*
				this.radio_opts = this.apijs_getOptions();//Backup de las opciones
				
				var selected_opt = this.apijs_getSelectedOption();
				 
				var div = new Element('div').setStyles({
					'font-size': '13px',
			    	'padding-left': '15px'
				}).set('optvalue', selected_opt[0]);
				
				if(selected_opt[0])
					div.set('html', '<b>' + selected_opt[1] + '</b>');
				
				if(this.content.childNodes) {
					for(var i = this.content.childNodes.length - 1; i > 0 ; i--)
						$(this.content.childNodes[i]).destroy();
				}
				
				div.inject(this.content);
				*/
				
				this.content.getElements('input').each(function(input) {
					input.setStyle('display', 'none');					
					
					if(input.get('checked'))
						input.getNext('span').setStyles({
							'font-weight': 'bold',
							'padding-left': '15px'
						});
					else
						input.getNext('span').setStyle('display', 'none');
					
					var br = input.getNext('br');
					if(br) br.setStyle('display', 'none');
				});
				
				this.options[Field.PROPERTY_READONLY] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_READONLY]) {
				/*
				var selected_val = this.apijs_getSelectedValue();
				
				this.content.getElement('div').destroy();
				
				//Restauramos los valores a partir de radio_opts
				if(this.radio_opts && this.radio_opts.length) {
					for(var i = 0; i < this.radio_opts.length; i++) {
						
						var option = new Element('input', {
							type: 'radio',
							name: this.frmId + "_" + this.fldId,
							fld_id: this.frmId + "_" + this.fldId,
							value: this.radio_opts[i][0] //value_to_store
						}).setStyle('width', '15px');
						
						if(this.radio_opts[i][0] == selected_val)
							option.set('checked', 'checked');
						
						if(this.options[Field.PROPERTY_REQUIRED])
							option.addClass('validate["required"]');
						
						option.inject(this.content);
						
						var inner_node = this.radio_opts[i][1]; //value_to_show
						var text_span = new Element('span');
						
						if(this.options[Field.PROPERTY_DONT_BREAK_RADIO]) {				
							inner_node += ' ';			
							
							text_span.appendText(inner_node);
							text_span.inject(this.content);
						} else {
							text_span.appendText(inner_node);
							text_span.inject(this.content);
							(new Element('br')).inject(this.content);
						}
						
						if(this.options[Field.PROPERTY_VALUE_COLOR])
							text_span.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
						else if(this.options[Field.PROPERTY_DISABLED])
							text_span.setStyle('color', 'grey');
						
						
						//onchange
						if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
							var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
							
							if (fn_change) {
								option.addEvent('change', function() { fn_change(); });			
							} else {				
								if(console) console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
								
								option.addEvent('change', function() {
									SynchronizeFields.toSync(this.content, this.getValue());
								}.bind(this));
							}
						} else {
							option.addEvent('change', function() {
								SynchronizeFields.toSync(this.content, this.getValue());
							}.bind(this));
						}
					}
					
					if(this.options[Field.PROPERTY_REQUIRED]) {
						$('frmData').formChecker.register(this.content.getElements('input'));
					}
				}
				
				*/
				
				this.content.getElements('input').each(function(input) {
					input.setStyle('display', '');					
					
					if(input.get('checked'))
						input.getNext('span').setStyles({
							'font-weight': '',
							'padding-left': ''
						});
					else
						input.getNext('span').setStyle('display', '');
					
					var br = input.getNext('br');
					if(br) br.setStyle('display', '');
				});
				
				this.options[Field.PROPERTY_READONLY] = false;
			}
		} else if(prp_name == Field.PROPERTY_VISIBILITY_HIDDEN) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN] == false) {
				this.content.addClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = true;
				//Si es requerido, desregistrarlo
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					this.content.removeClass('required');
					this.content.getElements('input').removeClass('validate["required"]');
					var options = this.content.getElements('input');
					if(options) {
						var frmData = $('frmData');
						options.each(function(opt) {
							frmData.formChecker.dispose(opt);
						});
					}
				}
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				this.content.removeClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = false;
				//Verificar si era requerido
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					this.content.addClass('required');
					this.content.getElements('input').addClass('validate["required"]');
					var options = this.content.getElements('input');
					if(options) {
						var frmData = $('frmData');
						options.each(function(opt) {
							frmData.formChecker.register(opt);
						});
					}
				}
			}
		} else if(prp_name == Field.PROPERTY_DONT_BREAK_RADIO) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_DISPLAY_NONE) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_CSS_CLASS) {
			var p = this.content.getParent().erase('class');
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
	 * Metodo de APIJS para obtener los posibles valores del campo
	 * @param asObject Define si se debe retornar un objeto que contenga los pares valor a guardar y valor a mostrar; o un Array de elementos que contengan en la posici�n [0] el valor a guardar y en la posici�n [1] el valor a mostrar
	 */
	apijs_getOptions: function(asObject) {
		
		var result;
		if(asObject)
			result = {};
		else
			result = new Array();
		
		/*if(this.options[Field.PROPERTY_READONLY]) {
			Array.from(this.xml.childNodes).each(function (option_xml) {
				var inner_node = '';
				if(option_xml.childNodes[0])
					inner_node = option_xml.childNodes[0].nodeValue;
				if(asObject) {
					result[option_xml.getAttribute("value")] = inner_node;
				} else {
					var current_opt = new Array();
					current_opt.push(String.from(option_xml.getAttribute("value")));
					current_opt.push(String.from(inner_node));
					result.push(current_opt);
				}
			}.bind(this));
		} else {*/
			this.content.getElements('input').each(function(option) {
				if(asObject) {
					result[option.get('value')] = option.getNext().get('html');
				} else {
					var current_opt = new Array();
					current_opt.push(String.from(option.get('value')));
					current_opt.push(String.from(option.getNext().get('html')));
					result.push(current_opt);
				}
			});
		//}
		return result;
	},
	
	/**
	 * Metodo de APIJS para eliminar todos los posibles valores del campo
	 */
	apijs_clearOptions: function() {
		if(!this.options[Field.PROPERTY_READONLY]) {
			var elements = this.content.childNodes;
			if(elements)
				for(var i = elements.length - 1; i > 0; i--)
					elements[i].destroy();
		}
	},
	
	/**
	 * Metodo de APIJS para agregar un posible valor
	 * @param {String} store_value Valor a guardar
	 * @param {String} show_value Valor a mostrar
	 * @param {String} allowRepeatedValue permite insertar opciones con el mismo valor que otras, o modificar las ya existentes
	 */
	apijs_addOption: function(store_value, show_value, allowRepeatedValue) {
		if(allowRepeatedValue) {
			if(!this.options[Field.PROPERTY_READONLY]) {
				var option = new Element('input', {
					type: 'radio',
					name: this.frmId + "_" + this.fldId,
					fld_id: this.frmId + "_" + this.fldId,
					value: store_value
				}).setStyle('width', '15px').inject(this.content);
				
				if(this.options[Field.PROPERTY_REQUIRED] && !this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					option.addClass('validate["required"]');
					$('frmData').formChecker.register(option);
				}
				
				if(this.options[Field.PROPERTY_DISABLED])
					option.set('disabled', 'disabled');
				
				var inner_node = show_value;
				var text_span = new Element('span');
							
				if(this.options[Field.PROPERTY_DONT_BREAK_RADIO]) {				
					inner_node += ' ';				
					text_span.appendText(inner_node);
					text_span.inject(this.content);
				} else {
					text_span.appendText(inner_node);
					text_span.inject(this.content);
					(new Element('br')).inject(this.content);
				}
				
				if(this.options[Field.PROPERTY_VALUE_COLOR])
					text_span.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
				else if(this.options[Field.PROPERTY_DISABLED])
					text_span.setStyle('color', 'grey');
				
				//onchange
//				if(this.xml.getAttribute(Field.FUNC_CHANGE) && !window.editionMode) {
				if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
					var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
					
					if (fn_change) {
						option.addEvent('change', function() { fn_change(); });			
					} else {				
						if(console) console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
						
						option.addEvent('change', function() {
							SynchronizeFields.toSync(this.content, this.getValue());
						}.bind(this));
					}
				} else {
					option.addEvent('change', function() {
						SynchronizeFields.toSync(this.content, this.getValue());
					}.bind(this));
				}
				
				//onclick
//				if(this.xml.getAttribute(Field.FUNC_CLICK) && !window.editionMode) {
				if(this.xml.getAttribute(Field.FUNC_CLICK)) {
					var fn_click = window[this.xml.getAttribute(Field.FUNC_CLICK)];
					var target = this;
					if (fn_click) {
						option.addEvent('click', function() {
							//fn_click();
							try {
								fn_click(new ApiaField(target));
							} catch(error) {}
						});
					}
				}
			}
		} else {
			if(!this.options[Field.PROPERTY_READONLY]) {
				var found = false;
				this.content.getChildren('input').each(function(opt) {
					if(opt.get('value') == store_value) {
						opt.getNext('span').set('text', show_value);
						found = true;
					}
				});
				if(!found) {
					var option = new Element('input', {
						type: 'radio',
						name: this.frmId + "_" + this.fldId,
						fld_id: this.frmId + "_" + this.fldId,
						value: store_value
					}).setStyle('width', '15px').inject(this.content);
					
					if(this.options[Field.PROPERTY_REQUIRED] && !this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
						option.addClass('validate["required"]');
						$('frmData').formChecker.register(option);
					}
					
					if(this.options[Field.PROPERTY_DISABLED])
						option.set('disabled', 'disabled');
					
					var inner_node = show_value;
					var text_span = new Element('span');
								
					if(this.options[Field.PROPERTY_DONT_BREAK_RADIO]) {
						inner_node += ' ';
						text_span.appendText(inner_node);
						text_span.inject(this.content);
					} else {
						text_span.appendText(inner_node);
						text_span.inject(this.content);
						(new Element('br')).inject(this.content);
					}
					
					if(this.options[Field.PROPERTY_VALUE_COLOR])
						text_span.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
					else if(this.options[Field.PROPERTY_DISABLED])
						text_span.setStyle('color', 'grey');
					
					//onchange
//					if(this.xml.getAttribute(Field.FUNC_CHANGE) && !window.editionMode) {
					if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
						var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
						
						if (fn_change) {
							option.addEvent('change', function() { fn_change(); });			
						} else {				
							if(console) console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
							
							option.addEvent('change', function() {
								SynchronizeFields.toSync(this.content, this.getValue());
							}.bind(this));
						}
					} else {
						option.addEvent('change', function() {
							SynchronizeFields.toSync(this.content, this.getValue());
						}.bind(this));
					}
					
					//onclick
//					if(this.xml.getAttribute(Field.FUNC_CLICK) && !window.editionMode) {
					if(this.xml.getAttribute(Field.FUNC_CLICK)) {
						var fn_click = window[this.xml.getAttribute(Field.FUNC_CLICK)];
						var target = this;
						if (fn_click) {
							option.addEvent('click', function() {
								//fn_click();
								try {
									fn_click(new ApiaField(target));
								} catch(error) {}
							});
						}
					}
				}
			}
		}
		
	},
	
	/**
	 * Metodo de APIJS para eliminar un posible valor
	 */
	apijs_removeOption: function(value) {
		if(!this.options[Field.PROPERTY_READONLY]) {
			var opts = this.content.getElements('input');
			var frmData;
			if(opts) {
				if(this.options[Field.PROPERTY_REQUIRED] && !this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					frmData = $('frmData');
					opts.each(function(opt) {
						frmData.formChecker.dispose(opt);
					});
				}
				for(var i = 0; i < opts.length; i++) {
					if(opts[i].get('value') == value) {
						if(!this.options[Field.PROPERTY_DONT_BREAK_RADIO])
							opts[i].getNext().getNext().destroy();
						opts[i].getNext().destroy();
						opts[i].destroy();
						break;
					}
				}
			}
			if(this.options[Field.PROPERTY_REQUIRED] && !this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				opts = this.content.getElements('input');
				opts.each(function(opt) {
					frmData.formChecker.register(opt);
				});
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
		
		/*if(this.options[Field.PROPERTY_READONLY]) {
			if(asObject) {
				result[String.from(this.content.getElements('div').get('optvalue'))] = String.from(this.content.getElements('b').get('html'));
			} else {
				result.push(String.from(this.content.getElements('div').get('optvalue')));
				result.push(String.from(this.content.getElements('b').get('html')));
			}
		} else {*/
		
			var inputs = this.content.getElements('input');
			if(inputs && inputs.length) {
				inputs.each(function(option) {				
					if(option.get('checked')) {
						if(asObject) {
							result[option.get('value')] = option.getNext().get('html');
						} else {
							result.push(option.get('value'));
							result.push(option.getNext().get('html'));
						}
					}
				});
			} else {
				var monitorRadio = this.content.getElement('span.monitor-radio');
				if(monitorRadio) {
					if(asObject) {
						result[monitorRadio.get('val')] = monitorRadio.get('text');
					} else {
						result.push(monitorRadio.get('val'));
						result.push(monitorRadio.get('text'));
					}
				}
			}
			
		//}
		
		return result;
	},
	
	/**
	 * Metodo de APIJS para obtener el valor de la opci�n seleccionada
	 */
	apijs_getSelectedValue: function() {
		var opt_sel = this.apijs_getSelectedOption(false);
		if(opt_sel)
			return opt_sel[0];
		return null;
	},
	
	/**
	 * Metodo de APIJS para obtener el texto de la opci�n seleccionada
	 */
	apijs_getSelectedText: function() {
		var opt_sel = this.apijs_getSelectedOption(false);
		if(opt_sel)
			return opt_sel[1];
		return null;
	},
	
	/**
	 * Parsea el xml
	 */
	parseXML: function() {
		
		this.parseXMLposition();
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		//Seteamos el tipo de atributo
		if(this.xml.getAttribute("valueType"))
			this.options.valueType = this.xml.getAttribute("valueType");
		
		//TODO: Field_PROPERTY_NAME
		
		if(this.form.readOnly) {
			if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
				this.content.addClass('visibility-hidden');
			
			var label = new Element('label.monitor-lbl').appendText(this.xml.getAttribute("attLabel") + ':');
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			label.inject(this.content);
			
			var input = new Element('span.monitor-radio');
			
			Array.from(this.xml.childNodes).each(function (option_xml, index) {
				if(option_xml.getAttribute("selected") && option_xml.childNodes && option_xml.childNodes[0]) {
					input.set('text', option_xml.childNodes[0].nodeValue);
					input.set('val', option_xml.getAttribute(Field.PROPERTY_VALUE));
				}
			}.bind(this));
			
			if(this.options[Field.PROPERTY_REQUIRED])
				this.content.addClass('required');
			
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			input.inject(this.content);
			
			return;
		}
		
		//LABEL
		
		var label = new Element('label');
		
		if(this.options[Field.PROPERTY_FONT_COLOR])
			label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		
		label.appendText(this.xml.getAttribute("attLabel") + ':');
		
		label.inject(this.content);
		
		//RADIO
		
		if(this.options[Field.PROPERTY_REQUIRED] && !this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('required');
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');

		Array.from(this.xml.childNodes).each(function (option_xml, index) {
			
			var option = new Element('input', {
				type: 'radio',
				name: this.frmId + "_" + this.fldId,
				fld_id: this.frmId + "_" + this.fldId,
				value: option_xml.getAttribute(Field.PROPERTY_VALUE)
			}).setStyle('width', '15px');
					
			option.inject(this.content);
			
			var hide = false;
			/*if(option_xml.getAttribute("selected")) {
				option.set('checked', 'checked');
			} else if(this.options[Field.PROPERTY_READONLY]) {
				option.setStyle('display', 'none');
				hide = true;
			}*/
			if(this.options[Field.PROPERTY_READONLY]) {
				option.setStyle('display', 'none');
				//Solo escondemos los no seleccionados
				if(option_xml.getAttribute("selected"))
					option.set('checked', 'checked');
				else
					hide = true;
			} else if(option_xml.getAttribute("selected")) {
				option.set('checked', 'checked');
			}
			
			if(this.options[Field.PROPERTY_REQUIRED] && !this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				option.addClass('validate["required"]');
				$('frmData').formChecker.register(option);
			}
			
			if(this.options[Field.PROPERTY_DISABLED])
				option.set('disabled', 'disabled');
			
			var inner_node = "";
			var text_span = new Element('span');
			
			if(option_xml.childNodes[0])
				inner_node = option_xml.childNodes[0].nodeValue;
						
			if(this.options[Field.PROPERTY_DONT_BREAK_RADIO]) {				
				inner_node += ' ';			
				
				text_span.appendText(inner_node);
				text_span.inject(this.content);
				if(hide)
					text_span.setStyle('display', 'none');
				else if(this.options[Field.PROPERTY_READONLY])
					text_span.setStyles({'font-weight': 'bold',
					'padding-left': '15px'});
			} else {
				
				text_span.appendText(inner_node);
				text_span.inject(this.content);
				
				var br = (new Element('br')).inject(this.content);
				
				if(hide) {
					text_span.setStyle('display', 'none');
					br.setStyle('display', 'none');
				} else if(this.options[Field.PROPERTY_READONLY]) {
					text_span.setStyles({'font-weight': 'bold',
						'padding-left': '15px'});
				}
			}
			
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				text_span.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			else if(this.options[Field.PROPERTY_DISABLED])
				text_span.setStyle('color', 'grey');
			
			//onchange
//			if(this.xml.getAttribute(Field.FUNC_CHANGE) && !window.editionMode) {
			if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
				var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
				var target = this;
				if (fn_change) {
					option.addEvent('change', function() { 
						//fn_change();
						try {
							fn_change(new ApiaField(target));
						} catch(error) {}
					});			
				} else {				
					if(console) console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
					
					option.addEvent('change', function() {
						SynchronizeFields.toSync(this.content, this.getValue());
					}.bind(this));
				}
			} else {
				option.addEvent('change', function() {
					SynchronizeFields.toSync(this.content, this.getValue());
				}.bind(this));
			}
			
			//onclick
//			if(this.xml.getAttribute(Field.FUNC_CLICK) && !window.editionMode) {
			if(this.xml.getAttribute(Field.FUNC_CLICK)) {
				var fn_click = window[this.xml.getAttribute(Field.FUNC_CLICK)];
				var target = this;
				if (fn_click) {
					option.addEvent('click', function() {
						//fn_click();
						try {
							fn_click(new ApiaField(target));
						} catch(error) {}
					});
				}
			}
		}.bind(this));

		this.content.addClass('AJAXfield');

		if(this.xml.getAttribute("forceSync"))
			this.content.set(SynchronizeFields.SYNC_FAILED, 'true');

		
		if(this.options[Field.PROPERTY_TOOLTIP])
			label.tooltip(this.options[Field.PROPERTY_TOOLTIP], { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
		
		this.radio_opts = this.apijs_getOptions();//Backup de las opciones
	},
	
	getPrintHTML: function(formContainer) {
		
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var fieldContainer = this.parsePrintXMLposition(formContainer);
			
			var label = new Element('label').appendText(this.xml.getAttribute("attLabel") + ':');
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			label.inject(fieldContainer);
			
			var input = new Element('span');
			var value = this.apijs_getSelectedOption();
			if(value && value.length > 1)
				input.set('text', value[0] + ' - ' + value[1]);
			
			if(this.options[Field.PROPERTY_REQUIRED])
				fieldContainer.addClass('required');
			
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			input.inject(fieldContainer);
		}
	},
	
	showFormListener: function() {
		var options = this.content.getElements('input');
		if(options) {
			options.each(function(opt) {
				opt.erase('disabledCheck');
			});
		}
	},
	
	hideFormListener: function() {
		var options = this.content.getElements('input');
		if(options) {
			options.each(function(opt) {
				opt.set('disabledCheck', 'true');
			});
		}
	}
});