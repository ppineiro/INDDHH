var Area = new Class({

	Extends: Field,
	
	translations: [],
	
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
		//this.options[Field.PROPERTY_ROWSPAN]			= null;
		this.options[Field.PROPERTY_ROWS]				= null;
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
		this.options[Field.PROPERTY_TRANSLATION_REQUIRED]		= null;
	},

	booleanOptions: [Field.PROPERTY_INPUT_AS_TEXT, Field.PROPERTY_REQUIRED, Field.PROPERTY_DISABLED, Field.PROPERTY_READONLY, Field.PROPERTY_VISIBILITY_HIDDEN, Field.PROPERTY_TRANSLATION_REQUIRED],
		
	getValue: function() {
		var text;
		var ele = this.content.getElement('textarea');
		if(ele) {
			text = ele.get('value');
		} else {
			//Solo lectura
			if(Browser.ie8) {
				text = this.content.getElement('div.monitor-area').get('html').replace(/<br>/gi,"\n").replace(/&lt;/gi,"<").replace(/&gt;/gi,">");
			} else {
				text = this.content.getElement('div.monitor-area').get('text');
			}
		}
		
		//var text = this.content.getElements('textarea')[0].get('value');
		text.replace('\\', '%5C');
		var res = new Array();
		var i = 0;
		while(text.length > 255) {
			res.push(text.substr(0, 255));
			text = text.substr(255);
		}
		if(text.length > 0)
			res.push(text);
		
		return res;
	},
	
	/**
	 * Retorna el valor para la APIJS
	 */
	apijs_getFieldValue: function() {
		return this.content.getElement('textarea').get('value');
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_setFieldValue: function(value) {
		if(this.form.readOnly) return;
		if(typeOf(value) == 'array') {
			var text = "";
			for(var i = 0; i < value.length; i++)
				text += value[i];
			this.content.getElement('textarea').set('value', text);
		} else {
			this.content.getElement('textarea').set('value', value);
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
		var ele = this.content.getElement('textarea');
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
		} else if(prp_name == Field.PROPERTY_INPUT_AS_TEXT) {
			
			if(console) console.error("[" +this.frmId + "_" + this.fldId + "] ERROR: INPUT_AS_TEXT not supported.")
			
		} else if(prp_name == Field.PROPERTY_SIZE) {

			this.options[Field.PROPERTY_SIZE] = Number.from(prp_value);
			var textarea = this.content.getElement('textarea')
			if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0) {				
				if(textarea)
					textarea.setStyle('width', this.options[Field.PROPERTY_SIZE]);
			} else {
				if(textarea)
					textarea.setStyle('width', '98%');
			}
			
		} else if(prp_name == Field.PROPERTY_ROWS) {
			var textarea = this.content.getElement('textarea')
			if(textarea) {
				this.options[Field.PROPERTY_ROWS] = Number.from(prp_value);
				var area_rows = "3";
				if(this.options[Field.PROPERTY_ROWS]) {
					try {
						area_rows = Number.from(this.options[Field.PROPERTY_ROWS]);
					} catch (error) {}
				}
				textarea.set('rows', area_rows);
			}
			
		} else if(prp_name == Field.PROPERTY_INPUT_AS_TEXT) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_FONT_COLOR) {
			this.content.getElement('label').setStyle('color', prp_value);
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_TOOLTIP) {
			this.content.getElement('label').tooltip(prp_value, { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
			this.options[Field.PROPERTY_TOOLTIP] = prp_value;
		} else if(prp_name == Field.PROPERTY_VALUE_COLOR) {
			this.content.getElement('textarea').setStyle('color', prp_value);
			this.options[Field.PROPERTY_VALUE_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_REQUIRED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_REQUIRED] == false) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					var textarea = this.content.getElement('textarea');
					if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
						if(!textarea.hasClass('validate["%Area.customRequiredChecker"]')) {
							textarea.addClass('validate["%Area.customRequiredChecker"]');
							$('frmData').formChecker.register(textarea);
						}
					} else {
						textarea.addClass('validate["required"]');
						$('frmData').formChecker.register(textarea);
					}
					
					this.content.addClass('required');
					
//					this.content.getElement('textarea').addClass('validate["required"]');
//					this.content.addClass('required');
//					$('frmData').formChecker.register(this.content.getElement('textarea'));
				}
				this.options[Field.PROPERTY_REQUIRED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_REQUIRED]) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					
					var textarea = this.content.getElement('textarea');
					
					if(!this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
						textarea.removeClass('validate["required"]');
						$('frmData').formChecker.dispose(textarea);
					}
					
					this.content.removeClass('required');
					
