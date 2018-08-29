var Editor = new Class({
	
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
		this.options[Field.PROPERTY_REQUIRED] 			= null;
		this.options[Field.PROPERTY_VISIBILITY_HIDDEN] 	= null;
		this.options[Field.PROPERTY_READONLY] 			= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
		this.options[Field.PROPERTY_TRANSLATION_REQUIRED]		= null;
	},
	
	booleanOptions: [Field.PROPERTY_REQUIRED, Field.PROPERTY_READONLY, Field.PROPERTY_VISIBILITY_HIDDEN, Field.PROPERTY_TRANSLATION_REQUIRED],
	
	getValue: function() {
		var text = this.content.getElements('textarea')[0].get('value');
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
		var textarea = this.content.getElement('textarea');
		if(textarea)
			return textarea.get('value');
		else
			return this.xml.getAttribute(Field.PROPERTY_VALUE);
	},
	
	/**
	 * Metodo de APIJS para establecer el valor del campo
	 */
	apijs_setFieldValue: function(value) {
		if(this.form.readOnly) return;
		tinymce.get('area_' + this.content.id).setContent(value + "");
		this.content.getElement('textarea').set('value', value + "");
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
		var ele = tinymce.get('area_' + this.content.id);
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
		var editor_area = this.content.getElement('textarea');
		
		if(prp_name == Field.PROPERTY_NAME) {
			//throw new Error('Property can not be changed.')
		} else if(prp_name == Field.PROPERTY_REQUIRED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_REQUIRED] == false) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
//					editor_area.addClass('validate["required","target:' + editor_area.get('id') + '_parent"]');
					
//					editor_area.addClass('validate["required","target:' + editor_area.get('id') + '_container"]');
//					
//					this.content.addClass('required');
//					$('frmData').formChecker.register(editor_area);
					
					this.content.addClass('required');
					
					if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
						if(!editor_area.hasClass('validate["%Editor.customRequiredChecker","target:' + editor_area.get('id') + '_container"]')) {
							editor_area.addClass('validate["%Editor.customRequiredChecker","target:' + editor_area.get('id') + '_container"]');
							$('frmData').formChecker.register(editor_area);
						}
					} else {
						editor_area.addClass('validate["required","target:' + editor_area.get('id') + '_container"]');
						$('frmData').formChecker.register(editor_area);
					}
				}
				this.options[Field.PROPERTY_REQUIRED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_REQUIRED]) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					//editor_area.removeClass('validate["required","target:' + editor_area.get('id') + '_parent"]');
//					editor_area.removeClass('validate["required","target:' + editor_area.get('id') + '_container"]');
					this.content.removeClass('required');
//					$('frmData').formChecker.dispose(editor_area);
					
					if(!this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
						editor_area.removeClass('validate["required","target:' + editor_area.get('id') + '_container"]');
						$('frmData').formChecker.dispose(editor_area);
					}
					
				}
				this.options[Field.PROPERTY_REQUIRED] = false;
			}
		} else if(prp_name == Field.PROPERTY_VISIBILITY_HIDDEN) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN] == false) {
				this.content.addClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = true;
				//Si es requerido, desregistrarlo
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					//editor_area.removeClass('validate["required","target:' + editor_area.get('id') + '_parent"]');
//					editor_area.removeClass('validate["required","target:' + editor_area.get('id') + '_container"]');
					this.content.removeClass('required');
//					$('frmData').formChecker.dispose(editor_area);
					
					if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
						if(editor_area.hasClass('validate["%Editor.customRequiredChecker","target:' + editor_area.get('id') + '_container"]')) {
							editor_area.removeClass('validate["%Editor.customRequiredChecker","target:' + editor_area.get('id') + '_container"]');
							$('frmData').formChecker.dispose(editor_area);
						}
					} else {
						editor_area.removeClass('validate["required","target:' + editor_area.get('id') + '_container"]');
						$('frmData').formChecker.dispose(editor_area);
					}
				}
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				this.content.removeClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = false;
				//Verificar si era requerido
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					//editor_area.addClass('validate["required","target:' + editor_area.get('id') + '_parent"]');
//					editor_area.addClass('validate["required","target:' + editor_area.get('id') + '_container"]');
					this.content.addClass('required');
