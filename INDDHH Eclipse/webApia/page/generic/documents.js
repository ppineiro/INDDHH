var DOCUMENTS_LAST_CONTAINER = "";
var prefixForDisable;

if(window.IS_READONLY == undefined)
	window.IS_READONLY = false;

var docIdsByGroupId = {};
var currentPrefix;

function initDocuments(prefix,ajaxUploadStartAction,docTypePermitted, allowSign, dontAllowEdition) { //ej: docTypePermitted = {use: false, objId: '', objType: ''}
	if (! prefix) prefix = "";
	
	prefixForDisable = prefix;
	
	var allowEdition = dontAllowEdition==undefined? false : !dontAllowEdition;
	
	if (!docTypePermitted){
		docTypePermitted = {
			use: false,
			objId: '',
			objType: ''
		}
	}
	
	initPoolMdlPage();
	initUsrMdlPage();
	
	var prmPoolContainter = $('prmDocumentContainter' + prefix);
	if (!prmPoolContainter || prmPoolContainter.documentLoaded) return;
	prmPoolContainter.documentLoaded = true;
	
	var docAddDocument = $('docAddDocument' + prefix);
	if(docAddDocument) {		
		docAddDocument.documentsPrefix = prefix;
		if (IS_READONLY) {
			docAddDocument.addClass('hidden');
		} else{
			docAddDocument.addEvent("click", function(e) {
				if(e) e.stop();
				showDocumentsModal(initDocumentMldPage, null, {
					prefix: prefix,
					addTo: 'prmDocumentContainter' + prefix, 
					buttonAdd: 'docAddDocument' + prefix, 
					allowMultiple: true,
					allowSign: allowSign,
					allowEdition: allowEdition,
					allowLock: true,
					action:ajaxUploadStartAction,
					docTypePermitted: docTypePermitted
				},null, null, null, function() {
					docAddDocument.focus();
				});
			});
			docAddDocument.addEvent('keypress', Generic.enterKeyToClickListener);
		}
	}
	initDocumentMdlPage(prefix);

	initCurrentDocuments(initDocumentMldPage, {
		prefix: prefix,
		addTo: 'prmDocumentContainter' + prefix, 
		buttonAdd: 'docAddDocument' + prefix, 
		allowMultiple: true,
		allowSign: allowSign,
		allowEdition: allowEdition,
		allowLock: true,
		readOnly: window.isMonitor ? false : IS_READONLY
	});
}

function initDocumentMldPage(extra, docInfo) {
	
	fncDocumentCreateDocument(extra, docInfo);
	
	var buttonAdd = $(extra.buttonAdd);
	if (! extra.allowMultiple)
		$(extra.buttonAdd).style.display = 'none';
	
	closeDocumentsModal();
}

