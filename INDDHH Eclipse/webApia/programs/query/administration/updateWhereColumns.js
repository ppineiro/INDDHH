//---
//--- Funciones para trabajar con las columnas del filtro
//---

function validkey(startPar, event) {
	var keynum = null;
	if(window.event) {
		keynum = event.keyCode
	} else if (event.which) {
		keynum = event.which
	}
	return keynum == null || keynum == 8 || (keynum == 41 && !startPar) || (startPar && keynum == 40);
}

function btnAddWhereAtt_click() {
	var rets = openModal("/programs/modals/dataDictionary.jsp",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				
				if (canAdd(ret[0])) {
					addToAttAdded(ret[0]);
					generateWhere(ret[0],ret[1],ret[2],ret[3],QRY_DB_TYPE_ATT,"");
				}
			}
//			updateWhereParentesis();
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnAddWhere_click() {
	//var rets = openModal("/programs/modals/viewColumns.jsp?viewName=" + QRY_DB_VIEW_NAME,500,300);
	var rets = openModal("/query.AdministrationAction.do?action=addShowColumn&viewName=" + QRY_DB_VIEW_NAME + windowId,500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
	
				trows=document.getElementById("gridWhere").rows;
	
				if (! inNotAllowed(ret[0])) {
					generateWhere('',ret[0],ret[0],ret[1],QRY_DB_TYPE_COL,"");
				} else {
					showMessageOneParam(MSG_COL_NOT_ALLOW,ret[0]);
				}
			}
//			updateWhereParentesis();
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnAddWherePar_click() {
	var rets = openModal("/programs/modals/viewProParam.jsp?viewName=" + QRY_DB_VIEW_NAME,500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridWhere").getRows();
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[4].value == ret[0]) {
						addRet = false;
					}
				}
	
				trows=document.getElementById("gridUser").getRows();
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[4].value == ret[0]) {
						addRet = false;
					}
				}
			
				if (addRet) {
					generateWhere('',ret[0],ret[0],ret[1],QRY_DB_TYPE_PARAM,"");
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnAddWhereBusClaPar_click() {
	var rets = openModal("/programs/modals/busClaParameter.jsp?busClaId=" + BUS_CLA_ID + "&notParType=" + PARAM_IO_OUT,500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridWhere").getRows();
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].cells[0].getElementsByTagName("INPUT")[6].value == ret[0]) {
						addRet = false;
					}
				}
	
				if (addRet) {
					generateWhere("",ret[1],ret[2],ret[3],QRT_DB_TYPE_NONE,ret[0]);
					//ret[0] = busClaParId
					//ret[1] = colName
					//ret[2] = headName
					//ret[3] = type
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}


function btnDelWhere_click() {
	var cant=0

	trows = document.getElementById("gridWhere").getRows();
	document.getElementById("gridWhere").removeSelected();
//	updateWhereParentesis();

	return cant;
}

