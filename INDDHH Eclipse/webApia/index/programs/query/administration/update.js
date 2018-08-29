function checkPeriodicity() {
	var cmbPeri = document.getElementById("cmbPeri");
	var cmbSchAfterSchId = document.getElementById("cmbSchAfterSchId");
	
	if (cmbPeri.selectedIndex != -1 && cmbPeri.options[cmbPeri.selectedIndex].value == perAfterSch) {
		cmbSchAfterSchId.disabled = false;
		setRequiredField(cmbSchAfterSchId);
	} else {
		cmbSchAfterSchId.disabled = true;
		unsetRequiredField(cmbSchAfterSchId);
	}
	
}

function showOtherNode(val, show){
	document.getElementById("radSelected").value = val;
	if (!show){
		document.getElementById("txtExeNode").value = "";
		document.getElementById("txtExeNode").disabled = true;
	}else{
		document.getElementById("txtExeNode").disabled = false;
	}
}

//boton de siguiente
function btnConf_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "query.AdministrationAction.do?action=updateData";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnAnt_click() {
	document.getElementById("frmMain").action = "query.AdministrationAction.do?action=previous";
	submitForm(document.getElementById("frmMain"));
}

function btnConfData_click(doConfirm){
	if (verifyRequiredObjects() && validateParentesis() && wsOk()) {
		if(isValidName(document.getElementById("txtName").value)){
			//processCmbColType();
			processcmbExecOnCha();
			processCmbUserTime();
			processCmbShow2Column();
			processCmbShoTime();
			processCmbIsHTML();
			processCmbJoinAttValues();
			processCmbDontExport();
			processCmbUseUpper();
			processCmbHidFilSel();
			processCmbFilDontUseAutoFilter();
			processActVieQryToAllowAutoFilter();
			processCmbDontUseAutoFilter();
			processCmbHidChtId();
			
			processCmbIsReadOnly();
	
			document.getElementById("frmMain").action = "query.AdministrationAction.do?action=" + (doConfirm ? "confirm" : "test");
			submitForm(document.getElementById("frmMain"));
		}	
	}
}

function wsOk(){
	if((document.getElementById("chkPubWs") != null) && document.getElementById("chkPubWs").checked){
		if(document.getElementById("gridShows").rows.length < 1){
			alert(msgWsShowCols);
			return false;
		}
	}
	return true;
}

function cmbSource_change(){
	document.getElementById("frmMain").action = "query.AdministrationAction.do?action=source";
	submitForm(document.getElementById("frmMain"));
}

function selViewName_change() {
	document.getElementById("frmMain").action = "query.AdministrationAction.do?action=checkView";
	submitForm(document.getElementById("frmMain"));
}

function selBusClass_change() {
	document.getElementById("frmMain").action = "query.AdministrationAction.do?action=checkBusClass";
	submitForm(document.getElementById("frmMain"));
}

function btnSig_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "query.AdministrationAction.do?action=updateData";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}

