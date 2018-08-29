function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	$('frmData').formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: 10,
					tipsOffsetX: -10
				}
			}
	);
	/*
	$$("div.button").each(function(ele){
		setAdmEvents(ele);
	});
	*/
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=processMER&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { 
			modalProcessXml(resXml);

			var panel = SYS_PANELS.getActive();
			//En caso de error muestro modal
			if (panel.footer.innerHTML!=""){
				panel.footer.getElement('div.close').destroy();
				panel.addClass("modalWarning");						
				SYS_PANELS.addClose(panel, false, function(){
					 sp.show(true);
					 window.location = CONTEXT + URL_REQUEST_AJAX + '?action=merImport' + TAB_ID_REQUEST;
				});		
				SYS_PANELS.refresh();				
			}
			else{
				SYS_PANELS.closeAll();
			}
		}
	}).send();
	
	var btnBack = $('btnBack');
	if (btnBack){
		btnBack.addEvent("click",function(e){
			 e.stop();
			 sp.show(true);
			 window.location = CONTEXT + URL_REQUEST_AJAX + '?action=merImport' + TAB_ID_REQUEST; 
		});
	}
	
	var btnEdit = $('btnEdit');
	if (btnEdit){
		btnEdit.addEvent("click",function(e){
			e.stop();
			
			var form = $('frmData');
			if(!form.formChecker.isFormValid()){
				return;
			}

			var request = new Request({
				method: 'post',
				data:{pool:$('txtPoolName').value,isSave:true},
				url: CONTEXT + URL_REQUEST_AJAX + '?action=showModalMER&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { processModalParams(resXml); }
			}).send();			
		});
	}
	
	var btnConfirm = $('btnConfirm');
	if (btnConfirm){
		btnConfirm.addEvent("click",function(e){
			e.stop();
			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=confirmMER&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();			
		});
	}
	
	var btnLoadstate = $('btnLoadState');
	if (btnLoadState){
		btnLoadState.addEvent("click",function(e){
			var request = new Request({
				method: 'post',				
				url: CONTEXT + URL_REQUEST_AJAX + '?action=readMERState&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { processModalParams(resXml); }
			}).send();
		});
	}
}

function processMERTable(xml){
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		if (xml != null){
			console.debug(xml);
			loadTable($('tableData'),xml,false);
		}
		else{
			var messages = ajaxCallXml.getElementsByTagName("messages");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				 loadTable($('tableData'),messages.item(0),false);
			}
		}
		
	}
	SYS_PANELS.closeActive();
}
	
