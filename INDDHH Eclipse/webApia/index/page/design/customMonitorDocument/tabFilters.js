var currentScrTitMdl = null;
var cmbFilSrcBefore = null;

function initTabFilters(){
	
	//Agregar DocType
	$('addFilDocType').addEvent("click",function(e){
		e.stop();
		
		DOC_TYPE_MODAL_SELECTONLYONE = false;
		showDocTypeModal(processMdlDocTypeReturn);
	});
	//Agregar User
	$('addFilUser').addEvent("click",function(e){
		e.stop();
		
		USERMODAL_EXTERNAL = false;
		USERMODAL_SELECTONLYONE	= false;
		USERMODAL_GLOBAL_AND_ENV = true;
		showUsersModal(processMdlUsersReturn);
	});
	//Agregar SrcTit (tarea)
	$('addFilSrcTit_tsk').addEvent("click",function(e){
		e.stop();
		currentScrTitMdl = DOC_TYPE_TASK;
		
		TASKMODAL_SELECTONLYONE = false;
		showTaskModal(processSrcTitMdlReturn);
	});
	//Agregar SrcTit (proceso)
	$('addFilSrcTit_pro').addEvent("click",function(e){
		e.stop();
		currentScrTitMdl = DOC_TYPE_PROCESS;
		
		PROCESSMODAL_SHOWGLOBAL = false;
		PROCESSMODAL_SELECTONLYONE	= false;
		PROCESSMODAL_IS_SCENARIO	= false;
		PROCESSMODAL_SHOW_ALL = false;
		showProcessModal(processSrcTitMdlReturn);
	});
	//Agregar SrcTit (entidad)
	$('addFilSrcTit_ent').addEvent("click",function(e){
		e.stop();
		currentScrTitMdl = DOC_TYPE_BUS_ENT;
		
		ENTITIESMODAL_SHOWGLOBAL = false;
		ENTITIESMODAL_SELECTONLYONE	= false;
		showEntitiesModal(processSrcTitMdlReturn);
	});
	//Agregar SrcTit (atributo)
	$('addFilSrcTit_att').addEvent("click",function(e){
		e.stop();
		currentScrTitMdl = DOC_TYPE_PRO_INST_ATTRIBUTE;
		
		ATTRIBUTEMODAL_SELECTONLYONE = false;
		showAttributesModal(processSrcTitMdlReturn);
	});
	//Agregar SrcTit (formulario)
	$('addFilSrcTit_frm').addEvent("click",function(e){
		e.stop();
		currentScrTitMdl = DOC_TYPE_FORM;
		
		FORMSMODAL_SHOWGLOBAL = false;
		FORMSMODAL_SELECTONLYONE	= false;
		showFormModal(processSrcTitMdlReturn);
	});
	
	currentScrTitMdl = null;
	cmbFilSrcBefore = $('cmbFilSrc').value;
	
	loadFilters();	    
}

function executeBeforeConfirmTabFilters(){
	$('filtersDocType').value = getFiltersDocType();
	$('filtersSize').value = getFiltersSize();
	$('filtersUser').value = getFiltersUser();
	$('filtersDate').value = getFiltersDate();
	$('filtersSrcTit').value = getFilSrcTit();
	$('filtersRegInst').value = getFilRegInst();
	return true;
}

function loadFilters(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadFilters&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { processXmlFilters(resXml); }
	}).send();
}