function fncDocumentCreateDocument(extra, docInfo) {
	
	var documentSpan = $('documentElement' + docInfo.docId + (extra && extra.prefix ? extra.prefix : ""));
	if (documentSpan) {
		$('documentElementSize' + docInfo.docId + (extra && extra.prefix ? extra.prefix : "")).set('html', docInfo.docSize);
		return documentSpan;
	}
	
	//IMPORTANTE... pasar este prefix a todas las url! '&prefix=' + currentPrefix esto es necesario por ejemplo para documentos de instncia de proceso
	currentPrefix = extra.prefix;
	
	//En caso de ver entidad desde consulta, las opciones sobre documentos se deshabilitan
	var disabledFromQuery = extra.readOnly? 'Disabled' : '';
//	var removeReadOnly = '';
//	if (extra.readOnly) removeReadOnly = 'NoImg';
	
	var span = new Element("div", {'class': 'option document', 'id': 'documentElement' + docInfo.docId + (extra && extra.prefix ? extra.prefix : ""), 'data-docId':docInfo.docId});
	new Element('div', {'class': 'docData', html: docInfo.docName + ' (<span id="documentElementSize' + docInfo.docId + (extra && extra.prefix ? extra.prefix : "") + '">' + docInfo.docSize + '</span> kb)'}).inject(span);
	var infoIcon			= new Element('div', {'class': 'docIcon docInfoIcon' + disabledFromQuery, 'title': LBL_INFO, tabIndex: ''});
	var downloadIcon 		= new Element('a', {'download': 'true', 'href':CONTEXT + URL_REQUEST_AJAX + "?action=downloadDocument&docId=" +  encodeURIComponent(docInfo.downloadDocId) + "&prefix=" + currentPrefix + TAB_ID_REQUEST}).hide();
	var downloadContainer	= new Element('div', {'class': 'docIcon docDownloadIcon' + disabledFromQuery, 'title': LBL_DOWN_FILE});
	var uploadIcon			= docInfo.onlyInformation ? null : new Element('div', {'class': 'docIcon docUploadIcon' + disabledFromQuery, 'title': LBL_UPLOAD_FILE, tabIndex: ''});
	var editIcon			= null;
	
	//infoIcon.tooltip(LBL_INFO, {mode : 'auto',width : 100,hook : false});
	//if (uploadIcon) { uploadIcon.tooltip(LBL_UPLOAD_FILE, {mode : 'auto',width : 100,hook : false}); }
	//downloadIcon.tooltip(LBL_DOWN_FILE, {mode : 'auto',width : 100,hook : false});
	
	var lockIcon = null;
	if (! docInfo.onlyInformation) {
		if (extra.readOnly){//Ver entidad desde consulta
			lockIcon = new Element('div', {'id': 'lck' + docInfo.docId + currentPrefix ,'class': 'docIcon docLockIcon docLockIcon' + disabledFromQuery, 'title': BTN_LOC, tabIndex: ''});			
		} else if(docInfo.docLock =='true' || docInfo.docLock==true){
			if (docInfo.docUserLocking != CURRENT_USER_LOGIN) {
				lockIcon = new Element('div', {'id': 'lck' + docInfo.docId + currentPrefix ,'class': 'docIcon docLockIcon docLockIconLockedOther', 'title': docInfo.docUserLocking, tabIndex: ''});
				//lockIcon.tooltip(docInfo.docUserLocking, {mode : 'auto',width : 100,hook : false});
			} else {
				lockIcon = new Element('div', {'id': 'lck' + docInfo.docId + currentPrefix ,'class': 'docIcon docLockIcon docLockIconLocked', 'title': BTN_LOC, tabIndex: ''});	
			}
			
		} else if (docInfo.docLock=='false' || docInfo.docLock==false) {
			lockIcon = new Element('div', {'id': 'lck' + docInfo.docId + currentPrefix ,'class': 'docIcon docLockIcon docLockIconUnlocked', 'title': BTN_LOC, tabIndex: ''});
		}
		//lockIcon.tooltip(BTN_LOC, {mode : 'auto',width : 100,hook : false});
	}
	
	downloadIcon.inject(downloadContainer);
	
	span.docInfo = docInfo;
//	span.extraInfo = extra;
	span.extraInfo = JSON.decode(JSON.encode(extra)); //Clonamos objeto
	
	if (! docInfo.onlyInformation) lockIcon.docInfo = docInfo;

	if (!extra.readOnly){
		infoIcon.addEvent('click', function(e){
			if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
			showDocumentInfo(docInfo,extra);
		}).addEvent('keypress', Generic.enterKeyToClickListener);
		
		downloadContainer.addEvent('click', function(e){
			e.stop();
			
			if (window.isMonitor || this.parentElement.extraInfo.prefix==''){
				window.location = this.getElement('a').href;
			} else {
				//En ejecución se espera por edicion sincronizada
				this.parentElement.retriesCount = 10;
				syncWebDavDocumentLock(this.parentElement, docInfo.docId, function(){
					window.location = this.getElement('a').href;					
				}.bind(this))	
			}
			
		}).addEvent('keypress', Generic.enterKeyToClickListener);
	}
	
	if (! docInfo.onlyInformation && !extra.readOnly) {
		uploadIcon.addEvent('click', function(e){
			if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
			
			if(docInfo.docUserLocking && docInfo.docUserLocking != CURRENT_USER_LOGIN) return;//Doc blocked
			
			var okFnc = function(){
				if(docInfo.docUserLocking && docInfo.docUserLocking != CURRENT_USER_LOGIN) return;//Doc blocked
				
				if(Number.from(docInfo.docId) < 0 || docInfo.docUserLocking == CURRENT_USER_LOGIN) {
					this.parentElement.retriesCount = 10;
					syncWebDavDocumentLock(this.parentElement, docInfo.docId, function(){
						showDocumentsModal(initDocumentMldPage, docInfo.docId, this.extraInfo, docInfo);
					}.bind(this.parentElement));
				} else {
					showMessage(MSG_DOC_MUST_BE_LOCKED);
				}
			}.bind(this);
			
			processDocumentCheckLock(this.parentElement, okFnc);
			
		}).addEvent('keypress', Generic.enterKeyToClickListener);
		
		lockIcon.addEvent('click', function(e){
			if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
			
			if(Number.from(docInfo.docId) > 0) {
				var customFnc = function(){
					if(this.docInfo.docUserLocking && this.docInfo.docUserLocking != CURRENT_USER_LOGIN) {
						updateDocumentWithUnlockedState(this.parentElement);
						
					} else {
						if(this.docInfo.docLock == true || this.docInfo.docLock == false){
							var docElement = this.parentElement;
							var request = new Request({
								method: 'post',
								url: CONTEXT + URL_REQUEST_AJAX + '?action=lockDocument&docId=' + docElement.docInfo.docId + "&lock=" + docElement.docInfo.docLock + '&isAjax=true' + TAB_ID_REQUEST + "&prefix=" + docElement.extraInfo.prefix,
								onRequest: function() { },
								onComplete: function(resText, resXml) { modalProcessXml(resXml); }
							}).send();
						}						
					}
				}.bind(this);
				
				processDocumentCheckLock(this.parentElement, customFnc, customFnc);
			}
		}).addEvent('keypress', Generic.enterKeyToClickListener);
	}
	
	if (! docInfo.onlyInformation && currentPrefix!='') uploadIcon.inject(span);
	downloadContainer.inject(span);
	infoIcon.inject(span);
	
	if (IS_EDITION_ALLOWED && !docInfo.onlyInformation && extra.allowEdition) {
		editIcon = new Element('div', {'class': 'docIcon docEditIcon', 'title': LBL_EDIT, tabIndex: ''}).inject(span)
			.addEvent('click', function(e){
				if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
				
				if(docInfo.docUserLocking && docInfo.docUserLocking != CURRENT_USER_LOGIN) return;//Doc blocked
				
				var okFnc = function(prefix){
					var userLocking = docInfo.docUserLocking;
					if(userLocking && userLocking != CURRENT_USER_LOGIN) return;//Doc blocked
					
					if (!userLocking || userLocking == '') {
						showMessage(MSG_DOC_MUST_BE_LOCKED);
					} else if(Number.from(docInfo.docId) > 0) {
						var params = URL_REQUEST_AJAX + '?action=updateWebDavDocument&docId=' + docInfo.docId + "&prefix=" + prefix;
						openWebDavDocument(docInfo.docId, docInfo.docName, params);
					}					
				}
				
				processDocumentCheckLock(this.parentElement, okFnc);
			})
			.addEvent('keypress', Generic.enterKeyToClickListener);
	}
	
	if (!docInfo.onlyInformation && currentPrefix!='') lockIcon.inject(span);
	
	if (!docInfo.onlyInformation && extra.allowSign) {
		var firmIcon = new Element('div.docSignIcon.docIcon', {title: BTN_SIGN, tabIndex: ''});
		
		if(extra.readOnly)
			firmIcon.addClass('docMarkedToSignIcon' + disabledFromQuery);
		else if(docInfo.markedToSign)
			firmIcon.addClass('docMarkedToSignIcon');
		
		//firmIcon.tooltip(BTN_SIGN, {mode : 'auto', width : 100, hook : false});
		
		if(!extra.readOnly){
			firmIcon.addEvent('click', function(e) {
				if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
				
				if(docInfo.docUserLocking && docInfo.docUserLocking != CURRENT_USER_LOGIN) return;//Doc blocked
				
				var okFnc = function(){
					if(docInfo.docUserLocking && docInfo.docUserLocking != CURRENT_USER_LOGIN) return;//Doc blocked
					
					if(Number.from(docInfo.docId) < 0 || docInfo.docUserLocking == CURRENT_USER_LOGIN) {
						var docElement = this.parentElement;
						var request = new Request({
							method: 'post',
							url: CONTEXT + URL_REQUEST_AJAX + '?action=markDocTosign&docId=' + docElement.docInfo.docId + "&lock=" + docElement.docInfo.docLock + '&isAjax=true' + TAB_ID_REQUEST + "&prefix=" + docElement.extraInfo.prefix,
							onComplete: function(resText, resXml) { 
								//modalProcessXml(resXml);
								if(resXml) {
									var response = resXml.childNodes[resXml.childNodes.length - 1];
									
									if(response.getAttribute('markedToSign') == 'true') {
										firmIcon.addClass('docMarkedToSignIcon');
									} else {
										firmIcon.removeClass('docMarkedToSignIcon');
									}
								}
							}
						}).send();
					} else {
						showMessage(MSG_DOC_MUST_BE_LOCKED);
					}
				}.bind(this);
				
				processDocumentCheckLock(this.parentElement, okFnc, okFnc);
				
			}).addEvent('keypress', Generic.enterKeyToClickListener);
		}
		
		firmIcon.inject(span);
	}
	
	
	var firmCheckIcon = new Element('div.docIcon', {title: BTN_VERIF_SIGN, tabIndex: ''});
	
	if(Number.from(docInfo.docId) > 0 && !extra.readOnly)
		firmCheckIcon.addClass('docVerifySignIcon');
	else
		firmCheckIcon.addClass('docVerifySignIconDisabled');
	
	//firmCheckIcon.tooltip(BTN_VERIF_SIGN, {mode : 'auto', width : 100, hook : false});
	
	if(!extra.readOnly){
		firmCheckIcon.addEvent('click', function(e){
			if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
			if(Number.from(docInfo.docId) > 0)
				ModalController.openWinModal(CONTEXT +  URL_REQUEST_AJAX + '?action=viewDocSigns&docId=' + this.parentElement.docInfo.docId + "&lock=" + this.parentElement.docInfo.docLock + '&isAjax=true' + TAB_ID_REQUEST + "&prefix=" + this.parentElement.extraInfo.prefix, 700, 460, null, null, true,true,false);
		}).addEvent('keypress', Generic.enterKeyToClickListener);
	}
	
	firmCheckIcon.inject(span);
	
	if(extra.langId || docInfo.docLang) {
		
		//Agregar boton de borrado
		var deleteIcon = new Element('div.docIcon.docEraseIcon', {title: BTN_DELETE, tabIndex: ''});
		deleteIcon.addEvent('click', function() {
			if(docInfo.docUserLocking && docInfo.docUserLocking != CURRENT_USER_LOGIN) return;//Doc blocked
			
			var okFnc = function(){
				if(docInfo.docUserLocking && docInfo.docUserLocking != CURRENT_USER_LOGIN) return;//Doc blocked
				
				if(Number.from(docInfo.docId) < 0 || !docInfo.docUserLocking || docInfo.docUserLocking == CURRENT_USER_LOGIN) {
					showConfirm(MSG_CONFIG_DELETE_DOCUMENT,GNR_TIT_WARNING, fncEraseDocument.bind(this), 'modalWarning');
				}
			}.bind(this);
			
			processDocumentCheckLock(this.parentElement, okFnc, okFnc);
			
		}).addEvent('keypress', Generic.enterKeyToClickListener);
		deleteIcon.inject(span);
		
		if(docInfo.docLang && docIdsByGroupId[docInfo.docLangGroup]) {
			span.inject($(docInfo.docLang + "_" + docIdsByGroupId[docInfo.docLangGroup]), 'before');
		} else {
			span.inject($(extra.buttonAdd), 'before');
		}
		
	} else {
		
		if(docInfo.docLangGroup) {
			docIdsByGroupId[docInfo.docLangGroup] = docInfo.docId;
		}
		
		var tradLangIcon = new Element('div.docIcon', {title: BTN_TRAD, tabIndex: ''});
		tradLangIcon.addClass('docTradLangIcon');
		
		if(extra.prefix == "E" && !window.isMonitor) {
			tradLangIcon.addEvent('click', function(e) {
				//Evita abrir menu de idiomas
				if(this.docUserLocking && this.docUserLocking != CURRENT_USER_LOGIN){//Doc blocked
					if(e.event)
						e.event.stopImmediatePropagation();
					return false;
				}
			}.bind(docInfo)).addEvent('keypress', Generic.enterKeyToClickListener);
			
			
			var has_langs = false;
			
			var lang_modals = new Array();
			for(var lang_id in DOC_LANGS) {
				has_langs = true;
//				if(window.isMonitor) {
//					//Readonly
//					lang_modals.push("<div class='modalOptionsContainer'><span>" + DOC_LANGS[lang_id] + "</span><div id='" + lang_id + "_" + docInfo.docId + "' class='document context-menu-doc'><div class='docIcon docDownloadIconDisabled' title='" + LBL_DOWN_FILE + "'></div><div class='docIcon docInfoIconDisabled' title='" + LBL_INFO + "'></div><div title='" + BTN_VERIF_SIGN + "' class='docIcon docVerifySignIconDisabled'></div></div></div>");
//				} else {
					//Editable
					lang_modals.push("<div class='modalOptionsContainer'><span>" + DOC_LANGS[lang_id] + "</span><div id='" + lang_id + "_" + docInfo.docId + "' class='document context-menu-doc'><div class='docIcon docUploadIcon' title='" + LBL_UPLOAD_FILE + "'></div><div class='docIcon docDownloadIconDisabled' title='" + LBL_DOWN_FILE + "'></div><div class='docIcon docInfoIconDisabled' title='" + LBL_INFO + "'></div><div class='docIcon docLockIconDisabled' title='" + BTN_LOC+ "'></div><div title='" +BTN_SIGN + "' class='docSignIconDisabled docIcon'></div><div title='" + BTN_VERIF_SIGN+ "' class='docIcon docVerifySignIconDisabled'></div><div title='" + BTN_DELETE + "' class='docEraseIconDisabled docIcon'></div></div></div>");
//				}
				
			}
			
			if(has_langs) {
				tradLangIcon.inject(span);
				span.inject($(extra.buttonAdd), 'before');
				docInfo.langMenu = new ContextMenuModal(tradLangIcon, lang_modals, {position: 'center'});
				
				for(var lang_id in DOC_LANGS) {
					var tradDocUploadIcon = $(lang_id + "_" + docInfo.docId).getElement('div.docUploadIcon');
					if(tradDocUploadIcon)
						tradDocUploadIcon.addEvent('click', showDocumentsModalByLang.pass([lang_id, lang_id + "_" + docInfo.docId, docInfo.docLangGroup, extra])).addEvent('keypress', Generic.enterKeyToClickListener);
				}	
			} else {
				span.inject($(extra.buttonAdd), 'before');
			}
		} else {
			span.inject($(extra.buttonAdd), 'before');
		}
		
		if (! docInfo.onlyInformation && !extra.readOnly) {
			
			if(!extra.readOnly) {
				//Agregar icono de borrado
				new Element('div.docIcon.docEraseIcon', {title: BTN_FILE_ERASE_LBL, tabIndex: ''}).addEvent('click', function(evt) { 
					if(docInfo.docUserLocking && docInfo.docUserLocking != CURRENT_USER_LOGIN) return;//Doc blocked
					
					var okFnc = function(){
						if(docInfo.docUserLocking && docInfo.docUserLocking != CURRENT_USER_LOGIN) return;//Doc blocked
						
						var docId = this.getParent().docInfo.docId;
						if(Number.from(docInfo.docId) < 0 || !docInfo.docUserLocking || docInfo.docUserLocking == CURRENT_USER_LOGIN) {
							if(docInfo.langMenu && docInfo.langMenu.menu.getElements('.option').length>0) {
								showConfirm(window.MSG_DEL_FILE_TRANS, window.TIT_DEL_FILE, fncEraseDocument.bind(this), 'modalWarning');
							} else {
								showConfirm(MSG_CONFIG_DELETE_DOCUMENT,GNR_TIT_WARNING, fncEraseDocument.bind(this), 'modalWarning');
							}
						}
					}.bind(this);

					if (currentPrefix==''){
						okFnc();
					} else {
						processDocumentCheckLock(this.parentElement, okFnc, okFnc);	
					}
				}).addEvent('keypress', Generic.enterKeyToClickListener).inject(span);
			}
		}
	}
	
	//Se verifica si documenta se encuentra bloqueado por otro usuario
	//if(this.docInfo.docUserLocking && this.docInfo.docUserLocking != CURRENT_USER_LOGIN) {
	if (docInfo.docUserLocking && docInfo.docUserLocking != CURRENT_USER_LOGIN){
		updateDocumentWithLockedState(span, docInfo.docUserLocking);
	}
}

