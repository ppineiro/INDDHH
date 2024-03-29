var currentClassE = "";
var currentClassP = "";

var executionEntForms = new Array();
var executionProForms = new Array();

var url_fromEntQuery = "";
var url_fromWorkEntity = "";

var inModal = '';
var formConf;

function initPage(){
	
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	if(ENT_TITLE && getTabContainerController())
		getTabContainerController().changeTabTitle(TAB_ID, ENT_TITLE);
	
	var frmData = $('frmData');
	
	frmData.formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 0,
					tipsPosition: 'left',
					tipsOffsetY: -12,
					tipsOffsetX: -10
				}
			}
		);
	
	var current_form_tab = null;
	
	if(window.fromEntQuery)
		url_fromEntQuery = "&fromEntQuery=true";
	
	if(window.fromWorkEntity == "true")
		url_fromWorkEntity = "&fromWorkEntity=true";
	
	//disparar el cargado de los formularios
	$$('div.formContainer').each(function (frm) {
		
		if(current_form_tab == null) {
			current_form_tab = frm.getParent().getParent();
			Form.addCollapseFunctions(current_form_tab);
		}
		
		//parse each form...
		var form = new Form(frm);
		
		executionEntForms.push(form); //Se agregan antes de ser procesados para que lo encuentre la API
		
		form.parseXML(current_form_tab);
		if(form.tabContent)
			current_form_tab = form;
	});
	
	
	
	if(currentTab!=-1){
		$('tabComponent').changeTo(currentTab);
	}
	
	
	$$("input.datePicker").each(setAdmDatePicker);
	
	

	
	var btnConf = $('btnConf');
	var btnBackToList = $('btnBackToList');
	var btnSign = $('btnSign');
	var btnViewDocs = $('btnViewDocs');
	var btnPrintFrm = $('btnPrintFrm');
	var btnClose = $('btnClose');
	var btnCloseMdl = $('btnCloseMdl');
	
	if(btnConf) {
		btnConf.addEvent('click', function(e) {
			
			e.stop();
			
			if(this.getElement('button') && this.getElement('button').get('disabled'))
				return;
			
			formConf = $('frmData');
			if(!formConf.formChecker.isFormValid()){
				return;
			}
			
//			var asocData = $('tableDataAsoc');
//			if(asocData && !asocData.formChecker.isFormValid()){
//				return;
//			}
			
			if(forceConfirm) {
				
				if(!fireFormSubmitEvents()) {
					SYS_PANELS.closeLoading();
					return;
				}
				
				//Volver a verificar requeridos luego de ejecutar clases de negocio JS en el onSubmit
				if(!formConf.formChecker.isFormValid()) {
					SYS_PANELS.closeLoading();
					return;
				}
				
				if(frmData.captchas) {
					for(var i = 0; i < frmData.captchas.length; i++ ) {
						frmData.captchas[i].processSubmit(frmData);
					}
				}
				
				inModal = '';
				if(window.frameElement && $(window.frameElement).hasClass('modal-content')) {
					inModal = '&inModal=true';
				}
				
				confirmFunction();
					
			} else {
				SynchronizeFields.syncJAVAexec(function() {
					/*
					 * onComplete con éxito ejecuta función successWebDavLockFunction()
					 */
					var submitUrl = 'apia.execution.EntInstanceListAction.run?action=checkWebDavDocumentsLocks' + TAB_ID_REQUEST;
					var request = new Request({
						method: 'post',
						url: submitUrl,
						onRequest: function() { SYS_PANELS.showLoading(); },
						onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); modalProcessXml(resXml); }
					}).send();
				});
			}
		});
	}
	
	if(btnBackToList) {
		btnBackToList.addEvent('click', function(e) {
	 
			if(window.frameElement && $(window.frameElement).hasClass('modal-content')) {
				$(window.frameElement).fireEvent('closeModal');
			}
			SYS_PANELS.showLoading();
			var url = 'apia.execution.EntInstanceListAction.run?action=goBack&' + TAB_ID_REQUEST;
			$('frmData').setProperty('action',url);
			$('frmData').fireEvent('submit');
			
			
		});
	}
	
	if(btnViewDocs){
		btnViewDocs.addEvent('click', function(e){
			if(this.getElement('button') && this.getElement('button').get('disabled'))
				e.stop();
			else
				showExecutionDocuments(btnViewDocs.getElement('button'));
		});
	}
	
	if(btnPrintFrm){
		btnPrintFrm.addEvent('click', function(e){
			if(this.getElement('button') && this.getElement('button').get('disabled'))
				e.stop();
			else
				printForms(btnPrintFrm.getElement('button'));
		});
	}
	
	
	if(btnClose)
		btnClose.addEvent('click', function() {
			getTabContainerController().removeActiveTab();
		});
	
	frmData.addEvent('submit', function(e) {
		if(window.getScrollTop) {
			$(window.frameElement).set('scrollTo', getScrollTop());
		} else {
			$(window.frameElement).set('scrollTo', window.scrollY);
		}
		
		if(frmData.captchas) {
			for(var i = 0; i < frmData.captchas.length; i++ ) {
				frmData.captchas[i].processSubmit(frmData);
			}
		}
		
		this.submit();
	});
	
	if (btnCloseMdl){
		btnCloseMdl.addEvent('click', function(e) {
			if(window.frameElement && $(window.frameElement).hasClass('modal-content')) {
				$(window.frameElement).fireEvent('closeModal');
			}
		})
	}
	
	initDocuments("E", null, {
		use: true,
		objId: docTypePerEntId,
		objType: 'E'
	}, true, false);
	
	
	/*********************/
	//detectar si hay alg?n tab marcado para resaltar
	if($('tabComments') && commentsMarked){
		$('tabComments').addClass('marked');
	}	
	/*********************/
	
	initDocumentMdlPage();
	
	initPinOptions();
	
	var scrollToY = $(window.frameElement).get('scrollTo');
	if(scrollToY) {
		window.scrollTo(0, scrollToY);
		$(window.frameElement).erase('scrollTo');
	}
	
	try{
		frmOnloadE();
	} catch(e){
		if(currentClassE!=""){
			showMessage(Generic.formatMsg(ERR_EXEC_BUS_CLASS, currentClassE));
		}
	}
	
	if(window.kb) {
		
		var ifrm_height = document.body.scrollHeight;
		var dataContainer = $('dataContainer');
		if(dataContainer) {
			ifrm_height = Number.max(ifrm_height, dataContainer.getHeight());
			var resizeId = setInterval(function() {
				var new_ifrm_height = Number.max(ifrm_height, dataContainer.getHeight());
				if(new_ifrm_height != ifrm_height) {
					window.frameElement.setStyle('height', new_ifrm_height);
					clearInterval(resizeId);
				}
			}, 100);
		}
		window.frameElement.setStyle('height', ifrm_height);
		
		if(current_form_tab){
			current_form_tab.addFormCollapseListener(function(type, target) {
				if(type == 'init') {
					var curr_height = Number.from(target.DOMform.getStyle('height'));
					target.max_height
					if(curr_height < target.max_height) {
						window.frameElement.setStyle('height', Number.from($('dataContainer').getStyle('height')) + target.max_height - curr_height);
					}
				}
				
				if(type == 'end') {
					window.frameElement.setStyle('height', Number.from($('dataContainer').getStyle('height')) + 2);
				}
			});
		}
	}
	
	if(window.initAsociations)
		initAsociations();
	
	if(window.initVisibilities)
		initVisibilities();
	
	if(window.initCategories)
		initCategories();
	
	
	checkErrors();
	
	//Prevenir submit onKeypress==enter
	new Element('input').set('type', 'text').set('title', 'Prevent Submit').setStyle('display', 'none').inject(frmData);
}

