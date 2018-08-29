var proIdSelected;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
		
	$('addProcess').addEvent("click", function(e) {
		e.stop();
		STATUSMODAL_SHOWGLOBAL = true;		
		PROCESSMODAL_IS_SCENARIO =true;
		PROCESSMODAL_SHOW_ALL = true;
		showProcessModal(processProcessModalReturn);
	});
	
	var btnViewCal = $('btnViewCal');
	if (btnViewCal){
		btnViewCal.addEvent("click",function(e){
			e.stop();
			var calId = $('selCal').value; 
			if (calId == "" || calId == null){
				showMessage(NO_SEL_CAL, GNR_TIT_WARNING, 'modalWarning');    		
			} else {
				showCalendarViewModal(calId);
			}
		});
	}
	//['btnViewCal'].each(setTooltip);
	
	['txtSceHorIni','txtSceHorEnd','txtHistFrecHorIni','txtHistFrecHorEnd'].each(setHourField);
	
	initAdminActionsEdition(validateBeforeConfirm);
	
	initPermissions();
	$('projectPermissions').setStyle("display","none");
	
	initAdminFav();
	
	loadComboProcess();
	
	loadProcess();
	
	initProcMdlPage();
	
	loadPools();
	
	initCalendarViewMdlPage();
	
	changeEndType($('endTypeSelected').value);
	clickUseHist();
}

function validateBeforeConfirm(){
	if (!$('frmData').formChecker.isFormValid()) return ;
	return verifyPermissions() && verifyOtherReqObjects();
}

function checkValidations(obj,formName){
	
	var validations = $(formName!=null?formName:'frmData').formChecker.validations;
	if (obj!=null){
		for (var i=0;i<validations.length;i++){
			if (obj== validations[i]){
				return false;
			}
		}
		return true;
	}
	return false;
}

function registerValidation(obj,className,formName){
	var ok = checkValidations(obj,formName);
	if (ok){
		if (!className){
			obj.addClass("validate['required']");
		}else if (!obj.hasClass(className)){
			obj.addClass(className);
		}		
		$(formName!=null?formName:'frmData').formChecker.register(obj);
	}
}

function disposeValidation(obj,formName){
	if (obj!=null){
		$(formName!=null?formName:'frmData').formChecker.dispose(obj);
	}
}

function populateCombo(firstChild){
	var id = firstChild.getAttribute("id");
	
	var aux = $(id);
	aux.options.length=0;			
	
	var selectedValue = firstChild.getAttribute("value");
	
	var options = firstChild.getElementsByTagName("option");
	var arrayOptions = new Array();
	
	var optionDOM = new Element('option');

	for (var m = 0; m < options.length; m++) {
		var option = options.item(m);
		
		var optionValue = option.getAttribute("value");
		var optionText = (option.firstChild != null)?option.firstChild.nodeValue:""; 
		
		optionDOM = new Element('option');
		optionDOM.setProperty('value',optionValue);
		optionDOM.appendText(optionText);
		if (selectedValue!="" && optionValue==selectedValue){
			optionDOM.setProperty('selected',"selected");
		}	
		
		optionDOM.inject(aux);							
	}
}

function processTd(td){
	
	var cells = td.getElementsByTagName("cell");
	var i=0;
	var arrayCell = new Array();
	var arrayTd = new Array();
	while (i<cells.length){
		var cc = cells[i];		
		var ccType = cc.getAttribute("type");	
		
		var display = cc.getAttribute("display");
		var isRequired = toBoolean(cc.getAttribute("required"));
		var validation = cc.getAttribute("validation");
		var isChecked = toBoolean(cc.getAttribute("checked"));
		var isDisabled = false;//toBoolean(cc.getAttribute("disabled"));
		var firstChild = cc.firstChild;		
		var isReadOnly = false;//toBoolean(cc.getAttribute("readonly"));
		
		if (ccType!="text"&&ccType!="colorpicker"){
			var ccName = firstChild.getAttribute("name");
			var ccId = firstChild.getAttribute("id");
		}
		
		if (ccType =="input"){
			var aux = {'type':'text',name:ccName,id:ccId,'required':isRequired,value:firstChild.getAttribute("value"),'display':display,'validation':validation,hasDatePicker:cc.getAttribute("hasDatePicker"),disabled:isDisabled,bgColor:cc.getAttribute("bgColor"),isReadOnly:isReadOnly,'onkeypress':firstChild.getAttribute("onkeypress"),'onchange':firstChild.getAttribute("onchange")};
		}else if (ccType =="checkbox"){
			var aux = {'type':'checkbox',name:ccName,id:ccId,'required':isRequired,'checked':isChecked,'display':display,disabled:isDisabled,'onclick':firstChild.getAttribute("onclick")};
		}else if (ccType =="hidden"){
			var aux = {'type':'hidden',name:ccName,id:ccId,'required':isRequired,value:firstChild.getAttribute("value"),'display':display,disabled:isDisabled};
		}else if (ccType =="combo"){
			
			var selectedValue = firstChild.getAttribute("value");
			
			var options = firstChild.getElementsByTagName("option");
			var arrayOptions = new Array();
			for (var m = 0; m < options.length; m++) {
				var option = options.item(m);
				
				var optionValue = option.getAttribute("value");
				var optionText = (option.firstChild != null)?option.firstChild.nodeValue:""; 
				
				var selected = false;
				if (selectedValue!="" && selectedValue == optionValue || selectedValue=="" && m==0){
					selected = true;
				}
				
				arrayOptions.push({'value':optionValue,'text':optionText,'selected':selected,validFor:option.getAttribute("validFor")});							
			}
			var aux = {'type':'combo',name:ccName,id:ccId,'required':isRequired,'options':arrayOptions,'display':display,disabled:isDisabled,'width':cc.getAttribute("width"),'onchange':firstChild.getAttribute("onChange")};
		}else if (ccType =="text"){
			var aux = {'type':'span',html:firstChild.nodeValue};
		}else if (ccType=="colorpicker"){
			var aux = {'type':'colorpicker'};
		}
		arrayCell.push(aux);
		i++;
	}
	lCount = i;
	return arrayCell;
}

