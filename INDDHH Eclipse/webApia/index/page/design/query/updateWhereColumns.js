
function previewWhereFilter_click() {
	var result = "";
	var grid = $("tblWhereBody");

	if (grid != null) {
		for (var i = 0; i < grid.rows.length; i++) {
			if (QRY_ALLOW_ATT && i == 0) continue;
		
			var row = grid.rows[i];
			var filterType = row.cells[3].getElementsByTagName("SELECT")[0];//cmbWheFilter
			
			if (filterType != null) {
				if (result != "") {
					result += row.cells[0].getElementsByTagName("SELECT")[0].options[row.cells[0].getElementsByTagName("SELECT")[0].selectedIndex].text + " "; //operador
				}
				
				result += "<b>" + row.cells[1].getElementsByTagName("INPUT")[0].value + "</b> "; //parentesis cmbParStar
				result += row.cells[0].getElementsByTagName("INPUT")[4].value + " "; //columna hidWheColName
				result += filterType.options[filterType.selectedIndex].text + " "; //condici�n
				
				if (filterType.options[filterType.selectedIndex].value == COLUMN_FILTER_NULL || filterType.options[filterType.selectedIndex].value == COLUMN_FILTER_NOT_NULL) {
				} else {
					if (row.cells[4].getElementsByTagName("SELECT")[0].selectedIndex == 0) {//cmbWheTip
						result += row.cells[4].getElementsByTagName("INPUT")[0].value + " ";//txtWheVal
					} else {
						result += row.cells[4].getElementsByTagName("SELECT")[1].options[row.cells[4].getElementsByTagName("SELECT")[1].selectedIndex].text + " "; //value de funci?n cmbColFun
					}
				}
		
				result += "<b>" + row.cells[6].getElementsByTagName("INPUT")[0].value + "</b> "; //parentesis cmbParend
			}
		}
		
		$("previewWhere").innerHTML = result;
		
		return validateParentesis();
	}
}

function checkCmbWheFilter() {
	var cmbs = document.getElementsByTagName("select");
	if (cmbs != null) {
		for (var i = 0; i < cmbs.length; i++) {
			if (cmbs[i].name == "cmbWheFilter") {
				cmbWheFil_change(cmbs[i]);
			}
		}
	}
}

function cmbWheFil_change(cmb) {
	var td = cmb.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var tdAux=td;
	var index=parseInt(td.cellIndex);
	/*
	if(window.event){
		index++;
	}
	*/
	td=td.parentNode.cells[index+1];
	td.getElementsByTagName("DIV")[0].style.display = (cmb.options[cmb.selectedIndex].value == COLUMN_FILTER_NULL || cmb.options[cmb.selectedIndex].value == COLUMN_FILTER_NOT_NULL)?"none":"inline";
	if ((cmb.options[cmb.selectedIndex].value == COLUMN_FILTER_NULL || cmb.options[cmb.selectedIndex].value == COLUMN_FILTER_NOT_NULL)) {
		var cmbFun = td.childNodes[0].getElementsByTagName("select")[0];
		var txtVal = cmbFun.nextSibling.nextSibling;
		//unsetRequiredField(txtVal.parentNode.getElementsByTagName("INPUT")[0]);
		$('frmData').formChecker.dispose(txtVal.parentNode.getElementsByTagName("INPUT")[0]);
	} else {
		var cmbFun = td.getElementsByTagName("select")[0];
		var txtVal = cmbFun.nextSibling.nextSibling;
		if(txtVal.parentNode.getElementsByTagName("INPUT")[0].style.display!="none"){
			//setRequiredField(txtVal.parentNode.getElementsByTagName("INPUT")[0]);
			$('frmData').formChecker.register(txtVal.parentNode.getElementsByTagName("INPUT")[0]);
		}else{
			//unsetRequiredField(txtVal.parentNode.getElementsByTagName("INPUT")[0]);
			$('frmData').formChecker.dispose(txtVal.parentNode.getElementsByTagName("INPUT")[0]);
		}
		cmbWheTip_change(td.getElementsByTagName("SELECT")[0]);
	}
}

