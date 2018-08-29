//--- Funciones para trabajar con las filas y poderlas cambiar de lugar
function upWhereUsu_click() {
	lastSelectionWhereUsu=document.getElementById("gridUser").selectedItems[0];
	swapGeneric("gridUser",-1);
}

function downWhereUsu_click() {
	lastSelectionWhereUsu=document.getElementById("gridUser").selectedItems[0];
	swapGeneric("gridUser",1);
}

function selectColumnWhereUsu() {
	lastSelectionWhereUsu = selectAColumn(lastSelectionWhereUsu);
}

//---
//--- Funciones para columnas y atributos del filtro del usuario
//---
function btnAddUserAtt_click() {
	var rets = openModal("/programs/modals/dataDictionary.jsp",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridUser").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[2].value == ret[0]) {
						addRet = false;
					}
				}
				
				if (addRet && canAdd(ret[0])) {
					addToAttAdded(ret[0]);
					generateUser(ret[0],ret[1],ret[2],ret[3],QRY_DB_TYPE_ATT,"");
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnAddUserBusClaPar_click() {
	var rets = openModal("/programs/modals/busClaParameter.jsp?busClaId=" + BUS_CLA_ID + "&notParType=" + PARAM_IO_OUT,500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridUser").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[6].value == ret[0]) {
						addRet = false;
					}
				}
				
				if (addRet) {
					generateUser("",ret[1],ret[2],ret[3],QRT_DB_TYPE_NONE,ret[0]);
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

function btnAddUser_click() {
	if (! QRY_FREE_SQL_MODE) {
		var rets = openModal("/query.AdministrationAction.do?action=addShowColumn&viewName=" + QRY_DB_VIEW_NAME + windowId,500,300);
		var doAfter=function(rets){
			if (rets != null) {
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];
					var addRet = true;
					
					trows=document.getElementById("gridUser").getRows();
					for (i=0;i<trows.length && addRet;i++) {
						if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[4].value == ret[0]) {
							addRet = false;
						}
					}
		
					if (addRet) {
						if (! inNotAllowed(ret[0])) {
							generateUser('',ret[0],ret[0],ret[1],QRY_DB_TYPE_COL,"");
						} else {
							showMessageOneParam(MSG_COL_NOT_ALLOW,ret[0]);
						}
					}
				}
			}
		}
		rets.onclose=function(){
			doAfter(rets.returnValue);
		}
	} else {
		generateUser('','','','',QRY_DB_TYPE_COL,"");
	}
}