function severalProperties(domElement,auxRow){
	var auxValidation = new Array();
	if (auxRow.width!=null && auxRow.width!=''){
		domElement.style.width=auxRow.width;
	}
	if (auxRow.display!=null && auxRow.display!=""){
		domElement.style.display=auxRow.display;
		//domElement.setAttribute('style','display:'+auxRow.display);
	}
//	if (auxRow.disabled!=null && auxRow.disabled){
//		domElement.setAttribute('disabled',"true");
//	}
	if (auxRow.className!=null){
		domElement.addClass(auxRow.className);
	}
	if (auxRow.validation!=null){
		auxValidation.push(auxRow.validation);
	}
	if (auxRow.required){
		new Element('span',{html:"&nbsp;*"}).inject(domElement,"after");
		auxValidation.push("required");
	}						
	if (auxValidation.length!=0){
		var strV = ""; 
		for (var h=0;h<auxValidation.length;h++){
			strV+="'"+auxValidation[h]+"',";
		}
		strV = strV.substring(0,strV.lastIndexOf(","));							
		registerValidation(domElement,"validate["+strV+"]");
	}
	if (auxRow.format!=null){
		domElement.setAttribute("format",auxRow.format);
	} 
	if (auxRow.hasDatePicker!=null && auxRow.hasDatePicker){
		if (auxRow.value!=null&&auxRow.value=="__/__/____"){
			domElement.setAttribute("value","");
		}
		setAdmDatePicker(domElement);
	}
	if (auxRow.className!=null){
		domElement.addClass(auxRow.className);
	}
	
	if (auxRow.bgColor!=null){
		domElement.style.backgroundColor=auxRow.bgColor;
	}
	
	if (auxRow.isReadOnly){
		domElement.readOnly=auxRow.isReadOnly;
	}
	
	if (auxRow.onclick!=null){
		domElement.setAttribute("onclick",auxRow.onclick);
	}
	if (auxRow.onkeypress!=null){
		domElement.setAttribute("onkeypress",auxRow.onkeypress);
	}
	if (auxRow.onchange!=null){
		domElement.setAttribute("onchange",auxRow.onchange);
	}
}

function loadComboProcess(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadComboProcess&isAjax=true' + TAB_ID_REQUEST,	
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); SYS_PANELS.closeAll(); }
	}).send();
}

function processLoadComboProcess(){
	var resXml = getLastFunctionAjaxCall(); 
	var comboDOM = resXml.getElementsByTagName("element");
	if (comboDOM!=null && comboDOM.length!=0){
		for (var i=0;i<comboDOM.length;i++){
			populateCombo(comboDOM[i]);
		}
	}	
}

function changeEndType(val){
	val = val==-1?0:val;
	if (val == SIMULATION_END_BY_TIME){
		$("endTypeSelected").value = SIMULATION_END_BY_TIME;
		$("txtSceDatEnd").disabled=false;
		$("txtSceDatEnd").getNext().disabled=false;
		$("txtSceDatEnd").removeClass("readonly");
		if ($("txtSceDatEnd").retrieve('datepicker'))
			$("txtSceDatEnd").retrieve('datepicker').options.isReadonly=false;
		$("txtSceDatEnd").getNext().removeClass("readonly");
		$("txtSceDatEnd").getNext().setStyle('background-color','white');
		registerValidation($("txtSceDatEnd"));
		$("txtSceHorEnd").disabled=false;
		$("txtSceHorEnd").setStyle('background-color','white');
		$("txtSceHorEnd").removeClass("readonly");
		registerValidation($("txtSceHorEnd"),"validate['required','~validateHours']");
		$("sceEndDays").disabled=true;
		$("sceEndDays").value = "";
		disposeValidation($("sceEndDays"));
		$("sceEndTrans").disabled=true;
		$("sceEndTrans").value = "";
		disposeValidation($("sceEndTrans"));
		$("sceEndProTrans").disabled=true;
		$("sceEndProTrans").value = "";
		disposeValidation($("sceEndProTrans"));
		$("selEndProcess").disabled=true;
		$("selEndProcess").selectedIndex=0;
		
		setRequiredFinalize($('divEndByTime'));
	}else if (val == SIMULATION_END_BY_DATE){
		$("endTypeSelected").value = SIMULATION_END_BY_DATE;
		$("txtSceDatEnd").value = "";
		$("txtSceDatEnd").getNext().value="";
		$("txtSceDatEnd").disabled=true;
		$("txtSceDatEnd").getNext().disabled=true;
		$("txtSceDatEnd").addClass("readonly");
		$("txtSceDatEnd").getNext().addClass("readonly");
		disposeValidation($("txtSceDatEnd"));
		$("txtSceHorEnd").disabled=true;
		disposeValidation($("txtSceHorEnd"));
		$("txtSceDatEnd").value = "";
		$("txtSceHorEnd").value = "";
		$("txtSceHorEnd").addClass('readonly');
		$("sceEndDays").disabled=false;
		registerValidation($("sceEndDays"));
		$("sceEndTrans").disabled=true;
		disposeValidation($("sceEndTrans"));
		$("sceEndTrans").value = "";
		$("sceEndProTrans").disabled=true;
		$("sceEndProTrans").value = "";
		disposeValidation($("sceEndProTrans"));
		$("selEndProcess").disabled=true;
		$("selEndProcess").selectedIndex=0;		
		
		setRequiredFinalize($('divEndByDate'));
	}else if (val == SIMULATION_END_BY_AMOUNT_GLOBAL){
		$("endTypeSelected").value = SIMULATION_END_BY_AMOUNT_GLOBAL;
		$("txtSceDatEnd").value = "";
		$("txtSceDatEnd").getNext().value="";
		$("txtSceDatEnd").disabled=true;
		$("txtSceDatEnd").getNext().disabled=true;
		$("txtSceDatEnd").addClass("readonly");
		$("txtSceDatEnd").getNext().addClass("readonly");
		disposeValidation($("txtSceDatEnd"));
		$("txtSceHorEnd").disabled=true;
		$("txtSceHorEnd").addClass('readonly');
		disposeValidation($("txtSceHorEnd"));
		$("txtSceHorEnd").value = "";
		$("sceEndDays").disabled=true;
		$("sceEndDays").value = "";
		disposeValidation($("sceEndDays"));
		$("sceEndTrans").disabled=false;
		registerValidation($("sceEndTrans"));
		$("sceEndProTrans").disabled=true;
		$("sceEndProTrans").value = "";
		disposeValidation($("sceEndProTrans"));
		$("selEndProcess").disabled=true;
		$("selEndProcess").selectedIndex=0;	
		
		setRequiredFinalize($('divEndByAmountGlobal'));
	}else if (val == SIMULATION_END_BY_AMOUNT_PROCESS){
		$("endTypeSelected").value = SIMULATION_END_BY_AMOUNT_PROCESS;
		$("txtSceDatEnd").value = "";
		$("txtSceDatEnd").getNext().value="";
		$("txtSceDatEnd").disabled=true;
		$("txtSceDatEnd").getNext().disabled=true;
		$("txtSceDatEnd").addClass("readonly");
		$("txtSceDatEnd").getNext().addClass("readonly");
		disposeValidation($("txtSceDatEnd"));
		$("txtSceHorEnd").disabled=true;
		$("txtSceHorEnd").addClass('readonly');
		disposeValidation($("txtSceHorEnd"));
		$("txtSceHorEnd").value = "";
		$("sceEndDays").disabled=true;
		$("sceEndDays").value = "";
		disposeValidation($("sceEndDays"));
		$("sceEndTrans").disabled=true;
		$("sceEndTrans").value = "";
		disposeValidation($("sceEndTrans"));
		$("sceEndProTrans").disabled=false;
		registerValidation($("sceEndProTrans"));
		$("selEndProcess").disabled=false;
		
		setRequiredFinalize($('divEndByAmountProcess'));
	}
	
	["selEndProcess", "sceEndProTrans", "sceEndTrans", "sceEndDays", "txtSceHorEnd"].each(function(ele){
		$(ele).fireEvent('change');
	});
	$("txtSceDatEnd").getNext().fireEvent('selectDate');
}

