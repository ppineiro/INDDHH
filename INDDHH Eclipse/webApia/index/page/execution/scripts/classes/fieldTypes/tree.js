var Tree = new Class({

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
		//this.options[Field.PROPERTY_TRANSIENT] 		= null;
		this.options[Field.PROPERTY_READONLY] 			= null;
		this.options[Field.PROPERTY_VISIBILITY_HIDDEN] 	= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 	= null;
		
		this.options[Field.PROPERTY_HEIGHT]				= null;
		this.options[Field.PROPERTY_MULTISELECT]		= null;
		this.options[Field.PROPERTY_SEL_PARENT]			= null;
		this.options[Field.PROPERTY_PARENT_ICON]		= null;
		this.options[Field.PROPERTY_LEAF_ICON]			= null;
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
	},
	
	booleanOptions: [Field.PROPERTY_INPUT_AS_TEXT, Field.PROPERTY_REQUIRED, Field.PROPERTY_DISABLED, Field.PROPERTY_READONLY, Field.PROPERTY_VISIBILITY_HIDDEN, Field.PROPERTY_MULTISELECT],
	
	getValue: function() {		
		var res = new Array();
		this.content.getElement('ol.tree').getElements('span.selected').each(function(option) {
			res.push(option.get('val'));
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
		if(typeOf(value) == "array" && value != null && value.length) {
			if(this.options[Field.PROPERTY_MULTISELECT])
				values = value;
			else
				values = value[0];
			
			for(var i = 0; i < values.length; i++) {
				values[i] = values[i]+"";
			}
		} else if(typeOf(value) == "string" || typeOf(value) == "number") {
			values = [value + ""];
		} else {
			throw new Error('The function setFieldValue for a Tree field only accepts array, int or string type for value parameter.');
		}
		if(values) {
			this.content.getElement('ol.tree').getElements('span').each(function(option) {
				if(values.contains(option.get('val')))
					option.addClass('selected');
				else
					option.removeClass('selected');
			});
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
		var ele = this.content.getElement('ol.tree.first-parent');
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
		} else if(prp_name == Field.PROPERTY_SIZE) {

			this.options[Field.PROPERTY_SIZE] = Number.from(prp_value);
			var tree = this.content.getElement('ol.tree.first-parent');
			if(this.options[Field.PROPERTY_SIZE] || this.options[Field.PROPERTY_SIZE] === 0) {				
				if(tree)
					tree.setStyle('width', this.options[Field.PROPERTY_SIZE]);
			} else {
				if(tree)
					tree.setStyle('width', '');
			}
			
		} else if(prp_name == Field.PROPERTY_HEIGHT) {
			
			this.options[Field.PROPERTY_HEIGHT] = Number.from(prp_value);
			var tree = this.content.getElement('ol.tree.first-parent');
			if(this.options[Field.PROPERTY_HEIGHT] || this.options[Field.PROPERTY_HEIGHT] === 0) {				
				if(tree)
					tree.setStyle('height', this.options[Field.PROPERTY_HEIGHT]);
			} else {
				if(tree)
					tree.setStyle('height', '');
			}
			
		} else if(prp_name == Field.PROPERTY_FONT_COLOR) {
			this.content.getElement('label').setStyle('color', prp_value);
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_TOOLTIP) {
			this.content.getElement('label').tooltip(prp_value, { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
			this.options[Field.PROPERTY_TOOLTIP] = prp_value;
		} else if(prp_name == Field.PROPERTY_VALUE_COLOR) {
			this.content.getElement('ol.tree').setStyle('color', prp_value);
			this.options[Field.PROPERTY_VALUE_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_REQUIRED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_REQUIRED] == false) {
				var ol_tree = this.content.addClass('required').getElement('ol.tree').addClass('validate["required","%Tree.customTreeChecker"]');
				this.options[Field.PROPERTY_REQUIRED] = true;
				$('frmData').formChecker.register(ol_tree);
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_REQUIRED]) {
				var ol_tree = this.content.removeClass('required').getElement('ol.tree').removeClass('validate["required","%Tree.customTreeChecker"]');
				this.options[Field.PROPERTY_REQUIRED] = false;
				$('frmData').formChecker.dispose(ol_tree);
			}
		} else if(prp_name == Field.PROPERTY_DISABLED) {
			var tree = this.content.getElement('ol.tree.first-parent');
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_DISABLED] == false) {
				tree.addClass('disabled');
				if(Browser.firefox)
					tree.setStyle('background-color', '#f0f0f0');
				this.options[Field.PROPERTY_DISABLED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_DISABLED]) {
				tree.removeClass('disabled');
				if(Browser.firefox)
					tree.setStyle('background-color', '');
				this.options[Field.PROPERTY_DISABLED] = false;
			}
		} else if(prp_name == Field.PROPERTY_TRANSIENT) {
			//NOT SUPPORTED
		} else if(prp_name == Field.PROPERTY_READONLY) {
			this.options[Field.PROPERTY_READONLY] = prp_boolean_value;
		} else if(prp_name == Field.PROPERTY_VISIBILITY_HIDDEN) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN] == false) {
				this.content.addClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = true;
				//Si es requerido, desregistrarlo
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					var ol_tree = this.content.removeClass('required').getElement('ol.tree').removeClass('validate["required","%Tree.customTreeChecker"]');
					$('frmData').formChecker.dispose(ol_tree);
				}
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				this.content.removeClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = false;
				//Verificar si era requerido
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					var ol_tree = this.content.addClass('required').getElement('ol.tree').addClass('validate["required","%Tree.customTreeChecker"]');
					$('frmData').formChecker.register(ol_tree);
				}
			}
		} else if(prp_name == Field.PROPERTY_MULTISELECT) {
			this.options[Field.PROPERTY_MULTISELECT] = prp_boolean_value;
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
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		//Seteamos el tipo de atributo
		if(this.xml.getAttribute("valueType"))
			this.options.valueType = this.xml.getAttribute("valueType");
		
		//Si estoy en monitor, solo coloco el texto
		if(this.form.readOnly) {
			if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
				this.content.addClass('visibility-hidden');
			
			var label = new Element('label.monitor-lbl').appendText(this.xml.getAttribute("attLabel") + ':');
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			label.inject(this.content);
			
			
			var tree_ro = new Element('div.monitor-tree', {
				fld_id: this.frmId + "_" + this.fldId
			}).setStyles({
		    	'padding-left': '15px'
			});
			
			option_html = "";
			var tree = new Element('ol').set('html', this.parseTreePossibleValues(this.xml.childNodes));
			tree.getElements('span.selected').each(function(span) {
				var aux_str = span.get('html');
				var aux_ele = span.getParent('li');
				while (aux_ele.getParent('li') != null) {
					aux_ele = aux_ele.getParent('li');
					aux_str = aux_ele.getElement('span').get('html') + " > " + aux_str;
				}
				option_html += aux_str + '<br/>';
			});
			tree.destroy();
			
			tree_ro.set('html', option_html);
			
			tree_ro.inject(this.content);
			
			if(this.options[Field.PROPERTY_REQUIRED])
				this.content.addClass('required');
			
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				tree_ro.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			return;
		}

		//LABEL
		
		var label = new Element('label');
				
		if(this.options[Field.PROPERTY_FONT_COLOR] && this.options[Field.PROPERTY_FONT_COLOR] != "#000000")
			label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		
		label.appendText(this.xml.getAttribute("attLabel") + ':');
		
		//TREE
		
		var tree = new Element('ol.tree.first-parent', {
			fld_id: this.frmId + "_" + this.fldId
		});
		
		tree.set('tabIndex', '0');
		
		if(this.options[Field.PROPERTY_SIZE])
			tree.setStyle('width', Number.from(this.options[Field.PROPERTY_SIZE]));
		
		if(this.options[Field.PROPERTY_HEIGHT])
			tree.setStyle('height', Number.from(this.options[Field.PROPERTY_HEIGHT]));
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		if(this.options[Field.PROPERTY_VALUE_COLOR] && this.options[Field.PROPERTY_VALUE_COLOR] != "#000000")
			tree.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		if(this.options[Field.PROPERTY_REQUIRED] && !this.options[Field.PROPERTY_READONLY] && !this.options[Field.PROPERTY_DISABLED]) {
			tree.addClass('validate["required","%Tree.customTreeChecker"]');
			this.content.addClass('required');
			$('frmData').formChecker.register(tree);
		}
		
		if(this.xml.childNodes != null && this.xml.childNodes.length > 0) {
			tree.set('html', this.parseTreePossibleValues(this.xml.childNodes));
			tree.getElements('div.expanded').addEvent('click', this.expandClick);
			tree.getElements('span').addEvent('click', this.selectClick.bind(this));
		}
				
		label.inject(this.content);
		
		tree.inject(this.content);
		
		if(this.options[Field.PROPERTY_DISABLED]) {
			tree.addClass('disabled');
			if(Browser.firefox)
				tree.setStyle('background-color', '#f0f0f0');
		} else {
			this.content.addClass('AJAXfield');
		}
		
		if(this.options[Field.PROPERTY_TOOLTIP])
			label.tooltip(this.options[Field.PROPERTY_TOOLTIP], { mode: 'auto', width: 200, hook: 0, mouse:true, click:false});
		
		//onchange
//		if(this.xml.getAttribute(Field.FUNC_CHANGE) && !window.editionMode) {
		if(this.xml.getAttribute(Field.FUNC_CHANGE)) {
			var fn_change = window[this.xml.getAttribute(Field.FUNC_CHANGE)];
			var target = this;
			if (fn_change) {
				tree.addEvent('change', function() {
					//SynchronizeFields.preJSexec(this.content);					
					//fn_change();
					try {
						fn_change(new ApiaField(target));
					} catch(error) {}
					//SynchronizeFields.posJSexec(this.content);
				});
			} else {				
				if(console) console.error('NO SE ENCUENTRA CLASE GENERADA: ' + this.xml.getAttribute(Field.FUNC_CHANGE));
				
				tree.addEvent('change', function() {
					SynchronizeFields.toSync(this.content, this.getValue());
				}.bind(this));
			}
		} else {
		 	
			tree.addEvent('change', function() {
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
			
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				
				var tree_ro = new Element('div.monitor-tree', {
					fld_id: this.frmId + "_" + this.fldId
				}).setStyles({
			    	'padding-left': '15px'
				});
				
				option_html = "";
				var tree = new Element('ol').set('html', this.parseTreePossibleValues(this.xml.childNodes));
				tree.getElements('span.selected').each(function(span) {
					var aux_str = span.get('html');
					var aux_ele = span.getParent('li');
					while (aux_ele.getParent('li') != null) {
						aux_ele = aux_ele.getParent('li');
						aux_str = aux_ele.getElement('span').get('html') + " > " + aux_str;
					}
					option_html += aux_str + '<br/>';
				});
				tree.destroy();
				
				tree_ro.set('html', option_html);
				
				tree_ro.inject(fieldContainer);
				
				if(this.options[Field.PROPERTY_VALUE_COLOR])
					tree_ro.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			}
		} else {
			var opts = this.getSelectedPath();			
			for(var i = 0; i < opts.length; i++) {
				var input = new Element('span', {html: opts[i]});
				if(this.options[Field.PROPERTY_VALUE_COLOR])
					input.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
				input.inject(fieldContainer);
				new Element('br').inject(fieldContainer);
			}
		}
		
		if(this.options[Field.PROPERTY_REQUIRED])
			fieldContainer.addClass('required');
	},
	
	parseTreePossibleValues: function(nodes) {
		var res = '';
		Array.from(nodes).each(function (option_xml, index) {
			
			var childs = null;
			if(option_xml.childNodes != null && option_xml.childNodes.length > 0)
				childs = this.parseTreePossibleValues(option_xml.childNodes);
			
			res += '<li>';
			
			if(childs) {
				res += '<div class="expanded"></div>';
				
				if(this.options[Field.PROPERTY_PARENT_ICON])
					res += '<img class="parent" src="' + CONTEXT + '/images/uploaded/' + this.options[Field.PROPERTY_PARENT_ICON] + '" />';
				
				
				res += '<span ' + (option_xml.getAttribute('selected') ? 'class="selected"' : '') + ' val="' + option_xml.getAttribute('value') + '">' + option_xml.getAttribute('text') + '</span>';
				
			} else {
				res += '<div class="leaf"></div>';
				
				if(this.options[Field.PROPERTY_LEAF_ICON])
					res += '<img class="leaf" src="' + CONTEXT + '/images/uploaded/' + this.options[Field.PROPERTY_LEAF_ICON] + '" />';
				
				res += '<span ' + (option_xml.getAttribute('selected') ? 'class="selected"' : '') + ' val="' + option_xml.getAttribute('value') + '">' + option_xml.getAttribute('text') + '</span>';
			}
			
			
			if(childs)
				res += '<ol class="tree">' + childs + '</ol>';
		}.bind(this));
		
		return res;
	},
	
	getSelectedPath: function() {
		var res = [];
		this.content.getElement('ol.tree').getElements('span.selected').each(function(span) {
			var aux_str = span.get('html');
			var aux_ele = span.getParent('li');
			while (aux_ele.getParent('li') != null) {
				aux_ele = aux_ele.getParent('li');
				aux_str = aux_ele.getElement('span').get('html') + " > " + aux_str;
			}
			res.push(aux_str);
		});
		return res;
	},
	
	expandClick: function(event) {
		var tree = event.target.getNext('ol.tree');
		if(event.target.hasClass('expanded')) {
			event.target.removeClass('expanded').addClass('collapsed');
			tree.setStyle('display', 'none');
		} else {
			event.target.removeClass('collapsed').addClass('expanded');
			tree.setStyle('display', '');
		}
	},
	
	selectClick: function(event) {
		if(this.options[Field.PROPERTY_READONLY] || this.options[Field.PROPERTY_DISABLED])
			return;
		
		if(!this.options[Field.PROPERTY_SEL_PARENT] && event.target.getNext('ol.tree'))
			return;
		
		if(event.target.hasClass('selected')) {
			event.target.removeClass('selected');
		} else {
			if(!this.options[Field.PROPERTY_MULTISELECT])
				this.content.getElement('ol.tree').getElements('span').removeClass('selected');
			event.target.addClass('selected');
		}
		this.content.getElement('ol.tree').fireEvent('change');
	},
	
	forceAjaxReload: function(xml) {
		
		if(this.options[Field.PROPERTY_REQUIRED]) {
			var ol_tree = this.content.removeClass('required').getElement('ol.tree').removeClass('validate["required","%Tree.customTreeChecker"]');
			this.options[Field.PROPERTY_REQUIRED] = false;
			$('frmData').formChecker.dispose(ol_tree);
		}
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.removeClass('visibility-hidden');
			
		//Limpiar options
		this.setDefaultOptions();
		
		this.xml = xml.childNodes[0];
		
		//Obtener options
		var options = JSON.decode(this.xml.getAttribute(Field.FIELD_PROPERTIES));
		
		//Actualiar options
		this.setOptions(options);
		this.setBooleanOptions();
		
		if(this.options[Field.PROPERTY_FONT_COLOR] && this.options[Field.PROPERTY_FONT_COLOR].indexOf('#') < 0)
			this.options[Field.PROPERTY_FONT_COLOR] = '#' + this.options[Field.PROPERTY_FONT_COLOR];
		
		if(this.options[Field.PROPERTY_VALUE_COLOR] && this.options[Field.PROPERTY_VALUE_COLOR].indexOf('#') < 0)
			file_object.options[Field.PROPERTY_VALUE_COLOR] = '#' + this.options[Field.PROPERTY_VALUE_COLOR];
		
		//Recagar
		var childs = this.content.getChildren();
		if(childs) {
			for(var i = 0; i < childs.length; i++)
				childs[i].destroy();
		}
		
		this.parseXML();
	}
});

Tree.customTreeChecker = function(el) {
	var tree = el.getParent().retrieve(Field.STORE_KEY_FIELD);
	if(tree.getValue().length > 0) {
		return true;
	} else {
		el.errors.push(formcheckLanguage.required);
		return false;
	}
		
}