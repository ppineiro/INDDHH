/**
 * Campo File input
 */
var Fileinput = new Class({
	
	Extends: Field,
	
	Implements: GridField,
	
	file_prp: {},
	
	doc_id: null,
	
	canRead: true,
	
	canEdit: true,
	
	isLocked: "false", //false, true, me
	lockedBy: null,
	
	markedToSign: false,
	
	lang_id: null,
	
	translations: [],
	
	initialize: function(form, frmId, xml, rowXml) {
		//Establecer las opciones
		this.setDefaultOptions();
		this.xml = xml;
		
		if(this.xml.getAttribute("langId"))
			this.lang_id = this.xml.getAttribute("langId");
		
		if(rowXml) {
			//Es de una grilla. Obtenemos las propiedades de rowXml
			this.parent(form, frmId, xml.getAttribute("id"), JSON.decode(rowXml.getAttribute(Field.FIELD_PROPERTIES)), xml.getAttribute("attId"));
			this.row_xml = rowXml;
		} else {
			//No es de una grilla
			this.parent(form, frmId, xml.getAttribute("id"), JSON.decode(xml.getAttribute(Field.FIELD_PROPERTIES)), xml.getAttribute("attId"));
			
			if(!this.lang_id)
				this.parseXML();
		}	
	},

	setDefaultOptions: function() {
		this.options[Field.PROPERTY_NAME] 					= null;
		this.options[Field.PROPERTY_VALUE]					= null;
		this.options[Field.PROPERTY_READONLY] 				= null;
		this.options[Field.PROPERTY_DISABLED] 				= null;
		this.options[Field.PROPERTY_REQUIRED] 				= null;
		this.options[Field.PROPERTY_HIDE_DOC_PERMISSIONS]	= null;
		this.options[Field.PROPERTY_HIDE_DOC_METADATA]		= null;
		this.options[Field.PROPERTY_HIDE_DOC_UPLOAD] 		= null; //oculta el boton de upload
		this.options[Field.PROPERTY_HIDE_DOC_DOWNLOAD] 		= null; //oculta el boton de descargar
		this.options[Field.PROPERTY_HIDE_DOC_ERASE] 		= null; //oculta el boton de borrar
		this.options[Field.PROPERTY_HIDE_DOC_LOCK] 			= null; //oculta el boton de lock
		this.options[Field.PROPERTY_HIDE_DOC_SIGN]			= null; //oculta el boton de firma
		
		this.options[Field.PROPERTY_NO_MODIFY] 				= null; //muestra deshabilitado el boton de modificar
		this.options[Field.PROPERTY_NO_DOWNLOAD] 			= null; //muestra deshabilitado el boton de descargar
		this.options[Field.PROPERTY_NO_ERASE] 				= null; //muestra deshabilitado el boton de borrar
		this.options[Field.PROPERTY_NO_LOCK] 				= null; //muestra deshabilitado el boton de lock
		this.options[Field.PROPERTY_ALLOW_EDITION]			= null; //muestra deshabilitado el boton de editar
		
		//this.options[Field.PROPERTY_NO_HISTORY] 		= null;
		
		//this.options[Field.PROPERTY_HIDE_DOC_HISTORY] 		= null;
		//this.options[Field.PROPERTY_HIDE_SIGN_ICONS] 		= null;
		this.options[Field.PROPERTY_VISIBILITY_HIDDEN] 		= null;
		//this.options[Field.PROPERTY_DISPLAY_NONE] 			= null;
		
		this.options[Field.PROPERTY_FILE_PREVIEW]	 		= null;
		this.options[Field.PROPERTY_CSS_CLASS]				= null;
		this.options[Field.PROPERTY_DOC_TYPE]				= null;
		this.options[Field.PROPERTY_FONT_COLOR] 			= null;
		this.options[Field.PROPERTY_VALUE_COLOR] 			= null;
		this.options[Field.PROPERTY_SIGNATURE_REQUIRED]		= null;
		this.options[Field.PROPERTY_COL_WIDTH] 				= null;
	},
	
	booleanOptions: [Field.PROPERTY_HIDE_DOC_PERMISSIONS, Field.PROPERTY_HIDE_DOC_METADATA, Field.PROPERTY_REQUIRED, Field.PROPERTY_DISABLED, Field.PROPERTY_READONLY, 
	                 Field.PROPERTY_HIDE_DOC_UPLOAD, Field.PROPERTY_HIDE_DOC_DOWNLOAD, Field.PROPERTY_HIDE_DOC_ERASE,
	                 Field.PROPERTY_HIDE_DOC_LOCK, Field.PROPERTY_HIDE_DOC_SIGN, Field.PROPERTY_NO_MODIFY, Field.PROPERTY_NO_DOWNLOAD,
	                 Field.PROPERTY_NO_ERASE, Field.PROPERTY_NO_LOCK, Field.PROPERTY_ALLOW_EDITION, Field.PROPERTY_VISIBILITY_HIDDEN, Field.PROPERTY_FILE_PREVIEW, Field.PROPERTY_SIGNATURE_REQUIRED],
	
	getValue: function() {
		return '';
	},
	
	/**
	 * Retorna el valor para la APIJS
	 */
	apijs_getFieldValue: function() {
		var doc_name = this.content.getElement('div.docDataSinError');
		if(doc_name) return doc_name.get('text');
		return '';
	},
	
	getPrpsForGridReload: function() {
		var res = {};
		res[Field.PROPERTY_REQUIRED] = this.options[Field.PROPERTY_REQUIRED];
		res[Field.PROPERTY_READONLY] = this.options[Field.PROPERTY_READONLY];
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
		
		if(prp_name == Field.PROPERTY_NAME) {
			//throw new Error('Property can not be changed.')
		} else if(prp_name == Field.PROPERTY_FONT_COLOR && !this.row_xml) {
			this.content.getElement('span.asLabel').setStyle('color', prp_value);
			this.options[Field.PROPERTY_FONT_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_VALUE_COLOR) {
			var docDataSinError = this.content.getElement('div.docDataSinError');
			if(docDataSinError)
				docDataSinError.setStyle('color', prp_value);
			this.options[Field.PROPERTY_VALUE_COLOR] = prp_value;
		} else if(prp_name == Field.PROPERTY_REQUIRED) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_REQUIRED] == false) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					var file = this.content.getElement('div.document').addClass('validate["required","%Fileinput.customFileChecker"]');
					if(this.row_xml != undefined) {
						var div = this.content.getElement('div.gridMinWidth').addClass('gridCellRequired');
						file.setStyles({
							display: 'inline',
							'margin': 0
						});
						var btns = file.getElements('div');
						var margin_left = Generic.getHiddenWidth(div)/2 - (this.row_xml ? 73 : Generic.getHiddenWidth(file)/2 );
						btns[0].setStyle('margin-left', margin_left);
						btns[1].setStyle('margin-left', margin_left);
					} else {
						this.content.addClass('required');
					}
					$('frmData').formChecker.register(file);
				}
				this.options[Field.PROPERTY_REQUIRED] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_REQUIRED]) {
				if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
					var file = this.content.getElement('div.document').removeClass('validate["required","%Fileinput.customFileChecker"]');
	
					if(this.row_xml != undefined) {
						this.content.getElement('div.gridMinWidth').removeClass('gridCellRequired');
						file.setStyles({
							display: 'block',
							'margin': 'auto'
						});
						
						var btns = file.getElements('div');
						btns[0].setStyle('margin-left', 0);
						btns[1].setStyle('margin-left', 0);
					} else {
						this.content.removeClass('required');
					}
					$('frmData').formChecker.dispose(file);
				}
				this.options[Field.PROPERTY_REQUIRED] = false;
			}
		} else if(prp_name == Field.PROPERTY_DISABLED) {
			//TODO:
			
		} else if(prp_name == Field.PROPERTY_READONLY) {
			
			if(this.fr)
				throw new Error("Can't modify property readonly of fileinputs non editable");
			
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_READONLY] == false) {
				
				var icon = this.content.getElement('div.docUploadIcon');
				if(icon){
					icon.removeClass('docUploadIcon').addClass('docUploadIconDisabled');
					//CAMBIO HECHO POR JUAN PABLO: Para que aparezcan los botones del los FileUpload 
					//								cuando estan dentro de una grilla
					var tarea = ApiaFunctions.getCurrentTaskName();
					
					if (tarea == "CARGA_DATOS_TRAMITE"  || tarea == "RETOMA_CARGA_DATOS" ) {
						icon.addClass('docUploadIconGrilla');
					}
					//FIN DEL CAMBIO
				}
					
				icon = this.content.getElement('div.docLockIcon');
				if(icon)
					icon.removeClass('docLockIconUnlocked').removeClass('docLockIconLocked').removeClass('docLockIconLockedOther').addClass('docLockIconDisabled');
				
				icon = this.content.getElement('div.docSignIcon');
				if(icon)
					icon.removeClass('docSignIcon').addClass('docSignIconDisabled');
				
				icon = this.content.getElement('div.docEraseIcon');
				if(icon)
					icon.removeClass('docEraseIcon').addClass('docEraseIconDisabled');
				
				if(this.options[Field.PROPERTY_FILE_PREVIEW])
					this.content.getElement('div.document').setStyle('display', 'none');
									
				this.options[Field.PROPERTY_READONLY] = true;
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_READONLY]) {
				
				var icon = this.content.getElement('div.docUploadIconDisabled');
				if(icon)
					icon.removeClass('docUploadIconDisabled').addClass('docUploadIcon');
				
				icon = this.content.getElement('div.docLockIcon');
				if(icon) {
					icon.removeClass('docLockIconUnlocked').removeClass('docLockIconLocked').removeClass('docLockIconLockedOther').removeClass('docLockIconDisabled');
					
					var file_disabled = this.options[Field.PROPERTY_DISABLED] || !this.canEdit;
					var file_readonly = this.options[Field.PROPERTY_DISABLED] || (!this.canRead && !this.canEdit);
					
					if(this.doc_id == undefined || this.doc_id < 0 || file_disabled || !this.canEdit || file_readonly)
						icon.addClass('docLockIconDisabled');
					else if(this.isLocked == "false")
						icon.addClass('docLockIconUnlocked');
					else if(this.isLocked == "me")
						icon.addClass('docLockIconLocked');
					else if(this.isLocked == "true")
						icon.addClass('docLockIconLockedOther');
				}
				
				icon = this.content.getElement('div.docSignIconDisabled');
				if(icon)
					icon.removeClass('docSignIconDisabled').addClass('docSignIcon');
				
//				icon = this.content.getElement('div.docEraseIconDisabled');
				if(icon)
					icon.removeClass('docEraseIconDisabled').addClass('docEraseIcon');
				
				if(this.options[Field.PROPERTY_FILE_PREVIEW])
					this.content.getElement('div.document').setStyle('display', '');
				
				this.options[Field.PROPERTY_READONLY] = false;
			}
		} else if(prp_name == Field.PROPERTY_VISIBILITY_HIDDEN) {
			if((prp_boolean_value == true || "true" == prp_value ) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN] == false) {
				
				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = true;

				if(this.row_xml) {
					this.content.getElement('div').addClass('visibility-hidden');
					this.gridHeader.checkVisibility();
				} else {
					this.content.addClass('visibility-hidden');
				}
				
				//Si es requerido, desregistrarlo
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					var file = this.content.getElement('div.document').removeClass('validate["required","%Fileinput.customFileChecker"]');
					
					if(this.row_xml != undefined) {
						this.content.getElement('div.gridMinWidth').removeClass('gridCellRequired');
						file.setStyles({
							display: 'block',
							margin: 'auto'
						});
						
						var btns = file.getElements('div');
						btns[0].setStyle('margin-left', 0);
						btns[1].setStyle('margin-left', 0);
					} else {
						this.content.removeClass('required');
					}
					$('frmData').formChecker.dispose(file);
				}
			} else if((prp_boolean_value == false || "false" == prp_value) && this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {

				this.options[Field.PROPERTY_VISIBILITY_HIDDEN] = false;

				if(this.row_xml) {
					this.gridHeader.checkVisibility();
				} else {
					this.content.removeClass('visibility-hidden');
				}
				
				//Verificar si era requerido
				if(!this.form.readOnly && this.options[Field.PROPERTY_REQUIRED]) {
					var file = this.content.getElement('div.document').addClass('validate["required","%Fileinput.customFileChecker"]');
					if(this.row_xml != undefined) {
						var div = this.content.getElement('div.gridMinWidth').addClass('gridCellRequired');
						file.setStyles({
							display: 'inline',
							margin: 0
						});
						var btns = file.getElements('div');
						var margin_left = Generic.getHiddenWidth(div)/2 - (this.row_xml ? 73 : Generic.getHiddenWidth(file)/2);
						btns[0].setStyle('margin-left', margin_left);
						btns[1].setStyle('margin-left', margin_left);
					} else {
						this.content.addClass('required');
					}
					$('frmData').formChecker.register(file);
				}
			}
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
	 * Parsea el xml
	 */
	parseXML: function() {
		
		//Hace espacio en el formulario y ubica el campo en su lugar.
		this.parseXMLposition();
		
		this.content.getParent().erase('class');
		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.getParent().addClass(clase);
			}.bind(this));
		
		//Seteamos el tipo de atributo
		if(this.xml.getAttribute("valueType"))
			this.options.valueType = this.xml.getAttribute("valueType");
		
		//this.file_prp = JSON.decode(this.xml.getAttribute("file_prp"));
		var fprps = this.xml.getAttribute("file_prp");
		if(fprps) {
			if(this.lang_id)
				this.file_prp = JSON.decode(fprps.replace(/\\/g, '\\\\'))[this.lang_id];
			else
				this.file_prp = JSON.decode(fprps.replace(/\\/g, '\\\\'))[0];
			
			if(!this.file_prp) {
				this.file_prp = {};
			} else {
				
				if(this.file_prp.docId)
					this.doc_id = this.file_prp.docId;
				
				if(this.file_prp.downloadDocId)
					this.downloadDocId = this.file_prp.downloadDocId;
				
				this.canRead = this.file_prp.canRead;

				this.canEdit = this.file_prp.canEdit
				
				this.isLocked = this.file_prp.lock;
				this.lockedBy = this.file_prp.lockedBy;
				
				if(this.fromAjaxReload)
					this.file_prp.name = new Element('div', {html: this.file_prp.name}).get('text');
			}	
		}
				
		if(this.canEdit)
			this.canRead = true; //Si tengo permiso de modificacion tambien tengo permiso de lectura
		
		if(this.form.readOnly) {
			this.canEdit = false;
			//this.canRead = true; //Si no se podia leer, mantener eso
		}
		
		if(this.file_prp.sign)
			this.markedToSign = true;
		
		
		this.content.addClass(this.xml.getAttribute('attName'));
		//LABEL
		
		var label = new Element('span.asLabel.asLabelFileinput')
		if(this.fromAjaxReload)
			label.set('html', this.xml.getAttribute("attLabel") + ':');
		else
			label.appendText(this.xml.getAttribute("attLabel") + ':');
		
		if(this.options[Field.PROPERTY_FONT_COLOR])
			label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
		
		//FILE
		
		var file = new Element('div.document', {
			'data-fld_id': this.frmId + "_" + this.fldId
		});
		
		file.set('data-attLabel', this.xml.getAttribute("attLabel"));
		
		if(this.form.readOnly) {
			file.addClass('monitor-fileinput');
			label.addClass('monitor-lbl');
			this.content.addClass('monitor_field');
		}
		
		var doc_name = new Element('div.docDataSinError').inject(file);
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			doc_name.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		var formId = this.frmId.split('_')[1];
		var attributeId = this.attId;
		var frmParent = this.frmId.split('_')[0];
		 
		var file_disabled = this.options[Field.PROPERTY_DISABLED] || !this.canEdit;
		var file_readonly = this.options[Field.PROPERTY_READONLY] || this.options[Field.PROPERTY_DISABLED] || !this.canRead;
		
		this.fr = this.options[Field.PROPERTY_READONLY];
		
		if(!window.kb && !this.options[Field.PROPERTY_HIDE_DOC_UPLOAD] && !this.options[Field.PROPERTY_NO_MODIFY]) {
			var upload = new Element('div.docIcon', {
				title: BTN_FILE_UPLOAD_LBL,
				tabIndex: ''
			}).inject(file);
			
			if(!file_disabled && this.canEdit && !(this.isLocked == "true") && !file_readonly) {
				upload.addClass('docUploadIcon').addEvent('click', this.uploadEvent).addEvent('keypress', Generic.enterKeyToClickListener);
			} else {
				upload.addClass('docUploadIconDisabled');
			}
		}
		
		if(!this.options[Field.PROPERTY_HIDE_DOC_DOWNLOAD] && !this.options[Field.PROPERTY_NO_DOWNLOAD]) {
			if(this.doc_id != undefined && this.canRead) {
				/*
				var a = new Element('a',  {
					'download': 'true',
					href: CONTEXT + '/page/generic/downloadAttDoc.jsp?action=download&frmParent=' + frmParent + '&frmId=' + formId + '&attId=' + attributeId + '&index=' + this.index + '&docId=' + this.doc_id + (this.lang_id ? '&langId=' + this.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : '')
				});
				a.setAttribute('aria-label',BTN_FILE_DOWNLOAD_LBL);
				new Element('div.docDownloadIcon', {
					title: BTN_FILE_DOWNLOAD_LBL
				}).addClass('docIcon').inject(a);
				a.inject(file);
				*/
				var divDown = new Element('div.docDownloadIcon', {
					title: BTN_FILE_DOWNLOAD_LBL
				}).addClass('docIcon').inject(file).addEvent('click', function(e){
					e.stop();
					
					if (isMonitor){
						window.location = this.getElement('a').href;
					} else {
						//En ejecución se espera por edicion sincronizada
						var file_object = this.getParent().getParent().retrieve(Field.STORE_KEY_FIELD);
						file_object.retriesCount = 10;
						syncWebDavDocumentLock(file_object, file_object.doc_id, function(){
							window.location = this.getElement('a').href;					
						}.bind(this))	
					}
				});
				
				var a = new Element('a', {
					'download': 'true',
					href: CONTEXT + '/page/generic/downloadAttDoc.jsp?action=download&frmParent=' + frmParent + '&frmId=' + formId + '&attId=' + attributeId + '&index=' + this.index + '&docId=' + encodeURIComponent(this.downloadDocId) + (this.lang_id ? '&langId=' + this.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : '')
				}).inject(divDown);
			} else {
				new Element('div.docDownloadIconDisabled', {
					title: BTN_FILE_DOWNLOAD_LBL,
					tabIndex: ''
				}).addClass('docIcon').inject(file);
			}
		}
		
		var doc_info = new Element('div.docIcon', {
			title: BTN_FILE_INFO_LBL,
			tabIndex: ''
		}).inject(file);
		
		this.infoEvent = this.showModalInfo.bind(this);
		
		if(this.doc_id != undefined && this.doc_id > 0 && this.canRead) {
			doc_info.addClass('docInfoIcon').addEvent('click', this.infoEvent).addEvent('keypress', Generic.enterKeyToClickListener);
		} else {
			doc_info.addClass('docInfoIconDisabled');
		}
		/*
		var doc_edit = null;
		if (this.options[Field.PROPERTY_ALLOW_EDITION]){
			doc_edit = new Element('div.docIcon.docEditIcon.docEditIconDisabled', {
				title: LBL_EDIT,
				tabIndex: ''
			}).inject(file);	
		}
		*/
		
		if(!window.kb && !this.options[Field.PROPERTY_HIDE_DOC_LOCK] && !this.options[Field.PROPERTY_NO_LOCK]) {
			var doc_lock = new Element('div.docIcon', {
				title: BTN_FILE_LOCK_LBL,
				tabIndex: ''
			}).addClass('docLockIcon');
			if(this.doc_id == undefined || this.doc_id < 0 || file_disabled || !this.canEdit || file_readonly) {
				doc_lock.addClass('docLockIconDisabled').inject(file);
			} else if(this.isLocked == "false") {
				doc_lock.addClass('docLockIconUnlocked').inject(file);
				doc_lock.addEvent('click', this.lockDocument).addEvent('keypress', Generic.enterKeyToClickListener);
			} else if(this.isLocked == "me") {
				doc_lock.addClass('docLockIconLocked').inject(file);
				doc_lock.addEvent('click', this.unlockDocument).addEvent('keypress', Generic.enterKeyToClickListener);
			} else if(this.isLocked == "true") {
				doc_lock.addClass('docLockIconLockedOther').inject(file);
				doc_lock.addEvent('click', this.refreshLock).addEvent('keypress', Generic.enterKeyToClickListener);
			}
		}
		
		if(!this.options[Field.PROPERTY_HIDE_DOC_SIGN]) {
			
			if(!window.kb) {
				if(this.doc_id != undefined  && !file_disabled && !(this.isLocked == "true") && !this.form.readOnly && !file_readonly) {
					var _docSignIcon = new Element('div.docSignIcon', {
						title: BTN_FILE_SIGN_LBL,
						tabIndex: ''
					}).addClass('docIcon').inject(file).addEvent('click', this.signEvent).addEvent('keypress', Generic.enterKeyToClickListener);
					
					if(this.markedToSign)
						_docSignIcon.addClass('docMarkedToSignIcon');
					
				} else {
					new Element('div.docSignIconDisabled', {
						title: BTN_FILE_SIGN_LBL,
						tabIndex: ''
					}).addClass('docIcon').inject(file);
				}
			}
			
			if(this.doc_id != undefined  && this.canRead) {
				new Element('div.docVerifySignIcon', {
					title: BTN_FILE_VERIFY_LBL,
					tabIndex: ''
				}).addClass('docIcon').inject(file).addEvent('click', this.verifSignEvent).addEvent('keypress', Generic.enterKeyToClickListener);
			} else {
				new Element('div.docVerifySignIconDisabled', {
					title: BTN_FILE_VERIFY_LBL,
					tabIndex: ''
				}).addClass('docIcon').inject(file);
			}
		}
		
		if(!window.kb && !this.lang_id && this.form.langs && this.form.frmType == 'E') {
			var tradLangIcon = new Element('div.docIcon', {
				title: BTN_FILE_TRADUC_LBL,
				tabIndex: ''
			}).inject(file).addEvent('click', this.checkTradLang.bind(this)).addEvent('keypress', Generic.enterKeyToClickListener);
			
			var lang_modals = new Array();
			for(var lang_id in DOC_LANGS) {
				
				var previous_modal = $(this.frmId + "_" + this.fldId + "_" + this.index + "_" + lang_id + "_Trad");
				if(previous_modal)
					previous_modal.getParent('div.contentMenu-container').destroy();
				
				lang_modals.push("<div id='" + this.frmId + "_" + this.fldId + "_" + lang_id + "_Trad' class='modalOptionsContainer'><div></div></div>");
			}
			
			this.langMenu = new ContextMenuModal(tradLangIcon, lang_modals);
			
			if(this.doc_id != undefined && !file_disabled && this.canEdit && !(this.isLocked == "true") && !file_readonly) {
				tradLangIcon.addClass('docTradLangIcon');
			} else {
				tradLangIcon.addClass('docTradLangIconDisabled');
			}
		}
		
		if(!window.kb && !this.options[Field.PROPERTY_HIDE_DOC_ERASE] && !this.options[Field.PROPERTY_NO_ERASE]) {
			
			if(this.doc_id != undefined && !file_disabled && this.canEdit && !(this.isLocked == "true") && !file_readonly) {
				new Element('div.docEraseIcon', {
					title: BTN_FILE_ERASE_LBL,
					tabIndex: ''
				}).addClass('docIcon').inject(file).addEvent('click', this.eraseEvent).addEvent('keypress', Generic.enterKeyToClickListener);
			} else {
				new Element('div.docEraseIconDisabled', {
					title: BTN_FILE_ERASE_LBL,
					tabIndex: ''
				}).addClass('docIcon').inject(file);
			}
		}
		
		//TODO:
		//this.options[Field.PROPERTY_HIDE_DOC_PERMISSIONS]
		//this.options[Field.PROPERTY_HIDE_DOC_HISTORY]
		
		if(this.file_prp.name)
			doc_name.set('text', this.file_prp.name);
		
		file.focus = function() {
			var i = new Element('input');
			i.inject(this);
			i.focus();
			i.destroy();
		};
		
		if(this.options[Field.PROPERTY_REQUIRED]) {
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				if(!this.form.readOnly) {
					file.addClass('validate["required","%Fileinput.customFileChecker"]');
					$('frmData').formChecker.register(file);
				}
				this.content.addClass('required');
			}
		}		
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		label.inject(this.content);
		file.inject(this.content);
		
		if(this.options[Field.PROPERTY_FILE_PREVIEW]) {
			if(this.file_prp['preview']) {
				var img = new Element('img.fileinput-image-preview').set('src', this.file_prp['preview']);
				img.inject(this.content);
			} else {
				//TODO: Colocar imagen por defecto
			}
			if(this.options[Field.PROPERTY_READONLY])
				this.content.getElement('div.document').setStyle('display', 'none')
		}
		
		var multIdx = this.xml.getAttribute("multIdx");
		if(multIdx) {
			this.index = Number.from(multIdx);
		}
		
		if(!window.kb && !this.lang_id && this.form.langs && this.form.frmType == 'E') {
			//Ahora que esta insertado en el DOM, agregar eventos
			
			//Generar XML para cada traduccion
			var lang_modals = new Array();
			for(var lang_id in DOC_LANGS) {
				var lang_xml = this.xml.cloneNode('true');
				
				//Agregarle langId
				lang_xml.setAttribute('langId', lang_id);
				lang_xml.setAttribute('attLabel', DOC_LANGS[lang_id]);
				
				var lang_file = new Fileinput(this.form, this.frmId, lang_xml, this.row_xml);
				lang_file.content = $(this.frmId + "_" + this.fldId + "_" + lang_id + "_Trad").getChildren()[0];
				lang_file.parseXML();
				
				lang_file.content.getElement('div.document').addClass('context-menu-doc');
				
				lang_file.content.store(Field.STORE_KEY_FIELD, lang_file);
				
				this.translations[lang_id] = lang_file;
			}
		}
	},
	
	parseXMLforGrid: function(td_container, grid_index, isGridReadonly) {
		this.content = td_container;
		this.index = grid_index;
		
		this.updateProperties();
		
		if(!this.gridHeader.col_fld_id)
			this.gridHeader.col_fld_id = this.fldId;
		
		//Seteamos el tipo de atributo
		if(this.xml.getAttribute("valueType"))
			this.options.valueType = this.xml.getAttribute("valueType");

		if(this.options[Field.PROPERTY_CSS_CLASS])
			this.options[Field.PROPERTY_CSS_CLASS].split(' ').each(function(clase) {
				if(clase) this.content.addClass(clase);
			}.bind(this));		
		
		var fprps = this.row_xml.getAttribute("file_prp");
		if(fprps) {
			if(this.lang_id)
				this.file_prp = JSON.decode(fprps.replace(/\\/g, '\\\\'))[this.lang_id];
			else
				this.file_prp = JSON.decode(fprps.replace(/\\/g, '\\\\'))[0];
			
			if(!this.file_prp) {
				this.file_prp = {};
			} else {
				
				if(this.file_prp.docId)
					this.doc_id = this.file_prp.docId;
				
				if(this.file_prp.downloadDocId)
					this.downloadDocId = this.file_prp.downloadDocId;
				
				this.canRead = this.file_prp.canRead;

				this.canEdit = this.file_prp.canEdit
				
				this.isLocked = this.file_prp.lock;
				this.lockedBy = this.file_prp.lockedBy;
			}	
		}
			
		if(this.canEdit)
			this.canRead = true;
		
		if(this.file_prp.sign)
			this.markedToSign = true;		
		
		if(this.form.readOnly || isGridReadonly) {
			this.canEdit = false;
			//this.canRead = true; //this.canRead se mantiene con su valor
		}
		
		//FILE
		
		var file = new Element('div.document', {
			'data-fld_id': this.frmId + "_" + this.fldId
		}).addClass('grid_document');
		
		if(this.form.readOnly)
			file.addClass('monitor-fileinput');
		
		var doc_name = new Element('div.docDataSinError').inject(file);
		
		if(this.options[Field.PROPERTY_VALUE_COLOR])
			doc_name.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
		
		
		var formId = this.frmId.split('_')[1];
		var attributeId = this.attId;
		var frmParent = this.frmId.split('_')[0];
		
		var file_disabled = this.options[Field.PROPERTY_DISABLED] || !this.canEdit;
		var file_readonly = this.options[Field.PROPERTY_READONLY] || this.options[Field.PROPERTY_DISABLED] || !this.canRead;
		
		this.fr = this.options[Field.PROPERTY_READONLY];
		
		if(!window.kb && !this.options[Field.PROPERTY_HIDE_DOC_UPLOAD] && !this.options[Field.PROPERTY_NO_MODIFY]) {
			
			var upload = new Element('div.docIcon', {
				title: BTN_FILE_UPLOAD_LBL,
				tabIndex: ''
			}).inject(file);
			
			if(!file_disabled && this.canEdit && !(this.isLocked == "true") && !file_readonly)
				upload.addClass('docUploadIcon').addEvent('click', this.uploadEvent).addEvent('keypress', Generic.enterKeyToClickListener);
			else
				upload.addClass('docUploadIconDisabled');
		}
				
		if(!this.options[Field.PROPERTY_HIDE_DOC_DOWNLOAD] && !this.options[Field.PROPERTY_NO_DOWNLOAD]) {
			if(this.doc_id != undefined && this.canRead) {
				/*
				var a = new Element('a',  {
					'download': 'true',
					href: CONTEXT + '/page/generic/downloadAttDoc.jsp?action=download&frmParent=' + frmParent + '&frmId=' + formId + '&attId=' + attributeId + '&index=' + grid_index + '&docId=' + this.doc_id + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : '')
				});
				a.setAttribute('aria-label',BTN_FILE_DOWNLOAD_LBL);
				new Element('div.docDownloadIcon', {
					title: BTN_FILE_DOWNLOAD_LBL
				}).addClass('docIcon').inject(a);
				a.inject(file);
				*/
				var divDown = new Element('div.docDownloadIcon', {
					title: BTN_FILE_DOWNLOAD_LBL
				}).addClass('docIcon').inject(file).addEvent('click', function(e){
					e.stop();
					
					if (isMonitor){
						window.location = this.getElement('a').href;
					} else {
						//En ejecución se espera por edicion sincronizada
						var file_object = this.getParent().getParent().retrieve(Field.STORE_KEY_FIELD);
						file_object.retriesCount = 10;
						syncWebDavDocumentLock(file_object, file_object.doc_id, function(){
							window.location = this.getElement('a').href;					
						}.bind(this))	
					}
				});
				
				var a = new Element('a', {
					'download': 'true',
					href: CONTEXT + '/page/generic/downloadAttDoc.jsp?action=download&frmParent=' + frmParent + '&frmId=' + formId + '&attId=' + attributeId + '&index=' + grid_index + '&docId=' + encodeURIComponent(this.downloadDocId) + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : '')
				}).inject(divDown);
			} else {
				new Element('div.docDownloadIconDisabled', {
					title: BTN_FILE_DOWNLOAD_LBL,
					tabIndex: ''
				}).addClass('docIcon').inject(file);
			}
		}
		
		var doc_info = new Element('div.docIcon', {
			title: BTN_FILE_INFO_LBL,
			tabIndex: ''
		}).inject(file);
		this.infoEvent = this.showModalInfo.bind(this);
		
		if(this.doc_id != undefined && this.doc_id > 0 && this.canRead) {
			doc_info.addClass('docInfoIcon');
			doc_info.addEvent('click', this.infoEvent).addEvent('keypress', Generic.enterKeyToClickListener);
		} else {
			doc_info.addClass('docInfoIconDisabled');
		}
		
		var doc_edit = null;
		if (this.options[Field.PROPERTY_ALLOW_EDITION]){
			var doc_edit = new Element('div.docIcon.docEditIcon.docEditIconDisabled', {
				title: LBL_EDIT,
				tabIndex: ''
			}).inject(file);	
		}
		
		
		if(!window.kb && !this.options[Field.PROPERTY_HIDE_DOC_LOCK] && !this.options[Field.PROPERTY_NO_LOCK]) {
			var doc_lock = new Element('div.docIcon', {
				title: BTN_FILE_LOCK_LBL,
				tabIndex: ''
			}).addClass('docLockIcon');
			if(this.doc_id == undefined || this.doc_id < 0 || file_disabled || !this.canEdit || file_readonly) {
				doc_lock.addClass('docLockIconDisabled').inject(file);
			} else if(this.isLocked == "false") {
				doc_lock.addClass('docLockIconUnlocked').inject(file);
				doc_lock.addEvent('click', this.lockDocument).addEvent('keypress', Generic.enterKeyToClickListener);
			} else if(this.isLocked == "me") {
				doc_lock.addClass('docLockIconLocked').inject(file);
				doc_lock.addEvent('click', this.unlockDocument).addEvent('keypress', Generic.enterKeyToClickListener);
			} else if(this.isLocked == "true") {
				doc_lock.addClass('docLockIconLockedOther').inject(file);
				doc_lock.addEvent('click', this.refreshLock).addEvent('keypress', Generic.enterKeyToClickListener);
			}
		}
		
		if(!this.options[Field.PROPERTY_HIDE_DOC_SIGN]) {
			
			if(!window.kb) {
				if(this.doc_id != undefined  && !file_disabled && !(this.isLocked == "true") && !this.form.readOnly && !file_readonly) {
					var _docSignIcon = new Element('div.docSignIcon', {
						title: BTN_FILE_SIGN_LBL,
						tabIndex: ''
					}).addClass('docIcon').inject(file).addEvent('click', this.signEvent).addEvent('keypress', Generic.enterKeyToClickListener);
					
					if(this.markedToSign)
						_docSignIcon.addClass('docMarkedToSignIcon');
				} else {
					new Element('div.docSignIconDisabled', {
						title: BTN_FILE_SIGN_LBL,
						tabIndex: ''
					}).addClass('docIcon').inject(file);
				}
			}
			
			if(this.doc_id != undefined  && this.canRead) {
				new Element('div.docVerifySignIcon', {
					title: BTN_FILE_VERIFY_LBL,
					tabIndex: ''
				}).addClass('docIcon').inject(file).addEvent('click', this.verifSignEvent).addEvent('keypress', Generic.enterKeyToClickListener);
			} else {
				new Element('div.docVerifySignIconDisabled', {
					title: BTN_FILE_VERIFY_LBL,
					tabIndex: ''
				}).addClass('docIcon').inject(file);
			}
		}
		
		if(!window.kb && !this.lang_id && this.form.langs && this.form.frmType == 'E') {
			var tradLangIcon = new Element('div.docIcon', {
				title: BTN_FILE_TRADUC_LBL,
				tabIndex: ''
			}).inject(file).addEvent('click', this.checkTradLang.bind(this)).addEvent('keypress', Generic.enterKeyToClickListener);
			
			var lang_modals = new Array();
			for(var lang_id in DOC_LANGS) {
				
				var previous_modal = $(this.frmId + "_" + this.fldId + "_" + this.index + "_" + lang_id + "_Trad");
				if(previous_modal)
					previous_modal.getParent('div.contentMenu-container').destroy();
				
				lang_modals.push("<div id='" + this.frmId + "_" + this.fldId + "_" + this.index + "_" + lang_id + "_Trad' class='modalOptionsContainer'><div></div></div>");
			}
			
			this.langMenu = new ContextMenuModal(tradLangIcon, lang_modals);
			
			if(this.doc_id != undefined && !file_disabled && this.canEdit && !(this.isLocked == "true") && !file_readonly) {
				tradLangIcon.addClass('docTradLangIcon');
			} else {
				tradLangIcon.addClass('docTradLangIconDisabled');
			}
		}
		
		if(!window.kb && !this.options[Field.PROPERTY_HIDE_DOC_ERASE] && !this.options[Field.PROPERTY_NO_ERASE]) {
			
			if(this.doc_id != undefined && !file_disabled && this.canEdit && !(this.isLocked == "true") && !file_readonly) {
				new Element('div.docEraseIcon', {
					title: BTN_FILE_ERASE_LBL,
					tabIndex: ''
				}).addClass('docIcon').inject(file).addEvent('click', this.eraseEvent).addEvent('keypress', Generic.enterKeyToClickListener);
			} else {
				new Element('div.docEraseIconDisabled', {
					title: BTN_FILE_ERASE_LBL,
					tabIndex: ''
				}).addClass('docIcon').inject(file);
			}
		}
		
		//TODO:
		//this.options[Field.PROPERTY_HIDE_DOC_PERMISSIONS]
		//this.options[Field.PROPERTY_HIDE_DOC_HISTORY]
		
		if(this.file_prp.name)
			doc_name.set('HTML', this.file_prp.name);
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.addClass('visibility-hidden');
		
		var div = new Element('div.gridMinWidth', {
			id: this.frmId + '_' + this.fldId + '_' + grid_index
		});
		
		div.addClass(this.xml.getAttribute('attName'));
		
		if(this.form.readOnly || isGridReadonly) {
			div.addClass('monitorGridCell');
		}
		
		if(this.options[Field.PROPERTY_REQUIRED]) {
			if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
				file.addClass('validate["required","%Fileinput.customFileChecker"]');
				
				if($('frmData').formChecker)
					$('frmData').formChecker.register(file);
				
				div.addClass('gridCellRequired');
				
				file.setStyles({
					display: 'inline',
					'margin': 0
				});
				
				var btns = file.getElements('div');
				var margin_left = Generic.getHiddenWidth(div)/2 - 73;
				
				if(margin_left<0) margin_left=0;
				
				btns[0].setStyle('margin-left', margin_left);
				btns[1].setStyle('margin-left', margin_left);
			}
			
			if(this.form.options[Form.PROPERTY_FORM_HIDDEN] == "true") {
				file.set('disabledCheck', 'true');
			}
		}	
		
		file.set('data-attLabel', this.xml.getAttribute("attLabel"));
		
		file.inject(div);
		div.inject(this.content);
		
		div.store(Field.STORE_KEY_FIELD, this);
		
		if(!window.kb && !this.lang_id && this.form.langs && this.form.frmType == 'E') {
			//Ahora que esta insertado en el DOM, agregar eventos
			
			//Generar XML para cada traduccion
			var lang_modals = new Array();
			for(var lang_id in DOC_LANGS) {
				var lang_xml = this.xml.cloneNode('true');
				
				//Agregarle langId
				lang_xml.setAttribute('langId', lang_id);
				lang_xml.setAttribute('attLabel', DOC_LANGS[lang_id]);
				
				var file_prp = this.row_xml.getAttribute('file_prp');
				if(file_prp)
					lang_xml.setAttribute('file_prp', file_prp);
				
				var lang_file = new Fileinput(this.form, this.frmId, lang_xml, this.row_xml);
				lang_file.content = $(this.frmId + "_" + this.fldId + "_" + this.index + "_" + lang_id + "_Trad").getChildren()[0];
				lang_file.parseXML();
				lang_file.index = this.index;
				
				lang_file.content.getElement('div.document').addClass('context-menu-doc');
				
				lang_file.content.store(Field.STORE_KEY_FIELD, lang_file);
				
				this.translations[lang_id] = lang_file;
			}
		}
	},
	
	showModalInfo: function() {
		if(this.doc_id)
			showDocumentInfo({docId: this.doc_id}, {prefix: this.frmId.split("_")[0]}, 
					this.options[Field.PROPERTY_HIDE_DOC_METADATA], this.options[Field.PROPERTY_NO_DOWNLOAD]);
	},
	
	lockDocument: function() {
		var field = this.getParent().getParent().retrieve(Field.STORE_KEY_FIELD);
		var file = this.getParent();
		var file_object = field;
		
		if(!file_object.options[Field.PROPERTY_READONLY] && !file_object.options[Field.PROPERTY_DISABLED]) {
			//Controlar que est� bloqueado por el usuario.
			/*
			new Request({
				url: 'apia.execution.FormAction.run?action=checkLockDocument&frmId=' +  file_object.frmId.split('_')[1] + '&frmParent=' + file_object.frmId.split('_')[0] + '&attId=' + file_object.attId + '&index=' + file_object.index + '&docId=' + file_object.doc_id + (file_object.lang_id ? '&langId=' + file_object.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''),
				onSuccess: function(responseText, responseXML) {
			    	//AJAX exitoso
			    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
			    		
			    		checkErrors(responseXML);
			    		
			    		var response = responseXML.childNodes[responseXML.childNodes.length - 1];
			    		
			    		if(response.tagName == 'result' && response.getAttribute('success')) {
			    			var result = response.getAttribute('success');
			    			
			    			if(result == "ok") {
			    				//El archivo esta bloqueado por mi
			    				file_object.isLocked = 'me';
			    				
			    			} else if(result == "locked") {
			    				//El archivo esta bloqueado por otro, actualizar visualmente y avisar
			    				
			    				var uplBtn = file.getElement('div.docUploadIcon');
			    				if(uplBtn)
			    					uplBtn.removeClass('docUploadIcon')
					    					.addClass('docUploadIconDisabled')
					    					.removeEvent('click', file_object.uploadEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
			    				
			    				var lockBtn = file.getElement('div.docLockIcon');
			    				if(lockBtn)
			    					lockBtn.removeClass('docLockIconDisabled')
					    					.removeClass('docLockIconUnlocked')
					    					.removeClass('docLockIconLocked')
					    					.addClass('docLockIconLockedOther')
					    					.removeEvent('click', file_object.lockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
					    					.removeEvent('click', file_object.unlockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
					    					.addEvent('click', file_object.refreshLock).addEvent('keypress', Generic.enterKeyToClickListener);
			    				
			    				var signBtn = file.getElement('div.docSignIcon');
			    				if(signBtn) 
			    					signBtn.removeClass('docSignIcon')
			    							.addClass('docSignIconDisabled')
			    							.removeEvent('click', file_object.signEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
			    				
			    				var eraseBtn = file.getElement('div.docEraseIcon');
			    				if(eraseBtn) 
			    					eraseBtn.removeClass('docEraseIcon')
			    							.addClass('docEraseIconDisabled')
			    							.removeEvent('click', file_object.eraseEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
			    				
			    				file_object.isLocked = 'true';
			    				
			    				showMessage(MSG_DOC_LOCKED_BY_USR + ': ' + response.getAttribute('usr'));
			    				
			    			} else if(result == "unlocked") {
			    				//El archivo no esta bloqueado
			    				file_object.isLocked = 'false';
			    				
			    				new Request({
			    					url: 'apia.execution.FormAction.run?action=lockDocument&frmId=' +  field.frmId.split('_')[1] + '&frmParent=' + field.frmId.split('_')[0] + '&attId=' + field.attId + '&index=' + field.index + '&docId=' + field.doc_id + '&lock=false' + (field.lang_id ? '&langId=' + field.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''),
			    					onSuccess: function(responseText, responseXML) {
			    				    	//AJAX exitoso
			    				    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
			    				    		var hasErrors = checkErrors(responseXML);
			    				    		if(!hasErrors) {
			    				    			//Cambiar icono
			    				    			field.content.getElement('div.docLockIcon')
			    				    				.removeClass('docLockIconUnlocked')
			    				    				.addClass('docLockIconLocked')
			    				    				.removeEvent('click', field.lockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
			    				    				.addEvent('click', field.unlockDocument).addEvent('keypress', Generic.enterKeyToClickListener);
			    				    			field.isLocked = "me";
			    				    		}
			    				    	}
			    					}
			    				}).send();
			    			}
			    		}
					}
				}
			}).send();
			*/
			var customUnlockedFnc = function(){ 
				file_object.isLocked = 'false';
				
				new Request({
					url: 'apia.execution.FormAction.run?action=lockDocument&frmId=' +  field.frmId.split('_')[1] + '&frmParent=' + field.frmId.split('_')[0] + '&attId=' + field.attId + '&index=' + field.index + '&docId=' + field.doc_id + '&lock=false' + (field.lang_id ? '&langId=' + field.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''),
					onSuccess: function(responseText, responseXML) {
				    	//AJAX exitoso
				    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
				    		var hasErrors = checkErrors(responseXML);
				    		if(!hasErrors) {
				    			//Cambiar icono
				    			field.content.getElement('div.docLockIcon')
				    				.removeClass('docLockIconUnlocked')
				    				.addClass('docLockIconLocked')
				    				.removeEvent('click', field.lockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
				    				.addEvent('click', field.unlockDocument).addEvent('keypress', Generic.enterKeyToClickListener);
				    			field.isLocked = "me";
				    		}
				    	}
					}
				}).send();
			}
			processCheckLock(file, file_object, null, null, null, customUnlockedFnc);
		}
	},
	
	refreshLock: function() {
		var field = this.getParent().getParent().retrieve(Field.STORE_KEY_FIELD);
		var file = this.getParent();
		var file_object = field;
		if(!file_object.options[Field.PROPERTY_READONLY] && !file_object.options[Field.PROPERTY_DISABLED]) {
			//Controlar que esta bloqueado por el usuario.
			new Request({
				url: 'apia.execution.FormAction.run?action=checkLockDocument&frmId=' +  file_object.frmId.split('_')[1] + '&frmParent=' + file_object.frmId.split('_')[0] + '&attId=' + file_object.attId + '&index=' + file_object.index + '&docId=' + file_object.doc_id + (file_object.lang_id ? '&langId=' + file_object.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''),
				onSuccess: function(responseText, responseXML) {
			    	//AJAX exitoso
			    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
			    		
			    		checkErrors(responseXML);
			    		
			    		var response = responseXML.childNodes[responseXML.childNodes.length - 1];
			    		
			    		if(response.tagName == 'result' && response.getAttribute('success')) {
			    			var result = response.getAttribute('success');
			    			
			    			if(result == "ok") {
			    				file_object.isLocked = 'me';
			    				var lockBtn = file.getElement('div.docLockIcon');
			    				if(lockBtn)
			    					lockBtn.set('title', BTN_FILE_LOCK_LBL);
			    			} else if(result == "locked") {
			    				file_object.isLocked = 'true';
			    				var lockBtn = file.getElement('div.docLockIcon');
			    				if(lockBtn && response.getAttribute('lockedBy'))
			    					lockBtn.set('title', response.getAttribute('lockedBy'));
			    			} else if(result == "unlocked") {
			    				//El archivo no esta bloqueado
			    				updateWithUnlockedState(file, file_object);
			    				/*file_object.isLocked = 'false';
			    				
			    				//Upload
			    				if(!file_object.options[Field.PROPERTY_HIDE_DOC_UPLOAD] && !file_object.options[Field.PROPERTY_NO_MODIFY] && file_object.canEdit) {
			    					var docUpload = file.getElement('div.docUploadIcon');
			    					if(!docUpload) {
			    						upload = file.getElement('div.docUploadIconDisabled');
			    						upload.removeClass('docUploadIconDisabled')
			    								.addClass('docUploadIcon')
			    								.addEvent('click', file_object.uploadEvent).addEvent('keypress', Generic.enterKeyToClickListener);
			    					}
			    				}
			    				
			    				//Firma
			    				if(!file_object.options[Field.PROPERTY_HIDE_DOC_SIGN] && file_object.doc_id != undefined && (file_object.canEdit || file_object.canRead)) {
			    					var docSign = file.getElement('div.docSignIcon');
			    					if(!docSign) {
			    						docSign = file.getElement('div.docSignIconDisabled');
			    						docSign.removeClass('docSignIconDisabled')
			    								.addClass('docSignIcon')
			    								.addEvent('click', file_object.signEvent).addEvent('keypress', Generic.enterKeyToClickListener);
			    					}
			    				}
			    				
			    				//Borrado
			    				if(!file_object.options[Field.PROPERTY_HIDE_DOC_ERASE] && !file_object.options[Field.PROPERTY_NO_ERASE] && file_object.doc_id != undefined && file_object.canEdit) {
			    					//TODO: Verificar esto
			    					var docErase = file.getElement('div.docEraseIcon');
			    					if(!docErase) {
			    						docErase = file.getElement('div.docEraseIconDisabled');
			    						docErase.removeClass('docEraseIconDisabled')
			    								.addClass('docEraseIcon')
			    								.addEvent('click', file_object.eraseEvent).addEvent('keypress', Generic.enterKeyToClickListener);
			    					}
			    				}
			    				
			    				
			    				if(!file_object.options[Field.PROPERTY_HIDE_DOC_LOCK] && !file_object.options[Field.PROPERTY_NO_LOCK] && (file_object.canRead || file_object.canEdit)) {
				    				var lockBtn = file.getElement('div.docLockIcon');
				    				if(lockBtn) {
				    					lockBtn.removeClass('docLockIconDisabled')
						    					.removeClass('docLockIconUnlocked')
						    					.removeClass('docLockIconLocked')
						    					.removeClass('docLockIconLockedOther')
						    					.removeEvent('click', file_object.refreshLock).removeEvent('keypress', Generic.enterKeyToClickListener)
						    					.set('title', BTN_FILE_LOCK_LBL);
				    					
				    					if(file_object.doc_id == undefined || file_object.doc_id < 0 || !file_object.canEdit) {
				    						lockBtn.addClass('docLockIconDisabled');
				    					} else {
				    						lockBtn.addClass('docLockIconUnlocked')
				    								.addEvent('click', file_object.lockDocument).addEvent('keypress', Generic.enterKeyToClickListener);
				    					}
				    				}
			    				} */
			    			}
			    		}
					}
				}
			}).send();
		}
	},
	
	unlockDocument: function() {
		var field = this.getParent().getParent().retrieve(Field.STORE_KEY_FIELD);
		if(!field.options[Field.PROPERTY_READONLY] && !field.options[Field.PROPERTY_DISABLED]) {
			new Request({
				url: 'apia.execution.FormAction.run?action=lockDocument&frmId=' +  field.frmId.split('_')[1] + '&frmParent=' + field.frmId.split('_')[0] + '&attId=' + field.attId + '&index=' + field.index + '&docId=' + field.doc_id + '&lock=true' + (field.lang_id ? '&langId=' + field.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''),
				onSuccess: function(responseText, responseXML) {
			    	//AJAX exitoso
			    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
			    					    		
			    		var response = responseXML.childNodes[responseXML.childNodes.length - 1]
			    		
			    		if(response.tagName == 'data' && responseXML.childNodes.length && response.childNodes[0].tagName == 'load') {
			    			//Cambiar icono
			    			field.content.getElement('div.docLockIcon')
			    				.addClass('docLockIconUnlocked')
			    				.removeClass('docLockIconLocked')
			    				.removeEvent('click', field.unlockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
			    				.addEvent('click', field.lockDocument).addEvent('keypress', Generic.enterKeyToClickListener);
			    			field.isLocked = "false";
			    		} else {
			    			modalProcessXml(responseXML);
			    		}
			    	}
				}
			}).send();
		}
	},
	
	uploadDocument: function(file_object, file, index) {
		showDocumentsModal(function(extra, docInfo) {
			//Modificar el nombre del archivo visualmente
			file.getElements('div.docDataSinError').set('text', docInfo.docName);
			file_object.doc_id = docInfo.docId;
			file_object.downloadDocId = docInfo.downloadDocId;
			if(file_object.options[Field.PROPERTY_FILE_PREVIEW]) {
				var img = file_object.content.getElement('img.fileinput-image-preview');
				if(!img) {
					img = new Element('img.fileinput-image-preview').set('src', 'apia.execution.FormAction.run?action=imagePreview&frmParent=' + file_object.frmId.split('_')[0] +'&frmId=' + file_object.frmId.split('_')[1] + '&attId=' + file_object.attId + '&index=' + index + '&docId=' + file_object.doc_id + (file_object.lang_id ? '&langId=' + file_object.lang_id : '') + TAB_ID_REQUEST);
					img.inject(file_object.content);
				} else {
					img.set('src', 'apia.execution.FormAction.run?action=imagePreview&frmParent=' + file_object.frmId.split('_')[0] +'&frmId=' + file_object.frmId.split('_')[1] + '&attId=' + file_object.attId + '&index=' + index + '&docId=' + file_object.doc_id + (file_object.lang_id ? '&langId=' + file_object.lang_id : '') + TAB_ID_REQUEST);
				}
			}
			
			//Descarga
			if(!file_object.options[Field.PROPERTY_HIDE_DOC_DOWNLOAD] && !file_object.options[Field.PROPERTY_NO_DOWNLOAD]) {
				var docDownload = file.getElement('div.docDownloadIcon');
				if(!docDownload) {
					/*
					docDownload = file.getElement('div.docDownloadIconDisabled')
										.addClass('docDownloadIcon')
										.removeClass('docDownloadIconDisabled');
					
					var a = new Element('a', {'download': 'true'}).inject(docDownload, "before")
									.grab(docDownload);
					a.setAttribute('aria-label',BTN_FILE_DOWNLOAD_LBL);
					*/
					docDownload = file.getElement('div.docDownloadIconDisabled')
										.addClass('docDownloadIcon')
										.removeClass('docDownloadIconDisabled')
										.addEvent('click', function(e){
											e.stop();
											window.location = this.getElement('a').href;					
										});
					new Element('a', {'download': 'true'}).inject(docDownload);
				}
				//Cambiar la url del anchor
				docDownload.getElement('a').set('href', CONTEXT + '/page/generic/downloadAttDoc.jsp?action=download&frmParent=' + file_object.frmId.split('_')[0] +'&frmId=' + file_object.frmId.split('_')[1] + '&attId=' + file_object.attId + '&index=' + index + '&docId=' + encodeURIComponent(file_object.downloadDocId) + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''));
				//docDownload.getParent('a').set('href', CONTEXT + '/page/generic/downloadAttDoc.jsp?action=download&frmParent=' + file_object.frmId.split('_')[0] +'&frmId=' + file_object.frmId.split('_')[1] + '&attId=' + file_object.attId + '&index=' + index + '&docId=' + file_object.doc_id + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''));
				docDownload.removeAttribute('tabIndex');
			}
			
			//Firma
			if(!file_object.options[Field.PROPERTY_HIDE_DOC_SIGN] && file_object.doc_id != undefined && (file_object.canEdit || file_object.canRead) && !(file_object.isLocked == "true")) {
				var docSign = file.getElement('div.docSignIcon');
				if(docSign) {
					if(file_object.options[Field.PROPERTY_SIGNATURE_REQUIRED]) {
						docSign.removeClass('docSignIconDisabled')
								.addClass('docMarkedToSignIcon');
					}
				} else {
					docSign = file.getElement('div.docSignIconDisabled');
					docSign.removeClass('docSignIconDisabled')
							.addClass('docSignIcon')
							.addEvent('click', file_object.signEvent).addEvent('keypress', Generic.enterKeyToClickListener);
					
					if(file_object.options[Field.PROPERTY_SIGNATURE_REQUIRED]) {
						docSign.addClass('docMarkedToSignIcon');
					}
				}
			}
			
			if(file_object.doc_id != undefined && file_object.canEdit && !(file_object.isLocked == "true")) {
				var docTrad = file.getElement('div.docTradLangIconDisabled');
				if(docTrad) {
					docTrad.removeClass('docTradLangIconDisabled')
							.addClass('docTradLangIcon');
				}
			}
			
			//Borrado
			if(!file_object.options[Field.PROPERTY_HIDE_DOC_ERASE] && !file_object.options[Field.PROPERTY_NO_ERASE] && file_object.doc_id != undefined && file_object.canEdit && !(file_object.isLocked == "true")) {
				var docErase = file.getElement('div.docEraseIcon');
				if(!docErase) {
					docErase = file.getElement('div.docEraseIconDisabled');
					docErase.removeClass('docEraseIconDisabled')
							.addClass('docEraseIcon')
							.addEvent('click', file_object.eraseEvent).addEvent('keypress', Generic.enterKeyToClickListener);
				} else {
					docErase.removeClass('docEraseIconDisabled')
					.addClass('docEraseIcon')
					.addEvent('click', file_object.eraseEvent).addEvent('keypress', Generic.enterKeyToClickListener);
				}
			}
			
			//Info
			var infoBtn = file.getElement('div.docInfoIconDisabled');
			if(infoBtn){
				infoBtn.addClass('docInfoIcon')
						.removeClass('docInfoIconDisabled')
						.addEvent('click', file_object.infoEvent).addEvent('keypress', Generic.enterKeyToClickListener);
			}
			
		},
		file_object.doc_id,
		{
			url_aux: '/apia.execution.FormAction.run',
			params: '&frmParent=' + file_object.frmId.split('_')[0] + '&frmId=' + file_object.frmId.split('_')[1] + '&attId=' + file_object.attId + '&index=' + index + (file_object.doc_id != undefined ? '&docId=' + file_object.doc_id : '') + (file_object.options[Field.PROPERTY_DOC_TYPE] ? '&forceDocTypeId=' + file_object.options[Field.PROPERTY_DOC_TYPE] : '') + (window.editionMode ? '&editionMode=true' : ''),
			langId:  file_object.lang_id
		},
		undefined,
		file_object.options[Field.PROPERTY_HIDE_DOC_PERMISSIONS],
		file_object.options[Field.PROPERTY_HIDE_DOC_METADATA],
		function() {
			var uploadIcon = file.getElement('div.docUploadIcon');
			if(uploadIcon)
				uploadIcon.focus();
		});
	},
	
	editDocument: function(field){
		var params = 
			'/apia.execution.FormAction.run?action=updateWebDavDocument' +
			'&frmId=' +  field.frmId.split('_')[1] + 
			'&frmParent=' + field.frmId.split('_')[0] +
			'&attId=' + field.attId + '&index=' + field.index + 
			'&docId=' + field.doc_id + 
			(field.lang_id ? '&langId=' + field.lang_id : '');
		openWebDavDocument(field.file_prp['docId'], field.file_prp['name'], params);
	},
	
	/********FUNCIONES DE BOTONES***********/
	
	uploadEvent: function(evt) {
		var file = this.getParent();
		var file_object = file.getParent().retrieve(Field.STORE_KEY_FIELD);
		
		if(!file_object.options[Field.PROPERTY_READONLY] && !file_object.options[Field.PROPERTY_DISABLED]) {
			if(file_object.doc_id != undefined) {
				//Controlar que est� bloqueado por el usuario.
				new Request({
					url: 'apia.execution.FormAction.run?action=checkLockDocument&frmId=' +  file_object.frmId.split('_')[1] + '&frmParent=' + file_object.frmId.split('_')[0] + '&attId=' + file_object.attId + '&index=' + file_object.index + '&docId=' + file_object.doc_id + (file_object.lang_id ? '&langId=' + file_object.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''),
					onSuccess: function(responseText, responseXML) {
				    	//AJAX exitoso
				    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
				    		
				    		checkErrors(responseXML);
				    		
				    		var response = responseXML.childNodes[responseXML.childNodes.length - 1];
				    		
				    		if(response.tagName == 'result' && response.getAttribute('success')) {
				    			var result = response.getAttribute('success');
				    			
				    			if(result == "ok") {
				    				//El archivo esta bloqueado por mi
				    				file_object.uploadDocument(file_object, file, file_object.index);
				    				file_object.isLocked = 'me';
				    			} else if(result == "locked") {
				    				//El archivo esta bloqueado por otro, actualizar visualmente y avisar
				    				
				    				var uplBtn = file.getElement('div.docUploadIcon');
				    				if(uplBtn)
				    					uplBtn.removeClass('docUploadIcon')
						    					.addClass('docUploadIconDisabled')
						    					.removeEvent('click', file_object.uploadEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				var lockBtn = file.getElement('div.docLockIcon');
				    				if(lockBtn)
				    					lockBtn.removeClass('docLockIconDisabled')
						    					.removeClass('docLockIconUnlocked')
						    					.removeClass('docLockIconLocked')
						    					.addClass('docLockIconLockedOther')
						    					.removeEvent('click', file_object.lockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
						    					.removeEvent('click', file_object.unlockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
						    					.set('title', response.getAttribute('lockedBy'));
				    				
				    				var signBtn = file.getElement('div.docSignIcon');
				    				if(signBtn) 
				    					signBtn.removeClass('docSignIcon')
				    							.addClass('docSignIconDisabled')
				    							.removeEvent('click', file_object.signEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				var eraseBtn = file.getElement('div.docEraseIcon');
				    				if(eraseBtn) 
				    					eraseBtn.removeClass('docEraseIcon')
				    							.addClass('docEraseIconDisabled')
				    							.removeEvent('click', file_object.eraseEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				file_object.isLocked = 'true';
				    				
				    				showMessage(MSG_DOC_LOCKED_BY_USR + ': ' + response.getAttribute('usr'));
				    				
				    			} else if(result == "unlocked") {
				    				//El archivo no esta bloqueado
				    				showMessage(MSG_DOC_MUST_BE_LOCKED);
				    				file_object.isLocked = 'false';
				    			}
				    		}
						}
					}
				}).send();
			} else {
				file_object.uploadDocument(file_object, file, file_object.index);
			}
		}
	},
	
	editEvent: function() {
		var file = this.getParent();
		var file_object = file.getParent().retrieve(Field.STORE_KEY_FIELD);
		
		if(file_object.doc_id != undefined) {
			//Controlar que esta bloqueado por el usuario.				
			var okFnc = function(){ file_object.editDocument(file_object, file, file_object.index); }
			processCheckLock(file, file_object, okFnc);
		}
	},
	
	signEvent:function(evt) {
		var file = this.getParent();
		var file_object = file.getParent().retrieve(Field.STORE_KEY_FIELD);
		
		var currentTab = '';
		var tabComponent = $('tabComponent');
		if(tabComponent)
			currentTab = '&currentTab=' + tabComponent.getActiveTabId();
		
		if(!file_object.options[Field.PROPERTY_READONLY] && !file_object.options[Field.PROPERTY_DISABLED]) {
			if(file_object.doc_id > 0) {
				//Controlar que est� bloqueado por el usuario.
				SYS_PANELS.showLoading();
				new Request({
					url: 'apia.execution.FormAction.run?action=checkLockDocument&frmId=' +  file_object.frmId.split('_')[1] + '&frmParent=' + file_object.frmId.split('_')[0] + '&attId=' + file_object.attId + '&index=' + file_object.index + '&docId=' + file_object.doc_id + (file_object.lang_id ? '&langId=' + file_object.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''),
					onSuccess: function(responseText, responseXML) {
				    	//AJAX exitoso
				    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
				    		
				    		checkErrors(responseXML);
				    		var response = responseXML.childNodes[responseXML.childNodes.length - 1];
				    		
				    		if(response.tagName == 'result' && response.getAttribute('success')) {
				    			var result = response.getAttribute('success');
				    			
				    			if(result == "ok") {
				    				//El archivo esta bloqueado por mi
				    				SynchronizeFields.preJAVAexec(file_object.fldId);
				    				SynchronizeFields.syncJAVAexec(function() {
				    					
				    					var request = new Request({
				    						method: 'post',
				    						url: 'apia.execution.FormAction.run?action=sign&frmParent=' + file_object.frmId.split('_')[0] + '&frmId=' + file_object.frmId.split('_')[1] + '&fldId=' + file_object.fldId + '&attId=' + file_object.attId + '&index=' + file_object.index  + currentTab + (file_object.lang_id ? '&langId=' + file_object.lang_id : '') + TAB_ID_REQUEST+ (window.editionMode ? '&editionMode=true' : ''),
				    						onRequest: function() {  },
				    						onComplete: function(resText, resXml) { 
				    							modalProcessXml(resXml);
				    							
				    							var response = resXml.childNodes[resXml.childNodes.length - 1];
				    							
				    							if(response.getAttribute('markedToSign') == 'true') {
				    								
				    								file_object.markedToSign = true;
				    								
				    								//Mostrar archivo como marcado para firmar
					    							var signBtn = file.getElement('div.docSignIcon');
								    				if(signBtn)
								    					signBtn.addClass('docMarkedToSignIcon').focus();
				    							} else {
				    								
				    								file_object.markedToSign = false;
				    								
				    								//Mostrar archivo como marcado para firmar
					    							var signBtn = file.getElement('div.docSignIcon');
								    				if(signBtn)
								    					signBtn.removeClass('docMarkedToSignIcon').focus();
				    							}
				    						}
				    					}).send();
				    					
				    				});
				    				
				    				file_object.isLocked = 'me';
				    				
				    			} else if(result == "locked") {
				    				//El archivo esta bloqueado por otro, actualizar visualmente y avisar
				    				
				    				var uplBtn = file.getElement('div.docUploadIcon');
				    				if(uplBtn)
				    					uplBtn.removeClass('docUploadIcon')
						    					.addClass('docUploadIconDisabled')
						    					.removeEvent('click', file_object.uploadEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				var lockBtn = file.getElement('div.docLockIcon');
				    				if(lockBtn)
				    					lockBtn.removeClass('docLockIconDisabled')
						    					.removeClass('docLockIconUnlocked')
						    					.removeClass('docLockIconLocked')
						    					.addClass('docLockIconLockedOther')
						    					.removeEvent('click', file_object.lockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
						    					.removeEvent('click', file_object.unlockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
						    					.addEvent('click', file_object.refreshLock).addEvent('keypress', Generic.enterKeyToClickListener)
						    					.set('title', response.getAttribute('lockedBy'));
				    				
				    				var signBtn = file.getElement('div.docSignIcon');
				    				if(signBtn) 
				    					signBtn.removeClass('docSignIcon')
				    							.addClass('docSignIconDisabled')
				    							.removeEvent('click', file_object.signEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				var eraseBtn = file.getElement('div.docEraseIcon');
				    				if(eraseBtn) 
				    					eraseBtn.removeClass('docEraseIcon')
				    							.addClass('docEraseIconDisabled')
				    							.removeEvent('click', file_object.eraseEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				file_object.isLocked = 'true';
				    				
				    				SYS_PANELS.closeLoading();
				    				showMessage(MSG_DOC_LOCKED_BY_USR + ': ' + response.getAttribute('usr'));
				    				
				    			} else if(result == "unlocked") {
				    				SYS_PANELS.closeLoading();
				    				
				    				//El archivo no esta bloqueado
				    				showMessage(MSG_DOC_MUST_BE_LOCKED);
				    				file_object.isLocked = 'false';
				    			}
				    		}
						}
					}
				}).send();
			} else {
				SynchronizeFields.preJAVAexec(file_object.fldId);
				SynchronizeFields.syncJAVAexec(function() {
					SYS_PANELS.showLoading();
					var request = new Request({
						method: 'post',
						url: 'apia.execution.FormAction.run?action=sign&frmParent=' + file_object.frmId.split('_')[0] + '&frmId=' + file_object.frmId.split('_')[1] + '&fldId=' + file_object.fldId + '&attId=' + file_object.attId + '&index=' + file_object.index  + currentTab + (file_object.lang_id ? '&langId=' + file_object.lang_id : '') + TAB_ID_REQUEST+ (window.editionMode ? '&editionMode=true' : ''),
						onRequest: function() {  },
						onComplete: function(resText, resXml) { 
							
							modalProcessXml(resXml);
							var response = resXml.childNodes[resXml.childNodes.length - 1];
							
							if(response.getAttribute('markedToSign') == 'true') {
								
								file_object.markedToSign = true;
								
								//Mostrar archivo como marcado para firmar
    							var signBtn = file.getElement('div.docSignIcon');
			    				if(signBtn)
			    					signBtn.addClass('docMarkedToSignIcon').focus();
							} else {
								
								file_object.markedToSign = false;
								
								//Mostrar archivo como marcado para firmar
    							var signBtn = file.getElement('div.docSignIcon');
			    				if(signBtn)
			    					signBtn.removeClass('docMarkedToSignIcon').focus();
							}
						}
					}).send();
				});
			}
		}
	},
	
	verifSignEvent: function() {
		var file = this.getParent();
		var file_object = file.getParent().retrieve(Field.STORE_KEY_FIELD);
		var currentTab = '';
		var tabComponent = $('tabComponent');
		if(tabComponent)
			currentTab = '&currentTab=' + tabComponent.getActiveTabId();
			
		if(!file_object.options[Field.PROPERTY_DISABLED]) {
			ModalController.openWinModal(CONTEXT +  '/apia.execution.FormAction.run?action=viewFieldSigns&frmParent=' + file_object.frmId.split('_')[0] + '&frmId=' + file_object.frmId.split('_')[1] + '&fldId=' + file_object.fldId + '&attId=' + file_object.attId + '&index=' + file_object.index  + currentTab + (file_object.lang_id ? '&langId=' + file_object.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''), 700, 460, null, null, true,true,false);
		}
	},
	
	checkTradLang: function(e) {
		var file_disabled = this.options[Field.PROPERTY_DISABLED] || !this.canEdit;
		var file_readonly = this.options[Field.PROPERTY_READONLY] || this.options[Field.PROPERTY_DISABLED] || !this.canRead;
		
		if(!(this.doc_id != undefined && !file_disabled && this.canEdit && !(this.isLocked == "true") && !file_readonly)) {
			if(e.event)
				e.event.stopImmediatePropagation();
			return false;
		}
	},
	
	uploadTraductionEvent: function(evt) {
		var file = this.getParent();
		var file_object = file.getParent().retrieve(Field.STORE_KEY_FIELD);
		
		if(!file_object.options[Field.PROPERTY_READONLY] && !file_object.options[Field.PROPERTY_DISABLED]) {
			if(file_object.doc_id != undefined) {
				//Controlar que esta bloqueado por el usuario.
				new Request({
					url: 'apia.execution.FormAction.run?action=checkLockDocument&frmId=' +  file_object.frmId.split('_')[1] + '&frmParent=' + file_object.frmId.split('_')[0] + '&attId=' + file_object.attId + '&index=' + file_object.index + '&docId=' + file_object.doc_id + (file_object.lang_id ? '&langId=' + file_object.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''),
					onSuccess: function(responseText, responseXML) {
				    	//AJAX exitoso
				    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
				    		
				    		checkErrors(responseXML);
				    		var response = responseXML.childNodes[responseXML.childNodes.length - 1];
				    		
				    		if(response.tagName == 'result' && response.getAttribute('success')) {
				    			var result = response.getAttribute('success');
				    			
				    			if(result == "ok") {
				    				//El archivo esta bloqueado por mi
				    				file_object.uploadDocument(file_object, file, file_object.index);
				    				file_object.isLocked = 'me';
				    			} else if(result == "locked") {
				    				//El archivo esta bloqueado por otro, actualizar visualmente y avisar
				    				
				    				var uplBtn = file.getElement('div.docUploadIcon');
				    				if(uplBtn)
				    					uplBtn.removeClass('docUploadIcon')
						    					.addClass('docUploadIconDisabled')
						    					.removeEvent('click', file_object.uploadEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				var lockBtn = file.getElement('div.docLockIcon');
				    				if(lockBtn)
				    					lockBtn.removeClass('docLockIconDisabled')
						    					.removeClass('docLockIconUnlocked')
						    					.removeClass('docLockIconLocked')
						    					.addClass('docLockIconLockedOther')
						    					.removeEvent('click', file_object.lockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
						    					.removeEvent('click', file_object.unlockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
						    					.set('title', response.getAttribute('lockedBy'));
				    				
				    				var signBtn = file.getElement('div.docSignIcon');
				    				if(signBtn) 
				    					signBtn.removeClass('docSignIcon')
				    							.addClass('docSignIconDisabled')
				    							.removeEvent('click', file_object.signEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				var eraseBtn = file.getElement('div.docEraseIcon');
				    				if(eraseBtn) 
				    					eraseBtn.removeClass('docEraseIcon')
				    							.addClass('docEraseIconDisabled')
				    							.removeEvent('click', file_object.eraseEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				file_object.isLocked = 'true';
				    				
				    				showMessage(MSG_DOC_LOCKED_BY_USR + ': ' + response.getAttribute('usr'));
				    				
				    			} else if(result == "unlocked") {
				    				//El archivo no esta bloqueado
				    				showMessage(MSG_DOC_MUST_BE_LOCKED);
				    				file_object.isLocked = 'false';
				    			}
				    		}
						}
					}
				}).send();
			} else {
				file_object.uploadTraductionDocument(file_object, file, file_object.index);
			}
		}
	},
	
	eraseEvent: function(evt) {
		var file = this.getParent();
		var file_object = file.getParent().retrieve(Field.STORE_KEY_FIELD);
		
		if(!file_object.options[Field.PROPERTY_READONLY] && !file_object.options[Field.PROPERTY_DISABLED]) {
			
			var fnc_erase = function() {
				new Request({
					url: 'apia.execution.FormAction.run?action=ajaxRemoveDocument&frmId=' +  file_object.frmId.split('_')[1] + '&frmParent=' + file_object.frmId.split('_')[0] + '&attId=' + file_object.attId + '&index=' + file_object.index + '&docId=' + file_object.doc_id + (file_object.lang_id ? '&langId=' + file_object.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''),
					onSuccess: function(responseText, responseXML) {
						//Verificar que este ok, sino refrescar visualmente para mostrar que el archivo esta bloqueado por otor usuario
						
						//AJAX exitoso
				    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
				    		
				    		checkErrors(responseXML);
				    		var response = responseXML.childNodes[responseXML.childNodes.length - 1];
				    		
				    		if(response.tagName == 'general' && response.getAttribute('success')) {
				    			if(response.getAttribute('success') == "true") {
				    				
				    				file.getElement('div.docDataSinError').set('text', '');
				    				
				    				var downBtn = file.getElement('div.docDownloadIcon');
				    				if(downBtn) {
				    					downBtn.removeClass('docDownloadIcon').addClass('docDownloadIconDisabled');
				    					var anchor = downBtn.getParent('div').getElement('a');
				    					downBtn.inject(anchor, 'after');
				    					anchor.dispose();
				    					downBtn.set('tabIndex', '');
				    				}
				    				
				    				var infoBtn = file.getElement('div.docInfoIcon');
				    				if(infoBtn)
				    					infoBtn.removeClass('docInfoIcon')
				    							.addClass('docInfoIconDisabled')
				    							.removeEvent('click', file_object.infoEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				var lockBtn = file.getElement('div.docLockIcon');
				    				if(lockBtn)
				    					lockBtn.addClass('docLockIconDisabled')
						    					.removeClass('docLockIconUnlocked')
						    					.removeClass('docLockIconLocked')
						    					.removeClass('docLockIconLockedOther')
						    					.removeEvent('click', file_object.lockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
						    					.removeEvent('click', file_object.unlockDocument).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				var signBtn = file.getElement('div.docSignIcon');
				    				if(signBtn)
				    					signBtn.removeClass('docSignIcon')
				    							.removeClass('docMarkedToSignIcon')
				    							.addClass('docSignIconDisabled')
				    							.removeEvent('click', file_object.signEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				var verifSignBtn = file.getElement('div.docVerifySignIcon');
				    				if(verifSignBtn)
				    					verifSignBtn.removeClass('docVerifySignIcon')
				    							.addClass('docVerifySignIconDisabled')
				    							.removeEvent('click', file_object.verifSignEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				var tradBtn = file.getElement('div.docTradLangIcon');
				    				if(tradBtn)
				    					tradBtn.removeClass('docTradLangIcon')
				    							.addClass('docTradLangIconDisabled');
				    				
				    				var eraseBtn = file.getElement('div.docEraseIcon');
				    				if(eraseBtn)
				    					eraseBtn.removeClass('docEraseIcon')
				    							.addClass('docEraseIconDisabled')
				    							.removeEvent('click', file_object.eraseEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
				    				
				    				file_object.doc_id = undefined;
				    				
				    				var img = file_object.content.getElement('img.fileinput-image-preview');
				    				if(img)
				    					img.destroy();
				    			} else {
				    				if(response.getAttribute('locked') == "true") {
				    					
					    				var uplBtn = file.getElement('div.docUploadIcon');
					    				if(uplBtn)
					    					uplBtn.removeClass('docUploadIcon')
							    					.addClass('docUploadIconDisabled')
							    					.removeEvent('click', file_object.uploadEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
					    				
					    				var lockBtn = file.getElement('div.docLockIcon');
					    				if(lockBtn)
					    					lockBtn.removeClass('docLockIconDisabled')
							    					.removeClass('docLockIconUnlocked')
							    					.removeClass('docLockIconLocked')
							    					.addClass('docLockIconLockedOther')
							    					.removeEvent('click', file_object.lockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
							    					.removeEvent('click', file_object.unlockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
							    					.addEvent('click', file_object.refreshLock).addEvent('keypress', Generic.enterKeyToClickListener)
							    					.set('title', response.getAttribute('lockedBy'));
					    				
					    				var eraseBtn = file.getElement('div.docEraseIcon');
					    				if(eraseBtn) 
					    					eraseBtn.removeClass('docEraseIcon')
					    							.addClass('docEraseIconDisabled')
					    							.removeEvent('click', file_object.eraseEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
					    				
					    				var signBtn = file.getElement('div.docSignIcon');
					    				if(signBtn) 
					    					signBtn.removeClass('docSignIcon')
					    							.addClass('docSignIconDisabled')
					    							.removeEvent('click', file_object.signEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
					    				file_object.isLocked = 'true';
					    				
					    				showMessage(MSG_DOC_LOCKED_BY_USR + ': ' + response.getAttribute('usr'));
					    				
				    				}
				    			} 
				    		}
				    	}
					}
				}).send();
			}
						
			
			if(file_object.form.langs && !file_object.lang_id && file_object.form.frmType == 'E') {
				showConfirm(window.MSG_DEL_FILE_TRANS, window.TIT_DEL_FILE,  function(result) {
					if(result) fnc_erase();
				});
			} else {
				fnc_erase();
			}
			
			processCheckLock(file, file_object, fnc_erase, null, null, customEraseFnc);
			
		}
	},
	
	getPrintHTML: function(formContainer) {
		
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var fieldContainer = this.parsePrintXMLposition(formContainer);
			
			var lbl = new Element('span.asLabel.asLabelFileinput').appendText(this.xml.getAttribute("attLabel") + ':')
				.setStyle('padding-bottom', '5px')
				.inject(fieldContainer);
			
			if(this.options[Field.PROPERTY_FONT_COLOR])
				lbl.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			
			if(this.options[Field.PROPERTY_REQUIRED])
				fieldContainer.addClass('required');
			
			var file_name = this.content.getElement('div.docDataSinError').get('text');
			if(file_name != "") {
				
				var docDataSinError = new Element('div.docDataSinError', {text: file_name});
				if(this.options[Field.PROPERTY_VALUE_COLOR])
					docDataSinError.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
				
				new Element('div.option.document').grab(docDataSinError).inject(fieldContainer)
					.setStyles({
						'padding-left': '5px',
						'padding-bottom': '5px',
						'padding-top': '3px',
						float: 'left',
						height: 'auto'
					});
			}
		}
	},
	
	getPrintHTMLForGrid: function() {
		if(!this.options[Field.PROPERTY_VISIBILITY_HIDDEN]) {
			var a = new Element('div');
			
			var label = new Element('span.asLabel').set('html', (this.options[Field.PROPERTY_REQUIRED] ? '*' : '') + this.xml.getAttribute("attLabel") + ':');
			if(this.options[Field.PROPERTY_FONT_COLOR]) label.setStyle('color', this.options[Field.PROPERTY_FONT_COLOR]);
			
			label.inject(new Element('td.left-cell').inject(a));
			
			var file_name = this.content.getElement('div.docDataSinError').get('text');
			if(file_name != "") {
				
				var docDataSinError = new Element('div.docDataSinError', {text: file_name});
				if(this.options[Field.PROPERTY_VALUE_COLOR])
					docDataSinError.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
				
				new Element('div.option.document').grab(docDataSinError).inject(new Element('td').inject(a))
					.setStyles({
						'padding-left': '5px',
						'padding-bottom': '5px',
						'padding-top': '3px',
						'float': 'left',
						'height': 'auto'
					});
			} else {
				new Element('td').inject(a);
			}
			
			
			return a.get('html');
		}
		return '';
	},
	
	getValueHTMLForGrid: function() {
		var a = new Element('div');
		
		var file_name = this.content.getElement('div.docDataSinError').get('text');
		if(file_name != "") {
			
			var docDataSinError = new Element('div.docDataSinError', {text: file_name});
			if(this.options[Field.PROPERTY_VALUE_COLOR])
				docDataSinError.setStyle('color', this.options[Field.PROPERTY_VALUE_COLOR]);
			
			new Element('div.option.document').grab(docDataSinError).inject(a)
				.setStyles({
					'padding-left': '5px',
					'padding-bottom': '5px',
					'padding-top': '3px',
					float: 'left',
					height: 'auto'
				});
		}
		
		return a.get('html');
	},
	
	showFormListener: function() {
		var file = this.content.getElement('div.document');
		if(file)
			file.erase('disabledCheck');
	},
	
	hideFormListener: function() {
		var file = this.content.getElement('div.document');
		if(file)
			file.set('disabledCheck', 'true');
	},
	
	forceAjaxReload: function(xml) {
		
		if(this.options[Field.PROPERTY_REQUIRED]) {
			this.content.removeClass('required');
			$('frmData').formChecker.dispose(this.content.getElement('div.document'));
		}
		
		if(this.options[Field.PROPERTY_VISIBILITY_HIDDEN])
			this.content.removeClass('visibility-hidden');
			
		//Limpiar options
		this.setDefaultOptions();
		
		this.xml = xml.childNodes[0];
		
		//Obtener options
		var options = JSON.decode(this.xml.getAttribute(Field.FIELD_PROPERTIES));
		
		//Actualizar options
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
		this.fromAjaxReload = true;
		this.parseXML();
		this.fromAjaxReload = undefined;    			
	},
	
	resetFileInput: function(){
		var file_object = this;
		var file = this.content;
		
		file.getElement('div.docData').set('text', '');
		
		var downBtn = file.getElement('div.docDownloadIcon');
		if(downBtn) {
			downBtn.removeClass('docDownloadIcon').addClass('docDownloadIconDisabled');
			var anchor = downBtn.getParent('div').getElement('a');
			anchor.dispose();
			downBtn.set('tabIndex', '');
		}
		
		var infoBtn = file.getElement('div.docInfoIcon');
		if(infoBtn)
			infoBtn.removeClass('docInfoIcon')
					.addClass('docInfoIconDisabled')
					.removeEvent('click', file_object.infoEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
		
		var editBtn = file.getElement('div.docEditIcon');
		if(editBtn)
			editBtn.addClass('docEditIconDisabled')
					.removeEvent('click', file_object.editEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
		
		var lockBtn = file.getElement('div.docLockIcon');
		if(lockBtn)
			lockBtn.addClass('docLockIconDisabled')
					.removeClass('docLockIconUnlocked')
					.removeClass('docLockIconLocked')
					.removeClass('docLockIconLockedOther')
					.removeEvent('click', file_object.lockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
					.removeEvent('click', file_object.unlockDocument).removeEvent('keypress', Generic.enterKeyToClickListener);
		
		var signBtn = file.getElement('div.docSignIcon');
		if(signBtn)
			signBtn.removeClass('docSignIcon')
					.removeClass('docMarkedToSignIcon')
					.addClass('docSignIconDisabled')
					.removeEvent('click', file_object.signEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
		
		var verifSignBtn = file.getElement('div.docVerifySignIcon');
		if(verifSignBtn)
			verifSignBtn.removeClass('docVerifySignIcon')
					.addClass('docVerifySignIconDisabled')
					.removeEvent('click', file_object.verifSignEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
		
		var tradBtn = file.getElement('div.docTradLangIcon');
		if(tradBtn){
			tradBtn.removeClass('docTradLangIcon')
					.addClass('docTradLangIconDisabled');
			
			file_object.refreshTranslationMenu(tradBtn);
		}
		
		var eraseBtn = file.getElement('div.docEraseIcon');
		if(eraseBtn)
			eraseBtn.removeClass('docEraseIcon')
					.addClass('docEraseIconDisabled')
					.removeEvent('click', file_object.eraseEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
		
		file_object.doc_id = undefined;
		
		var img = file_object.content.getElement('img.fileinput-image-preview');
		if(img)
			img.destroy();
	},
	
	refreshTranslationMenu: function(tradLangIcon) {
		if(this.translations) {
			//Se elimina información del menú anterior
			this.translations.each(function(t){ t.resetFileInput(); });			
		}
	}
});

Fileinput.customFileChecker = function(el) {
	var file = el.getParent().retrieve(Field.STORE_KEY_FIELD);
	if(file.doc_id != undefined) {
		return true;
	} else {
		el.errors.push(formcheckLanguage.required);
		return false;
	}
		
}

/*
 * Funcion genérica para procesar estado de bloqueo de documentos en formularios
 */
function processCheckLock(file, file_object, okFnc, lockedFnc, unlockedFnc, customUnlockedFnc){
	//Controlar que esta bloqueado por el usuario.
	new Request({
		url: 'apia.execution.FormAction.run?action=checkLockDocument&frmId=' +  file_object.frmId.split('_')[1] + '&frmParent=' + file_object.frmId.split('_')[0] + '&attId=' + file_object.attId + '&index=' + file_object.index + '&docId=' + file_object.doc_id + (file_object.lang_id ? '&langId=' + file_object.lang_id : '') + TAB_ID_REQUEST + (window.editionMode ? '&editionMode=true' : ''),
		onSuccess: function(responseText, responseXML) {
	    	//AJAX exitoso
	    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
	    		
	    		checkErrors(responseXML);
	
				var response = responseXML.childNodes[responseXML.childNodes.length - 1];
				
				if(response.tagName == 'result' && response.getAttribute('success')) {
					var result = response.getAttribute('success');
					
					if(result == "ok") {
						//El archivo esta bloqueado por mi
						file_object.isLocked = 'me';
						
						if (okFnc) okFnc();
						
					} else if(result == "locked") {
						//El archivo esta bloqueado por otro, actualizar visualmente y avisar	
						
						//Generic
						updateWithLockedState(file, file_object, response.getAttribute('usr'));
						
						if (lockedFnc) lockedFnc();
						
						var customLabel = MSG_DOC_LOCKED_BY_USR.replace('.', ': ' + response.getAttribute('usr') + '.');
    					showMessage(customLabel);					
						
					} else if(result == "unlocked") {
						//El archivo no esta bloqueado
						if (customUnlockedFnc){
							customUnlockedFnc();
							
						} else {
							if (unlockedFnc) unlockedFnc();
							
							//Generic						
		    				showMessage(MSG_DOC_MUST_BE_LOCKED);
		    				file_object.isLocked = 'false';							
						}
					}
				}	
	    	}
		}
	}).send();
}

function updateWithLockedState(file, file_object, lockedBy){
	var uplBtn = file.getElement('div.docUploadIcon');
	if(uplBtn)
		uplBtn.removeClass('docUploadIcon')
				.addClass('docUploadIconDisabled')
				.removeEvent('click', file_object.uploadEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
	
	var lockBtn = file.getElement('div.docLockIcon');
	if(lockBtn){
		lockBtn.removeClass('docLockIconDisabled')
				.removeClass('docLockIconUnlocked')
				.removeClass('docLockIconLocked')
				.addClass('docLockIconLockedOther')
				.removeEvent('click', file_object.lockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
				.removeEvent('click', file_object.unlockDocument).removeEvent('keypress', Generic.enterKeyToClickListener)
				.addEvent('click', file_object.refreshLock).addEvent('keypress', Generic.enterKeyToClickListener);
		
		if (lockedBy) { lockBtn.set('title', lockedBy); }
	}
	
	var signBtn = file.getElement('div.docSignIcon');
	if(signBtn) 
		signBtn.removeClass('docSignIcon')
				.addClass('docSignIconDisabled')
				.removeEvent('click', file_object.signEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
	
	var eraseBtn = file.getElement('div.docEraseIcon');
	if(eraseBtn) 
		eraseBtn.removeClass('docEraseIcon')
				.addClass('docEraseIconDisabled')
				.removeEvent('click', file_object.eraseEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
	
	var editBtn = file.getElement('div.docEditIcon');
	if(editBtn) 
		editBtn.addClass('docEditIconDisabled')
				.removeEvent('click', file_object.editEvent).removeEvent('keypress', Generic.enterKeyToClickListener);
	
	var tradBtn = file.getElement('div.docTradLangIcon');
	if (tradBtn)
		tradBtn.addClass('docTradLangIconDisabled')
				.removeClass('docTradLangIcon');
	
	file_object.isLocked = 'true';
}

function updateWithUnlockedState(file, file_object){
	//Upload
	if(!file_object.options[Field.PROPERTY_HIDE_DOC_UPLOAD] && !file_object.options[Field.PROPERTY_NO_MODIFY] && file_object.canEdit) {
		var docUpload = file.getElement('div.docUploadIcon');
		if(!docUpload) {
			upload = file.getElement('div.docUploadIconDisabled');
			upload.removeClass('docUploadIconDisabled')
					.addClass('docUploadIcon')
					.addEvent('click', file_object.uploadEvent).addEvent('keypress', Generic.enterKeyToClickListener);
		}
	}
	
	//Firma
	if(!file_object.options[Field.PROPERTY_HIDE_DOC_SIGN] && file_object.doc_id != undefined && (file_object.canEdit || file_object.canRead)) {
		var docSign = file.getElement('div.docSignIcon');
		if(!docSign) {
			docSign = file.getElement('div.docSignIconDisabled');
			docSign.removeClass('docSignIconDisabled')
					.addClass('docSignIcon')
					.addEvent('click', file_object.signEvent).addEvent('keypress', Generic.enterKeyToClickListener);
		}
	}
	
	//Borrado
	if(!file_object.options[Field.PROPERTY_HIDE_DOC_ERASE] && !file_object.options[Field.PROPERTY_NO_ERASE] && file_object.doc_id != undefined && file_object.canEdit) {
		//TODO: Verificar esto
		var docErase = file.getElement('div.docEraseIcon');
		if(!docErase) {
			docErase = file.getElement('div.docEraseIconDisabled');
			docErase.removeClass('docEraseIconDisabled')
					.addClass('docEraseIcon')
					.addEvent('click', file_object.eraseEvent).addEvent('keypress', Generic.enterKeyToClickListener);
		}
	}
	
	
	if(!file_object.options[Field.PROPERTY_HIDE_DOC_LOCK] && !file_object.options[Field.PROPERTY_NO_LOCK] && (file_object.canRead || file_object.canEdit)) {
		var lockBtn = file.getElement('div.docLockIcon');
		if(lockBtn) {
			lockBtn.removeClass('docLockIconDisabled')
					.removeClass('docLockIconUnlocked')
					.removeClass('docLockIconLocked')
					.removeClass('docLockIconLockedOther')
					.removeEvent('click', file_object.refreshLock).removeEvent('keypress', Generic.enterKeyToClickListener)
					.set('title', BTN_FILE_LOCK_LBL);
			
			if(file_object.doc_id == undefined || file_object.doc_id < 0 || !file_object.canEdit) {
				lockBtn.addClass('docLockIconDisabled');
			} else {
				lockBtn.addClass('docLockIconUnlocked')
						.addEvent('click', file_object.lockDocument).addEvent('keypress', Generic.enterKeyToClickListener);
			}
		}
	}
	
	var editBtn = file.getElement('div.docEditIcon');
	if(editBtn) 
		editBtn.removeClass('docEditIconDisabled')
				.addEvent('click', file_object.editEvent).addEvent('keypress', Generic.enterKeyToClickListener);
	
	var tradBtn = file.getElement('div.docTradLangIconDisabled');
	if (tradBtn)
		tradBtn.removeClass('docTradLangIconDisabled')
				.addClass('docTradLangIcon');
	
	file_object.isLocked = 'false';
}