function clickUseHist(){
	if ($("useHistChk").checked){
		$("lblSampFrecuency").disabled=false;
		$("lblSampFrecuency").removeClass('readonly');
		registerValidation($("lblSampFrecuency"));
		$("txtHistFrecDatIni").disabled=false;
		if ($("txtHistFrecDatIni").retrieve('datepicker'))
			$("txtHistFrecDatIni").retrieve('datepicker').options.isReadonly=false;
		$("txtHistFrecDatIni").getNext().setStyle('background-color','white');
		$("txtHistFrecDatIni").getNext().removeClass('readonly');
		registerValidation($("txtHistFrecDatIni"));
		$("txtHistFrecDatIni").getNext().disabled=false;
		$("txtHistFrecHorIni").disabled=false;
		$("txtHistFrecHorIni").removeClass('readonly');
		registerValidation($("txtHistFrecHorIni"));
		$("txtHistFrecDatEnd").disabled=false;
		$("txtHistFrecDatEnd").getNext().disabled=false;
		if ($("txtHistFrecDatEnd").retrieve('datepicker'))		
			$("txtHistFrecDatEnd").retrieve('datepicker').options.isReadonly=false;
		$("txtHistFrecDatEnd").getNext().setStyle('background-color','white');
		$("txtHistFrecDatEnd").getNext().removeClass('readonly');
		registerValidation($("txtHistFrecDatEnd"));
		$("txtHistFrecHorEnd").disabled=false;
		$("txtHistFrecHorEnd").removeClass('readonly');
		registerValidation($("txtHistFrecHorEnd"));
	}else{
		$("lblSampFrecuency").disabled=true;
		$("lblSampFrecuency").addClass('readonly');
		disposeValidation($("lblSampFrecuency"));
		$("lblSampFrecuency").value="";
		$("txtHistFrecDatIni").disabled=true;
		$("txtHistFrecDatIni").getNext().disabled=true;
		$("txtHistFrecDatIni").addClass('readonly');
		$("txtHistFrecDatIni").getNext().addClass('readonly');
		disposeValidation($("txtHistFrecDatIni"));
		$("txtHistFrecDatIni").getNext().value="";
		$("txtHistFrecDatIni").value="";
		$("txtHistFrecHorIni").disabled=true;
		$("txtHistFrecHorIni").addClass('readonly');
		disposeValidation($("txtHistFrecHorIni"));
		$("txtHistFrecHorIni").value="";
		$("txtHistFrecDatEnd").disabled=true;
		$("txtHistFrecDatEnd").getNext().disabled=true;
		$("txtHistFrecDatEnd").addClass('readonly');
		$("txtHistFrecDatEnd").getNext().addClass('readonly');
		disposeValidation($("txtHistFrecDatEnd"));
		$("txtHistFrecDatEnd").getNext().value="";
		$("txtHistFrecDatEnd").value="";
		$("txtHistFrecHorEnd").disabled=true;
		$("txtHistFrecHorEnd").addClass('readonly');
		disposeValidation($("txtHistFrecHorEnd"));
		$("txtHistFrecHorEnd").value="";
		
		["lblSampFrecuency", "txtHistFrecHorIni", "txtHistFrecHorEnd"].each(function(ele){
			$(ele).fireEvent('change');
		});
		["txtHistFrecDatIni", "txtHistFrecDatEnd"].each(function(ele){
			$(ele).getNext().fireEvent('selectDate');
		})
	}
}

function setRequiredFinalize(obj){
	$('divEndByTime').removeClass("required");
	$('divEndByDate').removeClass("required");
	$('divEndByAmountGlobal').removeClass("required");
	$('divEndByAmountProcess').removeClass("required");
	
	obj.addClass("required");
}

function loadProcess(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=loadProcess&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { 
			processXMLProcess(resXml); sp.hide(true); 
			
			initAdminModalHandlerOnChangeHighlight($('processContainer'));
		}
	}).send();
}

function processXMLProcess(ajaxCallXml){
	if (ajaxCallXml != null) {
		
		var envs = ajaxCallXml.getElementsByTagName("processes");
		if (envs != null && envs.length > 0 && envs.item(0) != null) {
			envs = envs.item(0).getElementsByTagName("process");
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				var text	= env.getAttribute("text");
				var father	= env.getAttribute("father");					
				var id = env.getAttribute("id");				
				addActionElementProcess($('processContainer'),text,id,father,"true",true);
			}
		}
	}
}

function processProcessModalReturn(aux){
	if (aux != null) {
		rets = new Array();
		for (var j = 0; j < aux.length; j++) {
			arr = new Array();
			arr[0] = aux[j].getRowId();
			arr[1] = aux[j].getRowContent()[0];	
			arr[2] = aux[j].getAttribute("proVerId");
			arr[3] = aux[j].getAttribute("proFathers");
			rets[rets.length] = arr; 
		}
		
		for (var j = 0; j < rets.length; j++) {
			var ret = rets[j];
			var addRet = true;
			var proId = ret[0];
			var fathers = ret[3];
			var text = ret[1];
			
			addAjaxProcess(proId);
			//Obtenemos todos los subprocesos del proceso
			var subPro = getSubProcesses(proId);
			var i = 0;
			if (subPro != null){
				while (i < subPro.length){
					var h=0;
					var found=false;
					while (h < rets.length && !found){
						if (subPro[i][0] == rets[h][0]){
							found = true;
						}
						h++;
					}
					if (!found){
						rets[rets.length] = subPro[i];
					}
					i++;
				}
			}
			
			addActionElementProcess($('processContainer'),text,proId,fathers,"true",true);	
			
		}
	}	
	refreshPools();
	reLoadComboProcess();
}

function StringtoXML(text){
    if (window.ActiveXObject){
      var doc=new ActiveXObject('Microsoft.XMLDOM');
      doc.async='false';
      doc.loadXML(text);
    } else {
      var parser=new DOMParser();
      var doc=parser.parseFromString(text,'text/xml');
    }
    return doc;
}