function fncDocumentRemove() {
	var ajaxCallXml = getLastFunctionAjaxCall();
	var xmlGenerals = ajaxCallXml.getElementsByTagName('general');
	
	if (xmlGenerals != null) {
		
		for (var i = 0; i < xmlGenerals.length; i++) {
			var xmlGeneral = xmlGenerals[i];
			var docId = xmlGeneral.getAttribute("docId");
			var prefix = xmlGeneral.getAttribute("prefix");
			
			//Verifica si alguna traduccion se encuentra bloqueada por otro usuario
			var langLockedBy = xmlGeneral.getAttribute('langLockedBy');
			if (langLockedBy){
				var langDoc = $('documentElement' + docId + prefix);
				updateDocumentWithLockedState(langDoc, xmlGeneral.getAttribute('usr'));
				showMessage(langLockedBy);
				return;
			}
			
			if (!prefix) prefix = "";
			var found = false;
			
			$('prmDocumentContainter' + prefix).getElements("div.document").each(function (e) {
				if(e.get("data-docId") == docId) {
					e.destroy();
					found = true;
				}
			})
			if(!found) {
				//Buscar en traducciones
				var doc = $('documentElement' + docId + prefix);
				if(doc)
					doc.destroy();
			}
		}
	}
}

var DOCS_ARE_LOCKED = false;
function disableAllDocumentsPage(){
	DOCS_ARE_LOCKED = true;
	var prmDocumentContainter = $("prmDocumentContainter" + prefixForDisable);
	$("prmAddPool" + prefixForDisable).removeEvents("click");
	
	prmDocumentContainter.getElements("div.document").each(function (div){
		div.removeEvents("click");
		div.getElements("div").each(function (divSons){
			divSons.removeEvents("click");
		});
	});
}