//					$('frmData').formChecker.register(editor_area);
					
					if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
						if(!editor_area.hasClass('validate["%Editor.customRequiredChecker","target:' + editor_area.get('id') + '_container"]')) {
							editor_area.addClass('validate["%Editor.customRequiredChecker","target:' + editor_area.get('id') + '_container"]');
							$('frmData').formChecker.register(editor_area);
						}
					} else {
						editor_area.addClass('validate["required","target:' + editor_area.get('id') + '_container"]');
						$('frmData').formChecker.register(editor_area);
					}
				}
			}
		} else if(prp_name == Field.PROPERTY_READONLY) {
			//TODO
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
				
		//Hace espacio en el formulario y ubica el campo en su lugar.
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

		//TODO: Field_PROPERTY_NAME
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		if(this.xml.getAttribute("trad"))
			this.translations = JSON.decode(this.xml.getAttribute("trad"));
		
		//Si estoy en monitor, solo coloco el texto
		/*if(this.form.readOnly) {
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				var div = new Element('div.editor_container');
				
				new Element('label').appendText(this.xml.getAttribute("attLabel") + ':')
					.inject(div);
				
				var editor = new Element('div', {
					html: this.xml.getAttribute(Field.PROPERTY_VALUE)
				});
				
				if(this.options[Field.PROPERTY_REQUIRED])
					fieldContainer.addClass('required');
				
				editor.inject(div);
				
				div.inject(this.content);
			}
			
			return;
		}*/
		
		//LABEL
		
		var label = new Element('label');
		/*		
		if(this.options[Field.PROPERTY_FONT_COLOR])
			label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		*/
		label.appendText(this.xml.getAttribute("attLabel") + ':');
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		//EDITOR
		
		if(this.options[Field.PROPERTY_READONLY] || this.form.readOnly) {
			//Agregar value como HTML
			
			label.addClass('monitor-lbl');
			
			var editor = new Element('div', {
				id: 	"div_" + this.content.id,
				fld_id:	this.frmId + "_" + this.fldId,
				html: this.xml.getAttribute(Field.PROPERTY_VALUE)
			});
			
			if(this.form.readOnly)
				editor.addClass('monitor-editor');
			
			//this.content.addClass('editor');
			
			label.inject(this.content);
			editor.inject(this.content);
			
			if(this.options[Field.PROPERTY_REQUIRED]) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					this.content.addClass('required'); //visualmente
				}
			}
			
			this.addTranslationIcon(new Element('input', {value: editor.get('html')}));
			
			if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
				editor.addClass('validate["%Editor.customRequiredChecker"]');
				editor.set('forceReq', 'true');
				$('frmData').formChecker.register(editor);
			}
			
		} else {
		
			var area_id = "area_" + this.content.id;
			
			var editor = new Element('textarea', {
				id: 	area_id,
				rows: 	15,
				cols: 	80,
				fld_id:	this.frmId + "_" + this.fldId
			});
			
			//Forzamos el alto para que los formularios cerrados perciban el alto del editor
			//El textarea va a quedar oculto igual cuando se cargue el editor
			editor.setStyle("height", 455); 
			
//			var has_value;
			if(this.xml.getAttribute(Field.PROPERTY_VALUE)) {
				editor.set('value', this.xml.getAttribute(Field.PROPERTY_VALUE));
//				has_value = true;
			}
			
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				if(this.options[Field.PROPERTY_REQUIRED]) {
					if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED])
						editor.addClass('validate["%Editor.customRequiredChecker","target:' + area_id + '_container"]');
					else
						editor.addClass('validate["required","target:' + area_id + '_container"]');
					//editor.addClass('validate["required","target:' + area_id + '_parent"]');			
//					editor.addClass('validate["required","target:' + area_id + '_container"]');
					this.content.addClass('required');
					$('frmData').formChecker.register(editor);
				} else if(this.options[Field.PROPERTY_TRANSLATION_REQUIRED]) {
					editor.addClass('validate["%Editor.customRequiredChecker","target:' + area_id + '_container"]');
					this.content.addClass('required');
					$('frmData').formChecker.register(editor);
				}
			}
			
			this.content.addClass('editor');
			
			label.inject(this.content);
			
			editor.inject(new Element('div', {id: area_id + '_container'}).inject(this.content));
