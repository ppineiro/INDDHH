var currentClassE = "";
var currentClassP = "";
var ACTION_CONFIRM = 0;
var ACTION_SAVE = 1;
var lastAction = -1;

var executionEntForms = new Array();
var executionProForms = new Array();

var APIA_SOCIAL_ACTIVE = false;

var IN_EXECUTION = false;
var docTypePerEntId;
var docTypePerProId;

function getTabContainerController() {
	var inIframe = window.parent != null && window.parent.document != null;
	var result = document.getElementById("tabContainer");
	if (result == null && inIframe) result = window.parent.document.getElementById("tabContainer");
	return result;
}

function initPage() {
	
	if(TSK_TITLE && getTabContainerController())
		getTabContainerController().changeTabTitle(TAB_ID, TSK_TITLE);
	
	//detectar si hay alg�n tab marcado para resaltar
	if($('tabComments') && commentsMarked){
		$('tabComments').addClass('marked');
	}

	var frmData = $('frmData');
	
	frmData.formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: -12,
					tipsOffsetX: -10
				}
			}
		);
	
	var current_form_tab = null; 
	var current_form_tab_E = null;
	var current_form_tab_P = null;
	
	//disparar el cargado de los formularios
	$$('div.formContainer').each(function (frm) {
		/*
		if(current_form_tab == null) {
			current_form_tab = frm.getParent().getParent();
			Form.addCollapseFunctions(current_form_tab);
		}
		*/
		//parse each form...
		var form = new Form(frm);
		
		if(form.frmType == "E") {
			executionEntForms.push(form);
			if(current_form_tab_E == null) {
				//current_form_tab_E = current_form_tab;
				current_form_tab_E = frm.getParent().getParent()
				Form.addCollapseFunctions(current_form_tab_E);
			}
			
			form.parseXML(current_form_tab_E);
			
			if(form.tabContent)
				current_form_tab_E = form;
		} else {
			executionProForms.push(form);
			if(current_form_tab_P == null) {
				//current_form_tab_P = current_form_tab;
				current_form_tab_P = frm.getParent().getParent()
				Form.addCollapseFunctions(current_form_tab_P);
			}
			
			form.parseXML(current_form_tab_P);
			
			if(form.tabContent)
				current_form_tab_P = form;
		}
	});
	
	checkErrors();
	
	if(currentTab!=-1){
		$('tabComponent').changeTo(currentTab);
	}
	
	try{
		frmOnloadE();
	} catch(e){
		if(currentClassE!=""){
			showMessage(Generic.formatMsg(ERR_EXEC_BUS_CLASS, currentClassE));
		}
	}
	try{
		frmOnloadP();
	} catch(e){
		if(currentClassP!=""){
			showMessage(Generic.formatMsg(ERR_EXEC_BUS_CLASS, currentClassP));
		}
	}
	
	frmData.addEvent('submit', function(e) {
		$(window.frameElement).set('scrollTo', window.scrollY);
		this.submit();
	}); 
	 
	var btnConf = $('btnConf');
	var btnNext = $('btnNext');
	var btnLast = $('btnLast');
	var btnSave = $('btnSave');
	var btnFree = $('btnFree');
	var btnDelegate = $('btnDelegate');
	var btnBackToMinisite = $('btnBackToMinisite');
	var btnViewDocs = $('btnViewDocs');
	var btnPrintFrm = $('btnPrintFrm');
	var btnViewCal = $("btnViewCal");
	
	if (btnConf) {
		btnConf.addEvent('click', function(e) {
			
			if(e && e.stop)
				e.stop();
			
			if(this.getElement('button') && this.getElement('button').get('disabled'))
				return;
			
			if(btnConf.getProperty('btnDisabled') != 'true'){
				
				if(!frmData.formChecker.isFormValid()){
					return;
				}
				
				if(forceConfirm) {
					
					if(!fireFormSubmitEvents()) {
						SYS_PANELS.closeLoading();
						return;
					}
										
					//Se ejecutaron las clases js onSubmit
					if(!frmData.formChecker.isFormValid()) {
						SYS_PANELS.closeLoading();
						return;
					}
					
					SynchronizeFields.syncJAVAexec(function() {
						var submitUrl = 'apia.execution.TaskAction.run?action=confirm&appletToken=' + appletToken + TAB_ID_REQUEST;
						var params = getFormParametersToSend(frmData);
						lastAction = ACTION_CONFIRM;
						var request = new Request({
							method: 'post',
							url: submitUrl,
							onComplete: function(resText, resultXml) {
								//No tenia nada firmable, se confirm� la tarea
								modalProcessXml(resultXml);
							}
						}).send(params);
					});
					
				} else {
					SynchronizeFields.syncJAVAexec(function() {
						var request = new Request({
							method: 'post',
							url: 'apia.execution.TaskAction.run?action=hasSignableForms&prevSteps=true&appletToken=' + appletToken + TAB_ID_REQUEST,
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
										data.content = new Element('div.fieldGroup');
										
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
														//Si el elemento est� en pantalla, simular click sobre el
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
										
										//Steps anteriores
										var t = new Element('table').setStyle('width', '100%');
										addTitle = true;
										
										for(; i < resXml.childNodes.length; i++) {
											
											if(resXml.childNodes[i].nodeName == 'form_prev') {
												
												if(addTitle) {
													new Element('div.title', {html: TIT_SING_MODAL_PREV_LBL}).inject(data.content);
													addTitle = false;
												}
												
												var tr = new Element('tr');
												var check = new Element('input', {type: 'checkbox'}).inject(new Element('td').setStyle('width', 30).inject(tr));
												
												check.checked = true;
												
												check.set('disabled', 'true');
												
												new Element('td', {html: resXml.childNodes[i].getAttribute('t')}).inject(tr);
												tr.inject(t);
											} else {
												break;
											}
										}
										
										if(!addTitle)
											t.inject(data.content);
										
										
										//Archivos
										
										var t = new Element('table').setStyle('width', '100%');
										
										addTitle = true;
										
										for(; i < resXml.childNodes.length; i++) {
											
											if(resXml.childNodes[i].nodeName == 'file') {
												
												if(addTitle) {
													new Element('div.title', {html: TIT_SING_DOCS_MODAL_LBL}).inject(data.content);
													addTitle = false;
												}
												
												var f = {
													i: resXml.childNodes[i].getAttribute('i'),
													t: resXml.childNodes[i].getAttribute('t'),
													p: resXml.childNodes[i].getAttribute('p'),
													l: resXml.childNodes[i].getAttribute('l'),
												};
												
												var tr = new Element('tr');
												var check = new Element('input', {type: 'checkbox'}).inject(new Element('td').setStyle('width', 30).inject(tr));
												
												check.checked = true;
												
												check.f_object = f;
												
												check.set('disabled', 'true');
												
												new Element('td', {html: f.l + ' - ' + f.t}).inject(tr);
												tr.inject(t);
											} else {
												break;
											}
										}

										t.inject(data.content);
										
										ModalController.openContentModal(data).addEvent('confirm', function() {
											SynchronizeFields.syncJAVAexec(function() {
												new Request({
													method: 'post',
													url: 'apia.execution.TaskAction.run?action=sign&' + TAB_ID_REQUEST,
													onRequest: function() { SYS_PANELS.showLoading(); },
													onComplete: function(resText, resXml) { 
														modalProcessXml(resXml);
													}
												}).send();
											});
										});
									} else {
										//Confirmar tarea
										if(fireFormSubmitEvents()) {
											//Se ejecutaron las clases js onSubmit
											
											if(!frmData.formChecker.isFormValid()) {
												if(appletToken) {
													var request = new Request({
														method: 'post',
														url: 'apia.execution.TaskAction.run?action=unSign&appletToken=' + appletToken + TAB_ID_REQUEST,
														onComplete: function(resText, resXml) { 
															SYS_PANELS.closeLoading();
														}
													}).send();
												} else {
													SYS_PANELS.closeLoading();
												}
												return;
											}
											
											SynchronizeFields.syncJAVAexec(function() {
												var submitUrl = 'apia.execution.TaskAction.run?action=confirm&appletToken=' + appletToken + TAB_ID_REQUEST;
												var params = getFormParametersToSend(frmData);
												lastAction = ACTION_CONFIRM;
												var request = new Request({
													method: 'post',
													url: submitUrl,
													onComplete: function(resText, resultXml) {
														//No tenia nada firmable, se confirm� la tarea
														modalProcessXml(resultXml);
													}
												}).send(params);
											});
										} else {
											//Una clase de negocio retorno false
											if(appletToken) {
												var request = new Request({
													method: 'post',
													url: 'apia.execution.TaskAction.run?action=unSign&appletToken=' + appletToken + TAB_ID_REQUEST,
													onComplete: function(resText, resXml) { 
														SYS_PANELS.closeLoading();
													}
												}).send();
											} else {
												SYS_PANELS.closeLoading();
											}
										}
									}
								}
							}
						}).send();
					});
				}
			}
		});
	}
	
	if (btnSave) {
		btnSave.addEvent('click', function(e) {
		
			e.stop();
			
			if(this.getElement('button') && this.getElement('button').get('disabled'))
				return;
			
			if(btnSave.getProperty('btnDisabled') != 'true') {
				saving = true;
				saveTask();
				saving = false;
			}
		});
	}
	
	if(btnNext){
		btnNext.addEvent('click', function(e) {
			e.stop();
			if(this.getElement('button') && this.getElement('button').get('disabled'))
				return;
			
			if(btnNext.getProperty('btnDisabled') != 'true') {
				
				if(!frmData.formChecker.isFormValid()){
					return;
				}
				
//				if(fireFormSubmitEvents()){
//					SYS_PANELS.showLoading();
//					 SynchronizeFields.syncJAVAexec(function() {
//						 frmData.setProperty('action', 'apia.execution.TaskAction.run?action=gotoNextStep' + TAB_ID_REQUEST + '&currentTab=' + $('tabComponent').getActiveTabId());
//						 frmData.fireEvent('submit');
//					 });
//				}
				

				//TODO: Consultar al servidor por formularios para firmar
				
					SynchronizeFields.syncJAVAexec(function() {
						var request = new Request({
							method: 'post',
							url: 'apia.execution.TaskAction.run?action=hasSignableForms&appletToken=' + appletToken + TAB_ID_REQUEST,
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
										data.content = new Element('div.fieldGroup');
										
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
														//Si el elemento est� en pantalla, simular click sobre el
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
										
										var t = new Element('table').setStyle('width', '100%');
										
										addTitle = true;
										
										for(; i < resXml.childNodes.length; i++) {
											
											if(resXml.childNodes[i].nodeName == 'file') {
												
												if(addTitle) {
													new Element('div.title', {html: TIT_SING_DOCS_MODAL_LBL}).inject(data.content);
													addTitle = false;
												}
												
												var f = {
													i: resXml.childNodes[i].getAttribute('i'),
													t: resXml.childNodes[i].getAttribute('t'),
													p: resXml.childNodes[i].getAttribute('p'),
													l: resXml.childNodes[i].getAttribute('l'),
												};
												
												var tr = new Element('tr');
												var check = new Element('input', {type: 'checkbox'}).inject(new Element('td').setStyle('width', 30).inject(tr));
												
												check.checked = true;
												
												check.f_object = f;
												
												check.set('disabled', 'true');
												
												new Element('td', {html: f.l + ' - ' + f.t}).inject(tr);
												tr.inject(t);
											} else {
												break;
											}
										}

										t.inject(data.content);
										
										ModalController.openContentModal(data).addEvent('confirm', function() {
//											SynchronizeFields.syncJAVAexec(function() {
//												new Request({
//													method: 'post',
//													url: 'apia.execution.TaskAction.run?action=sign&' + TAB_ID_REQUEST,
//													onRequest: function() { SYS_PANELS.showLoading(); },
//													onComplete: function(resText, resXml) { 
//														modalProcessXml(resXml);
//													}
//												}).send();
//											});
											
											if(!fireFormSubmitEvents()) {
												SYS_PANELS.closeLoading();
												return;
											}
																
											//Se ejecutaron las clases js onSubmit
											if(!frmData.formChecker.isFormValid()) {
												SYS_PANELS.closeLoading();
												return;
											}
											
											SYS_PANELS.showLoading();
											SynchronizeFields.syncJAVAexec(function() {
												frmData.setProperty('action', 'apia.execution.TaskAction.run?action=gotoNextStep' + TAB_ID_REQUEST + '&currentTab=' + $('tabComponent').getActiveTabId());
												frmData.fireEvent('submit');
											});
											
											
//											SynchronizeFields.syncJAVAexec(function() {
//												var submitUrl = 'apia.execution.TaskAction.run?action=confirm&appletToken=' + appletToken + TAB_ID_REQUEST;
//												var params = getFormParametersToSend(frmData);
//												lastAction = ACTION_CONFIRM;
//												var request = new Request({
//													method: 'post',
//													url: submitUrl,
//													onComplete: function(resText, resultXml) {
//														//No tenia nada firmable, se confirm� la tarea
//														modalProcessXml(resultXml);
//													}
//												}).send(params);
//											});
										});
									} else {
										//Confirmar tarea
										if(fireFormSubmitEvents()) {
											//Se ejecutaron las clases js onSubmit
											
											if(!frmData.formChecker.isFormValid()) {
//												if(appletToken) {
//													var request = new Request({
//														method: 'post',
//														url: 'apia.execution.TaskAction.run?action=unSign&appletToken=' + appletToken + TAB_ID_REQUEST,
//														onComplete: function(resText, resXml) { 
//															SYS_PANELS.closeLoading();
//														}
//													}).send();
//												} else {
													SYS_PANELS.closeLoading();
//												}
												return;
											}
											
											//TODO: Pasar al siguiente step
//											alert("PASAR AL SIGUIENTE STEP");
											
											SynchronizeFields.syncJAVAexec(function() {
												frmData.setProperty('action', 'apia.execution.TaskAction.run?action=gotoNextStep' + TAB_ID_REQUEST + '&currentTab=' + $('tabComponent').getActiveTabId());
												frmData.fireEvent('submit');
											});
											
//											SynchronizeFields.syncJAVAexec(function() {
//												var submitUrl = 'apia.execution.TaskAction.run?action=confirm&appletToken=' + appletToken + TAB_ID_REQUEST;
//												var params = getFormParametersToSend(frmData);
//												lastAction = ACTION_CONFIRM;
//												var request = new Request({
//													method: 'post',
//													url: submitUrl,
//													onComplete: function(resText, resultXml) {
//														//No tenia nada firmable, se confirm� la tarea
//														modalProcessXml(resultXml);
//													}
//												}).send(params);
//											});
										} else {
											//Una clase de negocio retorno false
//											if(appletToken) {
//												var request = new Request({
//													method: 'post',
//													url: 'apia.execution.TaskAction.run?action=unSign&appletToken=' + appletToken + TAB_ID_REQUEST,
//													onComplete: function(resText, resXml) { 
//														SYS_PANELS.closeLoading();
//													}
//												}).send();
//											} else {
												SYS_PANELS.closeLoading();
//											}
										}
									}
								}
							}
						}).send();
					});
				
			}
		});
	}

	if(btnLast) {
		btnLast.addEvent('click', function(e) {
			
			if(this.getElement('button') && this.getElement('button').get('disabled')) {
				e.stop();
			} else if(btnLast.getProperty('btnDisabled') != 'true') {
				SYS_PANELS.showLoading();
				SynchronizeFields.syncJAVAexec(function() { 
					frmData.disabledCheck = true;
					frmData.setProperty('action', 'apia.execution.TaskAction.run?action=gotoPrevStep' + TAB_ID_REQUEST + '&currentTab=' + $('tabComponent').getActiveTabId());
					frmData.fireEvent('submit');
				});
			}
		});
	}
	
	if(btnFree) {
		btnFree.addEvent('click', function(e) {
			if(this.getElement('button') && this.getElement('button').get('disabled')) {
				e.stop();
			} else {
				SYS_PANELS.showLoading();
				var submitUrl = 'apia.execution.TaskAction.run?action=release&' + TAB_ID_REQUEST;
				var request = new Request({
					method: 'post',
					url: submitUrl,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
	}
	
	if(btnViewDocs) {
		btnViewDocs.addEvent('click', function(e){
			if(this.getElement('button') && this.getElement('button').get('disabled'))
				e.stop();
			else
				showExecutionDocuments();
		});
	}
	
	if(btnPrintFrm) {
		btnPrintFrm.addEvent('click', function(e) {
			if(this.getElement('button') && this.getElement('button').get('disabled'))
				e.stop();
			else
				printForms();
		});
	}
	
	if(btnViewCal) {
		initCalendarViewMdlPage();
		btnViewCal.addEvent('click', function(e) {
			var selCalValue = $("selCal").get('value');
			if(selCalValue != "0") {
				var calId = selCalValue;
				showCalendarViewModal(calId);
			}
		})
	}
	
	if(btnBackToMinisite) {
		btnBackToMinisite.addEvent('click', function(e) {
			window.parent.location = 'apia.security.LoginAction.run?action=gotoMinisite' + TAB_ID_REQUEST;
		});
	}
	
	if (btnDelegate) {
		btnDelegate.addEvent("click", function(e) {
			if(this.getElement('button') && this.getElement('button').get('disabled')) {
				e.stop();
			} else {
				showConfirm(MSG_NO_GUA,GNR_TIT_WARNING, function(ret) {  
						if (ret) {
							SYS_PANELS.closeAll();
							SYS_PANELS.showLoading();
							var request = new Request({
								method: 'post',
								url: 'apia.execution.TaskAction.run?action=startDelegate' + TAB_ID_REQUEST,
								onRequest: function() { SYS_PANELS.showLoading(); },
								onComplete: function(resText, resXml) { modalProcessXml(resXml); }
							}).send();
						} 
					}, 
					"modalWarning"
				);
			}
		});
	}
	
	drawStepsGraph();
	
	initPinOptions();
 
	if (IN_EXECUTION) {
		initDocuments("E",null,{
			use: true,
			objId: docTypePerEntId,
			objType: 'E'
		}, true);
		initDocuments("P",null,{
			use: true,
			objId: docTypePerProId,
			objType: 'P'
		}, true);
	} else {
		initDocuments("E");
		initDocuments("P");
	}
	
	initDocumentMdlPage();
	
	var scrollToY = $(window.frameElement).get('scrollTo');
	if(scrollToY) {
		window.scrollTo(0, scrollToY);
		$(window.frameElement).erase('scrollTo');
	}
	
	var tabMonitor = $('tabMonitor');
	if(tabMonitor) {
		tabMonitor.addEvent('click', function() {
			addScrollTable($('tableDataFormEnt'));
		});
		
		var gridBodyFormEntHeader = $('gridBodyFormEntHeader')
		if(gridBodyFormEntHeader) {
			$('gridBodyFormEnt').addEvent('custom_scroll', function(left) {			
				gridBodyFormEntHeader.setStyle('left', left);
			});
		}
	}
	
	//APIA SOCIAL
	if (APIA_SOCIAL_ACTIVE) {
		initTaskReadPanel();
		loadCurrentChannels();
		loadApiaSocialCurrentMessages();		
	}
	
	if(idNumWrite) {
		frmData.formChecker.register($('txtProNum').addClass('validate["required"]'));
	}
}

function saveTask(){
	 if(fireFormSubmitEvents()){
		 SynchronizeFields.syncJAVAexec(function() {
				var submitUrl = 'apia.execution.TaskAction.run?action=saveTask&' + TAB_ID_REQUEST;
				var params = getFormParametersToSend($('frmData'));
				lastAction=ACTION_SAVE;
				var request = new Request({
					method: 'post',
					url: submitUrl,
					onRequest: function() { },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send(params);
			});		 
	 }
}

function fireFormSubmitEvents(){
	if (window['submitFormsData_E']!=null && !submitFormsData_E()) {
		return false;
	}
	
	if (window['submitFormsData_P']!=null && !submitFormsData_P()) {
		return false;
	}
	
	return true;
}

function drawStepsGraph(){
	
	var container = $('stepsGraph');
	if (container) {
		for(i=0;i<stepQty;i++){
			var selected = "";
			if((i+1)==currentStep){
				selected = " selected";
			}
			var div = new Element("div", {html: '', 'class': 'stepElement' + selected });
			div.set('title','Step ' + (i+1));
			setTooltip(div);
			div.inject(container);
		}
	}
}

function checkErrors(){
	
	var xmlDoc;
	if (window.DOMParser) {
		parser = new DOMParser();
		xmlDoc = parser.parseFromString(new String($('execErrors').value),"text/xml");
	} else {
		// Internet Explorer
		xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc.async = false;
		xmlDoc.loadXML(new String($('execErrors').value)); 
	}
	
	//var xml =  xmlDoc.childNodes[0];
	//var xml = Browser.ie && Browser.version < 9 ?  xmlDoc.childNodes[1] :  xmlDoc.childNodes[0];
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
	/*
	if (xml.getElementsByTagName("sysExceptions").length != 0) {
		processXmlExceptions(xml.getElementsByTagName("sysExceptions").item(0), true);
		hasErrors = true;
	}
	
	if (xml.getElementsByTagName("sysMessages").length != 0) {
		processXmlMessages(xml.getElementsByTagName("sysMessages").item(0), true);
		hasErrors = true;
	}
	*/
	$('execErrors').value  = "<?xml version='1.0' encoding='iso-8859-1'?><data onClose='' />";
	
	return hasErrors;
}

///-------Funciones para el confirmOK
function confirmOkOnClose(){
	SYS_PANELS.showLoading();
	var params = "";
	//ir al server a verificar si hay wizzard
	var request = new Request({
		method: 'post',
		url: 'apia.execution.TaskAction.run?action=checkWizzard' + TAB_ID_REQUEST,
		onRequest: function() {  },
		onComplete: function(resText, resXml) { processCheckWizzard(resXml); }
	}).send(params);
}

function confirmOkOnSave() {
	SYS_PANELS.closeActive();
}

function confirmOkOnCloseSplash(){
	var tabContainer = window.parent.document.getElementById('tabContainer');
	if(tabContainer) {
		tabContainer.removeTab(tabContainer.activeTab);
	} else {
		if(onFinish=="2") {
			window.parent.location.reload();
		}
	}
}

function clearEvalPath(){

	SYS_PANELS.showLoading();
	var params = "";
	var request = new Request({
		method: 'post',
		url: 'apia.execution.TaskAction.run?action=clearEvalPath' + TAB_ID_REQUEST,
		onRequest: function() {  },
		onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); }
	}).send(params);
	
}

function confirmOkOnSaveSplash() {
	confirmOkOnSave();
	confirmOkOnCloseSplash();
}

function releaseOkOnClose(){
	checkActionRedirect();
}

function delegateOkOnClose(){
	checkActionRedirect();
}

function processCheckWizzard(resXml){
	//si es de wizzard se redirige, sino se pregunta al usuario que desea hacer.
	if (resXml != null) {
		var url;
		if(resXml.firstChild.nextSibling != null){
			url = resXml.firstChild.nextSibling.getAttribute('url')
		}	else {
			url = resXml.firstChild.getAttribute('url');
		}	
		
		if(url!=null){
			SYS_PANELS.showLoading();
			document.location.href = url; 
		} else {
			if(lastAction==ACTION_SAVE){
				SYS_PANELS.showLoading();
				$('frmData').setProperty('action', 'apia.execution.TaskAction.run?action=refreshStep' + '&currentTab=' + $('tabComponent').getActiveTabId() + TAB_ID_REQUEST);
				$('frmData').disabledCheck = true;
				$('frmData').fireEvent('submit');
			} else if(lastAction==ACTION_CONFIRM){
				checkActionRedirect();
			} else {
				showMessage(LBL_ERROR);
				if(window.console && console.log) console.log("sin valor en lastAction");
			}
						
		}
	}

}

function checkActionRedirect(){
	
	if(EXTERNAL_ACCESS=="true"){
		if (IS_MINISITE=="true") {
			window.parent.location = 'apia.security.LoginAction.run?action=gotoMinisite' + TAB_ID_REQUEST;
		}
		if(onFinish=="1"){
			window.parent.parent.close();
		} else if(onFinish=="2"){
			window.parent.location.reload();
		} else if(onFinish=="3") {
			
		} else if(onFinish=="100") {
			//close tab
			XD.postMessage("custom_close_tab", "*", parent.parent)
//			var tabContainer = window.parent.parent.document.getElementById('tabContainer');
//			tabContainer.removeTab(tabContainer.activeTab);
		} else {
			//keepBlocking
			new Element('div.modalBlocker').setStyles({
				width: "100%",
				height: "100%",
				position: "fixed",
				top: "0px",
				left: "0px",
				zIndex: currentZIndex
			}).inject(document.body);
		}
	} else {
		//close tab
		var tabContainer = window.parent.document.getElementById('tabContainer');
		tabContainer.removeTab(tabContainer.activeTab);
	}
}

///-------Funciones para el selectPool


///-------Funciones para el selectPath
function pathOnload(){
	enableFirstColumn($("trPath").getElementsByTagName("TD")[0].getElementsByTagName("TBODY")[0]);
}



function enableFirstColumn(obj) {
	var j;
	for (j=0;j<obj.rows.length;j++) {
		if (obj.rows[j].cells[0].getElementsByTagName("INPUT")[0]) {
			obj.rows[j].cells[0].getElementsByTagName("INPUT")[0].disabled=false;
			if (obj.rows[j].cells[0].getElementsByTagName("INPUT")[0].checked) {
				obj.rows[j].cells[1].style.color="black";
			}
		} else {
			obj.rows[j].cells[0].style.color="black";
			obj.rows[j].cells[1].style.color="black";
			if (rowHasTable(obj.rows[j])) {
				enableFirstColumn(getTable(obj.rows[j]));
			}
		}
	}
}

function getTable(objTr) {
	if (objTr.cells.length == 3) {
		return objTr.cells[2].getElementsByTagName("TABLE")[0];
	} else {
		return objTr.cells[1].getElementsByTagName("TABLE")[0];
	}
}
function checkRadio(obj) {
	if (obj.checked) {
		table = obj.parentNode.parentNode.parentNode.parentNode;
		tdIndex = obj.parentNode.cellIndex;
		trIndex = obj.parentNode.parentNode.rowIndex;
		for (i=0;i<table.rows.length;i++) {
			if (i != trIndex) {
				table.rows[i].cells[tdIndex].getElementsByTagName("INPUT")[0].checked=false;
				table.rows[i].cells[tdIndex+1].style.color="gray";
				if (rowHasTable(table.rows[i])) {
					disableTree(getTable(table.rows[i]));
				}
			}		
		}
		table.rows[trIndex].cells[tdIndex+1].style.color="black";
		if (rowHasTable(table.rows[trIndex])) {
			enableFirstColumn(getTable(table.rows[trIndex]));
		}
	} 
}

function checkCheckbox(obj) {

	table = obj.parentNode.parentNode.parentNode.parentNode;
	tdIndex = obj.parentNode.cellIndex;
	trIndex = obj.parentNode.parentNode.rowIndex;
	if (rowHasTable(table.rows[trIndex])) {
		if (obj.checked) {
			enableFirstColumn(getTable(table.rows[trIndex]));
		} else {
			disableTree(getTable(table.rows[trIndex]));
		}	
	}
	
	if (obj.checked) {
		table.rows[trIndex].cells[tdIndex+1].style.color="black";
	} else {
		table.rows[trIndex].cells[tdIndex+1].style.color="gray";
	}
}

function rowHasTable(objTr) {
	return objTr.cells.length == 3 || 
		   (objTr.cells[1].childNodes.length > 0 && 
		   	objTr.cells[1].getElementsByTagName("TABLE")[0]);
}

function checkSelection() {
	var inpCol = document.getElementsByTagName("INPUT");
	for (i=0;i<inpCol.length;i++) {
		if (!inpCol[i].disabled && (inpCol[i].type=="radio" || inpCol[i].type=="checkbox")) {
			if (!checkSingleSelection(inpCol[i])) {
				return false;
			}
		}
	}
	return true;
}

function checkSingleSelection(obj) {
	table = obj.parentNode.parentNode.parentNode;
	tdIndex = obj.parentNode.cellIndex;
	trIndex = obj.parentNode.parentNode.rowIndex;
	for (j=0;j<table.rows.length;j++) {
		if (table.rows[j].cells[tdIndex].getElementsByTagName("INPUT")[0].checked) {
			return true;
		}		
	}
	return false;
}


function disableTree(obj) {
	var j;
	for (j=0;j<obj.rows.length;j++) {
		if (obj.rows[j].cells[0].childNodes[0].tagName == "INPUT") {
			obj.rows[j].cells[0].childNodes[0].disabled=true;
			obj.rows[j].cells[1].style.color="gray";
		} else {
			obj.rows[j].cells[0].style.color="gray";
			obj.rows[j].cells[1].style.color="gray";
		} 

		if (rowHasTable(obj.rows[j])) {
			disableTree(getTable(obj.rows[j]));
		}
	}
}


///-------FIN Funciones para el selectPath


var appletToken = "";
var forceConfirm = false;

///Firma digital
function appletConfirmer(result, tkn){
	signedOK = result;
	appletToken = tkn;
	
	$('btnConf').fireEvent('click', new Event({
		type: 'click',
		target: $('btnConf')
	}));
//	$('divDigitalSign').style.display = 'none';
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
			url: 'apia.execution.TaskAction.run?action=unSign&appletToken=' + tkn + TAB_ID_REQUEST,
			onComplete: function(resText, resXml) { 
//				SYS_PANELS.closeLoading();
			}
		}).send();
	} else {
//		SYS_PANELS.closeLoading();
	}
	
//	$('divDigitalSign').style.display = 'none';
	hideAppletModal();
}
///FIN FIRMA DIGITAL

//--modal de docs
function showExecutionDocuments(){
	var modal = ModalController.openWinModal(CONTEXT + "/page/generic/docExecutionModal.jsp?isProcessMonitor="+IN_MONITOR_PROCESS+"&isTaskMonitor="+IN_MONITOR_TASK+"&isTask=true" + TAB_ID_REQUEST , 700, 400, null, null, true,true,false);
	modal.addEvent("close", function() {
	});
}

function forceSubmit() {
	$('frmData').set('action', 'apia.execution.FormAction.run?action=refresh&' + TAB_ID_REQUEST).fireEvent('submit');
}
