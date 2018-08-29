/** 
 * Interfaz para manejo de campos
 */
var Field = new Class({
	
	Implements: Options,
	
	options: {
		valueType: "S"
	},
	
	content: null,
	
	form: null,
	
	frmId: null,
	
	attId:  null,
	
	fldId: "",
	
	x: null,
	
	y: null,
	
	rows: null,
	
	cols: null,
	
	xml: null,
	
	index: 0,
	
	initialize: function(form, frmId, fldId, options, attId) {
		this.form = form;
		this.frmId = frmId;
		this.fldId = fldId;
		this.attId = attId;
		
		//Formulario en grilla editable
		if(this.form.isGridEditionForm)
			this.index = this.form.gridEditionIndex;
		
		
		this.setOptions(options);
		
		this.setBooleanOptions();
		
		if(this.options[Field.PROPERTY_FONT_COLOR] && this.options[Field.PROPERTY_FONT_COLOR].indexOf('#') < 0)
			this.options[Field.PROPERTY_FONT_COLOR] = '#' + this.options[Field.PROPERTY_FONT_COLOR];
		
		if(this.options[Field.PROPERTY_VALUE_COLOR] && this.options[Field.PROPERTY_VALUE_COLOR].indexOf('#') < 0)
			this.options[Field.PROPERTY_VALUE_COLOR] = '#' + this.options[Field.PROPERTY_VALUE_COLOR];
		
		//Formulario readonly
		//if(this.form.readOnly)
		//	this.options[Field.PROPERTY_READONLY] = true;
	},
	
	/**
	 * Se debe sobreescribir
	 */
	getValue: function() {
		return "";
	},
	
	/**
	 * Sobreescribir para escuchar cuando al formulario se le hace show
	 */
	showFormListener: function() {
		
	},
	
	/**
	 * Sobreescribir para escuchar cuando al formulario se le hace hide
	 */
	hideFormListener: function() {
		
	},
	
	booleanOptions: [],
	
	/**
	 * Corrige el valor de las opciones que son booleanas
	 */
	setBooleanOptions: function() {
		for(var i = 0; i < this.booleanOptions.length; i++) {
			var val = this.options[this.booleanOptions[i]];
			if(val && (val+"").toUpperCase().contains('T'))
				this.options[this.booleanOptions[i]] = true;
			else
				this.options[this.booleanOptions[i]] = false;
		}
	},
	
	/**
	 * Parsea el xml inicial colocando el campo en su lugar.
	 */
	parseXMLposition: function(auxContainer) {
		this.x = Number.from(this.xml.getAttribute("x"));
		this.y = Number.from(this.xml.getAttribute("y"));
		this.cols = Number.from(this.xml.getAttribute("cols"));
		this.rows = Number.from(this.xml.getAttribute("rows"));
		
		if(this.content == null) {
			this.content = new Element('div.field', {
				id: this.frmId + "_" + this.fldId
			}).addClass('exec_field');
			
			var td = $(this.frmId + "_gr_" + this.y + "_" + this.x);
			
			if(this.rows > 0) 
				td.set('rowSpan', this.rows);
			if(this.cols > 0) 
				td.set('colSpan', this.cols);
			
			this.content.inject(td);
			
			this.fixFormTable();
			
			this.content.store(Field.STORE_KEY_FIELD, this);
		}
	},
	
	/**
	 * Parsea el xml inicial colocando el campo en su lugar.
	 */
	parsePrintXMLposition: function(auxContainer) {
		
		var content = new Element('div.field', {
			id: this.frmId + "_" + this.fldId
		}).addClass('field' + this.form.cols).addClass("print_field");
					
		
		/*
		var tds = auxContainer.getElements('td');
		var td;
		if(tds) {
			for(var i = 0; i < tds.length; i++) {
				if(tds[i].get('id') == this.frmId + "_gr_" + this.y + "_" + this.x) {
					td = tds[i];
					break;
				}
			}
		}*/
		var td = findElementById(auxContainer, 'td', this.frmId + "_gr_" + this.y + "_" + this.x);
		
		if(!td) throw new Error('No se encontr� celda para el campo');
		
		if(this.rows > 0) 
			td.set('rowSpan', this.rows);
		if(this.cols > 0) 
			td.set('colSpan', this.cols);
		
		this.fixPrintFormTable(auxContainer);
		
		content.inject(td);
		
		return content;
	},
	
	/**
	 * Elimina los td's innecesarios del formulario
	 */
	fixFormTable: function(){

		if(this.rows > 0) {
			
			for(var r = 0; r < this.rows; r++) {
				if(this.cols > 0) {
					for(var c = 0; c < this.cols; c++) {
						if(r == 0 && c == 0)
							continue;
						var td_aux = document.getElementById(this.frmId + "_gr_" + (this.y + r) + "_" + (this.x + c));
						td_aux.parentNode.removeChild(td_aux);
					}
				} else {
					if(r == 0)
						continue;
					var td_aux = document.getElementById(this.frmId + "_gr_" + (this.y + r) + "_" + this.x);
					td_aux.parentNode.removeChild(td_aux);
				}
			}
		} else if(this.cols > 0){
			for(var c = 1; c < this.cols; c++) {
				var td_aux = document.getElementById(this.frmId + "_gr_" + this.y + "_" + (this.x + c));
				td_aux.parentNode.removeChild(td_aux);
			}
		}
	},
	
	fixPrintFormTable: function(auxContainer) {
		if(this.rows > 0) {
			for(var r = 0; r < this.rows; r++) {					
				if(this.cols > 0) {
					for(var c = 0; c < this.cols; c++) {
						if(r == 0 && c == 0) continue;
						//var td_aux = auxContainer.getElementById(this.frmId + "_gr_" + (this.y + r) + "_" + (this.x + c));
						var td_aux = findElementById(auxContainer, 'td', this.frmId + "_gr_" + (this.y + r) + "_" + (this.x + c));
						td_aux.parentNode.removeChild(td_aux);
					}
				} else {
					if(r == 0) continue;
					//var td_aux = auxContainer.getElementById(this.frmId + "_gr_" + (this.y + r) + "_" + this.x);
					var td_aux = findElementById(auxContainer, 'td', this.frmId + "_gr_" + (this.y + r) + "_" + this.x);
					td_aux.parentNode.removeChild(td_aux);
				}
			}
		} else if(this.cols > 0){
			for(var c = 1; c < this.cols; c++) {
				//var td_aux = auxContainer.getElementById(this.frmId + "_gr_" + this.y + "_" + (this.x + c));
				var td_aux = findElementById(auxContainer, 'td', this.frmId + "_gr_" + this.y + "_" + (this.x + c));
				td_aux.parentNode.removeChild(td_aux);
			}
		}
	},
	
	executeAjaxBinding: function() {
		var frmParent = this.frmId.split('_')[0];
		var frmId = this.frmId.split('_')[1];
		SynchronizeFields.syncJAVAexec(function() {
			new Request({
				url: 'apia.execution.FormAction.run?action=fireFieldEvent&isAjax=true&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + this.fldId + '&evtId=1&attId=' + this.attId + '&index=' + this.index  + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST,
				onSuccess: function(responseText, responseXML) {
					if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
						checkErrors(responseXML);
						var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
						if(response.tagName == 'result' && response.getAttribute('success'))
							SynchronizeFields.updateClientValues(response);
						else
							showMessage(ERR_EXEC_BINDING);
					} else {
						showMessage(ERR_EXEC_BINDING);
					}
					SYS_PANELS.closeLoading();
				},
				onFailure: function(xhr) { showMessage(ERR_EXEC_BINDING); }
			}).send();
		}.bind(this));
	},
	
	addTranslationIcon: function(input, icon_container) {
		if(!window.kb && this.form.frmType == 'E' && this.form.langs) {
			this.langIco = new Element('div.langIco').inject(icon_container ? icon_container : this.content);
			
			var add_checks = false;
			//Revisar si alguno tiene checkbox
			for(var lang_id in this.form.langs) {
				if(this.translations && this.translations[lang_id]) {
					add_checks = true;
					break;
				}
			}
			
			var lang_modals = {};
			for(var lang_id in this.form.langs) {
				if(this.translations && this.translations[lang_id])
					lang_modals['<div class="check"></div>' + this.form.langs[lang_id]] = this.showTranslationModal.bind(this).pass(lang_id);
				else if(add_checks)
					lang_modals['<div class="check-space"></div>' + this.form.langs[lang_id]] = this.showTranslationModal.bind(this).pass(lang_id);	
				else
					lang_modals[this.form.langs[lang_id]] = this.showTranslationModal.bind(this).pass(lang_id);	
			}
			
			this.langMenu = new ContextMenu(this.langIco, lang_modals, {event: 'click', position: 'left'});
		
			if(input.get('value') == '') {
				this.langIco.setStyle('display', 'none');
				this.langMenu.detach();
			}
		}
	},
	
	checkTranslationIconVisibility: function(input) {
		if(!window.kb && this.form.langs && this.langIco) {
			if(input.get('value') == '' && this.langIco.getStyle('display') != 'none') {
				this.langIco.setStyle('display', 'none');
				this.langMenu.detach();
			} else if(input.get('value') != '' && this.langIco.getStyle('display') == 'none') {
				this.langIco.setStyle('display', '');
				this.langMenu.attach(this.langIco);
			}
		}
	},
	
	refreshTranslationMenu: function() {
		if(!window.kb && this.form.langs && this.langIco) {
			
			if(this.langIco.getStyle('display') != 'none')
				this.langMenu.detach();
			
			this.langMenu.destroy();
			
			var add_checks = false;
			//Revisar si alguno tiene checkbox
			for(var lang_id in this.form.langs) {
				if(this.translations && this.translations[lang_id]) {
					add_checks = true;
					break;
				}
			}
			
			var lang_modals = {};
			for(var lang_id in this.form.langs) {
				if(this.translations && this.translations[lang_id])
					lang_modals['<div class="check"></div>' + this.form.langs[lang_id]] = this.showTranslationModal.bind(this).pass(lang_id);
				else if(add_checks)
					lang_modals['<div class="check-space"></div>' + this.form.langs[lang_id]] = this.showTranslationModal.bind(this).pass(lang_id);	
				else
					lang_modals[this.form.langs[lang_id]] = this.showTranslationModal.bind(this).pass(lang_id);	
			}
			
			this.langMenu = new ContextMenu(this.langIco, lang_modals, {event: 'click', position: 'left'});
			
			if(this.langIco.getStyle('display') == 'none')
				this.langMenu.detach();
		}
	}
});