function loadTableParams(table){
	
	if (table==null || table.length==0){		
		return;
	}
	var object =  $('tableData');
	var selectOnlyOne = true;
	
	var newBody = new Element("tbody");
	newBody.id = object.id;
	newBody.addClass("tableData");
	var parent = object.parentNode;
	object.dispose();
	newBody.inject(parent);
	object = newBody;
	object.selectOnlyOne = selectOnlyOne;
	
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
		
	var headers = theadTr ? theadTr.getElements("th") : null;
	
	var tdWidths = headers ? new Array(headers.length) : null;
	
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	
	
	var rows = table.getElementsByTagName("row");		
	
	for(var i = 0; i < rows.length; i++) {
		var row = rows.item(i);
		var id = row.getAttribute("id");
		var classToAdd = row.getAttribute("classToAdd");

		var unselectableTR = row.getAttribute("unselectableTR");
		var tr = null;
		if (!unselectableTR){				
			tr = new Element('tr', {'class': 'selectableTR'});
		}else{
			tr = new Element('tr', null);
		}
		if(i%2==0) tr.addClass("trOdd");
		if (classToAdd) tr.className += " " + classToAdd;
		if (id != null && id != null) tr.setAttribute("rowId", id);
		
		tr.getRowId = function () { return this.getAttribute("rowId"); };
		tr.setRowId = function (a) { this.setAttribute("rowId",a); };
		tr.inject(object);
		
		var cells = row.getElementsByTagName("cell");
		var tdCol = 0;
		for(var j = 0; j < cells.length; j++) {
		
			var cell = cells.item(j);
			var type = cell.getAttribute("type");		
			var isHidden = toBoolean(cell.getAttribute("isHidden"));
			var isDisabled = toBoolean(cell.getAttribute("isDisabled"));
			var isRequired = toBoolean(cell.getAttribute("isRequired"));
			
			var content = cell.firstChild ? cell.firstChild.nodeValue : "";
			
			if (type=="input"){
				if (!isHidden){
					var td = new Element('td');
					td.setProperty('style','width:'+tdWidths[tdCol]);					
				}
				var inputDOM = getInput(cell,isHidden?"hidden":"text");				
				if (!isHidden){
					tdCol++;
				}				
				inputDOM.inject(td);
				if (isRequired){
					inputDOM.setProperty("style","width:80%");
					registerValidation(inputDOM);
					new Element("span",{html:"&nbsp;*"}).inject(td);
				}
				
			}else if (type=="combo"){
				var td = new Element('td');
				td.setProperty('style','width:'+tdWidths[tdCol]);
				td.setProperty('align','center');
				selector = getSelect(cell);			
				selector.inject(td);
				tdCol++;
			}else if (type=="text"){
				var td = new Element('td');
				td.setAttribute("textContent",content);
				var div = new Element('div', {styles: {width: tdWidths[tdCol], overflow: 'hidden', 'white-space': 'pre',margin:0}});
				new Element('span', {html: content}).inject(div);
				td.setProperty('style','width:'+tdWidths[tdCol]);
				div.inject(td);
				td.inject(tr);
				tdCol++;
			}
			td.inject(tr);
		}	
		var td = new Element('td');
		td.setProperty('style','width:'+tdWidths[tdCol]);
		var button = new Element('div',{html:LBL_EDIT,title:LBL_EDIT_TOOLTIP});
		button.addClass("buttonInput button");
		button.setProperty('style','float:none;text-align:center');
		button.setProperty("onclick","showModal('"+row.getAttribute("id")+"',"+i+")");
		button.inject(td);
		td.inject(tr);	
		
		
		
		tr.inject(object);		
	}
	
	initTable(object);		
	
	SYS_PANELS.closeActive();	
}	

function registerValidation(obj){
	obj.className="validate['required']";	
	$('frmData').formChecker.register(obj);
}

function disposeValidation(obj){
	$('frmData').formChecker.dispose(obj);
}