function validateParentesis() {
	var grid = $("tblWhereBody");
	if (grid == null) return true;
	
	var valid = true;
	var openSoFar = 0;
	var openLast = 0;
	var closeSoFar = 0;
	var closeLast = 0;
	
	var lastOpen = null;
	var lastClose = null;
	
	var lastIdOpen = -1;
	var lastIdClose = -1;
	
	var firstError = null;
	
	for (var i = 0; i < grid.rows.length; i++) {
		var row = grid.rows[i];
		
		var actualOpen = row.cells[1].getElementsByTagName("INPUT")[0];
		var actualClose = row.cells[6].getElementsByTagName("INPUT")[0];
		
		actualOpen.style.backgroundColor = "#FFFFFF";
		actualClose.style.backgroundColor = "#FFFFFF";
		
		openLast = actualOpen.value.length;
		closeLast = actualClose.value.length;

		if (openLast > 0) {
			lastOpen = actualOpen;
			lastIdOpen = i;
		}
		if (closeLast > 0) {
			lastClose = actualClose;
			lastIdClose = i;
		}

		openSoFar += openLast;
		
		if (closeLast > 0 && (closeSoFar + closeLast) > openSoFar) {
			actualClose.style.backgroundColor = "#FF0000";
			if (firstError == null) firstError = actualClose;
			valid = false;
		}
		
		closeSoFar += closeLast;
	}
	
	if (openSoFar > closeSoFar) {
		lastOpen.style.backgroundColor = "#FF0000";
		if (firstError == null) firstError = lastOpen;
		valid = false;
	}
	if (lastIdOpen > lastIdClose) {
		lastOpen.style.backgroundColor = "#FF0000";
		if (firstError == null) firstError = lastOpen;
		valid = false;
	}
	
	if (lastOpen != null && lastClose != null && lastOpen.value.length > lastClose.value.length) {
		lastOpen.style.backgroundColor = "#FF0000";
		if (firstError == null) firstError = lastOpen;
		valid = false;
	}
	
	if (! valid) {
		showMessage(ERR_NOT_VALID_FILTER);
		if (firstError != null) firstError.focus();
	}
	
	return valid;
}

function loadWhere(){
	if (!QRY_FREE_SQL_MODE){
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=loadWhere&isAjax=true' + TAB_ID_REQUEST,	
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { 
				modalProcessXml(resXml); 
				Scroller_tblWhereBody = addScrollTable($('tblWhereBody')); 
				SYS_PANELS.closeAll(); 
			}
		}).send();
	}
}

var lCount=0;
function processLoadWhere(){
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
				if (type=="td-div"){
					auxTd = processWhereTdDiv(cell);
					arrayTd.push({'display':tdDisplay,'type':'td-div',arr:auxTd});				
				}else{
					auxTd = processTd(cell);
					arrayTd.push({'display':tdDisplay,'type':'td',arr:auxTd});				
				}			
				k +=lCount;
				k++;
			}			
			arrayRow.push(arrayTd);			
		}
		addRowWhere($('tblWhereBody'),arrayRow);
	}
	toogleLastTr("tblWhereBody");
}

function processWhereTdDiv(td){
	var tdDisplay = td.getAttribute("display");
	
	var dispFirstDiv = td.getAttribute("dispFirstDiv");
	var dispSecondDiv = td.getAttribute("dispSecondDiv");
	
	var cells = td.getElementsByTagName("cell");
	var i=0;
	var arrayCell = new Array();
	var arrayTd = new Array();
	var arrDiv = new Array();
	
	while (i<cells.length){
		var cc = cells[i];		
		var ccType = cc.getAttribute("type");	
		
		var display = cc.getAttribute("display");
		var isRequired = toBoolean(cc.getAttribute("required"));
		var validation = cc.getAttribute("validation");
		
		var firstChild = cc.firstChild;		
		
		if (ccType!="text"){
			var ccName = firstChild.getAttribute("name");
			var ccId = firstChild.getAttribute("id");
		}
		
		if (ccType =="input"){
			var aux = {'type':'text',name:ccName,id:ccId,'required':isRequired,value:firstChild.getAttribute("value"),'display':display,'validation':validation};
			arrayCell.push({'display':dispFirstDiv,td:arrDiv});
			arrDiv = new Array();
			arrDiv.push(aux);
			arrayCell.push({'display':dispSecondDiv,td:arrDiv});
			break;
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
				
				arrayOptions.push({'value':optionValue,'text':optionText,'selected':selected});							
			}
			var aux = {'type':'combo',name:ccName,id:ccId,'required':isRequired,'options':arrayOptions,'display':display,onchange:firstChild.getAttribute('onChange')};
		}
		arrDiv.push(aux);
		i++;
	}
	lCount = 3;
	return arrayCell;
}