function showDocumentsModalByLang(langId, addTo, docLangGroup, extra) {
	var extra_clone= Object.clone(extra);
	extra_clone.addTo = 'tradDocContainter' + extra.prefix;
	extra_clone.langId = langId;
	extra_clone.buttonAdd = addTo;
	extra_clone.docLangGroup = docLangGroup;
	showDocumentsModal(initDocumentMldPage, null, extra_clone);
}

function fncEraseDocument(ret){
	if (ret) {
		var docId = this.parentElement.getAttribute('data-docId');
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=ajaxRemoveDocument&docId=' + docId + '&isAjax=true' + TAB_ID_REQUEST + "&prefix=" + this.parentElement.extraInfo.prefix,
			onRequest: function() { },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	}
}

/*
 * Funcion genérica para procesar estado de bloqueo
 */
function processDocumentCheckLock(docElement, okFnc, customUnlockedFnc){
	//Controlar que esta bloqueado por el usuario.
	new Request({
		url: CONTEXT + URL_REQUEST_AJAX + '?action=checkLockDocument&docId=' + docElement.docInfo.docId + '&isAjax=true' + TAB_ID_REQUEST + "&prefix=" + docElement.extraInfo.prefix,
		onSuccess: function(responseText, responseXML) {
	    	//AJAX exitoso
	    	if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
	    		
	    		checkErrors(responseXML);
	
				var response = responseXML.childNodes[responseXML.childNodes.length - 1];
				
				if(response.tagName == 'result' && response.getAttribute('success')) {
					var result = response.getAttribute('success');
					
					if(result == "ok") {
						//El archivo esta bloqueado por mi
						if (okFnc) okFnc(docElement.extraInfo.prefix);
						
					} else if(result == "locked") {
						//El archivo esta bloqueado por otro, actualizar visualmente y avisar	
						//Generic
						updateDocumentWithLockedState(docElement, response.getAttribute('usr'));
						
						if (!docElement.docInfo.docUserLocking){
							docElement.docInfo.docUserLocking = response.getAttribute('usr');
							var customLabel = MSG_DOC_LOCKED_BY_USR.replace('.', ': ' + response.getAttribute('usr') + '.');
	    					showMessage(customLabel);
						}
						
					} else if(result == "unlocked") {
						//El archivo no esta bloqueado
						if (customUnlockedFnc){
							customUnlockedFnc();
						} else {
							//Generic						
		    				showMessage(MSG_DOC_MUST_BE_LOCKED);
						}
					}
				}	
	    	}
		}
	}).send();
}