function btnBack_click() {
	if (canWrite()){
		var msg = confirm(GNR_PER_DAT_ING);
		if (msg) {
			document.getElementById("frmMain").action = "query.AdministrationAction.do?action=backToList";
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "query.AdministrationAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}

}

function showChecked(element) {
	element.previousSibling.value = element.checked?1:0;
}

//---
//--- Funciones utilizadas en la administraci?n de la consulta
//---
function btnConfData2_click() {
	if (document.getElementById("selQryTyp").value == QRY_TYPE_MODAL && document.getElementById("tblShows").rows.length <= 0) {
		alert(MSG_QRR_REQ_COL_SEL_MOD);
	} else {
		btnConfData_click(true);
	}
}

function btnTest_click() {
	if (document.getElementById("selQryTyp").value == QRY_TYPE_MODAL && document.getElementById("tblShows").rows.length <= 0) {
		alert(MSG_QRR_REQ_COL_SEL_MOD);
	} else {
		btnConfData_click(false);
	}
}


//---
//--- Funciones para poder mover las filas de lugar
//---
var lastSelectionShowUsu = null;
function upShowUsu_click() {
	lastSelectionShowUsu=document.getElementById("gridShows").selectedItems[0];
	swapGeneric("gridShows",-1);
	changeHiddenAtts();
	//loadShowCols();
}

function downShowUsu_click() {
	lastSelectionShowUsu=document.getElementById("gridShows").selectedItems[0];
	swapGeneric("gridShows",1);
	changeHiddenAtts();
	//loadShowCols();
}

function swapShowUsu(pos1, pos2) {
	pos1--;
	pos2--;
	document.getElementById("gridShows").swapRows(pos1, pos2);
	//loadShowCols(); //si se llega a usar esta funcion, usar changeHiddenAtts() en vez de loadShowCols.
}


var lastSelectionWhereUsu = null;

function swapWhereUsu(pos1, pos2) {
	pos1--;
	pos2--;
	document.getElementById("gridUser").swapRows(pos1,pos2);
}

var lastSelectionWhere = null;

function upWhere_click() {
	lastSelectionWhere=document.getElementById("gridWhere").selectedItems[0];
	swapGeneric("gridWhere",-1);
}

function downWhere_click() {
	lastSelectionWhere=document.getElementById("gridWhere").selectedItems[0];
	swapGeneric("gridWhere",1);
}

function swapWhere(pos1, pos2) {
	pos1--;
	pos2--;
	document.getElementById("gridWhere").swapRows(pos1,pos2);
}

function swapGeneric(gridName, shift) {
	var grid=document.getElementById(gridName);
	var element=grid.selectedItems[0];
	if ((element != null)&&(grid.selectedItems.length == 1)){
		var index = element.rowIndex;
		if((index + shift > 0) && (index + shift <= grid.rows.length)){
			index--;
			document.getElementById(gridName).swapRows(index,index + shift);
		}
	}
}

function findRow(e) {
	if (e.tagName == "TR" && e.rowIndex!=0) {
		return e;
	} else if (e.tagName == "BODY") {
		return null;
	} else {
		return findRow(e.parentNode);
	}
}

function findCell(e) {
	if (e == null) {
		return null;
	} else if (e.tagName == "TD") {
		return findRow(e.parentNode);
	} else if (e.tagName == "BODY") {
		return null;
	} else {
		return findCell(e.parentNode);
	}
}

//---
//--- Funciones para trabajar con atributos
//---
function insideAtt(value) {
	var inside = false;
	for (var i = 0; i < attAdded.length && ! inside; i++) {
		if (attAdded[i] == value) {
			inside = true;
		}
	}
	return inside;
}

function inNotAllowed(value) {
	var inside = false;
	value = value.toUpperCase();
	for (var i = 0; i < notAllowed.length && ! inside; i++) {
		if (notAllowed[i] == value) {
			inside = true;
		}
	}
	return inside;
}

function incAttAdded(value) {
	for (var i = 0; i < attAdded.length; i++) {
		if (attAdded[i] == value) {
			attCount[i] += 1;
		}
	}
}
	
function addToAttAdded(value) {
	if (! insideAtt(value)) {
		attAdded[attAdded.length] = value;
		attCount[attCount.length] = 1;
	} else {
		incAttAdded(value);
	}
}
	
function canAdd(value) {
	if (insideAtt(value)) {
		return true;
	} else if (attAdded.length < GNR_MAX_ATTRIBUTE) {
		return true;
	} else {
		alert(MSG_QRY_MAX_ATT);
		return false;
	}
}

function sortChange(event) {
	var attValue;
	var attSelect;
	event=getEventObject(event);
	var src=getEventSource(event);
	var row=src.parentNode;
	while(row.tagName!="TR"){row=row.parentNode;}
	attValue = row.cells[0].getElementsByTagName("INPUT")[1].value;
	attSelect = row.cells[3].getElementsByTagName("INPUT")[0];
	if (attValue != "") {
		if (attSelect.value == "") {
			if (insideAtt(attValue)) {
				removeAtt(attValue);
			}
		} else {
			if (canAdd(attValue)) {
				addToAttAdded(attValue);
			} else {
				attSelect.value = "";
			}
		}
	}
}

function removeAtt(value) {
	var sacar = false;
	var pos = -1;
	for (var i = 0; (i < attAdded.length) && ! sacar; i++) {
		if (attAdded[i] == value) {
			attCount[i] -= 1;
			if (attCount[i] == 0) {
				sacar = true;
				pos = i;
			}
		}
	}
	
	if (sacar) {
		var newAttAdded = new Array();
		var newAttCount = new Array();
		for (var i = 0; i < attAdded.length; i++) {
			if (i != pos) {
				newAttAdded[newAttAdded.length] = attAdded[i];
				newAttCount[newAttAdded.length] = attCount[i];
			}
		}
		
		attAdded = newAttAdded;
		attCount = newAttCount;
	}
}

//---
//--- Funciones para consultas de tipo modal
//---
function loadShowCols() {
	/*var selectedIndex=document.getElementById("selQryTyp").value;
	if (document.getElementById("selQryTyp").value== QRY_TYPE_MODAL || document.getElementById("selQryTyp").value == QRY_TYPE_ENTITY_MODAL) {
		var modValue = document.getElementById("selQryColIdModValue");
		if(modValue.tagName=="INPUT"){
			return;
		}
		var modText = document.getElementById("selQryColIdModText");
		var selValue;
		var setText;
		var posValue = (modValue.tagName == "SELECT")?modValue.selectedIndex:-1;
		var hidValue = (modValue.tagName == "INPUT")?modValue.value:-1;
		var posText = modText.selectedIndex;
		var trows2 = document.getElementById("gridShows").rows;
		var option;
		var td;
	
		if (posValue > -1) {
			selValue = modValue.options[posValue].text;
		} else {
			selValue = "";
			posValue = 0;
		}
		if (posText > -1) {
			selText = modText.options[posText].text;
		} else {
			selText = "";
			posText = 0;
		}
		if(modValue.tagName=="SELECT"){
			while (modValue.options.length > 0) { 
				modValue.removeChild(modValue.options[0])
			}
		}
		if(modText.tagName=="SELECT"){
			while (modText.options.length > 0) { 
				modText.removeChild(modText.options[0]); 
			}
		}

		for (i = 0; i < trows2.length; i++) {
			td = trows2[i].getElementsByTagName("TD")[1];
			if(td.getElementsByTagName("SPAN")[0]){
				td=td.getElementsByTagName("SPAN")[0];
			}
			option = document.createElement("OPTION"); 
			option.value = i;
			//option.text = td.childNodes[2].innerHTML.split("<BR>")[1];
			option.text = getCellInnerHTML(td);
			if(modValue.tagName=="SELECT"){
				modValue.options.add(option);
			}
			if (option.text == selValue) {
				posValue = i;
			}

			option = document.createElement("OPTION"); 
			option.value = i;
			option.text = getCellInnerHTML(td);
			if(modText.tagName=="SELECT"){
				modText.options.add(option);
			}
			if (option.text == selText) {
				posText = i;
			}
		}
	
		if (posValue >= trows2.length) {
			posValue = 0;
		}
		if (posText >= trows2.length) {
			posText = 0;
		}
	
		modValue.value = posValue;
		modText.value = posText;
	}*/
}

//---
//--- Funciones de las columnas a ser mostradas
//---
function btnAddShowAtt_click() {
	//var rets = openModal("/programs/modals/dataDictionary.jsp",500,300);
	var rets = openModal("/query.AdministrationAction.do?action=addAttColumn" + windowId,500,300);
	
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridShows").getRows();
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[2].value == ret[0]) {
						addRet = false;
					}
				}
		
	//			if (addRet && canAdd(ret[0])) {
				if (addRet) {
					if (ret[0] != "") {
						attInsert ++;
					}
					generateShow(ret[0],ret[1],ret[2],ret[3],QRY_DB_TYPE_ATT,"");
				}
			}
			changeHiddenAtts();
			//loadShowCols();
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnAddShowBusClaPar_click() {
	var rets = openModal("/programs/modals/busClaParameter.jsp?busClaId=" + BUS_CLA_ID + "&notParType=" + PARAM_IO_IN,500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridShows").getRows();
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[6].value == ret[0]) {
						addRet = false;
					}
				}
	
				if (addRet) {
					generateShow("",ret[1],ret[2],ret[3],QRT_DB_TYPE_NONE,ret[0]);
					//ret[0] = busClaParId
					//ret[1] = colName
					//ret[2] = headName
					//ret[3] = type
				}
			}
			changeHiddenAtts();
			//loadShowCols();
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}