function generateWhere(val0,val1,val2,val3,val4,val5) {
	//val0;hidWheAttId
	//val1;hidWheColName
	//val3;hidWheDatType
	//val4;hidWheDbType	
	
	var oTr = document.createElement("TR");
	var oTd0; 
	var oTd00;
	var oTdParStart;
	var oTd1;
	var oTd2;
	var oTd3;
	var oTd4;
	var oTdParEnd;
	if (window.navigator.appVersion.indexOf("MSIE")>0){
		for(var i=0;i<8;i++){
			oTr.appendChild(document.createElement("TD"));
		}
		oTd0 = oTr.getElementsByTagName("TD")[0]; 
		oTd00 = oTr.getElementsByTagName("TD")[1]; 
		oTdParStart = oTr.getElementsByTagName("TD")[2]; 
		oTd1 = oTr.getElementsByTagName("TD")[3]; 
		oTd2 = oTr.getElementsByTagName("TD")[4]; 
		oTd3 = oTr.getElementsByTagName("TD")[5]; 
		oTd4 = oTr.getElementsByTagName("TD")[6]; 
		oTdParEnd = oTr.getElementsByTagName("TD")[7]; 
	}else{
		oTd0 = oTr.insertCell(0); 
		oTd00 = oTr.insertCell(1); 
		oTdParStart = oTr.insertCell(2); 
		oTd1 = oTr.insertCell(3); 
		oTd2 = oTr.insertCell(4); 
		oTd3 = oTr.insertCell(5); 
		oTd4 = oTr.insertCell(6); 
		oTdParEnd = oTr.insertCell(7); 
	}

	oTd0.innerHTML = "<input type='hidden' name='chkWhereSel'><input type='hidden' name='hidWheColId' value=''><input type='hidden' name='hidWheAttId'><input type='hidden' name='hidWheDatType'><input type='hidden' name='hidWheColName' value=''><input type='hidden' name='hidWheDbType' value''><input type=hidden name='hidWheParId' value=''>";
	oTd0.style.display="none";
	oTd0.getElementsByTagName("INPUT")[2].value = val0;
	oTd0.getElementsByTagName("INPUT")[3].value = val3;
	oTd0.getElementsByTagName("INPUT")[4].value = val1;
	oTd0.getElementsByTagName("INPUT")[5].value = val4;	
	oTd0.getElementsByTagName("INPUT")[6].value = val5;
	oTd0.align="center";

	var selectOperator = "<select name=\"cmbOperId\"><option value=\"0\">AND</option><option value=\"1\">OR</option></select>";
	oTd00.innerHTML = selectOperator;

	oTdParStart.innerHTML = "<input type=\"text\" name=\"cmbParStar\" size=6 onkeypress=\"return validkey(true,event);\">";
	oTdParEnd.innerHTML = "<input type=\"text\" name=\"cmbParEnd\" size=6  onkeypress=\"return validkey(false,event);\">";

	oTd1.innerHTML = val1;
	
	var select = "";
	select += "<select name='cmbWheFilter' onchange=\"cmbWheFil_change(this)\">";
	if (val3 != COLUMN_DATA_STRING) { select += "<option value='" + COLUMN_FILTER_LESS + "'>" + lblQryFilLess + "</option>"; }
	if (val3 != COLUMN_DATA_STRING) { select += "<option value='" + COLUMN_FILTER_MORE + "'>" + lblQryFilMore + "</option>"; }
	select += "<option value='" + COLUMN_FILTER_EQUAL + "'>" + lblQryFilEqual + "</option>";
	select += "<option value='" + COLUMN_FILTER_DISTINCT + "'>" + lblQryFilDis + "</option>";
	if (val3 != COLUMN_DATA_STRING) { select += "<option value='" + COLUMN_FILTER_LESS_EQUAL + "'>" + lblQryFilLessE + "</option>"; }
	if (val3 != COLUMN_DATA_STRING) { select += "<option value='" + COLUMN_FILTER_MORE_EQUAL + "'>" + lblQryFilMoreE + "</option>"; }
	if (val3 == COLUMN_DATA_STRING) { select += "<option value='" + COLUMN_FILTER_LIKE + "'>" + lblQryFilLike + "</option>"; }
	if (val3 == COLUMN_DATA_STRING) { select += "<option value='" + COLUMN_FILTER_NOT_LIKE + "'>" + lblQryFilNotLike + "</option>"; }
	if (val3 == COLUMN_DATA_STRING) { select += "<option value='" + COLUMN_FILTER_START_WITH + "'>" + lblQryFilStartWith + "</option>"; }
	select += "<option value='" + COLUMN_FILTER_NULL + "'>" + lblQryFilNull + "</option>";
	select += "<option value='" + COLUMN_FILTER_NOT_NULL + "'>" + lblQryFilNotNull + "</option>";
	select += "</select>";
			
	oTd2.innerHTML = select;
	oTd2.align = "center";
	if (QRY_TO_PROCEDURE) { 
		oTd2.style.display = "none";
	}

	var type = "<select name=\"cmbWheTip\" onchange=\"cmbWheTip_change(this)\">";
	type += "<option value=\"" + COLUMN_TYPE_FILTER + "\" selected>" + lblQryVal + "</option>";
	type += "<option value=\"" + COLUMN_TYPE_FUNCTION + "\">" + lblQryFunc + "</option>";
	type += "</select>";

	var inputStart = "<input p_required='true' name='txtWheVal' type='text' value='' req_desc='" + val1 + "' ";
	var inputType = "";
	if (val3 == COLUMN_DATA_DATE) {
		inputType = "class=\"txtDate\" size='10' p_mask=\"" + pMask + "\" p_calendar=\"true\" query='true'";
	} else if (val3 == COLUMN_DATA_NUMBER) {
		inputType = "p_numeric='true'";
	} else if (val3 == COLUMN_DATA_STRING) {
		inputType = "maxlength='100'";
	}
	var inputEnd = ">";

	var strCmbColFun;
	strCmbColFun = "<select name=\"cmbColFun\" style=\"display:none\">";

	if (val3 == COLUMN_DATA_DATE) {
		strCmbColFun += "<option value=\"" + FUNCTION_DATE_EQUAL + "\">" + lblQryFunDteEqu + "</option>";
	} else if (val3 == COLUMN_DATA_NUMBER) {
		strCmbColFun += "<option value=\"" + FUNCTION_ENV_ID + "\">" + lblQryFunEnvId + "</option>";
	} else if (val3 == COLUMN_DATA_STRING) {
		strCmbColFun += "<option value=\"" + FUNCTION_ENV_NAME + "\">" + lblQryFunEnvName + "</option>";
		strCmbColFun += "<option value=\"" + FUNCTION_USER + "\">" + lblQryFunUser + "</option>";
	}
	strCmbColFun += "</select>";

	oTd3.innerHTML = "<div style='white-space: nowrap;'>" + type + strCmbColFun + "<div style='white-space: nowrap;'>" + inputStart + inputType + inputEnd + "</div></div>";
	oTd3.style.whiteSpace="nowrap";
	oTd3.align="center";
	if (val3 == COLUMN_DATA_DATE) {
		var input=oTd3.getElementsByTagName("DIV")[0].getElementsByTagName("DIV")[0].getElementsByTagName("INPUT")[0];	
		//setMask(input,input.getAttribute("p_mask"));
	}

	var strCmbAttFrom;
	strCmbAttFrom = "<select name=\"cmbWheAttFrom\"";
	if (val0 == null || val0 == "" || ! (addEntAttOpt && addProAttOpt)) {
		strCmbAttFrom += "style=\"display:none;\"";
	}
	strCmbAttFrom += ">";

	if (addEntAttOpt) {
		strCmbAttFrom += "<option value=\"1\">" + lblQryAttFromEnt + "</option>";
	}
	if (addProAttOpt) {
		strCmbAttFrom += "<option value=\"0\">" + lblQryAttFromPro + "</option>";
	}
	if (!(addEntAttOpt || addProAttOpt)) {
		strCmbAttFrom += "<option value=\"-1\"></option>";
	}
	strCmbAttFrom += "</select>";

	oTd4.innerHTML = strCmbAttFrom;
	oTd4.align = "center";	
	if (! showAttFrom) {
		oTd4.style.display = "none";
	}

	document.getElementById("gridWhere").addRow(oTr);
	setMasksToNodes(oTr);
	cmbWheTip_change(oTd3.getElementsByTagName("DIV")[0].getElementsByTagName("SELECT")[0]);
	for(var i=0;i<oTr.getElementsByTagName("INPUT").length;i++){if(oTr.getElementsByTagName("INPUT")[i].type=="text"){oTr.getElementsByTagName("INPUT")[i].focus();break;}}
	fixGridsHeader();
}