function updateDocumentWithLockedState(docElement, lockedBy){
	var lockBtn = docElement.getElement('div.docLockIcon');
	if(lockBtn){
		lockBtn.removeClass('docLockIconDisabled')
				.removeClass('docLockIconUnlocked')
				.removeClass('docLockIconLocked')
				.addClass('docLockIconLockedOther');
		if (lockedBy) { lockBtn.set('title', lockedBy); }
	}
	
	var uplBtn = docElement.getElement('div.docUploadIcon');
	if(uplBtn)
		uplBtn.removeClass('docUploadIcon')
				.addClass('docUploadIconDisabled');
	
	var signBtn = docElement.getElement('div.docSignIcon');
	if(signBtn) 
		signBtn.removeClass('docSignIcon')
				.addClass('docSignIconDisabled');
	
	var eraseBtn = docElement.getElement('div.docEraseIcon');
	if(eraseBtn) 
		eraseBtn.removeClass('docEraseIcon')
				.addClass('docEraseIconDisabled');
	
	var editBtn = docElement.getElement('div.docEditIcon');
	if(editBtn) 
		editBtn.addClass('docEditIconDisabled');
	
	var tradBtn = docElement.getElement('div.docTradLangIcon');
	if (tradBtn)
		tradBtn.addClass('docTradLangIconDisabled')
				.removeClass('docTradLangIcon');
}