function processXmlFilters(resXml){
	var filters = resXml.getElementsByTagName("filters")
	if (filters != null && filters.length > 0 && filters.item(0) != null) {
		var filtersDocType = filters.item(0).getElementsByTagName("filtersDocType");
		var filtersSize = filters.item(0).getElementsByTagName("filtersSize");
		var filtersUser = filters.item(0).getElementsByTagName("filtersUser");
		var filtersDate = filters.item(0).getElementsByTagName("filtersDate");
		var filtersSrcTit = filters.item(0).getElementsByTagName("filtersSrcTit");
		var filtersRegInst = filters.item(0).getElementsByTagName("filtersRegInst");
		
		//Procesar filtros docType
		if (filtersDocType != null && filtersDocType.length > 0 && filtersDocType.item(0) != null) {
			filtersDocType = filtersDocType.item(0).getElementsByTagName("docType");
			for (var i = 0; i < filtersDocType.length; i++){
				var docTypeXml = filtersDocType[i];
				createFilDocType(docTypeXml.getAttribute("id"), docTypeXml.getAttribute("name"));
			}
		}
		
		//Procesar filtros size
		if (filtersSize != null && filtersSize.length > 0 && filtersSize.item(0) != null) {
			filtersSize = filtersSize.item(0).getElementsByTagName("size");
			for (var i = 0; i < filtersSize.length; i++){
				var sizeXml = filtersSize[i];
				createFilSize(sizeXml.getAttribute("from"), sizeXml.getAttribute("to"));
			}
		}
		createFilSize("","");
		
		//Procesar filtros user
		if (filtersUser != null && filtersUser.length > 0 && filtersUser.item(0) != null) {
			filtersUser = filtersUser.item(0).getElementsByTagName("user");
			for (var i = 0; i < filtersUser.length; i++){
				var userXml = filtersUser[i];
				createFilUser(userXml.getAttribute("id"));				
			}
		}
		
		//Procesar filtros date
		if (filtersDate != null && filtersDate.length > 0 && filtersDate.item(0) != null) {
			filtersDate = filtersDate.item(0).getElementsByTagName("date");
			for (var i = 0; i < filtersDate.length; i++){
				var dateXml = filtersDate[i];
				createFilDate(dateXml.getAttribute("from"),dateXml.getAttribute("to"));
			}
		}
		createFilDate("","");
		
		//Procesar filtros srcTit
		if (filtersSrcTit != null && filtersSrcTit.length > 0 && filtersSrcTit.item(0) != null) {
			filtersSrcTit = filtersSrcTit.item(0).getElementsByTagName("srcTit");
			for (var i = 0; i < filtersSrcTit.length; i++){
				var srcTitXml = filtersSrcTit[i];
				createFilSrcTit(srcTitXml.getAttribute("id"), srcTitXml.getAttribute("name"), srcTitXml.getAttribute("type"));				
			}
		}
		
		//Procesar filtros regInst
		if (filtersRegInst != null && filtersRegInst.length > 0 && filtersRegInst.item(0) != null) {
			filtersRegInst = filtersRegInst.item(0).getElementsByTagName("regInst");
			for (var i = 0; i < filtersRegInst.length; i++){
				var regInstXml = filtersRegInst[i];
				createFilRegInst(regInstXml.getAttribute("id"));				
			}
		}
		if (!existEmptyRegInst()) { createFilRegInst(""); }
	}
	
	SYS_PANELS.closeAll();
	
	onChangeCmbFilSrc($('cmbFilSrc'),false);
	reloadFiltersMetadata(true);
}

function processMdlDocTypeReturn(ret){
	var newDocType = false;
	var i = 0;
	while (i < ret.length && !newDocType){
		newDocType = !$('filDocType_'+ret[i].getRowId());
		i++;
	}
	if (newDocType && countDocTypeFilters() > 0){
		showConfirm(MSG_LOST_FILTERS, GNR_TIT_WARNING, 
				function(result){
					if (result){ //confirma
						confirmAddNewFilDocType(ret);
					}
				}
			, 'modalWarning');
	} else if (newDocType){
		confirmAddNewFilDocType(ret);
	}	
}

function confirmAddNewFilDocType(ret){
	ret.each(function(docType){
		createFilDocType(docType.getRowId(),docType.getRowContent()[0]);
	});
	reloadFiltersMetadata(false);
}

