function checkWhereUserFilterFreeSql() {
	if (document.getElementById("gridUser")!=null){
		trows=document.getElementById("gridUser").rows;
		for (var i=0;i<trows.length;i++) {
			addFreeSqlEvents(trows[i]);
		}
	}
}

function addFreeSqlEvents(tr) {
	if (! QRY_FREE_SQL_MODE) return;
	
	var tds = tr.getElementsByTagName("TD");
	
	var inputType		= tds[1].getElementsByTagName("SELECT")[0];//SELECT
	var inputDefault	= tds[5].getElementsByTagName("INPUT")[0];//INPUT
	var inputCondition	= tds[6].getElementsByTagName("SELECT")[0];//SELECT
	var inputCombox		= tds[8].getElementsByTagName("SELECT")[0];//SELECT
	var inputShowTime	= tds[11].getElementsByTagName("INPUT")[0];//INPUT
	var input2Columns	= tds[12].getElementsByTagName("INPUT")[0];//INPUT
	var inputIgnoreCaps	= tds[13].getElementsByTagName("INPUT")[0];//INPUT
	var inputEntity		= tds[15].getElementsByTagName("SELECT")[0];//SELECT
	var inputHideIcon	= tds[16].getElementsByTagName("INPUT")[0];//INPUT
	
	inputType.inputDefault		= inputDefault;
	inputType.inputCondition	= inputCondition;
	inputType.inputCombox		= inputCombox;
	inputType.inputShowTime		= inputShowTime;
	inputType.input2Columns		= input2Columns;
	inputType.inputIgnoreCaps	= inputIgnoreCaps;
	inputType.inputEntity		= inputEntity;
	inputType.inputHideIcon		= inputHideIcon;
	
	inputType.addEvent('change',executeFreeSqlEvent);
	executeFreeSqlvent(inputType);
}

function executeFreeSqlEvent(evt) {
	//CAM_11735
	//evt = getEventObject(evt);
	var caller = getEventSource(evt);
	executeFreeSqlvent(caller)
}

function getEventSource(evt){
	if(evt && evt.element){
		return evt.element;
	}
	if(MSIE){
		return window.event.srcElement;
	}
	return evt.target;
} 

function removeDatePicker (datePicker) {
	if (!datePicker.get('hasDatepicker')) return;
	var inputDate = datePicker.nextSibling;
	inputDate.style.display='none';
	inputDate.nextSibling.style.display='none';	
	inputDate.disabled=true;
	datePicker.style.display='';
}

function executeFreeSqlvent(caller) {
	var currentValue = caller.options[caller.selectedIndex].value;
	
	caller.inputDefault;
	removeDatePicker(caller.inputDefault);
	disposeValidation(caller.inputDefault);
	if (currentValue == COLUMN_DATA_DATE) {	
		caller.inputDefault.addClass("datePicker filterInputDate");
		if (!caller.inputDefault.get('hasDatepicker')){
			setAdmDatePicker(caller.inputDefault);
		}else{
			var inputDate = caller.inputDefault.nextSibling;
			caller.inputDefault.style.display='none';
			inputDate.disabled=false;
			inputDate.style.display='';
			inputDate.nextSibling.style.display='';
		}
	}else if (currentValue == COLUMN_DATA_NUMBER){
		registerValidation(caller.inputDefault,"validate['numeric']");
	}
	
	caller.inputCondition.style.display = (currentValue == COLUMN_DATA_DATE) ? 'none' : '';
	caller.inputCombox.style.display = (currentValue == COLUMN_DATA_DATE) ? 'none' : '';
	caller.inputShowTime.style.display = (currentValue == COLUMN_DATA_DATE) ? '' : 'none';
	caller.input2Columns.style.display = (currentValue == COLUMN_DATA_DATE) ? 'none' : '';
	caller.inputIgnoreCaps.style.display = (currentValue == COLUMN_DATA_DATE) ? 'none' : '';
	caller.inputEntity.style.display = (currentValue == COLUMN_DATA_DATE) ? 'none' : '';
	caller.inputHideIcon.style.display = (currentValue == COLUMN_DATA_DATE) ? 'none' : '';
	
	if (currentValue == COLUMN_DATA_DATE) {
		caller.inputCondition.selectedIndex = 0;
	} else {
		for (var i = 0; i < caller.inputCondition.options.length; i++) {
			var option = caller.inputCondition.options[i];
			var validFor = option.getAttribute("validFor");
			option.style.display = (validFor == "all" || validFor == currentValue) ? '' : 'none';
		}
	}
}

