/**
 * Campo Grid
 */
var Grid = new Class({
	
	Extends: Field,
	
	gridColumns: null,
	
	tr_selected: null,
	
	index_selected: null, 
	
	max_index: 0,
	
	hor_scroll: null,
	
	ver_scroll: null,
	
	startIndex: 0,
	
	currentPage: 0,
	
	pages: 0,
	
	spinner: null,
	
	exec_ajax_call: false,
	
	contextmenu: null,
	
	editionTable: null,
	
	divBody: null,
	
	divFooter: null,
	
	prps: {},
	
	btnSource: null,
	
	initialize: function(form, frmId, xml) {
		//Establecer las opciones
		this.setDefaultOptions();		
		this.parent(form, frmId, xml.getAttribute("id"), JSON.decode(xml.getAttribute(Field.FIELD_PROPERTIES)));
		
		this.xml = xml;
		this.parseXML();
	},
	
	setDefaultOptions: function() {
		this.options[Field.PROPERTY_NAME] 						= null;
		this.options[Field.PROPERTY_READONLY] 					= null;
		this.options[Field.PROPERTY_VISIBILITY_HIDDEN]		 	= null;		
		//this.options[Field.PROPERTY_DISPLAY_NONE] 				= null;
		
		this.options[Field.PROPERTY_GRID_TITLE] 				= null;
		this.options[Field.PROPERTY_GRID_HEIGHT] 				= null;

		this.options[Field.PROPERTY_HIDE_GRID_BTN] 				= null;
		this.options[Field.PROPERTY_GRID_HIDE_BTN_ORDER] 		= null;
		this.options[Field.PROPERTY_GRID_HIDE_BTN_INCLUDE] 		= null;
		this.options[Field.PROPERTY_GRID_HIDE_BTN_ADD] 			= null;
		this.options[Field.PROPERTY_GRID_HIDE_BTN_DEL] 			= null;

		this.options[Field.PROPERTY_PAGED_GRID] 				= null;
		this.options[Field.PROPERTY_GRID_ALTER_IN_LAST_PAGE]	= null; //TODO
		this.options[Field.PROPERTY_PAGED_GRID_SIZE]			= 5;
		
		this.options[Field.PROPERTY_GRID_FORM]					= null;
		this.options[Field.PROPERTY_GRID_QUERY]					= null;

		this.options[Field.PROPERTY_INCLUDE_FIRST_ROW]			= null; //read-only
		this.options[Field.PROPERTY_MAX_REG_GRID]				= null;
		
		this.options[Field.PROPERTY_CSS_CLASS]					= null;
	},
	
	booleanOptions: [Field.PROPERTY_READONLY, Field.PROPERTY_VISIBILITY_HIDDEN, Field.PROPERTY_HIDE_GRID_BTN,
	                 Field.PROPERTY_GRID_HIDE_BTN_ORDER, Field.PROPERTY_GRID_HIDE_BTN_INCLUDE, Field.PROPERTY_GRID_HIDE_BTN_ADD,
	                 Field.PROPERTY_GRID_HIDE_BTN_DEL, Field.PROPERTY_PAGED_GRID, Field.PROPERTY_GRID_ALTER_IN_LAST_PAGE,
	                 Field.PROPERTY_INCLUDE_FIRST_ROW],
	
	required_fields_aux: null,
	
	/**
	* Metodo de APIJS para establecer propiedades
	*/
	apijs_setProperty: function(prp_name, prp_value) {
		var prp_boolean_value;
		if(prp_value == true || prp_value == "T")
			prp_boolean_value = true;
		else if(prp_value == false || prp_value == "F")
			prp_boolean_value = false;
		
		if(prp_name == Field.PROPERTY_VISIBILITY_HIDDEN) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN] == false) {
				this.content.addClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = true;
				//Si alguno de los hijos son requeridos, hay que desregistrarlos
				if(!this.required_fields_aux)
					this.required_fields_aux = new Array();
				for(var i = 0; i < this.gridColumns.length; i++) {
					for(var j = 1; j < this.gridColumns[i].length; j++) {
						var field = this.gridColumns[i][j];
						if(field.options[Field.PROPERTY_REQUIRED]) {
							//Usamos la funci�n gen�rica
							if(field.apijs_setProperty) {
								//Agregarlo a la lista de campos que eran requeridos
								this.required_fields_aux.push(field);
								try {
									field.apijs_setProperty(Field.PROPERTY_REQUIRED, false);
								} catch(error) {
									if(window.console && console.log) console.log(error.message);
								}
							}	
						}
					}
				}
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				//Verificar si alguno de los hijos es requerido
				if(this.required_fields_aux) {
					var field = this.required_fields_aux.shift();
					while(field) {
						field.apijs_setProperty(Field.PROPERTY_REQUIRED, true);
						field = this.required_fields_aux.shift();
					}
				}
				this.content.removeClass('visibility-hidden');
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = false;
			}
		} else if(prp_name == Field.PROPERTY_CSS_CLASS) {
			var p = this.content.getParent().erase('class');
			this.options[Field.PROPERTY_CSS_CLASS] = prp_value;
			if(this.options[Field.PROPERTY_CSS_CLASS])
				this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
					if(clase) p.addClass(clase);
				});
		}
	},
	             	
	getFormCantCols: function() {
		
		var total = 0;
		this.content.getParent().getParent().getChildren().get('colSpan').each(function(colspan) {
			total+=colspan;
		});
		
		return total;
	},
	
	/**
	 * Muestra la mascara para evitar la edicion
	 */
	showSpinner: function(noFx) {
		if(!this.spinner)
			this.spinner = new Spinner(this.content);
		this.spinner.show(noFx);
		this.spinner.content.getParent().setStyle('width', this.content.getElement('div.gridHeader').getWidth());
	},
	
	/**
	 * Oculta la mascara para permitir la edicion
	 */
	hideSpinner: function(noFx) {
		this.spinner.hide(noFx);
	},
	
	/**
	 * Parsea el xml
	 */
	parseXML: function(redrawing, new_row_xml) {
		
		if(!redrawing) {
			//Hace espacio en el formulario y ubica el campo en su lugar.
			this.parseXMLposition();
			if(Browser.ie7)
				this.content.addClass('ie7');
			else
				this.content.addClass('no-ie7');
			
			window.addEvent('resize', this.window_resized.bind(this));
			
			if(this.options[Field.PROPERTY_CSS_CLASS])
				this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
					if(clase) this.content.getParent().addClass(clase);
				}.bind(this));
			
		} else {
			if(this.contextmenu)
				this.contextmenu.detach();
			
			var p = this.content.getParent().erase('class');
			if(this.options[Field.PROPERTY_CSS_CLASS])
				this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
					if(clase) p.addClass(clase);
				});
		}
		
		if(new_row_xml) {
			//Solo agregar fila al final
			
			var tr_index = this.max_index;
			this.max_index++;
			
			var tr = new Element('tr.selectableTR');
			if(tr_index % 2 == 1)
				tr.addClass('trOdd');
			
			//Siempre poner el foco en la nueva fila
//			var trs = this.divBody.getElement('tbody').getChildren('tr');
//			if(trs)
//				trs.each(function(item) {
//					item.removeAttribute('tabIndex');
//				});
			
			tr.set('tabIndex');
			
			var focus_set = false;
			(this.xml.childNodes.length - 1).times(function(td_index) {
				var td = new Element('td');
				
				var field_xml = new_row_xml.childNodes[td_index + 1];
				if(field_xml && field_xml.nodeName == Grid.tags.gridField) {
					
					var fieldType = field_xml.getAttribute("fieldType");
					var row_xml = field_xml.childNodes[0];
					
					if(!row_xml)
						row_xml = field_xml;
					
					var field;
					switch (fieldType) {
						case Field.TYPE_INPUT:
							field = new Input(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_SELECT:
							field = new Select(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_BUTTON:
							field = new Button(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_CHECK:
							field = new Check(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_PASSWORD:
							field = new Password(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_LABEL:
							field = new Label(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_HIDDEN:
							field = new Hidden(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_HREF:
							field = new Href(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_IMAGE:
							field = new Image(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_FILE:
							field = new Fileinput(this.form, this.frmId, field_xml, row_xml);
							break;
					}
					
					if(field) {
						field.gridHeader = this.gridColumns[td_index][0];
						this.gridColumns[td_index][0].col_fields.push(field);
						this.gridColumns[td_index].push(field);
						
						field.parseXMLforGrid(td, this.startIndex + tr_index, this.options[Field.PROPERTY_READONLY]);
						
						//Corregir visibilidad
						this.gridColumns[td_index][0].fixVisibility(field);
						
						if(!focus_set && field.apijs_setFocus)
							focus_set = field;
					}
				}
				td.inject(tr);
			}.bind(this));
			
			tr.addEvent('click', function(event) {
				if(event.control)
					this.addToSelectRows(tr, tr_index + this.startIndex);
				else
					this.selectRow(tr, tr_index + this.startIndex);
			}.bind(this));
			
			this.addTrKeyListener(tr);
			
			if(this.editionTable) {
				
				this.divBody.addClass('editable-gridBody');
				
				var this_grid = this;
				var edition_index = tr_index + this.startIndex;
				var edit_button = new Element('div.editable-row', {tabindex:''}).inject(this.editionTable).addEvents({
					mouseover: function(e) {
						this.addClass('editable-row-hover');
						tr.addClass('selectableTR-hover');
					},
					mouseout: function(e) {
						this.removeClass('editable-row-hover');
						this.removeClass('editable-row-pressed');
						tr.removeClass('selectableTR-hover');
					},
					mousedown: function(e) {
						this.addClass('editable-row-pressed');
					},
					mouseup: function(e) {
						this.removeClass('editable-row-pressed');
					},
					click: function(e) {
						var modal = ModalController.openWinModalAGESIC(CONTEXT + '/apia.execution.FormAction.run?action=editGrid' + '&frmName=' + this_grid.options[Field.PROPERTY_GRID_FORM] + '&frmParent=' + this_grid.frmId.split('_')[0] + '&editionMode=true' + (this_grid.options[Field.PROPERTY_READONLY] ? '&ro=true' : '') + '&index=' + edition_index + TAB_ID_REQUEST, 640, 600, null, null, true, false, true);
						modal.addEvent('confirm', this_grid.refreshGrid.bind(this_grid));
					},
					keydown: function(e) {
						if (e && e.key == 'enter') this.fireEvent('click');
					}
				});				
				
				if(tr.hasClass('trOdd'))
					edit_button.addClass('editable-row-odd');
				
				tr.addEvents({
					mouseover: function(e) {
						edit_button.addClass('editable-row-hover');
					},
					mouseout: function(e) {
						edit_button.removeClass('editable-row-hover');
					}
				});
			}
			
			tr.inject(this.divBody.getElement('tbody'));
			
			if(this.editionTable) {
				//Posicionar la tabla de edicion
				
				this.editionTable.setStyles({
					height: this.divBody.getStyle('height'),
					overflow: 'hidden'
				});
				
//				var pos = this.divBody.getPosition();
//				
//				this.editionTable.setStyles({
//					top: pos.y - 2,
//					//left: pos.x - Number.from(this.editionTable.getStyle('width'))
//					left: pos.x - Generic.getHiddenWidth(this.editionTable)
//				});
				
				this.editionTable.position({
				    relativeTo: this.divBody,
				    position: 'upperLeft',
				    edge: 'upperRight'
				});
				
				var rowHeights;
//				if(Browser.opera)
					rowHeights = this.divBody.getElements('tr').getHeight();
//				else
//					rowHeights = this.divBody.getElements('tr').getStyle('height');
				
				this.editionTable.getChildren().each(function(div, i) {
					div.setStyle('height', rowHeights[i]);
				});
				
				this.form.form_tab_parent.addFormCollapseListener(this.handleFormMove.bind(this));
				
				if(this.form.form_tab_parent.tabTitle)
					this.form.form_tab_parent.tabTitle.addEvent('focus', this.handleTabFocus.bind(this));
				else
					this.form.form_tab_parent.contentTab.tabTitle.addEvent('focus', this.handleTabFocus.bind(this));
			}
			
			if(!this.options[Field.PROPERTY_READONLY] && redrawing)
				this.contextmenu.attach(this.divBody);
			
			if(this.hor_scroll || this.ver_scroll) {
				var divHeader = this.content.getElement('div.gridHeader');
				if(!Browser.ie)
					divHeader.scrollTo(0, 0);
				this.content.getElement('div.gridBody').scrollTo(this.hor_scroll, this.ver_scroll);
				if(Browser.ie7)
					divHeader.scrollTo(this.hor_scroll, 0);
				else
					divHeader.setStyle('left', - this.hor_scroll);
			}
			
			if(focus_set)
				focus_set.apijs_setFocus();
					
			this.tableBody.setStyle('width', '');
			
			return;
		}
		
		this.content.set('html', '');
		
		this.content.addClass('gridContainer');
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		else 
			this.content.removeClass('visibility-hidden');
		
		if(this.options[Field.PROPERTY_PAGED_GRID]) {
			this.startIndex = Number.from(this.xml.getAttribute('startIndex'));
		}
		
		if(this.options[Field.PROPERTY_GRID_TITLE]) {
			new Element('span.labelTitle', {
				text: this.options[Field.PROPERTY_GRID_TITLE]
			}).inject(new Element('div.gridTitle').inject(this.content));
		}
		
		if(this.form.readOnly)
			this.options[Field.PROPERTY_READONLY] = true;
		
		if(this.options[Field.PROPERTY_GRID_QUERY])
			this.options[Field.PROPERTY_HIDE_GRID_BTN] = true;
		
		//var total_width = Window.getWidth() - this.form.getParent().getStyle('padding-left').toInt() * 2;
		//En IE, el offseWidth del parent.parent a veces no tiene tiempo de ajustarse. ver de obtener el ancho de otra manera.
		var total_width;
		if(Browser.ie8) {
			var body = $(document.body);
			while(body.offsetWidth == 0) {  } //No se termino de dibujar el body todavia...
			total_width = body.offsetWidth - this.form.DOMform.getParent().getStyle('padding-left').toInt() * 2;
		} else {
			total_width = this.form.DOMform.getParent().getParent().getParent().offsetWidth - this.form.DOMform.getParent().getStyle('padding-left').toInt() * 2;
		}
		
		var grid_width = total_width / this.getFormCantCols();
		
		if(this.cols > 0)
			grid_width = this.cols * grid_width;
		
		if(this.options[Field.PROPERTY_GRID_FORM]) {
			
			var tdParent = this.content.getParent();
			var tdParentId = tdParent.get('id').split('_');
			if(tdParentId[tdParentId.length - 1] != '0') {
				this.content.getParent().setStyle('padding-left', '28px');

				grid_width -= 28;
			}
		}
			
		
		var divHeader = new Element('div.gridHeader').setStyles({
			width: grid_width, //-17
			overflow: 'hidden'
		});
		
		var tableTitle = this.options[Field.PROPERTY_GRID_TITLE];
		if (!tableTitle){
			tableTitle = this.form.frmTitle;
		}
		
		var tableHeader = new Element('table', {title: tableTitle}).inject(divHeader);
		tableHeader.setAttribute('aria-labelledby', this.form.id+"_gr_"+this.y+"_"+this.x);
		
		var divBody = new Element('div.gridBody').setStyles({
			width: grid_width,
			height: this.options[Field.PROPERTY_GRID_HEIGHT] ? Number.from(this.options[Field.PROPERTY_GRID_HEIGHT]) : 200, //TODO: Definir el alto por defecto de la grilla
			overflow: 'auto'
		});
		
		this.divBody = divBody;
		
		var tableBody = new Element('table', {title: tableTitle}).inject(divBody);
		tableBody.setAttribute('aria-labelledby', this.content.id);
		
		this.tableBody = tableBody;
		
		if(this.options[Field.PROPERTY_GRID_FORM]) {
			//Grilla editable
			if(this.editionTable) {
				//Borrar la anterior
				this.editionTable.destroy();
			}
			this.editionTable = new Element('div.editable-table').setStyles({				
				position: 'absolute',
				top: '100px',
				left: '100px'
			});	
			//this.editionTable.inject(document.body);
			this.editionTable.inject(this.content);
			
//			var tdParent = this.content.getParent();
//			var tdParentId = tdParent.get('id').split('_');
//			if(tdParentId[tdParentId.length - 1] != '0')
//				this.content.getParent().setStyle('padding-left', '28px');
		}
		
		this.max_index = 0;
		
		var tableHeader_html = "";
		var tableHeader_row = new Element('tr');
		
		this.gridColumns = new Array();
		
		var fn_col_select;
//		if(this.xml.getAttribute(Field.FUNC_COL_SELECT) && !window.editionMode)
		if(this.xml.getAttribute(Field.FUNC_COL_SELECT))
			fn_col_select = window[this.xml.getAttribute(Field.FUNC_COL_SELECT)];
		
		if(this.xml.childNodes[0].nodeName == Grid.tags.gridHeader) {
			Array.from(this.xml.childNodes[0].childNodes).each(function(col_xml, col_index) {
				if(col_xml.nodeName == Grid.tags.gridHeaderCol) {
					
					var col_tooltip = "";
					if(col_xml.getAttribute('title'))
						col_tooltip = col_xml.getAttribute("title");
					
					var col_title = "";
					if(col_xml.getAttribute('colTitle'))
						col_title = col_xml.getAttribute("colTitle");
					
					var col_fld_id = "";
					if(col_xml.getAttribute('fldId'))
						col_fld_id = col_xml.getAttribute("fldId");
					
					var th = new Element('th');
					var gridColHeader = new GridHeader(th, col_title, col_tooltip,this.xml.childNodes[col_index + 1].getAttribute('fieldType'), JSON.decode(this.xml.childNodes[col_index + 1].getAttribute('properties')), fn_col_select, this.exec_ajax_call);
					gridColHeader.col_fld_id = col_fld_id;
					th.inject(tableHeader_row);
					
					this.gridColumns.push(new Array());
					this.gridColumns[col_index].push(gridColHeader);
					gridColHeader.parentGrid = this;
					gridColHeader.col_index = col_index;
				}
			}.bind(this));
			
			for(var i = 1; i < this.xml.childNodes.length; i++) {
				if(this.xml.childNodes[i].nodeName == Grid.tags.gridField) {
					if(this.xml.childNodes[i].childNodes.length > this.max_index)
						this.max_index = this.xml.childNodes[i].childNodes.length;
				}
			}
		} else {
			throw new Error('Grid field without gridHeader');
		}
		
		var thead = new Element('thead').inject(tableHeader);
		tableHeader_row.inject(thead);
		
		var tableBody_html = "";
		this.max_index.times(function(i) {
			
			tableBody_html += "<tr class='selectableTR";
			if(i % 2 == 1)
				tableBody_html += " trOdd";
			tableBody_html += "'";
			
//			if(i == 0)
				tableBody_html += " tabIndex='0'";
			
			tableBody_html += 	">";
			
			//tableBody_html += "<tr class='selectableTR'>";
			
			(this.xml.childNodes.length - 1).times(function() {tableBody_html += "<td></td>";});
			
		}.bind(this));
		
		tableBody.set('html', '<tbody class="tableData">' + tableBody_html + '</tbody>');
		
		var do_set_focus = false;
		if(this.aux_focus_set == null)
			do_set_focus = true;
		
		//Se recorre la grilla, creando fields seg�n corresponda
		divBody.getElements('tr').each(function(tr, tr_index) {
			tr.addEvent('click', function(event) {
				if(event.control)
					this.addToSelectRows(tr, tr_index + this.startIndex);
				else
					this.selectRow(tr, tr_index + this.startIndex);
			}.bind(this));
			
			this.addTrKeyListener(tr);
			
			if(do_set_focus)
				this.aux_focus_set = null;
			
			tr.getElements('td').each(function(td, td_index) {
				var field_xml = this.xml.childNodes[td_index + 1];
				if(field_xml && field_xml.nodeName == Grid.tags.gridField) {
					
					var fieldType = field_xml.getAttribute("fieldType");
					var row_xml = field_xml.childNodes[tr_index];
					
					if(!row_xml)
						row_xml = field_xml;
					
					var field;
					switch (fieldType) {
						case Field.TYPE_INPUT:
							field = new Input(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_SELECT:
							field = new Select(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_BUTTON:
							field = new Button(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_CHECK:
							field = new Check(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_PASSWORD:
							field = new Password(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_LABEL:
							field = new Label(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_HIDDEN:
							field = new Hidden(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_HREF:
							field = new Href(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_IMAGE:
							field = new Image(this.form, this.frmId, field_xml, row_xml);
							break;
						case Field.TYPE_FILE:
							field = new Fileinput(this.form, this.frmId, field_xml, row_xml);
							break;
					}
					
					if(field) {
						field.gridHeader = this.gridColumns[td_index][0];
						this.gridColumns[td_index][0].col_fields.push(field);
						this.gridColumns[td_index].push(field);
						
						field.parseXMLforGrid(td, this.startIndex + tr_index, this.options[Field.PROPERTY_READONLY]);
						
						if(!this.aux_focus_set && field.apijs_setFocus)
							this.aux_focus_set = field;
					}
				}
			}.bind(this));
			
			if(this.editionTable) {
				
				divBody.addClass('editable-gridBody');
				
				var this_grid = this;
				var edition_index = tr_index + this.startIndex;
				var edit_button = new Element('div.editable-row', {tabindex:''}).inject(this.editionTable).addEvents({
					mouseover: function(e) {
						this.addClass('editable-row-hover');
						tr.addClass('selectableTR-hover');
					},
					mouseout: function(e) {
						this.removeClass('editable-row-hover');
						this.removeClass('editable-row-pressed');
						tr.removeClass('selectableTR-hover');
					},
					mousedown: function(e) {
						this.addClass('editable-row-pressed');
					},
					mouseup: function(e) {
						this.removeClass('editable-row-pressed');
					},
					click: function(e) {
						var modal = ModalController.openWinModalAGESIC(CONTEXT + '/apia.execution.FormAction.run?action=editGrid' + '&frmName=' + this_grid.options[Field.PROPERTY_GRID_FORM] + '&frmParent=' + this_grid.frmId.split('_')[0] + '&editionMode=true' + (this_grid.options[Field.PROPERTY_READONLY] ? '&ro=true' : '') + '&index=' + edition_index + TAB_ID_REQUEST, 640, 600, null, null, true, false, true);
						modal.addEvent('confirm', this_grid.refreshGrid.bind(this_grid));
					},
					keydown: function(e) {
						if (e && e.key == 'enter') this.fireEvent('click');
					}
				});				
				
				if(tr_index % 2 == 1)
					edit_button.addClass('editable-row-odd');
				
				tr.addEvents({
					mouseover: function(e) {
						edit_button.addClass('editable-row-hover');
					},
					mouseout: function(e) {
						edit_button.removeClass('editable-row-hover');
					}
				});
			}
			
		}.bind(this));
		
		//DOMfooter
		
		var divFooter = new Element('div.gridFooter').setStyle('width', grid_width);
		
		this.divFooter = divFooter;
		
		//var nav_buttons = "";
		//var nav_buttons_options = "";

		if(this.options[Field.PROPERTY_PAGED_GRID]) {
			this.currentPage = 1;
			this.pages = 1;
			
			if(this.xml.getAttribute('curPage'))
				this.currentPage = Number.from(this.xml.getAttribute('curPage'));
			
			if(this.xml.getAttribute('pages'))
				this.pages = Number.from(this.xml.getAttribute('pages'));
			
			var nav_buttons = new Element('div.navButtons').set('html',
					'<div class="pGroup"><div class="btnFirst pButton"></div><div class="btnPrev pButton"></div></div>' + 
					'<div class="pGroup"><input class="navBarCurrentPage" type="text" value="' + this.currentPage + '" size="2"><span class="navBarPageCount">de ' + this.pages + '</span></div>' + 
					'<div class="pGroup"><div class="btnNext pButton"></div><div class="btnLast pButton"></div></div>');
			
			nav_buttons.inject(divFooter);
			
			nav_buttons.getElements('.btnFirst').addEvent('click', function() {
				this.navPage('first');
			}.bind(this));
			nav_buttons.getElements('.btnPrev').addEvent('click', function() {
				this.navPage('prev');
			}.bind(this));
			nav_buttons.getElements('.btnNext').addEvent('click', function() {
				this.navPage('next');
			}.bind(this));
			nav_buttons.getElements('.btnLast').addEvent('click', function() {
				this.navPage('last');
			}.bind(this));
			
			nav_buttons.getElements('.navBarCurrentPage').addEvents({
				keyup: function(event) {
					if(event && event.key == 'enter') {
						var value = Number.from(event.target.get('value'));
						if(value && value <= this.pages && value != this.currentPage) {
							this.navPage('gotopage&page=' + value);
						} else { 
							event.target.set('value', this.currentPage);
							event.target.selectRange(0, event.target.get('value').length);
						}
					}
				}.bind(this),
				change: function(event) {
					if(event) {
						var value = Number.from(event.target.get('value'));
						if(value && value <= this.pages && value != this.currentPage) {
							this.navPage('gotopage&page=' + value);
						} else { 
							event.target.set('value', this.currentPage);
							event.target.selectRange(0, event.target.get('value').length);
						}
					}
				}.bind(this),
				click: function(event) {
					if(event)
						event.target.selectRange(0, event.target.get('value').length);
				}
			});
		}
		
		if(!this.options[Field.PROPERTY_HIDE_GRID_BTN] && !this.options[Field.PROPERTY_READONLY]) {
			var nav_buttons_options = new Element('div.gridButtons');
			
			if(!this.options[Field.PROPERTY_GRID_HIDE_BTN_INCLUDE]) {
				if(!this.options[Field.PROPERTY_GRID_HIDE_BTN_DEL]) {
					//var btnEliminar = new Element('div.gridButton', {'html': GRID_BTN_DELETE}).setStyle('width', '50px').inject(nav_buttons_options);
					var btnEliminar = new Element('div.gridButton.btnEliminar', {'html': GRID_BTN_DELETE, tabIndex: ''}).inject(nav_buttons_options);
					Generic.setAdmGridBtnWidth(btnEliminar);
					
					var fn_row_delete;
//					if(this.xml.getAttribute(Field.FUNC_ROW_DELETE) && !window.editionMode)
					if(this.xml.getAttribute(Field.FUNC_ROW_DELETE))
						fn_row_delete = window[this.xml.getAttribute(Field.FUNC_ROW_DELETE)];
					
					var allAjaxRowDelete = this.xml.getAttribute("allAjax_61") == "true";
					
					btnEliminar.addEvent('keypress', Generic.enterKeyToClickListener);
					btnEliminar.addEvent('click', function() {
						if(this.index_selected == null || this.index_selected.length == 0) {
							showMessage(GRID_MSG_SEL_ROW);
							return;
						}
//						var java_submit = false;
						var result = {result: true};
						if (fn_row_delete) {
							try {
//								java_submit = fn_row_delete(new ApiaField(this));
								result = fn_row_delete(new ApiaField(this));
							} catch(error) {}
						}
//						if(java_submit && !allAjaxRowDelete) {
						if(result.result) {
							this.btnSource = 'btnEliminar';
							if(result.submit && !allAjaxRowDelete) {
								this.deleteRowJava();
							} else {
								this.deleteRow(null, allAjaxRowDelete);
							}
						}
					}.bind(this));
				}
				if(!this.options[Field.PROPERTY_GRID_HIDE_BTN_ADD]) {
					//new Element('div.navSeparator').inject(nav_buttons_options);
					//var btnAgregar = new Element('div.gridButton', {'html': GRID_BTN_ADD}).setStyle('width', '53px').inject(nav_buttons_options);
					var btnAgregar = new Element('div.gridButton', {'html': GRID_BTN_ADD, tabIndex: ''}).inject(nav_buttons_options);
					Generic.setAdmGridBtnWidth(btnAgregar);
					
					var fn_row_add;
//					if(this.xml.getAttribute(Field.FUNC_ROW_ADD) && !window.editionMode)
					if(this.xml.getAttribute(Field.FUNC_ROW_ADD))
						fn_row_add = window[this.xml.getAttribute(Field.FUNC_ROW_ADD)];
					
					var allAjaxRowAdd = this.xml.getAttribute("allAjax_60") == "true";
					
					btnAgregar.addEvent('keypress', Generic.enterKeyToClickListener);
					btnAgregar.addEvent('click', function() {
						if(this.options[Field.PROPERTY_MAX_REG_GRID]) {
							if(this.options[Field.PROPERTY_PAGED_GRID]) {
								if((this.pages - 1) * this.options[Field.PROPERTY_PAGED_GRID_SIZE] + this.max_index >= this.options[Field.PROPERTY_MAX_REG_GRID]) {
									showMessage("Se alcanz� la cantidad m�xima de registros.")
									return;
								}
							} else {
								if(this.max_index >= this.options[Field.PROPERTY_MAX_REG_GRID]) {
									showMessage("Se alcanz� la cantidad m�xima de registros.")
									return;
								}
							}
						}
//						var java_submit = false;
						var result = {result: true};
						if (fn_row_add) {
							try {
//								java_submit = fn_row_add(new ApiaField(this));
								result = fn_row_add(new ApiaField(this));
							} catch(error) {}
						}
//						if(java_submit && !allAjaxRowAdd) {
						if(result.result) {
							if(result.submit && !allAjaxRowAdd) {
								this.addRowJava();
							} else {
								this.addRow(allAjaxRowAdd);
							}
						}
					}.bind(this));
				}
			}
			if(!this.options[Field.PROPERTY_GRID_HIDE_BTN_ORDER]) {
				
				var fn_row_sort;
//				if(this.xml.getAttribute(Field.FUNC_ROW_SORT) && !window.editionMode)
				if(this.xml.getAttribute(Field.FUNC_ROW_SORT))
					fn_row_sort = window[this.xml.getAttribute(Field.FUNC_ROW_SORT)];
				
				//new Element('div.navSeparator').inject(nav_buttons_options);
				//var btnBajar = new Element('div.gridButton', {'html': GRID_BTN_DOWN}).setStyle('width', '40px').inject(nav_buttons_options);
				var btnBajar = new Element('div.gridButton.btnBajar', {'html': GRID_BTN_DOWN, tabIndex: ''}).inject(nav_buttons_options);
				Generic.setAdmGridBtnWidth(btnBajar);
				
				var allAjaxRowSort = this.xml.getAttribute("allAjax_62") == "true";
				
				btnBajar.addEvent('keypress', Generic.enterKeyToClickListener);
				btnBajar.addEvent('click', function() {
					if(this.index_selected == null || this.index_selected.length == 0) {
						showMessage(GRID_MSG_SEL_ROW);
						return;
					}
					//var java_submit = false;
					var result = {result: true};
					if (fn_row_sort) {
						try {
//							java_submit = fn_row_sort(new ApiaField(this));
							result = fn_row_sort(new ApiaField(this));
						} catch(error) {}
					}
					//if(java_submit && !allAjaxRowSort) {
					if(result.result) {
						this.btnSource = 'btnBajar';
						if(result.submit && !allAjaxRowSort) {
							this.downRowJava();
						} else {
							this.downRow(allAjaxRowSort);
						}
					}
				}.bind(this));
				//new Element('div.navSeparator').inject(nav_buttons_options);
				//var btnSubir = new Element('div.gridButton', {'html': GRID_BTN_UP}).setStyle('width', '40px').inject(nav_buttons_options);
				var btnSubir = new Element('div.gridButton.btnSubir', {'html': GRID_BTN_UP, tabIndex: ''}).inject(nav_buttons_options);
				Generic.setAdmGridBtnWidth(btnSubir);
				
				btnSubir.addEvent('keypress', Generic.enterKeyToClickListener);
				btnSubir.addEvent('click', function() {
					if(this.index_selected == null || this.index_selected.length == 0) {
						showMessage(GRID_MSG_SEL_ROW);
						return;
					}
					//var java_submit = false;
					var result = {result: true};
					if (fn_row_sort) {
						try {
//							java_submit = fn_row_sort(new ApiaField(this));
							result = fn_row_sort(new ApiaField(this));
						} catch(error) {}
					}
					//if(java_submit && !allAjaxRowSort) {
					if(result.result) {
						this.btnSource = 'btnSubir';
						if(result.submit && !allAjaxRowSort) {
							this.upRowJava();
						} else {
							this.upRow(allAjaxRowSort);
						}
					}
				}.bind(this));
			}
			
			//nav_buttons_options.inject(buttonContainer);
			
			nav_buttons_options.inject(divFooter);
			
			/*
			nav_buttons_options = "<div class='navButtonsOptions'>" +
									(this.options[Field.PROPERTY_GRID_HIDE_BTN_DEL] ? "" : "<div class='gridButtons'>Eliminar</div>") +
									(this.options[Field.PROPERTY_GRID_HIDE_BTN_ADD] ? "" : "<div class='navSeparator'></div>" + "<div class='gridButtons'>Agregar</div>") +
									(this.options[Field.PROPERTY_GRID_HIDE_BTN_ORDER] ? "" : 
											"<div class='navSeparator'></div>" + "<div class='gridButtons'>Bajar</div>" +
											"<div class='navSeparator'></div>" + "<div class='gridButtons'>Subir</div>") +
								  "</div>";
			*/
		}
		/*
		divFooter.set('html', '<table><tbody><tr style="height:16px"><td class="roundedLeft"/><td>' +
										'<td>' +
											nav_buttons +
											nav_buttons_options +
										'</td>' +
							   '<td class="roundedRight"/></tr></tbody></table>');
		*/
		
		divHeader.setStyle('visibility', 'hidden').inject(this.content);
		divBody.setStyle('visibility', 'hidden').inject(this.content);
		divFooter.setStyle('visibility', 'hidden').inject(this.content);
		
		if(this.hor_scroll || this.ver_scroll) {
			if(!Browser.ie)
				divHeader.scrollTo(0, 0);
			
			divBody.scrollTo(this.hor_scroll, this.ver_scroll);
			
			if(Browser.ie7) {
				divHeader.scrollTo(this.hor_scroll, 0);
			} else {
				tableHeader.setStyle('left', - this.hor_scroll);
			}
		}
		
		divHeader.setStyle('visibility', '');
		divBody.setStyle('visibility', '');
		divFooter.setStyle('visibility', '');
		
		
		//posicionar menu de edicion
		if(this.options[Field.PROPERTY_GRID_FORM]) {
			
			this.editionTable.setStyles({
				height: divBody.getStyle('height'),
				overflow: 'hidden'
			});
			
			
//			var pos = divBody.getPosition();
//			
//			this.editionTable.setStyles({
//				//top: pos.y,
//				//left: pos.x - Number.from(this.editionTable.getStyle('width'))
//				//left: pos.x - Number.from(this.editionTable.getWidth())
//				bottom: 25,
//				left: - Number.from(this.editionTable.getWidth())
//			});
			
			this.editionTable.position({
			    relativeTo: this.divBody,
			    position: 'upperLeft',
			    edge: 'upperRight'
			});
			
			//var rowHeights = divBody.getElements('tr').getStyle('height');
			var rowHeights = divBody.getElements('tr').getHeight();
			this.editionTable.getChildren().each(function(div, i) {
				div.setStyle('height', rowHeights[i]);
			});
			
			this.form.form_tab_parent.addFormCollapseListener(this.handleFormMove.bind(this));
			
			if(this.form.form_tab_parent.tabTitle)
				this.form.form_tab_parent.tabTitle.addEvent('focus', this.handleTabFocus.bind(this));
			else
				this.form.form_tab_parent.contentTab.tabTitle.addEvent('focus', this.handleTabFocus.bind(this));
		}
		
		
		var element = this;
		//Control de overflow-x
		divBody.addEvent('scroll', function() {
			//divHeader.scrollTo(this.scrollLeft, 0);
			//divHeader.getElements('table').setStyle('right', this.scrollLeft);
			//tableHeader.setStyle('right', this.scrollLeft);
			if(Browser.ie7) {
				divHeader.scrollTo(this.scrollLeft, 0);
			} else {
				tableHeader.setStyle('left', - this.scrollLeft);				
			}
			
			if(element.editionTable)
				element.editionTable.scrollTo(0, this.scrollTop);
			
			element.hor_scroll = this.scrollLeft;
			element.ver_scroll = this.scrollTop;
		});
		
		//Colocar scroll para los casos en que no tiene
		if(divBody.getElements('tr').length == 0) {
			tableBody.setStyle('width', Generic.getHiddenWidth(tableHeader));
		}
		
		if(!this.options[Field.PROPERTY_READONLY]) {
			if(redrawing) {
				//Ya existe el contextmenu
				this.contextmenu.attach(divBody);
			} else {
				if(this.options[Field.PROPERTY_PAGED_GRID]) {
					this.contextmenu = new ContextMenu(divBody, {
						'Seleccionar todo': this.selectAllRows.bind(this),
						'Deseleccionar': this.deselectAllRows.bind(this),
						'Mover a p�gina anterior': this.rowToPrevPage.bind(this),
						'Mover a p�gina siguiente': this.rowToNextPage.bind(this)
					});
				} else {
					this.contextmenu = new ContextMenu(divBody, {
						'Seleccionar todo': this.selectAllRows.bind(this),
						'Deseleccionar': this.deselectAllRows.bind(this)
					});
				}
			}
		}
		
		if(redrawing && this.gridColumns && this.gridColumns.length) {
			var empty = true;
			for(var i = 0; i < this.gridColumns.length && empty; i++) {
				if(this.gridColumns[i].length > 1) {
					empty = false;
				}
			}
			if(!empty) {
				//Corregir visibilidades
				for(var i = 0; i < this.gridColumns.length; i++)
					this.gridColumns[i][0].checkVisibility();
			}
		}
	},
	
	selectRow: function(tr, tr_index) {
		
		if(!tr)
			return;
		
		if(this.tr_selected)
			$each(this.tr_selected, function(t) {
				t.removeClass('selectedTR');
			});
		this.tr_selected = [];
		this.tr_selected[0] = tr.addClass('selectedTR');
		this.index_selected = [];
		this.index_selected[0] = tr_index;
	},
	
	selectRowByIndex: function(tr_index) {
		var trs = this.content.getElements('div.gridBody').getElements('tr').flatten();
		this.selectRow(trs[tr_index - this.startIndex], tr_index);
	},
	
	addToSelectRows: function(tr, tr_index) {
		
		if(!tr)
			return;
		
		if(!this.index_selected)
			this.index_selected = [];
		
		if(this.index_selected.contains(tr_index)) {
			//Deseselccionar
			if(this.tr_selected)
				this.tr_selected.erase(tr.removeClass('selectedTR'));
			if(this.index_selected)
				this.index_selected.erase(tr_index);
		} else {
			//Seleccionar
			if(!this.tr_selected)
				this.tr_selected = [];
			this.tr_selected.include(tr.addClass('selectedTR'));
			if(!this.index_selected)
				this.index_selected = [];
			
			//Insertar ordenado
			var aux_array = [];
			var done = false;			
			this.index_selected.each(function(value) {
				if(tr_index > value && !done) {
					aux_array.include(tr_index);
					done = true;
				}
				aux_array.include(value);
			});
			if(!done)
				aux_array.include(tr_index);
			this.index_selected = aux_array;
		}
	},
	
	addToSelectRowByIndex: function(tr_index) {
		var trs = this.content.getElements('div.gridBody').getElements('tr').flatten();
		this.addToSelectRows(trs[tr_index - this.startIndex], tr_index);
	},
	
	selectAllRows: function() {
		this.index_selected = [];
		this.content.getElements('div.gridBody').getElements('tr').flatten().each(function(tr, tr_index) {
			this.addToSelectRows(tr, this.startIndex + tr_index);
		}.bind(this));
	},
	
	deselectAllRows: function() {
		this.content.getElements('div.gridBody').getElements('tr').flatten().each(function(tr, tr_index) {
			if(this.index_selected.contains(this.startIndex + tr_index))
				this.addToSelectRows(tr, this.startIndex + tr_index);
		}.bind(this));
		
		this.index_selected = [];
	},
	
	addRowJava: function () {
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		var fldId = this.fldId;
		
		SynchronizeFields.syncJAVAexec(function() {
			var index = 0;
			$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&gridAction=add&cantRowsToAdd=1&index=0&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + fldId + '&evtId=60&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
			$('frmData').disabledCheck = true;
			$('frmData').fireEvent('submit');
		});
	},
	
	addRow: function(allAjax, doBlock, cant) {
		
		if(this.exec_ajax_call)
			return;
		
		this.exec_ajax_call = true;
		
		var cant_rows_to_add = cant ? Number.from(cant) : 1;
		
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		
		if(!this.options[Field.PROPERTY_PAGED_GRID]) {
			this.prps = {};
			for(var i = 0; i < this.gridColumns.length; i++) {
				for(var j = 1; j < this.gridColumns[i].length; j++) {
					var field = this.gridColumns[i][j];
					if(field.getPrpsForGridReload) {
						if(!this.prps[field.fldId])
							this.prps[field.fldId] = {};
						this.prps[field.fldId][field.index] = field.getPrpsForGridReload();
					}
				}
			}
		}
		
		this.disposeRequiredChilds();
		
		var element = this;
		
		var tId = setTimeout(function() {element.showSpinner();}, Field.WAITTIME_FOR_GRID_SPINNER);
		
		if(allAjax)
			SYS_PANELS.showLoading();
		
		var myRequest = new Request({
			url: 'apia.execution.FormAction.run?action=processGridFieldAction&gridAction=add&frmId=' +  frmId + '&frmParent=' + frmParent + '&fldId=' + this.fldId + (allAjax ? '&fireAjaxEvt=true' : '') + "&cantRowsToAdd=" + cant_rows_to_add + TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
		    	//AJAX exitoso
		    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
		    		
		    		//Errorres y mensajes
		    		checkErrors(responseXML)
		    		
		    		//Control para xml de ie
		    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
		    		
		    		if(response.tagName == 'result' && response.getAttribute('success')) {
		    			
		    			var gridXml = new Element('div').set('auxAtt', response.getAttribute('gridXml')).get('auxAtt');
		    			//Parsear XML
		    			var xmlDoc;		    			
		    			if (window.DOMParser) {
		    				parser = new DOMParser();
		    				//xmlDoc = parser.parseFromString(response.getAttribute('gridXml'),"text/xml");
		    				xmlDoc = parser.parseFromString(gridXml, "text/xml");
		    			} else {
		    				// Internet Explorer
		    				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		    				xmlDoc.async = false;
		    				//xmlDoc.loadXML(response.getAttribute('gridXml')); 
		    				xmlDoc.loadXML(gridXml);
		    			}
		    			
		    			if(response.getAttribute('only_added_row')) {
		    				//Se mando solo la nueva fila a agregar, no borrar el contenido anterior
//		    				element.tr_selected = [];
		    				
		    				//Volver a colocar los requeridos en caso necesario
		    				if(!element.options[Field.PROPERTY_PAGED_GRID]) {
		    					for(var i = 0; i < element.gridColumns.length; i++) {
		    						for(var j = 1; j < element.gridColumns[i].length; j++) {
		    							var field = element.gridColumns[i][j];
		    							if(element.prps[field.fldId][field.index][Field.PROPERTY_REQUIRED])
		    								field.apijs_setProperty(Field.PROPERTY_REQUIRED, true);
		    						}
		    					}
		    				}
		    				
		    				//Forzar scroll vertical al ultimo elemento
			    			element.ver_scroll = element.content.getChildren('div.gridBody')[0].scrollHeight;
			    			element.parseXML(true, xmlDoc.childNodes[0]);
			    			$$("input.datePicker").each(setAdmDatePicker);
		    			} else {
		    				//element.index_selected = null;
			    			element.tr_selected = [];
			    			
			    			var h_scroll = window.scrollX || window.screenLeft;
			    			var v_scroll = window.scrollY || window.screenTop;
			    			
			    			//Forzar scroll vertical al ultimo elemento
			    			element.ver_scroll = element.content.getChildren('div.gridBody')[0].scrollHeight;
			    			
			    			var cantCols = element.gridColumns.length;
			    			for(var i = cantCols - 1; i >= 0; i--) {
			    				delete element.gridColumns[i];
			    			}
			    			
			    			element.xml = xmlDoc.childNodes[0];
			    			element.aux_focus_set = null;
			    			
			    			element.parseXML(true);
			    			
			    			if(element.index_selected != null) {		    				
			    				var aux_indexes = element.index_selected;
			    				element.index_selected = [];
			    				element.tr_selected = [];
			    				$each(aux_indexes, function (t_index) { element.addToSelectRowByIndex(t_index);});
			    			}
			    			
			    			$$("input.datePicker").each(setAdmDatePicker);
			    		
			    			if(!Browser.ie)
			    				window.scrollTo(h_scroll, v_scroll);
			    			
			    			if(element.aux_focus_set)
			    				element.aux_focus_set.apijs_setFocus();
		    			}
		    		} else {
		    			//TODO:
		    			showMessage(LBL_ERROR);
		    		}
		    		
		    		if(response.childNodes.length && response.childNodes[0].childNodes.length) {
			    		//actualizar ajax con response.childNodes[0]
		    			element.dontReload = true;
			    		SynchronizeFields.updateClientValues(response.childNodes[0].childNodes[0]);
			    		SYS_PANELS.closeLoading();
			    		element.dontReload = null;
		    		}
		    		
		    		if(element.spinner && !element.spinner.hidden)
	    				element.hideSpinner(true);
	    			else
	    				clearTimeout(tId)
	    				
	    			element.exec_ajax_call = false;
		    		
		    	} else {
		    		//TODO:
		    		showMessage(LBL_ERROR);
		    	}
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO:
		    	showMessage(LBL_ERROR);
		    },
		    
		    async: !doBlock
		}).send();
	},
	
	deleteRowJava: function () {
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		var rowIdToSend = "";
		$each(this.index_selected, function(index) {
			rowIdToSend += "&rowId=" + index;
		});
		var fldId = this.fldId;
		SynchronizeFields.syncJAVAexec(function() {
			var index = 0;
			$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&gridAction=delete&index=0&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + fldId + rowIdToSend + '&evtId=61&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
			$('frmData').disabledCheck = true;
			$('frmData').fireEvent('submit');
		});
	},
	
	deleteRow: function(indexes_to_erase, allAjax, doBlock) {
		
		if(indexes_to_erase == null || indexes_to_erase == undefined) {
			if(this.index_selected == null || this.index_selected.length == 0) {
				showMessage(GRID_MSG_SEL_ROW);
				return;
			}
		}
		
		if(this.exec_ajax_call)
			return;
		
		this.exec_ajax_call = true;
		
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		
		if(!this.options[Field.PROPERTY_PAGED_GRID]) {
			this.prps = {};
			for(var i = 0; i < this.gridColumns.length; i++) {
				for(var j = 1; j < this.gridColumns[i].length; j++) {
					var field = this.gridColumns[i][j];
					if(field.getPrpsForGridReload) {
						if(!this.prps[field.fldId])
							this.prps[field.fldId] = {};
						this.prps[field.fldId][field.index] = field.getPrpsForGridReload();
					}
				}
			}
		}
		
		this.disposeRequiredChilds();
		
		var element = this;
		
		var tId = setTimeout(function() {element.showSpinner();}, Field.WAITTIME_FOR_GRID_SPINNER);
		
		var rowIdToSend = "";
		var deleted_indexes = [];
		if(indexes_to_erase != null && indexes_to_erase != undefined) {
			$each(indexes_to_erase, function(index) {
				rowIdToSend += "&rowId=" + index;
				deleted_indexes.push(index);
			});			
		} else {
			$each(this.index_selected, function(index) {
				rowIdToSend += "&rowId=" + index;
				deleted_indexes.push(index);
			});
		}
		
		if(allAjax)
			SYS_PANELS.showLoading();
		
		var myRequest = new Request({	    
			url: 'apia.execution.FormAction.run?action=processGridFieldAction&gridAction=delete&frmId=' +  frmId + '&frmParent=' + frmParent + '&fldId=' + this.fldId + rowIdToSend + (allAjax ? '&fireAjaxEvt=true' : '') + TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
				//AJAX exitoso
		    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
		    	
		    		//Errorres y mensajes
		    		checkErrors(responseXML);
		    		
		    		//Control para xml de ie
		    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
		    		
		    		if(response.tagName == 'result' && response.getAttribute('success')) {
		    			
		    			var cantCols = element.gridColumns.length;
		    			
		    			if(!this.options[Field.PROPERTY_PAGED_GRID]) {
		    				//Reacomodar las propiedades de los campos
		    				deleted_indexes.sort().reverse();
		    				for(var i = 0; i < cantCols; i++) {
		    					var fld_id = element.gridColumns[i][0].col_fld_id;
			    				for (var j = 0; j < deleted_indexes.length; j++) {
			    					var col_prps = element.prps[fld_id];
			    					if(col_prps) {
			    						col_prps[deleted_indexes[j]] = {};
			    						for(var k = deleted_indexes[j] + 1; k < element.gridColumns[i].length - 1; k++) {
			    							col_prps[k - 1] = col_prps[k];
				    					}
			    					}
			    				}
		    				}
		    			}
		    			
		    			element.index_selected = [];
		    			element.tr_selected = [];
		    			
		    			for(var i = cantCols - 1; i >= 0; i--) {
		    				delete element.gridColumns[i];
		    			}
		    			
		    			var h_scroll = window.scrollX || window.screenLeft;
		    			var v_scroll = window.scrollY || window.screenTop;
		    			
		    			//Parsear XML
		    			var xmlDoc;
		    			if (window.DOMParser) {
		    				parser = new DOMParser();
		    				xmlDoc = parser.parseFromString(response.getAttribute('gridXml'),"text/xml");
		    			} else {
		    				// Internet Explorer
		    				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		    				xmlDoc.async = false;
		    				xmlDoc.loadXML(response.getAttribute('gridXml')); 
		    			}
		    			
		    			element.xml = xmlDoc.childNodes[0];		    			
		    			
		    			element.parseXML(true);
		    			
		    			$$("input.datePicker").each(setAdmDatePicker); 
		    			
		    			if(!Browser.ie)
		    				window.scrollTo(h_scroll, v_scroll);
	    			
		    		} else {
		    			//TODO
		    			showMessage(LBL_ERROR);		    			
		    		}
		    		
		    		if(response.childNodes.length && response.childNodes[0].childNodes.length) {
			    		//actualizar ajax con response.childNodes[0]
		    			element.dontReload = true;
			    		SynchronizeFields.updateClientValues(response.childNodes[0].childNodes[0]);
			    		SYS_PANELS.closeLoading();
			    		element.dontReload = null;
		    		}
		    		
		    		if(element.spinner && !element.spinner.hidden)
	    				element.hideSpinner(true);
	    			else
	    				clearTimeout(tId)
	    				
	    			element.exec_ajax_call = false;
		    		
		    		if(element.btnSource) {
		    			element.divFooter.getElement('div.' + element.btnSource).focus();
		    			element.btnSource = undefined;
		    		}
		    	} else {
		    		//TODO
		    		showMessage(LBL_ERROR);	
		    	}
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO
		    	showMessage(LBL_ERROR);	
		    },
		    
		    async: !doBlock
		}).send();
	},
	
	upRowJava: function () {
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		var rowIdToSend = "";
		for(var index = this.index_selected.length - 1; index >= 0; index--) {
			rowIdToSend += "&rowId=" + this.index_selected[index];
		}
		var fldId = this.fldId;
		SynchronizeFields.syncJAVAexec(function() {
			var index = 0;
			$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&gridAction=up&index=0&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + fldId + rowIdToSend + '&evtId=61&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
			$('frmData').disabledCheck = true;
			$('frmData').fireEvent('submit');
		});
	},
	
	upRow: function(allAjax) {
		
		if(this.index_selected == null || this.index_selected.length == 0) {
			showMessage(GRID_MSG_SEL_ROW);
			return;
		}
		
		if(this.index_selected[this.index_selected.length - 1] == 0)
			return;
		
		if(this.exec_ajax_call)
			return;
		
		this.exec_ajax_call = true;
		
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		
		if(!this.options[Field.PROPERTY_PAGED_GRID]) {
			this.prps = {};
			for(var i = 0; i < this.gridColumns.length; i++) {
				for(var j = 1; j < this.gridColumns[i].length; j++) {
					var field = this.gridColumns[i][j];
					if(field.getPrpsForGridReload) {
						if(!this.prps[field.fldId])
							this.prps[field.fldId] = {};
						this.prps[field.fldId][field.index] = field.getPrpsForGridReload();
					}
				}
			}
		}
		
		this.disposeRequiredChilds();
		
		var element = this;
		
		var tId = setTimeout(function() {element.showSpinner();}, Field.WAITTIME_FOR_GRID_SPINNER);
		
		var rowIdToSend = "";
		var up_indexes = [];
		for(var index = this.index_selected.length - 1; index >= 0; index--) {
			rowIdToSend += "&rowId=" + this.index_selected[index];
			up_indexes.push(this.index_selected[index]);
		}
		
		if(allAjax)
			SYS_PANELS.showLoading();
		
		var myRequest = new Request({
			url: 'apia.execution.FormAction.run?action=processGridFieldAction&gridAction=up&frmId=' +  frmId + '&frmParent=' + frmParent + '&fldId=' + this.fldId + rowIdToSend + (allAjax ? '&fireAjaxEvt=true' : '') + TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
				//AJAX exitoso
		    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
		    	
		    		//Errorres y mensajes
		    		checkErrors(responseXML);
		    		
		    		//Control para xml de ie
		    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
		    		
		    		if(response.tagName == 'result' && response.getAttribute('success')) {
		    			
		    			var cantCols = element.gridColumns.length;
		    			
		    			if(!this.options[Field.PROPERTY_PAGED_GRID]) {
		    				//Reacomodar las propiedades de los campos
		    				up_indexes.sort();
		    				for(var i = 0; i < cantCols; i++) {
		    					var fld_id = element.gridColumns[i][0].col_fld_id;
			    				for (var j = 0; j < up_indexes.length; j++) {
			    					var col_prps = element.prps[fld_id];
			    					if(col_prps) {
			    						var actual = col_prps[up_indexes[j]];
			    						var previo = col_prps[up_indexes[j] - 1];
			    						col_prps[up_indexes[j]] = previo;
			    						col_prps[up_indexes[j] - 1] = actual;
			    					}
			    				}
		    				}
		    			}
		    			
		    			//element.index_selected = null;
		    			element.tr_selected = [];
		    			
		    			var h_scroll = window.scrollX || window.screenLeft;
		    			var v_scroll = window.scrollY || window.screenTop;
		    			
		    			//var cantCols = element.gridColumns.length;
		    			for(var i = cantCols - 1; i >= 0; i--) {
		    				delete element.gridColumns[i];
		    			}
		    			
		    			//Parsear XML
		    			var xmlDoc;
		    			if (window.DOMParser) {
		    				parser = new DOMParser();
		    				xmlDoc = parser.parseFromString(response.getAttribute('gridXml'),"text/xml");
		    			} else {
		    				// Internet Explorer
		    				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		    				xmlDoc.async = false;
		    				xmlDoc.loadXML(response.getAttribute('gridXml')); 
		    			}
		    			
		    			element.xml = xmlDoc.childNodes[0];		    			
		    			
		    			element.parseXML(true);

	    				if(element.index_selected != null) {		    				
		    				var aux_indexes = element.index_selected;
		    				element.index_selected = [];		    				
		    				$each(aux_indexes, function (t_index) { element.addToSelectRowByIndex(t_index - 1);});
		    			}
	    				
	    				$$("input.datePicker").each(setAdmDatePicker); 
		    			
	    				if(!Browser.ie)
	    					window.scrollTo(h_scroll, v_scroll);
	    				
		    		} else {
	 		    		//TODO
		    			showMessage(LBL_ERROR);		    			
	 		    	}
	 		    	
		    		if(response.childNodes.length && response.childNodes[0].childNodes.length) {
			    		//actualizar ajax con response.childNodes[0]
		    			element.dontReload = true;
			    		SynchronizeFields.updateClientValues(response.childNodes[0].childNodes[0]);
			    		SYS_PANELS.closeLoading();
			    		element.dontReload = null;
		    		}
		    		
 		    		if(element.spinner && !element.spinner.hidden)
 	    				element.hideSpinner(true);
 	    			else
 	    				clearTimeout(tId)
 	    				
 	    			element.exec_ajax_call = false;
 		    		
 		    		if(element.btnSource) {
		    			element.divFooter.getElement('div.' + element.btnSource).focus();
		    			element.btnSource = undefined;
		    		}
		    	} else {
		    		//TODO
		    		showMessage(LBL_ERROR);		  
		    	}
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO
		    	showMessage(LBL_ERROR);		  
		    }
		}).send();
	},
	
	downRowJava: function () {
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		var rowIdToSend = "";
		$each(this.index_selected, function(index) {
			rowIdToSend += "&rowId=" + index;
		});
		var fldId = this.fldId;
		SynchronizeFields.syncJAVAexec(function() {
			var index = 0;
			$('frmData').setProperty('action', 'apia.execution.FormAction.run?action=fireFieldEvent&gridAction=down&index=0&frmParent=' + frmParent + '&frmId=' + frmId + '&fldId=' + fldId + rowIdToSend + '&evtId=61&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
			$('frmData').disabledCheck = true;
			$('frmData').fireEvent('submit');
		});
	},
	
	downRow: function(allAjax) {
		
		if(this.index_selected == null || this.index_selected.length == 0) {
			showMessage(GRID_MSG_SEL_ROW);
			return;
		}
		
		if(this.index_selected[0] == this.max_index + this.startIndex - 1 && this.currentPage == this.pages)
			return;
		
		if(this.exec_ajax_call)
			return;
		
		this.exec_ajax_call = true;
		
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		
		if(!this.options[Field.PROPERTY_PAGED_GRID]) {
			this.prps = {};
			for(var i = 0; i < this.gridColumns.length; i++) {
				for(var j = 1; j < this.gridColumns[i].length; j++) {
					var field = this.gridColumns[i][j];
					if(field.getPrpsForGridReload) {
						if(!this.prps[field.fldId])
							this.prps[field.fldId] = {};
						this.prps[field.fldId][field.index] = field.getPrpsForGridReload();
					}
				}
			}
		}
		
		this.disposeRequiredChilds();
		
		var element = this;
		
		var tId = setTimeout(function() {element.showSpinner();}, Field.WAITTIME_FOR_GRID_SPINNER);
		
		var rowIdToSend = "";
		var down_indexes = [];
		$each(this.index_selected, function(index) {
			rowIdToSend += "&rowId=" + index;
			down_indexes.push(index);
		});
		
		if(allAjax)
			SYS_PANELS.showLoading();
		
		var myRequest = new Request({	    
			url: 'apia.execution.FormAction.run?action=processGridFieldAction&gridAction=down&frmId=' +  frmId + '&frmParent=' + frmParent + '&fldId=' + this.fldId + rowIdToSend + (allAjax ? '&fireAjaxEvt=true' : '') + TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
				//AJAX exitoso
		    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
		    	
		    		//Errorres y mensajes
		    		checkErrors(responseXML);
		    		
		    		//Control para xml de ie
		    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
		    		
		    		if(response.tagName == 'result' && response.getAttribute('success')) {
		    			
		    			var cantCols = element.gridColumns.length;
		    			
		    			if(!this.options[Field.PROPERTY_PAGED_GRID]) {
		    				//Reacomodar las propiedades de los campos
		    				down_indexes.sort().reverse();
		    				for(var i = 0; i < cantCols; i++) {
		    					var fld_id = element.gridColumns[i][0].col_fld_id;
			    				for (var j = 0; j < down_indexes.length; j++) {
			    					var col_prps = element.prps[fld_id];
			    					if(col_prps) {
			    						var actual = col_prps[down_indexes[j]];
			    						var sig = col_prps[down_indexes[j] + 1];
			    						col_prps[down_indexes[j]] = sig;
			    						col_prps[down_indexes[j] + 1] = actual;
			    					}
			    				}
		    				}
		    			}
		    			
		    			//element.index_selected = null;
		    			element.tr_selected = [];
		    			
		    			var h_scroll = window.scrollX || window.screenLeft;
		    			var v_scroll = window.scrollY || window.screenTop;
		    			
		    			//var cantCols = element.gridColumns.length;
		    			for(var i = cantCols - 1; i >= 0; i--) {
		    				delete element.gridColumns[i];
		    			}
		    			
		    			//Parsear XML
		    			var xmlDoc;
		    			if (window.DOMParser) {
		    				parser = new DOMParser();
		    				xmlDoc = parser.parseFromString(response.getAttribute('gridXml'),"text/xml");
		    			} else {
		    				// Internet Explorer
		    				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		    				xmlDoc.async = false;
		    				xmlDoc.loadXML(response.getAttribute('gridXml')); 
		    			}
		    			
		    			element.xml = xmlDoc.childNodes[0];		    			
		    			
		    			element.parseXML(true);
		    			
		    			if(element.index_selected != null) {		    				
		    				var aux_indexes = element.index_selected;
		    				element.index_selected = [];		    				
		    				$each(aux_indexes, function (t_index) { element.addToSelectRowByIndex(t_index + 1);});
		    			}
		    			
		    			$$("input.datePicker").each(setAdmDatePicker);
		    			
		    			if(!Browser.ie)
		    				window.scrollTo(h_scroll, v_scroll);
		    			
		    		} else {
	 		    		//TODO
		    			showMessage(LBL_ERROR);		    			
	 		    	}
	 		    	
		    		if(response.childNodes.length && response.childNodes[0].childNodes.length) {
			    		//actualizar ajax con response.childNodes[0]
		    			element.dontReload = true;
			    		SynchronizeFields.updateClientValues(response.childNodes[0].childNodes[0]);
			    		SYS_PANELS.closeLoading();
			    		element.dontReload = null;
		    		}
		    		
 		    		if(element.spinner && !element.spinner.hidden)
 	    				element.hideSpinner(true);
 	    			else
 	    				clearTimeout(tId)
 	    				
 	    			element.exec_ajax_call = false;
 		    		
 		    		if(element.btnSource) {
		    			element.divFooter.getElement('div.' + element.btnSource).focus();
		    			element.btnSource = undefined;
		    		}
		    	} else {
		    		//TODO
		    		showMessage(LBL_ERROR);		
		    	}
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO
		    	showMessage(LBL_ERROR);		
		    }
		}).send();
	},
	
	rowToPrevPage: function() {
		//uppage dar vuelta los �ndices al enviarlos
		
		if(this.index_selected == null || this.index_selected.length == 0) {
			showMessage(GRID_MSG_SEL_ROW);
			return;
		}
		
		if(this.currentPage == 1)
			return;
		
		if(this.exec_ajax_call)
			return;
		
		this.exec_ajax_call = true;
		
		this.disposeRequiredChilds();
		
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		
		var element = this;
		
		var tId = setTimeout(function() {element.showSpinner();}, Field.WAITTIME_FOR_GRID_SPINNER);
		
		var rowIdToSend = "";
		$each(this.index_selected, function(index) {
			rowIdToSend += "&rowId=" + index;
		});
		
		var myRequest = new Request({
			url: 'apia.execution.FormAction.run?action=processGridFieldAction&gridAction=uppage&frmId=' +  frmId + '&frmParent=' + frmParent + '&fldId=' + this.fldId + rowIdToSend + TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
				//AJAX exitoso
		    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
		    	
		    		//Errorres y mensajes
		    		checkErrors(responseXML);
		    		
		    		//Control para xml de ie
		    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
		    		
		    		if(response.tagName == 'result' && response.getAttribute('success')) {
		    			
		    			//element.index_selected = null;
		    			element.tr_selected = [];
		    			
		    			var h_scroll = window.scrollX || window.screenLeft;
		    			var v_scroll = window.scrollY || window.screenTop;
		    			
		    			var cantCols = element.gridColumns.length;
		    			for(var i = cantCols - 1; i >= 0; i--) {
		    				delete element.gridColumns[i];
		    			}
		    			
		    			//Parsear XML
		    			var xmlDoc;
		    			if (window.DOMParser) {
		    				parser = new DOMParser();
		    				xmlDoc = parser.parseFromString(response.getAttribute('gridXml'),"text/xml");
		    			} else {
		    				// Internet Explorer
		    				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		    				xmlDoc.async = false;
		    				xmlDoc.loadXML(response.getAttribute('gridXml')); 
		    			}
		    			
		    			element.xml = xmlDoc.childNodes[0];		    			
		    			
		    			element.parseXML(true);
		    			/*
	    				if(element.index_selected != null) {		    				
		    				var aux_indexes = element.index_selected;
		    				element.index_selected = [];		    				
		    				$each(aux_indexes, function (t_index) { element.addToSelectRowByIndex(t_index - 1);});
		    			}
	    				*/
	    				$$("input.datePicker").each(setAdmDatePicker); 
		    			
	    				if(!Browser.ie)
	    					window.scrollTo(h_scroll, v_scroll);
	    				
		    		} else {
	 		    		//TODO
		    			showMessage(LBL_ERROR);		    			
	 		    	}
	 		    		
 		    		if(element.spinner && !element.spinner.hidden)
 	    				element.hideSpinner(true);
 	    			else
 	    				clearTimeout(tId)
 	    				
 	    			element.exec_ajax_call = false;
		    	} else {
		    		//TODO
		    		showMessage(LBL_ERROR);		  
		    	}
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO
		    	showMessage(LBL_ERROR);		  
		    }
		}).send();
	},
	
	rowToNextPage: function() {
		//downpage
		
		if(this.index_selected == null || this.index_selected.length == 0) {
			showMessage(GRID_MSG_SEL_ROW);
			return;
		}
		
		if(this.currentPage == this.pages)
			return;
		
		if(this.exec_ajax_call)
			return;
		
		this.exec_ajax_call = true;
		
		this.disposeRequiredChilds();
		
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		
		var element = this;
		
		var tId = setTimeout(function() {element.showSpinner();}, Field.WAITTIME_FOR_GRID_SPINNER);
		
		var rowIdToSend = "";
		for(var index = this.index_selected.length - 1; index >= 0; index--) {
			rowIdToSend += "&rowId=" + this.index_selected[index];
		}
		
		var myRequest = new Request({	    
			url: 'apia.execution.FormAction.run?action=processGridFieldAction&gridAction=downpage&frmId=' +  frmId + '&frmParent=' + frmParent + '&fldId=' + this.fldId + rowIdToSend + TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
				//AJAX exitoso
		    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
		    	
		    		//Errorres y mensajes
		    		checkErrors(responseXML);
		    		
		    		//Control para xml de ie
		    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
		    		
		    		if(response.tagName == 'result' && response.getAttribute('success')) {
		    			
		    			//element.index_selected = null;
		    			element.tr_selected = [];
		    			
		    			var h_scroll = window.scrollX || window.screenLeft;
		    			var v_scroll = window.scrollY || window.screenTop;
		    			
		    			var cantCols = element.gridColumns.length;
		    			for(var i = cantCols - 1; i >= 0; i--) {
		    				delete element.gridColumns[i];
		    			}
		    			
		    			//Parsear XML
		    			var xmlDoc;
		    			if (window.DOMParser) {
		    				parser = new DOMParser();
		    				xmlDoc = parser.parseFromString(response.getAttribute('gridXml'),"text/xml");
		    			} else {
		    				// Internet Explorer
		    				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		    				xmlDoc.async = false;
		    				xmlDoc.loadXML(response.getAttribute('gridXml')); 
		    			}
		    			
		    			element.xml = xmlDoc.childNodes[0];		    			
		    			
		    			element.parseXML(true);
		    			/*
		    			if(element.index_selected != null) {		    				
		    				var aux_indexes = element.index_selected;
		    				element.index_selected = [];		    				
		    				$each(aux_indexes, function (t_index) { element.addToSelectRowByIndex(t_index + 1);});
		    			}
		    			*/
		    			$$("input.datePicker").each(setAdmDatePicker);
		    			
		    			if(!Browser.ie)
		    				window.scrollTo(h_scroll, v_scroll);
		    			
		    		} else {
	 		    		//TODO
		    			showMessage(LBL_ERROR);		    			
	 		    	}
	 		    		
 		    		if(element.spinner && !element.spinner.hidden)
 	    				element.hideSpinner(true);
 	    			else
 	    				clearTimeout(tId)
 	    			
 	    			element.exec_ajax_call = false;
 		    		
		    	} else {
		    		//TODO
		    		showMessage(LBL_ERROR);		
		    	}
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO
		    	showMessage(LBL_ERROR);		
		    }
		}).send();
	},
	
	navPage: function(action) {
				
		if(this.exec_ajax_call)
			return;
		
		this.exec_ajax_call = true;
		
		this.disposeRequiredChilds();
		
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		
		var element = this;
		
		var tId = setTimeout(function() {element.showSpinner();}, Field.WAITTIME_FOR_GRID_SPINNER);
		
		var myRequest = new Request({
			url: 'apia.execution.FormAction.run?action=processGridFieldAction&gridAction=' + action + '&startIndex=' + this.startIndex + '&frmId=' +  frmId + '&frmParent=' + frmParent + '&fldId=' + this.fldId + '&rowId=' + this.index_selected + TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
				//AJAX exitoso
		    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
		    	
		    		//Errorres y mensajes
		    		checkErrors(responseXML);
		    		
		    		//Control para xml de ie
		    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
		    		
		    		if(response.tagName == 'result' && response.getAttribute('success')) {
		    			
		    			//element.index_selected = null;
		    			element.tr_selected = [];
		    			
		    			var h_scroll = window.scrollX || window.screenLeft;
		    			var v_scroll = window.scrollY || window.screenTop;
		    			
		    			var cantCols = element.gridColumns.length;
		    			for(var i = cantCols - 1; i >= 0; i--) {
		    				delete element.gridColumns[i];
		    			}
		    			
		    			//Parsear XML
		    			var xmlDoc;
		    			if (window.DOMParser) {
		    				parser = new DOMParser();
		    				xmlDoc = parser.parseFromString(response.getAttribute('gridXml'),"text/xml");
		    			} else {
		    				// Internet Explorer
		    				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		    				xmlDoc.async = false;
		    				xmlDoc.loadXML(response.getAttribute('gridXml')); 
		    			}
		    			
		    			element.xml = xmlDoc.childNodes[0];		    			
		    			
		    			//Forzamos el scroll de nuevo a la primer posicion
		    			element.ver_scroll = 0;
		    			
		    			element.parseXML(true);

		    			//element.selectRowByIndex(element.index_selected + 1);
		    			
		    			$$("input.datePicker").each(setAdmDatePicker);
		    			
		    			if(!Browser.ie)
		    				window.scrollTo(h_scroll, v_scroll);
		    			
		    		} else {
	 		    		//TODO
		    			showMessage(LBL_ERROR);		    			
	 		    	}
	 		    		
 		    		if(element.spinner && !element.spinner.hidden)
 	    				element.hideSpinner(true);
 	    			else
 	    				clearTimeout(tId)
 	    				
 	    			element.exec_ajax_call = false;
		    	} else {
		    		//TODO
		    		showMessage(LBL_ERROR);
		    	}
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO
		    	showMessage(LBL_ERROR);
		    }
		}).send();
	},
	
	visualRefreshGrid: function() {
		
		var total_width = this.form.DOMform.getParent().getParent().getParent().offsetWidth - this.form.DOMform.getParent().getStyle('padding-left').toInt() * 2;
		var grid_width = total_width / this.getFormCantCols();
		
		if(this.cols > 0)
			grid_width = this.cols * grid_width;
			
		if(this.options[Field.PROPERTY_GRID_FORM]) {
			
			var tdParent = this.content.getParent();
			var tdParentId = tdParent.get('id').split('_');
			if(tdParentId[tdParentId.length - 1] != '0') {
				this.content.getParent().setStyle('padding-left', '28px');

				grid_width -= 28;
			}
		}
		
		this.content.getElement('div.gridHeader').setStyle('width', grid_width);
		this.content.getElement('div.gridBody').setStyle('width', grid_width);
		this.content.getElement('div.gridFooter').setStyle('width', grid_width);
	},
	
	refreshGrid: function() {
		
		if(this.exec_ajax_call)
			return;
		
		this.exec_ajax_call = true;
		
		this.disposeRequiredChilds();
		
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		
		var element = this;
		var tId = setTimeout(function() {element.showSpinner();}, Field.WAITTIME_FOR_GRID_SPINNER);
		
		var gridAction = 'refresh';
		if(this.currentPage) 
			gridAction += '&page=' + this.currentPage;
			
		var myRequest = new Request({
			url: 'apia.execution.FormAction.run?action=processGridFieldAction&gridAction=' + gridAction + '&frmId=' +  frmId + '&frmParent=' + frmParent + '&fldId=' + this.fldId + TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
				//AJAX exitoso
		    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
		    	
		    		//Errorres y mensajes
		    		checkErrors(responseXML);
		    		
		    		//Control para xml de ie
		    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
		    		
		    		if(response.tagName == 'result' && response.getAttribute('success')) {
		    			
		    				//element.index_selected = null;
		    			//element.tr_selected = [];
		    			
		    			var h_scroll = window.scrollX || window.screenLeft;
		    			var v_scroll = window.scrollY || window.screenTop;
		    			
		    			var cantCols = element.gridColumns.length;
		    			for(var i = cantCols - 1; i >= 0; i--) {
		    				delete element.gridColumns[i];
		    			}
		    			
		    			//Parsear XML
		    			var xmlDoc;
		    			if (window.DOMParser) {
		    				parser = new DOMParser();
		    				xmlDoc = parser.parseFromString(response.getAttribute('gridXml'),"text/xml");
		    			} else {
		    				// Internet Explorer
		    				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		    				xmlDoc.async = false;
		    				xmlDoc.loadXML(response.getAttribute('gridXml')); 
		    			}
		    			
			    			//Limpiar options
			    			element.setDefaultOptions();
		    			
		    			element.xml = xmlDoc.childNodes[0];
		    			
			    			//Obtener options
			    			//var options = JSON.decode(element.xml.getAttribute(Field.FIELD_PROPERTIES));
			    			//Simular la inserción en un jsp
		    			var options = JSON.decode(new Element('div').set('html', element.xml.getAttribute(Field.FIELD_PROPERTIES)).get('text'));
		    			
			    			//Actualiar options
			    			element.setOptions(options);
			    			element.setBooleanOptions();
		    				
		    			element.parseXML(true);
		    			
		    			element.ajaxBusClassExecuting = false;	//Bajar bandera
		    			/*
		    			if(element.index_selected != null) {		    				
		    				var aux_indexes = element.index_selected;
		    				element.index_selected = [];		    				
		    				$each(aux_indexes, function (t_index) { element.addToSelectRowByIndex(t_index + 1);});
		    			}
		    			*/
		    			
		    			$$("input.datePicker").each(setAdmDatePicker);
		    			
		    			if(!Browser.ie)
		    				window.scrollTo(h_scroll, v_scroll);
		    			
		    		} else {
	 		    		//TODO
		    			showMessage(LBL_ERROR);		    			
	 		    	}
	 		    		
 		    		if(element.spinner && !element.spinner.hidden)
 	    				element.hideSpinner(true);
 	    			else
 	    				clearTimeout(tId)
 	    				
 	    			element.exec_ajax_call = false;
 		    		
		    	} else {
		    		//TODO
		    		showMessage(LBL_ERROR);		
		    	}
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO
		    	showMessage(LBL_ERROR);		
		    }
		}).send();
	},
	
	clearPage: function(page) {		
		
		var page_to_del = Number.from(page);
		if(page_to_del == null)
			return;
		
		if(this.exec_ajax_call)
			return;
		
		this.exec_ajax_call = true;
		
		this.disposeRequiredChilds();
		
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		
		var element = this;
		
		var tId = setTimeout(function() {element.showSpinner();}, Field.WAITTIME_FOR_GRID_SPINNER);
		
		var myRequest = new Request({	    
			url: 'apia.execution.FormAction.run?action=processGridFieldAction&gridAction=clearPage&frmId=' +  frmId + '&frmParent=' + frmParent + '&fldId=' + this.fldId + "&page=" + page_to_del  + TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
				//AJAX exitoso
		    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
		    	
		    		//Errorres y mensajes
		    		checkErrors(responseXML);
		    		
		    		//Control para xml de ie
		    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
		    		
		    		if(response.tagName == 'result' && response.getAttribute('success')) {
		    			
		    			//element.index_selected = null;
		    			element.tr_selected = [];
		    			
		    			var h_scroll = window.scrollX || window.screenLeft;
		    			var v_scroll = window.scrollY || window.screenTop;
		    			
		    			var cantCols = element.gridColumns.length;
		    			for(var i = cantCols - 1; i >= 0; i--) {
		    				delete element.gridColumns[i];
		    			}
		    			
		    			//Parsear XML
		    			var xmlDoc;
		    			if (window.DOMParser) {
		    				parser = new DOMParser();
		    				xmlDoc = parser.parseFromString(response.getAttribute('gridXml'),"text/xml");
		    			} else {
		    				// Internet Explorer
		    				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		    				xmlDoc.async = false;
		    				xmlDoc.loadXML(response.getAttribute('gridXml')); 
		    			}
		    			
		    			element.xml = xmlDoc.childNodes[0];		    			
		    			
		    			element.parseXML(true);
		    			
		    			//Restaurar la seleccion
		    			if(element.index_selected != null) {		    				
		    				var aux_indexes = element.index_selected;
		    				element.index_selected = [];		    				
		    				$each(aux_indexes, function (t_index) { element.addToSelectRowByIndex(t_index - 1);});
		    			}
		    			
		    			$$("input.datePicker").each(setAdmDatePicker); 
		    			
		    			if(!Browser.ie)
		    				window.scrollTo(h_scroll, v_scroll);
	    			
		    		} else {
		    			//TODO
		    			showMessage(LBL_ERROR);		    			
		    		}
		    		
		    		if(element.spinner && !element.spinner.hidden)
	    				element.hideSpinner(true);
	    			else
	    				clearTimeout(tId)
	    				
	    			element.exec_ajax_call = false;
		    		
		    	} else {
		    		//TODO
		    		showMessage(LBL_ERROR);	
		    	}
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO
		    	showMessage(LBL_ERROR);	
		    }
		}).send();
	},
	
	clearGrid: function(clearReadonlyFields) {
		
		if(this.exec_ajax_call) return;
		
		this.disposeRequiredChilds();
		
		this.exec_ajax_call = true;
		
		var frmParent = this.frmId;
		var frmId = this.frmId;
		var frmStrSplited = frmId.split('_');
		if(frmStrSplited.length > 1) {
			frmParent = frmStrSplited[0];
			frmId = frmStrSplited[1];
		}
		
		var element = this;
		var tId = setTimeout(function() {element.showSpinner();}, Field.WAITTIME_FOR_GRID_SPINNER);
		
		var clearRos = '&clearReadonly=false';
		if(clearReadonlyFields)
			clearRos = '&clearReadonly=true';
		
		var myRequest = new Request({
			url: 'apia.execution.FormAction.run?action=processGridFieldAction&gridAction=clearGrid&frmId=' +  frmId + '&frmParent=' + frmParent + '&fldId=' + this.fldId + clearRos + TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
				//AJAX exitoso
		    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
		    	
		    		//Errorres y mensajes
		    		checkErrors(responseXML);
		    		
		    		//Control para xml de ie
		    		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
		    		
		    		if(response.tagName == 'result' && response.getAttribute('success')) {
		    			
		    			//element.index_selected = null;
		    			element.tr_selected = [];
		    			
		    			var h_scroll = window.scrollX || window.screenLeft;
		    			var v_scroll = window.scrollY || window.screenTop;
		    			
		    			var cantCols = element.gridColumns.length;
		    			for(var i = cantCols - 1; i >= 0; i--) {
		    				delete element.gridColumns[i];
		    			}
		    			
		    			//Parsear XML
		    			var xmlDoc;
		    			if (window.DOMParser) {
		    				parser = new DOMParser();
		    				xmlDoc = parser.parseFromString(response.getAttribute('gridXml'),"text/xml");
		    			} else {
		    				// Internet Explorer
		    				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		    				xmlDoc.async = false;
		    				xmlDoc.loadXML(response.getAttribute('gridXml')); 
		    			}
		    			
		    			element.xml = xmlDoc.childNodes[0];		    			
		    			
		    			element.parseXML(true);
		    			
		    			//Restaurar la seleccion
		    			if(element.index_selected != null) {		    				
		    				var aux_indexes = element.index_selected;
		    				element.index_selected = [];		    				
		    				$each(aux_indexes, function (t_index) { element.addToSelectRowByIndex(t_index - 1);});
		    			}
		    			
		    			$$("input.datePicker").each(setAdmDatePicker); 
		    			
		    			if(!Browser.ie)
		    				window.scrollTo(h_scroll, v_scroll);
	    			
		    		} else {
		    			//TODO
		    			showMessage(LBL_ERROR);		    			
		    		}
		    		
		    		if(element.spinner && !element.spinner.hidden)
	    				element.hideSpinner(true);
	    			else
	    				clearTimeout(tId)
	    				
	    			element.exec_ajax_call = false;
		    		
		    	} else {
		    		//TODO
		    		showMessage(LBL_ERROR);	
		    	}
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO
		    	showMessage(LBL_ERROR);	
		    }
		}).send();
	},
	
	handleFormMove: function(action, source) {
		if(action == 'init') {
			this.editionTable.setStyle('visibility', 'hidden');
		} else if(action == 'end') {			
			this.editionTable.position({
			    relativeTo: this.divBody,
			    position: 'upperLeft',
			    edge: 'upperRight'
			});
			this.editionTable.setStyle('visibility', '');
		}
	},
	
	handleTabFocus: function() {
		if(this.editionTable) {
//			var pos = this.divBody.getPosition();
			
//			this.editionTable.setStyles({
//				top: pos.y,
//				//left: pos.x - Number.from(this.editionTable.getStyle('width'))
//				left: pos.x - Number.from(this.editionTable.getWidth())
//			});
			
			this.editionTable.position({
			    relativeTo: this.divBody,
			    position: 'upperLeft',
			    edge: 'upperRight'
			});
			
			//var rowHeights = this.divBody.getElements('tr').getStyle('height');
			var rowHeights = this.divBody.getElements('tr').getHeight();
			this.editionTable.getChildren().each(function(div, i) {
				div.setStyle('height', rowHeights[i]);
			});
		}
	},
	
	/**
	 * Quita los hijos de la grilla requeridos del formcheck
	 */
	disposeRequiredChilds: function() {
		for(var i = 0; i < this.gridColumns.length; i++) {
			for(var j = 1; j < this.gridColumns[i].length; j++) {
				var field = this.gridColumns[i][j];
				if(field.options[Field.PROPERTY_REQUIRED]) {
					//$('frmData').formChecker.dispose(this.content.getElement('input'));
					//Usamos la funci�n gen�rica
					if(field.apijs_setProperty) {
						try {
							field.apijs_setProperty(Field.PROPERTY_REQUIRED, false);
						} catch(error) {
							if(window.console && console.log) console.log(error.message);
						}
					}	
				}
			}
		}
		
	},
	
	ajaxBusClassExecuting: false,
	
	/**
	 * Para recargar de clases de negocio java ajax
	 */
	forceAjaxReload: function(xml) {
//		if(xml.getAttribute("r") == "gC")
		
		this.ajaxBusClassExecuting = true;
		this.refreshGrid();
		
//		if(xml.childNodes) {
//			var prps = xml.childNodes[0];
//			for(var i = 0; i < prps.childNodes.length; i++) {
//				var p = prps.childNodes[i].getAttribute("i");
//				var v = prps.childNodes[i].getAttribute("v");
//				//Implementadas
//				if( p == Field.PROPERTY_VISIBILITY_HIDDEN || p == Field.PROPERTY_CSS_CLASS) {
//					this.apijs_setProperty(p, v);
//				} else if (p == Field.PROPERTY_HIDE_GRID_BTN){
//					
//				}
//			}
//		}
	},
	
	/**********************FUNCIONES APIJS******************************/
	
	/**
	 * Retorna un ApiaField representando un campo de la grilla, seg�n nombre e indice
	 */
	apijs_getField: function(fldName, index) {		
		var idx = index + 1; //Para tener en cuenta el cabezal en las columnas de la grilla
		if(this.gridColumns) {
			for(var i = 0; i < this.gridColumns.length; i++) {
				var gridElement = this.gridColumns[i];
				if(gridElement.length > idx && gridElement[idx].options[Field.PROPERTY_NAME] && gridElement[idx].options[Field.PROPERTY_NAME].toUpperCase() == fldName) {
					return new ApiaField(gridElement[idx], true);
				}
			}
		}
		return null;
	},
	
	/**
	 * Retorna un Array de ApiaField's representando una columna de la grilla
	 */
	apijs_getColumn: function(fldName) {
		var res = new Array();
		if(this.gridColumns) {
			for(var i = 0; i < this.gridColumns.length; i++) {
				var gridElement = this.gridColumns[i];
				if(gridElement.length > 1 && gridElement[1].options[Field.PROPERTY_NAME] && gridElement[1].options[Field.PROPERTY_NAME].toUpperCase() == fldName) {
					for(var j = 1; j < gridElement.length; j++) {
						res.push(new ApiaField(gridElement[j], true));
					}
					break;
				}
			}
		}
		return res;
	},
	
	/**
	 * Retorna un Array de ApiaField's representando una fila de la grilla
	 */
	apijs_getRow: function(index) {
		var res = new Array();
		var idx = index + 1; //Para tener en cuenta el cabezal en las columnas de la grilla
		if(this.gridColumns) {
			for(var i = 0; i < this.gridColumns.length; i++) {
				var gridElement = this.gridColumns[i];
				if(gridElement.length > idx) {
					res.push(new ApiaField(gridElement[idx], true));
				}
			}
		}
		return res;
	},
	
	/**
	 * Elimina una fila de elementos de la grilla
	 */
	apijs_deleteRow: function(index) {
		var toDel = new Array();
		if(typeOf(index) == 'array') {
			for(var i = 0; i < index.length; i++) {
				if(this.gridColumns && this.gridColumns.length && this.gridColumns[0] && this.gridColumns[0].length > Number.from(index[i]) + 1) {//+1 por el header 
					toDel.push(this.startIndex + Number.from(index[i])); //aca no se considera el header
				}
			}
			if(toDel.length) {
				//Ordenar en orden descendente
				var toDelAux = toDel;
				toDel = new Array();
				var length = toDelAux.length;
				var max;
				while(toDel.length < length) {
					max = 0;
					for(var i = 0; i < toDelAux.length; i++) {
						if(max < toDelAux[i]) 
							max = toDelAux[i];
					}
					toDelAux.erase(max);
					toDel.push(max);
				}
				
				this.deleteRow(toDel, false, true);
			}
		} else {
			if(this.gridColumns && this.gridColumns.length && this.gridColumns[0] && this.gridColumns[0].length > index + 1) {//+1 por el header 
				toDel.push(this.startIndex + Number.from(index)); //aca no se considera el header
				
				this.deleteRow(toDel, false, true);
			}
		}
		
			
	},
	
	/**
	 * Elimina todos los campos de una pagina de la grilla.
	 * Las paginas inician desde 1
	 */
	apijs_deletePage: function(page) {
		if(page > 0 && page <= this.pages ) {
			var toDel = new Array();
			var cant_rows_per_page = Number.from(this.options[Field.PROPERTY_PAGED_GRID_SIZE]);
			var start_idx = (page - 1) * cant_rows_per_page;
			var end_idx = start_idx + cant_rows_per_page - 1;
			for(var index = end_idx; index >= start_idx; index--)
				toDel.push(this.startIndex + index);
			if(toDel.length)
				this.deleteRow(toDel);
		}
	},
	
	/**
	 * Elimina todos los campos de una grilla
	 */
	apijs_deleteGrid: function() {
		
		//TODO: Verificar que pasa cuando le paso indices que no existe. Ocurre en el caso
		//de que la ultima pagina no este completa
		
		var toDel = new Array();
		var cant_rows_per_page = Number.from(this.options[Field.PROPERTY_PAGED_GRID_SIZE]);
		
		var max_index = 0;
		
		if(this.options[Field.PROPERTY_PAGED_GRID]) {
			max_index = this.pages * cant_rows_per_page - 1;
		} else {
			
			if(this.gridColumns && this.gridColumns.length && this.gridColumns[0] && this.gridColumns[0].length)
				max_index = this.gridColumns[0].length;  //+1 por el header
			
		}
		
		for(var index = max_index; index >= 0; index--)
			toDel.push(index);
		
		if(toDel.length)
			this.deleteRow(toDel);
	},
	
	/**
	 * Limpia los valores de una fila de la grilla
	 */
	apijs_clearRow: function(index) {
		if(this.gridColumns && this.gridColumns.length && this.gridColumns[0] && this.gridColumns[0].length > index + 1){ //+1 por el header
			this.gridColumns.each(function(gridCol) {
				//gridCol[index + 1].clearValue();
				gridCol[index + 1].apijs_clearValue();
			});
		}
	},
	
	/**
	 * Limpia el valor de todos los campos de la pagina actual de la grilla
	 */
	apijs_clearPage: function(page) {		
		if(this.gridColumns && this.gridColumns.length && this.gridColumns[0] && this.gridColumns[0].length > 1) { //+1 por el header
			//this.gridColumns.each(function(gridCol) {
			//	for(var i = 1; i < gridCol.length; i++)
			//		gridCol[i].clearValue();
			//});
			if(page <= this.pages)
				this.clearPage(page);
			else
				throw new Error("Invalid page, current grid has only " + this.pages + " pages.");
		}
	},
	
	/**
	 * Limpia el valor de todos los campos de la grilla
	 */
	apijs_clearGrid: function(clearReadonlyFields) {
		//TODO: Ir contra un action del server y redibujar la grilla
		if(this.gridColumns && this.gridColumns.length && this.gridColumns[0] && this.gridColumns[0].length > 1){ //+1 por el header
			this.clearGrid(clearReadonlyFields);
		}
	},
	
	/**
	 * Agrega una fila al final de la grilla, simulando el addRow
	 */
	apijs_addRow: function(cant) {
		this.addRow(false, true, cant);
	},
	
	/**
	 * Retorna true si la grilla es paginada
	 */
	apijs_isPaged: function() {
		return this.options[Field.PROPERTY_PAGED_GRID] == true ;
	},
	
	/**
	 * Retorna la cantidad de paginas de la grilla 
	 */
	apijs_getPageCount: function() {
		return this.pages;
	},
	
	/**
	 * Retorna la pagina actual
	 */
	apijs_getCurrentPage: function() {
		return this.currentPage;
	},
	
	/**
	 * Retorna los indices seleccionados
	 */
	apijs_getSelectedIndexes: function(useAbsoluteIndex) {
		var res = new Array();
		if(this.index_selected) {
			var selection = this.index_selected.clone();
			selection.sort();
			$each(selection, function(val) {
				if(useAbsoluteIndex)
					res.push(val);
				else
					res.push(val - this.startIndex);
			}.bind(this));
		}
		return res;
	},
	
	/**
	 * Retorna las filas seleccionadas
	 */
	apijs_getSelectedItems: function() {
		var res = new Array();
		if(this.index_selected) {
			var selection = this.index_selected.clone();
			selection.sort();
			$each(selection, function(val) {
				res.push(this.apijs_getRow(val - this.startIndex));
			}.bind(this));
		}
		return res;
	},
	
	/**
	 * Retorna un array con todas las columnas. Cada columna es un array de ApiaField's
	 */
	apijs_getAllColumns: function() {
		var res = new Array();
		if(this.gridColumns) {
			for(var i = 0; i < this.gridColumns.length; i++) {
				var res_i = [];
				var gridElement = this.gridColumns[i];
				if(gridElement.length > 1) {
					for(var j = 1; j < gridElement.length; j++) {
						res_i.push(new ApiaField(gridElement[j], true));
					}
				}
				res.push(res_i);
			}
		}
		return res;
	},
	
	getPrintHTML: function(formContainer) {
		
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			
			var fieldContainer = this.parsePrintXMLposition(formContainer);
			
			if(this.options[Field.PROPERTY_GRID_TITLE]) {
				var label = new Element('label').appendText(this.options[Field.PROPERTY_GRID_TITLE]);
				label.inject(fieldContainer);
			}
			
			var gridContainer = new Element('div');
			
			if(this.options[Field.PROPERTY_GRID_PRINT_HORIZONTAL]) {
			
				var table = new Element('table.horizontal-grid');
				var tbody = new Element('tbody');
				
				var tr = new Element('tr');
				for(var j = 0; j < this.gridColumns.length; j++) {
					var gridElement = this.gridColumns[j];
					if(gridElement.length > 0 && !gridElement[0].container.hasClass('visibility-hidden') && gridElement[0].field_type != Field.TYPE_HIDDEN && gridElement[0].field_type != Field.TYPE_BUTTON) {
						new Element('th', {
							html: gridElement[0].container.getChildren('div').get('html')
						}).inject(tr);
					}
				}
				tr.inject(new Element('thead').inject(table));
				
				if(this.gridColumns) {
					for(var i = 1; i < this.max_index + 1; i++) {
						tr = new Element('tr');
						for(j = 0; j < this.gridColumns.length; j++) {
							var gridElement = this.gridColumns[j];
							if(gridElement.length > i && !gridElement[i].content.hasClass('visibility-hidden') && gridElement[i].xml.getAttribute("fieldType") != Field.TYPE_HIDDEN && gridElement[i].xml.getAttribute("fieldType") != Field.TYPE_BUTTON) {
								var value = '';
								try {
									value = gridElement[i].getValueHTMLForGrid();
								} catch(errrr) {}
								
								new Element('td', {
									html: value 
								}).inject(tr);
							}
						}
						tr.inject(tbody);
					}
				}
				tbody.inject(table);
				table.inject(gridContainer);
				
			} else {
				
				if(this.gridColumns) {
					for(var i = 1; i < this.max_index + 1; i++) {
						
						var table = new Element('table.row-container');
						
						for(var j = 0; j < this.gridColumns.length; j++) {
							var gridElement = this.gridColumns[j];
							if(gridElement.length > i) {
								var field = gridElement[i];
								
								try {
									var tr = new Element('tr', {
										html: field.getPrintHTMLForGrid()
									}).inject(table);
								} catch(err) {}
							}
						}
						
						table.inject(gridContainer);
					}
				}
				
			}
			gridContainer.inject(fieldContainer);
		}
	},
	
	addTrKeyListener: function(tr) {
		tr.addEvent('keydown', function(e) {
			if(e.key == 'down') {
				e.preventDefault();
				var next = this.getNext('tr');
				if(next) {
					next.set('tabIndex').focus();
//					this.removeAttribute('tabIndex');
				}
			} else if(e.key == 'up') {
				e.preventDefault();
				var prev = this.getPrevious('tr'); 
				if(prev) {
					prev.set('tabIndex').focus();
//					this.removeAttribute('tabIndex');
				}
			}
		}.bind(tr)).addEvent('keypress', function(e) {
			if(e.key == 'space' && e.target == this) {
				e.preventDefault();
				this.fireEvent('click', e);
			}
		}.bind(tr));
	},
	
	showFormListener: function() {
		if(this.gridColumns) {
			for(var i = 0; i < this.gridColumns.length; i++) {
				var gridElement = this.gridColumns[i];
				for(var j = 1; j < gridElement.length; j++) {
					gridElement[j].showFormListener();
				}
			}
		}
	},
	
	hideFormListener: function() {
		if(this.gridColumns) {
			for(var i = 0; i < this.gridColumns.length; i++) {
				var gridElement = this.gridColumns[i];
				for(var j = 1; j < gridElement.length; j++) {
					gridElement[j].hideFormListener();
				}
			}
		}
	},
	
	resize_timer: null,
	resize_timeout: 1000,
	
	window_resized: function() {
		if(this.resize_timer != null) {
			//detener el timer
			clearTimeout(this.resize_timer);
		}
		this.resize_timer = setTimeout(function() {
			this.resize_timeout = null;
			if(!window.appletToken) {
				this.visualRefreshGrid();
			}
		}.bind(this), this.resize_timeout);
	}
});