//--modal de docs
function showExecutionDocuments(source){
	var modal = ModalController.openWinModal(CONTEXT + "/page/generic/docExecutionModal.jsp?isTask=false" + TAB_ID_REQUEST , 700, 400, null, null, true,true,false);
	modal.addEvent("close", function() {
		source.focus();
	});
}

function checkErrors(xmlDoc){
 
	if(!xmlDoc) {
		//Obtener el xml del textarea		
		if (window.DOMParser) {
			parser = new DOMParser();
			xmlDoc = parser.parseFromString($('execErrors').value,"text/xml");
		} else {
			// Internet Explorer
			xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async = false;
			xmlDoc.loadXML($('execErrors').value); 
		}
	}
	
	//ie friendly
	var xml;
	if(Browser.ie) {
		for(var iter_e = xmlDoc.childNodes.length - 1; iter_e >= 0; iter_e--) {
			if(xmlDoc.childNodes[iter_e].nodeType != 3) {
				xml = xmlDoc.childNodes[iter_e];
				break;
			}
		}
	} else {
		xml = xmlDoc.childNodes[0];
	}
	
	var hasErrors = false;
	
	if(xml && xml.childNodes) {
		for(var i = 0; i < xml.childNodes.length; i++) {
			if (xml.childNodes[i].tagName == "sysExceptions") {
				processXmlExceptions(xml.childNodes[i], true);
				hasErrors = true;
			}
			
			if (xml.childNodes[i].tagName == "sysMessages") {
				processXmlMessages(xml.childNodes[i], true);
				hasErrors = true;
			}
		}
	}
	$('execErrors').value  = "<?xml version='1.0' encoding='iso-8859-1'?><data onClose='' />";
	
	return hasErrors;
}

