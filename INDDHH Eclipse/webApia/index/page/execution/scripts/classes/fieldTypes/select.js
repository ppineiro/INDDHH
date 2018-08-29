var Select = new Class({

	Extends: Field,
	
	Implements: GridField,
	
	hasBinding: false,
	
	serverValue: undefined,
	
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
		this.options[Field.PROPERTY_COL_WIDTH] 			= null;
		this.options[Field.PROPERTY_INPUT_AS_TEXT] 		= null;
		this.options[Field.PROPERTY_FONT_COLOR] 		= null;
		this.options[Field.PROPERTY_TOOLTIP] 			= null;
		this.options[Field.PROPERTY_VALUE_COLOR] 		= null;
		this.options[Field.PROPERTY_REQUIRED] 			= null;
		this.options[Field.PROPERTY_DISABLED] 			= null;
		//this.options[Field.PROPERTY_TRANSIENT] 			= null;
		this.options[Field.PROPERTY_READONLY] 			= null;
		this.options[Field.PROPERTY_VISIBILITY_HIDDEN] 	= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
	},
	
	booleanOptions: [Field.PROPERTY_INPUT_AS_TEXT, Field.PROPERTY_REQUIRED, Field.PROPERTY_DISABLED, Field.PROPERTY_READONLY, Field.PROPERTY_VISIBILITY_HIDDEN],
	
	getValue: function() {
		if(this.form.readOnly || this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			var res = '';
			Array.from(this.xml.childNodes).each(function (option_xml) {
				if(option_xml.getAttribute("selected")) {
					res = option_xml.getAttribute(Field.PROPERTY_VALUE);
				}
			});
			return res;
		} else {
			return this.content.getElement('select').get('value');
		}
	},
	
	/**
	 * Retorna el valor para la APIJS
	 */
	apijs_getFieldValue: function() {
		if(this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			return this.content.getElement('input').get('value');
		} else {
			return this.getValue();
		}
	},

	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_setFieldValue: function(value) {
		if(this.form.readOnly) return;
		if(typeOf(value) == "string" || typeOf(value) == "int") {
			this.content.getElements('option').each(function(option, index) {
				if(value == option.get('value')) {
					option.set('selected', true);
					option.getParent('select').set('defaultvalue', index);
				}
			});
			this.serverValue = undefined;
		} else {
			throw new Error('The function setFieldValue for a Select field only accepts int or string type for value parameter.');
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
	
	getPrpsForGridReload: function() {
		var res = {};
		res[Field.PROPERTY_TOOLTIP] = (this.options[Field.PROPERTY_TOOLTIP] != null ? this.options[Field.PROPERTY_TOOLTIP] : '');
		res[Field.PROPERTY_VALUE_COLOR] = (this.options[Field.PROPERTY_VALUE_COLOR] != null ? this.options[Field.PROPERTY_VALUE_COLOR] : '');
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
		} else if(prp_name == Field.PROPERTY_INPUT_AS_TEXT) {
			
			if(console) console.error("[" +this.frmId + "_" + this.fldId + "] ERROR: INPUT_AS_TEXT not supported.")
			
		} else if(prp_name == Field.PROPERTY_SIZE) {
			
			this.options[Field.PROPERTY_SIZE] = Number.from(prp_value);
			var select = this.content.getElement('select')
			if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0) {
				if(select)
					select.setStyle('width', this.options[Field.PROPERTY_SIZE]);
			} else {
				if(select)
					select.setStyle('width', '');
			}
			
		} else if(prp_name == Field.PROPERTY_COL_WIDTH) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_FONT_COLOR && !this.row_xml) {
			this.content.getElement('label').setStyle('color', prp_value);
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_TOOLTIP) {
			if(this.row_xml)//Grilla
				this.content.getElement('select').tooltip(prp_value, { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
			else				
				this.content.getElement('label').tooltip(prp_value, { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
			this.options[Field.PROPERTY_TOOLTIP] = prp_value;
		} else if(prp_name == Field.PROPERTY_VALUE_COLOR) {
			this.content.getElement('select').setStyle('color', prp_value);
			this.options[Field.PROPERTY_VALUE_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_REQUIRED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_REQUIRED] == false) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					this.content.getElement('select').addClass('validate["required"]');
					if(this.row_xml)
						this.content.getElement('div').addClass('gridCellRequired');
					else
						this.content.addClass('required');
					$('frmData').formChecker.register(this.content.getElement('select'));
				}
				this.options[Field.PROPERTY_REQUIRED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_REQUIRED]) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					this.content.getElement('select').removeClass('validate["required"]');				
					if(this.row_xml)
						this.content.getElement('div').removeClass('gridCellRequired');
					else
						this.content.removeClass('required');
					$('frmData').formChecker.dispose(this.content.getElement('select'));
				}
				this.options[Field.PROPERTY_REQUIRED] = false;
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
			
			if(this.options[Field.PROPERTY_INPUT_AS_TEXT]) return;
				
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_READONLY] == false) {
				
				this.content.getElement('select')
					.addClass('readonly')
					.set('defaultvalue', this.getSelectedIndex())				
					.addEvent('change', this.restoreDefaultValue);
				
				this.options[Field.PROPERTY_READONLY] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_READONLY]) {
			
				this.content.getElement('select')
					.removeClass('readonly')								
					.removeEvent('change', this.restoreDefaultValue);
				
				this.options[Field.PROPERTY_READONLY] = false;
			}
		} else if(prp_name == Field.PROPERTY_VISIBILITY_HIDDEN) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN] == false) {
				this.content.addClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = true;
				//Si es requerido, desregistrarlo
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					this.content.getElement('select').removeClass('validate["required"]');				
					if(this.row_xml)
						this.content.getElement('div').removeClass('gridCellRequired');
					else
						this.content.removeClass('required');
					$('frmData').formChecker.dispose(this.content.getElement('select'));
				}
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				this.content.removeClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = false;
				//Verificar si era requerido
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					this.content.getElement('select').addClass('validate["required"]');
					if(this.row_xml)
						this.content.getElement('div').addClass('gridCellRequired');
					else
						this.content.addClass('required');
					$('frmData').formChecker.register(this.content.getElement('select'));
				}
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
		
		if(!this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			this.content.getElements('option').each(function(option) {
				if(asObject) {
					result[option.get('value')] = option.get('html');
				} else {
					var current_opt = new Array();
					current_opt.push(option.get('value'));
					current_opt.push(option.get('html'));
					result.push(current_opt);
				}
			});
		}
		return result;
	},
	
	/**
	 * Metodo de APIJS para eliminar todos los posibles valores del campo
	 */
	apijs_clearOptions: function() {
		if(!this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			this.content.getElements('option').destroy();
		}
	},
	
	/**
	 * Metodo de APIJS para agregar un posible valor
	 */
	apijs_addOption: function(store_value, show_value, allowRepeatedValue) {
		if(!this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			if(allowRepeatedValue) {
				var opt = new Element('option', {
					value: store_value,
					html: show_value 
				});
				
				if(this.serverValue != undefined && store_value == this.serverValue)
					opt.set('selected', 'true');
				
				opt.inject(this.content.getElement('select'));
			} else {
				var found = false;
				if(this.form.readOnly) {
					
				} else {
					this.content.getElement('select').getChildren('option').each(function(opt) {
						if(opt.get('value') == store_value) {
							opt.set('html', show_value);
							found = true;
						}
					});
					if(!found) {
						var opt = new Element('option', {
							value: store_value,
							html: show_value 
						});
						
						if(this.serverValue != undefined && store_value == this.serverValue)
							opt.set('selected', 'true');
						
						opt.inject(this.content.getElement('select'));
					}
				}
			}
		}
	},
	
	/**
	 * Metodo de APIJS para eliminar un posible valor
	 */
	apijs_removeOption: function(value) {
		if(!this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			var opts = this.content.getElements('option');
			if(opts) {
				for(var i = 0; i < opts.length; i++) {
					if(opts[i].get('value') == value) {
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
		
		if(!this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			this.content.getElements('option').each(function(option) {
				if(option.get('selected')) {
					if(asObject) {
						result[option.get('value')] = option.get('html');
					} else {
						result.push(String.from(option.get('value')));
						result.push(String.from(option.get('html')));						
					}
				}
			});
		}
		
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

	getSelectedIndex: function() {
		var opts = this.apijs_getOptions();
		if(opts && opts.length) {
			var val = this.apijs_getSelectedValue();
			for(var i = 0; i < opts.length; i++) {
				if(opts[i][0] == val)
					return i;
			}
		}
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

		if(this.xml.getAttribute("entityBind") == "true")
			this.hasBinding = true;
		
		if(this.xml.getAttribute("serverEvent"))
			this.serverEvent = true;
		
		if(this.xml.getAttribute("value"))
			this.serverValue = this.xml.getAttribute("value");
		
		//Si estoy en monitor, solo coloco el texto
		if(this.form.readOnly) {
			if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
				this.content.addClass('visibility-hidden');
			
			var label = new Element('label.monitor-lbl').appendText(this.xml.getAttribute("attLabel") + ':');
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			label.inject(this.content);
			
			var select = new Element('span.monitor-select');
			
			Array.from(this.xml.childNodes).each(function (option_xml, index) {
				if(option_xml.getAttribute("selected")) {
					var inner_node = "";
					if(option_xml.childNodes[0])
						inner_node = option_xml.childNodes[0].nodeValue;
					select.set('text', inner_node);
				}
			});
			
			if(this.options[Field.PROPERTY_REQUIRED])
				this.content.addClass('required');
			
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				select.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			select.inject(this.content);
			
			return;
		}
		
		//LABEL
		
		var label = new Element('label');
				
		if(this.options[Field.PROPERTY_FONT_COLOR])
			label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		
		label.appendText(this.xml.getAttribute("attLabel") + ':');
		
		//SELECT
		
		var select;
		
		if(this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			select = new Element('input', {
				fld_id: this.frmId + "_" + this.fldId,
				type: "text"
			});
			
			select.addClass('input-as-text');
					
			select.set('readonly', 'readonly');
		} else {
			select = new Element('select', {
				fld_id: this.frmId + "_" + this.fldId
			});
		}
		
		if(this.options[Field.PROPERTY_SIZE])
			select.setStyle('width', Number.from(this.options[Field.PROPERTY_SIZE]));
		
		if(this.options[Field.PROPERTY_DISABLED])
			select.set('disabled', 'disabled');
		
		if(this.options[Field.PROPERTY_REQUIRED]) {
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				select.addClass('validate["required"]');
				this.content.addClass('required');
				$('frmData').formChecker.register(select);
			}
		}
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			select.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		var defValue = 0;
		
		Array.from(this.xml.childNodes).each(function (option_xml, index) {
			var option = new Element('option');
			
			if(option_xml.getAttribute("selected")) {
				option.set('selected', 'selected');
				defValue = index;
			}
			
			if(!this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
				var inner_node = "";
				if(option_xml.childNodes[0])
					inner_node = option_xml.childNodes[0].nodeValue;
				
				option.set('value', option_xml.getAttribute(Field.PROPERTY_VALUE));
				option.appendText(inner_node);
				
				option.inject(select);
			}
		}.bind(this));
		
		select.set('defaultvalue', defValue);
		
		if(this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			if(defValue < this.xml.childNodes.length) {
				var value = this.xml.childNodes[defValue].childNodes[0];
				if(value)
					select.set('value', value.nodeValue);
				else
					select.set('value', '');
			}
		} else if(this.options[Field.PROPERTY_READONLY]) {
			select.addClass('readonly');
			select.addEvent('change', this.restoreDefaultValue);
		}
		
		label.inject(this.content);
		select.inject(this.content);
		
		if(!this.options[Field.PROPERTY_INPUT_AS_TEXT])
			this.content.addClass('AJAXfield');
		
		var multIdx = this.xml.getAttribute("multIdx");
		if(multIdx) {
			this.index = Number.from(multIdx);
		}
		
		//Obligamos siempre a sincronizar el valor de los select a menos que tenga ver como texto
		if(this.xml.getAttribute("forceSync") && !this.options[Field.PROPERTY_INPUT_AS_TEXT])
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
				select.addEvent('change', function() {					
					
					//Las clases de negocio se ejecutan solo si no es readonly
					//if(!this.getParent().retrieve(Field.STORE_KEY_FIELD).options[Field.PROPERTY_READONLY]) {
					if(!this.options[Field.PROPERTY_READONLY]) {
						//SynchronizeFields.preJSexec(this.content);	
						//SynchronizeFields.toSync(this.getParent(), this.get('value'));
						//SynchronizeFields.toSync(this.content, this.getValue());
						//fn_change();
						
						this.serverValue = undefined;
						
						try {
							fn_change(new ApiaField(target))
						} catch(error) {}
						//SynchronizeFields.posJSexec(this.content);
						
						if (this.hasBinding && !this.serverEvent) {
							//Forzar una funci�n contra el server
//							var frmParent = this.frmId.split('_')[0];
//							var frmId = this.frmId.split('_')[1];
//							SynchronizeFields.syncJAVAexec(function() {
//								$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + this.fldId + '&evtId=1&attId=' + this.attId + '&index=' + this.index  + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
//								$('frmData').fireEvent('submit');
//							}.bind(this));
							this.executeAjaxBinding();
						}
					}
				}.bind(this));			
			} else {
				
				console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
				
				select.addEvent('change', function() {
					//No deber�a ser necesario sincronizar si es readonly
					//if(!this.getParent().retrieve(Field.STORE_KEY_FIELD).options[Field.PROPERTY_READONLY]) {
					if(!this.options[Field.PROPERTY_READONLY]) {
						
						this.serverValue = undefined;
						
						SynchronizeFields.toSync(this.content, this.getValue());
						
						if (this.hasBinding) {
							//Forzar una funci�n contra el server
//							var frmParent = this.frmId.split('_')[0];
//							var frmId = this.frmId.split('_')[1];
//							SynchronizeFields.syncJAVAexec(function() {
//								$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + this.fldId + '&evtId=1&attId=' + this.attId + '&index=' + this.index  + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
//								$('frmData').fireEvent('submit');
//							}.bind(this));
							this.executeAjaxBinding();
						}
					}
				}.bind(this));
			}
		} else {
			select.addEvent('change', function() {
				//No deber�a ser necesario sincronizar si es readonly
				//if(!this.getParent().retrieve(Field.STORE_KEY_FIELD).options[Field.PROPERTY_READONLY]) {
				if(!this.options[Field.PROPERTY_READONLY]) {
					
					this.serverValue = undefined;
					
					SynchronizeFields.toSync(this.content, this.getValue());
					
					if (this.hasBinding) {
						//Forzar una funci�n contra el server
//						var frmParent = this.frmId.split('_')[0];
//						var frmId = this.frmId.split('_')[1];
//						SynchronizeFields.syncJAVAexec(function() {
//							$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + this.fldId + '&evtId=1&attId=' + this.attId + '&index=' + this.index  + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
//							$('frmData').fireEvent('submit');
//						}.bind(this));
						this.executeAjaxBinding();
					}
				}
			}.bind(this));
		}
	},
	
	/**
	 * Mantiene seleccionado el valor en selects readonly
	 */
	restoreDefaultValue: function(e) {
		var opts = this.getElements('option');
		
		var defValue = Number.from(this.get("defaultvalue")); 
		if(defValue >= 0 && defValue < opts.length) {
			opts[defValue].set('selected', 'selected');
		}
	},
	
	parseXMLforGrid: function(td_container, grid_index, isGridReadonly) {
		this.content = td_container;
		this.index = grid_index;
		
		this.updateProperties();
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.addClass(clase);
			}.bind(this));
		
		//Seteamos el tipo de atributo
		if(this.xml.getAttribute("valueType"))
			this.options.valueType = this.xml.getAttribute("valueType");
		
		if(this.xml.getAttribute("entityBind") == "true")
			this.hasBinding = true;
		
		if(this.row_xml.getAttribute("value"))
			this.serverValue = this.row_xml.getAttribute("value");
		
		//Si estoy en monitor, solo coloco el texto
		if(this.form.readOnly || isGridReadonly) {
			if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
				this.content.addClass('visibility-hidden');
			
			var select = new Element('span.monitor-select');
			
			Array.from(this.row_xml.childNodes).each(function (option_xml, index) {
				if(option_xml.getAttribute("selected")) {
					var inner_node = "";
					if(option_xml.childNodes[0])
						inner_node = option_xml.childNodes[0].nodeValue;
					select.set('text', inner_node);
				}
			});
			
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				select.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			var div = new Element('div.gridMinWidth', {
				id: this.frmId + '_' + this.fldId + '_' + grid_index
			});
			
			if(this.options[Field.PROPERTY_REQUIRED])
				div.addClass('gridCellRequired');
			
			if(Number.from(this.options[Field.PROPERTY_COL_WIDTH]))
				div.setStyle('width', Number.from(this.options[Field.PROPERTY_COL_WIDTH]));
			
			select.inject(div);
			div.inject(this.content);
			
			return;
		}
		
		
		//SELECT		
		var select;
		
		if(this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			select = new Element('input', {
				fld_id: this.frmId + "_" + this.fldId,
				type: "text"
			});
			
			select.addClass('input-as-text');
			
			if(!this.options[Field.PROPERTY_READONLY])
				select.set('readonly', 'readonly');
			
		} else {
			select = new Element('select', {
				fld_id: this.frmId + "_" + this.fldId
			});
		}
		
		if(Number.from(this.options[Field.PROPERTY_SIZE]))
			select.setStyle('width', Number.from(this.options[Field.PROPERTY_SIZE]));
		
		if(this.options[Field.PROPERTY_DISABLED])
			select.set('disabled', 'disabled');		
		
		if(this.options[Field.PROPERTY_REQUIRED]) {
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				select.addClass('validate["required"]');
				
				if($('frmData').formChecker)
					$('frmData').formChecker.register(select);
			}
			
			if(this.form.options[Form.PROPERTY_FORM_HIDDEN] == "true") {
				select.set('disabledCheck', 'true');
			}
		}
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			select.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);		
		
		var defValue = 0;
		
		Array.from(this.row_xml.childNodes).each(function (option_xml, index) {
			var option = new Element('option');
			
			if(option_xml.getAttribute("selected")) {
				option.set('selected', 'selected');
				defValue = index;
			}
			
			if(!this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
				var inner_node = "";
				if(option_xml.childNodes[0])
					inner_node = option_xml.childNodes[0].nodeValue;
				
				option.set('value', option_xml.getAttribute(Field.PROPERTY_VALUE));
				option.appendText(inner_node);
				
				option.inject(select);
			}
		}.bind(this));
		
		if(this.options[Field.PROPERTY_READONLY]) {
			select.addClass('readonly');
			select.set('defaultvalue', defValue);
			
			select.addEvent('change', this.restoreDefaultValue);
		}
		
		
		if(this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			if(defValue < this.row_xml.childNodes.length) {
				var value = this.row_xml.childNodes[defValue].childNodes[0];
				if(value)
					select.set('value', value.nodeValue);
			}
		}
		
		if(this.options[Field.PROPERTY_TOOLTIP])
			select.tooltip(this.options[Field.PROPERTY_TOOLTIP], { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
		
		
		var div = new Element('div.gridMinWidth', {
			id: this.frmId + '_' + this.fldId + '_' + grid_index
		});
		
		if(this.options[Field.PROPERTY_REQUIRED] && !this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			div.addClass('gridCellRequired');
		
		if(Number.from(this.options[Field.PROPERTY_COL_WIDTH]))
			div.setStyle('width', Number.from(this.options[Field.PROPERTY_COL_WIDTH]));
		
		select.inject(div);
		div.inject(this.content);
		
		/*
		if(!Number.from(this.options[Field.PROPERTY_SIZE])) {
			var w = Number.from(div.getStyle('width')) - 10;
			if(w > 0)
				select.setStyle('width', w);
		}*/
		if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0)
			select.setStyle('width', Number.from(this.options[Field.PROPERTY_SIZE]));
		else {
			//input.setStyle('width', '100%');
			//var w = Number.from(div.getStyle('width')) - 10;
			var w = Generic.getHiddenWidth(div) - 10;
			if(w > 0)
				select.setStyle('width', w);
		}
		
		div.store(Field.STORE_KEY_FIELD, this);
		
		div.addClass('AJAXfield');
		
		//Obligamos siempre a sincronizar el valor de los select, a menos que sea ver como texto
		if(this.xml.getAttribute("forceSync") && !this.options[Field.PROPERTY_INPUT_AS_TEXT])
			div.set(SynchronizeFields.SYNC_FAILED, 'true');
		
		//onchange
//		if(this.xml.getAttribute(Field.FUNC_CHANGE) && !window.editionMode) {
		if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
			var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
			var target = this;
			if (fn_change) {
				select.addEvent('change', function() {	
					
					//Las clases de negocio se ejecutan solo si no es readonly
					//if(!this.getParent().retrieve(Field.STORE_KEY_FIELD).options[Field.PROPERTY_READONLY]) {
					if(!target.options[Field.PROPERTY_READONLY]) {
						//SynchronizeFields.preJSexec(this.content);					
						//fn_change();
						
						target.serverValue = undefined;
						
						try {
							fn_change(new ApiaField(target, true));
						} catch(error) {}
						//SynchronizeFields.posJSexec(this.content);
						
						if (target.hasBinding && !target.serverEvent) {
							//Forzar una funci�n contra el server
//							var frmParent = target.frmId.split('_')[0];
//							var frmId = target.frmId.split('_')[1];
//							SynchronizeFields.syncJAVAexec(function() {
//								$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + target.fldId + '&evtId=1&attId=' + target.attId + '&index=' + target.index  + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
//								$('frmData').fireEvent('submit');
//							});
							target.executeAjaxBinding();
						}
					}
				});			
			} else {
				
				console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
				
				select.addEvent('change', function() {
					//No deber�a ser necesario sincronizar si es readonly
					//if(!this.getParent().retrieve(Field.STORE_KEY_FIELD).options[Field.PROPERTY_READONLY]) {
					if(!target.options[Field.PROPERTY_READONLY]) {
						
						target.serverValue = undefined;
						
						SynchronizeFields.toSync(div, target.getValue());
						
						if (target.hasBinding) {
							//Forzar una funci�n contra el server
//							var frmParent = target.frmId.split('_')[0];
//							var frmId = target.frmId.split('_')[1];
//							SynchronizeFields.syncJAVAexec(function() {
//								$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + target.fldId + '&evtId=1&attId=' + target.attId + '&index=' + target.index  + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
//								$('frmData').fireEvent('submit');
//							});
							target.executeAjaxBinding();
						}
					}
				});
			}
		} else {
			var target = this;
			select.addEvent('change', function() {
				//No deber�a ser necesario sincronizar si es readonly
				//if(!this.getParent().retrieve(Field.STORE_KEY_FIELD).options[Field.PROPERTY_READONLY]) {
				if(!target.options[Field.PROPERTY_READONLY]) {
					
					target.serverValue = undefined;
					
					SynchronizeFields.toSync(div, target.getValue());
					
					if (target.hasBinding) {
						//Forzar una funci�n contra el server
//						var frmParent = target.frmId.split('_')[0];
//						var frmId = target.frmId.split('_')[1];
//						SynchronizeFields.syncJAVAexec(function() {
//							$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + target.fldId + '&evtId=1&attId=' + target.attId + '&index=' + target.index  + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
//							$('frmData').fireEvent('submit');
//						});
						target.executeAjaxBinding();
					}
				}
			});
		}
	},
	
	getPrintHTML: function(formContainer) {
		
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var fieldContainer = this.parsePrintXMLposition(formContainer);
			
			var label = new Element('label').appendText(this.xml.getAttribute("attLabel") + ':');
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			label.inject(fieldContainer);
			
			var input = new Element('span');
			
			if(this.form.readOnly) {
				Array.from(this.xml.childNodes).each(function (option_xml, index) {
					if(option_xml.getAttribute("selected")) {
						var inner_node = "";
						if(option_xml.childNodes[0])
							inner_node = option_xml.childNodes[0].nodeValue;
						input.set('text', option_xml.getAttribute(Field.PROPERTY_VALUE) + ' - ' + inner_node);
					}
				});
			} else {
				value = this.apijs_getSelectedOption();
				if(value.length > 1)
					input.set('text', value[0] + ' - ' + value[1]);
			}
			
			if(this.options[Field.PROPERTY_REQUIRED])
				fieldContainer.addClass('required');
			
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			input.inject(fieldContainer);
		}
	},
	
	getPrintHTMLForGrid: function() {
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var a = new Element('div');
			
			var label = new Element('label').set('html', (this.options[Field.PROPERTY_REQUIRED] ? '*' : '') + this.xml.getAttribute("attLabel") + ':');
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			
			label.inject(new Element('td.left-cell').inject(a));
			
			var input = new Element('span');
			
			if(this.form.readOnly) {
				Array.from(this.row_xml.childNodes).each(function (option_xml, index) {
					if(option_xml.getAttribute("selected")) {
						var inner_node = "";
						if(option_xml.childNodes[0])
							inner_node = option_xml.childNodes[0].nodeValue;
						input.set('text', option_xml.getAttribute(Field.PROPERTY_VALUE) + ' - ' + inner_node);
					}
				});
			} else {
				value = this.apijs_getSelectedOption();
				if(value.length > 1)
					input.set('text', value[0] + ' - ' + value[1]);
			}
			
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			input.inject(new Element('td').inject(a));
			
			return a.get('html');
		}
		return '';
	},
	
	getValueHTMLForGrid: function() {
		var a = new Element('div');
		var input = new Element('span');
		if(this.form.readOnly) {
			Array.from(this.row_xml.childNodes).each(function (option_xml, index) {
				if(option_xml.getAttribute("selected")) {
					var inner_node = "";
					if(option_xml.childNodes[0])
						inner_node = option_xml.childNodes[0].nodeValue;
					input.set('text', option_xml.getAttribute(Field.PROPERTY_VALUE) + ' - ' + inner_node);
				}
			});
		} else {
			value = this.apijs_getSelectedOption();
			if(value.length > 1)
				input.set('text', value[0] + ' - ' + value[1]);
		}
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		input.inject(a);
		
		return a.get('html');
	},
	
	showFormListener: function() {
		//var select = this.content.getChildren('select')[0] || this.content.getChildren('div')[0].getChildren('select')[0];
		var select = this.content.getElement('select');
		if(select)
			select.erase('disabledCheck');
	},
	
	hideFormListener: function() {
		//var select = this.content.getChildren('select')[0] || this.content.getChildren('div')[0].getChildren('select')[0];
		var select = this.content.getElement('select');
		if(select)
			select.set('disabledCheck', 'true');
	}
});