function createFilDocType(id,name){
	if (!$('filDocType_'+id)){
		var filDocType = new Element("div",{'id': "filDocType_"+id, html: name, 'class': 'option optionRemove'}).inject($('addFilDocType'),"before");
		filDocType.setAttribute("docTypeId",id);
		filDocType.addEvent("click",function(evt){
			var fil = this;
			if (countDocTypeFilters() == 1 && countFilMetadata() > 0){
				showConfirm(MSG_LOST_FILTERS, GNR_TIT_WARNING, 
						function(result){
							if (result){ //confirma
								if ($('containerDocType').getElements("div.optionRemove").length == 1){
									$('allFilDocType').setStyle("display","");
								} 
								fil.destroy();
								reloadFiltersMetadata(false);								
							}
						}
					, 'modalWarning');
			} else {
				if ($('containerDocType').getElements("div.optionRemove").length == 1){
					$('allFilDocType').setStyle("display","");
				} 
				this.destroy();
				reloadFiltersMetadata(false);				
			} 
		});		
		$('allFilDocType').setStyle("display","none");
	}
}

function getFiltersDocType(){
	var ret = "";
	$('containerDocType').getElements("div.optionRemove").each(function(docType){
		if (ret != "") ret += ";";
		ret += docType.getAttribute("docTypeId");
	});
	return ret;
}

function countDocTypeFilters(){
	return $('containerDocType').getElements("div.optionRemove").length;
}

function createFilSize(from,to){
	var div = new Element("div.option",{'helper':'true',styles:{'height':'18px','cursor':'auto'}}).inject($('containerSize'));
	var inputFrom = new Element("input",{'type':'text','size':'5','value':from}).inject(div);
	new Element("span",{html: '&nbsp;-&nbsp;'}).inject(div);
	var inputTo = new Element("input",{'type':'text','size':'5','value':to}).inject(div);
	inputFrom.otherInput = inputTo;
	inputTo.otherInput = inputFrom;
	[inputFrom,inputTo].each(function(ele){
			ele.addEvent("change",function(e){
				var arr = $('containerSize').getElements("div.option");
				if (this.value == ""){					
					if (this.otherInput.value == "" && this.getParent("div.option") != arr[arr.length-1]){
						this.getParent("div.option").destroy();
					} 
				} else if (this.getParent("div.option") == arr[arr.length-1]){
					createFilSize("","");
				}
			});
			
			ele.addEvent("keypress",function(e){
				if (e.key < '0' || e.key > '9'){
					if (e.key != "delete" && e.key != "tab" && e.key != "backspace" && e.key != "left" && e.key != "right"){
						e.stop();
					}
				} 
			});
		}
	);	
}

function getFiltersSize(){
	var ret = "";
	var all = $('containerSize').getElements("div.option");
	for (var i = 0; i < all.length-1; i++){
		var size = all[i];
		if (ret != "") ret += ";";
		var inputs = size.getElements("input");
		ret += inputs[0].value != "" ? inputs[0].value : "null";
		ret += PRIMARY_SEPARATOR;
		ret += inputs[1].value != "" ? inputs[1].value : "null";
	};
	return ret;
}

function processMdlUsersReturn(ret){
	ret.each(function(user){
		createFilUser(user.getRowId());
	});
}

function createFilUser(usrLogin){
	if (!$('filUser_'+usrLogin)){
		var filSize = new Element("div",{'id': "filUser_"+usrLogin, html: usrLogin, 'class': 'option optionRemove'}).inject($('addFilUser'),"before");
		filSize.setAttribute("usrLogin",usrLogin);
		filSize.addEvent("click",function(evt){ 
			if ($('containerUser').getElements("div.optionRemove").length == 1){
				$('allFilUser').setStyle("display","");
			} 
			this.destroy();
			evt.stopPropagation(); 
		});		
		$('allFilUser').setStyle("display","none");
	}
}