//					this.content.getElement('textarea').removeClass('validate["required"]');
//					this.content.removeClass('required');
//					$('frmData').formChecker.dispose(this.content.getElement('textarea'));
				}
				this.options[Field.PROPERTY_REQUIRED] = false;
			}
		} else if(prp_name == Field.PROPERTY_DISABLED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_DISABLED] == false) {
				this.content.getElement('textarea').set('disabled', 'disabled');
				this.options[Field.PROPERTY_DISABLED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_DISABLED]) {
				this.content.getElement('textarea').set('disabled', false);
				this.options[Field.PROPERTY_DISABLED] = false;
			}
		} else if(prp_name == Field.PROPERTY_TRANSIENT) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_READONLY) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_READONLY] == false) {
				this.content.getElement('textarea')
					.set('readonly', 'readonly')
					.addClass('readonly');
				this.options[Field.PROPERTY_READONLY] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_READONLY]) {
				this.content.getElement('textarea')
					.set('readonly', false)
					.removeClass('readonly');
				this.options[Field.PROPERTY_READONLY] = false;
			}
		} else if(prp_name == Field.PROPERTY_VISIBILITY_HIDDEN) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN] == false) {
				this.content.addClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = true;
				//Si es requerido, desregistrarlo
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
//					this.content.getElement('textarea').removeClass('validate["required"]');
//					this.content.removeClass('required');
//					$('frmData').formChecker.dispose(this.content.getElement('textarea'));
					
					var textarea = this.content.getElement('textarea');
					this.content.removeClass('required');
					
					if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
						if(textarea.hasClass('validate["%Area.customRequiredChecker"]')) {
							textarea.removeClass('validate["%Area.customRequiredChecker"]');
							$('frmData').formChecker.dispose(textarea);
						}
					} else {
						textarea.removeClass('validate["required"]');
						$('frmData').formChecker.dispose(textarea);
					}
				}
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				this.content.removeClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = false;
				//Verificar si era requerido
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
//					this.content.getElement('textarea').addClass('validate["required"]');
//					this.content.addClass('required');
//					$('frmData').formChecker.register(this.content.getElement('textarea'));
					
					var textarea = this.content.getElement('textarea');
					this.content.addClass('required');
					
					if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
						if(!textarea.hasClass('validate["%Area.customRequiredChecker"]')) {
							textarea.addClass('validate["%Area.customRequiredChecker"]');
							$('frmData').formChecker.register(textarea);
						}
					} else {
						textarea.addClass('validate["required"]');
						$('frmData').formChecker.register(textarea);
					}
				}
			}
		} else if(prp_name == Field.PROPERTY_DISPLAY_NONE) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_ROWSPAN) {
			//NOT SUPPORTED
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
	 * Parsea el xml
	 */
	parseXML: function() {
		
		this.parseXMLposition();
		
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
		
		//TODO: Field_PROPERTY_COL_WIDTH -- SOLO EN GRILLAS
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		if(this.xml.getAttribute("trad"))
			this.translations = JSON.decode(this.xml.getAttribute("trad"));
		
		//Si estoy en monitor, solo coloco el texto
		if(this.form.readOnly) {
			if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
				this.content.addClass('visibility-hidden');
				
			var label = new Element('label.monitor-lbl').appendText(this.xml.getAttribute("attLabel") + ':');
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			label.inject(this.content);
			
			var input = new Element('div.monitor-area').setStyle('white-space', 'pre-wrap');
			if(this.xml.getAttribute(Field.PROPERTY_VALUE))
				input.set('text', this.xml.getAttribute(Field.PROPERTY_VALUE));
			
			if(this.options[Field.PROPERTY_SIZE])
				input.setStyle('width', Number.from(this.options[Field.PROPERTY_SIZE]));
			else
				input.setStyle('width', '98%');
			
			if(this.options[Field.PROPERTY_REQUIRED])
				this.content.addClass('required');
			
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			input.inject(this.content);
			
			this.addTranslationIcon(new Element('input', {value: input.get('text')}));
			
			if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
				input.addClass('validate["%Area.customRequiredChecker"]');
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
		
		//TEXTAREA
		
		var textarea = new Element('textarea', {
			fld_id: this.frmId + "_" + this.fldId,
			type: 'text'
		});
		
		if(this.xml.getAttribute("length"))
			textarea.set("maxlength", this.xml.getAttribute("length"));
		
		if(this.xml.getAttribute(Field.PROPERTY_VALUE))
			textarea.set('value', this.xml.getAttribute(Field.PROPERTY_VALUE));
		
		if(this.options[Field.PROPERTY_SIZE])
			textarea.setStyle('width', Number.from(this.options[Field.PROPERTY_SIZE]));
		else
			textarea.setStyle('width', '98%');
		
		if(this.options[Field.PROPERTY_DISABLED])
			textarea.set('disabled', 'disabled');
		
		if(this.options[Field.PROPERTY_READONLY]) {
			textarea.set('readonly', 'readonly');
			textarea.addClass('readonly');
		}
		
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			if(this.options[Field.PROPERTY_REQUIRED]) {
				if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED])
					textarea.addClass('validate["%Area.customRequiredChecker"]');
				else
					textarea.addClass('validate["required"]');
				this.content.addClass('required');
				$('frmData').formChecker.register(textarea);
			} else if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
				textarea.addClass('validate["%Area.customRequiredChecker"]');
				this.content.addClass('required');
				$('frmData').formChecker.register(textarea);
			}
		}

		var area_rows = "3";
		//if(this.options[Field.PROPERTY_ROWSPAN]) {
		if(this.options[Field.PROPERTY_ROWS]) {
			try {
				//area_rows = Number.from(this.options[Field.PROPERTY_ROWSPAN]);
				area_rows = Number.from(this.options[Field.PROPERTY_ROWS]);
			} catch (error) {}
		}
		textarea.set('rows', area_rows);
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			textarea.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		if(this.options[Field.PROPERTY_INPUT_AS_TEXT]) {
			textarea.addClass('input-as-text');
			if(!this.options[Field.PROPERTY_READONLY])
				textarea.set('readonly', 'readonly');
		}
		
		label.inject(this.content);
		textarea.inject(this.content);
		
		this.content.addClass('AJAXfield');
		
		if(this.xml.getAttribute("forceSync"))
			this.content.set(SynchronizeFields.SYNC_FAILED, 'true');
		
		if(this.options[Field.PROPERTY_TOOLTIP])
			label.tooltip(this.options[Field.PROPERTY_TOOLTIP], { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
		
		//onchange
//		if(this.xml.getAttribute(Field.FUNC_CHANGE) && !window.editionMode) {
		if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
			var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
			var target = this;
			if (fn_change) {
				textarea.addEvent('change', function() {
					try {
						fn_change(new ApiaField(target));
					} catch(error) {}
					
					target.checkTranslationIconVisibility(textarea);
				});
			} else {
				
				if(console) console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
				
				textarea.addEvent('change', function() {
					SynchronizeFields.toSync(this.content, this.getValue());
					
					this.checkTranslationIconVisibility(textarea);
				}.bind(this));
			}
		} else {
			textarea.addEvent('change', function() {
				SynchronizeFields.toSync(this.content, this.getValue());
				
				this.checkTranslationIconVisibility(textarea);
			}.bind(this));
		}
		
		//TRADUCCION
		this.addTranslationIcon(textarea);
		
		if(Browser.firefox) {
			//Firefox no dispara evento onchange al hacer drop. Deshabilitamos el drop hasta que corrijan bug 501152
			textarea.addEventListener('drop', function(e) {
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
			
			var input = new Element('div').setStyle('white-space', 'pre-wrap');
			var value = this.getValue();
			if(typeOf(value) == 'array') {
				var txt = "";
				for(var i = 0; i < value.length; i++) {
					txt += value[i];
				}
				input.set('text', txt);
			} else {
				input.set('text', value);
			}
			
			
			if(this.options[Field.PROPERTY_REQUIRED])
				fieldContainer.addClass('required');
			
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			input.inject(fieldContainer);
		}
	},
	
	showFormListener: function() {
		var area = this.content.getChildren('textarea')[0];
		if(area)
			area.erase('disabledCheck');
	},
	
	hideFormListener: function() {
		var area = this.content.getChildren('textarea')[0];
		if(area)
			area.set('disabledCheck', 'true');
	},
	
	showTranslationModal: function(lang_id) {
		
		var ele = this;
		
		new Request({
			url: 'apia.execution.FormAction.run?action=getFieldTranslations&frmId=' +  this.frmId.split('_')[1] + '&frmParent=' + this.frmId.split('_')[0] + '&fldId=' + this.fldId +'&attId=' + this.attId + '&langId=' + lang_id + TAB_ID_REQUEST,
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
		    			new_ele.force_synchronous = true;
		    			
		    			var translations = response.childNodes[0].childNodes;
		    			var translation = '';
		    			for(var i = 0; i < translations.length; i++) {
		    				if(translations[i].textContent != undefined)
		    					translation += translations[i].textContent;
		    				else
		    					translation += translations[i].text;
		    			}
		    			
		    			var data = {};
		    			data.url = CONTEXT + '/page/generic/emptyTranslation.jsp?' + TAB_ID_REQUEST;
		    			data.content = new Element('div.fieldGroup').setStyles({
		    				margin: 0
		    			});
		    			
		    			new Element('div.title', {text: TIT_TRANSLTATION}).inject(data.content);
		    			new Element('br').inject(data.content);
		    			
		    			var leftField = new Element('div.field.fieldHalf').setStyle('margin-bottom', '10px').inject(data.content);
		    			
		    			var label = new Element('label').appendText(ele.xml.getAttribute("attLabel") + ':');
		    			if(ele.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', ele.options[Field.PROPERTY_FONT_COLOR]);
		    			label.inject(leftField);
		    			
		    			var input = new Element('div').setStyle('white-space', 'pre-wrap');
		    			var value = ele.getValue();
		    			if(typeOf(value) == 'array') {
		    				var txt = "";
		    				for(var i = 0; i < value.length; i++) {
		    					txt += value[i];
		    				}
		    				input.set('text', txt);
		    			} else {
		    				input.set('text', value);
		    			}
		    			
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
		    			var inp = new Element('textarea.AJAXfield', {
		    				type: 'text',
		    				value: translation ? translation : '',
				    		id: ele.frmId + "_" + ele.fldId + '_tradField'
		    			}).setStyles({
		    				width: '100%'
		    			}).inject(rightField);
		    			
		    			inp.store(Field.STORE_KEY_FIELD, new_ele); //Referenciar al nuevo ele
		    			
//		    			inp.changeTranslation = function() {
			    		inp.addEvent('change', function() {	//Firefox no soporta eventos entre iframes
//		    				ele.lang_id = lang_id;
		    				
//		    				var text = inp.get('value');
//		    				
//		    				//var text = this.content.getElements('textarea')[0].get('value');
//		    				text.replace('\\', '%5C');
//		    				var res = new Array();
//		    				var i = 0;
//		    				while(text.length > 255) {
//		    					res.push(text.substr(0, 255));
//		    					text = text.substr(255);
//		    				}
//		    				if(text.length > 0)
//		    					res.push(text);
//		    				
//
//		    				//Firefox pierde stores
//		    				inp.store(Field.STORE_KEY_FIELD, new_ele);
//		    				
//		    				//SynchronizeFields.toSync(ele.content, res);
//		    				SynchronizeFields.toSync(inp, res);
			    			
			    			new_ele.has_changed = true;
		    			});
		    			
		    			inp.startSyncTraduction = function(callback_fnc) {
		    				
		    				if(new_ele.has_changed) {
		    					var text = inp.get('value');
			    				
			    				//var text = this.content.getElements('textarea')[0].get('value');
			    				text.replace('\\', '%5C');
			    				var res = new Array();
			    				var i = 0;
			    				while(text.length > 255) {
			    					res.push(text.substr(0, 255));
			    					text = text.substr(255);
			    				}
			    				if(text.length > 0)
			    					res.push(text);
			    				

			    				//Firefox pierde stores
			    				inp.store(Field.STORE_KEY_FIELD, new_ele);
			    				
			    				//SynchronizeFields.toSync(ele.content, res);
			    				SynchronizeFields.toSync(inp, res);
		    				}
		    				
		    				SynchronizeFields.syncJAVAexec(function() {
//		    					ele.lang_id = undefined;
		    					
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
		    			
		    			ModalController.openContentModal(data, 800, 500).addEvent('load', function(ifrm) {
		    				inp.setStyle('height', Number.max(Number.from(ifrm.getElement('div.fieldGroup').getStyle('height')) - 80, 355));
		    			});
		    			
		    			
		    			//Sincronizacion sin bloqueador
//		    			ModalController.openContentModal(data, 800, 500).addEvent('confirm', function() {
//		    				ele.lang_id = lang_id;
//		    				
//		    				var text = inp.get('value');
//		    				
//		    				//var text = this.content.getElements('textarea')[0].get('value');
//		    				text.replace('\\', '%5C');
//		    				var res = new Array();
//		    				var i = 0;
//		    				while(text.length > 255) {
//		    					res.push(text.substr(0, 255));
//		    					text = text.substr(255);
//		    				}
//		    				if(text.length > 0)
//		    					res.push(text);
//		    				
//		    				SynchronizeFields.toSync(ele.content, res);
//		    				ele.lang_id = undefined;
//		    			}.bind(this)).addEvent('load', function(ifrm) {
//		    				
//		    				inp.setStyle('height', Number.max(Number.from(ifrm.getElement('div.fieldGroup').getStyle('height')) - 80, 355));
//		    			});
		    			
		    		}
		    	}
			}
		}).send();
	}
});

Area.customRequiredChecker = function(el) {
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