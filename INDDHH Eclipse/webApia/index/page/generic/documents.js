var DOCUMENTS_LAST_CONTAINER = "";
var prefixForDisable;

if(window.IS_READONLY == undefined)
	window.IS_READONLY = false;

var docIdsByGroupId = {};

function initDocuments(prefix,ajaxUploadStartAction,docTypePermitted, allowSign) { //ej: docTypePermitted = {use: false, objId: '', objType: ''}
	if (! prefix) prefix = "";
	
	prefixForDisable = prefix;
	
	if (!docTypePermitted){
		docTypePermitted = {
			use: false,
			objId: '',
			objType: ''
		}
	}
	
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
				e.stop();
				showDocumentsModal(initDocumentMldPage, null, {
					prefix: prefix,
					addTo: 'prmDocumentContainter' + prefix, 
					buttonAdd: 'docAddDocument' + prefix, 
					allowMultiple: true,
					allowSign: allowSign,
					allowLock: true,
					action:ajaxUploadStartAction,
					docTypePermitted: docTypePermitted
				},null);
			});
		}
	}
	initDocumentMdlPage(prefix);
	initPoolMdlPage();
	initUsrMdlPage();
	initCurrentDocuments(initDocumentMldPage, {
		prefix: prefix,
		addTo: 'prmDocumentContainter' + prefix, 
		buttonAdd: 'docAddDocument' + prefix, 
		allowMultiple: true,
		allowSign: allowSign,
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
		$('documentElementSize' + docInfo.docId).set('html', docInfo.docSize);
		return documentSpan;
	}
	
	//IMPORTANTE... pasar este prefix a todas las url! '&prefix=' + currentPrefix esto es necesario por ejemplo para documentos de instncia de proceso
	var currentPrefix = extra.prefix;
	
	//En caso de ver entidad desde consulta, las opciones sobre documentos se deshabilitan
	var disabledFromQuery = extra.readOnly? 'Disabled' : '';
	var removeReadOnly = '';
	if (extra.readOnly) removeReadOnly = 'NoImg';
	
	var span = new Element("div", {'class': 'option optionRemove' + removeReadOnly + ' document', 'id': 'documentElement' + docInfo.docId + (extra && extra.prefix ? extra.prefix : ""), 'docId':docInfo.docId});
	new Element('div', {'class': 'docData', html: docInfo.docName + ' (<span id="documentElementSize' + docInfo.docId + '">' + docInfo.docSize + '</span> kb)'}).inject(span);
	var infoIcon			= new Element('div', {'class': 'docIcon docInfoIcon' + disabledFromQuery, 'title': LBL_INFO});
	var downloadIcon 		= new Element('a', {'title': LBL_DOWN_FILE, 'download': 'true', 'href':CONTEXT + URL_REQUEST_AJAX + "?action=downloadDocument&docId=" +  docInfo.docId + "&prefix=" + currentPrefix + TAB_ID_REQUEST});
	var downloadContainer	= new Element('div', {'class': 'docIcon docDownloadIcon' + disabledFromQuery});
	var uploadIcon			= docInfo.onlyInformation ? null : new Element('div', {'class': 'docIcon docUploadIcon' + disabledFromQuery, 'title': LBL_UPLOAD_FILE});
	
	//infoIcon.tooltip(LBL_INFO, {mode : 'auto',width : 100,hook : false});
	//if (uploadIcon) { uploadIcon.tooltip(LBL_UPLOAD_FILE, {mode : 'auto',width : 100,hook : false}); }
	//downloadIcon.tooltip(LBL_DOWN_FILE, {mode : 'auto',width : 100,hook : false});
	
	var lockIcon = null;
	if (! docInfo.onlyInformation) {
		if (extra.readOnly){//Ver entidad desde consulta
			lockIcon = new Element('div', {'id': 'lck' + docInfo.docId + currentPrefix ,'class': 'docIcon docLockIcon docLockIcon' + disabledFromQuery, 'title': BTN_LOC});			
		} else if(docInfo.docLock =='true' || docInfo.docLock==true){
			if (docInfo.docUserLocking != CURRENT_USER_LOGIN) {
				lockIcon = new Element('div', {'id': 'lck' + docInfo.docId + currentPrefix ,'class': 'docIcon docLockIcon docLockIconLockedOther', 'title': docInfo.docUserLocking});
				//lockIcon.tooltip(docInfo.docUserLocking, {mode : 'auto',width : 100,hook : false});
			} else {
				lockIcon = new Element('div', {'id': 'lck' + docInfo.docId + currentPrefix ,'class': 'docIcon docLockIcon docLockIconLocked', 'title': BTN_LOC});	
			}
			
		} else if (docInfo.docLock=='false' || docInfo.docLock==false) {
			lockIcon = new Element('div', {'id': 'lck' + docInfo.docId + currentPrefix ,'class': 'docIcon docLockIcon docLockIconUnlocked', 'title': BTN_LOC});
		}
		//lockIcon.tooltip(BTN_LOC, {mode : 'auto',width : 100,hook : false});
	}
	
	downloadContainer.inject(downloadIcon);
	
	span.docInfo = docInfo;
//	span.extraInfo = extra;
	span.extraInfo = JSON.decode(JSON.encode(extra)); //Clonamos objeto
	
	if (! docInfo.onlyInformation) lockIcon.docInfo = docInfo;

	if (!extra.readOnly){
		infoIcon.addEvent('click', function(e){
			if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
			showDocumentInfo(docInfo,extra);
		});
		
		downloadIcon.addEvent('click', function(e){
			if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
		});
	}
	
	if (! DOCS_ARE_LOCKED && ! docInfo.onlyInformation && !extra.readOnly) {
		uploadIcon.addEvent('click', function(e){
			if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
			if(Number.from(docInfo.docId) < 0 || docInfo.docUserLocking == CURRENT_USER_LOGIN) {
				showDocumentsModal(initDocumentMldPage, this.parentElement.docInfo.docId, this.parentElement.extraInfo, this.parentElement.docInfo);
			} else {
				showMessage(MSG_DOC_MUST_BE_LOCKED);
			}
		});
		
		lockIcon.addEvent('click', function(e){
			if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
			
			if(Number.from(docInfo.docId) > 0) {
				if(this.docInfo.docLock == true || this.docInfo.docLock == false){
					var request = new Request({
						method: 'post',
						url: CONTEXT + URL_REQUEST_AJAX + '?action=lockDocument&docId=' + this.parentElement.docInfo.docId + "&lock=" + this.parentElement.docInfo.docLock + '&isAjax=true' + TAB_ID_REQUEST + "&prefix=" + currentPrefix,
						onRequest: function() { },
						onComplete: function(resText, resXml) { modalProcessXml(resXml); }
					}).send();
				}
			}
		});
	}
	
	if (! docInfo.onlyInformation && (docInfo.docLock==false || docInfo.docUserLocking==CURRENT_USER_LOGIN)) uploadIcon.inject(span);
	downloadIcon.inject(span);
	infoIcon.inject(span);
	if (! docInfo.onlyInformation) lockIcon.inject(span);
	
	if (!docInfo.onlyInformation && extra.allowSign) {
		var firmIcon = new Element('div.docSignIcon.docIcon', {title: BTN_SIGN});
		
		if(extra.readOnly)
			firmIcon.addClass('docMarkedToSignIcon' + disabledFromQuery);
		else if(docInfo.markedToSign)
			firmIcon.addClass('docMarkedToSignIcon');
		
		//firmIcon.tooltip(BTN_SIGN, {mode : 'auto', width : 100, hook : false});
		
		if(!extra.readOnly){
			firmIcon.addEvent('click', function(e) {
				if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
				
				if(Number.from(docInfo.docId) < 0 || docInfo.docUserLocking == CURRENT_USER_LOGIN) {
					var request = new Request({
						method: 'post',
						url: CONTEXT + URL_REQUEST_AJAX + '?action=markDocTosign&docId=' + this.parentElement.docInfo.docId + "&lock=" + this.parentElement.docInfo.docLock + '&isAjax=true' + TAB_ID_REQUEST + "&prefix=" + currentPrefix,
						onComplete: function(resText, resXml) { 
							//modalProcessXml(resXml);
							console.log(resText);
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
			});
		}
		
		firmIcon.inject(span);
	}
	
	
	var firmCheckIcon = new Element('div.docIcon', {title: BTN_VERIF_SIGN});
	
	if(Number.from(docInfo.docId) > 0 && !extra.readOnly)
		firmCheckIcon.addClass('docVerifySignIcon');
	else
		firmCheckIcon.addClass('docVerifySignIconDisabled');
	
	//firmCheckIcon.tooltip(BTN_VERIF_SIGN, {mode : 'auto', width : 100, hook : false});
	
	if(!extra.readOnly){
		firmCheckIcon.addEvent('click', function(e){
			if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
			if(Number.from(docInfo.docId) > 0)
				ModalController.openWinModal(CONTEXT +  URL_REQUEST_AJAX + '?action=viewDocSigns&docId=' + this.parentElement.docInfo.docId + "&lock=" + this.parentElement.docInfo.docLock + '&isAjax=true' + TAB_ID_REQUEST + "&prefix=" + currentPrefix, 700, 460, null, null, true,true,false);
		});
	}
	
	firmCheckIcon.inject(span);
	
	
	//var addTo = extra.buttonAdd ? extra.buttonAdd : extra.addTo;
	
	
	if(extra.langId || docInfo.docLang) {
		
		//Agregar boton de borrado
		var deleteIcon = new Element('div.docIcon.docEraseIcon', {title: BTN_DELETE});
		deleteIcon.addEvent('click', function() {
			if(Number.from(docInfo.docId) < 0 || docInfo.docUserLocking == CURRENT_USER_LOGIN) {
				showConfirm(MSG_CONFIG_DELETE_DOCUMENT,GNR_TIT_WARNING, function(ret) {
					if (ret) {
						new Request({
							method: 'post',
							url: CONTEXT + URL_REQUEST_AJAX + '?action=ajaxRemoveDocument&docId=' + docInfo.docId + '&isAjax=true' + TAB_ID_REQUEST + "&prefix=" + currentPrefix,
							onComplete: function(resText, resXml) { 
								modalProcessXml(resXml);
							}
						}).send();
					}
				}, 'modalWarning');
			} else {
				showMessage(MSG_DOC_MUST_BE_LOCKED);
			}
		});
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
		
		var tradLangIcon = new Element('div.docIcon', {title: BTN_TRAD});
		tradLangIcon.addClass('docTradLangIcon');
//		tradLangIcon.addEvent('click', function(e){
//			if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
//			
//			alert("TODO: Traducciones de archivos");
//		});
//		var lang_modals = {};
//		for(var lang_id in this.form.langs) {
//			if(this.translations && this.translations[lang_id])
//				lang_modals['<div class="check"></div>' + this.form.langs[lang_id]] = this.showTranslationModal.bind(this).pass(lang_id);
//			else if(add_checks)
//				lang_modals['<div class="check-space"></div>' + this.form.langs[lang_id]] = this.showTranslationModal.bind(this).pass(lang_id);	
//			else
//				lang_modals[this.form.langs[lang_id]] = this.showTranslationModal.bind(this).pass(lang_id);	
//		}
		
		
		if(extra.prefix == "E" && !window.isMonitor) {
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
				this.langMenu = new ContextMenuModal(tradLangIcon, lang_modals, {position: 'center'});
				
				for(var lang_id in DOC_LANGS) {
					var tradDocUploadIcon = $(lang_id + "_" + docInfo.docId).getElement('div.docUploadIcon');
					if(tradDocUploadIcon)
						tradDocUploadIcon.addEvent('click', showDocumentsModalByLang.pass([lang_id, lang_id + "_" + docInfo.docId, docInfo.docLangGroup, extra]));
				}	
			} else {
				span.inject($(extra.buttonAdd), 'before');
			}
		} else {
			span.inject($(extra.buttonAdd), 'before');
		}
		
		if (! DOCS_ARE_LOCKED && ! docInfo.onlyInformation && !extra.readOnly) {
			span.addEvent('click', function(evt) { 
				var docId = this.docInfo.docId;
				
				if(Number.from(docInfo.docId) < 0 || docInfo.docUserLocking == CURRENT_USER_LOGIN) {
					showConfirm(MSG_CONFIG_DELETE_DOCUMENT,GNR_TIT_WARNING, 
						function(ret) {
							if (ret) {
								var request = new Request({
									method: 'post',
									url: CONTEXT + URL_REQUEST_AJAX + '?action=ajaxRemoveDocument&docId=' + docId + '&isAjax=true' + TAB_ID_REQUEST + "&prefix=" + currentPrefix,
									onRequest: function() { },
									onComplete: function(resText, resXml) { modalProcessXml(resXml); }
								}).send();
							}
						}
					, 'modalWarning');
				} else {
					showMessage(MSG_DOC_MUST_BE_LOCKED);
				}
			}); 
		}
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
			
			if (!prefix) prefix = "";
			var found = false;
			
			$('prmDocumentContainter' + prefix).getElements("div.document").each(function (e) {
				if(e.get("docId") == docId) {
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