function getSubProcesses(proId){
	
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', CONTEXT + URL_REQUEST_AJAX +'?action=getSubprocess' + TAB_ID_REQUEST, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "&proId="+proId;
	http_request.send(str);
	
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
			 var resp = http_request.responseText; //formato:"proId, proName, fathId1, fathId2,..,fathIdN;proId, proName, fathId1,.."
			 var xml = StringtoXML(resp);
			 var resp = xml.getElementsByTagName("data").item(0).textContent;
		     if(resp != "NOK"){		    	 
		         if (resp != null && resp!="null" && resp!= ""){
					var arrResp = new Array();
					var i = 0;
					while (resp.indexOf(";")>0){
						var subPro = new Array();
						subPro[0] = resp.substring(0,resp.indexOf(",")); //proId
						resp = resp.substring(resp.indexOf(",")+1, resp.length);
						subPro[1] = resp.substring(0,resp.indexOf(",")); //proName
						resp = resp.substring(resp.indexOf(",")+1, resp.length);
						subPro[3] = resp.substring(0,resp.indexOf(";")); //proFathers (en posicion 3 pq en la 2 esta la version)
						arrResp[i] = subPro;
						resp = resp.substring(resp.indexOf(";")+1, resp.length);
						i++;
					}
					var subPro = new Array();
					subPro[0] = resp.substring(0,resp.indexOf(",")); //proId
					resp = resp.substring(resp.indexOf(",")+1, resp.length);
					subPro[1] = resp.substring(0,resp.indexOf(",")); //proName
					resp = resp.substring(resp.indexOf(",")+1, resp.length);
					subPro[3] = resp; //proFathers (en posicion 3 pq en la 2 esta la version)
					arrResp[i] = subPro;
					
					return arrResp;	
			     }else {
			     	return null;
			     }
		     }else{
				showMessage(LBL_GENERIC_ERROR);
	         }
    	} else {
    		showMessage(LBL_CANT_REACH_SERVER);            
        }
	}
}

function getXMLHttpRequest(){
	var http_request = null;
	if (window.XMLHttpRequest) {
		// browser has native support for XMLHttpRequest object
		http_request = new XMLHttpRequest();
	} else if (window.ActiveXObject) {
	// 	try XMLHTTP ActiveX (Internet Explorer) version
		try {
			http_request = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e1) {
			try {
				http_request = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e2) {
				http_request = null;
			}
		}
	}
	return http_request;
} 

var proToDelete = "";
function addActionElementProcess(container, text, id,father,helper,addRemove){
	var repeated = false;
	//primero verificar que no exista
	container.getElements("DIV.option").each(function(item,index){
		if(item.get("id") == id) {
			repeated = true;
			//actualizo el nombre si es necesario
			var t = item.firstChild.textContent;
			if (t!=text){
				item.firstChild.textContent=text;
			}
		}
	});
	if(repeated){
		return;
	}
	
	var elemDiv = new Element("div", {'id': id,'class': 'option optionMiddle'});
	var span = new Element("span", {html: text});
	span.inject(elemDiv);

	new Element('div.optionRemove').addEvent('click', function(e){
		proToDelete = "";

		SYS_PANELS.newPanel();
		var panel = SYS_PANELS.getActive();
		panel.addClass("modalWarning");
		panel.content.innerHTML = CONFIRM_ELEMENT_DELETE;
		panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); doConfirm(" + id + ");\">"+ LBL_CONFIRM + "</div>";
		SYS_PANELS.addClose(panel);
		SYS_PANELS.refresh();		
		
	}).inject(elemDiv);
	
	fncDiv = new Element("div", {'class': 'optionIcon optionModify','title':LBL_PRO_MAP});	
	fncDiv.addEvent('click', function(evt) { openProMap(this); if (evt) { evt.stopPropagation(); } });
	fncDiv.inject(elemDiv);
	
	fncDiv = new Element("div", {'class': 'optionIcon optionModify','title':LBL_DEF_GEN});	
	fncDiv.addEvent('click', function(evt) { openGenModal(id); if (evt) { evt.stopPropagation(); } });
	fncDiv.inject(elemDiv);
		
	new Element('input',{ type:'hidden','name':'chkProcSel','value':''}).inject(elemDiv);
	new Element('input',{ type:'hidden','name':'chkProc','value':id}).inject(elemDiv);
	new Element('input',{ type:'hidden','name':'chkProcFather','value':father}).inject(elemDiv);
	new Element('input',{ type:'hidden','name':'hidMapData','id':'hidMapData','value':''}).inject(elemDiv);
	

	
	
	elemDiv.inject(container.getLast(),'before'); 
	
	return container;
}

function doConfirm(id){
	var obj = $(id.toString());
	var container = $('processContainer');
	var proName = obj.getElementsByTagName("SPAN")[0].firstChild.textContent;
	var proId = obj.getElementsByTagName("INPUT")[1].value;
	var fathersIds = obj.getElementsByTagName("INPUT")[2].value;
	if (!inList(proToDelete, proId)){
		//Si el proceso que se quiere eliminar no es subproceso de nadie, o es subproceso pero su proceso padre no esta en la grilla
		if (fathersIds==""){
			obj.destroy(); 
			if (container && container.onRemove) container.onRemove();
			var subProcs = getAllSubProcsToDelete(proId,container);
			if (subProcs != ""){
				proToDelete = proToDelete + "," + subProcs;
			}
		}else{
			var fathers = getRealFathers(fathersIds);
			if (fathers==""){//No es subproceso de un proceso de la grilla 
				if (proToDelete == ""){
					proToDelete = proId;
				}else{
					proToDelete = proToDelete + "," + proId;
				}
				var subProcs = getAllSubProcsToDelete(proId,container);//Eliminamos todos los subprocesos del proId que no son subprocesos de otro proceso de la grilla
				if (subProcs != ""){
					proToDelete = proToDelete + "," + subProcs;
				}
			}else{//Es subproceso de un proceso de la grilla
				showMessage((MSG_CANT_DEL_SUBPROC.replace("<TOK1>",proName)).replace("<TOK2>", fathers));
			}
		}
	}
	doOther();
	addScrollTable($('tblScenarioPoolBody'));
}

function doOther(){
	if (proToDelete != ""){
		deleteAllProcess(proToDelete);
		reLoadComboProcess();
	}
	refreshPools();
}

function validDiv(item){
	return !item.hasClass("optionIcon") && item.id!="addProcess" && !item.hasClass("optionAdd") && !item.hasClass("optionRemove");
}
//Devuelve true si obj se encuentra en list: "obj1,obj2,obj3,.."
function inList(list, obj){
	while (list.indexOf(",")>0){;
		if (obj == list.substring(0, list.indexOf(","))){
			return true;
		}
		list = list.substring(list.indexOf(",") + 1, list.length);
	}
	if (obj == list){
		return true;
	}
	return false;
}

//Elimina todos los procesos de la grilla que tienen como padre a proId y a ningun otro proceso de la grilla
function getAllSubProcsToDelete(proIdDel,container){
	var proIds= "";
	container.getElements("DIV.option").each(function(item,index){
			if (validDiv(item)){
				var proId = item.getElementsByTagName("INPUT")[1].value;
				var fathersIds = item.getElementsByTagName("INPUT")[2].value;
				if (proId != proIdDel && canDeleteProcess(fathersIds, proIdDel)){
					if (proIds == ""){
						proIds = proId;
					}else{
						proIds = proIds + "," + proId;
					}
				}
			}
		}
	)
	return proIds;
}