function processModalParams(ajaxXml){
    var element = SYS_PANELS.getActive();
	if (element == null) element = SYS_PANELS.newPanel();
	
	
	var toLoad = ajaxXml.getElementsByTagName("load").item(0);
	if (toLoad==null){
		processXmlMessages(ajaxXml.getElementsByTagName("sysMessages").item(0), true);
		return;
	}
	var theForm = toLoad.getElementsByTagName("form").item(0);
	var formAction = theForm.getAttribute("action"); 
	var formAjaxSubmit		= toBoolean(theForm.getAttribute("ajaxsubmit"));
	var formAjaxNewPanel	= toBoolean(theForm.getAttribute("ajaxNewPanel"));
	var formTitle 	= theForm.getAttribute("title");
	var formMethod 			= "post";
	var isSave = toBoolean(theForm.getAttribute("isSave"));	
	var onSubmit = "";
	
	/*theForm.setStyle('width','70%');
	theForm.setStyle('height','70%');*/
	
	if (formTitle != "") {
		element.header.empty();
		new Element("span", {html: formTitle}).inject(element.header);
	}
	
	var form = new Element('form',{id:'frmModalPanelAjax',action:formAction,method:formMethod,onsubmit:onSubmit});
	formStart = "<form action=\"" + formAction + "\" method=\"" + formMethod + "\"   id='frmModalPanelAjax'>";
	formEnd = "</form>";
	
   

    var xmlTable = theForm.getElementsByTagName("table");
    
	var aTable	= xmlTable.item(0);
	var rows	= aTable.getElementsByTagName("row");
	
	for (var i=0;i<rows.length;i++){
		var row = rows.item(i);	
		var titleTable = row.getAttribute("title");
		
		var formTable = new Element('table').set('html','<colgroup><col width="35%"><col></colgroup>');
		
		var tr =  new Element('tr');
		var th =  new Element('th',{html:titleTable});
		th.setAttribute("colspan", 2);
		th.inject(tr);
		tr.inject(formTable);	
		
		var cells = row.getElementsByTagName("cell");
		var k = 0;
		while (k < cells.length){		
			var cell = cells.item(k);
			var type = cell.getAttribute("type");		
			var isHidden = toBoolean(cell.getAttribute("isHidden"));
			var isDisabled = toBoolean(cell.getAttribute("isDisabled"));
			var isRequired = toBoolean(cell.getAttribute("isRequired"));
			var title = cell.getAttribute("title");
			var value = cell.getAttribute("value");
			
			if (type=="parent"||type=="son"){
				k = processParentSon(formTable,cell,type,k);			
			}else{
				var tr =  new Element('tr');
			
				if (type=="combo"){
					var td1 =  new Element('td',{html:title});					
					var td2 =  new Element('td');
					selector = getSelect(cell);
					selector.setAttribute('style','width:81%');
					selector.inject(td2);
					
				}else if (type=="checkbox"){
					var td1 =  new Element('td');		
					var td2 =  new Element('td');				
					
					var data = cell.firstChild;
					var id = data.getAttribute("id");
					var label = new Element('label',{html:title});
					label.setProperty('for',id);
					label.addClass("label");
				
					var inputDOM = getInput(cell,"checkbox");
							
					label.inject(td1);
					inputDOM.inject(td2);
											
				}else if (type=="both"){
					var td1 =  new Element('td',{html:title});
					var td2 =  new Element('td');
					
					var inputDOM = getInput(cell,"checkbox",true);
					inputDOM.setAttribute('style','width:5%');
					selector = getSelect(cell);
					selector.setAttribute('style','width:73%');
					
					inputDOM.inject(td2);
					selector.inject(td2);
				}else if (type=="input"){
					var td1 =  new Element('td');			
					var td2 =  new Element('td');		
					var inputDOM = getInput(cell,isHidden?"hidden":type);	
					if (!title){
						inputDOM.inject(td1);
					}else{
						td1 = new Element('td',{html:title});					
						registerValidation(inputDOM);
						inputDOM.inject(td2);
						new Element("span",{html:"&nbsp;*"}).inject(td1);
					}
				}
					
				td1.inject(tr);
				td2.inject(tr);
				
				tr.setAttribute("id", k);
				tr.addClass("locked");				
				tr.inject(formTable);				
				
				k++;
			}		
		}
		formTable.inject(form);
	}
	
	element.content.innerHTML="";
	form.inject(element.content);	
	if (formAction=="both"){
		form.setAttribute("action",URL_REQUEST_AJAX + '?action=saveParams' + TAB_ID_REQUEST);
		element.footer.innerHTML = "<div onclick=\"doAjaxSubmit('frmModalPanelAjax', true);\" class='button'>"+LBL_SAVE+"</div><div style='padding-left:30%' onclick=\"saveState('frmModalPanelAjax',true);\" class='button'>"+LBL_SAVE_STATE+"</div>";
	}
	
	SYS_PANELS.addClose(element);
	
	var modal= $$('div.modalContent')[0].setStyle('width', 600);
	modal.getChildren('div.content').setStyle('max-height', 600);
	modal.position();
	
}

function saveState(name,showLoading){
	var form = $(name);
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
	
	if (!form.formChecker.isFormValid()) return ;
	if (showLoading == null) showLoading = true;
	
	var params = "";
	
	var doEscape = form.getAttribute("doescape") == "true";
	
	//parseo
	
	var elements = form.getElementsByTagName("INPUT");
	var elementsCmb = form.getElementsByTagName("SELECT");
	var strCookie = "";
	for(var i=0;i<elementsCmb.length;i++){
		var name = elementsCmb[i].id;
		var val = elementsCmb[i].value;
		if(name && name!=null && name.length>0){
			if(strCookie.length>0){
				strCookie = strCookie + "#";
			}
			strCookie = strCookie + name + "|" + val;
		}
	}
	
	//armar string
	for(var i=0;i<elements.length;i++){
		var name = elements[i].id;
		var val = elements[i].value;
		if(elements[i].type=="checkbox"){
			val = elements[i].checked;
		}
		if(name && name!=null && name.length>0){
			if(strCookie.length>0){
				strCookie = strCookie + "#";
			}
			strCookie = strCookie + name + "|" + val;
		}
	}
	
	SYS_PANELS.showLoading();
	
	new Request({
		method: 'post',
		data:{str:strCookie},
		url: CONTEXT+URL_REQUEST_AJAX + '?action=saveMERState&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) { modalProcessXml(resXml);  }
	}).send();
		
}