function getFiltersUser(){
	var ret = "";
	$('containerUser').getElements("div.optionRemove").each(function(user){
		if (ret != "") ret += ";";
		ret += user.getAttribute("usrLogin");		
	});
	return ret;
}

function createFilDate(from,to){
	var div = new Element("div.option",{'helper':'true',styles:{'cursor':'auto'}}).inject($('containerDate'));
	var inputFrom = new Element("input.datePicker",{'type':'text','size':'9','maxlength':'10','format':'d/m/Y','value':from}).inject(div);
	new Element("span",{html: '&nbsp;&nbsp-&nbsp;'}).inject(div);
	var inputTo = new Element("input.datePicker",{'type':'text','size':'9','maxlength':'10','format':'d/m/Y','value':to}).inject(div);
	inputFrom.otherInput = inputTo;
	inputTo.otherInput = inputFrom;
	[inputFrom,inputTo].each(function(ele){
			setAdmDatePicker(ele);
			
			ele.addEvent("change",function(e){
				var arr = $('containerDate').getElements("div.option");
				if (this.value == ""){					
					if (this.otherInput.value == "" && this.getParent("div.option") != arr[arr.length-1]){
						this.getParent("div.option").destroy();
					} 
				} else if (this.getParent("div.option") == arr[arr.length-1]){
					createFilDate("","");
				}
			});
		}
	);	
}

function getFiltersDate(){
	var ret = "";
	var all = $('containerDate').getElements("div.option");
	for (var i = 0; i < all.length-1; i++){
		var date = all[i];
		if (ret != "") ret += ";";
		var inputs = date.getElements("input");
		ret += inputs[0].value != "" ? inputs[0].value : "null";
		ret += PRIMARY_SEPARATOR;
		ret += inputs[2].value != "" ? inputs[2].value : "null";
	};
	return ret;
}

function createFilRegInst(regInst){
	var div = new Element("div.option",{'helper':'true',styles:{'height':'18px','cursor':'auto'}}).inject($('containerRegInst'));
	var input = new Element("input",{'type':'text','size':'12','value':regInst}).inject(div);
	input.addEvent("change",function(e){
		var arr = $('containerRegInst').getElements("div.option");
		if (this.value == ""){					
			if (this.getParent("div.option") != arr[arr.length-1]){
				this.getParent("div.option").destroy();
			} 
		} else if (this.getParent("div.option") == arr[arr.length-1]){
			createFilRegInst("","");
		}
	});
	$('containerRegInst').setStyle("display","");
}

function getFilRegInst(){
	var ret = "";
	var all = $('containerRegInst').getElements("div.option");
	for (var i = 0; i < all.length-1; i++){
		var regInst = all[i];
		if (ret != "") ret += ";";
		ret += regInst.getElement("input").value;		
	};
	return ret;
}

function existEmptyRegInst(){
	var arr = $('containerRegInst').getElements("div.option");
	var regInst = arr[arr.length-1];
	return arr.length > 0 && regInst.getElement("input").value == "";
}

function onChangeCmbFilSrc(cmbFilSrc,showMsg){
	if (showMsg && cmbFilSrcBefore != "" && 
			!(cmbFilSrcBefore == DOC_TYPE_PROCESS && cmbFilSrc.value == DOC_TYPE_PROCESS_INST) && 
				!(cmbFilSrcBefore == DOC_TYPE_BUS_ENT && cmbFilSrc.value == DOC_TYPE_BUS_ENT_INST) && 
					!(cmbFilSrcBefore == DOC_TYPE_BUS_ENT && cmbFilSrc.value == DOC_TYPE_BUS_ENT_INST_ATTRIBUTE) && 
						!(cmbFilSrcBefore == DOC_TYPE_PROCESS && cmbFilSrc.value == DOC_TYPE_PRO_INST_ATTRIBUTE)){
		
		showConfirm(MSG_LOST_FILTERS, GNR_TIT_WARNING, 
				function(ret){
					if (ret){ //confirma
						confirmCmbFilSrcChange();
					} else { //cancela
						cmbFilSrc.value = cmbFilSrcBefore;
					}
				}
			, 'modalWarning');
		
	} else {
		confirmCmbFilSrcChange();
	}   
}