//Tipos de campos 
Field.TYPE_INPUT 	= "input";
Field.TYPE_SELECT 	= "select";
Field.TYPE_RADIO	= "radio";
Field.TYPE_CHECK	= "check";
Field.TYPE_BUTTON	= "button";
Field.TYPE_AREA		= "area";
Field.TYPE_LABEL	= "label";
Field.TYPE_TITLE	= "title";
Field.TYPE_FILE		= "file";
Field.TYPE_MULTIPLE	= "multiple";
Field.TYPE_HIDDEN	= "hidden";
Field.TYPE_PASSWORD	= "password";
Field.TYPE_GRID		= "grid";
Field.TYPE_IMAGE	= "image";
Field.TYPE_HREF		= "href";
Field.TYPE_EDITOR	= "editor";
Field.TYPE_TREE		= "tree";

//Funciones de campos
Field.FUNC_CLICK		= "onclick";
Field.FUNC_CHANGE		= "onchange";
Field.FUNC_MODAL_RETURN	= "onmodalreturn";

Field.FUNC_ROW_ADD		= "onrowadd";
Field.FUNC_ROW_DELETE	= "onrowdelete";
Field.FUNC_ROW_SORT		= "onrowsort";
Field.FUNC_COL_SELECT	= "oncolselect";