function getSelect(cell){
	var elements = cell.getElementsByTagName("element");
	if (elements.length==1){
		var elem = elements.item(0);
	}else{
		var elem = elements.item(1);
	}
	var opts = elem.firstChild;
	var selectedValue = elem.getAttribute("value");
	var disabled  = toBoolean(elem.getAttribute("disabled"));
	var onchange = elem.getAttribute("onchange") || cell.getAttribute("onchange")
	var selector = new Element('select');
	selector.setProperty('id',elem.getAttribute("id"));
	selector.setProperty('name',elem.getAttribute("id"));
	
	if (disabled){
		selector.setProperty('disabled',disabled);	
	}
	if (onchange){
		selector.setProperty('onchange',onchange);
	}
	
	var options = opts.getElementsByTagName("option");
	for (var l = 0; l < options.length; l++) {
		var optionDOM = new Element('option');
		var option = options.item(l);
		
		var value = option.getAttribute("value");
		var text = (option.firstChild != null)?option.firstChild.nodeValue:""; 
		
		optionDOM.setProperty('value',value);
		optionDOM.appendText(text);
		
		if (selectedValue!="" && selectedValue == value || selectedValue=="" && l==0){
			optionDOM.setProperty('selected','selected');
		}
		optionDOM.inject(selector);
	
	}
	
	return selector;
}

function getInput(cell,type){
	var data = cell.firstChild;
	var id = data.getAttribute("id");
	var name = data.getAttribute("name");
	var value = data.getAttribute("value");
	var click = data.getAttribute("onclick") || cell.getAttribute("onclick");
	var disabled = data.getAttribute("disabled") || cell.getAttribute("disabled");
	var inputDOM = new Element('input');				
	var isChecked = cell.getAttribute("selected");
	if (isChecked!=null){
		isChecked = toBoolean(cell.getAttribute("selected"));
	}else{
		isChecked = toBoolean(data.getAttribute("selected"));
	}
	
	inputDOM.setProperty("id",id);
	inputDOM.setProperty("name",name);	
	inputDOM.setProperty('type',type);
	if (click){
		inputDOM.setProperty('onclick',click);		
	}	
	if (isChecked){
		inputDOM.setProperty('checked',true);		
	}
	if (value!=null && value!="null"){
		inputDOM.setProperty('value',value);
	}
	if (disabled){
		inputDOM.setProperty('disabled',disabled=='true');
	}
	
	
	return inputDOM;
}

function enableCombo(obj, relation, id, id2){
	$(id+relation).disabled=!obj.checked;
	
	if (id2){
		$(id2+relation).disabled=!obj.checked;		
	}
}

function bindingStatus(combo, relation, toCompare, id, id2){
	$(id+relation).disabled = combo.value == toCompare;	
	
	if (id2){
		$(id2+relation).disabled = combo.value == toCompare;		
	}
}