function processColumnsModalReturnUser(ret){
	var notAllowAux = new Array();
	var trows = $('tableBodyUser').rows;
	var count = 0;
	for (var j = 0; j < ret.length; j++){
		var e = ret[j];
		var addRet = true;	
		var text = e.getRowContent()[0];
		for (i=0;i<trows.length && addRet;i++) {
			if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[4].value == text) {
				addRet = false;
			}
		}
		if (addRet) {
			if (! inNotAllowed(text)) {
				generateUser('',text,text,e.getAttribute("type"),QRY_DB_TYPE_COL,"");
			} else {
				notAllowAux.push(text);
			}
		}			
	}
	Scroller_tableBodyUser = addScrollTable($('tableBodyUser'));
	SYS_PANELS.closeAll();
	
	if (notAllowAux.length == 1){
		showMessage(MSG_COL_NOT_ALLOW.replace("<TOK1>",notAllowAux[0]), GNR_TIT_WARNING, 'modalWarning');
	} else if (notAllowAux.length > 1){
		var tok = "";
		for (var i = 0; i < notAllowAux.length; i++){
			if (tok != "") tok += ", ";
			tok += notAllowAux[i];			
		}
		showMessage(MSG_COL_NOT_ALLOW_S.replace("<TOK1>",tok), GNR_TIT_WARNING, 'modalWarning');
	}
}