var appletToken = "";
var forceConfirm = false;

function appletConfirmer(result, tkn) {
	signedOK = result;
	appletToken = tkn;
	
	$('btnConf').fireEvent('click', new Event({
		type: 'click',
		target: $('btnConf')
	}));
	
	hideAppletModal();
}

function forceAppletConfirmer() {
	forceConfirm = true;
	$('btnConf').fireEvent('click', new Event({
		type: 'click',
		target: $('btnConf')
	}));
	forceConfirm = false;
	hideAppletModal();
}

function appletCloser(result, tkn) {
	signedOK = result;
	
	if(tkn) {
		var request = new Request({
			method: 'post',
			url: 'apia.execution.EntInstanceListAction.run?action=unSign&appletToken=' + tkn + TAB_ID_REQUEST,
			onComplete: function(resText, resXml) { 
			}
		}).send();
	} else {
	}
	
	hideAppletModal();
}

function forceSubmit() {
	$('frmData').set('action', 'apia.execution.FormAction.run?action=refresh&' + TAB_ID_REQUEST).fireEvent('submit');
}

function fireFormSubmitEvents(){
	if (window['submitFormsData_E']!=null && !submitFormsData_E()) {
		return false;
	}
	
	return true;
}

function callNavigateClose() {
	$('btnClose').fireEvent('click');
}

function confirmFunction(){
	SynchronizeFields.syncJAVAexec(function() {
		var submitUrl = 'apia.execution.EntInstanceListAction.run?action=confirm' + TAB_ID_REQUEST;
		var params = getFormParametersToSend($('frmData')) + "&isExternal=" + EXTERNAL_ACCESS + inModal + url_fromEntQuery + url_fromWorkEntity;
		var request = new Request({
			method: 'post',
			url: submitUrl,
			onRequest: function() {
				SYS_PANELS.showLoading();
			},
			onComplete: function(resText, resXml) {
				modalProcessXml(resXml);
			}
		}).send(params);
	});
}