function btnAddUserPar_click() {
	var rets = openModal("/programs/modals/viewProParam.jsp?viewName=" + QRY_DB_VIEW_NAME,500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridUser").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[4].value == ret[0]) {
						addRet = false;
					}
				}
			
				trows=document.getElementById("gridWhere").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[4].value == ret[0]) {
						addRet = false;
					}
				}
			
				if (addRet) {
					generateUser('',ret[0],ret[0],ret[1],QRY_DB_TYPE_PARAM,"");
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnDelUser_click() {
	var cant=0
	document.getElementById("gridUser").removeSelected();

	return cant;
}

function addFreeSqlEvents(tr) {
	if (! QRY_FREE_SQL_MODE) return;
	
	var tds = tr.getElementsByTagName("TD");
	
	var inputType		= tds[2].getElementsByTagName("SELECT")[0];//SELECT
	var inputDefault	= tds[6].getElementsByTagName("INPUT")[0];//INPUT
	var inputCondition	= tds[7].getElementsByTagName("SELECT")[0];//SELECT
	var inputCombox		= tds[9].getElementsByTagName("SELECT")[0];//SELECT
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
	
	addListener(inputType,'change',executeFreeSqlEvent);
	executeFreeSqlvent(inputType);
}

function executeFreeSqlEvent(evt) {
	evt = getEventObject(evt);
	var caller = getEventSource(evt);
	executeFreeSqlvent(caller)
}

function executeFreeSqlvent(caller) {
	var currentValue = caller.options[caller.selectedIndex].value;
	
	caller.inputDefault
	
	if (currentValue == COLUMN_DATA_DATE) {
		unsetNumeric(caller.inputDefault)
		setMask(caller.inputDefault,"nn'/'nn'/'nnnn");
		setDTPicker(caller.inputDefault);
	} else if (currentValue == COLUMN_DATA_STRING) {
		unsetNumeric(caller.inputDefault)
		unsetMask(caller.inputDefault,"nn'/'nn'/'nnnn");
		unsetDTPicker(caller.inputDefault);
	} else if (currentValue == COLUMN_DATA_NUMBER){
		unsetMask(caller.inputDefault,"nn'/'nn'/'nnnn");
		unsetDTPicker(caller.inputDefault);
		setNumeric(caller.inputDefault);		
	} else {
		unsetNumeric(caller.inputDefault)
		unsetMask(caller.inputDefault,"nn'/'nn'/'nnnn");
		unsetDTPicker(caller.inputDefault);
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

function checkWhereUserFilterFreeSql() {
	if (document.getElementById("gridUser")!=null){
		trows=document.getElementById("gridUser").rows;
		for (var i=0;i<trows.length;i++) {
			addFreeSqlEvents(trows[i]);
		}
	}
}

function generateUser(val0,val1,val2,val3,val4,val5) {
	var oTr = document.createElement("TR");
	var oTd0;
	var oTd1;
	var oTd2;
	var oTd3;
	var oTd4;
	var oTd5;
	var oTd51; //condition type
	var oTd6;
	var oTd8;
	var oTd9;
	var oTd10;
	var oTd11;//useUpper
	var oTd12;
	var oTd13; //isReadOnly
	var oTd14; //bus entity
	var oTd15;
	var oTd16 = null; //avoid autofilter
	var oTd17 = null; //tipo de datos de base de datos cuando se está en la sql libre
	
	
	/************************************************/
	/** No cambiar el orden, en caso de hacerlo se **/
	/** debe actualizar el código de la función    **/
	/** addFreeSqlEvents la cual se ejecuta solo   **/
	/** si se está en una consulta de tipo sql     **/
	/** libre.                                     **/
	/************************************************/
	
	if (window.navigator.appVersion.indexOf("MSIE")>0){
		if (QRY_FREE_SQL_MODE) oTd17 = document.createElement("TD");
		for(var i=0;i<(QRY_FREE_SQL_MODE ? 17 : 16);i++){
			if (QRY_FREE_SQL_MODE && i == 2) {
				oTr.appendChild(oTd17);
			} else {
				oTr.appendChild(document.createElement("TD"));
			}
		}
		var request = 0;
		oTd0 = oTr.getElementsByTagName("TD")[request++]; 
		oTd1 = oTr.getElementsByTagName("TD")[request++]; 
		if (QRY_FREE_SQL_MODE) request++;
		oTd2 = oTr.getElementsByTagName("TD")[request++]; 
		oTd3 = oTr.getElementsByTagName("TD")[request++]; 
		oTd4 = oTr.getElementsByTagName("TD")[request++]; 
		oTd5 = oTr.getElementsByTagName("TD")[request++]; 
		oTd51 = oTr.getElementsByTagName("TD")[request++]; 
		oTd6 = oTr.getElementsByTagName("TD")[request++]; 
		oTd8 = oTr.getElementsByTagName("TD")[request++]; 
		oTd9 = oTr.getElementsByTagName("TD")[request++]; 
		oTd10 = oTr.getElementsByTagName("TD")[request++]; 
		oTd11 = oTr.getElementsByTagName("TD")[request++]; 
		oTd12 = oTr.getElementsByTagName("TD")[request++]; 
		oTd13 = oTr.getElementsByTagName("TD")[request++];
		oTd14 = oTr.getElementsByTagName("TD")[request++];
		oTd15 = oTr.getElementsByTagName("TD")[request++];
	}else{
		var request = 0;
		oTd0 = oTr.insertCell(request++); 
		oTd1 = oTr.insertCell(request++); 
		if (QRY_FREE_SQL_MODE) oTd17 = oTr.insertCell(request++); 
		oTd2 = oTr.insertCell(request++); 
		oTd3 = oTr.insertCell(request++); 
		oTd4 = oTr.insertCell(request++); 
		oTd5 = oTr.insertCell(request++); 
		oTd51 = oTr.insertCell(request++); 
		oTd6 = oTr.insertCell(request++); 
		oTd8 = oTr.insertCell(request++); 
		oTd9 = oTr.insertCell(request++);
		oTd10 = oTr.insertCell(request++);
		oTd11 = oTr.insertCell(request++);//useUpper
		oTd12 = oTr.insertCell(request++);
		oTd13 = oTr.insertCell(request++); //isReadOnly
		oTd14 = oTr.insertCell(request++); //bus entity
		oTd15 = oTr.insertCell(request++);
	}
	
	var nextCell = QRY_FREE_SQL_MODE ? 17 : 16;
	if (ADD_AVOID_AUTO_FILTER) {
		if (window.navigator.appVersion.indexOf("MSIE")>0){
			oTd16 = document.createElement("TD");
			oTr.appendChild(oTd16);
		}else{
			oTd16 = oTr.insertCell(nextCell++);
		}
	}
	
	oTd0.innerHTML = "<input type='hidden' name='chkUserSel'><input type='hidden' name='hidUserColId' value=''><input type='hidden' name='hidUserAttId'><input type='hidden' name='hidUserDbType' value=''><input type=hidden name='hidUserParId' value=''>" + (QRY_FREE_SQL_MODE ? "" : "<input type='hidden' name='hidUserColName' value=''><input type='hidden' name='hidUserDatType'>");
	oTd0.style.display="none";
	oTd0.getElementsByTagName("INPUT")[2].value = val0;
	oTd0.getElementsByTagName("INPUT")[3].value = val4;
	oTd0.getElementsByTagName("INPUT")[4].value = val5;
	if (! QRY_FREE_SQL_MODE) {
		oTd0.getElementsByTagName("INPUT")[5].value = val1; //name
		oTd0.getElementsByTagName("INPUT")[6].value = val3; //data type
	}
	oTd0.align="center";

	oTd1.innerHTML = QRY_FREE_SQL_MODE ? "<input p_required='true' type='text' name='hidUserColName'>" : val1;
	
	if (QRY_FREE_SQL_MODE) {
		oTd17.innerHTML = "<select name='hidUserDatType'>" +
							"<option value='" + COLUMN_DATA_STRING + "'>" + LBL_DATA_TYPE_STR + "</option>" +
							"<option value='" + COLUMN_DATA_NUMBER + "'>" + LBL_DATA_TYPE_NUM + "</option>" +
							"<option value='" + COLUMN_DATA_DATE + "'>" + LBL_DATA_TYPE_FEC + "</option>" +
							"</select>";
	}
	oTd2.innerHTML = val1;
	oTd2.style.display = "none";
	
	oTd3.innerHTML = "<input p_required=true name='txtUserHeadName' maxlength='50' type='text' value='"+val2+"'>";
	//oTd3.getElementsByTagName("INPUT")[0].value = val2;
	oTd3.align="center";
	
	oTd4.innerHTML = "<input name='txtUserTool' maxlength='255' type='text'>";
	oTd4.align="center";
	
	var inputStart = "<input name='txtUserVal' type='text' value='' ";
	var inputType = "";
	if (val3 == COLUMN_DATA_DATE) {
		inputType = "class=\"txtDate\" size='10' p_mask=\"" + pMask + "\" p_calendar=\"true\" query='true'";
	} else if (val3 == COLUMN_DATA_NUMBER) {
		inputType = "p_numeric='true'";
	} else if (val3 == COLUMN_DATA_STRING) {
		inputType = "maxlength='100'";
	}
	var inputEnd = ">";
	
	oTd5.innerHTML = inputStart + inputType + inputEnd;
	
	oTd51HTML = "<select name=\"cmbUsuFilter\"><option value=\"\" validFor='all'></option>";
	
	if (val3 == COLUMN_DATA_NUMBER || QRY_FREE_SQL_MODE) {
		oTd51HTML += "<option value=\"" + NUMBER_TYPE_EQUAL + "\" validFor='" + COLUMN_DATA_NUMBER + "'>" + LBL_NUMBER_TYPE_EQUAL + "</option>";
		oTd51HTML += "<option value=\"" + NUMBER_TYPE_LESS + "\" validFor='" + COLUMN_DATA_NUMBER + "'>" + LBL_NUMBER_TYPE_LESS + "</option>";
		oTd51HTML += "<option value=\"" + NUMBER_TYPE_MORE + "\" validFor='" + COLUMN_DATA_NUMBER + "'>" + LBL_NUMBER_TYPE_MORE + "</option>";
		oTd51HTML += "<option value=\"" + NUMBER_TYPE_DISTINCT + "\" validFor='" + COLUMN_DATA_NUMBER + "'>" + LBL_NUMBER_TYPE_DISTINCT + "</option>";
		oTd51HTML += "<option value=\"" + NUMBER_TYPE_LESS_OR_EQUAL + "\" validFor='" + COLUMN_DATA_NUMBER + "'>" + LBL_NUMBER_TYPE_LESS_OR_EQUAL + "</option>";
		oTd51HTML += "<option value=\"" + NUMBER_TYPE_MORE_OR_EQUAL + "\" validFor='" + COLUMN_DATA_NUMBER + "'>" + LBL_NUMBER_TYPE_MORE_OR_EQUAL + "</option>";
	} 
	if (val3 == COLUMN_DATA_STRING || QRY_FREE_SQL_MODE) {
		oTd51HTML += "<option value=\"" + STRING_TYPE_EQUAL + "\" validFor='" + COLUMN_DATA_STRING + "'>" + LBL_STRING_TYPE_EQUAL + "</option>";
		oTd51HTML += "<option value=\"" + STRING_TYPE_STARTS_WITH + "\" validFor='" + COLUMN_DATA_STRING + "'>" + LBL_STRING_TYPE_STARTS_WITH + "</option>";
		oTd51HTML += "<option value=\"" + STRING_TYPE_ENDS_WITH + "\" validFor='" + COLUMN_DATA_STRING + "'>" + LBL_STRING_TYPE_ENDS_WITH + "</option>";
		oTd51HTML += "<option value=\"" + STRING_TYPE_LIKE + "\" validFor='" + COLUMN_DATA_STRING + "'>" + LBL_STRING_TYPE_LIKE + "</option>";
		oTd51HTML += "<option value=\"" + STRING_TYPE_NOT_EQUAL + "\" validFor='" + COLUMN_DATA_STRING + "'>" + LBL_STRING_TYPE_NOT_EQUAL + "</option>";
		oTd51HTML += "<option value=\"" + STRING_TYPE_NOT_STARTS_WITH + "\" validFor='" + COLUMN_DATA_STRING + "'>" + LBL_STRING_TYPE_NOT_STARTS_WITH + "</option>";
		oTd51HTML += "<option value=\"" + STRING_TYPE_NOT_ENDS_WITH + "\" validFor='" + COLUMN_DATA_STRING + "'>" + LBL_STRING_TYPE_NOT_ENDS_WITH + "</option>";
		oTd51HTML += "<option value=\"" + STRING_TYPE_NOT_LIKE + "\" validFor='" + COLUMN_DATA_STRING + "'>" + LBL_STRING_TYPE_NOT_LIKE + "</option>";
	}
	
	oTd51HTML += "</select>";
	oTd51.innerHTML = oTd51HTML;
	
	oTd6.innerHTML ="<select name=\"cmbUserReq\"><option value=\"1\">" + lblYes + "</option><option value=\"0\" selected>" + lblNo + "</option></select>";
	oTd6.align = "center";

 

	oTd8.innerHTML = "<select name=\"cmbColType\" id=\"mbColTypec\"><option value=\"0\">" + lblNo + "</option><option value=\"1\">" + lblYes + "</option><option value=\"2\">" + lblListbox + "</option></select>";
	oTd8.align="center";
	
	oTd9.innerHTML = "<input type='checkbox' name='cmbExecOnCha' id='cmbExecOnCha' value='1'>";
	oTd9.align="center";
	
	oTd10.innerHTML = "<input type='checkbox' name='cmbUserTime' id='cmbUserTime' value='1'>";
	oTd10.align="center";
	if (val3 != COLUMN_DATA_DATE && ! QRY_FREE_SQL_MODE) { 
		oTd10.getElementsByTagName("INPUT")[0].style.display = 'none';
	}

	oTd11.innerHTML = "<input type='checkbox' name='cmbShow2Column' id='cmbShow2Column' value='1'>";
	oTd11.align="center";
	if (val3 == COLUMN_DATA_DATE && ! QRY_FREE_SQL_MODE) { 
		oTd11.getElementsByTagName("INPUT")[0].style.display = 'none';
	}
	
	oTd12.innerHTML = "<input type='checkbox' name='cmbUseUpper' id='cmbUseUpper' value='1'>";
	oTd12.align="center";
	if ((val3 == COLUMN_DATA_DATE || val3 == COLUMN_DATA_NUMBER) && ! QRY_FREE_SQL_MODE) {
		oTd12.getElementsByTagName("INPUT")[0].style.display = 'none';
	}
	
	oTd13.innerHTML = "<input type='checkbox' name='cmbIsReadOnly' id='cmbIsReadOnly' value='1'>";
	oTd13.align="center";
	
	if (val3 == COLUMN_DATA_DATE && ! QRY_FREE_SQL_MODE) {
		oTd14.innerHTML = "<input type=\"hidden\" name=\"cmbBusEntIdFilter\" value=\"\">";
	} else {
		oTd14.innerHTML = "<select name=\"cmbBusEntIdFilter\">" + OPTIONS_BUS_ENTITY_COMBO_STR + "</select>";
	}
	
	oTd15.innerHTML = "<input type='checkbox' name='cmbHidFilSel' id='cmbHidFilSel' value='1'>";
	oTd15.align="center";

	if (ADD_AVOID_AUTO_FILTER) {
		oTd16.innerHTML = "<input type='checkbox' name='cmbFilDontUseAutoFilter' id='cmbFilDontUseAutoFilter' value='1'>";
		oTd16.align="center";
	}
	
	addFreeSqlEvents(oTr);
	document.getElementById("gridUser").addRow(oTr);
	for(var i=0;i<oTr.getElementsByTagName("INPUT").length;i++){if(oTr.getElementsByTagName("INPUT")[i].type=="text"){oTr.getElementsByTagName("INPUT")[i].focus();break;}}
}