function generateUser(val0,val1,val2,val3,val4,val5) {
	/************************************************/
	/** No cambiar el orden, en caso de hacerlo se **/
	/** debe actualizar el c�digo de la funci�n    **/
	/** addFreeSqlEvents la cual se ejecuta solo   **/
	/** si se est� en una consulta de tipo sql     **/
	/** libre.                                     **/
	/************************************************/
	
	
	var arrayRow = new Array();
	var arrayTd = new Array();
	var arrayCell = new Array();	

	//Fila
	arrayCell.push({'type':'hidden',name:'chkWhereSel',id:'chkWhereSel'});
	arrayCell.push({'type':'hidden',name:'hidUserColId',id:'hidUserColId',value:''});
	arrayCell.push({'type':'hidden',name:'hidUserAttId',id:'hidUserAttId',value:val0});
	arrayCell.push({'type':'hidden',name:'hidUserDbType',id:'hidUserDbType',value:val4});
	arrayCell.push({'type':'hidden',name:'hidUserParId',id:'hidUserParId',value:val5});
	
	if (!QRY_FREE_SQL_MODE) {
		arrayCell.push({'type':'hidden',name:'hidUserColName',id:'hidUserColName',value:val1});
		arrayCell.push({'type':'hidden',name:'hidUserDatType',id:'hidUserDatType',value:val3});
		arrayCell.push({'type':'span',html:val1});	
	}else{
		arrayCell.push({'type':'text',name:'hidUserColName',id:'hidUserColName',required:true,value:''});
	}
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	if (QRY_FREE_SQL_MODE){
		arrayOptions = new Array();	
		arrayOptions.push({'value':COLUMN_DATA_STRING,'text':LBL_DATA_TYPE_STR,'selected':true});	
		arrayOptions.push({'value':COLUMN_DATA_NUMBER,'text':LBL_DATA_TYPE_NUM,'selected':false});
		arrayOptions.push({'value':COLUMN_DATA_DATE,'text':LBL_DATA_TYPE_FEC,'selected':false});
		var aux = {'type':'combo',name:'hidUserDatType',id:'hidUserDatType','required':false,'options':arrayOptions,display:''};	
		arrayCell.push(aux);
		arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	}
	
	//Fila
	arrayCell = new Array();
	arrayCell.push({'type':'span',html:val1});
	arrayTd.push({'display':'none',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	arrayCell.push({'type':'text',name:'txtUserHeadName',id:'txtUserHeadName',required:true,value:val2});
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	arrayCell.push({'type':'text',name:'txtUserTool',id:'txtUserTool',required:false,value:''});
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	arrayCell.push({'type':'text',name:'txtUserVal',id:'txtUserVal',value:'','className':val3 == COLUMN_DATA_DATE?"datePicker filterInputDate":null,validation:val3 == COLUMN_DATA_NUMBER?"numeric":null,format:val3 == COLUMN_DATA_DATE?"d/m/Y":null,hasDatePicker:val3 == COLUMN_DATA_DATE?true:false});
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	arrayOptions = new Array();	
	arrayOptions.push({'value':'','text':'','selected':false});	
	if (val3 == COLUMN_DATA_NUMBER || QRY_FREE_SQL_MODE) {
		arrayOptions.push({'value':NUMBER_TYPE_EQUAL,'text':LBL_NUMBER_TYPE_EQUAL,'selected':false,validFor:COLUMN_DATA_NUMBER});	
		arrayOptions.push({'value':NUMBER_TYPE_LESS,'text':LBL_NUMBER_TYPE_LESS,'selected':false,validFor:COLUMN_DATA_NUMBER});	
		arrayOptions.push({'value':NUMBER_TYPE_MORE,'text':LBL_NUMBER_TYPE_MORE,'selected':false,validFor:COLUMN_DATA_NUMBER});	
		arrayOptions.push({'value':NUMBER_TYPE_DISTINCT,'text':LBL_NUMBER_TYPE_DISTINCT,'selected':false,validFor:COLUMN_DATA_NUMBER});	
		arrayOptions.push({'value':NUMBER_TYPE_LESS_OR_EQUAL,'text':LBL_NUMBER_TYPE_LESS_OR_EQUAL,'selected':false,validFor:COLUMN_DATA_NUMBER});	
		arrayOptions.push({'value':NUMBER_TYPE_MORE_OR_EQUAL,'text':LBL_NUMBER_TYPE_MORE_OR_EQUAL,'selected':false,validFor:COLUMN_DATA_NUMBER});			
	}
	if (val3 == COLUMN_DATA_STRING || QRY_FREE_SQL_MODE) {
		arrayOptions.push({'value':STRING_TYPE_EQUAL,'text':LBL_STRING_TYPE_EQUAL,'selected':false,validFor:COLUMN_DATA_STRING});	
		arrayOptions.push({'value':STRING_TYPE_STARTS_WITH,'text':LBL_STRING_TYPE_STARTS_WITH,'selected':false,validFor:COLUMN_DATA_STRING});	
		arrayOptions.push({'value':STRING_TYPE_ENDS_WITH,'text':LBL_STRING_TYPE_ENDS_WITH,'selected':false,validFor:COLUMN_DATA_STRING});	
		arrayOptions.push({'value':STRING_TYPE_LIKE,'text':LBL_STRING_TYPE_LIKE,'selected':false,validFor:COLUMN_DATA_STRING});	
		arrayOptions.push({'value':STRING_TYPE_NOT_EQUAL,'text':LBL_STRING_TYPE_NOT_EQUAL,'selected':false,validFor:COLUMN_DATA_STRING});	
		arrayOptions.push({'value':STRING_TYPE_NOT_STARTS_WITH,'text':LBL_STRING_TYPE_NOT_STARTS_WITH,'selected':false,validFor:COLUMN_DATA_STRING});	
		arrayOptions.push({'value':STRING_TYPE_NOT_ENDS_WITH,'text':LBL_STRING_TYPE_NOT_ENDS_WITH,'selected':false,validFor:COLUMN_DATA_STRING});	
		arrayOptions.push({'value':STRING_TYPE_NOT_LIKE,'text':LBL_STRING_TYPE_NOT_LIKE,'selected':false,validFor:COLUMN_DATA_STRING});	
	}
		
	aux = {'type':'combo',name:'cmbUsuFilter',id:'cmbUsuFilter','required':false,'options':arrayOptions,display:'',validFor:'all'};	
	arrayCell.push(aux);
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	arrayOptions = new Array();	
	
	arrayOptions.push({'value':1,'text':lblYes,'selected':false});	
	arrayOptions.push({'value':0,'text':lblNo,'selected':true});	
	
	aux = {'type':'combo',name:'cmbUserReq',id:'cmbUserReq','required':false,'options':arrayOptions,display:''};	
	arrayCell.push(aux);
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});

	//Fila
	arrayCell = new Array();
	arrayOptions = new Array();	
	
	arrayOptions.push({'value':0,'text':lblNo,'selected':false});	
	arrayOptions.push({'value':1,'text':lblYes,'selected':false});		
	
	aux = {'type':'combo',name:'cmbColType',id:'cmbColType','required':false,'options':arrayOptions,display:'','onchange':"onChangeCmbType(this)"};	
	arrayCell.push(aux);
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	aux = {'type':'checkbox',name:'cmbExecOnCha',id:'cmbExecOnCha','required':false,'checked':false,value:1};
	arrayCell.push(aux);
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	aux = {'type':'checkbox',name:'cmbSorted',id:'cmbSorted','required':false,'checked':false,value:1};
	arrayCell.push(aux);
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	aux = {'type':'checkbox',name:'cmbUserTime',id:'cmbUserTime','required':false,'checked':false,'display':val3 != COLUMN_DATA_DATE && ! QRY_FREE_SQL_MODE?'none':'',value:1};
	arrayCell.push(aux);
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	aux = {'type':'checkbox',name:'cmbShow2Column',id:'cmbShow2Column','required':false,'checked':false,'display':val3 == COLUMN_DATA_DATE && ! QRY_FREE_SQL_MODE?'none':'',value:1};
	arrayCell.push(aux);
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	aux = {'type':'checkbox',name:'cmbUseUpper',id:'cmbUseUpper','required':false,'checked':false,'display':(val3 == COLUMN_DATA_DATE || val3 == COLUMN_DATA_NUMBER) && ! QRY_FREE_SQL_MODE?'none':'',value:1};
	arrayCell.push(aux);
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	aux = {'type':'checkbox',name:'cmbIsReadOnly',id:'cmbIsReadOnly','required':false,'checked':false,value:1};
	arrayCell.push(aux);
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	if (val3 == COLUMN_DATA_DATE && ! QRY_FREE_SQL_MODE) {
		aux = {'type':'hidden',name:'cmbBusEntIdFilter',id:'cmbBusEntIdFilter',value:''};		
	} else {
		aux = {'type':'comboentity',name:'cmbBusEntIdFilter',id:'cmbBusEntIdFilter',width:'90%'};		
	}
	arrayCell.push(aux);
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	aux = {'type':'checkbox',name:'cmbHidFilSel',id:'cmbHidFilSel','required':false,'checked':false,value:1};
	arrayCell.push(aux);
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	if (ADD_AVOID_AUTO_FILTER) {
		aux = {'type':'checkbox',name:'cmbFilDontUseAutoFilter',id:'cmbFilDontUseAutoFilter','required':false,'checked':false,value:1};
		arrayCell.push(aux);
		arrayTd.push({'display':'',arr:arrayCell,'type':'td'});		
	}
	addRowWhereUser($('tableBodyUser'),arrayTd,true);
	
	toogleLastTr("tableBodyUser");
}