//Verifica si debemos y podemos eliminar el proceso que contiene los fathersIds pasados por parametro
//Debemos si los fathersIds tienen el proIdDel
//Podemos si los fathersIds no tienen otro fatherId existente en la grilla
function canDeleteProcess(fathersIds, proIdDel){
	var fathersIdsAux = fathersIds;
	var debemos = false;
	var podemos = false;
	while (!debemos && fathersIds.indexOf(",")>0){
		var fatherId = fathersIds.substring(0, fathersIds.indexOf(","));
		if (fatherId == proIdDel){
			debemos = true;
		}
		fathersIds = fathersIds.substring(fathersIds.indexOf(",")+1, fathersIds.length);
	}
	if (!debemos){
		if (fathersIds == proIdDel){
			debemos = true;
		}
	}
	if (debemos){
		podemos = !isSubProcess(fathersIdsAux, proIdDel);
	}
	return (debemos && podemos);
}

//Verifica si los proIds son subprocesos de algun proceso distinto del proIdDel
function isSubProcess(proIds, proIdDel){
	while (proIds.indexOf(",")>0){;
		var proId = proIds.substring(0, proIds.indexOf(","));
		proIds = proIds.substring(proIds.indexOf(",")+1, proIds.length);
		if (proId != proIdDel && existOnDiv(proId)){
			return true;
		}
	}
	if (proIds != proIdDel && existOnDiv(proIds)){
		return true;
	}
	return false;
}

//Verifica si existe en la grilla el proceso proId
function existOnDiv(proId){
	$('processContainer').getElements("DIV.option").each(function(item,index){		
			if (validDiv(item)){
				if (proId == item.getElementsByTagName("INPUT")[1].value){
					return true;
				}
			}
		}
	)
	return false;
}

//Devuelve nombre de los procesos padres que se encuentran en la grilla
function getRealFathers(fathersIds){
	var fathers = "";
	var found = false;
	if (fathersIds==""){ //Si no es un subproceso de nadie
		return "";
	}
	//Verificamos si es subproceso de algun proceso existente en la grilla
	
	trows=$('processContainer').getElements("DIV.option");
	while (fathersIds.indexOf(",")>0){
		var fathId = fathersIds.substring(0, fathersIds.indexOf(","));
		found = false;
		
		for (i=0;(!found && i<trows.length);i++) {
			var item = trows[i];
			if (validDiv(item)){
				var proId = item.getElementsByTagName("INPUT")[1].value;
				if (proId == fathId){
					found = true;
					if (fathers == ""){
						fathers = getProName(fathId);
					}else{
						fathers = fathers + ", " + getProName(fathId);
					}
				}
			}
		}
		fathersIds = fathersIds.substring(fathersIds.indexOf(",")+1,fathersIds.length);
	}
	found = false;
	for (i=0;(!found && i<trows.length);i++) {
		var item = trows[i];
		if (validDiv(item)){
			var proId = item.getElementsByTagName("INPUT")[1].value;
			if (proId == fathersIds){
				found = true;
				if (fathers == ""){
					fathers = getProName(fathersIds);
				}else{
					fathers = fathers + ", " + getProName(fathersIds);
				}
			}
		}
	}
	
	return fathers;
}

function getProName(proId){
	trows=$('processContainer').getElements("DIV.option");
	for (i=0;i<trows.length;i++) {
		var item = trows[i];
		if (validDiv(item)){
			if (proId == item.getElementsByTagName("INPUT")[1].value){
				return proName=trows[i].getElementsByTagName("SPAN")[0].firstChild.textContent;
			}
		}
	}
	return "<?>";
}

//Elimina todos los procesos pasados por parametro
function deleteAllProcess(proIds){
	while (proIds.indexOf(",")>0){;
		var proId = proIds.substring(0, proIds.indexOf(","));
		proIds = proIds.substring(proIds.indexOf(",")+1, proIds.length);
		deleteProcess(proId);
	}
	deleteProcess(proIds);
}

//Elimina el proceso pasado por parametro
function deleteProcess(proIdDel){
	trows=$('processContainer').getElements("DIV.option");
	var found = false;
	var i=0;
	while (!found && i<trows.length){
		var item = trows[i];
		if (validDiv(item)){
			var proId = item.getElementsByTagName("INPUT")[1].value;
			if (proId == proIdDel){
				item.destroy();
				found = true;
			}
		}
		i++;
	}
}

function reLoadComboProcess(){
	var proRows=$('processContainer').getElements("DIV.option");
	var proSel = $("selEndProcess").value; //guardamos el que estaba seleccionado
	//Vaciamos el combo de procesos
	while($("selEndProcess").options.length>0){
		$("selEndProcess").removeChild($("selEndProcess").options[0]);
	}
	for(var i=0;i<proRows.length;i++){
		var item = proRows[i];
		if (validDiv(item)){
			var proId=item.getElementsByTagName("INPUT")[1].value;
			var proName = item.getElementsByTagName("SPAN")[0].firstChild.textContent;
			if (i==0){
				var oOptNull = new Element("OPTION");
				oOptNull.inject($("selEndProcess"));
			}
			var oOpt1 = new Element("OPTION");
			oOpt1.value = proId;
			oOpt1.appendText(proName);
			if (proId == proSel){
				oOpt1.selected = true;
			}
			oOpt1.inject($("selEndProcess"));
		}
	}
}