function confirmCmbFilSrcChange(){
	var value = $('cmbFilSrc').value;
	cmbFilSrcBefore = value;
	if (value == ""){		
		$('containerSrcTit_tsk').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_tsk').setStyle("display","none");
		
		$('containerSrcTit_pro').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_pro').setStyle("display","none");
		
		$('containerSrcTit_ent').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_ent').setStyle("display","none");
		
		$('containerSrcTit_att').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_att').setStyle("display","none");
		
		$('containerSrcTit_frm').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_frm').setStyle("display","none");
		
		$('containerRegInst').getElements("div.option").each(function(item){ item.destroy(); });
		createFilRegInst("");
		$('containerRegInst').setStyle("display","none");
		
		$('flagFilSrc').disabled = false;
		$('flagFilSrc').checked = true;
		
	} else if (value == DOC_TYPE_TASK) {
		$('containerSrcTit_tsk').setStyle("display","");
		
		$('containerSrcTit_pro').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_pro').setStyle("display","none");
		
		$('containerSrcTit_ent').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_ent').setStyle("display","none");
		
		$('containerSrcTit_att').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_att').setStyle("display","none");
		
		$('containerSrcTit_frm').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_frm').setStyle("display","none");	
		
		$('containerRegInst').getElements("div.option").each(function(item){ item.destroy(); });
		createFilRegInst("");
		$('containerRegInst').setStyle("display","none");
		
		$('divSrcTit').setStyle("display","inline-block");
		
		$('flagFilSrc').checked = false;
		$('flagFilSrc').disabled = true;
		
	} else if (value == DOC_TYPE_PROCESS){
		$('containerSrcTit_tsk').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_tsk').setStyle("display","none");
		
		$('containerSrcTit_pro').setStyle("display","");
		
		$('containerSrcTit_ent').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_ent').setStyle("display","none");
		
		$('containerSrcTit_att').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_att').setStyle("display","none");
		
		$('containerSrcTit_frm').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_frm').setStyle("display","none");
		
		$('containerRegInst').getElements("div.option").each(function(item){ item.destroy(); });
		createFilRegInst("");
		$('containerRegInst').setStyle("display","none");
				
		$('divSrcTit').setStyle("display","inline-block");
		
		$('flagFilSrc').checked = false;
		$('flagFilSrc').disabled = true;
		
	} else if (value == DOC_TYPE_PROCESS_INST){
		$('containerSrcTit_tsk').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_tsk').setStyle("display","none");
		
		$('containerSrcTit_pro').setStyle("display","");
		
		$('containerSrcTit_ent').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_ent').setStyle("display","none");
		
		$('containerSrcTit_att').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_att').setStyle("display","none");
		
		$('containerSrcTit_frm').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_frm').setStyle("display","none");
		
		if (!existEmptyRegInst()) { createFilRegInst(""); }
		$('containerRegInst').setStyle("display","");
		
		$('divSrcTit').setStyle("display","inline-block");
		
		$('flagFilSrc').checked = false;
		$('flagFilSrc').disabled = true;
		
	} else if (value == DOC_TYPE_BUS_ENT){
		$('containerSrcTit_tsk').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_tsk').setStyle("display","none");
		
		$('containerSrcTit_pro').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_pro').setStyle("display","none");
		
		$('containerSrcTit_ent').setStyle("display","");
		
		$('containerSrcTit_att').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_att').setStyle("display","none");
		
		$('containerSrcTit_frm').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_frm').setStyle("display","none");
		
		$('containerRegInst').getElements("div.option").each(function(item){ item.destroy(); });
		createFilRegInst("");
		$('containerRegInst').setStyle("display","none");
				
		$('divSrcTit').setStyle("display","inline-block");
		
		$('flagFilSrc').checked = false;
		$('flagFilSrc').disabled = true;
		
	} else if (value == DOC_TYPE_BUS_ENT_INST){
		$('containerSrcTit_tsk').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_tsk').setStyle("display","none");
		
		$('containerSrcTit_pro').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_pro').setStyle("display","none");
		
		$('containerSrcTit_ent').setStyle("display","");
		
		$('containerSrcTit_att').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_att').setStyle("display","none");
		
		$('containerSrcTit_frm').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_frm').setStyle("display","none");
		
		if (!existEmptyRegInst()) { createFilRegInst(""); }
		$('containerRegInst').setStyle("display","");
		
		$('divSrcTit').setStyle("display","inline-block");
		
		$('flagFilSrc').checked = false;
		$('flagFilSrc').disabled = true;
		
	} else if (value == DOC_TYPE_FORM){
		$('containerSrcTit_tsk').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_tsk').setStyle("display","none");
		
		$('containerSrcTit_pro').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_pro').setStyle("display","none");
		
		$('containerSrcTit_ent').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_ent').setStyle("display","none");
		
		$('containerSrcTit_att').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_att').setStyle("display","none");
		
		$('containerSrcTit_frm').setStyle("display","");
		
		$('containerRegInst').getElements("div.option").each(function(item){ item.destroy(); });
		createFilRegInst("");
		$('containerRegInst').setStyle("display","none");
				
		$('divSrcTit').setStyle("display","inline-block");
		
		$('flagFilSrc').checked = false;
		$('flagFilSrc').disabled = true;
		
	} else if (value == DOC_TYPE_BUS_ENT_INST_ATTRIBUTE){
		$('containerSrcTit_tsk').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_tsk').setStyle("display","none");
		
		$('containerSrcTit_pro').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_pro').setStyle("display","none");
		
		$('containerSrcTit_ent').setStyle("display","");
		
		$('containerSrcTit_att').setStyle("display","");
		
		$('containerSrcTit_frm').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_frm').setStyle("display","none");
		
		//$('containerRegInst').getElements("div.option").each(function(item){ item.destroy(); });
		if (!existEmptyRegInst()) { createFilRegInst(""); }
		$('containerRegInst').setStyle("display","");
				
		$('divSrcTit').setStyle("display","inline-block");
		
		$('flagFilSrc').checked = false;
		$('flagFilSrc').disabled = true;
		
	} else if (value == DOC_TYPE_ENVIRONMENT){
		$('containerSrcTit_tsk').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_tsk').setStyle("display","none");
		
		$('containerSrcTit_pro').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_pro').setStyle("display","none");
		
		$('containerSrcTit_ent').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_ent').setStyle("display","none");
		
		$('containerSrcTit_att').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_att').setStyle("display","none");
		
		$('containerSrcTit_frm').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_frm').setStyle("display","none");
		
		$('containerRegInst').getElements("div.option").each(function(item){ item.destroy(); });
		createFilRegInst("");
		$('containerRegInst').setStyle("display","none");
				
		$('divSrcTit').setStyle("display","inline-block");
		
		$('flagFilSrc').checked = false;
		$('flagFilSrc').disabled = true;
		
	} else if (value == DOC_TYPE_PRO_INST_ATTRIBUTE){
		$('containerSrcTit_tsk').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_tsk').setStyle("display","none");
		
		$('containerSrcTit_pro').setStyle("display","");
		
		$('containerSrcTit_ent').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_ent').setStyle("display","none");
		
		$('containerSrcTit_att').setStyle("display","");
		
		$('containerSrcTit_frm').getElements("div.optionRemove").each(function(item){ item.fireEvent("click"); });
		$('containerSrcTit_frm').setStyle("display","none");
		
		//$('containerRegInst').getElements("div.option").each(function(item){ item.destroy(); });
		if (!existEmptyRegInst()) { createFilRegInst(""); }
		$('containerRegInst').setStyle("display","");
				
		$('divSrcTit').setStyle("display","inline-block");
		
		$('flagFilSrc').checked = false;
		$('flagFilSrc').disabled = true;
	}
}