function onChangeCmbType(ele){
	var row = ele.getParent().getParent().getParent();
	var sort = row.getElementById('cmbSorted');
	if (sort){
		if (ele.value==0){
			sort.disabled = true;
			sort.checked = false;
		}
		else{
			sort.disabled = false;
		}
	}
}

function addRowWhereUser(table,arrTable,displayRow){
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
		var div = new Element('div',{styles:{'width':tdWidths[j]}});
		
		div.addClass("width150");
		
		d = addRowWhereUserTd(td,div);
			
		var tdDOM = new Element('td',{styles:{'display':td.display,'disabled':td.disabled}});
		d.inject(tdDOM);
		tdDOM.inject(rowDOM);			
	}
	
	rowDOM.addClass("selectableTR");
	rowDOM.addEvent("click",function(e){myToggle(this)});
	rowDOM.getRowId = function () { return this.getAttribute("rowId"); };
	rowDOM.setRowId = function (a) { this.setAttribute("rowId",a); };
	rowDOM.setAttribute("rowId", table.rows.length);
	
	if(table.rows.length%2==0){
		rowDOM.addClass("trOdd");
	}
	if (!displayRow){
		rowDOM.style.display='none';
	}
	rowDOM.inject(table);
	addFreeSqlEvents(rowDOM);		
		
}