//			editor.inject(this.content);
			
			this.content.addClass('AJAXfield');
			
			if(this.xml.getAttribute("forceSync"))
				this.content.set(SynchronizeFields.SYNC_FAILED, 'true');
			
			//Agregar los controles de tinyMCE
			
//			try {
//				window.parent.tinyMCE.execCommand("mceRemoveEditor", false, area_id);
//			} catch(e) {			
//			}
			
//			try {
				tinyMCE.execCommand("mceAddEditor", false, area_id);
				
//				var editor_id = tinyMCE.get(area_id).editorContainer.id;
//				console.log("editor_id: " + editor_id);
				
//			var gg = tinyMCE.createEditor(area_id);
//			} catch(e) {
//				throw new Error("Error al agregar controles de tinyMCE");
//			}
			
//			//Sincronizacion
//			editor.addEvent('change', function() {
//				SynchronizeFields.toSync(this.content, this.getValue());
//			}.bind(this));
		
			
			
			if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
				var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
				var target = this;
				if (fn_change) {
					editor.addEvent('change', function() { 
//						if(has_value) {
//							has_value = false;
//							return;
//						}
						try {
							fn_change(new ApiaField(target));
						} catch(error) {}
						
						target.checkTranslationIconVisibility(editor);
					});			
				} else {				
					console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
					
					editor.addEvent('change', function() {
//						if(has_value) {
//							has_value = false;
//							return;
//						}
						SynchronizeFields.toSync(this.content, this.getValue());
						
						this.checkTranslationIconVisibility(editor);
					}.bind(this));
				}
			} else {
				//Sincronizacion
				editor.addEvent('change', function() {
//					if(has_value) {
//						has_value = false;
//						return;
//					}
					SynchronizeFields.toSync(this.content, this.getValue());
					
					this.checkTranslationIconVisibility(editor);
				}.bind(this));
			}
			
			//TRADUCCION
			this.addTranslationIcon(editor);
		}
	},
	
	getPrintHTML: function(formContainer) {
		
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var fieldContainer = this.parsePrintXMLposition(formContainer);
			
			var div = new Element('div.editor_container');
			
			new Element('label').appendText(this.xml.getAttribute("attLabel") + ':')
				.inject(div);
			
			var editor = new Element('div');
			
			if(this.form.readOnly || this.options[Field.PROPERTY_READONLY])
				editor.set('html', this.xml.getAttribute(Field.PROPERTY_VALUE));
			else
				editor.set('html', this.apijs_getFieldValue());
			
			if(this.options[Field.PROPERTY_REQUIRED])
				fieldContainer.addClass('required');
			
			editor.inject(div);
			
			div.inject(fieldContainer);
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
		    			
	    				
	    				var div = new Element('div.editor_container');
	    				
	    				new Element('label').appendText(ele.xml.getAttribute("attLabel") + ':').inject(div);
	    				
	    				var editor = new Element('div');
	    				
	    				editor.set('html', ele.apijs_getFieldValue());
	    				
	    				editor.inject(div);
	    				
	    				div.inject(leftField);
		    			
		    			
		    			var rightField = new Element('div.field.fieldHalf').inject(data.content);
		    			
		    			new Element('label', {text: ele.form.langs[lang_id] + ':'}).inject(rightField);
		    			
		    			var area_id = ele.frmId + "_" + ele.fldId + '_tradField'; //"area_" + ele.content.id + "_translation";
		    			
		    			var editor = new Element('textarea.AJAXfield', {
		    				id: 	area_id,
		    				rows: 	15,
		    				cols: 	80,
		    				value: translation ? translation : ''
		    			}).inject(rightField);
		    			
//		    			var inp = new Element('textarea', {
//		    				type: 'text',
//		    				value: translation ? translation : ''
//		    			}).setStyles({
//		    				width: '100%'
//		    			}).inject(rightField);
		    			
		    			editor.store(Field.STORE_KEY_FIELD, new_ele); //Referenciar al nuevo ele
		    			
		    			
		    			editor.changeTranslation = function() {
//		    			editor.addEvent('change', function() {	//Firefox no soporta eventos entre iframes
//		    				ele.lang_id = lang_id;
		    				
//		    				var text = editor.get('value');
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
//		    				//Firefox pierde stores
//		    				editor.store(Field.STORE_KEY_FIELD, new_ele);
//		    				
////		    				SynchronizeFields.toSync(ele.content, res);
//		    				SynchronizeFields.toSync(editor, res);
		    				
		    				new_ele.has_changed = true;
//		    			});
		    			};
		    			
		    			editor.startSyncTraduction = function(callback_fnc) {
		    				
		    				if(new_ele.has_changed) {
		    					var text = editor.get('value');
			    				
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
			    				editor.store(Field.STORE_KEY_FIELD, new_ele);
			    				
//			    				SynchronizeFields.toSync(ele.content, res);
			    				SynchronizeFields.toSync(editor, res);
		    				}
		    				
		    				SynchronizeFields.syncJAVAexec(function() {
//		    					ele.lang_id = undefined;
		    					
		    					//Agregar el elemento al documentbody por si no quedo sincronizado, para que el submit vuelva a intentarlo
		    					var prev_trad = $(editor.get('id'));
		    					if(prev_trad) prev_trad.dispose();
		    					editor.setStyle('display', 'none');
		    					editor.inject($(document.body));
		    					
		    					ele.translations[lang_id] = (String.trim(editor.get('value')) != '');
		    					
		    					ele.refreshTranslationMenu();
		    					
		    					if(callback_fnc)
		    						callback_fnc();
		    				}, true);
		    			};
		    			
		    			var width = Number.min($(document.body).getWidth() - 40, 1300);
		    			var height = $(document.body).getHeight() - 80; //600;
		    			var ifrm_height = height - 245;
		    			ModalController.openContentModal(data, width, height).addEvent('load', function(ifrm) {
		    				
		    				var win = ifrm.ownerDocument.defaultView || ifrm.ownerDocument.parentWindow
		    				
		    				win.tinyMCE.execCommand("mceAddEditor", false, area_id);
		    				
		    				setTimeout(function() {
		    					ifrm.ownerDocument.getElementById(area_id + '_ifr').style.height = Number.max(Number.from(ifrm.getElement('div.fieldGroup').getStyle('height')) - 185, ifrm_height) + 'px';
		    				},200);
//		    				ifrm.ownerDocument.getElementById('area_E_1029_26_translation_ifr').styles.height = Number.max(Number.from(ifrm.getElement('div.fieldGroup').getStyle('height')) - 80, 355) + 'px';
//		    				inp.setStyle('height', Number.max(Number.from(ifrm.getElement('div.fieldGroup').getStyle('height')) - 80, 355));
		    			});
		    			
		    			
		    			//Sincronizacion sin bloqueador
//		    			var width = Number.min($(document.body).getWidth() - 40, 1300);
//		    			var height = $(document.body).getHeight() - 80; //600;
//		    			var ifrm_height = height - 245;
//		    			ModalController.openContentModal(data, width, height).addEvent('confirm', function() {
//		    				ele.lang_id = lang_id;
//		    				
//		    				var text = editor.get('value');
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
//		    				var win = ifrm.ownerDocument.defaultView || ifrm.ownerDocument.parentWindow
//		    				
//		    				win.tinyMCE.execCommand("mceAddEditor", false, area_id);
//		    				
//		    				setTimeout(function() {
//		    					ifrm.ownerDocument.getElementById('area_E_1029_26_translation_ifr').style.height = Number.max(Number.from(ifrm.getElement('div.fieldGroup').getStyle('height')) - 185, ifrm_height) + 'px';
//		    				},100);
////		    				ifrm.ownerDocument.getElementById('area_E_1029_26_translation_ifr').styles.height = Number.max(Number.from(ifrm.getElement('div.fieldGroup').getStyle('height')) - 80, 355) + 'px';
////		    				inp.setStyle('height', Number.max(Number.from(ifrm.getElement('div.fieldGroup').getStyle('height')) - 80, 355));
//		    			});
		    			
		    		}
		    	}
			}
		}).send();
	}
});

Editor.customRequiredChecker = function(el) {
	var field = el.getParent('div.exec_field').retrieve(Field.STORE_KEY_FIELD);
	
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