function setTableStatus(tableId){
	var table = $$('div.modalContent')[0].getChildren('div.content').getChildren()[0].getChildren()[0].getChildren()[tableId];
	var chkCreation = $$(table.getElements('input#chkCreation'+tableId))[0];
		
	var aux = $$(table.getElements('select#'));
	for (var i=0; i<aux.length; i++){
		aux[i].disabled = !chkCreation.checked;
	}
	var aux = $$(table.getElements('input#'));
	for (var i=0; i<aux.length; i++){
		aux[i].disabled = !chkCreation.checked;
	}
	
	if (chkCreation.checked){	
		//Habilito segun corresponda relaciones con hijos
		var aux = $$(table.getElements('input[id^=chkCard])'));		
		for (var i=0; i<aux.length; i++){
			if (!aux[i].checked){
				var relation = aux[i].id.split('chkCard')[1];
				enableCombo(aux[i], relation, 'cmbAdmHij', 'txtRelNameChild');
			}
		}	
		//Habilito segun corresponda relaciones con padres		
		var aux = $$(table.getElements('select[id^=cmbAdmPad])'));		
		for (var i=0; i<aux.length; i++){
			aux[i].disabled = false;
			var relation = aux[i].id.split('cmbAdmPad')[1];
			bindingStatus(aux[i], relation, 'N', 'txtRelNamePad');
		}	
		
		//Habilito segun corresponda opciones de creacion de Proceso 
		var selTypeAdm = $$(table.getElements('select[id^=selTypeAdm'+tableId+']'))[0];
		bindingStatus(selTypeAdm, tableId, 'F', 'chkProCre', 'chkProAlt');
		
		//Habilito segun corresponda opciones de valor de modal
		var chkCreateModal = $$(table.getElements('input#chkCreateModal'+tableId))[0];
		enableCombo(chkCreateModal, tableId, 'cmbFinder');
	}
	
	chkCreation.disabled = false;
}

function processParentSon(tableMain,cell,type,i){
		
	var trMain = new Element('tr');
	var tdMain = new Element('td',{colspan:3});
	
	var table = new Element('table');
	table.addClass("parentSon");
	var cells = cell.getElementsByTagName('cell');
	
	if (cells==null || cells.length==0){
		return;
	}
	var thead = new Element('thead');
	var tr = new Element('tr');
	if (type=="parent"){
		td1 = new Element('td',{html:LBL_PARENT});
		td1.setAttribute('align','center');
		td2 = new Element('td',{html:LBL_BIND});
		td2.setAttribute('align','center');
		td3 = new Element('td',{html:LBL_NOMREL});
		td3.setAttribute('align','center');
	}else{
		td1 = new Element('td',{html:LBL_SON});
		td1.setAttribute('align','center');
		td2 = new Element('td',{html:LBL_ADM});
		td2.setAttribute('align','center');
		td3 = new Element('td',{html:LBL_NOMREL});
		td3.setAttribute('align','center');
	}
	td1.inject(tr);
	td2.inject(tr);
	td3.inject(tr);
	tr.inject(thead);
	thead.inject(table);
	var tbody = new Element('tbody');
	var count = 0;
	while (count < cells.length){		
		
		var tr = new Element('tr');
		td1 = new Element('td');
		td2 = new Element('td');
		td3 = new Element('td');
		
		//texto
		var cell = cells.item(count);
		var text = (cell.firstChild != null)?cell.firstChild.nodeValue:""; 
		td1 = new Element('td',{html:text});		
		
		count++;
		
		//hidden
		cell = cells.item(count);
		var data = cell.firstChild;
		inputDOM = getInput(cell,"hidden");		
		inputDOM.inject(td1);
		td1.inject(tr);
		
		count++;
		
		cell = cells.item(count);
		if (type=="parent"){
			selector = getSelect(cell);
			selector.inject(td2);
			selector.setAttribute('style','width:70%');
			td2.setAttribute('align','center');
			td2.inject(tr);
			
			count++;			
		}else{					
			inputDOM = getInput(cell,"checkbox");
			inputDOM.setAttribute('style','width:25%');
			inputDOM.inject(td2);
			td2.inject(tr);
			
			count++;
			
			cell = cells.item(count);
			selector = getSelect(cell);
			selector.setAttribute('style','width:50%');
			selector.inject(td2);
			td2.setAttribute('align','center');
			td2.inject(tr);
			count++;
		}	
		
		cell = cells.item(count);
		inputDOM = getInput(cell,"text");
		inputDOM.inject(td3);
		td3.setAttribute('align','center');
		
		count++;
		
		td1.inject(tr);
		td2.inject(tr);
		td3.inject(tr);
		
		tr.inject(tbody);
	}	
	tbody.inject(table)
	table.inject(tdMain);
	tdMain.inject(trMain);
	trMain.inject(tableMain);
	count++;
	return (i+count);
}

function reloadTable() {
	new Request({
		method: 'post',
		url: CONTEXT+URL_REQUEST_AJAX + '?action=reloadAfterReload&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) { 
			modalProcessXml(resXml);
			SYS_PANELS.closeAll();  
		}
	}).send();		
}