Grid.tags = {
	gridHeader 		: 'gridHeader',
	gridHeaderCol	: 'col',
	gridField		: 'field'
};

var GridHeader = new Class({

	Implements: Options,
	
	options: {},
	
	container: null,
	
	col_fields: [],
	
	field_type: null,
	
	parentGrid: null,
	
	col_index: null,
	
	booleanOptions: [Field.PROPERTY_VISIBILITY_HIDDEN],
	
	col_fld_id: null,
	
	initialize: function(th_container, title,tooltip, type, opts, fn_col_select, exec_ajax_call) {		
		this.container = th_container;
		this.setDefaultOptions();
		this.setOptions(opts);
		this.field_type = type;
		
		//Pasar a booleanos
		for(var i = 0; i < this.booleanOptions.length; i++) {
			var val = this.options[this.booleanOptions[i]];
			if(val && (val+"").toUpperCase().contains('T'))
				this.options[this.booleanOptions[i]] = true;
			else
				this.options[this.booleanOptions[i]] = false;
		}
		
		if(this.options[Field.PROPERTY_GRID_LABEL])
			title = this.options[Field.PROPERTY_GRID_LABEL];
		
		this.container.set('html', '');
		if(exec_ajax_call)
			this.container.set('html', '<div class="gridMinWidth" title="' + tooltip + '">' + title + '</div>');
		else
			new Element('div.gridMinWidth', {text: title,title: tooltip}).inject(this.container);
		
//		this.container.set('html', '<div class="gridMinWidth">' + title + '</div>');
		
		if(type == Field.TYPE_HIDDEN || this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.container.addClass('visibility-hidden');
		
		if(Number.from(this.options[Field.PROPERTY_COL_WIDTH]))
			this.container.getElements('div')[0].setStyle('width', Number.from(this.options[Field.PROPERTY_COL_WIDTH]));
		
		if(fn_col_select)
			this.container.getElement('div').addClass("col-as-link").addEvent('click', function() {
				var grid = new ApiaField(this.parentGrid);
				grid.selected_col_index = this.col_index;
				fn_col_select(grid);
			}.bind(this));
	},
	
	setDefaultOptions: function() {
		
		this.options[Field.PROPERTY_VISIBILITY_HIDDEN] 	= null;
		this.options[Field.PROPERTY_COL_WIDTH]			= null;
		this.options[Field.PROPERTY_GRID_LABEL]			= null;
	},
	
	checkVisibility: function() {
		
		if(this.field_type == 'hidden')
			return;
		
		var allHidden = true;
		
		if(this.col_fields && this.col_fields.length) {
			for(var i = 0; i < this.col_fields.length; i++) {
				var hidden = this.col_fields[i].options[Field.PROPERTY_VISIBILITY_HIDDEN];
				
				allHidden = allHidden && hidden;
			}
		}
		
		if(allHidden) {
			this.hideAllColumn();
		} else {
			this.showAllColumn();
		}
	},
	
	/**
	 * Hace visible la columna, manteniendo oculto el contenido de los campos 
	 */
	showAllColumn: function() {
		this.container.removeClass('visibility-hidden');
		if(this.col_fields && this.col_fields.length) {
			for(var i = 0; i < this.col_fields.length; i++) {
				var hidden = this.col_fields[i].options[Field.PROPERTY_VISIBILITY_HIDDEN];
				
				this.col_fields[i].content.removeClass('visibility-hidden');
				
				if(hidden) {
					this.col_fields[i].content.getElement('div').addClass('visibility-hidden');
				} else {
					this.col_fields[i].content.getElement('div').removeClass('visibility-hidden');
				}
			}
		}
	},
	
	/**
	 * Oculta la columna
	 */
	hideAllColumn: function() {
		this.container.addClass('visibility-hidden');
		if(this.col_fields && this.col_fields.length) {
			for(var i = 0; i < this.col_fields.length; i++) {				
				this.col_fields[i].content.addClass('visibility-hidden');
				this.col_fields[i].content.getElement('div').removeClass('visibility-hidden');
			}
		}
	},
	
	/**
	 * Corrige visibilidad cuando se agrega una nueva fila
	 */
	fixVisibility: function(field) {
		if(!this.container.hasClass('visibility-hidden')) {
			//La columna esta visible
			
			var hidden = field.options[Field.PROPERTY_VISIBILITY_HIDDEN];
			
			if(hidden) {
				field.content.removeClass('visibility-hidden');
				field.content.getElement('div').addClass('visibility-hidden');
			}
		}
	}
	
});