function addRowWhere(table,arrTable,scroll){
	var parent = table.getParent();
	table.selectOnlyOne = false;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (tdWidths[i] == null || tdWidths[i] == undefined || tdWidths[i] == "") 
				tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) 
				tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	
	for (var i=0;i<arrTable.length;i++){
		var row = arrTable[i];
		var rowDOM = new Element('tr');
		for (var j=0;j<row.length;j++){
			var td = row[j];
			var div = new Element('div',{styles:{'width': Number.from(tdWidths[j])}});
			if (td.type=="td-div"){
				d = addRowWhereTdDiv(td,div);
			}else{
				d = addRowWhereTd(td,div);
			}
			
			/*if (div.scrollWidth > div.offsetWidth) {
				td.title = content;
				td.addClass("titiled");
			}*/
			
			var tdDOM = new Element('td',{styles:{'display':td.display}});
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
		
		rowDOM.inject(table);		
	}
	
	
}

function addRowWhereTd(temp,div){
	var td = temp.arr;
	for (var i=0;i<td.length;i++){
		var aux = td[i];
		if (aux.type=="text") {
			domElement = new Element('input',{type:'text',name:aux.name,id:aux.id,'onkeypress':aux.onkeypress});
			//domElement.setAttribute("value",aux.value);
			domElement.set("value", aux.value);
		} else if (aux.type=="checkbox") {
			domElement = new Element('input',{type:'checkbox',name:aux.name,id:aux.id,checked:aux.checked});
		} else if (aux.type=="hidden") {
			domElement = new Element('input',{type:'hidden',name:aux.name,id:aux.id});
			//domElement.setAttribute("value",aux.value);
			domElement.set("value", aux.value);
		} else if (aux.type=="span") {
			domElement = new Element('span',{html:aux.html});
		} else if (aux.type=="combo") {
			domElement = getSelect(aux);
		}								
		
		if(domElement.get('name') == 'cmbParStar' || domElement.get('name') == 'cmbParEnd')
			domElement.setStyles({
				'width': '50%',
				'margin-left': '10px'
			});
		else
			domElement.setStyle("width","95%");
		domElement.inject(div);
		severalProperties(domElement, aux);
	}
	return div;
}

function addRowWhereTdDiv(temp,div){	
	var td = temp.arr;
	
	var firstDiv = td[0];
	
	var aux = firstDiv.td[0];
	
	var d = new Element('div',{styles:{display:firstDiv.display,'white-space':'nowrap','float':'left'}});
	domElement = getSelect(aux);
	
	if (aux.display!=null && aux.display!=""){
		//domElement.setAttribute('style','display:'+aux.display);
		domElement.setStyle('display', aux.display);
	}						
	domElement.inject(d);
	d = setRequired(aux,domElement,d);	
	d.inject(div);
	
	aux = firstDiv.td[1];
	
	domElement = getSelect(aux);	
	if (aux.display!=null && aux.display!=""){
		//domElement.setAttribute('style','display:'+aux.display);
		domElement.setStyle('display', aux.display);
	}						
	domElement.inject(d);
	d = setRequired(aux,domElement,d);	
	d.inject(div);
	
	var secondDiv = td[1];
	aux = secondDiv.td[0];
	
	d = new Element('div',{styles:{display:secondDiv.display,'white-space':'nowrap','float':'left'}});
	domElement = new Element('input',{type:'text',name:aux.name,id:aux.id});
	if (aux.display!=null && aux.display!=""){
		//domElement.setAttribute('style','display:'+aux.display);
		domElement.setStyle('display', aux.display);
	}
	//domElement.setAttribute("value",aux.value);
	domElement.set("value",aux.value);
	domElement.inject(d);
	d = setRequired(aux,domElement,d);

	d.inject(div);
	
	return div;
}

function setRequired(aux,domElement,div){
	if (aux.required){
		new Element('span',{html:"&nbsp;*"}).inject(div);
		if (aux.validation!=null){
			if (aux.validation=="number"){
				registerValidation(domElement,"validate['required','number']");
			}
		}else{
			registerValidation(domElement,null);
		}		
	}
	return div;
}

