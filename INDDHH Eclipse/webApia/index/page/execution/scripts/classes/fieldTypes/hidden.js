/**
 * Campo Hidden
 */
var Hidden = new Class({
	
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
		this.options[Field.PROPERTY_NAME] 				= null;//
		//this.options[Field.PROPERTY_TRANSIENT] 			= null;//
		//this.options[Field.PROPERTY_DISPLAY_NONE] 		= null;//
		this.options[Field.PROPERTY_CSS_CLASS]			= null;
	},
	
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
	
	getPrpsForGridReload: function() {
		return {};
	},
	
	/**
	 * Metodo de APIJS para establecer propiedades
	 */
	apijs_setProperty: function(prp_name, prp_value) {
		
		if(this.form.readOnly) return;
		
		//NOT SUPPORTED
		if(prp_name == Field.PROPERTY_CSS_CLASS) {
			var p;
			if(this.row_xml) {
				p = this.content.erase('class');
				p.addClass('visibility-hidden');
			} else {
				p = this.content.getParent().erase('class');
			}
			
			this.options[Field.PROPERTY_CSS_CLASS] = prp_value;
			if(this.options[Field.PROPERTY_CSS_CLASS])
				this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
					if(clase) p.addClass(clase);
				});
		}
	},
	
	/**
	 * Parsea el xml
	 */
	parseXML: function() {
				
		//Hace espacio en el formulario y ubica el campo en su lugar.
		this.parseXMLposition();

		//TODO: Field_PROPERTY_NAME
		//TODO: Field_PROPERTY_DISPLAY_NONE		
		
		//INPUT		
		var input = new Element('input', {
			fld_id: this.frmId + "_" + this.fldId,
			type: "hidden"
		});		
		
		if(this.xml.getAttribute(Field.PROPERTY_VALUE))
			input.set('value', this.xml.getAttribute(Field.PROPERTY_VALUE));
		
		input.inject(this.content);
		
		this.content.addClass('AJAXfield');
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
	},
	
	parseXMLforGrid: function(td_container, grid_index, isGridReadonly) {
		this.content = td_container;
		this.index = grid_index;
		
		this.updateProperties();
		
		this.content.addClass('visibility-hidden');
		
		//INPUT
		
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.addClass(clase);
			}.bind(this));
		
		var input = new Element('input', {
			type: "hidden"
		});	
		
		if(this.row_xml.getAttribute(Field.PROPERTY_VALUE))
			input.set('value', this.row_xml.getAttribute(Field.PROPERTY_VALUE));
		
		var div = new Element('div.gridMinWidth', {
			id: this.frmId + '_' + this.fldId + '_' + grid_index
		});
		
		input.inject(div);
		div.inject(this.content);
		
		div.store(Field.STORE_KEY_FIELD, this);
		div.addClass('AJAXfield');
		
		var multIdx = this.xml.getAttribute("multIdx");
		if(multIdx) {
			this.index = Number.from(multIdx);
		}
	},
	
	getPrintHTML: function(formContainer) {
	},
	
	getPrintHTMLForGrid: function() {
		return '';
	}
});