//Attribute con propiedades json para campos
Field.FIELD_PROPERTIES	= "properties";

//Propiedades de campos
Field.PROPERTY_NAME						= "name";
Field.PROPERTY_SIZE						= "size"; /*Cantidad de pixeles*/
Field.PROPERTY_READONLY 				= "readonly";
Field.PROPERTY_DISABLED 				= "disabled";
Field.PROPERTY_FONT_COLOR 				= "fontColor";
Field.PROPERTY_VALUE 					= "value";
Field.PROPERTY_REQUIRED 				= "required";
Field.PROPERTY_COLSPAN 					= "colspan";
Field.PROPERTY_ROWSPAN 					= "rowspan";
Field.PROPERTY_MODAL 					= "modal";
Field.PROPERTY_ROWS 					= "fieldRows";
Field.PROPERTY_BOLD 					= "bold";
Field.PROPERTY_UNDERLINED 				= "underlined";
Field.PROPERTY_ALIGNMENT 				= "alignment";
Field.PROPERTY_IMAGE 					= "imageUrl";
Field.PROPERTY_COL_WIDTH 				= "colWidth";
Field.PROPERTY_GRID_HEIGHT 				= "gridHeight";
Field.PROPERTY_HIDE_GRID_BTN			= "hideGridButtons";
Field.PROPERTY_VISIBILITY_HIDDEN		= "visibilityHidden";
Field.PROPERTY_TRANSIENT 				= "transient";
Field.PROPERTY_GRID_TITLE 				= "gridTitle";
Field.PROPERTY_TOOLTIP 					= "tooltip";
Field.PROPERTY_VALUE_COLOR 				= "valueColor";
Field.PROPERTY_GRID_FORM 				= "gridForm";
Field.PROPERTY_INPUT_AS_TEXT			= "inputAsText";
Field.PROPERTY_NO_DOWNLOAD 				= "noDownload";
Field.PROPERTY_NO_ERASE					= "noErase";
Field.PROPERTY_NO_LOCK 					= "noLock";
Field.PROPERTY_NO_HISTORY 				= "noHistory";
Field.PROPERTY_NO_MODIFY 				= "noModify";
Field.PROPERTY_HIDE_SIGN_ICONS 			= "hideSignButtons";
Field.PROPERTY_URL 						= "url";
Field.PROPERTY_GRID_HIDE_BTN_ORDER 		= "hideOrderButton";
Field.PROPERTY_GRID_HIDE_BTN_INCLUDE	= "hideIncludeButton";
Field.PROPERTY_REGEXP_MESSAGE 			= "regExpMessage";
Field.PROPERTY_PAGED_GRID 				= "paged";
Field.PROPERTY_PAGED_GRID_SIZE 			= "pagedGridSize";
Field.PROPERTY_GRID_ALTER_IN_LAST_PAGE 	= "alterOnlyLastPage";
Field.PROPERTY_GRID_PRINT_HORIZONTAL 	= "printHorizontal";
Field.PROPERTY_STORE_MODAL_QUERY_RESULT	= "storeMdlQryResult";
Field.PROPERTY_INCLUDE_FIRST_ROW		= "includeFirstRow";
//		PROPERTY_GRID_NOT_VERIFY_REQ_SERVER
Field.PROPERTY_MAX_REG_GRID 			= "maxRecords";
//		PROPERTY_PERMITED_FILE_TYPES
//		PROPERTY_FORBIDDEN_FILE_TYPES
//		PROPERTY_RADIOBUTTON_DONT_BREAK_LINE
Field.PROPERTY_GRID_LABEL				= "gridColTitle";
Field.PROPERTY_GRID_QUERY				= "gridQuery";
Field.PROPERTY_HIDE_DOC_PERMISSIONS 	= "hideDocPermissions";
Field.PROPERTY_VERIFY_SIGNATURE_ONLY 	= "verifySignatureOnly";
Field.PROPERTY_GRID_HIDE_BTN_ADD 		= "hideAddButton";
Field.PROPERTY_GRID_HIDE_BTN_DEL 		= "hideDelButton";
Field.PROPERTY_HIDE_DOC_UPLOAD 			= "hideDocUpload";
Field.PROPERTY_HIDE_DOC_DOWNLOAD 		= "hideDocDownload";
Field.PROPERTY_HIDE_DOC_ERASE 			= "hideDocErase";
Field.PROPERTY_HIDE_DOC_LOCK 			= "hideDocLock";
Field.PROPERTY_HIDE_DOC_HISTORY 		= "hideDocHistory";
Field.PROPERTY_HIDE_DOC_SIGN 			= "hideSignButtons";
Field.PROPERTY_DISPLAY_NONE 			= "displayNone";
Field.PROPERTY_DONT_BREAK_RADIO			= "dontBreakRadio";
Field.PROPERTY_CHECKED					= "checked";
Field.PROPERTY_FILE_PREVIEW				= "filePreview";