function btnAddShow_click() {
	if (! QRY_FREE_SQL_MODE) {
		var rets = openModal("/query.AdministrationAction.do?action=addShowColumn&viewName=" + QRY_DB_VIEW_NAME + windowId,500,300);
		var doAfter=function(rets){
			if (rets != null) {
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];
					var addRet = true;
		
					trows=document.getElementById("gridShows").rows;
					for (i=0;i<trows.length && addRet;i++) {
						if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[5].value.toUpperCase() == ret[0].toUpperCase()) {
							addRet = false;
						}
					}
		
					if (addRet) {
						if (! inNotAllowed(ret[0])) {
							generateShow('',ret[0],ret[0],ret[1],QRY_DB_TYPE_COL,"");
							//loadShowCols();
						} else {
							showMessageOneParam(MSG_COL_NOT_ALLOW,ret[0]);
						}
					}
				}
		
				checkActions();
				changeHiddenAtts();
				//loadShowCols();
			}
		}
		rets.onclose=function(){
			doAfter(rets.returnValue);
		}
	} else {
		generateShow('','','','',QRY_DB_TYPE_COL,"");
	}
}

function btnDelShow_click() {
	var cant=0
	trows = document.getElementById("gridShows").selectedItems;
	
	if (document.getElementById("selQryTyp").value == QRY_TYPE_ENTITY_MODAL) {
		var name=document.getElementById("selQryColIdModValueName").value;
		for(var i=0;i<trows.length;i++){
			var inputs=trows[i].getElementsByTagName("INPUT");
			for(var u=0;u<inputs.length;u++){
				if(inputs[u].id=="hidShoColName" && inputs[u].value==name){
					return;
				}
			}
		}
	}
	
	//////////////CAM_6218: Habilitar check cuando ya no hay atributos en datos a mostrar
	trows = document.getElementById("gridShows").selectedItems;
	for (i = 0; i < trows.length; i++) {
		if (trows[i].cells[0].childNodes.length > 0) {
			if (trows[i].cells[0].getElementsByTagName("input")[2] && trows[i].cells[0].getElementsByTagName("input")[2].value != "") {
				attInsert --;
			}
		}
	}
	if (QRY_ALLOW_ATT) {
		if (attInsert == 0) {
			document.getElementById("chkAllAtt").disabled = false;
			if (document.getElementById("chkAllAtt").checked) {
				document.getElementById("selAllAttFrom").style.visibility = 'visible';
			}
		}
	}
	//////////////////////////////
	
	document.getElementById("gridShows").removeSelected();
	checkActions();
	changeHiddenAtts();
	
	return cant;
}

function chkAllAtt_click() {
	if (document.getElementById("chkAllAtt").checked) {
			document.getElementById("selAllAttFrom").style.visibility = 'visible';
	} else {
			document.getElementById("selAllAttFrom").style.visibility = 'hidden';
	}
}