function addRowWhereUserTd(temp,div) {
	var td = temp.arr;
	for (var i=0;i<td.length;i++){
		var aux = td[i];
		if (aux.type=="text"){
			domElement = new Element('input',{type:'text',name:aux.name,id:aux.id});			
			//domElement.setAttribute("value",aux.value);
			domElement.set("value", aux.value);
		}else if (aux.type=="checkbox"){
			domElement = new Element('input',{type:'checkbox',name:aux.name,id:aux.id,checked:aux.checked,value:aux.value});
		}else if (aux.type=="hidden"){
			domElement = new Element('input',{type:'hidden',name:aux.name,id:aux.id});
			//domElement.setAttribute("value",aux.value);
			domElement.set("value", aux.value);
		}else if (aux.type=="span"){
			domElement = new Element('span',{html:aux.html});
		}else if (aux.type=="combo"){
			domElement = getSelectU(aux);
		}else if (aux.type="comboentity"){
			domElement = new Element('select',{id:aux.id,name:aux.name});							
			for (var l=0;l<OPTIONS_BUS_ENTITY_COMBO_ARR.length;l++){
				var auxOption = OPTIONS_BUS_ENTITY_COMBO_ARR[l];
				var optionDOM = new Element('option');
				optionDOM.setProperty('value',auxOption.value);
				optionDOM.appendText(auxOption.text);
				if (auxOption.selected){
					optionDOM.setProperty('selected',"selected");
				}
				optionDOM.inject(domElement);
			}
		}
		domElement.setStyle("width","95%");		
		domElement.inject(div);					
		severalProperties(domElement,aux);
	}
	return div;
}

function getSelectU(aux){
	var domElement = new Element('select',{id:aux.id,name:aux.name});
	if (aux.validFor!=null){
		//domElement.setAttribute('validFor',aux.validFor);
		domElement.set('validFor', aux.validFor);
	}
	for (var l=0;l<aux.options.length;l++){
		var auxOption = aux.options[l];
		var optionDOM = new Element('option');
		optionDOM.setProperty('value',auxOption.value);
		optionDOM.appendText(auxOption.text);
		if (auxOption.selected){
			optionDOM.setProperty('selected',"selected");
		}
		if (auxOption.validFor!=null){
			//optionDOM.setAttribute('validFor',auxOption.validFor);
			optionDOM.set('validFor', auxOption.validFor);
		}
		optionDOM.inject(domElement);
	}
	if (aux.onchange!=null && aux.onchange!=''){
		//domElement.setAttribute('onchange',aux.onchange);
		domElement.set('onchange', aux.onchange);
	}
	return domElement;
}

function loadWhereUser(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadWhereUser&isAjax=true' + TAB_ID_REQUEST,	
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); addScrollTable($('tableBodyUser')); SYS_PANELS.closeAll(); }
	}).send();
}

var lCount=0;
function processLoadWhereUser(){
	var resXml = getLastFunctionAjaxCall(); 
	var tableDOM = resXml.getElementsByTagName("table");
	if (tableDOM!=null){
		var rows = tableDOM.item(0).getElementsByTagName("row");
		var arrayRow = new Array();
		for (var i=0;i<rows.length;i++){
			var row = rows.item(i);
			var displayRow = toBoolean(row.getAttribute("display")==null?"true":row.getAttribute("display"));
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
			addRowWhereUser($('tableBodyUser'),arrayTd,displayRow);			
		}		
	}
	toogleLastTr("tableBodyUser");
}