function validateParentesis() {
	var grid = document.getElementById("gridWhere");
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
		
		var actualOpen = row.cells[2].getElementsByTagName("INPUT")[0];
		var actualClose = row.cells[7].getElementsByTagName("INPUT")[0];
		
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
		alert(ERR_NOT_VALID_FILTER);
		if (firstError != null) firstError.focus();
	}
	
	return valid;
}

function previewWhereFilter_click() {
	var result = "";
	var grid = document.getElementById("gridWhere");

	if (grid != null) {
		for (var i = 0; i < grid.rows.length; i++) {
			if (QRY_ALLOW_ATT && i == 0) continue;
		
			var row = grid.rows[i];
			var filterType = row.cells[4].getElementsByTagName("SELECT")[0];
			
			if (filterType != null) {
				if (result != "") {
					result += row.cells[1].getElementsByTagName("SELECT")[0].options[row.cells[1].getElementsByTagName("SELECT")[0].selectedIndex].text + " "; //operador
				}
				
				result += "<b>" + row.cells[2].getElementsByTagName("INPUT")[0].value + "</b> "; //parentesis
				result += row.cells[0].getElementsByTagName("INPUT")[4].value + " "; //columna
				result += filterType.options[filterType.selectedIndex].text + " "; //condici?n
				
				if (filterType.options[filterType.selectedIndex].value == COLUMN_FILTER_NULL || filterType.options[filterType.selectedIndex].value == COLUMN_FILTER_NOT_NULL) {
				} else {
					if (row.cells[5].getElementsByTagName("SELECT")[0].selectedIndex == 0) {
						result += row.cells[5].getElementsByTagName("INPUT")[0].value + " ";
					} else {
						result += row.cells[5].getElementsByTagName("SELECT")[1].options[row.cells[5].getElementsByTagName("SELECT")[1].selectedIndex].text + " "; //value de funci?n
					}
				}
		
				result += "<b>" + row.cells[7].getElementsByTagName("INPUT")[0].value + "</b> "; //parentesis
			}
		}
		
		document.getElementById("previewWhere").innerHTML = result;
		
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
	if(window.event){
		index++;
	}
	td=td.parentNode.cells[index+1];
	td.getElementsByTagName("DIV")[0].style.display = (cmb.options[cmb.selectedIndex].value == COLUMN_FILTER_NULL || cmb.options[cmb.selectedIndex].value == COLUMN_FILTER_NOT_NULL)?"none":"inline";
	if ((cmb.options[cmb.selectedIndex].value == COLUMN_FILTER_NULL || cmb.options[cmb.selectedIndex].value == COLUMN_FILTER_NOT_NULL)) {
		var cmbFun = td.childNodes[0].getElementsByTagName("select")[0];
		var txtVal = cmbFun.nextSibling.nextSibling;
		unsetRequiredField(txtVal.parentNode.getElementsByTagName("INPUT")[0]);
	} else {
		var cmbFun = td.getElementsByTagName("select")[0];
		var txtVal = cmbFun.nextSibling.nextSibling;
		if(txtVal.parentNode.getElementsByTagName("INPUT")[0].style.display!="none"){
			setRequiredField(txtVal.parentNode.getElementsByTagName("INPUT")[0]);
		}else{
			unsetRequiredField(txtVal.parentNode.getElementsByTagName("INPUT")[0]);
		}
		cmbWheTip_change(td.getElementsByTagName("SELECT")[0]);
	}
}