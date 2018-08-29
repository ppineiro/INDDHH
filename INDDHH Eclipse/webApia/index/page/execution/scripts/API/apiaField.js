/**
 * Campos para la APIJavascript
 */
var ApiaField = new Class({
	
	initialize: function(fld_src, inGrid) {
		
		this.fldType = fld_src.xml.getAttribute("fieldType");
		
		this.getForm = function() {
			if(fld_src.form)
				return new ApiaForm(fld_src.form);
		};
		
		this.setProperty = function(prp_name, prp_value) {
			if(fld_src.apijs_setProperty) 
				fld_src.apijs_setProperty(prp_name, prp_value);
			else
				throw new Error('The field does not support this function');
			return this;
		};
		
		this.getProperty = function(prp_name) {
			return fld_src.options[prp_name];
		};
		
		this.clearValue = function() {
			if(fld_src.apijs_clearValue)
				fld_src.apijs_clearValue();
			else
				throw new Error('The field does not support this function');
			return this;
		};
	
		this.getValue = function() {
			if(fld_src.apijs_getFieldValue)
				return fld_src.apijs_getFieldValue();
			else
				throw new Error('The field does not support this function');
		};
		
		this.setValue = function(value) {
			if(fld_src.apijs_setFieldValue)
				fld_src.apijs_setFieldValue(value);
			else
				throw new Error('The field does not support this function');
			return this;
		};
	
		this.getLabel = function() {
			var lbl = fld_src.xml.getAttribute("attLabel");
			if(lbl == null || lbl == undefined)
				throw new Error('The field does not use a label');
			return String.from(lbl);
		};
		
		this.isInGrid = function() {
			return !!inGrid;
		}
		
		this.setFocus = function() { 
			if(fld_src.apijs_setFocus) 
				fld_src.apijs_setFocus(); 
			return this;
		}
		
		if(inGrid) {
			//Opciones de campos dentro de grilla
			this.getParentGrid = function() {
				return fld_src.apijs_getParentGrid();
			};
			
			this.getNext = function() {
				return fld_src.apijs_getNext();
			};
			
			this.getPrevious = function() {
				return fld_src.apijs_getPrevious();
			};
			
			this.getColIndex = function() {
				return fld_src.apijs_getColIndex();
			};
			
			if(fld_src.index != null) {
				this.index = fld_src.index - fld_src.gridHeader.parentGrid.startIndex;
				this.absoluteIndex = fld_src.index;
			}
		} else {
			this.index = fld_src.index;
		}
		
		//Opciones de radio		
		if(this.fldType == Field.TYPE_INPUT) {
			this.getObjectValue = function() { return fld_src.apijs_getObjectValue(); };
		}
		//Opciones de boton		
		if(this.fldType == Field.TYPE_BUTTON) {
			this.fireClickEvent = function() { return fld_src.apijs_fireClickEvent(); };
		}
		//Opciones de radio		
		if(this.fldType == Field.TYPE_RADIO) {
			this.getOptions = function(asObject) { return fld_src.apijs_getOptions(asObject); };
			this.clearOptions = function() { fld_src.apijs_clearOptions(); return this;};
			this.addOption = function(value, showValue, allowRepeatedValue) { fld_src.apijs_addOption(value, showValue, allowRepeatedValue); return this;};
			this.removeOption = function(value) { fld_src.apijs_removeOption(value); return this;};
			this.getSelectedOption = function(asObject) { return fld_src.apijs_getSelectedOption(asObject);};
			/*this.getSelectedValue = function() { return fld_src.apijs_getSelectedValue();};*/
			this.getSelectedText = function() { return fld_src.apijs_getSelectedText();};
		}
		//Opciones de combo
		if(this.fldType == Field.TYPE_SELECT) {
			this.getOptions = function(asObject) { return fld_src.apijs_getOptions(asObject); };
			this.clearOptions = function() { fld_src.apijs_clearOptions(); return this;};
			this.addOption = function(value, showValue, allowRepeatedValue) { fld_src.apijs_addOption(value, showValue, allowRepeatedValue); return this;};
			this.removeOption = function(value) { fld_src.apijs_removeOption(value); return this;};
			this.getSelectedOption = function(asObject) { return fld_src.apijs_getSelectedOption(asObject);};
			/*this.getSelectedValue = function() { return fld_src.apijs_getSelectedValue();};*/
			this.getSelectedText = function() { return fld_src.apijs_getSelectedText();};
		}
		//Opciones de combo multiinstance
		if(this.fldType == Field.TYPE_MULTIPLE) {
			this.getOptions = function(asObject) { return fld_src.apijs_getOptions(asObject); };
			this.clearOptions = function() { fld_src.apijs_clearOptions(); return this;};
			this.addOption = function(value, showValue, allowRepeatedValue) { fld_src.apijs_addOption(value, showValue, allowRepeatedValue); return this;};
			this.removeOption = function(value) { fld_src.apijs_removeOption(value); return this;};
			this.getSelectedOption = function(asObject) { return fld_src.apijs_getSelectedOption(asObject);};
		}
		//Opciones de grilla
		if(this.fldType == Field.TYPE_GRID) {
			this.getField = function(fldName, index) { return fld_src.apijs_getField(fldName ? fldName.toUpperCase() : fldName, (index != null ? index : 0)); };
			this.getColumn = function(fldName) { return fld_src.apijs_getColumn(fldName ? fldName.toUpperCase() : fldName); };
			this.getRow = function(index) { return fld_src.apijs_getRow(index); };
			this.deleteRow = function(index) { fld_src.apijs_deleteRow(index); return this;};
			this.deletePage = function(page) { fld_src.apijs_deletePage(page); return this;};
			this.deleteGrid = function() { fld_src.apijs_deleteGrid(); return this;};
			this.clearRow = function(index) { fld_src.apijs_clearRow(index); return this;};
			this.clearPage = function(page) { fld_src.apijs_clearPage(page); return this;};
			this.clearGrid = function() { fld_src.apijs_clearGrid(true); return this;};
			this.addRow = function(cant) { fld_src.apijs_addRow(cant); return this;};
			this.isPaged = function() { return fld_src.apijs_isPaged(); };
			this.getPageCount = function() { return fld_src.apijs_getPageCount(); };
			this.getCurrentPage = function() { return fld_src.apijs_getCurrentPage(); };
			this.getSelectedIndexes = function(useAbsoluteIndex) { return fld_src.apijs_getSelectedIndexes(useAbsoluteIndex); };
			this.getSelectedItems = function() { return fld_src.apijs_getSelectedItems(); };
			
			this.getAllColumns = function() { return fld_src.apijs_getAllColumns(); };
		}
	}
});