function getSelect(aux){
	var domElement = new Element('select',{id:aux.id,name:aux.name});
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
	if (aux.onchange!=null && aux.onchange!=''){
		//domElement.setAttribute('onchange',aux.onchange);
		domElement.set('onchange', aux.onchange)
	}
	return domElement;
}

function processColumnsModalReturnWhere(ret){
	var notAllowAux = new Array();
	for (var i = 0; i < ret.length; i++){
		var e = ret[i];	
		var text = e.getRowContent()[0];
		if (! inNotAllowed(text)) {
			generateWhere('',text,text,e.getAttribute("type"),QRY_DB_TYPE_COL,"",true);
		} else {
			notAllowAux.push(text);
		}
	}
	Scroller_tblWhereBody = addScrollTable($('tblWhereBody'));
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

function generateWhere(val0,val1,val2,val3,val4,val5,scroll) {
	//val0;hidWheAttId
	//val1;hidWheColName
	//val3;hidWheDatType
	//val4;hidWheDbType	
	
	var arrayRow = new Array();
	var arrayTd = new Array();
	var arrayCell = new Array();	

	//Fila
	arrayCell.push({'type':'hidden',name:'chkWhereSel',id:'chkWhereSel'});
	arrayCell.push({'type':'hidden',name:'hidWheColId',id:'hidWheColId',value:''});
	arrayCell.push({'type':'hidden',name:'hidWheAttId',id:'hidWheAttId',value:val0});
	arrayCell.push({'type':'hidden',name:'hidWheDatType',id:'hidWheDatType',value:val3});
	arrayCell.push({'type':'hidden',name:'hidWheColName',id:'hidWheColName',value:val1});
	arrayCell.push({'type':'hidden',name:'hidWheDbType',id:'hidWheDbType',value:val4});	
	arrayCell.push({'type':'hidden',name:'hidWheParId',id:'hidWheParId',value:val5});
	
	var arrayOptions = new Array();	
	arrayOptions.push({'value':'0','text':'AND','selected':false});	
	arrayOptions.push({'value':'1','text':'OR','selected':false});
	var aux = {'type':'combo',name:'cmbOperId',id:'cmbOperId','required':false,'options':arrayOptions,display:''};	
	arrayCell.push(aux);
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});	
	

	//Fila
	arrayCell = new Array();
	
	arrayCell.push({'type':'text',name:'cmbParStar',id:'cmbParStar','onkeypress':'return validkey(true,event)',value:''});
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	arrayCell.push({'type':'span',html:val1});
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	
	//Fila
	arrayCell = new Array();
	
	arrayOptions = new Array();	
	if (val3 != COLUMN_DATA_STRING) {
		arrayOptions.push({'value':COLUMN_FILTER_LESS,'text':lblQryFilLess,'selected':false});
		arrayOptions.push({'value':COLUMN_FILTER_MORE,'text':lblQryFilMore,'selected':false});
	}
	arrayOptions.push({'value':COLUMN_FILTER_EQUAL,'text':lblQryFilEqual,'selected':false});
	arrayOptions.push({'value':COLUMN_FILTER_DISTINCT,'text':lblQryFilDis,'selected':false});
	if (val3 != COLUMN_DATA_STRING) {
		arrayOptions.push({'value':COLUMN_FILTER_LESS_EQUAL,'text':lblQryFilLessE,'selected':false});
		arrayOptions.push({'value':COLUMN_FILTER_MORE_EQUAL,'text':lblQryFilMoreE,'selected':false});
	}
	if (val3 == COLUMN_DATA_STRING) {
		arrayOptions.push({'value':COLUMN_FILTER_LIKE,'text':lblQryFilLike,'selected':false});
		arrayOptions.push({'value':COLUMN_FILTER_NOT_LIKE,'text':lblQryFilNotLike,'selected':false});
		arrayOptions.push({'value':COLUMN_FILTER_START_WITH,'text':lblQryFilStartWith,'selected':false});
	}
	arrayOptions.push({'value':COLUMN_FILTER_NULL,'text':lblQryFilNull,'selected':false});
	arrayOptions.push({'value':COLUMN_FILTER_NOT_NULL,'text':lblQryFilNotNull,'selected':false});
	
	var aux = {'type':'combo',name:'cmbWheFilter',id:'cmbWheFilter','required':false,'options':arrayOptions,display:'','onchange':'cmbWheFil_change(this)'};
	arrayCell.push(aux);
	arrayTd.push({'display':QRY_TO_PROCEDURE?"none":"",arr:arrayCell,'type':'td'});	
	
	//Fila
	arrayCell = new Array();
	
	arrayOptions = new Array();	
	arrayOptions.push({'value':COLUMN_TYPE_FILTER,'text':lblQryVal,'selected':true});	
	arrayOptions.push({'value':COLUMN_TYPE_FUNCTION,'text':lblQryFunc2,'selected':false});
	var aux = {'type':'combo',name:'cmbWheTip',id:'cmbWheTip','required':false,'options':arrayOptions,display:'','onchange':'cmbWheTip_change(this)'};	
	arrayCell.push(aux);
	
	arrayOptions = new Array();	
	if (val3 == COLUMN_DATA_DATE) {
		arrayOptions.push({'value':FUNCTION_DATE_EQUAL,'text':lblQryFunDteEqu,'selected':false});	
	} else if (val3 == COLUMN_DATA_NUMBER) {
		arrayOptions.push({'value':FUNCTION_ENV_ID,'text':lblQryFunEnvId,'selected':false});	
	} else if (val3 == COLUMN_DATA_STRING) {
		arrayOptions.push({'value':FUNCTION_ENV_NAME,'text':lblQryFunEnvName,'selected':false});	
		arrayOptions.push({'value':FUNCTION_USER,'text':lblQryFunUser,'selected':false});	
	}
		
	/*arrayOptions.push({'value':COLUMN_TYPE_FUNCTION,'text':lblQryFunc2,'selected':false});*/
	var aux = {'type':'combo',name:'cmbColFun',id:'cmbColFun','required':false,'options':arrayOptions,display:'none','onchange':'cmbWheTip_change(this)'};	
	arrayCell.push(aux);
	
	arrayCell.push({'type':'text',name:'txtWheVal',id:'txtWheVal','required':true,value:'','validation':val3 == COLUMN_DATA_DATE?'datepicker':val3 == COLUMN_DATA_NUMBER?'number':'','width':'45%'});
	
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});
	/*if (val3 == COLUMN_DATA_DATE) {
		var input=oTd3.getElementsByTagName("DIV")[0].getElementsByTagName("DIV")[0].getElementsByTagName("INPUT")[0];	
		//setMask(input,input.getAttribute("p_mask"));
	}*/

	
	//Fila
	arrayCell = new Array();
	
	arrayOptions = new Array();	
	if (addEntAttOpt) {
		arrayOptions.push({'value':'1','text':lblQryAttFromEnt,'selected':false});
	}
	if (addProAttOpt) {
		arrayOptions.push({'value':'0','text':lblQryAttFromPro,'selected':false});
	}
	if (!(addEntAttOpt || addProAttOpt)) {
		arrayOptions.push({'value':'-1','text':'','selected':false});
	}
	arrayOptions.push({'value':'1','text':'OR','selected':false});
	var aux = {'type':'combo',name:'cmbWheAttFrom',id:'cmbWheAttFrom','required':false,'options':arrayOptions,display:(val0 == null || val0 == "" || ! (addEntAttOpt && addProAttOpt))?'none':''};	
	arrayCell.push(aux);
	arrayTd.push({'display':! showAttFrom?'none':'',arr:arrayCell,'type':'td'});	
	
	//Fila
	arrayCell = new Array();
	
	arrayCell.push({'type':'text',name:'cmbParEnd',id:'cmbParEnd','onkeypress':'return validkey(false,event)',value:''});
	arrayTd.push({'display':'',arr:arrayCell,'type':'td'});	

	arrayRow.push(arrayTd);
	addRowWhere($('tblWhereBody'),arrayRow,scroll);
	
	//cmbWheTip_change(oTd3.getElementsByTagName("DIV")[0].getElementsByTagName("SELECT")[0]);
	
	toogleLastTr("tblWhereBody");
}

function validkey(startPar, event) {
	var keynum = null;
	if(window.event) {
		keynum = event.keyCode
	} else if (event.which) {
		keynum = event.which
	}
	return keynum == null || keynum == 8 || (keynum == 41 && !startPar) || (startPar && keynum == 40);
} 