Field.PROPERTY_HEIGHT					= "height"
Field.PROPERTY_MULTISELECT				= "multiselect";
Field.PROPERTY_SEL_PARENT				= "selParent";
Field.PROPERTY_PARENT_ICON				= "parentIcon";
Field.PROPERTY_LEAF_ICON				= "leafIcon";
Field.PROPERTY_CSS_CLASS				= "cssClass";
Field.PROPERTY_DOC_TYPE					= "docType";

Field.PROPERTY_HIDE_DOC_METADATA		= "hideDocMetadata";
Field.PROPERTY_TRANSLATION_REQUIRED		= "reqTrad";

//Mensajes de error
Field.WRONG_ATT_TYPE_ERROR		= "Component does not support attributes of type <TOK>. Contact system administrator";


//Keys almacenadas en los campos
Field.STORE_KEY_FIELD			= 'field';
Field.STORE_KEY_FORM			= 'form';

Field.WAITTIME_FOR_GRID_SPINNER			= 100; //ms

/**
 * Cambia los TOK por valores string. Es invocable a partir de varios argumentos
 * @returns String
 */
Field.formatMsg = function(msg) {
	var msg_split = msg.split("<TOK>");
	var res = msg_split[0];
	for(var i = 1; i < arguments.length; i++) {
		if(arguments[i]) {
			res += arguments[i];
		}
		if(msg_split[i])
			res += msg_split[i];
	}
	for(; i < msg_split.length; i++) {
		res += msg_split[i];
	}
	return res;
}