function processSrcTitMdlReturn(ret){
	ret.each(function(item){
		var id = item.getRowId();
		var name = null;
		
		if (currentScrTitMdl == DOC_TYPE_TASK){
			name = item.getRowContent()[0];
		} else if (currentScrTitMdl == DOC_TYPE_PROCESS){			
			name = item.getRowContent()[0];
		} else if (currentScrTitMdl == DOC_TYPE_BUS_ENT){			
			name = item.getRowContent()[0];
		} else if (currentScrTitMdl == DOC_TYPE_FORM){			
			name = item.getRowContent()[0];
		} else if (currentScrTitMdl == DOC_TYPE_PRO_INST_ATTRIBUTE){			
			name = item.getRowContent()[0];
		}   
		
		createFilSrcTit(id,name,currentScrTitMdl);
	});
}

function createFilSrcTit(id,name,type){
	var prefix = null;
	
	if (type == DOC_TYPE_TASK){
		prefix = "tsk";
	} else if (type == DOC_TYPE_PROCESS){
		prefix = "pro";		
	} else if (type == DOC_TYPE_BUS_ENT){
		prefix = "ent";		
	} else if (type == DOC_TYPE_FORM){
		prefix = "frm";		
	} else if (type == DOC_TYPE_PRO_INST_ATTRIBUTE){
		prefix = "att";		
	}    
	
	if (prefix != null){
		var itemId = 'filSrcTit_tsk_'+id;
		
		if (!$(itemId)){ //no existia, se crea			
			var objAdd = $('addFilSrcTit_'+prefix);
			var container = $('containerSrcTit_'+prefix);
			var allFil = $('allFilSrcTit_'+prefix);
				
			var filSrcTit = new Element("div",{'id': itemId, html: name, 'class': 'option optionRemove'}).inject(objAdd,"before");
			filSrcTit.setAttribute("srcTitId",id);
			filSrcTit.setAttribute("srcTitType",prefix);
			filSrcTit.addEvent("click",function(evt){ 
				if (container.getElements("div.optionRemove").length == 1){
					allFil.setStyle("display","");
				} 
				this.destroy();				 
			});		
			allFil.setStyle("display","none");
		}
	}
}