var ApiaForm = new Class({
	
	initialize: function(frm_src) {
		
		this.setProperty = function(prp_name, prp_value) {
			
			if(this.getProperty(prp_name) == String.from(prp_value))
				return;
			
			 if(prp_name == IProperty.PROPERTY_FORM_HIDDEN) {
				if(prp_value)
					frm_src.hideForm();
				else
					frm_src.showForm();
			} else if(prp_name == IProperty.PROPERTY_FORM_CLOSED) {
				if(prp_value) {
					if(frm_src.collapseBtn.hasClass("collapseForm"))
						frm_src.collapseForm();
				} else {
					if(frm_src.collapseBtn.hasClass("expandForm"))
						frm_src.expandForm();
				}
			} else if(prp_name == IProperty.PROPERTY_FORM_HIGHLIGHT) {
				frm_src.setHighlight(prp_value);
			} else if(prp_name == IProperty.PROPERTY_FORM_INVISIBLE) {
				throw new Error('The property "PROPERTY_FORM_INVISIBLE" can only be set in a JAVA business class.\nUse PROPERTY_FORM_HIDDEN instead.');
			} else if(prp_name == IProperty.PROPERTY_FORM_TAB) {
				throw new Error('The property "PROPERTY_FORM_TAB" can only be set in a JAVA business class.');
			} else if(prp_name == IProperty.PROPERTY_FORM_DONT_FIRE) {
				throw new Error('The property "PROPERTY_FORM_DONT_FIRE" can only be set in a JAVA business class.');
			} else if(prp_name == IProperty.PROPERTY_FORM_READONLY) {
				throw new Error('The property "PROPERTY_FORM_READONLY" can only be set in a JAVA business class.');
			} else {
				throw new Error('Form does not accept the property.');
			}
		};
		
		this.getProperty = function(prp_name) { return frm_src.options[prp_name] == "true"; };
		
		this.closeForm = function() { this.setProperty(IProperty.PROPERTY_FORM_CLOSED, true); };
		
		this.openForm = function() { this.setProperty(IProperty.PROPERTY_FORM_CLOSED, false); };
		/*
		this.hideForm = function() { this.setProperty(IProperty.PROPERTY_FORM_HIDDEN, true); };
		
		this.showForm = function() { this.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false); };
		*/
		this.clearForm = function(clearReadonlyFields, deleteGridsRows) {
			if(frm_src && frm_src.fields) {
				for(var i = 0; i < frm_src.fields.length; i++) {
					if(frm_src.fields[i].apijs_clearValue) {
						if(clearReadonlyFields || frm_src.fields[i].options[Field.PROPERTY_READONLY] == null)
							frm_src.fields[i].apijs_clearValue();
					}
					if(frm_src.fields[i].apijs_clearGrid) {
						if(deleteGridsRows)
							frm_src.fields[i].apijs_deleteGrid();
						else
							frm_src.fields[i].apijs_clearGrid(clearReadonlyFields);
					}
				}
			}
		};
		
		this.getField = function(fld_name) {
			if(frm_src && frm_src.fields) {
				for(var i = 0; i < frm_src.fields.length; i++) {
					var current_name = frm_src.fields[i].options[IProperty.PROPERTY_NAME];
					if(current_name && current_name.toUpperCase() == fld_name.toUpperCase()) {
						return new ApiaField(frm_src.fields[i]);
					}
				}
			}
			throw new Error('Field ' + fld_name.toUpperCase() + ' not found.');
		};
		
		this.getAllFields = function() {
			var res = [];
			if(frm_src && frm_src.fields) {
				for(var i = 0; i < frm_src.fields.length; i++) {
					res.push(new ApiaField(frm_src.fields[i]));
				}
			}
			return res;
		};
		
		this.getFieldColumn = function(fld_name) {
			if(frm_src && frm_src.fields) {
				for(var i = 0; i < frm_src.fields.length; i++) {
					if(frm_src.fields[i].xml.getAttribute("fieldType") == Field.TYPE_GRID) {
						var column = frm_src.fields[i].apijs_getColumn(fld_name.toUpperCase());
						if(column.length > 0)
							return column;
					}
				}
			}
			return new Array();
		};
		
		this.getAttField = function(att_id) {
			if(frm_src && frm_src.fields) {
				for(var i = 0; i < frm_src.fields.length; i++) {
					if(frm_src.fields[i].attId == att_id) {
						return new ApiaField(frm_src.fields[i]);
					} else {
						if (frm_src.fields[i].gridColumns != null){
							for(var z = 0; z < frm_src.fields[i].gridColumns.length; z++) {
								if(frm_src.fields[i].gridColumns[z].length > 1 && frm_src.fields[i].gridColumns[z][1].attId == att_id) {
									var res = new Array();
									for(var j = 1; j < frm_src.fields[i].gridColumns[z].length; j++) {
										res.push(new ApiaField(frm_src.fields[i].gridColumns[z][j], true));
									}
									return res;
								}
							}
						}
					}
				}
			}
			return null;
		};
		
		this.getFormTitle = function() {
			if(frm_src) return frm_src.frmTitle;
			return '';
		};
		
		this.getFormName = function() {
			if(frm_src) return frm_src.frmName;
			return '';
		};
	}
});

var IProperty = {};
for (var key in Field) {
	if(Field.hasOwnProperty(key) && key.indexOf('PROPERTY_') == 0) {
		IProperty[key] = Field[key];
	}
}
for (var key in Form) {
	if(Form.hasOwnProperty(key) && key.indexOf('PROPERTY_') == 0) {
		IProperty[key] = Form[key];
	}
}