/**
 * Clase para que implementen los campos de grillas
 */
var GridField = new Class({
	
	gridHeader: null,
	index: 0,
	
	apijs_getParentGrid: function() {
		return new ApiaField(this.gridHeader.parentGrid);
	},
	
	apijs_getNext: function() {
		var col_index = this.apijs_getColIndex();
		var cols = this.gridHeader.parentGrid.gridColumns;
		if(cols.length > col_index + 1)
			return new ApiaField(cols[col_index + 1][this.index + 1], true);
	},
	
	apijs_getPrevious: function() {
		var col_index = this.apijs_getColIndex();
		var cols = this.gridHeader.parentGrid.gridColumns;
		if(col_index > 0)
			return new ApiaField(cols[col_index - 1][this.index + 1], true);
	},
	
	apijs_getColIndex: function() {
		return Number.from(this.gridHeader.col_index);
	},
	
	/**
	 * Actualiza las propiedades del campo con las que se almacenan en la grilla, previo a sus eventos
	 */
	updateProperties: function() {
		if(this.gridHeader.parentGrid.prps) {
			var col_prps = this.gridHeader.parentGrid.prps[this.fldId];
			if(col_prps) {
				var field_prps = col_prps[this.index];
				if(field_prps) {
					for (var prp in field_prps) {
						this.options[prp] = field_prps[prp];
					}
				}
			}
		}
		if(this.gridHeader.parentGrid.ajaxBusClassExecuting) {
			var opts = JSON.decode(this.row_xml.getAttribute(Field.FIELD_PROPERTIES));
			for (var opt in opts) {
				this.options[opt] = opts[opt];
			}
			this.setBooleanOptions();
		}
	}
});

function findElementById(father, type, id) {
	var elements = father.getElements(type);
	if(elements) {
		for(var i = 0; i < elements.length; i++) {
			if(elements[i].get('id') == id) {
				return elements[i];
			}
		}
	}
}