function refreshPools(){
	//1- borramos todos los pools
	deleteAllPools();
	//2- armamos un string con todos los procesos que hay actualmente
	trows=$('processContainer').getElements("DIV.option");
	var i=0;
	var str = "";
	while (i<trows.length){
		var item = trows[i];
		if (validDiv(item)){
			var proId = item.getElementsByTagName("INPUT")[1].value;
			str = str + "&proId="+ proId;
		}
		i++;		
	}
	
	var request = new Request({
		method: 'post',		
		url: CONTEXT + URL_REQUEST_AJAX +'?action=refreshPools&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send(str);
}

function deleteAllPools(){
	trows=$("tblScenarioPoolBody").rows;
	var i=0;
	while (i<trows.length){
		trows[i].dispose();
	}
}

function addAjaxProcess(id){
	var request = new Request({
		method: 'post',
		data:{'id':id},
		url: CONTEXT + URL_REQUEST_AJAX +'?action=addProToBean&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();
}

function processLoadPool(){
	var resXml = getLastFunctionAjaxCall(); 
	var tableDOM = resXml.getElementsByTagName("table");
	if (tableDOM!=null){
		var rows = tableDOM.item(0).getElementsByTagName("row");
		var arrayRow = new Array();
		for (var i=0;i<rows.length;i++){
			var row = rows.item(i);
			var arrayTd = new Array();
			var cells = row.getElementsByTagName("cell");
			var k = 0;			
			while (k < cells.length){		
				var cell = cells.item(k);
				var type = cell.getAttribute("type");
				var tdDisplay = cell.getAttribute("display");
				lCount = 0;	
				
				auxTd = processTd(cell);
				arrayTd.push({'display':tdDisplay,'type':'td',arr:auxTd});				
							
				k +=lCount;
				k++;
			}
			addPool($('tblScenarioPoolBody'),arrayTd);			
		}		
	}
	
	var trs = $('tblScenarioPoolBody').getElements("tr");
	for (var i = 0; i < trs.length; i++){
		var tr = trs[i];
		if (i == trs.length-1){
			tr.addClass("lastTr");
		} else {
			tr.removeClass("lastTr");
		}
	}
	addScrollTable($('tblScenarioPoolBody'));
	
	
	initAdminFieldOnChangeHighlight(false,false,false,$('tblScenarioPoolBody'));
	initAdminRadioButtonOnChangeHighlight($('divEndByTime').getParent(), 'endType');
}

function addPool(table,arrTable){
	var parent = table.getParent();
	table.selectOnlyOne = false;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}

	var rowDOM = new Element('tr');
	for (var j=0;j<arrTable.length;j++){
		var td = arrTable[j];
		var div = new Element('div',{styles:{'width':'100%'}});
		if (j == 2){ div.set("align","center"); }
		d = addPoolTd(td,div);
			
		var tdDOM = new Element('td',{styles:{'display':td.display}});
		d.inject(tdDOM);
		tdDOM.inject(rowDOM);		
	}
	
	rowDOM.getRowId = function () { return this.getAttribute("rowId"); };
	rowDOM.setRowId = function (a) { this.setAttribute("rowId",a); };
	rowDOM.setAttribute("rowId", table.rows.length);
	
	if(table.rows.length%2==0){
		rowDOM.addClass("trOdd");
	}
	
	rowDOM.inject(table);	
}

function addPoolTd(temp,div){
	var td = temp.arr;
	for (var i=0;i<td.length;i++){
		var aux = td[i];
		
		if (aux.type=="span"){
			domElement = new Element('span',{html:aux.html});
		}else if (aux.type=="hidden"){
			domElement = new Element('input',{type:'hidden',name:aux.name,id:aux.id});
			domElement.setAttribute("value",aux.value);
		}else if (aux.type=="combo"){
			domElement = new Element('select',{id:aux.id,name:aux.name});
			for (var l=0;l<aux.options.length;l++){
				var auxOption = aux.options[l];
				var optionDOM = new Element('option');
				optionDOM.setProperty('value',auxOption.value);
				optionDOM.appendText(auxOption.text);
				if (auxOption.selected){
					optionDOM.setProperty('selected',"selected");
				}
				optionDOM.inject(domElement);
			}			
		}else if (aux.type=="text"){
			new Element('span',{html:"&nbsp;"}).inject(div);
			domElement = new Element('input',{type:'text',name:aux.name,id:aux.id,'onchange':aux.onchange});
			domElement.setAttribute("value",aux.value);
		}
		
		domElement.inject(div);		
		severalProperties(domElement,aux);
	}
	return div;
}

function loadPools(){
	deleteAllPools();
	var request = new Request({
		method: 'post',		
		url: CONTEXT + URL_REQUEST_AJAX +'?action=loadPools&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { 
			modalProcessXml(resXml); sp.hide(true);
			
			initAdminFieldOnChangeHighlight(false, false, false, null, true);
			initAdminFieldOnChangeHighlight(false,false,false,$('tblScenarioPoolBody'));
		}
	}).send();
}

function txtCantResChanged(obj){
	var td = obj.parentNode;
	var input0 = td.getElementsByTagName("INPUT")[0];
	var input1 = td.getElementsByTagName("INPUT")[1];
	input1.value = input0.value;	
}

function resTypeChanged(obj){
	var td = obj.parentNode;
	var select = td.getElementsByTagName("SELECT")[0];
	var type = select.options[select.selectedIndex].value;
	if (type < 0){
		td.getElementsByTagName("INPUT")[0].disabled = true;
		td.getElementsByTagName("INPUT")[0].value = "";
		td.getElementsByTagName("INPUT")[1].value = "";
	}else{
		td.getElementsByTagName("INPUT")[0].disabled = false;
	}
}

function myToggle(oTr){
	if (oTr.getParent().selectOnlyOne) {
		var parent = oTr.getParent();
		if (parent.lastSelected) parent.lastSelected.toggleClass("selectedTR");
		parent.lastSelected = oTr;
	}
	oTr.toggleClass("selectedTR"); 
}

function openGenModal(id){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=openGenModal&isAjax=true' + TAB_ID_REQUEST,	
		data:{proId:id},
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { 
			proIdSelected = id;
			
			modalProcessXml(resXml); 
			$('closeGenModal').addClass('close');
			
			var container = $('genTitle').getParent('div');
			resetChangeHighlight(container);
			initAdminFieldOnChangeHighlight(false, false, false, container, true);
			initAdminRadioButtonOnChangeHighlight(container, 'genType');
		}
	}).send();
}

function beforeCloseGenModal(){
	var modElements = $('genTitle').getParent('div').getElements('*.highlighted');
	if (modElements.length>0){		
		SYS_PANELS.newPanel();
		var panel = SYS_PANELS.getActive();
		panel.addClass("modalWarning");
		panel.content.innerHTML = GNR_PER_DAT_ING;
		panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll();\">" + BTN_CONFIRM + "</div>";
		SYS_PANELS.addClose(panel);

		SYS_PANELS.refresh();
		return false;
	}
	SYS_PANELS.closeAll();
}

function openProMap(obj){
	var proId = obj.getParent().getAttribute("id");
	
	if (Number.from(proId) == 1){
		showMessage(LBL_CANT_ASSIGN_PROB, GNR_TIT_WARNING, 'modalWarning');
		return;
	}	
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=startViewProcessMap&isAjax=true&proId=' + proId + TAB_ID_REQUEST,	
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();	
}

function openModalProMap(){
	SYS_PANELS.closeAll();
	var width = Number.from(frameElement.getParent("body").clientWidth);
	var height = Number.from(frameElement.getParent("body").clientHeight);
	width = (width*80)/100; //80%
	height = (height*80)/100; //80%
	
	var url = CONTEXT + URL_REQUEST_AJAX + "?action=viewProcessMap" + TAB_ID_REQUEST;
	var modal = ModalController.openWinModal(url, width, height, undefined, undefined, false, false, false);	
}