function generateShow(val0, val1, val2, val3,val4,val5) {
	//val0;hidShoAttId
	//val1;hidShoColName
	//val3;hidShoDatType
	//val4;hidShoDbType

	if (QRY_ALLOW_ATT) {
		if (attInsert > 0) {
			document.getElementById("chkAllAtt").disabled = true;
			document.getElementById("selAllAttFrom").style.visibility = 'hidden';
		}
	}
	var oTr = document.createElement("TR");
	var oTd0;
	var oTd1;
	var oTd2;
	var oTd3;
	var oTd4;
	var oTd5;
	var oTd6;
	var oTd7;
	var oTd8;
	var oTd9;
	var oTd10;
	var oTd11=null;
	var oTd12=null;
	var oTd13=null;
	var oTd14=null;//tipo de columna para el caso en que sea free sql mode
	var oTd15=null;//JoinAttValues
	
	if (window.navigator.appVersion.indexOf("MSIE")>0){
		if (QRY_FREE_SQL_MODE) oTd14 = document.createElement("TD");
		for(var i=0;i<(QRY_FREE_SQL_MODE ? 12 : 11);i++){
			if (QRY_FREE_SQL_MODE && i == 2) {
				oTr.appendChild(oTd14);
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
		oTd6 = oTr.getElementsByTagName("TD")[request++]; 
		oTd7 = oTr.getElementsByTagName("TD")[request++]; 
		oTd8 = oTr.getElementsByTagName("TD")[request++]; 
		oTd9 = oTr.getElementsByTagName("TD")[request++]; 
		oTd10 = oTr.getElementsByTagName("TD")[request++];
	}else{
		var request = 0;
		oTd0 = oTr.insertCell(request++); 
		oTd1 = oTr.insertCell(request++); 
		if (QRY_FREE_SQL_MODE) oTd14 = oTr.insertCell(request++); 
		oTd2 = oTr.insertCell(request++); 
		oTd3 = oTr.insertCell(request++); 
		oTd4 = oTr.insertCell(request++); 
		oTd5 = oTr.insertCell(request++); 
		oTd6 = oTr.insertCell(request++); 
		oTd7 = oTr.insertCell(request++); 
		oTd8 = oTr.insertCell(request++); 
		oTd9 = oTr.insertCell(request++);
		oTd10 = oTr.insertCell(request++);
	}
	
	
	var nextCell = QRY_FREE_SQL_MODE ? 12 : 11;
	
	if (ADD_DONT_EXPORT) {
		if (window.navigator.appVersion.indexOf("MSIE")>0){
			oTd11 = document.createElement("TD");
			oTr.appendChild(oTd11);

			oTd12 = document.createElement("TD");
			oTr.appendChild(oTd12);
		}else{
			oTd11 = oTr.insertCell(nextCell++);
			oTd12 = oTr.insertCell(nextCell++);
		}
	} else {
		if (window.navigator.appVersion.indexOf("MSIE")>0){
			oTd12 = document.createElement("TD");
			oTr.appendChild(oTd12);
		}else{
			oTd12 = oTr.insertCell(nextCell++);
		}
	}
	
	if (ADD_AVOID_AUTO_FILTER) {
		if (window.navigator.appVersion.indexOf("MSIE")>0){
			oTd13 = document.createElement("TD");
			oTr.appendChild(oTd13);
		}else{
			oTd13 = oTr.insertCell(nextCell++);
		}
	}

	if (window.navigator.appVersion.indexOf("MSIE")>0){
		oTd15 = document.createElement("TD");
		oTr.appendChild(oTd15);
	}else{
		oTd15 = oTr.insertCell(nextCell++);
	}

	
	//checkbox
	oTd0.innerHTML = "<input type='hidden' name='chkShowSel'><input type='hidden' name='hidShoColId' value=''><input type='hidden' name='hidShoAttId'><input type='hidden' name='hidShoDbType' value=''><input type=hidden name='hidShoParId' value=''>" + (QRY_FREE_SQL_MODE ? "" : "<input type='hidden' name='hidShoColName' value=''><input type='hidden' name='hidShoDatType'>");
	oTd0.getElementsByTagName("INPUT")[2].value = val0;
	oTd0.getElementsByTagName("INPUT")[3].value = val4;
	oTd0.getElementsByTagName("INPUT")[4].value = val5;
	if (! QRY_FREE_SQL_MODE) {
		oTd0.getElementsByTagName("INPUT")[5].value = val1;
		oTd0.getElementsByTagName("INPUT")[6].value = val3;
	}
	oTd0.align="center";
	oTd0.style.display="none";
	
	if(QRY_FREE_SQL_MODE){
		oTd1.setAttribute("req_desc",LBL_COLUMN);
		oTd3.setAttribute("req_desc",LBL_SHOWAS);
	}
	
	//nombre de la columna
	oTd1.innerHTML = QRY_FREE_SQL_MODE ? "<input p_required='true' type='text' name='hidShoColName' onchange='checkActions();changeHiddenAtts();'>" : val1;
	
	if (QRY_FREE_SQL_MODE) {
		oTd14.innerHTML = "<select name='hidShoDatType'>" +
							"<option value='" + COLUMN_DATA_STRING + "'>" + LBL_DATA_TYPE_STR + "</option>" +
							"<option value='" + COLUMN_DATA_NUMBER + "'>" + LBL_DATA_TYPE_NUM + "</option>" +
							"<option value='" + COLUMN_DATA_DATE + "'>" + LBL_DATA_TYPE_FEC + "</option>" +
							"</select>";
	}
	
	//Hidden
	oTd2.innerHTML = val1;
	oTd2.style.display = "none";
	
	//header de la columna
	oTd3.innerHTML = "<input p_required='true' name='txtShoHeadName' maxlength='50' type='text' value='"+val2+"'>";
	oTd3.getElementsByTagName("INPUT")[0].value = val2;
	oTd3.align="center";
	
	//orden
	oTd5.innerHTML = "<select name='cmbShoSort'><option value='' selected></option><option value='" + COLUMN_ORDER_ASC + "'>" + lblQryColOrdAsc + "</option><option value='" + COLUMN_ORDER_DESC + "'>" + lblQryColOrdDesc + "</option></select>";
	if (QRY_TO_PROCEDURE || ! QRY_TO_VIEW) {
		oTd5.style.display = "none";
	} else if (val0 != null && val0 != "") {
		oTd5.getElementsByTagName("SELECT")[0].style.display = "none";
	}
	oTd5.align="center";
	
	//ancho de la columna
	oTd6.innerHTML = "<input p_required='true' p_numeric='true' name='txtShowHeadWidth' maxlength='50' type='text' value='100' size='6'>"
	oTd6.align="center";
	
	//ocultar columna
	oTd7.innerHTML ="<select name=\"cmbShoHid\" onchange=\"changeHiddenAtts();\"><option value=\"1\">" + lblYes + "</option><option value=\"0\" selected>" + lblNo + "</option></select>";
	oTd7.align = "center";
	if (! showHiddenTd) {
		oTd7.style.display = "none";
	}
	
	//origen de atributo
	var strCmbAttFrom;
	strCmbAttFrom = "<select name=\"cmbShoAttFrom\"";
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

	oTd8.innerHTML = strCmbAttFrom;
	oTd8.align = "center";

	if (! (addEntAttOpt && addProAttOpt)) {
		oTd8.style.display = "none";
	}
	
	oTd4.innerHTML = "<input name='txtShoTool' maxlength='255' type='text'>";
	oTd4.align="center";
	
	oTd9.innerHTML = "<input type='checkbox' name='cmbShoTime' id='cmbShowTime' value='1'>";
	oTd9.align="center";
	if (val3 != COLUMN_DATA_DATE && ! QRY_FREE_SQL_MODE) { 
		oTd9.getElementsByTagName("INPUT")[0].style.display = 'none';
	}
	
	oTd10.innerHTML = "<input type='checkbox' name='cmbIsHTML' id='cmbIsHTML' value='1'>";
	oTd10.align="center";
	
	
	oTd15.innerHTML = "<input type='checkbox' name='cmbJoinAttValues' id='cmbJoinAttValues' value='1'>";
	oTd15.align="center";
	if (val0 == null || val0 == "") oTd15.getElementsByTagName("INPUT")[0].style.display = "none";
	if (! (addEntAttOpt || addProAttOpt) && val4 != 'S') oTd15.style.display = "none";
	
	if (ADD_DONT_EXPORT) {
		oTd11.innerHTML = "<input type='checkbox' name='cmbDontExport' id='cmbDontExport' value='1'>";
		oTd11.align="center";
	}
	
	if (oTd12 != null) {
		if (val3 == COLUMN_DATA_DATE) {
			oTd12.innerHTML = "<input type=\"hidden\" name=\"cmbBusEntIdShow\" value=\"\">";
		} else {
			oTd12.innerHTML = "<select name=\"cmbBusEntIdShow\">" + OPTIONS_BUS_ENTITY_COMBO_STR + "</select>";
		}
	}

	if (ADD_AVOID_AUTO_FILTER) {
		oTd13.innerHTML = "<input type='checkbox' name='cmbDontUseAutoFilter' id='cmbDontUseAutoFilter' value='1'>";
		oTd13.align="center";
	}

	document.getElementById("gridShows").addRow(oTr);
	addListener(oTd5.getElementsByTagName("SELECT")[0],"change",function(evt){sortChange(evt);})
	
	for(var i=0;i<oTr.getElementsByTagName("INPUT").length;i++){if(oTr.getElementsByTagName("INPUT")[i].type=="text"){oTr.getElementsByTagName("INPUT")[i].focus();break;}}
}

//---
//--- Funciones para trabajar con los par?metros de la consulta off-line
//---

function paramSave_onChange() {
	document.getElementById("paramPag").disabled = document.getElementById("paramSave").value != "H";
	document.getElementById("paramPagNum").disabled = document.getElementById("paramSave").value != "H";
	
	paramPag_onClick();
}

function paramPag_onClick() {
	if (! document.getElementById("paramPag").disabled) {
		document.getElementById("paramPagNum").disabled = ! document.getElementById("paramPag").checked;
	}
}

function paramMax_onClick() {
	document.getElementById("paramMaxNum").disabled = ! document.getElementById("paramMax").checked;
}

//---
//--- Funciones para trabajar con las acciones
//---
function chkActVieFor_click() {
  document.getElementById("actVieForTo").disabled = !document.getElementById("chkActVieFor").checked;
}

function tabSwitch(){
	if (isQuery && document.getElementById("samplesTab").getSelectedTabIndex() == 3) {
		checkActions();
	}
}

function checkActions() {
	if (isQuery && SOURCE_CONNECTION) {
		document.getElementById("chkActVieEnt").disabled = ! hasActColumns(requiereActVieEntCol);
		document.getElementById("chkActViePro").disabled = ! hasActColumns(requiereActVieProCol);
		document.getElementById("chkActViwTas").disabled = ! hasActColumns(requiereActVieTasCol);
		document.getElementById("chkActWorEnt").disabled = ! hasActColumns(requiereActWorEntCol);
		document.getElementById("chkActWorTas").disabled = ! hasActColumns(requiereActWorTasCol);
		document.getElementById("chkActAcqTas").disabled = ! hasActColumns(requiereActAcqTasCol);
		document.getElementById("chkActComTas").disabled = ! hasActColumns(requiereActComTasCol);
	}
}

function hasActColumns(requiere) {
	trows = document.getElementById("gridShows").getRows();
	continue1 = false;
	for (j = 0; j < requiere.length && ! continue1; j++) {
		continue1 = true;
		for (i = 0; i < trows.length && continue1;i++) {

			if (QRY_FREE_SQL_MODE) {
				if (requiere[j].toLowerCase() == trows[i].cells[1].getElementsByTagName("INPUT")[0].value.toLowerCase()) {
					continue1 = false;
				}
			} else if (requiere[j].toLowerCase() == trows[i].cells[0].getElementsByTagName("INPUT")[4].value.toLowerCase() || requiere[j].toLowerCase() == trows[i].cells[0].getElementsByTagName("INPUT")[5].value.toLowerCase()) {
				//en este if se pone que sea igual a la 4 o a la 5 porque no es igual la creacion que la modificacion
				continue1 = false;
			}
		}
	} 
	return ! continue1;
}

//---
//--- Funciones para determinar el valor de ser utilizado en un filtro
//---
function cmbWheTip_change(cmb) {
  var cmbFun = cmb.parentNode.getElementsByTagName("SELECT")[1];
  var txtVal = cmbFun.nextSibling;
  while(txtVal.tagName!="DIV"){
  	txtVal=txtVal.nextSibling;
  }
  txtVal=txtVal.getElementsByTagName("INPUT")[0];
  if (cmb.value == COLUMN_TYPE_FILTER) {
  	cmbFun.style.display = "none";
  	setRequiredField(txtVal);
 	txtVal.parentNode.style.display = "inline";
 	txtVal.parentNode.style.whiteSpace="nowrap";
  } else {
    txtVal.parentNode.style.display = "none";
    unsetRequiredField(txtVal);
    cmbFun.style.display = "inline";
  }
}

function cmbWheTip_changeAll() {
	var cmbs=new Array();
	for(var i=0;i<document.getElementsByTagName("*").length;i++){
		if(document.getElementsByTagName("*")[i].id=="cmbWheTip"){
			cmbs.push(document.getElementsByTagName("*")[i]);
		}
	}
	if (cmbs != null) {
		for (i = 0; i < cmbs.length; i++) {
			if (cmbs[i].tagName == "SELECT") {
				cmbWheTip_change(cmbs[i]);
			} else if (cmbs[i].parentNode.tagName == "SELECT"){
				cmbWheTip_change(cmbs[i].parentNode);
			}
		}
	}
}

//---------------------------------------
//--- Funciones para checkbox de combos
//---------------------------------------

//function processCmbColType() {
//	processCheckbox("cmbColType");
//}

function processcmbExecOnCha() {
	processCheckbox("cmbExecOnCha");
}

function processCmbUserTime() {
	processCheckbox("cmbUserTime");
}

function processCmbShow2Column() {
	processCheckbox("cmbShow2Column");
}

function processCmbShoTime() {
	processCheckbox("cmbShoTime");
}

function processCmbUseUpper() {
	processCheckbox("cmbUseUpper");
}

function processCmbDontExport() {
	processCheckbox("cmbDontExport");
}

function processCmbHidChtId(){
	processInput("hidChtId");
}

function processCmbHidFilSel() {
	processCheckbox("cmbHidFilSel");
}

function processCmbFilDontUseAutoFilter() {
	processCheckbox("cmbFilDontUseAutoFilter");
}

function processActVieQryToAllowAutoFilter() {
	processCheckbox("actVieQryToAllowAutoFilter");
}

function processCmbDontUseAutoFilter() {
	processCheckbox("cmbDontUseAutoFilter");
}

function processCmbIsHTML(){
	processCheckbox("cmbIsHTML");
}

function processCmbJoinAttValues(){
	processCheckbox("cmbJoinAttValues");
}

function processCmbIsReadOnly() {
	processReadOnly();
	processCheckbox("cmbIsReadOnly");
}

function processReadOnly() {
	var elements = document.getElementsByName("cmbIsReadOnly");
	if (elements != null) {
		for (i = 0; i < elements.length; i++) {
			var tr=elements[i].parentNode;
			while(tr.tagName!="TR"){
				tr=tr.parentNode;
			}
			var elems=tr.getElementsByTagName("INPUT");
			for(var u=0;u<elems.length;u++){
				elems[u].disabled=false;
			}
			elems=tr.getElementsByTagName("SELECT");
			for(var u=0;u<elems.length;u++){
				elems[u].disabled=false;
			}
		}
	}
}

function processCheckbox(chk) {
	var elements = document.getElementsByName(chk);
	if (elements != null) {
		for (i = 0; i < elements.length; i++) {
			if (elements[i].type.toUpperCase()=="CHECKBOX" && !elements[i].checked) {
				elements[i].value = "0";
				elements[i].checked = true;
			} else if(elements[i].type.toUpperCase()=="HIDDEN" && elements[i].value=="") {
				elements[i].value=0;
			}
		}
	}
}

function processInput(chk) {
	var elements = document.getElementsByName(chk);
	if (elements != null) {
		for (i = 0; i < elements.length; i++) {
			if (elements[i].value == 'on') {
				elements[i].value = "-2";
			}
		}
	}

}

function validateEntRelations(chk) {
	var chkForceDelRelation = document.getElementById("chkForceDelRelation");
	var chkDontDelOnRelation = document.getElementById("chkDontDelOnRelation");

	if (chkForceDelRelation == chk && chk.checked) chkDontDelOnRelation.checked = false;
	if (chkDontDelOnRelation == chk && chk.checked) chkForceDelRelation.checked = false;
}



function changeHiddenAtts(){
	var valorAMostrar=document.getElementById("selQryColIdModText");
	var shown="";
	if (valorAMostrar.selectedIndex >= 0) {
		if (valorAMostrar.options[valorAMostrar.selectedIndex].text != null && valorAMostrar.options[valorAMostrar.selectedIndex].text != "") {
			shown=valorAMostrar.options[valorAMostrar.selectedIndex].text;
		} else if (valorAMostrar.options[valorAMostrar.selectedIndex].label != null && valorAMostrar.options[valorAMostrar.selectedIndex].label != "") {
			shown=valorAMostrar.options[valorAMostrar.selectedIndex].label;
		}
	}
	
	var valorAlmacenar=document.getElementById("selQryColIdModValue");
	var stored="";
	if (document.getElementById("selQryTyp").value == QRY_TYPE_MODAL) {
		if (valorAlmacenar.selectedIndex >= 0) {
			if (valorAlmacenar.options[valorAlmacenar.selectedIndex].text != null && valorAlmacenar.options[valorAlmacenar.selectedIndex].text != "") {
				stored=valorAlmacenar.options[valorAlmacenar.selectedIndex].text;
			} else if (valorAlmacenar.options[valorAlmacenar.selectedIndex].label != null && valorAlmacenar.options[valorAlmacenar.selectedIndex].label != "") {
				stored=valorAlmacenar.options[valorAlmacenar.selectedIndex].label;
			}
		}
	}

	var selQryColIdModValueName = document.getElementById("selQryColIdModValueName").value;
	var rows=document.getElementById("gridShows").rows;
	
	while(valorAMostrar.options.length!=0) {
		valorAMostrar.removeChild(valorAMostrar.options[0]);
	}
	
	if (document.getElementById("selQryTyp").value == QRY_TYPE_MODAL && valorAlmacenar != null) {
		while(valorAlmacenar.options.length!=0) {
			valorAlmacenar.removeChild(valorAlmacenar.options[0]);
		}
	}

	var selOkShown=false;
	var selOkStored=false;
	for(var u=0; u<rows.length; u++){
		row=rows[u];
		var cmbOculto;
		var cmbs=row.getElementsByTagName("SELECT");
		for(var i=0; i<cmbs.length; i++){
			if(cmbs[i].name=="cmbShoHid"){
				cmbOculto=cmbs[i];
			}
		}
		var inputs=row.getElementsByTagName("INPUT");
		var name="";
		for(var i=0; i<inputs.length; i++){
			if(inputs[i].name=="hidShoColName"){
				name=inputs[i].value;
				if(valorAlmacenar.tagName=="INPUT"){
					if(selQryColIdModValueName==name){
						valorAlmacenar.value=u;
					}
				}
			}
		}
		var index=cmbOculto.selectedIndex;
		if(index==1){  //No ocultar
			//Si la columna no se va a ocultar hay que agregarla dentro de los posibles valores a mostrar.
			var opt=document.createElement("OPTION");
			opt.value=u;
			opt.text=name;
			opt.label=name;
			if(name==shown){
				opt.selected=true;
				selOkShown=true;
			}
			valorAMostrar.appendChild(opt);
		}  //Si en el combo "Ocultar" está seleccionado "Si" directamente no lo agrega al combo de valorAMostrar.
		
		if (document.getElementById("selQryTyp").value == QRY_TYPE_MODAL) {
			//Si el Valor a Almacenar es un Combo, entonces agregar todas las opciones existentes.
			var opt=document.createElement("OPTION");
			opt.value=u;
			opt.text=name;
			opt.label=name;
			if(name==stored){
				opt.selected=true;
				selOkStored=true;
			}
			valorAlmacenar.appendChild(opt);
		}
	}
	if(!selOkShown && valorAMostrar.options.length>0){
		valorAMostrar.options[0].selected=true;
	}
	if (document.getElementById("selQryTyp").value == QRY_TYPE_MODAL){
		if(!selOkStored && valorAlmacenar.options.length>0){
			valorAlmacenar.options[0].selected=true;
		}
	}
}

function chkPubWs_change(){
	if(document.getElementById("chkPubWs").checked){
		document.getElementById("txtWsName").disabled = false;
		setRequiredField(document.getElementById('txtWsName'));
	}else{
		document.getElementById("txtWsName").disabled = true;
		document.getElementById("txtWsName").value ="";
		unsetRequiredField(document.getElementById('txtWsName'));
	}
}

function verifyPermissions(){
	if (!document.getElementById("usePrjPerms").checked){ //Si no se usan los permisos del proyecto
		//Verificamos si almenos una persona tiene acceso de modificacion
		var permRows=document.getElementById("permGrid").rows;
		var someoneCanModify = false;
		for(var i=0;i<permRows.length;i++){
			var canModify= ("1" == permRows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value);
			if(canModify){//Verificamos que los nombres de los atributos no sean nulos
				someoneCanModify = true;
			}
		}
		if (!someoneCanModify){
			alert(MSG_PERMISSIONS_ERROR);	
			return false;
		}
	}
	return true;
}

function canWrite(){
	var usrCanWrite = document.getElementById("hidUsrCanWrite").value;
	if (usrCanWrite=='true'){
		return true;
	}else{
		return false;	
	}
}

function cmbProySel(){
	if (document.getElementById("selPrj").value == "0"){
		//Deshabilitamos el checkbox de usar permisos del proyecto
		document.getElementById("usePrjPerms").checked = false;
		document.getElementById("usePrjPerms").disabled = true;
		//Habilitamos la grilla de permisos
		document.getElementById("permGrid").disabled = false;
		document.getElementById("addPoolUsrPerm").disabled = false;
		document.getElementById("delPoolUsrPerm").disabled = false;
		//Vaciamos la grilla de permisos, dejando TODOS clickeado
		//delAllPerms(true);
		var oRows = document.getElementById("permGrid").rows;
		var td = oRows[0].getElementsByTagName("TD");
		//Marcamos el modo lectura
		td[3].getElementsByTagName("INPUT")[0].checked = true;
		td[0].getElementsByTagName("INPUT")[2].value = 1;
		//Marcamos escritura
		td[3].getElementsByTagName("INPUT")[1].checked = true;
	 	td[0].getElementsByTagName("INPUT")[3].value = 1;
	}else{
		//Habilitamos el checkbox de usar permisos del proyecto	
		document.getElementById("usePrjPerms").disabled = false;
		//Cargamos la grilla con los permisos del proyecto
		//loadProyectPerms(); <--- TODO, SI SE HACE SE DEBE HACER PARA TODOS LOS OBJETOS DE DISEÑO
		if (!document.getElementById("usePrjPerms").checked){ //Si no esta clickeado el checkbox de usar los permisos del proyecto
			var msg = confirm(MSG_USE_PROY_PERMS);
			if (msg) {
				document.getElementById("usePrjPerms").checked = true;
				//Deshabilitamos la grilla de permisos
				document.getElementById("permGrid").disabled = true;
				document.getElementById("addPoolUsrPerm").disabled = true;
				document.getElementById("delPoolUsrPerm").disabled = true;
				//Vaciamos la grilla de permisos, dejando TODOS sin clickear
				delAllPerms(false);
			}
		}
	}
}

function loadProyectPerms(){
	//1. Obtenemos el id del proyecto seleccionado
	var prjId = document.getElementById("selPrj").value;
	var sXMLSourceUrl = "administration.AdministrationAction.do?action=getProjPermssions&prjId=" + prjId;
	var xmlLoad=new xmlLoader();
	xmlLoad.onload=function(xmlRoot){
	
		for(i=0;i<xmlRoot.childNodes.length;i++){
			xRow = xmlRoot.childNodes[i];
			var option = document.createElement("OPTION");
			
			/* TODO */
		
		}
	}
	xmlLoad.load(sXMLSourceUrl);
}

function btnAddRemapAtt_click() {
	//var rets = openModal("/programs/modals/dataDictionary.jsp",500,300);
	var rets = openModal("/query.AdministrationAction.do?action=addAttColumn" + windowId,500,300);
	
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridRemap").getRows();
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[2].value == ret[0]) {
						addRet = false;
					}
				}
		
				if (addRet) {
					var oTd0 = document.createElement("TD");
					var oTd1 = document.createElement("TD");
					var oTd2 = document.createElement("TD"); 
					
					oTd0.innerHTML = "" +
							"<input type='checkbox' name='checkRemapSel'>" +
							"<input type='hidden' name='hidRempColId' value='true'>" +
							"<input type='hidden' name='hidRempAttId'>" +
							"<input type='hidden' name='hidRempAttName'>" +
							"<input type='hidden' name='hidRempAttType'>";
					oTd0.getElementsByTagName("INPUT")[2].value = ret[0];
					oTd0.getElementsByTagName("INPUT")[3].value = ret[1];
					oTd0.getElementsByTagName("INPUT")[4].value = ret[3];
					oTd0.align="center";
					
					oTd1.innerHTML = ret[1];			
					
					oTd2.innerHTML = "<select name=\"cmbRemapBusEntIdShow\" p_required=\"true\">" + OPTIONS_BUS_ENTITY_COMBO_STR + "</select>";
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					document.getElementById("gridRemap").addRow(oTr);
				}
			}
			changeHiddenAtts();
			//loadShowCols();
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnDelRemap_click() {
	document.getElementById("gridRemap").removeSelected();
}