function getFilSrcTit(){
	var ret = ""; //id·type;
	var containers = new Array();
	
	var type = $('cmbFilSrc').value;
	if (type == DOC_TYPE_TASK){
		containers.push($('containerSrcTit_tsk'));
	} else if (type == DOC_TYPE_PROCESS){
		containers.push($('containerSrcTit_pro'));
	} else if (type == DOC_TYPE_PROCESS_INST){
		containers.push($('containerSrcTit_pro'));
	} else if (type == DOC_TYPE_BUS_ENT){
		containers.push($('containerSrcTit_ent'));
	} else if (type == DOC_TYPE_BUS_ENT_INST){
		containers.push($('containerSrcTit_ent'));
	} else if (type == DOC_TYPE_FORM){
		containers.push($('containerSrcTit_frm'));
	} else if (type == DOC_TYPE_BUS_ENT_INST_ATTRIBUTE){
		containers.push($('containerSrcTit_ent'));
		containers.push($('containerSrcTit_att'));
	} else if (type == DOC_TYPE_PRO_INST_ATTRIBUTE){
		containers.push($('containerSrcTit_pro'));
		containers.push($('containerSrcTit_att'));
	}
	
	containers.each(function(container){
		container.getElements("div.optionRemove").each(function(item){
			if (ret != "") ret += ";";
			ret += item.getAttribute("srcTitId");
			ret += PRIMARY_SEPARATOR;
			ret += item.getAttribute("srcTitType");
		});		
	});
	
	return ret;
}