function changeGenType(val){
	var aux = $('genTitle');
	while (aux.tagName!="FORM"){
		aux = aux.parentNode;
	}
	var formName = aux.id;
	
	if (val == GEN_DISABLED){//dont start
		$("genTypeSelected").value = GEN_DISABLED;
		//Input de cantidad de transacciones
		$("txtCantTran").disabled=true;
		$("txtCantTran").value = "";
		
		disposeValidation($("txtCantTran"),formName);
		$("tdTxtCantTran").removeClass("required");
		
		//Frecuencia
		$("selGenFrec").selectedIndex=0;
		$("selGenFrec").disabled=true;
		$("txtPar1").disabled=true;
		$("txtPar2").disabled=true;
		
		disposeValidation($("selGenFrec"),formName);
		$("tdSelGenFrec").removeClass("required");
		
		disposeValidation($("txtPar1"),formName);
		disposeValidation($("txtPar2"),formName);
		$("tdTxtPar2").removeClass("required");
		
		$("txtPar1").value="";
		$("txtPar2").value="";
		
	}else if (val == GEN_ON_DEMAND){//on demand
		$("genTypeSelected").value = GEN_ON_DEMAND;
		//Input de cantidad de transacciones
		$("txtCantTran").disabled=true;
		$("txtCantTran").value = "";
		
		disposeValidation($("txtCantTran"),formName);
		$("tdTxtCantTran").removeClass("required");
		
		//Frecuencia
		$("selGenFrec").selectedIndex=0;
		$("selGenFrec").disabled=true;
		$("txtPar1").disabled=true;
		$("txtPar2").disabled=true;
		
		disposeValidation($("selGenFrec"),formName);
		$("tdSelGenFrec").removeClass("required");
		
		disposeValidation($("txtPar1"),formName);
		disposeValidation($("txtPar2"),formName);
		$("tdTxtPar2").removeClass("required");
		
		$("txtPar1").value="";
		$("txtPar2").value="";	
	}else if (val == GEN_CANT_TRANS){
		$("genTypeSelected").value = GEN_CANT_TRANS;
		//Input de cantidad de transacciones
		$("txtCantTran").disabled=false;
		
		$("txtCantTran").removeAttribute('class');
		registerValidation($("txtCantTran"),"validate['number','required'] scenarioInput",formName);
		$("tdTxtCantTran").addClass("required");
		
		//Frecuencia
		$("selGenFrec").selectedIndex=0;
		$("selGenFrec").disabled=true;
		$("txtPar1").disabled=true;
		$("txtPar2").disabled=true;
		
		disposeValidation($("selGenFrec"),formName);
		$("tdSelGenFrec").removeClass("required");
		
		disposeValidation($("txtPar1"),formName);
		disposeValidation($("txtPar2"),formName);
		$("tdTxtPar2").removeClass("required");
		
		$("txtPar1").value="";
		$("txtPar2").value="";
		
	}else if (val == GEN_FRECUENCY){
		$("genTypeSelected").value = GEN_FRECUENCY;
		//Input de cantidad de transacciones
		$("txtCantTran").disabled=true;
		$("txtCantTran").value = "";
		
		disposeValidation($("txtCantTran"),formName);
		$("tdTxtCantTran").removeClass("required");
		
		//Frecuencia
		$("selGenFrec").disabled=false;
		$("txtPar1").disabled=true;
		$("txtPar2").disabled=true;
		
		registerValidation($("selGenFrec"),"validate['required']",formName);
		$("tdSelGenFrec").addClass("required");
		
		disposeValidation($("txtPar1"),formName);
		disposeValidation($("txtPar2"),formName);
		$("tdTxtPar2").removeClass("required");
		
	}else if (val == GEN_HISTORY){//historic
		$("genTypeSelected").value = GEN_HISTORY;
		//Input de cantidad de transacciones
		$("txtCantTran").disabled=true;
		$("txtCantTran").value = "";
	
		disposeValidation($("txtCantTran"),formName);
		$("tdTxtCantTran").removeClass("required");
		
		//Frecuencia
		$("selGenFrec").selectedIndex=0;
		$("selGenFrec").disabled=true;
		$("txtPar1").disabled=true;
		$("txtPar2").disabled=true;
		
		disposeValidation($("selGenFrec"),formName);
		$("tdSelGenFrec").removeClass("required");
		
		disposeValidation($("txtPar1"),formName);
		disposeValidation($("txtPar2"),formName);
		$("tdTxtPar2").removeClass("required");
		
		$("txtPar1").value="";
		$("txtPar2").value="";	
	}
	
	["txtCantTran", "selGenFrec", "txtPar1", "txtPar2"].each(function(ele){
		$(ele).fireEvent('change');
	});
}

function changeGenTypeFrec(object){
	var aux = $('genTitle');
	while (aux.tagName!="FORM"){
		aux = aux.parentNode;
	}
	var formName = aux.id;
	
	var val = object.value;
	if (val==DIST_CTE_ENT){//Distribuida constante entera
		$("txtPar1").disabled=false;
		$("txtPar2").disabled=true;
		$("txtPar1").p_required=true;
		
		registerValidation($("txtPar1"),"validate['number','required'] scenarioInput",formName);
		disposeValidation($("tdTxtPar2"),formName);
		$("tdTxtPar2").removeClass("required");
		
		$("txtPar2").value="";
	}else if (val==DIST_EMP_ENT){//Distribuida empirica entera
		$("txtPar1").disabled=true;
		$("txtPar2").disabled=true;

		disposeValidation($("txtPar1"),formName);
		disposeValidation($("txtPar2"),formName);
		$("tdTxtPar2").removeClass("required");
		
		$("txtPar1").value="";
		$("txtPar2").value="";
	}else if (val==DIST_POISSON){//Distribuida poisson
		$("txtPar1").disabled=false;
		$("txtPar2").disabled=true;
		
		registerValidation($("txtPar1"),"validate['number','required'] scenarioInput",formName);
		disposeValidation($("txtPar2"),formName);
		$("tdTxtPar2").removeClass("required");
		
		$("txtPar2").value="";
	}else if (val==DIST_UNIF_ENT){//Distribuida uniforme entera
		$("txtPar1").disabled=false;
		$("txtPar2").disabled=false;
		
		registerValidation($("txtPar1"),"validate['number','required'] scenarioInput",formName);
		registerValidation($("txtPar2"),"validate['number','required'] scenarioInput",formName);
		$("tdTxtPar2").addClass("required");
		
	}else if (val==DIST_CTE_REAL){//Distribuida constante real
		$("txtPar1").disabled=false;
		$("txtPar2").disabled=true;

		registerValidation($("txtPar1"),"validate['number','required'] scenarioInput",formName);
		disposeValidation($("txtPar2"),formName);
		$("tdTxtPar2").removeClass("required");
		
		$("txtPar2").value="";
	}else if (val==DIST_EMP_REAL){//Distribuida empirica real
		$("txtPar1").disabled=true;
		$("txtPar2").disabled=true;
		
		disposeValidation($("txtPar1"),formName);
		disposeValidation($("txtPar2"),formName);
		$("tdTxtPar2").removeClass("required");
		
		$("txtPar1").value="";
		$("txtPar2").value="";
	}else if (val==DIST_EARLANG){//Distribuida erlang
		$("txtPar1").disabled=false;
		$("txtPar2").disabled=false;

		registerValidation($("txtPar1"),"validate['number','required'] scenarioInput",formName);
		registerValidation($("txtPar2"),"validate['number','required'] scenarioInput",formName);
		$("tdTxtPar2").addClass("required");
		
	}else if (val==DIST_EXP){//Distribuida exponencial
		$("txtPar1").disabled=false;
		$("txtPar2").disabled=true;
		
		registerValidation($("txtPar1"),"validate['number','required'] scenarioInput",formName);
		disposeValidation($("txtPar2"),formName);
		$("tdTxtPar2").removeClass("required");
		
		$("txtPar2").value="";
	}else if (val==DIST_NORMAL){//Distribuida normal
		$("txtPar1").disabled=false;
		$("txtPar2").disabled=false;

		registerValidation($("txtPar1"),"validate['number','required'] scenarioInput",formName);
		registerValidation($("txtPar2"),"validate['number','required'] scenarioInput",formName);
		$("tdTxtPar2").addClass("required");
		
	}else if (val==DIST_UNIF_REAL){//Distribuida uniforme real
		$("txtPar1").disabled=false;
		$("txtPar2").disabled=false;
		
		registerValidation($("txtPar1"),"validate['number','required'] scenarioInput",formName);
		registerValidation($("txtPar2"),"validate['number','required'] scenarioInput",formName);
		$("tdTxtPar2").addClass("required");
	}
}