function successWebDavLockFunction(){
	SynchronizeFields.syncJAVAexec(function() {
		var request = new Request({
			method: 'post',
			url: 'apia.execution.EntInstanceListAction.run?action=hasSignableForms&appletToken=' + appletToken + TAB_ID_REQUEST,
			onComplete: function(resText, resultXml) {
					
				if(resultXml && resultXml.childNodes) {
					
					var resXml;
					
					if(Browser.ie && Browser.version < 10)
						resXml = resultXml.childNodes[1];
					else
						resXml = resultXml.childNodes[0];
					
					if(resXml.getAttribute("sign") == "true") {
						
						SYS_PANELS.closeLoading();
						
						//Tiene formularios firmables y/o documentos marcados para firmar
						
						var data = {};
						data.url = CONTEXT + '/page/generic/empty.jsp?' + TAB_ID_REQUEST;
						data.content = new Element('div.fieldGroup.signature');
						
						var t = new Element('table').setStyle('width', '100%');
						
						var addTitle = true;
						
						for(var i = 0; i < resXml.childNodes.length; i++) {
								
							if(resXml.childNodes[i].nodeName == 'form') {
								
								if(addTitle) {
									new Element('div.title', {html: TIT_SING_MODAL_LBL}).inject(data.content);
									addTitle = false;
								}
								
								var f = {
									i: resXml.childNodes[i].getAttribute('i'),
									t: resXml.childNodes[i].getAttribute('t'),
									p: resXml.childNodes[i].getAttribute('p'),
									m: resXml.childNodes[i].getAttribute('m'),
									r: resXml.childNodes[i].getAttribute('r')
								};
																	
								var tr = new Element('tr');
								var check = new Element('input', {type: 'checkbox'}).inject(new Element('td').setStyle('width', 30).inject(tr));
								
								if(f.m) {
									check.checked = true;
									check.store('SIGNED', 'true');
								} else {
									check.store('SIGNED', 'false');
								}
								
								if(f.r) {
									check.set('disabled', 'true');
								} else {
									check.f_object = f;
									if(f.p == 'E') {
										for(var j = 0; j < executionEntForms.length; j++) {
											if(executionEntForms[j].id == 'E_' + f.i) {
												check.current_form = executionEntForms[j]; break;
											}
										}
									} else {
										for(var j = 0; j < executionProForms.length; j++) {
											if(executionProForms[j].id == 'P_' + f.i) {
												check.current_form = executionProForms[j]; break;
											}
										}
									}
									check.addEvent('change', function() {
										//Si el elemento est? en pantalla, simular click sobre el
										if(this.current_form) {
											this.current_form.buttonSign.fireEvent('click');
											if(this.retrieve('SIGNED') == "true")
												this.store('SIGNED', 'false');
											else
												this.store('SIGNED', 'true');
										} else {
											//Sino lanzar ajax f.p, f.i
											var sign = this.retrieve('SIGNED') == 'true' ? 'false' : 'true';
											var curr_check = this;
											/****/
											new Request({
												url: 'apia.execution.FormAction.run?action=markFormToSign&frmId=' +  this.f_object.i + '&frmParent=' + this.f_object.p + '&sign=' + sign + TAB_ID_REQUEST,
											    
												onSuccess: function(responseText, responseXML) {
											    	
													//TODO: parsearErrores y mensajes
													if(responseXML && responseXML.childNodes && responseXML.childNodes.length){
														if(responseXML.childNodes[0].tagName == 'result') {
															if(responseXML.childNodes[0].getAttribute('success') == 'true') {
																if(curr_check.retrieve('SIGNED') == "true")
																	curr_check.store('SIGNED', 'false');
																else
																	curr_check.store('SIGNED', 'true');
															}
														} else if(responseXML.childNodes[1].tagName == 'result') {
															//IE friendly
															if(responseXML.childNodes[1].getAttribute('success') == 'true') {
																if(curr_check.retrieve('SIGNED') == "true")
																	curr_check.store('SIGNED', 'false');
																else
																	curr_check.store('SIGNED', 'true');
															}
														}
													}
											    }
											}).send();
										}
									});
								}
								new Element('td', {html: f.t}).inject(tr);
								tr.inject(t);
							} else {
								break;
							}
						}
						
						t.inject(data.content);
						
						//Archivos
						
						var files = {};
						var filesWithoutFrm = [];
						for(; i < resXml.childNodes.length; i++) {
							if(resXml.childNodes[i].nodeName == 'file') {
								
								var frmTitle = resXml.childNodes[i].getAttribute('f');
								var f = {
									i: resXml.childNodes[i].getAttribute('i'),
									t: resXml.childNodes[i].getAttribute('t'),
									p: resXml.childNodes[i].getAttribute('p'),
									l: resXml.childNodes[i].getAttribute('l')
								};
								if(frmTitle) {
									if(!files[frmTitle])
										files[frmTitle] = [];
									files[frmTitle].push(f);
								} else {
									filesWithoutFrm.push(f);
								}
							} else {
								break;
							}
						}
						
						var t = new Element('table.sign');
						
						addTitle = true;
						firstSubTitle = true;
						
						for(frmTitle in files) {
							
							if(addTitle) {
								new Element('div.title', {html: TIT_SING_DOCS_MODAL_LBL}).inject(data.content);
								addTitle = false;
							}
							
							var subTitle = new Element('div.subtitle', {text: frmTitle}).inject(new Element('td', {colspan: 2}).inject(new Element('tr').inject(t)));
							
							if(firstSubTitle) {
								firstSubTitle = false;
							} else {
								subTitle.addClass('notFirst');
							}
							
							for(var j = 0; j < files[frmTitle].length; j++) {
								var f = files[frmTitle][j];
								
								var tr = new Element('tr');
								var check = new Element('input', {type: 'checkbox'}).inject(new Element('td').setStyle('width', 30).inject(tr));
								
								check.checked = true;
								
								check.f_object = f;
								
								check.set('disabled', 'true');
								
								new Element('td', {html: f.l ? f.l + ' - ' + f.t : f.t}).inject(tr);
								tr.inject(t);
							}
						}
						
						if(filesWithoutFrm.length) {
							
							if(addTitle) {
								new Element('div.title', {html: TIT_SING_DOCS_MODAL_LBL}).inject(data.content);
								addTitle = false;
							}
							
							if(!firstSubTitle) {
								var subTitle = new Element('div.subtitle.notFirst', {text: LBL_OTHER_DOCS}).inject(new Element('td', {colspan: 2}).inject(new Element('tr').inject(t)));
							}
							
							for(var j = 0; j < filesWithoutFrm.length; j++) {
								var f = filesWithoutFrm[j];
								
								var tr = new Element('tr');
								var check = new Element('input', {type: 'checkbox'}).inject(new Element('td').setStyle('width', 30).inject(tr));
								
								check.checked = true;
								
								check.f_object = f;
								
								check.set('disabled', 'true');
								
								new Element('td', {html: f.l ? f.l + ' - ' + f.t : f.t}).inject(tr);
								tr.inject(t);
							}
						}
						
						t.inject(data.content);
						
						ModalController.openContentModal(data).addEvent('confirm', function() {
							SynchronizeFields.syncJAVAexec(function() {
								new Request({
									method: 'post',
									url: 'apia.execution.EntInstanceListAction.run?action=sign&' + TAB_ID_REQUEST,
									onRequest: function() { SYS_PANELS.showLoading(); },
									onComplete: function(resText, resXml) { 
										modalProcessXml(resXml);
										createBlockerDiv();
									}
								}).send();
							});
						});
						
					} else {
						
						if(!fireFormSubmitEvents()) {
							if(appletToken) {
								var request = new Request({
									method: 'post',
									url: 'apia.execution.EntInstanceListAction.run?action=unSign&appletToken=' + appletToken + TAB_ID_REQUEST,
									onComplete: function(resText, resXml) { 
										SYS_PANELS.closeLoading();
									}
								}).send();
							} else {
								SYS_PANELS.closeLoading();
							}
							return;
						}
						
						//Volver a verificar requeridos luego de ejecutar clases de negocio JS en el onSubmit
						if(!formConf.formChecker.isFormValid()) {
							if(appletToken) {
								var request = new Request({
									method: 'post',
									url: 'apia.execution.EntInstanceListAction.run?action=unSign&appletToken=' + appletToken + TAB_ID_REQUEST,
									onComplete: function(resText, resXml) { 
										SYS_PANELS.closeLoading();
									}
								}).send();
							} else {
								SYS_PANELS.closeLoading();
							}
							return;
						}
						
						inModal = '';
						if(window.frameElement && $(window.frameElement).hasClass('modal-content')) {
							inModal = '&inModal=true';
						}
						
						if(frmData.captchas) {
							for(var i = 0; i < frmData.captchas.length; i++ ) {
								frmData.captchas[i].processSubmit(frmData);
							}
						}
						
						SynchronizeFields.syncJAVAexec(function() {
							var submitUrl = 'apia.execution.EntInstanceListAction.run?action=confirm&appletToken=' + appletToken + TAB_ID_REQUEST;
							var params = getFormParametersToSend($('frmData')) + "&isExternal=" + EXTERNAL_ACCESS + inModal + url_fromEntQuery + url_fromWorkEntity;
							var request = new Request({
								method: 'post',
								url: submitUrl,
								onRequest: function() { SYS_PANELS.showLoading(); },
								onComplete: function(resText, resXml) { modalProcessXml(resXml); }
							}).send(params);
						});
					}
				}
			}
		}).send();
	});
}

function confirmOkGoBack(){
	new Request({
		method: 'post',
		url: 'apia.execution.EntInstanceListAction.run?action=confirmOkGoBack' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); modalProcessXml(resXml); }
	}).send();
}