function updateDocumentWithUnlockedState(docElement){
	var lockBtn = docElement.getElement('div.docLockIcon');
	if(lockBtn) {
		lockBtn.removeClass('docLockIconDisabled')
				.addClass('docLockIconUnlocked')
				.removeClass('docLockIconLocked')
				.removeClass('docLockIconLockedOther')
				.set('title', BTN_FILE_LOCK_LBL);
	}
	
	var uplBtn = docElement.getElement('div.docUploadIconDisabled');
	if(uplBtn)
		uplBtn.addClass('docUploadIcon')
				.removeClass('docUploadIconDisabled');
	
	var eraseBtn = docElement.getElement('div.docEraseIconDisabled');
	if(eraseBtn) 
		eraseBtn.addClass('docEraseIcon')
				.removeClass('docEraseIconDisabled');
	
	var editBtn = docElement.getElement('div.docEditIcon');
	if(editBtn) 
		editBtn.removeClass('docEditIconDisabled');
	
	var tradBtn = docElement.getElement('div.docTradLangIconDisabled');
	if (tradBtn)
		tradBtn.removeClass('docTradLangIconDisabled')
				.addClass('docTradLangIcon');
	
	docElement.docInfo.docUserLocking = null;
	docElement.docInfo.docLock = false;
}

