/**
 * Campo Input
 */
var Input = new Class({
	
	Extends: Field,
	
	Implements: GridField,
	
	//maskAux: "nn'/'nn'/'nnnn",
	
	mask: "",
	
	hasBinding: false,
	
	qryId: null,
	
	serverEvent: false,
	
	translations: [],
	
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
		this.options[Field.PROPERTY_NAME] 						= null;
		this.options[Field.PROPERTY_SIZE] 						= null;
		this.options[Field.PROPERTY_COL_WIDTH] 					= null;
		this.options[Field.PROPERTY_INPUT_AS_TEXT] 				= null;
		this.options[Field.PROPERTY_REGEXP_MESSAGE] 			= null;
		this.options[Field.PROPERTY_FONT_COLOR] 				= null;
		this.options[Field.PROPERTY_TOOLTIP] 					= null;
		this.options[Field.PROPERTY_VALUE_COLOR] 				= null;
		this.options[Field.PROPERTY_REQUIRED] 					= null;
		this.options[Field.PROPERTY_DISABLED] 					= null;
		this.options[Field.PROPERTY_MODAL] 						= null;
		//this.options[Field.PROPERTY_TRANSIENT] 					= null;
		this.options[Field.PROPERTY_READONLY] 					= null;
		this.options[Field.PROPERTY_VISIBILITY_HIDDEN] 			= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE]		 		= null;
		this.options[Field.PROPERTY_STORE_MODAL_QUERY_RESULT]	= null;
		this.options[Field.PROPERTY_CSS_CLASS]					= null;
		this.options[Field.PROPERTY_TRANSLATION_REQUIRED]		= null;
	},
	
	booleanOptions: [Field.PROPERTY_INPUT_AS_TEXT, Field.PROPERTY_REQUIRED, Field.PROPERTY_DISABLED, Field.PROPERTY_READONLY, Field.PROPERTY_VISIBILITY_HIDDEN, Field.PROPERTY_STORE_MODAL_QUERY_RESULT, Field.PROPERTY_TRANSLATION_REQUIRED],
	
	getValue: function() {
		if(!this.qryId || this.qry_show_value == undefined) {
			return this.content.getElements('input')[0].get('value');
		} else if(this.row_xml) {
			return this.qry_value;
		} else if(this.index != null) {
			return this.qry_value; //Tareas multivaluadas
		} else {
			return [this.qry_value, this.qry_show_value];
		}
	},
	
	/**
	 * Retorna el valor para la APIJS
	 */
	apijs_getFieldValue: function() {
		if(this.form.readOnly || this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			if(!this.qryId || this.qry_show_value == undefined) {
				if(this.row_xml)
					return this.row_xml.getAttribute(Field.PROPERTY_VALUE);
				else
					return this.xml.getAttribute(Field.PROPERTY_VALUE);
			} else {
				return [this.qry_value, this.qry_show_value];
			}
		} else {
			if(!this.qryId || this.qry_show_value == undefined)
				return this.content.getElements('input')[0].get('value');
			else
				return [this.qry_value, this.qry_show_value];
		}
	},
	
	/**
	 * Retorna el valor para la APIJS
	 */
	apijs_getObjectValue: function() {
		if(this.form.readOnly || this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			return this.apijs_getFieldValue();
		}
		if(this.options.valueType == "D") {
			if(this.getValue() == '')
				return null;
			var inputs = this.content.getChildren();
			var format = (inputs[0].get("format") == null) ? DATE_FORMAT : inputs[0].get("format");
			return new DatePicker().unformat(this.getValue(), format);
		} else if(this.options.valueType == "N") {
			//return Number.from(this.getValue());
			return ApiaFunctions.toJSNumber(this.getValue());
		} else if(!this.qryId || this.qry_show_value == undefined) {
			return String.from(this.getValue());
		} else {
			return this.apijs_getFieldValue();
		}
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_setFieldValue: function(value) {
		if(this.form.readOnly || this.options[Field.PROPERTY_INPUT_AS_TEXT]) return;
		if(!this.qryId || this.qry_show_value == undefined) {
			if(this.options.valueType == "D") {
				if(typeOf(value) == 'date') {
					var inputs = this.content.getElements('input');
					var format = (inputs[0].get("format") == null) ? DATE_FORMAT : inputs[0].get("format");
					
					var frmt_value = new DatePicker().format(value, format);
					
					inputs[0].set('value', frmt_value);
					
					if(inputs[1])
						inputs[1].set('value', frmt_value);
				} else if (typeOf(value) == 'string') {
					
					var num_value = Number.from(value);
					if((num_value + "").length == value.length) {
						//Es el time
						var dte_value = new Date();
						dte_value.setTime(num_value);
						this.apijs_setFieldValue(dte_value);
					} else {
						var inputs = this.content.getElements('input');
						if(value === '') {
							inputs[0].set('value', "");
							inputs[1].set('value', "");
						} else {
							var format = (inputs[0].get("format") == null) ? DATE_FORMAT : inputs[0].get("format");
							if(Generic.checkDateFormat(value, format)) {
								inputs[0].set('value', value);
								inputs[1].set('value', value);
							} else if(console) {
								//TODO: pasar a label 
								console.log('Error en formato de valor de fecha para el campo ' + this.xml.getAttribute("attLabel"));
							}
						}
					}
				} else if(value == null || value == undefined || value === '') {
					var inputs = this.content.getElements('input');
					inputs[0].set('value', "");
					inputs[1].set('value', "");
				}
			} else if(this.options.valueType == "N") {
				if(typeOf(value) == 'number') {
					this.content.getElement('input').set('value', ApiaFunctions.toApiaNumber(value) + "");
				} else if (typeOf(value) == 'string') {
					if(value == '') {
						this.content.getElement('input').set('value', "");
					} else {
						//Obtener format numerico
						if(objNumRegExp.test(value)) {
							this.content.getElement('input').set('value', value);
						}
					}
				} else if(value == null || value == undefined || value === '') {
					this.content.getElement('input').set('value', "");
				}
			} else {
				if(value == null || value == undefined) {
					this.content.getElement('input').set('value', "").set('unmasked_value', '');
				} else {
					this.content.getElement('input').set('value', value + "").set('unmasked_value', value + "");
				}
			}
		}
		//Se evita tirar la excepci�n para el caso de clearValue sobre el formulario entero
		//else
		//	throw new Error("Can not set value to Input fields with modal property");
		
		
		/*
		if(!this.qryId || this.qry_show_value == undefined) {
			this.content.getElements('input')[0].set('value', value);
		} else {
			this.qry_value = value;
			this.qry_show_value == undefined;
			this.content.getElements('input')[0].set('value', value);
		}
		*/
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_clearValue: function() {
		if(this.qryId && this.qry_show_value != undefined) {
			this.qry_value = '';
			this.qry_show_value = '';
			this.content.getElements('input')[0].set('value', '');
		} else {
			this.apijs_setFieldValue("");
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
			var input = this.content.getElement('input')
			if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0) {				
				if(input)
					input.setStyle('width', this.options[Field.PROPERTY_SIZE]);
			} else {
				if(input)
					input.setStyle('width', '');
			}
		} else if(prp_name == Field.PROPERTY_COL_WIDTH) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_REGEXP_MESSAGE) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_FONT_COLOR && !this.row_xml) {
			this.content.getElement('label').setStyle('color', prp_value);
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_TOOLTIP) {
			if(this.row_xml) //Grilla
				this.content.getElement('input').tooltip(prp_value, { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
			else
				this.content.getElement('label').tooltip(prp_value, { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});				
			this.options[Field.PROPERTY_TOOLTIP] = prp_value;
		} else if(prp_name == Field.PROPERTY_VALUE_COLOR) {
			this.content.getElement('input').setStyle('color', prp_value);
			this.options[Field.PROPERTY_VALUE_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_REQUIRED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_REQUIRED] == false) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					//this.content.getElement('input').addClass('validate["required"]');
					var input = this.content.getElement('input');
					
					if(this.row_xml)
						this.content.getElement('div').addClass('gridCellRequired');
					else
						this.content.addClass('required');
					
					if(this.options.valueType == "D") {
						input.addClass('validate["required","target:' + input.get('fld_id') + '_d"]');
						$('frmData').formChecker.register(input);
					} else if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
						if(!input.hasClass('validate["%Input.customRequiredChecker"]')) {
							input.addClass('validate["%Input.customRequiredChecker"]');
							$('frmData').formChecker.register(input);
						}
					} else {
						input.addClass('validate["required"]');
						$('frmData').formChecker.register(input);
					}					
					
				}
				this.options[Field.PROPERTY_REQUIRED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_REQUIRED]) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					//this.content.getElement('input').removeClass('validate["required"]');
					var input = this.content.getElement('input');
					
					if(this.row_xml)
						this.content.getElement('div').removeClass('gridCellRequired');
					else
						this.content.removeClass('required');
					
					if(this.options.valueType == "D") {
						input.removeClass('validate["required","target:' + input.get('fld_id') + '_d"]');
						$('frmData').formChecker.dispose(input);
					} else if(!this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
						input.removeClass('validate["required"]');
						$('frmData').formChecker.dispose(input);
					}
				}
				this.options[Field.PROPERTY_REQUIRED] = false;
			}
		} else if(prp_name == Field.PROPERTY_DISABLED) {
			
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_DISABLED] == false) {
				this.content.getElement('input').set('disabled', 'disabled');
				this.options[Field.PROPERTY_DISABLED] = true;
				if(this.options.valueType == "D")
					this.content.getElements('input')[1].set('disabled', 'disabled');
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_DISABLED]) {
				this.content.getElement('input').set('disabled', false);
				this.options[Field.PROPERTY_DISABLED] = false;
				if(this.options.valueType == "D")
					this.content.getElements('input')[1].set('disabled', false);
			}
			
		} else if(prp_name == Field.PROPERTY_MODAL) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_TRANSIENT) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_READONLY) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_READONLY] == false) {
				this.content.getElement('input')
					.set('readonly', 'readonly')
					.addClass('readonly');
				this.options[Field.PROPERTY_READONLY] = true;
				if(this.options.valueType == "D") {
					//Se le quita la mascara de las fechas
					if(this.xml.getAttribute('mask')) {
						this.mask = null;
						MaskedInput.unsetMask(this.content.getElements('input')[0]);
					}
					
					removeAdmDatePicker(this.content.getElements('input')[0]);
				}
				
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_READONLY]) {
				this.content.getElement('input')
					.set('readonly', false)
					.removeClass('readonly');
				this.options[Field.PROPERTY_READONLY] = false;
				if(this.options.valueType == "D") {
					//Se le agrega la mascara de las fechas
					if(this.xml.getAttribute('mask')) {
						//this.mask = this.xml.getAttribute('mask');
						this.mask = new Element('div').set('html', this.xml.getAttribute('mask')).get('html');
						MaskedInput.setMask(this.content.getElements('input')[0], this.mask);
					}
					
					setAdmDatePicker(this.content.getElements('input')[0]);
				}
				
			}
		} else if(prp_name == Field.PROPERTY_VISIBILITY_HIDDEN) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN] == false) {
				this.content.addClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = true;
				//Si es requerido, desregistrarlo
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					//this.content.getElement('input').removeClass('validate["required"]');
					var input = this.content.getElement('input');
					
					if(this.row_xml)
						this.content.getElement('div').removeClass('gridCellRequired');
					else
						this.content.removeClass('required');
					
					if(this.options.valueType == "D") {
						input.removeClass('validate["required","target:' + input.get('fld_id') + '_d"]');
						$('frmData').formChecker.dispose(input);
					} else if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
						if(input.hasClass('validate["%Input.customRequiredChecker"]')) {
							input.removeClass('validate["%Input.customRequiredChecker"]');
							$('frmData').formChecker.dispose(input);
						}
					} else {
						input.removeClass('validate["required"]');
						$('frmData').formChecker.dispose(input);
					}
					
					
				}
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				this.content.removeClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = false;
				//Verificar si era requerido
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					//this.content.getElement('input').addClass('validate["required"]');
					var input = this.content.getElement('input');
					
					if(this.row_xml)
						this.content.getElement('div').addClass('gridCellRequired');
					else
						this.content.addClass('required');
					
					if(this.options.valueType == "D") {
						input.addClass('validate["required","target:' + input.get('fld_id') + '_d"]');
						$('frmData').formChecker.register(input);
					} else if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
						if(!input.hasClass('validate["%Input.customRequiredChecker"]')) {
							input.addClass('validate["%Input.customRequiredChecker"]');
							$('frmData').formChecker.register(input);
						}
					} else {
						input.addClass('validate["required"]');
						$('frmData').formChecker.register(input);
					}
					
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
			//throw new Error('Property not found or not available for this field.')
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
		
		if(this.xml.getAttribute("entityBind") == "true")
			this.hasBinding = true;
		
		if(this.xml.getAttribute("qryId"))
			this.qryId = this.xml.getAttribute("qryId");
		
		if(this.xml.getAttribute("serverEvent"))
			this.serverEvent = true;
				
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
			
		if(this.xml.getAttribute("trad"))
			this.translations = JSON.decode(this.xml.getAttribute("trad"));
		
		//Si estoy en monitor, solo coloco el texto
		if(this.form.readOnly || this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
				this.content.addClass('visibility-hidden');
				
			var label = new Element('label.monitor-lbl').appendText(this.xml.getAttribute("attLabel") + ':');
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			label.inject(this.content);
			
			var input;
			if(this.options[Field.PROPERTY_INPUT_AS_TEXT])
				input = new Element('span.input-as-text');
			else
				input = new Element('span.monitor-input');
			
			if(this.qryId) {
				this.qry_value = this.xml.getAttribute(Field.PROPERTY_VALUE);
				this.qry_show_value = this.xml.getAttribute("qry_show_value");
			}
			
			if(!this.qryId || this.qry_show_value == undefined)
				input.set('text', this.xml.getAttribute(Field.PROPERTY_VALUE));
			else
				input.set('text', this.qry_value + ' - ' + this.qry_show_value);
			
			if(this.options[Field.PROPERTY_REQUIRED])
				this.content.addClass('required');
			
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			input.inject(this.content);
			
			this.addTranslationIcon(new Element('input', {value: input.get('text')}));
			
			if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
				input.addClass('validate["%Input.customRequiredChecker"]');
				input.set('forceReq', 'true');
				$('frmData').formChecker.register(input);
			}
			
			return;
		}
		
		//LABEL
		
		var label = new Element('label');
				
		if(this.options[Field.PROPERTY_FONT_COLOR])
			label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		
		label.appendText(this.xml.getAttribute("attLabel") + ':');
		
		//INPUT
		
		var input = new Element('input', {
			fld_id: this.frmId + "_" + this.fldId,
			type: "text"
		});
		
		if(this.xml.getAttribute("length"))
			input.set("maxlength", this.xml.getAttribute("length"));
		else
			input.set("maxlength", Input.MAX_LENGTH);
		
		if(this.xml.getAttribute(Field.PROPERTY_VALUE))
			input.set('value', this.xml.getAttribute(Field.PROPERTY_VALUE));
		
		if(this.options.valueType == "S") {
			//Nothing
		} else if(this.options.valueType == "N") {			
			
			input.set('attLabel', this.xml.getAttribute("attLabel"));
		} else if(this.options.valueType == "D") {
			
			input.addClass('datePicker');
			input.addClass('dateInput');
		}
		
		if(this.options[Field.PROPERTY_READONLY]) {
			input.set('readonly', 'readonly');
			input.addClass('readonly');
		}
		
		if(this.options[Field.PROPERTY_DISABLED])
			input.set('disabled', 'disabled');
		/*
		if(this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			input.addClass('input-as-text');
			
			if(!this.options[Field.PROPERTY_READONLY])
				input.set('readonly', 'readonly');
		}
		*/	
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			if(this.options[Field.PROPERTY_REQUIRED]) {
				if(this.options.valueType == "D")
					input.addClass('validate["required","target:' + this.frmId + "_" + this.fldId + '_d"]');
				else if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED])
					input.addClass('validate["%Input.customRequiredChecker"]');
				else
					input.addClass('validate["required"]');
				
				this.content.addClass('required');
				$('frmData').formChecker.register(input);
			} else if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED] && this.options.valueType != "D") {
				input.addClass('validate["%Input.customRequiredChecker"]');
				this.content.addClass('required');
				$('frmData').formChecker.register(input);
			}
		}
		
		var input_width;
		if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0) {
			input_width = Number.from(this.options[Field.PROPERTY_SIZE]);
			input.setStyle('width', input_width);
		}
		
		if(this.xml.getAttribute('regExp')) {
			
			input.addEvent('blur', function() {
				
				var value = input.get('value');
				if(input.get('empty_mask')) {
					//if(input.get('empty_mask') == str) {
					if(input.get('empty_mask') == value) {
						value = "";
					} else if(input.get('unmasked_value')) {
						value = input.get('unmasked_value');
					}
				}
				 
				var result = Generic.testRegExp(value, this.xml.getAttribute('regExp'));
				
				if(!result) {
					if(this.options[Field.PROPERTY_REGEXP_MESSAGE])
						showMessage(this.options[Field.PROPERTY_REGEXP_MESSAGE]);
					else
						showMessage(MSG_INVALID_REG_EXP);
					
					input.set('value', '');
				   	if(input.get('unmasked_value'))
				   		input.set('unmasked_value', '');

					input.select();
				}
			}.bind(this));
		}
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		
		label.inject(this.content);
		input.inject(this.content);
		
		this.content.addClass('AJAXfield');
		
		var multIdx = this.xml.getAttribute("multIdx");
		if(multIdx) {
			this.index = Number.from(multIdx);
		}
		
		if(this.xml.getAttribute("forceSync"))
			this.content.set(SynchronizeFields.SYNC_FAILED, 'true');
		
		if(this.xml.getAttribute('mask')) {
			//Setearle la m�scara a input
			if(!this.options[Field.PROPERTY_READONLY]) {
				//this.mask = this.xml.getAttribute('mask');
				this.mask = new Element('div').set('html', this.xml.getAttribute('mask')).get('html');
				MaskedInput.setMask(input, this.mask);
			}
		}
		
		if(this.options.valueType == "N")
			Numeric.setNumeric(input);
		
		if(this.options[Field.PROPERTY_TOOLTIP])
			label.tooltip(this.options[Field.PROPERTY_TOOLTIP], { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
		
		
		//onchange
//		if(this.xml.getAttribute(Field.FUNC_CHANGE) && !window.editionMode) {
		if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
			var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
			
			if (fn_change) {
				input.addEvent('change', function() {
					
					if(!this.fromModal && this.qryId) {
						
						this.qry_value = '';
						this.qry_show_value = this.content.getElement('input').get('value');
						
						if(!this.qry_show_value) {
							//TODO: Se comenta, verificar que no es necesario
							//SynchronizeFields.toSync(this.content, this.getValue());							
							//fn_change();
							try {
								fn_change(new ApiaField(this));
							} catch(error) {}
							
							if (this.hasBinding && !this.serverEvent)
								this.executeAjaxBinding();
							
							this.checkTranslationIconVisibility(input);
							
							return;
						}
						
						var target = this;
						
						new Request({
							url: 'apia.execution.FormAction.run?action=checkModalValue&frmId=' +  this.frmId.split('_')[1] + '&frmParent=' + this.frmId.split('_')[0] + '&fldId=' + this.fldId +'&attId=' + this.attId + '&qryId=' + this.qryId + '&value=' + this.qry_show_value + '&index=0&forGrid=false' + TAB_ID_REQUEST,
							onSuccess: function(responseText, responseXML) {
						    	//AJAX exitoso
						    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
						    		
						    		//Errorres y mensajes
						    		checkErrors(responseXML)
						    		
						    		//Control para xml de ie
						    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
						    		
						    		if(response.tagName == 'result' && response.getAttribute('success')) {
						    			target.qry_value = response.childNodes[0].getAttribute('value');
						    		} else {
						    			target.qry_value = '';
						    			target.qry_show_value = '';
						    			target.content.getElement('input').set('value', '');
						    			showMessage(MSG_VAL_NOT_FOUND);
						    		}					    		
						    	} else {
						    		target.qry_value = '';
					    			target.qry_show_value = '';
					    			target.content.getElement('input').set('value', '');
					    			showMessage(MSG_VAL_NOT_FOUND);
						    	}
						    	
						    	//SynchronizeFields.toSync(target.content, target.getValue());
						    	//fn_change();
						    	try {
						    		fn_change(new ApiaField(target));
						    	} catch(error) {}
						    	
						    	if (target.hasBinding && !target.serverEvent)
						    		target.executeAjaxBinding();
						    	
						    	target.checkTranslationIconVisibility(input);
							},
							onFailure: function(responseText, responseXML) {
								target.qry_value = '';
				    			target.qry_show_value = '';
				    			target.content.getElement('input').set('value', '');
				    			showMessage(MSG_VAL_NOT_FOUND);
				    			
				    			//SynchronizeFields.toSync(target.content, target.getValue());
				    			//fn_change();
				    			try {
				    				fn_change(new ApiaField(target));
				    			} catch(error) {}
				    			
				    			if (target.hasBinding && !target.serverEvent)
				    				target.executeAjaxBinding();
				    			
				    			target.checkTranslationIconVisibility(input);
							}
						}).send();
						
					} else {
						
						//SynchronizeFields.toSync(this.content, this.getValue());
						//fn_change();
						try {
							fn_change(new ApiaField(this));
						} catch(error) {}
						
						if (this.hasBinding && !this.serverEvent)
							this.executeAjaxBinding();
						
						this.checkTranslationIconVisibility(input);
					}
				}.bind(this));		
			} else {
				
				console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
				
				input.addEvent('change', function() {
					SynchronizeFields.toSync(this.content, this.getValue());
					
					if (this.hasBinding)
						this.executeAjaxBinding();
					
					this.checkTranslationIconVisibility(input);
				}.bind(this));
			}
		} else {
			input.addEvent('change', function(e) {
				
				if(!this.fromModal && this.qryId) {
					
					this.qry_value = '';
					this.qry_show_value = this.content.getElement('input').get('value');
					
					if(!this.qry_show_value) {
						SynchronizeFields.toSync(this.content, this.getValue());
						
						if (this.hasBinding)
							this.executeAjaxBinding();
						
						this.checkTranslationIconVisibility(input);
						
						return;
					}
						
					var target = this;
					
					new Request({
						url: 'apia.execution.FormAction.run?action=checkModalValue&frmId=' +  this.frmId.split('_')[1] + '&frmParent=' + this.frmId.split('_')[0] + '&fldId=' + this.fldId + '&qryId=' + this.qryId + '&attId=' + this.attId +  '&value=' + this.qry_show_value + '&index=0&forGrid=false' + TAB_ID_REQUEST,
						onSuccess: function(responseText, responseXML) {
					    	//AJAX exitoso
					    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
					    		
					    		//Errorres y mensajes
					    		checkErrors(responseXML)
					    		
					    		//Control para xml de ie
					    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
					    		
					    		if(response.tagName == 'result' && response.getAttribute('success')) {
					    			target.qry_value = response.childNodes[0].getAttribute('value');
					    		} else {
					    			target.qry_value = '';
					    			target.qry_show_value = '';
					    			input.set('value', '');
					    			showMessage(MSG_VAL_NOT_FOUND);
					    		}					    		
					    	} else {
					    		target.qry_value = '';
				    			target.qry_show_value = '';
				    			input.set('value', '');
				    			showMessage(MSG_VAL_NOT_FOUND);
					    	}
					    	
					    	SynchronizeFields.toSync(target.content, target.getValue());
					    	
					    	if (target.hasBinding)
					    		target.executeAjaxBinding();
					    	
					    	target.checkTranslationIconVisibility(input);
						},
						onFailure: function(responseText, responseXML) {
							target.qry_value = '';
			    			target.qry_show_value = '';
			    			target.content.getElement('input').set('value', '');
			    			showMessage(MSG_VAL_NOT_FOUND);
			    			
			    			SynchronizeFields.toSync(target.content, target.getValue());
			    			
			    			if (target.hasBinding)
			    				target.executeAjaxBinding();
			    			
			    			target.checkTranslationIconVisibility(input);
						}
					}).send();
					
				} else {
					SynchronizeFields.toSync(this.content,this.getValue());
					
					if (this.hasBinding)
						this.executeAjaxBinding();
					
					this.checkTranslationIconVisibility(input);
				}
			}.bind(this));
		}
		
		//-Modal
		if(this.qryId) {
			
			if(!input_width) {
				input.setStyle('width', Number.from(Generic.getHiddenWidth(input)) - 23);
			}
			
			this.qry_value = this.xml.getAttribute(Field.PROPERTY_VALUE);
			this.qry_show_value = this.xml.getAttribute("qry_show_value");
			input.set('value', this.qry_show_value);
			
			var mdl = new Element('div.mdl-btn').inject(this.content);
			mdl.addEvent('click', function(e) {
				
				if(!this.options[Field.PROPERTY_DISABLED]) {
				
					var target = this;
					
					ModalController.openWinModal(CONTEXT + '/apia.query.ModalAction.run?action=init&query=' + this.qryId + TAB_ID_REQUEST, 700, 462, null, null, true).addEvent('confirm', function(selected_index) {
						var request = new Request({
							method: 'post',
							url: CONTEXT + "/apia.query.ModalAction.run?action=getValues" + TAB_ID_REQUEST,
							onComplete: function(resText, resXml) {
								
								if(resXml) {
									var cells = resXml.getElementsByTagName('cell');
									
									if(cells && cells.length) {
										target.qry_value = cells[0].textContent || cells[0].text;
										//target.qry_show_value = cells[1].textContent || cells[1].text;
										target.qry_show_value = Generic.htmlDecode(cells[1].textContent || cells[1].text);
										
										//TODO: Setear valor y valor a guardar al input
										target.fromModal = true;
										target.content.getElement('input').set('value', Generic.htmlDecode(cells[1].textContent || cells[1].text)).fireEvent('change');
										target.fromModal = false;
										
										if(target.xml.getAttribute(Field.FUNC_MODAL_RETURN)) {
											var fn_modal_return = window[target.xml.getAttribute(Field.FUNC_MODAL_RETURN)];
											if(fn_modal_return) {
												//Disparar onModalReturn
												lastModalReturn = new Array();
												for(var i = 0; i < cells.length; i++) {
													var txt = cells[i].textContent || cells[i].text;
													txt = Generic.htmlDecode(txt);
													lastModalReturn.push(txt);
												}
												//fn_modal_return();
												try {
													fn_modal_return(new ApiaField(target));
												} catch(error) {}
											}
										}
									}
								}
							}
						}).send('id=' + selected_index);
					});
				}
			}.bind(this));
		} else {
			//Si no es un modal
			
			//TRADUCCION
			this.addTranslationIcon(input);
		}
		
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
		
		this.updateProperties();
		
		//Seteamos el tipo de atributo
		if(this.xml.getAttribute("valueType"))
			this.options.valueType = this.xml.getAttribute("valueType");
		
		if(this.xml.getAttribute("entityBind") == "true")
			this.hasBinding = true;
		
		if(this.xml.getAttribute("qryId"))
			this.qryId = this.xml.getAttribute("qryId");
		
		if(this.xml.getAttribute("serverEvent"))
			this.serverEvent = true;
		
		if(this.row_xml.getAttribute("trad"))
			this.translations = JSON.decode(this.row_xml.getAttribute("trad"));
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.addClass(clase);
			}.bind(this));
		
		//Si estoy en monitor, solo coloco el texto
		if(this.form.readOnly || isGridReadonly || this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			
			if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
				this.content.addClass('visibility-hidden');
				
			var input;
			
			if(this.options[Field.PROPERTY_INPUT_AS_TEXT])
				input = new Element('span.input-as-text');
			else
				input = new Element('span.monitor-input');
			
			if(this.qryId) {
				this.qry_value = this.row_xml.getAttribute(Field.PROPERTY_VALUE);
				this.qry_show_value = this.row_xml.getAttribute("qry_show_value"); //Verificar si es row_xml o xml
			}
			
			if(!this.qryId || this.qry_show_value == undefined)
				input.set('text', this.row_xml.getAttribute(Field.PROPERTY_VALUE));
			else
				input.set('text', this.qry_value + ' - ' + this.qry_show_value);

			if(this.options[Field.PROPERTY_VALUE_COLOR])
				input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			var div = new Element('div.gridMinWidth', {
				id: this.frmId + '_' + this.fldId + '_' + grid_index
			});
			
			if(this.options[Field.PROPERTY_REQUIRED])
				div.addClass('gridCellRequired');
			
			if(Number.from(this.options[Field.PROPERTY_COL_WIDTH]))
				div.setStyle('width', Number.from(this.options[Field.PROPERTY_COL_WIDTH]));
			
			input.inject(div);
			div.inject(this.content);
			
			div.store(Field.STORE_KEY_FIELD, this);
			
			this.addTranslationIcon(new Element('input', {value: input.get('text')}), div);
			
			if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
				input.addClass('validate["%Input.customRequiredChecker"]');
				input.set('forceReq', 'true');
				$('frmData').formChecker.register(input);
			}			
			
			return;
		}
		
		
		//INPUT
		
		var input = new Element('input', {
			fld_id: this.frmId + '_' + this.fldId + '_' + grid_index,
			type: 'text'
		});
		
		if(this.xml.getAttribute("length"))
			input.set("maxlength", this.xml.getAttribute("length"));
		else
			input.set("maxlength", Input.MAX_LENGTH);
		
		if(this.row_xml.getAttribute(Field.PROPERTY_VALUE)) {
			input.set('value', this.row_xml.getAttribute(Field.PROPERTY_VALUE));
		}
		
		if(this.options.valueType == "S") {
			//Nothing
		} else if(this.options.valueType == "N") {
			input.set('attLabel', this.xml.getAttribute("attLabel"));
			Numeric.setNumeric(input);
		} else if(this.options.valueType == "D") {
			
			input.addClass('datePicker');
			input.addClass('dateInput');
		}
		
		if(this.options[Field.PROPERTY_READONLY]) {
			input.set('readonly', 'readonly');
			input.addClass('readonly');
		}
		
		if(this.options[Field.PROPERTY_DISABLED])
			input.set('disabled', 'disabled');
		/*
		if(this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			input.addClass('input-as-text');
			
			if(!this.options[Field.PROPERTY_READONLY])
				input.set('readonly', 'readonly');
		}
		*/
		
		if(this.options[Field.PROPERTY_REQUIRED]) {		
			
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				if(this.options.valueType == "D")
					input.addClass('validate["required","target:' + this.frmId + '_' + this.fldId + '_' + grid_index + '_d"]');
				else if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED])
					input.addClass('validate["%Input.customRequiredChecker"]');
				else
					input.addClass('validate["required"]');
				
				if($('frmData').formChecker)
					$('frmData').formChecker.register(input);
			}
			
			if(this.form.options[Form.PROPERTY_FORM_HIDDEN] == "true") {
				input.set('disabledCheck', 'true');
			}
			
		} else if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED] && this.options.valueType != "D") {
			
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				input.addClass('validate["%Input.customRequiredChecker"]');
				if($('frmData').formChecker)
					$('frmData').formChecker.register(input);
			}
			
			if(this.form.options[Form.PROPERTY_FORM_HIDDEN] == "true") {
				input.set('disabledCheck', 'true');
			}
		}
		
		if(this.options[Field.PROPERTY_TOOLTIP])
			input.tooltip(this.options[Field.PROPERTY_TOOLTIP], { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
		
		if(this.xml.getAttribute('regExp')) {
			
			input.addEvent('blur', function() {
				
				var value = input.get('value');
				if(input.get('empty_mask')) {
					//if(input.get('empty_mask') == str) {
					if(input.get('empty_mask') == value) {
						value = "";
					} else if(input.get('unmasked_value')) {
						value = input.get('unmasked_value');
					}
				}
				 
				var result = Generic.testRegExp(value, this.xml.getAttribute('regExp'));
				
				if(!result) {
					if(this.options[Field.PROPERTY_REGEXP_MESSAGE])
						showMessage(this.options[Field.PROPERTY_REGEXP_MESSAGE]);
					else
						showMessage(MSG_INVALID_REG_EXP);
					
					input.set('value', '');
				   	if(input.get('unmasked_value'))
				   		input.set('unmasked_value', '');

					input.select();
				}
			}.bind(this));
		}
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		var div = new Element('div.gridMinWidth', {
			id: this.frmId + '_' + this.fldId + '_' + grid_index
		});
		
		if(this.options[Field.PROPERTY_REQUIRED] && !this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			div.addClass('gridCellRequired');
		
		if(Number.from(this.options[Field.PROPERTY_COL_WIDTH]))
			div.setStyle('width', Number.from(this.options[Field.PROPERTY_COL_WIDTH]));
		
		
		var input_width;
		
		if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0) {
			input_width = Number.from(this.options[Field.PROPERTY_SIZE]);
			input.setStyle('width', input_width);
		} else if(this.options.valueType != "D" && !this.qryId) {
			//input.setStyle('width', '100%');
			var w = Number.from(div.getStyle('width')) - 11;
			if(w > 0) {
				input.setStyle('width', w);
				input_width = w;
			}
		}
		
		input.inject(div);
		div.inject(this.content);
		
		div.store(Field.STORE_KEY_FIELD, this);
		
		div.addClass('AJAXfield');
		
		if(this.xml.getAttribute("forceSync"))
			div.set(SynchronizeFields.SYNC_FAILED, 'true');
		
		if(this.xml.getAttribute('mask')) {
			//Setearle la m�scara al input XXX:Verificar
			if(!this.options[Field.PROPERTY_READONLY]) {
				//this.mask = this.xml.getAttribute('mask');
				this.mask = new Element('div').set('html', this.xml.getAttribute('mask')).get('html');
				MaskedInput.setMask(input, this.mask);
			}
		}
		
		//onchange
//		if(this.xml.getAttribute(Field.FUNC_CHANGE) && !window.editionMode) {
		if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
			var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
			//var target = this;
			if (fn_change) {
				input.addEvent('change', function() {
					if(!this.fromModal && this.qryId) {
						
						var new_value = this.content.getElement('input').get('value');
						this.qry_value = '';
						this.qry_show_value = undefined;
						if(this.options[Field.PROPERTY_STORE_MODAL_QUERY_RESULT]) {
							this.qry_value = new_value;
						} else {
							this.qry_show_value = new_value;
						} 
						
						if(!new_value) {
							//TODO: Se comenta, verificar que no es necesario
							//SynchronizeFields.toSync(this.content, this.getValue());							
							//fn_change();
							try {
								fn_change(new ApiaField(this, true));
							} catch(error) {}
							
							if (this.hasBinding && !this.serverEvent)
								this.executeAjaxBinding();
							
							this.checkTranslationIconVisibility(input);
							
							return;
						}
						
						var target = this;
						
						new Request({
							url: 'apia.execution.FormAction.run?action=checkModalValue&frmId=' +  this.frmId.split('_')[1] + '&frmParent=' + this.frmId.split('_')[0] + '&fldId=' + this.fldId + '&qryId=' + this.qryId + '&value=' + new_value + '&attId=' + this.attId +   '&index=' + grid_index + '&forGrid=true' + TAB_ID_REQUEST,
							onSuccess: function(responseText, responseXML) {
						    	//AJAX exitoso
						    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
						    		
						    		//Errorres y mensajes
						    		checkErrors(responseXML)
						    		
						    		//Control para xml de ie
						    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
						    		
						    		if(response.tagName == 'result' && response.getAttribute('success')) {
						    			target.qry_value = response.childNodes[0].getAttribute('value');
						    			target.qry_show_value = response.childNodes[0].getAttribute('show_value');
						    			if(target.options[Field.PROPERTY_STORE_MODAL_QUERY_RESULT])
						    				target.content.getElement('input').set('value', target.qry_value);
						    			else
						    				target.content.getElement('input').set('value', target.qry_show_value);
						    		} else {
						    			target.qry_value = '';
						    			target.qry_show_value = '';
						    			target.content.getElement('input').set('value', '');
						    			showMessage(MSG_VAL_NOT_FOUND);
						    		}					    		
						    	} else {
						    		target.qry_value = '';
					    			target.qry_show_value = '';
					    			target.content.getElement('input').set('value', '');
					    			showMessage(MSG_VAL_NOT_FOUND);
						    	}
						    	
						    	//SynchronizeFields.toSync(target.content, target.getValue());
						    	//fn_change();
						    	try {
						    		fn_change(new ApiaField(target, true));
						    	} catch(error) {}
						    	
						    	if (target.hasBinding && !target.serverEvent) {
						    		
						    		//TODO: verificar si se debe sincronizar el input (ya deber�a haberlo hecho al ejecutar el fn_change)
						    		
									//Forzar una funci�n contra el server
//									var frmParent = target.frmId.split('_')[0];
//									var frmId = target.frmId.split('_')[1];
//									SynchronizeFields.syncJAVAexec(function() {
//										var index = target.index;
//										$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + target.fldId + '&evtId=1&attId=' + target.attId + '&index=' + index  + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
//										$('frmData').fireEvent('submit');
//									});
						    		target.executeAjaxBinding();

								}
						    	
						    	target.checkTranslationIconVisibility(input);
						    	
							},
							onFailure: function(responseText, responseXML) {
								target.qry_value = '';
				    			target.qry_show_value = '';
				    			target.content.getElement('input').set('value', '');
				    			showMessage(MSG_VAL_NOT_FOUND);
				    			

				    			//SynchronizeFields.toSync(target.content, target.getValue());
				    			//fn_change();
				    			try {
				    				fn_change(new ApiaField(target, true));
				    			} catch(error) {}
				    			
				    			if (target.hasBinding && !target.serverEvent) {
				    				
				    				//TODO: verificar si se debe sincronizar el input (ya deber�a haberlo hecho al ejecutar el fn_change)
				    				
									//Forzar una funci�n contra el server
//									var frmParent = target.frmId.split('_')[0];
//									var frmId = target.frmId.split('_')[1];
//									SynchronizeFields.syncJAVAexec(function() {
//										var index = target.index;
//										$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + target.fldId + '&evtId=1&attId=' + target.attId + '&index=' + index  + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
//										$('frmData').fireEvent('submit');
//									});
				    				target.executeAjaxBinding();
								}
				    			
				    			target.checkTranslationIconVisibility(input);
							}
						}).send();
						
					} else {
						//SynchronizeFields.preJSexec(this.content);			
						//fn_change();
						try {
							fn_change(new ApiaField(this, true));
						} catch(error) {}
						//SynchronizeFields.posJSexec(this.content);
						
						if (this.hasBinding && !this.serverEvent) {
		    				
		    				//TODO: verificar si se debe sincronizar el input (ya deber�a haberlo hecho al ejecutar el fn_change)
		    				
							//Forzar una funci�n contra el server
//							var frmParent = this.frmId.split('_')[0];
//							var frmId = this.frmId.split('_')[1];
//							SynchronizeFields.syncJAVAexec(function() {
//								var index = this.index;
//								$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + target.fldId + '&evtId=1&attId=' + target.attId + '&index=' + index  + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
//								$('frmData').fireEvent('submit');
//							});
							this.executeAjaxBinding();
						}
						
						this.checkTranslationIconVisibility(input);
					}
				}.bind(this));
			} else {
				if(console) console.error('NO SE ENCUENTRA CLASE GENERADA: ' + target.xml.getAttribute(Field.FUNC_CHANGE));
				
				input.addEvent('change', function() {
					SynchronizeFields.toSync(div, this.getValue());
					
					if (this.hasBinding)
						this.executeAjaxBinding();
					
					this.checkTranslationIconVisibility(input);
					
				}.bind(this));
			}
		} else {
			input.addEvent('change', function() {
				
				if(!this.fromModal && this.qryId) {
					
					var new_value = this.content.getElement('input').get('value');
					this.qry_value = '';
					this.qry_show_value = undefined;
					if(this.options[Field.PROPERTY_STORE_MODAL_QUERY_RESULT]) {
						this.qry_value = new_value;
					} else {
						this.qry_show_value = new_value;
					} 
					
					if(!new_value) {
						//TODO: Se comenta, verificar que no es necesario
						//SynchronizeFields.toSync(this.content, this.getValue());							
						//fn_change();
						SynchronizeFields.toSync(div, this.getValue());
						
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
						
						this.checkTranslationIconVisibility(input);
						
						return;
					}
					
					var target = this;
					
					new Request({
						url: 'apia.execution.FormAction.run?action=checkModalValue&frmId=' +  this.frmId.split('_')[1] + '&frmParent=' + this.frmId.split('_')[0] + '&fldId=' + this.fldId + '&qryId=' + this.qryId + '&value=' + new_value + '&attId=' + this.attId + '&index=' + grid_index + '&forGrid=true' + TAB_ID_REQUEST,
						onSuccess: function(responseText, responseXML) {
					    	//AJAX exitoso
					    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
					    		
					    		//Errorres y mensajes
					    		checkErrors(responseXML)
					    		
					    		//Control para xml de ie
					    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
					    		
					    		if(response.tagName == 'result' && response.getAttribute('success')) {
					    			target.qry_value = response.childNodes[0].getAttribute('value');
					    			target.qry_show_value = response.childNodes[0].getAttribute('show_value');
					    			if(target.options[Field.PROPERTY_STORE_MODAL_QUERY_RESULT])
					    				target.content.getElement('input').set('value', target.qry_value);
					    			else
					    				target.content.getElement('input').set('value', target.qry_show_value);
					    		} else {
					    			target.qry_value = '';
					    			target.qry_show_value = '';
					    			target.content.getElement('input').set('value', '');
					    			showMessage(MSG_VAL_NOT_FOUND);
					    		}
					    	} else {
					    		target.qry_value = '';
				    			target.qry_show_value = '';
				    			target.content.getElement('input').set('value', '');
				    			showMessage(MSG_VAL_NOT_FOUND);
					    	}
					    	
					    	SynchronizeFields.toSync(div, target.getValue());
					    	
					    	if (target.hasBinding) {
								//Forzar una funci�n contra el server
//								var frmParent = target.frmId.split('_')[0];
//								var frmId = target.frmId.split('_')[1];
//								SynchronizeFields.syncJAVAexec(function() {
//									$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + target.fldId + '&evtId=1&attId=' + target.attId + '&index=' + target.index  + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
//									$('frmData').fireEvent('submit');
//								});
					    		target.executeAjaxBinding();
							}
					    	
					    	target.checkTranslationIconVisibility(input);
					    	
						},
						onFailure: function(responseText, responseXML) {
							target.qry_value = '';
			    			target.qry_show_value = '';
			    			target.content.getElement('input').set('value', '');
			    			showMessage(MSG_VAL_NOT_FOUND);
			    			

			    			SynchronizeFields.toSync(div, target.getValue());
			    			
			    			if (target.hasBinding) {
								//Forzar una funci�n contra el server
//								var frmParent = target.frmId.split('_')[0];
//								var frmId = target.frmId.split('_')[1];
//								SynchronizeFields.syncJAVAexec(function() {
//									$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + target.fldId + '&evtId=1&attId=' + target.attId + '&index=' + target.index  + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
//									$('frmData').fireEvent('submit');
//								});
			    				target.executeAjaxBinding();
							}
			    			
			    			target.checkTranslationIconVisibility(input);
						}
					}).send();
					
				} else {
					SynchronizeFields.toSync(div, this.getValue());
					
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
					
					this.checkTranslationIconVisibility(input);
				}
			}.bind(this));
		}
		
		//-Modal
		if(this.qryId) {
			
			if(!input_width)
				input_width = Number.from(Generic.getHiddenWidth(input));
			
			var inp_width;
//			if(this.options[Field.PROPERTY_REQUIRED])
//				inp_width = input_width - 27;
//			else
//				inp_width = input_width - 23;
			if(this.options[Field.PROPERTY_REQUIRED])
				inp_width = input_width - 4;
			else
				inp_width = input_width;
			
			if(inp_width >= 0)
				input.setStyle('width', inp_width);
			
			this.qry_value = this.row_xml.getAttribute(Field.PROPERTY_VALUE);
			if(this.options[Field.PROPERTY_STORE_MODAL_QUERY_RESULT]) {
				this.qry_show_value = undefined;
			} else {
				this.qry_show_value = this.row_xml.getAttribute("qry_show_value");
				input.set('value', this.qry_show_value);
			}
			
			var mdl = new Element('div.mdl-btn').inject(div);
			
			if(!(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0)) {
				//No tiene propiedad ancho
				if(this.options[Field.PROPERTY_REQUIRED])
					inp_width =  Generic.getHiddenWidth(div) - 27;
				else
					inp_width =  Generic.getHiddenWidth(div) - 23;
				input.setStyle('width', inp_width);
			}
			
			mdl.addEvent('click', function(e) {
				
				if(!this.options[Field.PROPERTY_DISABLED]) {
				
					var target = this;
				
					ModalController.openWinModal(CONTEXT + '/apia.query.ModalAction.run?action=init&query=' + this.qryId + TAB_ID_REQUEST, 700, 462, null, null, true).addEvent('confirm', function(selected_index) {
						var request = new Request({
							method: 'post',
							url: CONTEXT + "/apia.query.ModalAction.run?action=getValues" + TAB_ID_REQUEST,
							onComplete: function(resText, resXml) {
								
								if(resXml) {
									var cells = resXml.getElementsByTagName('cell');
									
									if(cells) {
										target.qry_value = cells[0].textContent || cells[0].text;
										var new_value = target.qry_value;
										
										if(target.options[Field.PROPERTY_STORE_MODAL_QUERY_RESULT]) {
											target.qry_show_value = undefined;
										} else {
											target.qry_show_value = Generic.htmlDecode(cells[1].textContent || cells[1].text);
											new_value = target.qry_show_value;
										}
										
										//TODO: Setear valor y valor a guardar al input
										target.fromModal = true;
										//target.content.getElement('input').set('value', cells[1].textContent).fireEvent('change');
										target.content.getElement('input').set('value', new_value).fireEvent('change');
										target.fromModal = false;
										
										if(target.xml.getAttribute(Field.FUNC_MODAL_RETURN)) {
											var fn_modal_return = window[target.xml.getAttribute(Field.FUNC_MODAL_RETURN)];
											if(fn_modal_return) {
												//Disparar onModalReturn
												lastModalReturn = new Array();
												for(var i = 0; i < cells.length; i++) {
													var txt = cells[i].textContent || cells[i].text;
													txt = Generic.htmlDecode(txt);
													lastModalReturn.push(txt);
												}
												//fn_modal_return();
												try {
													fn_modal_return(new ApiaField(target, true));
												} catch(error) {}
											}
										}
									}
								}
							}
						}).send('id=' + selected_index);
					});
				}
			}.bind(this));
		} else if(this.options.valueType != "D") {
			//Si no es modal
			
			//TRADUCCIONES
			if(!input_width)
				input_width = Number.from(Generic.getHiddenWidth(input));
			
			var inp_width;
			
			if(this.options[Field.PROPERTY_REQUIRED])
				inp_width = input_width - 4;
			else
				inp_width = input_width;
			
			if(inp_width >= 0)
				input.setStyle('width', inp_width);
			
			//this.langIco = new Element('div.langIco').inject(div);
			
			if(!(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0)) {
				//No tiene propiedad ancho
				if(this.options[Field.PROPERTY_REQUIRED])
					inp_width =  Generic.getHiddenWidth(div) - 27;
				else
					inp_width =  Generic.getHiddenWidth(div) - 23;
				input.setStyle('width', inp_width);
			}
			
			this.addTranslationIcon(input, div)
		}
		
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
		
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var fieldContainer = this.parsePrintXMLposition(formContainer);
			
			var label = new Element('label').appendText(this.xml.getAttribute("attLabel") + ':');
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			label.inject(fieldContainer);
			
			var input = new Element('span');
			if(!this.qryId || this.qry_show_value == undefined) {
				var html_input = this.content.getElement('input');
				if(html_input)
					input.set('text', html_input.get('value'));
				else
					input.set('text', this.xml.getAttribute(Field.PROPERTY_VALUE));
			} else {
				input.set('text', this.qry_value + ' - ' + this.qry_show_value);
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
			if(!this.qryId || this.qry_show_value == undefined) {
				var html_input = this.content.getElement('input');
				if(html_input)
					input.set('html', html_input.get('value'));
				if(this.to_trans_value != undefined)
					input.set('html', this.to_trans_value);
				else
					input.set('html', this.row_xml.getAttribute(Field.PROPERTY_VALUE));
			} else {
				input.set('html', this.qry_value + ' - ' + this.qry_show_value);
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
		if(!this.qryId || this.qry_show_value == undefined) {
			var html_input = this.content.getElement('input');
			if(html_input)
				input.set('html', html_input.get('value'));
			else
				input.set('html', this.row_xml.getAttribute(Field.PROPERTY_VALUE));
		} else {
			input.set('html', this.qry_value + ' - ' + this.qry_show_value);
		}
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		input.inject(a);
		
		return a.get('html');
	},
	
	showFormListener: function() {
		//var input = this.content.getChildren('input')[0] || this.content.getChildren('div')[0].getChildren('input')[0];
		var input = this.content.getElement('input');
		/*
		if(this.content.getChildren('input').length)
			input = this.content.getElement('input');
		else
			input = this.content.getElement('div').getElement('input');
		*/
		if(input)
			input.erase('disabledCheck');
		
	},
	
	hideFormListener: function() {
		//var input = this.content.getChildren('input')[0] || this.content.getChildren('div')[0].getChildren('input')[0];
		//var input;
		var input = this.content.getElement('input');
		/*
		if(this.content.getChildren('input').length)
			input = this.content.getElement('input');
		else
			input = this.content.getElement('div').getElement('input');
		*/
		if(input)
			input.set('disabledCheck', 'true');
	},
	
	showTranslationModal: function(lang_id) {
		
		var ele = this;
		
		new Request({
			url: 'apia.execution.FormAction.run?action=getFieldTranslations&frmId=' +  this.frmId.split('_')[1] + '&frmParent=' + this.frmId.split('_')[0] + '&fldId=' + this.fldId +'&attId=' + this.attId + '&index=' + this.index + '&langId=' + lang_id + TAB_ID_REQUEST,
			onSuccess: function(responseText, responseXML) {
				
		    	//AJAX exitoso
		    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
		    		
		    		//Errorres y mensajes
		    		checkErrors(responseXML)
		    		
		    		//Control para xml de ie
		    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
		    		
		    		if(response.getAttribute('success')) {
		    			
		    			//Clonar el elemento base
		    			var new_ele = new Field({}, ele.frmId, ele.fldId, null, ele.attId);
		    			new_ele.lang_id = lang_id;
		    			new_ele.index  = ele.index;
		    			new_ele.force_synchronous = true;
		    			
		    			//Quitar referencias al viejo elemento
		    			
		    			//Agregar a document.body
		    			
		    			var translation = response.childNodes[0].childNodes[0].textContent || response.childNodes[0].childNodes[0].text; //IE8
		    			
		    			var data = {};
		    			data.url = CONTEXT + '/page/generic/emptyTranslation.jsp?' + TAB_ID_REQUEST;
		    			data.content = new Element('div.fieldGroup').setStyle('margin', 0);
		    			
		    			new Element('div.title', {text: TIT_TRANSLTATION}).inject(data.content);
		    			new Element('br').inject(data.content);
		    			
		    			var leftField = new Element('div.field.fieldHalf').inject(data.content);
		    					    			
		    			var label = new Element('label').appendText(ele.xml.getAttribute("attLabel") + ':');
		    			if(ele.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', ele.options[Field.PROPERTY_FONT_COLOR]);
		    			label.inject(leftField);
		    			
		    			var input = new Element('span');
		    			
	    				var html_input = ele.content.getElement('input');
	    				if(html_input)
	    					input.set('text', html_input.get('value'));
	    				else
	    					input.set('text', ele.xml.getAttribute(Field.PROPERTY_VALUE));
		    			
		    			if(ele.options[Field.PROPERTY_VALUE_COLOR])
		    				input.setStyle('color', ele.options[Field.PROPERTY_VALUE_COLOR]);
		    			
		    			input.inject(leftField);
		    			
		    			var rightField = new Element('div.field.fieldHalf').inject(data.content);
		    			
//		    			var value = ele.apijs_getFieldValue();
//		    			if(typeOf(value) == 'array') {
//		    				if(value.length == 2)
//		    					value = value[1];
//		    				else
//		    					value = value[0];
//		    			}
		    			
//		    			new Element('label', {text: this.xml.getAttribute("attLabel") + ':'}).inject(leftField);
//		    			new Element('input', {type: 'text', value: value}).inject(leftField);
		    			
		    			new Element('label', {text: ele.form.langs[lang_id] + ':'}).inject(rightField);
		    			var inp = new Element('input.AJAXfield', {
		    				type: 'text',
		    				value: translation ? translation : '',
		    				id: ele.frmId + '_' + ele.fldId + (ele.index ? '_' + ele.index : '') + '_tradField',
		    				maxlength: Input.MAX_LENGTH
		    			}).inject(rightField);
		    			
		    			inp.store(Field.STORE_KEY_FIELD, new_ele); //Referenciar al nuevo ele
		    			
//		    			ModalController.openContentModal(data, 700, 180).addEvent('confirm', function() {
//		    				ele.lang_id = lang_id;
//		    				SynchronizeFields.toSync(ele.content, inp.get('value'));
//		    				ele.lang_id = undefined;
//		    			}.bind(this));
		    			
		    			//Esto es para mostrar un bloqueador mientras se sincroniza
		    			
//		    			inp.changeTranslation = function() {
		    			inp.addEvent('change', function() {
//		    				ele.lang_id = lang_id;
//		    				ele.formReadOnly = ele.form.readOnly;
//		    				ele.form.readOnly = false; //Restriccion de sincronizacion para campos
//		    				SynchronizeFields.toSync(ele.content, inp.get('value'));
		    				
//		    				//Firefox pierde stores
//		    				inp.store(Field.STORE_KEY_FIELD, new_ele);
		    				
		    				new_ele.has_changed = true;
		    				
//		    				SynchronizeFields.toSync(inp, inp.get('value'));
		    			});
		    			
		    			inp.startSyncTraduction = function(callback_fnc) {
		    				
		    				if(new_ele.has_changed) {
		    					//Firefox pierde stores
			    				inp.store(Field.STORE_KEY_FIELD, new_ele);
			    				
		    					SynchronizeFields.toSync(inp, inp.get('value'));
		    				}
		    				
		    				SynchronizeFields.syncJAVAexec(function() {
//		    					ele.lang_id = undefined;
//		    					ele.form.readOnly = ele.formReadOnly;
		    					
		    					//Agregar el elemento al documentbody por si no quedo sincronizado, para que el submit vuelva a intentarlo
		    					var prev_trad = $(inp.get('id'));
		    					if(prev_trad) prev_trad.dispose();
		    					inp.setStyle('display', 'none');
		    					inp.inject($(document.body));
		    					
		    					ele.translations[lang_id] = (String.trim(inp.get('value')) != '');
		    					
		    					ele.refreshTranslationMenu();
		    					
		    					if(callback_fnc)
		    						callback_fnc();
		    				}, true);
		    			};
		    			
		    			ModalController.openContentModal(data, 700, 180);
		    			
		    			//Esto es para la demo
//		    			ModalController.openContentModal(data, 700, 180).addEvent('beforeConfirm', function() {
//		    				ele.lang_id = lang_id;
//		    				SynchronizeFields.toSync(ele.content, inp.get('value'));
//		    				ele.lang_id = undefined;
//		    			}.bind(this));
		    		}
		    	}
			}
		}).send();
	}
});

Input.customRequiredChecker = function(el) {
	var field = el.getParent().retrieve(Field.STORE_KEY_FIELD);
	
	if(field.options[Field.PROPERTY_REQUIRED] && el && !el.get('value')) {
		el.errors.push("Este campo es requerido.");
		return false;
	}
	
	if(field.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
		for(var lang_id in field.form.langs) {
			if(!field.translations[lang_id]) {
				el.errors.push('El idioma ' + field.form.langs[lang_id] + ' es requerido.');
				return false;
			}
		}		
	}
	
	return true;
}

Input.MAX_LENGTH = 255;