function validateHours(obj){
   if (obj.value == "") return true;	
	
   var RegEx = /^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/;
   if(!obj.value.match(RegEx)){
	  obj.errors.push("Invalid format "+TIME_FORMAT);
      return false;
   }   
   return true;
}

function confirmGen(obj){
	var aux = $('genTitle');
	while (aux.tagName!="FORM"){
		aux = aux.parentNode;
	}
	var formName = aux.id;
	
	var form = $(formName);
	var url = form.getAttributeNode("action").value;
	if (! form) return;
	if (! form.formChecker) {
		form.formChecker = new FormCheck(
		form,
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
	}
	if (!form.formChecker.isFormValid()) return ; 
	
	new Request({
		method: 'post',
		url: CONTEXT + url,
		onComplete: function(resText, resXml) { 
			//Si se modifica, el proceso queda marcado como modificado
			var modElements = $('genTitle').getParent('form').getElements('*.highlighted');
			if (modElements.length>0){ $(proIdSelected).addClass('highlighted'); }
			
			modalProcessXml(resXml);
		}
	}).send("values="+getValues()); 
}

function getValues(){
	arr = new Array();
	var genTypeSel = $("genTypeSelected").value;
	arr[0] = genTypeSel;
	if (genTypeSel == 2){
		arr[1] = $("txtCantTran").value;
	}else if (genTypeSel == 0){
		var genTypeFrecSel = $("selGenFrec").value;
		arr[1] = genTypeFrecSel;
		if (genTypeFrecSel == 1){ //dist. constante entera
			arr[2] = $("txtPar1").value;
			arr[3] = "";
		}else if (genTypeFrecSel == 2){ //dist. empirica entera
			arr[2] = "";
			arr[3] = "";
		}else if (genTypeFrecSel == 3){ //dist. poisson
			arr[2] = $("txtPar1").value;
			arr[3] = "";
		}else if (genTypeFrecSel == 4){ //dist. uniforme entera
			arr[2] = $("txtPar1").value;
			arr[3] = $("txtPar2").value;
		}else if (genTypeFrecSel == 5){ //dist. constante real
			arr[2] = $("txtPar1").value;
			arr[3] = "";
		}else if (genTypeFrecSel == 6){ //dist. empirica real
			arr[2] = "";
			arr[3] = "";
		}else if (genTypeFrecSel == 7){ //dist. erlang
			arr[2] = $("txtPar1").value;
			arr[3] = $("txtPar2").value;
		}else if (genTypeFrecSel == 8){ //dist. exponencial
			arr[2] = $("txtPar1").value;
			arr[3] = "";
		}else if (genTypeFrecSel == 9){ //dist. normal
			arr[2] = $("txtPar1").value;
			arr[3] = $("txtPar2").value;
		}else if (genTypeFrecSel == 10){ //dist. uniforme real
			arr[2] = $("txtPar1").value;
			arr[3] = $("txtPar2").value;
		}
	}
	return arr;
} 

//Devuelve true si date1 es mayor que date2
function isGreater(date1, date2){
	var format = DATE_FORMAT.split('/');
	var yIdx, mIdx, dIdx; 
	
	for (var i=0; i<3; i++){
		if (format[i]=='Y') yIdx=i;
		if (format[i]=='m') mIdx=i;
		if (format[i]=='d') dIdx=i;
	}
	
	date1 = date1.split('/'); date2 = date2.split('/');
	var d1 = new Date(date1[yIdx], date1[mIdx]-1, date1[dIdx]);
	var d2 = new Date(date2[yIdx], date2[mIdx]-1, date2[dIdx]);
	
	return d1 > d2;
}

function verifyOtherReqObjects(){

	if ($("endTypeSelected").value == SIMULATION_END_BY_TIME){
		if (isGreater($("txtSceFchIni").value, $("txtSceDatEnd").value)){
			showMessage(MSG_WRNG_DATES);
			return false;
		}else if ($("txtSceFchIni").value == $("txtSceDatEnd").value){
			if ($("txtSceHorIni").value >= $("txtSceHorEnd").value){
				showMessage(MSG_WRNG_DATES);
				return false;
			}
		}
	}
	if ($("useHistChk").checked){ //Si es clickeado usar hist�rico	
		if (isGreater($("txtHistFrecDatIni").value, $("txtHistFrecDatEnd").value)){		
			showMessage(MSG_HIST_WRNG_DATES);
			return false;
		}else if ($("txtHistFrecDatIni") == $("txtHistFrecDatEnd")){
			if ($("txtHistFrecHorIni").value >= $("txtHistFrecHorEnd").value){
				showMessage(MSG_HIST_WRNG_DATES);
				return false;
			}
		}
	}
	//Verificamos si ingreso al menos un proceso
	var trows = $('processContainer').getElements("DIV.option");
	var found = false;
	for (i=0;(!found && i<trows.length);i++) {
		var item = trows[i];
		if (validDiv(item)){
			found=true;
		}
	}
	if (!found){
		showMessage(MSG_SCE_MUS_HAV_ONE_PRO);
		return false;
	}
	
	//Verificamos si se ingreso cant. de recursos, en todos los pooles que se selecciono fijo
	var trows=$("tblScenarioPoolBody").rows;
	for (i=0;i<trows.length;i++) {
		var td = trows[i].getElementsByTagName("TD")[1];
		var poolName = trows[i].getElementsByTagName("SPAN")[0].firstChild.textContent;
		var type = td.getElementsByTagName("SELECT")[0].value;
		if (type>=0 && td.getElementsByTagName("INPUT")[0].value == ""){
			showMessage(MSG_CANT_RES_NEED.replace("<TOK1>", poolName));
			return false;
		}
	}
	//Verificamos que si no se selecciono Usar historico, en todos los pooles se haya seleccionado fijo o ilimitado
	if (!$("useHistChk").checked){
		var trows=$("tblScenarioPoolBody").rows;
		for (i=0;i<trows.length;i++) {
			var td = trows[i].getElementsByTagName("TD")[1];
			var poolName = trows[i].getElementsByTagName("SPAN")[0].firstChild.textContent;
			var typeFixed = (td.getElementsByTagName("SELECT")[0].value == CANT_RES_FIXED);
			var typeUnlim = (td.getElementsByTagName("SELECT")[0].value == CANT_RES_UNLIM);
			if (!typeFixed && !typeUnlim && td.getElementsByTagName("INPUT")[0].value == ""){
				showMessage(MSG_MUST_SEL_CANT_RES_FIXED.replace("<TOK1>", poolName));
				return false;
			}
		}
	}

	return true;
}