/*
 * *****************************
 * ***** WEBDAV Functions ******
 * ***************************** 
 */

//Abre documento en repositorio WebDav 
//En caso de ser necesario solicita para instalar protocolo ItHit
function openWebDavDocument(docId, docName, params){
	new Request({
		url: CONTEXT + params + '&isAjax=true' + TAB_ID_REQUEST, 
		onSuccess: function(resText, resXml) {
			checkErrorsDoc(resXml)
			
			var response = resXml.childNodes[resXml.childNodes.length - 1];
			var folderId = response.getAttribute('folderId');
			if (folderId){
				var sDocumentUrl = WEBDAV_SERVER + folderId + '/' + docId + '/' + docName;

		        _ProtocolInstallMessage = function () { 
		        	showMessage(MSG_NO_DOC_EDIT_PROTOCOL, LBL_EDIT, 'modalWarning');
		        };
		        
		        ITHit.WebDAV.Client.DavConstants.ProtocolTimeout = 10000;
	
		      	ITHit.WebDAV.Client.DocManager.DavProtocolEditDocument(
		        		sDocumentUrl,
		        		WEBDAV_SERVER,
						_ProtocolInstallMessage
		      	);
			}
		}
	}).send();
}

//Muestra mensaje mientras se sincroniza el documento con repositorio WebDav
function syncWebDavDocumentLock(file_object, docId, successFnc){
	if (!file_object.retriesCount || file_object.retriesCount<=0){
		file_object.syncPanelMsg=null;
		SYS_PANELS.closeAll();
		return;
	}
	
	new Request({
		url: CONTEXT + URL_REQUEST_AJAX + '?action=isWebDavDocumentLocked&docId=' + docId + '&isAjax=true' + TAB_ID_REQUEST,
		onSuccess: function(responseText, responseXML) {
			var response = responseXML.childNodes[responseXML.childNodes.length - 1];
			if (response && response.getAttribute('locked')=='true'){
				//Si ya existe un mensaje activo, se utiliza
				//Sino se crea uno nuevo
				if (!file_object.syncPanelMsg){
					showMessage(MSG_WAIT_SYNC_DOCUMENT);
					file_object.syncPanelMsg = SYS_PANELS.getActive();
					file_object.syncPanelMsg.onclose = function(){
						file_object.syncPanelMsg=null;
						clearTimeout(this.timer);
					};
				}

				file_object.retriesCount--;
				if (file_object.retriesCount<=0){
					file_object.syncPanelMsg=null;
					SYS_PANELS.closeAll();
					showMessage(MSG_FAIL_SYNC_DOCUMENT);
					
				} else {
					//Se espera y se vuelve a intentar
					file_object.syncPanelMsg.timer = syncWebDavDocumentLock.delay(1000, file_object, [file_object, docId, successFnc]);	
				}
			} else {
				//Documento no bloqueado
				SYS_PANELS.closeAll();
				file_object.syncPanelMsg=null;
				file_object.retriesCount=0;
				successFnc();
			}
		}
	}).send()	
}