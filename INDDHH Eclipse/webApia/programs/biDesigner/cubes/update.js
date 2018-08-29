var tablearr = new Array(); //aqui guardamos las tablas seleccionadas para pasarle al flash que crea las dimensiones
							// el formato de guardado es este: [1-Tabla1;2-Tabla2;3-Tabla3]
var selSchName;

if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", start, false);
}else{
	start();
}

function start(){
	if (document.getElementById("txtName") != null && document.getElementById("txtName").value == ""){
		document.getElementById("txtName").focus();
	}
}
function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("txtName").value)){
			if (verifyOtherReqObjects() && verifyPermissions()){
				document.getElementById("frmMain").action = "biDesigner.CubeAction.do?action=confirm" + windowId;
				document.getElementById("frmMain").target = "_self";
				submitForm(document.getElementById("frmMain"));
			}
		}
	}
}

function isValidDimNameToUse(s){
var re = new RegExp("^[a-zA-Z 0-9_]*$");
	if (!s.match(re)) {
		alert(MSG_DIM_INVALID_NAME.replace("<TOK1>", s));
		return false;
	}
	return true;
}

function isValidHierNameToUse(s){
var re = new RegExp("^[a-zA-Z 0-9_]*$");
	if (!s.match(re)) {
		alert(MSG_HIER_INVALID_NAME.replace("<TOK1>", s));
		return false;
	}
	return true;
}

function isValidLvlNameToUse(s){
var re = new RegExp("^[a-zA-Z 0-9_]*$");
	if (!s.match(re)) {
		alert(MSG_LVL_INVALID_NAME.replace("<TOK1>", s));
		return false;
	}
	return true;
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
			document.getElementById("frmMain").action = "biDesigner.CubeAction.do?action=backToList" + windowId;
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "biDesigner.CubeAction.do?action=backToList" + windowId;
		submitForm(document.getElementById("frmMain"));
	}
}
function viewFnc(e){
	var previous=e.parentNode.parentNode.previousSibling;
	if(previous.tagName!="TD"){
		previous=previous.previousSibling;
	}
	var envId = previous.getElementsByTagName("INPUT")[1].value+"";
	if(envId=="all") {
		envId = 0;
	}
	var ret = openModal("/biDesigner.CubeAction.do?action=openModal&envId=" + envId + windowId,400,500);
}

function deseleccionar(name){
	if (document.getElementById(name).selectedIndex >= 0){
		var tables = document.getElementById(name);
		// Obtener el índice de la opción que se ha seleccionado
		var indiceSeleccionado = tables.selectedIndex;
		// Con el índice y el array "options", obtener la opción seleccionada
		tables.options[indiceSeleccionado].selected = false;
	}
}

function verifyOtherReqObjects(){

	//0.Verificamos si el nombre del cubo es único
	if (checkExistCubeName(document.getElementById("txtName").value)){
		alert(MSG_CUBE_NAME_ALREADY_EXIST);
		return false;
	}
/*
	//1. Verificamos si ingreso algun perfil
	if (document.getElementById("gridProfiles").rows.length<=0){
		alert(MSG_MUST_ENT_ONE_PRF);
		return false;
	}
	*/
	
	//1.5 Verificamos que si se ingreso una vista no tenga comillas dobles
	if (document.getElementById("txtFactTableView").value.indexOf("\"")>0){
		alert(MSG_ERROR_IN_SQL_VIEW_WITH_COMS);
		return false;
	}
	
	if (document.getElementById("txtFactTableView").value.indexOf("<")>0){
		alert(MSG_ERROR_IN_SQL_VIEW_WITH_MINOR_CHAR);
		return false;
	}
	
	if (document.getElementById("txtFactTableView").value.indexOf("ORDER BY")>0){
		alert(MSG_ERROR_IN_SQL_VIEW_WITH_ORDER_BY);
		return false;
	}
		
	//2.Verificamos si agrego alguna medida
	if (document.getElementById("gridMeasures").rows.length <= 0){
		alert(MSG_MUST_ENT_ONE_MEAS);
		return false;
	}
	
	//3.Verificamos medidas
	var meaRows=document.getElementById("gridMeasures").rows;
	var visible = false;
	for(var i=0;i<meaRows.length;i++){
		var meaName=meaRows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
		if (meaName == ""){//Verificamos que los nombres de las medidas no sean nulos
			alert(MSG_WRG_MEA_NAME);
			return false;
		}
		if (!isValidMeasureName(meaName)){
			alert(MSG_MEAS_INV_NAME);
			return false;
		}
		
		if (!isValidMeasureCaption(meaCaption)){
			alert(MSG_MEAS_INV_CAP);
			return false;
		}
		
		var cmb=meaRows[i].cells[4].getElementsByTagName("SELECT")[0];
		var measType = (cmb.options[cmb.selectedIndex].value);
		if (measType == 1){//Si es medida calculada verificamos la formula
			var measFormula = meaRows[i].getElementsByTagName("TD")[7].getElementsByTagName("INPUT")[0];
			if (!chkFormula(meaName, measFormula)){
				return false;
			}
		}else{
			var attName = meaRows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
			if (attName == ""){
				alert(MSG_MIS_MEA_ATT);
				return false;
			}
			var meaCaption=meaRows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value;
			if (meaCaption == ""){//Verificamos que los caption de las medidas no sean nulos
				alert(MSG_WRG_MEA_CAP);
				return false;
			}
		}
		if (meaRows[i].getElementsByTagName("TD")[8].getElementsByTagName("INPUT")[0].checked){
			visible = true;
		}
	}
	
	//Almenos una medida debe ser visible	
	if (!visible){
		alert(MSG_ATLEAST_ONE_MEAS_VISIBLE);
		return false;
	}
	
	//4. Verificamos si ingreso al menos dos dimensiones
	var model=document.getElementById("treeModel").value;
	//alert(model);
	if (model == '<nodes/>'){ //No hay ninguna
		alert(MSG_MUST_ENT_ONE_DIM);
		return false;
	}
	var dimPos = model.indexOf('el_type="dimension"');
	if (dimPos < 0){ //No hay ninguna
		alert(MSG_MUST_ENT_ONE_DIM);
		return false;
	}
	
	//5. Verificamos todas las dimensiones se llamen distinto
	var modelRef=document.getElementById("treeModel").value;
	var posNode = modelRef.indexOf("</node>");
	var posName;
	var name;
	var dimName;
	var dimArrNames = new Array();
	while (posNode >= 0){
		model = modelRef.substring(0,posNode);
		posName = model.indexOf("name=");
		model = modelRef.substring(posName,model.length);
		dimArrNames.push(model.substring(6,model.indexOf('" ')))
		modelRef = modelRef.substring(posNode,modelRef.length);
		posNode = modelRef.indexOf("<node ");
		if (posNode >= 0){
			modelRef = modelRef.substring(posNode, modelRef.length);
			posNode = modelRef.indexOf("</node>");
		}
	}
	//dimArrNames=[dim1,dim2,dim3]
	for (var i = 0; i < dimArrNames.length; i++) {
		dimName = dimArrNames[i];
		if (isValidDimNameToUse(dimName)){
			for(var j=i+1; j<dimArrNames.length; j++){
				if (dimName == dimArrNames[j]){
					alert(MSG_CANT_BE_TWO_DIMS_WITH_SAME_NAME + " " + dimName);
					return false;
				}
			}
		}else {
			return false;
		}
		
	}
	
	//6. Verificamos todas las dimensiones tengan al menos un nivel
	modelRef=document.getElementById("treeModel").value;
	dimPos = modelRef.indexOf('el_type="dimension"');
	while (dimPos >= 0){
		modelRef = modelRef.substring(dimPos+ 19, modelRef.length);
		var dim2Pos = modelRef.indexOf('el_type="dimension"');
		if (dim2Pos >= 0){
			model = modelRef.substring(0, dim2Pos);
		}else {
			model = modelRef;
		}
		var levPos = model.indexOf('el_type="field"');
		if (levPos < 0){
			alert(MSG_MUST_ENTER_ONE_LVL_BY_DIM);
			return false;
		}
		//Verificamos que el nombre de la jerarquía sea correcto
		var hierPos = model.indexOf('el_type="hierarchy"');
		if (hierPos>0){
			var hModel = model.substring(hierPos+18, model.length);
			var namePos = hModel.indexOf("name=");
			hModel = hModel.substring(namePos, hModel.length);
			var hName = hModel.substring(6, hModel.indexOf('" '));
			if (!isValidHierNameToUse(hName)){
				return false;
			}
		}
		
		//Verificamos que el nombre del nivel sea correcto
		var lvlPos = model.indexOf('el_type="field"');
		if (lvlPos>0){
			var lvlModel = model.substring(lvlPos+15, model.length);
			var namePos = lvlModel.indexOf("name=");
			lvlModel = lvlModel.substring(namePos, lvlModel.length);
			var lvlName = lvlModel.substring(6, lvlModel.indexOf('" '));
			if (!isValidLvlNameToUse(lvlName)){
				return false;
			}
		}
		
		if (dim2Pos > 0){
			modelRef = modelRef.substring(dim2Pos, modelRef.length);
			dimPos = modelRef.indexOf('el_type="dimension"');
		}else{
			dimPos = -1;
		}
	}
	
	//7. Verificamos que en las dimensiones que no son virtuales se haya ingreado una foreignkey
	modelRef=document.getElementById("treeModel").value;
	dimPos = modelRef.indexOf('el_type="dimension"');
	var fkey;
	while (dimPos >= 0){
		var posIn = modelRef.indexOf("innerDimension=");
		var virtDim = modelRef.substring(posIn+16,posIn+21);
		if (virtDim == "false"){
			posFk = modelRef.indexOf("foreignKey=");
			if (posFk >= 0){
				fkey = modelRef.substring(posFk+12,posFk+13);
			}else{
				fkey = '"';
			}
			if (fkey == '"'){
				posName = modelRef.indexOf("name=");
				var tmpModel = modelRef.substring(posName+6,modelRef.length);
				name = tmpModel.substring(0,tmpModel.indexOf('"'));
				alert(MSG_MUST_SEL_ONE_FKEY_FIRST + " " + name);
				return false;
			}
		}
		posNode = modelRef.indexOf("</node>");
		while (posNode == 0){
			modelRef = modelRef.substring(7,modelRef.length);
			posNode = modelRef.indexOf("</node>");
		}
		modelRef = modelRef.substring(posNode, modelRef.length);
		dimPos = modelRef.indexOf('el_type="dimension"');
	}
	
	//8. Verificamos que en las dimensiones que no son virtuales se haya ingresado una (primaryKey y (una tabla o una vista))
	
	modelRef=document.getElementById("treeModel").value;
	dimPos = modelRef.indexOf('el_type="dimension"');
	var fkey;
	var posNode;
	var table;
	var pkey;
	while (dimPos >= 0){
		var posIn = modelRef.indexOf("innerDimension=");
		var virtDim = modelRef.substring(posIn+16,posIn+21);
		if (virtDim == "false"){
			var posName = modelRef.indexOf("name=");
			var tmpModel = modelRef.substring(posName+6,modelRef.length);
			dimName = tmpModel.substring(0,tmpModel.indexOf('"'));
			
			modelRef = modelRef.substring(dimPos, modelRef.length);
			posNode = modelRef.indexOf("<node ");
			model = modelRef.substring(posNode, modelRef.length);
			var posPkey = model.indexOf("primaryKey=");
			if (posPkey >= 0){
				pkey = model.substring(posPkey+12,posPkey+13);
			}else{
				pkey = '"';
			}
			if (pkey == '"'){
				alert(MSG_SEL_PK_FOR_JIER + " " + dimName);
				return false;
			}else{
				tmpModel = model.substring(posPkey+12, model.length);
				var posEsp = tmpModel.indexOf('" ');
				pkey = tmpModel.substring(0,posEsp);
				var posPto = pkey.indexOf(".");
				pkey = pkey.substring(0,posPto); //ahora pkey lleva el nombre de la tabla
			}
			var posTable = model.indexOf("table=");
			if (posTable >= 0){
				table = model.substring(posTable+7,posTable+8);
			}else{
				table = '"';
			}
			if (table == '"'){
				alert(MSG_SEL_TBL_FOR_JIER + " " + dimName);
				return false;
			}else{ //Verificamos si es una vista que se haya ingresado la sql de la misma
				tmpModel = model.substring(posTable+7,model.length);
				var posEsp = tmpModel.indexOf('" ');
				table = tmpModel.substring(0,posEsp);
				if (table.indexOf("[VIEW];") >= 0){
					var view = table.substring(7,table.length);
					if (view == ""){
						alert(MSG_MUST_ENT_ONE_VIEW_FIRST_FOR_HIER + " " + dimName);
						return false;
					}else{//verificamos correctitud de la vista
						//Se verifica en el servidor
					}
				}
			}
		}
		posNode = modelRef.indexOf("</node>");
		while (posNode == 0){
			modelRef = modelRef.substring(7,modelRef.length);
			posNode = modelRef.indexOf("</node>");
		}
		modelRef = modelRef.substring(posNode, modelRef.length);
		dimPos = modelRef.indexOf('el_type="dimension"');
	}
	
	//9. Verificamos si se agrego algun perfil para restringir sus dimensiones y que se haya restringido alguna
	var i = 0;
	var prfs = "";
	var trows = document.getElementById("gridNoAccProfiles").rows;
	for (i=0;i<trows.length;i++){
		if ("true" == trows[i].getElementsByTagName("TD")[1].getAttribute("flagNew")){
			if (prfs==""){
				prfs = trows[i].getElementsByTagName("TD")[1].getAttribute("value");
			}else {
				prfs += ";" + trows[i].getElementsByTagName("TD")[1].getAttribute("value");
			}
			
		}
	}
	if (prfs!=""){
		if (prfs.indexOf(";")<0){
			var msg = MSG_PRF_NO_ACC_DELETED.replace("<TOK1>",prfs);
			if (!confirm(msg)){
				return false;
			}
		}else {
			var msg = MSG_PRFS_NO_ACC_DELETED.replace("<TOK1>",prfs);
			if (!confirm(msg)){
				return false;
			}
		}
	}
	
	return true;
}

function checkExistCubeName(cubeName){
/*
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "biDesigner.CubeAction.do?action=checkExistCbeName"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "cubeName=" + cubeName;
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
		     if(http_request.responseText != "false"){
		         return true;
		     }else{
				 return false;
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
*/ 
	return false;
}

function cubeName_change(cubeName){
	if (cubeName!=""){
		if (!confirm(MSG_CUBE_NAME_CHG_ALERT)){
			document.getElementById("txtName").value = cubeName;
		}
	}
}
function testSqlViewFlashStr(sql,table){

	var wrongTable = false;
	
	if (table == null || table == ""){
		return MSG_MUST_SEL_ONE_PKEY_FIRST;
	}

	//1. Chequeamos el formato de la vista sea correcto: SELECT * FROM TABLE WHERE ..
	var fromPos = sql.indexOf("FROM");
	var wherePos = sql.indexOf("WHERE");
	
	if (wherePos < 0){
		wherePos = sql.length;
	}
	
	if (sql.substring(fromPos+4,wherePos-1).indexOf(",")>0){ //HAY MAS DE UNA TABLA
		return MSG_VW_REF_ONL_ONE_TABLE;
	}
	
	//2. Chequeamos que la tabla referenciada por la vista sea igual a la pasada por parametro
	var sqlTable;
	if (sql.indexOf("WHERE") < 0){
		sqlTable = sql.substring(fromPos+5,wherePos);
	}else{
		sqlTable = sql.substring(fromPos+5,wherePos-1);	
	}
	
	if (sqlTable.toLowerCase() != table.toLowerCase()){
		wrongTable = "true";
	}
	//3. Chequeamos la correctitud de la vista
	var dbConId = document.getElementById("dbConId").value;
	
	var loader=new xmlLoader();
	loader.onload=function(xml){
		if(xml!=null && xml.firstChild.nodeValue != "OK"){
           if (wrongTable == "true"){
		           return MSG_TBL_REF_BY_VW + " " + table;	              
	           }else{
		           return true;		
	           }
        } else {
           return true;	
        }
	}
	var str = "sql=" + encodeURIComponent(sql) + "&dbConId="+dbConId;
	loader.load(URL_ROOT_PATH+"/biDesigner.CubeAction.do?action=sqlTest"+windowId+"&"+str);
}

//Verifica si la formula es correcta
// formatos posibles: Measure op Measure, Measure op NUMBER
function chkFormula(meaName, obj){
	
	//1. Hallamos la medida 1, el operarador y la medida2 (o number)
	var formula = obj.value;
	if (formula == ""){
		alert(MSG_MUST_ENTER_FORMULA);
		return false;
	}
	var opPos = formula.indexOf("*");
	if (opPos<0){
		opPos = formula.indexOf("/");
	}
	if (opPos<0){
		opPos = formula.indexOf("-");
	}
	if (opPos<0){
		opPos = formula.indexOf("+");
	}
	
	var formula2 = formula.substring(opPos, formula.length);
	var meas1 = formula.substring(0,opPos-1);
	var op = formula2.substring(0,1);
	var meas2 = formula2;
	if (formula2.length>1){
		meas2 = formula2.substring(2, formula2.length);
	}
	
	//1.5 Verificamos que ninguna de las medidas utilizadas en la formula se llamen como la medida actual
	if (meaName == meas1 || meaName == meas2){
		alert(MSG_MEAS_CANT_AUTOREF + " " + meaName);
		return false;
	}
	
	//2. Verificamos la medida1 exista
	if (!chkMeasExist(meas1)){
		if (opPos < 0){
			alert(formula + ": " + MSG_MEAS_OP1_NAME_INVALID);
		}else {
			alert(meas1 + ": " + MSG_MEAS_OP1_NAME_INVALID);
		}
		obj.focus();		
		return false;
	}
	
	//3. Verificamos el operador sea valido
	if (op != '/' && op != '-' && op != '+' && op != '*'){
		alert(op + ": " + MSG_OP_INVALID);
		obj.focus();
		return false;
	}
	
	//4. Verificamos la medida2 exista
	if (!chkMeasExist(meas2)){//Si no existe como medida talvez sea un numero
		if (isNaN(meas2)){
			alert(meas2 + ": " + MSG_MEAS_OP2_NAME_INVALID);
			obj.focus();
			return false;
		}
	}
	return true;
}

//Verifica si la medida usada en una formula es valida
function chkMeasExist(measure){
	if (document.getElementById("gridMeasures").selectedItems.length >= 0){
		trows=document.getElementById("gridMeasures").rows;
		for (i=0;i<trows.length;i++) {
			if (trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value == measure) {
				return true;
			}
		}
	}else{
		return false;		
	}

	return false;
}

//Funcion interna que agrega una tabla al array interno de tablas
function addTable(tableId, tableName){
	tablearr.push(tableId + "-" +tableName);
}

//Funcion interna que elimina una tabla del array interno de tablas
function delTable(table){
	var size = tablearr.length;
	var indice = -1;
	var pos = 0;
	var found = false;
	
	if (size > 0){
		while (found == false && pos < size){
			if (tablearr[pos] == table){
				found = true;
				indice = pos;	
			}else{
				pos = pos + 1;
			}
		}
	}
	if (found){
		tablearr.splice(indice, 1) //borra a partir de la posicion indice 1 elemento
	}
}

/////////////////////////////// FUNCIONES DE LA SOLAPA DATOS GEN. /////////////////////////////////////

function cmbSource_change(update){
	if (document.getElementById("dbConId").selectedIndex >= 0){
		ACTUAL_PAGE = "1";
		//borramos los que habia antes
		borrarTextArea("selTables");
		var dbConSel = document.getElementById("dbConId");
		// Obtener el índice de la opción que se ha seleccionado
		var indiceSeleccionado = dbConSel.selectedIndex;
		// Con el índice y el array "options", obtener la opción seleccionada
		var opcionSeleccionada = dbConSel.options[indiceSeleccionado];
		// Obtener el valor y el texto de la opción seleccionada
		var dbConName = opcionSeleccionada.text;
		var dbConId = opcionSeleccionada.value;
		document.getElementById("dbConIdHid").value=dbConId;
		doXMLTablesLoad(dbConId,update);
	}
}

function doXMLTablesLoad(dbConId,update){
	var sXMLSourceUrl = "../programs/biDesigner/cubes/updateTablesXML.jsp?dbConId=" + dbConId + "&update=" +update+ windowId;
	var listener=new Object();
	listener.onLoad=function(xml){
	readDocTablesXML(xml);
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}

//Funcion interna utilizada por doXMLTablesLoad
function readDocTablesXML(sXmlResult){
	var xmlRoot=getXMLRoot(sXmlResult);
	if (xmlRoot.nodeName != "EXCEPTION") {
			var xRow = xmlRoot.childNodes[0];
			var cantTables=xRow.childNodes[0].firstChild.nodeValue;
			if (parseInt(cantTables) < parseInt(CANT_TABLES_BY_PAGE)){
				document.getElementById("btn_nextTables").disabled = true;
				document.getElementById("btn_prevTables").disabled = true;
			}else{
				if (ACTUAL_PAGE == "1"){
					document.getElementById("btn_nextTables").disabled = false;
					document.getElementById("btn_prevTables").disabled = true;
				}else{
					var cantPages = (parseInt(cantTables) / parseInt(CANT_TABLES_BY_PAGE));
					if (parseFloat(cantPages) > parseInt(cantPages)){
						cantPages = parseInt(cantPages) + 1;
					}
					if (parseInt(ACTUAL_PAGE) == cantPages){
						document.getElementById("btn_nextTables").disabled = true;
						document.getElementById("btn_prevTables").disabled = false;
					}else{
						document.getElementById("btn_nextTables").disabled = false;
						document.getElementById("btn_prevTables").disabled = false;
					}
				}
			}
		for(i=1;i<xmlRoot.childNodes.length;i++){
			var xRow = xmlRoot.childNodes[i];
			var tableId=xRow.childNodes[0].firstChild.nodeValue;
			var tableName=xRow.childNodes[1].firstChild.nodeValue;
			var oOpt = document.createElement("OPTION");
			oOpt.innerHTML = tableName;
			oOpt.value = tableId;
			document.getElementById("selTables").appendChild(oOpt);
		}
	}else{
		alert("Unexpected error in java script function readDocTablesXML");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}

function getTablePage(pageNum){
	if (document.getElementById("dbConId").selectedIndex >= 0){
		//borramos los que habia antes
		borrarTextArea("selTables");
		var dbConSel = document.getElementById("dbConId");
		// Obtener el índice de la opción que se ha seleccionado
		var indiceSeleccionado = dbConSel.selectedIndex;
		// Con el índice y el array "options", obtener la opción seleccionada
		var opcionSeleccionada = dbConSel.options[indiceSeleccionado];
		// Obtener el valor y el texto de la opción seleccionada
		var dbConName = opcionSeleccionada.text;
		var dbConId = opcionSeleccionada.value;
		document.getElementById("dbConIdHid").value=dbConId;
		doXMLTablesLoadByPage(dbConId,pageNum);
	}
}

function doXMLTablesLoadByPage(dbConId,pageNum){
	var sXMLSourceUrl = "../programs/biDesigner/cubes/updateTablesXML.jsp?dbConId=" + dbConId + "&pageNum="+ pageNum + windowId;
	var listener=new Object();
	listener.onLoad=function(xml){
	readDocTablesXML(xml);
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}

function btnAddProfile_click() {

	var rets = null;
	rets = openModal("/programs/modals/profiles.jsp",500,300);
	var doLoad=function(rets){
		if (rets != null) {
			if (rets != null) {
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];
					var addRet = true;
					
					trows=document.getElementById("gridProfiles").rows;
					for (i=0;i<trows.length && addRet;i++) {
						if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
							addRet = false;
						}
					}
					
					if (addRet) {
						var oTd0 = document.createElement("TD"); 
						var oTd1 = document.createElement("TD"); 
				
						oTd0.innerHTML = "<input type='checkbox' name='chkPrfSel'><input type='hidden' name='chkPrf'>";
						oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
						oTd0.align="center";
				
						if(ret[2]==1){
							oTd1.innerHTML = "<B>"+ret[1]+"</B>";			
						} else {
							oTd1.innerHTML = ret[1];			
						}
				
						var oTr = document.createElement("TR");
						oTr.appendChild(oTd0);
						oTr.appendChild(oTd1);
						document.getElementById("gridProfiles").addRow(oTr);
					}
				}
			}
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function btnDelProfile_click() {
	document.getElementById("gridProfiles").removeSelected();
}

function btnAddNoAccProfile_click() {
	var rets = null;
	rets = openModal("/programs/modals/profiles.jsp",500,300);
	var doLoad=function(rets){
		if (rets != null) {
			if (rets != null) {
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];
					var addRet = true;
					
					trows=document.getElementById("gridNoAccProfiles").rows;
					for (i=0;i<trows.length && addRet;i++) {
						if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
							addRet = false;
						}
					}
					
					if (addRet) {
						var oTd0 = document.createElement("TD"); 
						var oTd1 = document.createElement("TD"); 
						var oTd2 = document.createElement("TD");
				
						oTd0.innerHTML = "<input type='checkbox' name='chkPrfRestSel'><input type='hidden' name='chkPrfRest'>";
						oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
						oTd0.align="center";
				
						//if(ret[2]==1){
						//	oTd1.innerHTML = "<B>"+ret[1]+"</B>";			
						//} else {
							oTd1.innerHTML = ret[1];			
						//}
						oTd1.setAttribute("value",ret[1]);
						oTd1.setAttribute("flagNew","true");
				
						oTd2.innerHTML += "<span style=\"vertical-align:bottom;\">";
						oTd2.innerHTML += " <img title=\""+LBL_SEL_DIM_TO_DENIE_ACCESS+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openNoAccDims(this)\" style=\"cursor:pointer;cursor:hand\">";
						oTd2.innerHTML += "</span>";
		
						var oTr = document.createElement("TR");
						oTr.appendChild(oTd0);
						oTr.appendChild(oTd1);
						oTr.appendChild(oTd2);
						document.getElementById("gridNoAccProfiles").addRow(oTr);
					}
				}
			}
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function btnDelNoAccProfile_click() {
	var cant = chksChecked(document.getElementById("gridNoAccProfiles"));
	if(cant == 1) {
		var selPrfItem = document.getElementById("gridNoAccProfiles").selectedItems[0].rowIndex-1;
		var trows=document.getElementById("gridNoAccProfiles").rows;
		var prfName = trows[selPrfItem].getElementsByTagName("TD")[1].getAttribute("value");
		
		var frm=document.getElementById("frmMain");
		var action=frm.action;
		var target=frm.target;
		frm.action="biDesigner.CubeAction.do?action=removeNoAccProfile"+windowId+"&prfName="+prfName;
		frm.target="treeModSubmit";
		frm.submit();
		frm.action=action;
		frm.target=target;
		
		document.getElementById("gridNoAccProfiles").removeSelected();
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function openNoAccDims(obj) {
	//Para agregar un perfil de acceso restringido, se debe verificar previamente que el cubo tenga nombre
	if (document.getElementById("txtName")==""){
		alert(MSG_CBE_NAME_MISS);
		return;
	}
	var selPrfItem = document.getElementById("gridNoAccProfiles").selectedItems[0].rowIndex-1;
	var trows=document.getElementById("gridNoAccProfiles").rows;
	var prfName = trows[selPrfItem].getElementsByTagName("TD")[1].getAttribute("value");
	trows[selPrfItem].getElementsByTagName("TD")[1].setAttribute("flagNew","false");
	
	var frm=document.getElementById("frmMain");
	var action=frm.action;
	var target=frm.target;
	frm.action="biDesigner.CubeAction.do?action=loadDims"+windowId+"&after=openNoAccDimsModal&prfName="+prfName;
	frm.target="treeModSubmit";
	frm.submit();
	frm.action=action;
	frm.target=target;
}

function openNoAccDimsModal(dims){
	var cbeName = document.getElementById("txtName").value; //pasamos el nombre del cubo por si se esta creando (en el servidor aún no esta el nombre)
	var selPrfItem = document.getElementById("gridNoAccProfiles").selectedItems[0].rowIndex-1;
	var trows=document.getElementById("gridNoAccProfiles").rows;
	var prfName = trows[selPrfItem].getElementsByTagName("TD")[1].getAttribute("value");

	var rets = null;
	rets = openModal("/programs/modals/setCubePermissions.jsp",500,400);
	var doLoad=function(rets){
		if (rets != null) {
			if (rets=="removeRow"){
				document.getElementById("gridNoAccProfiles").removeSelected();
			}
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
	
	rets.onload=function(){
		var ifr=this.getElementsByTagName("IFRAME")[0];
		window.parent.parent.parent.frames[ifr.name].setXml(dims,prfName,cbeName,"userCube");
	}
}

/////////////////////////////// FUNCIONES DE LA SOLAPA TABLAS DE MAPEO /////////////////////////////////////

function getPrevTables(){ //obtain prev 100 tables
	ACTUAL_PAGE = parseInt(ACTUAL_PAGE) - 1;
	getTablePage(ACTUAL_PAGE);
	document.getElementById("btn_nextTables").disabled = false;
	if (ACTUAL_PAGE == "1"){
		document.getElementById("btn_prevTables").disabled = true;
	}
}
function getNextTables(){ //obtain next 100 tables
	ACTUAL_PAGE = parseInt(ACTUAL_PAGE) + 1;
	getTablePage(ACTUAL_PAGE);
	document.getElementById("btn_prevTables").disabled = false;
}

//Boton >> para agregar tabla
function addTable_click(){
	if (document.getElementById("selTables").selectedIndex >= 0){
		var tables = document.getElementById("selTables");
		while(tables.selectedIndex != -1){
	        // Obtener el índice de la opción que se ha seleccionado
			var indiceSeleccionado = tables.selectedIndex;
			// Con el índice y el array "options", obtener la opción seleccionada
			var opcionSeleccionada = tables.options[indiceSeleccionado];
			// Obtener el valor y el texto de la opción seleccionada
			var tableName = opcionSeleccionada.text;
			var tableId = opcionSeleccionada.value;
			tables.options[tables.selectedIndex].selected = false;
			addTableSelected(tableName, tableId);
	    }
		
	}else{
		alert(MSG_MUST_SEL_ONE_TBL_FIRST);
	}
}

function addTableSelected(tableName, tableId){
		addTable(tableId, tableName); //-> Agregamos la tabla seleccionada al array de tablas seleccionadas
		var oOpt = document.createElement("OPTION");
		oOpt.innerHTML = tableName;
		oOpt.value = tableId;
		if(notIn(tableId)){
			document.getElementById("txtTablesSel").appendChild(oOpt);
		}
		//agregamos la tabla al combo de tablas para fact table
		var oOpt2 = document.createElement("OPTION");
		oOpt2.innerHTML = tableName;
		oOpt2.value = tableId;
		if(notInSelFact(tableId)){
			document.getElementById("selFactTable").appendChild(oOpt2);
		}
		//Si no hay ingresada una vista y no hay ninguna medida agregada seleccionamos el radiobutton de tablas en la seccion de factTables
		if (document.getElementById("txtFactTableView").value == "" && document.getElementById("gridMeasures").rows.length <= 0){
			changeRadFact(1);
			document.getElementById("radFactTable1").checked = true;
			document.getElementById("radSelected").value = 1;
		}
		//almacenamos los ids de las tablas seleccionadas en un input oculto para su posterior recuperacion en caso que la generacion de error
		var inputTblHidden = document.getElementById("txtTablesSelHid");
		var valInputTblHidden = inputTblHidden.value;
		if (valInputTblHidden == ""){
			inputTblHidden.value = ";" + tableId + ";";
		}else{
			inputTblHidden.value = valInputTblHidden + tableId + ";";
		}
		//Deshabilitamos el combo con las conexiones para que no las pueda cambiar
		document.getElementById("dbConId").disabled=true;
}

//Boton << para borrar tabla
function delTable_click(){
	if (document.getElementById("txtTablesSel").selectedIndex >= 0){
		var tables = document.getElementById("txtTablesSel");
		while(tables.selectedIndex != -1){
	        // Obtener el índice de la opción que se ha seleccionado
			var indiceSeleccionado = tables.selectedIndex;
			// Con el índice y el array "options", obtener la opción seleccionada
			var opcionSeleccionada = tables.options[indiceSeleccionado];
			// Obtener el valor y el texto de la opción seleccionada
			var tableName = opcionSeleccionada.text;
			var tableId = opcionSeleccionada.value;
			tables.options[tables.selectedIndex].selected = false;
			delTableSelected(tableName, tableId);
			if(opcionSeleccionada){
				opcionSeleccionada.parentNode.removeChild(opcionSeleccionada);
			}
			
			//Si no hay mas tablas seleccionamos el radiobutton de vistas en la seccion de factTables
			if (tablearr.length == 0){
				document.getElementById("radFactTable2").checked=true;
				document.getElementById("radFactTable1").checked=false;
				changeRadFact(2);
				document.getElementById("radFactTable2").checked = false;
				document.getElementById("radSelected").value = 2;
			}
	    }
	}
}

function delTableSelected(tableName, tableId){
	delTable(tableId + "-" + tableName); //-> Borramos la tabla seleccionada al array de tablas seleccionadas
	
	//borramos los que habia antes
	borrarTextArea("txtColumns");
	borrarColsSel(tableId, tableName);
	borrarFactCombo(tableId, tableName);
	
	//eliminamos el id de las tablas seleccionadas en el input oculto para su posterior recuperacion en caso que la generacion de error
	var inputTblHidden = document.getElementById("txtTablesSelHid");
	var valInputTblHidden = inputTblHidden.value;
	var indx = valInputTblHidden.indexOf(";"+tableId+";");
	if (indx>=0){
		var indx2 = valInputTblHidden.substring(indx + 1,valInputTblHidden.length).indexOf(";") + indx + 1;
		valInputTblHidden = valInputTblHidden.substring(0,indx) + valInputTblHidden.substring(indx2,valInputTblHidden.length);
	}
	if (valInputTblHidden == ";"){
		valInputTblHidden = "";
	}
	inputTblHidden.value = valInputTblHidden;
}

//Funcion interna para chequear que no se haya agregado ya la tabla
function notIn(value){
	var notIn=true;
	
	for(var i=0;i<document.getElementById("txtTablesSel").options.length;i++){
		var arrPos = (document.getElementById("txtTablesSel").options[i].value);
		if(arrPos == value){
			return false;
		}
	}
	return notIn;
}

//Funcion interna para chequear que no se haya agregado ya la tabla al combo de fact tables
function notInSelFact(value){
	var notIn=true;
	for(var i=0;i<document.getElementById("selFactTable").options.length;i++){
		var arrPos = (document.getElementById("selFactTable").options[i].value);
		if(arrPos == value){
			return false;
		}
	}
	return notIn;
}

//Funcion para mostrar las columnas de la tabla
function showColumns(){
	if (document.getElementById("txtTablesSel").selectedIndex >= 0){
		//borramos los que habia antes
		borrarTextArea("txtColumns");
		var tablesSel = document.getElementById("txtTablesSel");
		
		// Obtener el índice de la opción que se ha seleccionado
		var indiceSeleccionado = tablesSel.selectedIndex;
		// Con el índice y el array "options", obtener la opción seleccionada
		var opcionSeleccionada = tablesSel.options[indiceSeleccionado];
		// Obtener el valor y el texto de la opción seleccionada
		var tableName = opcionSeleccionada.text;
		if (tableName.indexOf("(VIEW)") > 0){
			//Recuperamos las columnas de la vista
			var cols=document.getElementById("viewSQLColumns").value;
			var alias = document.getElementById("txtViewAlias").value;
			if (cols == "NOK"){return;}
			var vwCols = "";
			var colId = 0;
			while (cols.indexOf(",")>-1){
				var oOpt = document.createElement("OPTION");
				oOpt.innerHTML = alias + " (VIEW)." + cols.substring(0,cols.indexOf(","));
				oOpt.value = colId;
				document.getElementById("txtColumns").appendChild(oOpt);
				cols = cols.substring(cols.indexOf(",")+1, cols.length);
				colId ++;
			}
			var oOpt = document.createElement("OPTION");
			oOpt.innerHTML =  alias + " (VIEW)." + cols;
			oOpt.value = colId;
			document.getElementById("txtColumns").appendChild(oOpt);
			return;
		}
		setTimeout("doXMLColumnsLoad('"+tableName+"')",100);
	}
}

//Funcion interna utilizada por showColumns
function doXMLColumnsLoad(tableName){
	var conns = document.getElementById("dbConId");
	// Obtener el índice de la opción que se ha seleccionado
	var indiceSeleccionado = conns.selectedIndex;
	// Con el índice y el array "options", obtener la opción seleccionada
	var opcionSeleccionada = conns.options[indiceSeleccionado];
	// Obtener el valor y el texto de la opción seleccionada
	var conId = opcionSeleccionada.value;
	
	var sXMLSourceUrl = "../programs/biDesigner/cubes/updateColumnsXML.jsp?tableName="+tableName+"&dbConId="+conId+ windowId;
	var listener=new Object();
	listener.onLoad=function(xml){
	readDocColumnsXML(xml);
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}

//Funcion interna utilizada por doXMLLoad
function readDocColumnsXML(sXmlResult){
	var xmlRoot=getXMLRoot(sXmlResult);
	if (xmlRoot.nodeName != "EXCEPTION") {
		for(i=0;i<xmlRoot.childNodes.length;i++){
			var xRow = xmlRoot.childNodes[i];
			var colId=xRow.childNodes[0].firstChild.nodeValue;
			var colName=xRow.childNodes[1].firstChild.nodeValue;
			var oOpt = document.createElement("OPTION");
			oOpt.innerHTML = colName;
			oOpt.value = colId;
			document.getElementById("txtColumns").appendChild(oOpt);
		}
	}else{
		alert("error occurred");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}

//Boton >> Funcion para agregar una columna en el text area de columnas seleccionadas
function addColumn_click(){
	if (document.getElementById("txtColumns").selectedIndex >= 0){
		var columns = document.getElementById("txtColumns");
		while(columns.selectedIndex != -1){
			// Obtener el índice de la opción que se ha seleccionado
			var indiceSeleccionado = columns.selectedIndex;
			// Con el índice y el array "options", obtener la opción seleccionada
			var opcionSeleccionada = columns.options[indiceSeleccionado];
			// Obtener el valor y el texto de la opción seleccionada
			var colName = opcionSeleccionada.text;
			var colId = opcionSeleccionada.value;
			columns.options[columns.selectedIndex].selected = false;
			addColumnSelected(colName,colId);
		}
	}else{
		alert(MSG_MUST_SEL_ONE_COL_FIRST);
	}
}

function addColumnSelected(colName,colId){
	//obtener el nombre de la tabla
	var tables = document.getElementById("txtTablesSel");
	var talName = tables.options[tables.selectedIndex].text;
	var talId = tables.options[tables.selectedIndex].value;
	var oOpt = document.createElement("OPTION");
	if (colName.indexOf(".")<0){
		oOpt.innerHTML = talName + "." + colName;
		oOpt.value = talId + "." + colId;
	}else{
		oOpt.innerHTML = colName;
		oOpt.value = talId + "." + colId;
	}
	
	if(notInColsSel(oOpt.value, oOpt.innerHTML)){
		document.getElementById("txtColumnsSel").appendChild(oOpt);
	}
	
	//Si hay alguna medida, agregamos la columna al combo de las columnas de la grilla de medidas
	var combos = document.getElementsByName("selColumn");
	if (combos.length > 0){
		for(i=0;i<combos.length;i++){
			var oOpt2 = document.createElement("OPTION");
			if (colName.indexOf(".")<0){
				oOpt2.innerHTML = talName + "." + colName;
				oOpt2.value =  talId + "." + colId;
			}else{
				oOpt2.innerHTML = colName;
				oOpt2.value =  talId + "." + colId;
			}
			combos[0].appendChild(oOpt2);
		}
	}
	
	//almacenamos los ids de las cols seleccionadas en un input oculto para su posterior recuperacion en caso que la generacion de error
	var inputColHidden = document.getElementById("txtColumnsSelHid");
	var valInputColHidden = inputColHidden.value;
	if (valInputColHidden == ""){
		inputColHidden.value = oOpt.value +"_"+ oOpt.innerHTML + ";";
	}else{
		inputColHidden.value = valInputColHidden + oOpt.value +"_"+ oOpt.innerHTML + ";";
	}
}

//Boton << Funcion para borrar una columna en el text area de columnas seleccionadas
function delColumn_click(){
	if (document.getElementById("txtColumnsSel").selectedIndex >= 0){
		var columns = document.getElementById("txtColumnsSel");
		while(columns.selectedIndex != -1){
			var opt=document.getElementById("txtColumnsSel").options[document.getElementById("txtColumnsSel").selectedIndex];
			if (notInMeasCols(opt.value)){
				if(opt){
					opt.parentNode.removeChild(opt);
				}
				borrarColsFactSel(opt.value);
				//eliminamos el id de los cols seleccionadas en el input oculto para su posterior recuperacion en caso que la generacion de error
				var inputColHidden = document.getElementById("txtColumnsSelHid");
				var valInputColHidden = inputColHidden.value;
				var indx = valInputColHidden.indexOf(";" + opt.value + "_" + opt.innerHTML +";");
				if (indx>=0){
					var indx2 = valInputColHidden.substring(indx + 1,valInputColHidden.length).indexOf(";") + indx + 1;
					valInputColHidden = valInputColHidden.substring(0,indx) + valInputColHidden.substring(indx2,valInputColHidden.length);
				}
				if (valInputColHidden == ";"){
					valInputColHidden = "";
				}
				inputColHidden.value = valInputColHidden;
			}else{
				alert(MSG_SEL_COL_IS_IN_USE_BY_MSR);
				return;
			}
		}
	}else{
		alert(MSG_MUST_SEL_MEAS_FIRST);
	}
}

function delColumnSelected(opt){
	if (notInMeasCols(opt.value)){
		if(opt){
			opt.parentNode.removeChild(opt);
		}
		borrarColsFactSel(opt.value);
	}
	
	//eliminamos el id de los cols seleccionadas en el input oculto para su posterior recuperacion en caso que la generacion de error
	var inputColHidden = document.getElementById("txtColumnsSelHid");
	var valInputColHidden = inputColHidden.value;
	var indx = valInputColHidden.indexOf(";" + opt.value + "_" + opt.innerHTML +";");
	if (indx>=0){
		var indx2 = valInputColHidden.substring(indx + 1,valInputColHidden.length).indexOf(";") + indx + 1;
		valInputColHidden = valInputColHidden.substring(0,indx) + valInputColHidden.substring(indx2,valInputColHidden.length);
	}
	if (valInputColHidden == ";"){
		valInputColHidden = "";
	}
	inputColHidden.value = valInputColHidden;
}

//Funcion interna para eliminar una columna del textarea de columnas seleccionadas
function borrarColsSel(val,txt){
	var i = 0;
	while(i<document.getElementById("txtColumnsSel").options.length){
		var opt=document.getElementById("txtColumnsSel").options[i];
		var optTxt = opt.text;
		if (optTxt.indexOf(txt)>=0){
			opt.parentNode.removeChild(opt);
		}else{
			i++;
		}
	}
	
	//eliminamos el id de los cols seleccionadas en el input oculto para su posterior recuperacion en caso que la generacion de error
		var inputColHidden = document.getElementById("txtColumnsSelHid");
		var valInputColHidden = inputColHidden.value;
		var indx = valInputColHidden.indexOf(txt);
		while (indx>=0){
			//Buscamos donde esta el primer ';' antes de la primera ocurrencia de txt
			var str1 = valInputColHidden.substring(0,indx);
			var pos2 = str1.indexOf(";");
			var pos1 = 0;
			while (pos2>0){
				pos1 = pos1 + pos2;
				str1 = valInputColHidden.substring(pos1+1,indx);
				pos2 = str1.indexOf(";");
			}
			//en pos1 tenemos la ubicacion del primer ; antes del txt que estamos buscando
			//Buscamos donde esta el ultimo ';' antes de la primera ocurrencia del txt
			str1 = valInputColHidden.substring(indx,valInputColHidden.length);
			var pos3 = str1.indexOf(";") + indx;
			//en pos3 tenemos la ubicacion del ultimo ; antes del txt que estamos busc			
			
			var indx2 = valInputColHidden.substring(indx + 1,valInputColHidden.length).indexOf(";") + indx + 1;
			valInputColHidden = valInputColHidden.substring(0,pos1) + valInputColHidden.substring(pos3,valInputColHidden.length);
			
			var indx = valInputColHidden.indexOf(txt);
		}
		if (valInputColHidden == ";"){
			valInputColHidden = "";
		}
		inputColHidden.value = valInputColHidden;
}

//Funcion interna para chequear que no se haya agregado ya la columna en el textArea de columnas
function notInCols(value){
	var notIn=true;
	for(var i=0;i<document.getElementById("txtColumns").options.length;i++){
		var arrPos = (document.getElementById("txtColumns").options[i].value);
		if(arrPos == value){
			return false;
		}
	}
	return notIn;
}	

//Funcion interna para chequear que no se haya agregado ya la columna en el textArea de columnas seleccionadas
function notInColsSel(value, name){
	var notIn=true;
	for(var i=0;i<document.getElementById("txtColumnsSel").options.length;i++){
		var arrPos = (document.getElementById("txtColumnsSel").options[i].value);
		var arrNam = (document.getElementById("txtColumnsSel").options[i].text);
		
		if (arrNam == name){
			return false;
		}
	}
	return notIn;
}	

////////////////////////////////// FIN FUNCIONES SOLAPA TABLAS DE MAPEO /////////////////////////////////////

///////////////////////////////////FUNCIONES SOLAPA CREAR MEDIDAS //////////////////////////////////////////

//Funcion interna para chequear que no se haya agregado ya la columna en el textArea de columnas de la tabla de hechos
function notInColsFact(value){
	var combos = document.getElementsByName("selColumn");//recupero todos los combos con nombre selColumn
	if (combos.length > 0){//si hay alguno --> hay una medida de tipo Measure
		for(i=0;i<combos.length;i++){//para cada combo
			for(j=0;j<combos[i].options.length;j++){//para cada valor del combo
				var valCmb = combos[i].options[j].value;//obtenemos el valor
				if (valCmb == value){//si es el mismo--> ya existe
					return false;
				}
			}
		}
	}
	return true;
}	

//Funcion interna para eliminar una columna del textarea de columnas de tabla de hechos seleccionadas
function borrarColsFactSel(val){
	var combos = document.getElementsByName("selColumn");//recupero todos los combos con nombre selColumn
	if (combos.length > 0){//si hay alguno --> hay una medida de tipo Measure
		for(i=0;i<combos.length;i++){//para cada combo
			for(j=0;j<combos[i].options.length;j++){//para cada valor del combo
				var valCmb = combos[i].options[j].value;//obtenemos el valor
				if (valCmb == val){
					combos[i].removeChild(combos[i].options[j]);
				}
			}
		}
	}	
}

function notInMeasCols(val){
	var combos = document.getElementsByName("selColumn");//recupero todos los combos con nombre selColumn
	if (combos.length > 0){//si hay alguno --> hay una medida de tipo Measure
		for(i=0;i<combos.length;i++){//para cada combo
			var tablesSel = combos[i];
			// Obtener el índice de la opción que se ha seleccionado
			var indiceSeleccionado = tablesSel.selectedIndex;
			// Con el índice y el array "options", obtener la opción seleccionada
			var opcionSeleccionada = tablesSel.options[indiceSeleccionado];
			// Obtener el valor y el texto de la opción seleccionada
			var tableName = opcionSeleccionada.text;
			var tableId = opcionSeleccionada.value;
			if (val == tableId){
				return false;
			}
		}
	}	
	return true
}

//Funcion interna para eliminar una tabla del combo de tablas de hechos
function borrarFactCombo(val, text){
	//Borramos la tabla del combo de tablas de hecho
	var i = 0;
	while(i<document.getElementById("selFactTable").options.length){
		var opt=document.getElementById("selFactTable").options[i];
		var optTxt = opt.text;
		if (optTxt.indexOf(text)>=0){
			opt.parentNode.removeChild(opt);
		}else{
			i++;
		}
	}
}

//Funcion interna para mostrar las columnas de la tabla de hechos seleccionada en el combo de tablas de hechos
function showFactColumns(){
	if (document.getElementById("txtFact").selectedIndex >= 0){
		//borramos los que habia antes
		borrarTextArea("txtFactColumns");
	
		var tablesSel = document.getElementById("txtFact");
		// Obtener el índice de la opción que se ha seleccionado
		var indiceSeleccionado = tablesSel.selectedIndex;
		// Con el índice y el array "options", obtener la opción seleccionada
		var opcionSeleccionada = tablesSel.options[indiceSeleccionado];
		// Obtener el valor y el texto de la opción seleccionada
		var tableName = opcionSeleccionada.text;
		var tableId = opcionSeleccionada.value;
		for(var i=0;i<document.getElementById("txtColumnsSel").options.length;i++){
			var optId = (document.getElementById("txtColumnsSel").options[i].value);//valor compuesto: tblId.colId
			var optNom = (document.getElementById("txtColumnsSel").options[i].text);//valor compuesto: tblName.colName
			//alert(optNom + "/" + optId);
			//Mostramos solo las columnas seleccionadas de la tabla
			if (optId == 0 && optNom.indexOf(tableName)==0){ //es una recuperada de la base
				var oOpt = document.createElement("OPTION");
				oOpt.innerHTML = optNom;
				oOpt.value = optId;
				//if(notInColsFact(optId)){
					document.getElementById("txtFactColumns").appendChild(oOpt);
				//}
			}else if((optId.indexOf(tableId)==0) && (optNom.indexOf(tableName)==0)){ //es una seleccionada por el usuario
				var oOpt = document.createElement("OPTION");
				oOpt.innerHTML = optNom;
				oOpt.value = optId;
			//	if(notInColsFact(optId)){
					document.getElementById("txtFactColumns").appendChild(oOpt);
			//	}
			}
		}
	//	alert("tableId: "+tableId);
		if (indiceSeleccionado == 0){ //Si se selecciono la fila nula
			borrarAllMeasures();
		}else {
			trows=document.getElementById("gridMeasures").rows;
			if (trows.length>0){
				var val = trows[0].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
				var i = val.indexOf(".");
				var k = val.indexOf(tableId);
				if (k == -1 || k>i){
					borrarAllMeasures();
				}
			}
		}
	}
	document.getElementById("txtFactColumns").style.display="none";
	document.getElementById("txtFactColumns").style.display="block";
}

function fncAddMeasure(){
		var oTd0 = document.createElement("TD"); 
		var oTd1 = document.createElement("TD");
		var oTd2 = document.createElement("TD");
		var oTd3 = document.createElement("TD");
		var oTd4 = document.createElement("TD");
		var oTd5 = document.createElement("TD");
		var oTd6 = document.createElement("TD");
		var oTd7 = document.createElement("TD");
		var oTd8 = document.createElement("TD");
		
		var measureName = "MEASURE" + (document.getElementById("gridMeasures").rows.length + 1);
		
		var useTable = ("1"==document.getElementById("radSelected").value);
		
		//Obtenemos todas las columnas seleccionadas:
		var cantCols = document.getElementById("txtColumnsSel").options.length;
		oTd0.innerHTML = "<input name='txtColSel' value='' style='display:none'>"; //--> Agregamos columna oculta que almacena la info de c/col que viaja al servidor
		//Campo fuente
		var oSelCol = "<select name='selColumn' onchange='changeHidden(this)'>";
	
		//Valores para el campo fuente (segun si se selecciono una tabla o una vista)
		if (useTable){ //Usa tabla existente
			var tblSel = document.getElementById("selFactTable");
			// Obtener el índice de la opción que se ha seleccionado
			var indiceSeleccionado = tblSel.selectedIndex;
			if (indiceSeleccionado < 0){
				alert(MSG_MUST_SEL_ONE_TBL_FIRST);
				return;
			}
			// Con el índice y el array "options", obtener la opción seleccionada
			opcionSeleccionada = tblSel.options[indiceSeleccionado];
			// Obtener el valor y el texto de la opción seleccionada
			var tableSelected = opcionSeleccionada.text;
			
			var firstId;
			var firstNom;
			for(var i=0;i<cantCols;i++){
				var optId = (document.getElementById("txtColumnsSel").options[i].value);//valor compuesto: tblId.colId
				var optNom = (document.getElementById("txtColumnsSel").options[i].text);//valor compuesto: tblName.colName
				var pos = optNom.indexOf(".");
				if (tableSelected == optNom.substring(0,pos)){
					oSelCol = oSelCol + "<option value='" + optId + "'>" + optNom +"</option>";
					if (i==0){
						firstId = optId;
						firstNom = optNom
					}
				}
			}
		}else{ //Usa una vista
			//Recuperamos las columnas de la vista
			var cols = document.getElementById("viewSQLColumns").value;
			var alias = document.getElementById("txtViewAlias").value;
			var id = 0;
			if (cols == "NOK"){return;}
			while (cols.indexOf(",")>-1){
				var optId = id;
				var optNom = alias + "." + cols.substring(0,cols.indexOf(","));
				oSelCol = oSelCol + "<option value='" + optId + "'>" + optNom +"</option>";
				if (id==0){
					firstId = optId;
					firstNom = optNom
				}
				id++;
				cols = cols.substring(cols.indexOf(",")+1,cols.length);
			}
			var optId = id;
			var optNom = alias + "." + cols;
			oSelCol = oSelCol + "<option value='" + optId + "'>" + optNom +"</option>";
		}
		
		oSelCol = oSelCol + "</select>";
		oSelCol = oSelCol + "<input name='hidColumn' type='hidden' size='40' value='" + optNom + "'/>";
		oTd1.innerHTML = oSelCol;
			
		//Nombre
		oTd2.innerHTML = "<input type='text' name='name' onchange='chkMeasName(this,'')' value='" + measureName +"'>"; //--> Agregamos el name
		
		//Nombre a mostrar
		oTd3.innerHTML = "<input type='text' name='capName' onchange='chkMeasCaption(this)' value='" + measureName +"'>"; //--> Agregamos el caption name
			
		var oSelectMed = "";
		//Tipo de medida
		oSelectMed = "<select name='selTypeMeasure' onchange='changeMeasureType(this)'>";
		oSelectMed = oSelectMed + "<option value='0' selected>"+ LBL_MEAS_STANDARD + "</option>";
		oSelectMed = oSelectMed + "<option value='1'>"+ LBL_MEAS_CALCULATED + "</option>";
		oSelectMed = oSelectMed + "</select>";
		oTd4.innerHTML = oSelectMed; //--> Agregamos el combo con lo tipos de medidas
		
		//Opciones de agregador
		
		var type = getColType(firstNom); //Obhtenemos el tipo de la primer columna del combo para mostrar las funciones correspondientes
		
		var oSelect = "<select name='selAgregator' style='display:block'>";
		if (type=="S" || type == "D"){
			oSelect = oSelect + "<option value='2'>COUNT</option>";
			oSelect = oSelect + "<option value='5'>DIST.COUNT</option>";		
		}else{
			oSelect = oSelect + "<option value='0'>SUM</option>";
			oSelect = oSelect + "<option value='1'>AVG</option>";
			oSelect = oSelect + "<option value='2'>COUNT</option>";
			oSelect = oSelect + "<option value='3'>MIN</option>";	
			oSelect = oSelect + "<option value='4'>MAX</option>";
			oSelect = oSelect + "<option value='5'>DIST.COUNT</option>";
		}
		oSelect = oSelect + "</select>";
		oTd5.innerHTML = oSelect; //--> Agregamos el combo con los agregadores
	
		//Formato
		oTd6.innerHTML = "<input type='text' name='format' value='#,###.0'>"; //--> Agregamos el input formato
		//Formula
		oTd7.innerHTML = "<input type='text' name='formula' value='' size=45 style='display:none' title='[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos'>"; //--> Agregamos el input formula
		
		var oTr = document.createElement("TR");
		
		oTr.appendChild(oTd0);
		oTr.appendChild(oTd1);
		oTr.appendChild(oTd2);
		oTr.appendChild(oTd3);
		oTr.appendChild(oTd4);
		oTr.appendChild(oTd5);
		oTr.appendChild(oTd6);
		oTr.appendChild(oTd7);
		oTr.appendChild(oTd8);
		document.getElementById("gridMeasures").addRow(oTr);
		changeHidden(oTr.cells[1].getElementsByTagName("SELECT")[0]);
		
		var rowId = oTr.rowIndex - 1;
		//Visible
		oTd8.innerHTML = "<input type='checkbox' name='visible' value='"+ rowId + "' checked='true'>"; //--> Agregamos el checkbox visible
}

//btn: Agregar Medida --> Abrega una medida
function btnAddMeasure_click() {
/*
Agregado de medidas: Hay dos tipos de medidas: Medidas comunes que utilizan una columna de la tabla de hechos y medidas calculadas que utilzan otras medidas
*/

	// agregamos como tipo Measure por defecto
	
	if (document.getElementById("txtFactTableView").value != ""){ //Si se ingreso una consulta como vista
	
		//Verificamos haya ingresado un alias
		if (document.getElementById("txtViewAlias").value == ""){
			alert(MSG_MUST_ENT_VW_ALIAS_FIRST);
			return;
		}
		//Verificamos que la vista no tenga comillas dobles
		if (document.getElementById("txtFactTableView").value.indexOf("\"")>0){
			alert(MSG_ERROR_IN_SQL_VIEW_WITH_COMS);
			return;
		}
	
		testSqlView('btnAddMeasure', 'afterGetCols'); //Testeamos la sql, recuperamos las columnas y agregamos la medida
		
	}else{
		document.getElementById("btnDelMeasure").disabled = false;
		fncAddMeasure();
	}
}

function getColType(tableCol){
		
	var	http_request = getXMLHttpRequest();
		
	http_request.open('POST', "biDesigner.CubeAction.do?action=getColType"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "tableCol=" + tableCol;
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
   	   if (http_request.status == 200) {
           if(http_request.responseText != "NOK"){
              return http_request.responseText;
           } else {
              return "NOK";
           }
       } else {
               return "Could not contact the server.";  
            }
	}
}

function changeHidden(obj){
	var name = obj.options[obj.selectedIndex].text;
	chgHidValue(obj,name);
	
	//Segun el tipo de la columna seleccionada --> son los tipos de funciones que se pueden utilizar
	var type = getColType(name); //Obtenemos el tipo de la columna seleccionada
//	var tr = col.parentNode.parentNode;
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
		
	var combo = father.cells[5].getElementsByTagName("SELECT")[0];
	//var combo = father.getElementsByTagName("SELECT")[0];
	
	if (type == "N" || type =="S" || type == "D"){
		//1- Borramos todas las funciones del combo Agregador
		//var combo = document.getElementById("selAgregator");
		while(combo.options.length>0){
			combo.options[0].parentNode.removeChild(combo.options[0]);
		}
		
		//2- Agregamos segun el tipo de la columna seleccionada
		var opt;
		if (type=="N"){
			opt=document.createElement("OPTION");
			opt.innerHTML = "SUM";
			opt.value = 0;
			combo.appendChild(opt);
			
			opt=document.createElement("OPTION");
			opt.innerHTML = "AVG";
			opt.value = 1;
			combo.appendChild(opt);
			
			opt=document.createElement("OPTION");
			opt.innerHTML = "COUNT";
			opt.value = 2;
			combo.appendChild(opt);
			
			opt=document.createElement("OPTION");
			opt.innerHTML = "MIN";
			opt.value = 3;
			combo.appendChild(opt);
			
			opt=document.createElement("OPTION");
			opt.innerHTML = "MAX";
			opt.value = 4;
			combo.appendChild(opt);
			
			opt=document.createElement("OPTION");
			opt.innerHTML = "DIST.COUNT";
			opt.value = 5;
			combo.appendChild(opt);
			
		}else{
			opt=document.createElement("OPTION");
			opt.innerHTML = "COUNT";
			opt.value = 2;
			combo.appendChild(opt);
			
			opt=document.createElement("OPTION");
			opt.innerHTML = "DIST.COUNT";
			opt.value = 5;
			combo.appendChild(opt);
		
		}
	}
}
function chgHidValue(obj,name){
	var father = obj.parentNode;
	while(father.tagName!="TD"){
		father=father.parentNode;
	}
	if (father.getElementsByTagName("INPUT")[0] != null){
		father.getElementsByTagName("INPUT")[0].value=name;
	}
}

function chkMeasName(obj,oldName){
	var name = obj.value;
	var cant = 0;
	if (isValidMeasureName(name)){
		if (document.getElementById("gridMeasures").selectedItems.length >= 0){
			trows=document.getElementById("gridMeasures").rows;
			for (i=0;i<trows.length;i++) {
				if (trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value == name) {
					if (cant==1){
						alert(MSG_ALR_EXI_MEAS);		
						trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value = '';
						trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].focus();
						return false;
					}else{
						cant++;
					}
				}
			}
		}
	}else{
		alert(MSG_MEAS_INV_NAME);
		obj.value = '';
		obj.focus();
		return false;
	}
	
	if (oldName!=""){
		if (!confirm(MSG_MEAS_NAME_CHG_ALERT)){
			obj.value = oldName;
			return false;
		}
	}
	return true;
}

function chkMeasCaption(obj){
	var name = obj.value;
	var cant = 0;
	if (isValidMeasureCaption(name)){
		if (document.getElementById("gridMeasures").selectedItems.length >= 0){
			trows=document.getElementById("gridMeasures").rows;
			for (i=0;i<trows.length;i++) {
				if (trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value == name) {
					if (cant==1){
						alert(MSG_ALR_EXI_MEAS_CAP);		
						trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value = '';
						trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].focus();
						return false;
					}else{
						cant++;
					}
				}
			}
		}
	}else{
		alert(MSG_MEAS_INV_CAP);
		obj.value = '';
		obj.focus();
		return false;
	}
}

//btn: Eliminar Medida --> Elimina una medida
function btnDelMeasure_click() {
	if (document.getElementById("gridMeasures").selectedItems.length >= 0){
		var selItem = document.getElementById("gridMeasures").selectedItems[0].rowIndex-1;
		updateVisMeasRowIndex(selItem);
		document.getElementById("gridMeasures").removeSelected();
		if (document.getElementById("gridMeasures").rows.length == 0){
			document.getElementById("btnDelMeasure").disabled = true;
		}
	}else{
		alert(MSG_MUST_SEL_MEAS_FIRST);
	}
}	

//Actualiza el value de los checkbox visibles de todas las medidas 
function updateVisMeasRowIndex(rowIni){
	var trows=document.getElementById("gridMeasures").rows;
	for (var i=rowIni+1;i<trows.length;i++){
		var newRowId = trows[i].getElementsByTagName("TD")[8].getElementsByTagName("INPUT")[0].value - 1;
		trows[i].getElementsByTagName("TD")[8].getElementsByTagName("INPUT")[0].value = newRowId;
	}
}

//Funcion llamada cuando se cambia el tipo de una medida
function changeMeasureType(object){
	var val = object.value;
	var father = object.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	if (val == 0){ //Measure
		var cells=father.cells;
		cells[1].getElementsByTagName("SELECT")[0].style.display='block'; //mostramos column
		cells[3].getElementsByTagName("INPUT")[0].style.display='block'; //mostramos nombre a mostrar
		cells[5].getElementsByTagName("SELECT")[0].style.display='block'; //mostramos aggregator
		cells[6].getElementsByTagName("INPUT")[0].style.display='block'; //mostramos formato
		cells[7].getElementsByTagName("INPUT")[0].style.display='none'; //ocultamos formula
	}else { //Calculated Member
		var cells=father.cells;
		cells[1].getElementsByTagName("SELECT")[0].style.display='none'; //ocultamos column
		cells[3].getElementsByTagName("INPUT")[0].style.display='none'; //ocultamos nombre a mostrar
		cells[5].getElementsByTagName("SELECT")[0].style.display='none'; //ocultamos aggregator
		cells[6].getElementsByTagName("INPUT")[0].style.display='none'; //ocultamos formato
		cells[7].getElementsByTagName("INPUT")[0].style.display='block'; //mostramos formula
		chgHidValue(object,"null");
	}
//	alert(object.parentNode.getElementById(""));
}

//Funcion interna para saber si una medida ya no fue agregada
function notInMeasures(text){
	trows=document.getElementById("gridMeasures").rows;
	
	for (i=0;i<trows.length;i++) {
		if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[2].value == text) {
			return false;
		}
	}
	return true;
}

//Funcion interna para borrar todas las medidas del text area de columnas de la tabla de hechos(usada cuando se cambia la tabla de hechos seleccionada)
function borrarAllMeasures(){
	trows=document.getElementById("gridMeasures").rows;
	var i = 0;
	while (i<trows.length) {
		document.getElementById("gridMeasures").deleteElement(trows[i]);
	}
}

//Funcion interna para borrar una medidas del text area de columnas de la tabla de hechos(usada cuando se elimina una columna seleccionada)
/*
function borrarMedida(value){
	trows=document.getElementById("gridMeasures").rows;
	var i = 0;
	while (i<trows.length) {
		if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == value) {
			document.getElementById("gridMeasures").deleteElement(trows[i]);
		}
		i++;
	}
}
*/
function checkFactTableName(){
	if(isValidName(document.getElementById("txtNewFactTableName").value)){
		document.getElementById("txtNewFactTableName").value = document.getElementById("txtNewFactTableName").value.toUpperCase();
	}else{
		//document.getElementById("txtFactTableName").value = "";
	}
}

function checkFactView(){
	//1.
	//No pasar toda la consulta a mayuscula pq si la consulta quiere buscar por cierto valor de texto en minusculas nunca lo encontraria.
	//document.getElementById("txtFactTableView").value = document.getElementById("txtFactTableView").value.toUpperCase();
	
	//2.Pasamos la consulta a mayuscula menos lo que esta entre comillas
	
	var sql = document.getElementById("txtFactTableView").value;
	
	var subSql = sql;
	var finalSql = "";
	var nextCom = 0;
	var flag=0;
	var entreComillas = "";
	if (subSql.indexOf("'")>0){
		while (subSql.indexOf("'")>0 && flag<30){
			finalSql = finalSql + subSql.substring(0, subSql.indexOf("'")).toUpperCase();	
			nextCom = subSql.substring(subSql.indexOf("'")+1, subSql.length).indexOf("'");
			entreComillas  = subSql.substring(subSql.indexOf("'"), subSql.indexOf("'")+nextCom+2);
			finalSql = finalSql + entreComillas;	
			subSql = subSql.substring(subSql.indexOf("'")+2+nextCom, subSql.length);	
			flag++;
		}
	}
	finalSql = finalSql + subSql.toUpperCase();
	
	document.getElementById("txtFactTableView").value = finalSql;
	
	if (finalSql.indexOf("\"")>0){
		alert(MSG_ERROR_IN_SQL_VIEW_WITH_COMS);
		return;
	}
	
	//Se resuelve dejar a consideración del usuario eliminar las medidas/dimensiones basadas en columnas que ya no recupera la vista,
	// para no hacer ingresar todo nuevamente al usuario por un pequeño cambio en la vista.
	
	//if (document.getElementById("gridMeasures").rows.length > 0 || document.getElementById("treeModel").value != ""){
	//	if (SQL != ""){
	//		var msg = confirm(MSG_MEAS_AND_DIM_WILL_BE_DELETED);
	//		if (msg) {	
	//			SQL = document.getElementById("txtFactTableView").value;
	//			borrarAllMeasures();//Borramos todas las medidas y dimensiones
	//			document.getElementById("treeModel").value = "";
	//		}else{
	//			document.getElementById("txtFactTableView").value = SQL;
	//		}
	//	}else{
	//		SQL = document.getElementById("txtFactTableView").value;
	//		borrarAllMeasures();//Borramos todas las medidas y dimensiones
	//		document.getElementById("treeModel").value = "";
	//	}
	//}
}

function checkAliasViewName(){
	var alias = document.getElementById("txtViewAlias").value;
	
	if (alias.indexOf("-")>=0){
		alert(MSG_WRONG_NAME);
		document.getElementById("txtViewAlias").value = "";
		document.getElementById("txtViewAlias").focus();
		return;
	} 
	if (isValidName(alias)){
		document.getElementById("txtViewAlias").value = alias.toUpperCase();
	}else{
		document.getElementById("txtViewAlias").value = "";
		document.getElementById("txtViewAlias").focus();
	}
}

function changeSelFactTable(){
	var tblSel = document.getElementById("selFactTable");
	// Obtener el índice de la opción que se ha seleccionado
	var indiceSeleccionado = tblSel.selectedIndex;
	if (indiceSeleccionado >= 0){
		// Con el índice y el array "options", obtener la opción seleccionada
		opcionSeleccionada = tblSel.options[indiceSeleccionado];
		// Obtener el valor y el texto de la opción seleccionada
		var tblName = opcionSeleccionada.text;
		document.getElementById("txtSelFactTable").value = tblName;
	}
	
	borrarAllMeasures()//Borramos todas las medidas
	reloadTableColTypes(); //Recargamos los tipos de columna de la tabla de hechos
}

function reloadTableColTypes(){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "biDesigner.CubeAction.do?action=reloadTableColTypes"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	
	var tblSel = document.getElementById("selFactTable");
	// Obtener el índice de la opción que se ha seleccionado
	var indiceSeleccionado = tblSel.selectedIndex;
	// Con el índice y el array "options", obtener la opción seleccionada
	if (indiceSeleccionado == -1) return;
	opcionSeleccionada = tblSel.options[indiceSeleccionado];
	// Obtener el valor y el texto de la opción seleccionada
	var tableSelected = opcionSeleccionada.text;
	
	var str = "tableName=" + tableSelected;
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
   	   if (http_request.status == 200) {
           if(http_request.responseText != "NOK"){
              return http_request.responseText;
           } else {
              return "NOK";
           }
       } else {
               return "Could not contact the server.";  
       }
	}
}

function changeRadFact(val){
	if (val == 1){
		document.getElementById("radSelected").value = 1;
		document.getElementById("selFactTable").disabled=false;
		document.getElementById("txtViewAlias").disabled=true;
		setRequiredField(document.getElementById("selFactTable"));
		document.getElementById("txtFactTableView").disabled=true;
		document.getElementById("btnTestSql").disabled=true;
		document.getElementById("btnChangeSql").disabled=true;
		unsetRequiredField(document.getElementById("txtFactTableView"));
		unsetRequiredField(document.getElementById("txtViewAlias"));
		document.getElementById("txtFactTableView").value="";
		document.getElementById("hidFactTableView").value="";
		document.getElementById("txtViewAlias").value="";
		document.getElementById("btnAddMeasure").disabled=false;
		document.getElementById("btnDelMeasure").disabled=true;
		changeSelFactTable();
		borrarAllMeasures()
	}else {
		document.getElementById("radSelected").value = 2;
		document.getElementById("txtFactTableView").disabled=false;
		document.getElementById("txtViewAlias").disabled=false;
		document.getElementById("btnTestSql").disabled=false;
		document.getElementById("btnChangeSql").disabled=true;
		setRequiredField(document.getElementById("txtFactTableView"));
		setRequiredField(document.getElementById("txtViewAlias"));
		document.getElementById("selFactTable").disabled=true;
		unsetRequiredField(document.getElementById("selFactTable"));
		document.getElementById("btnAddMeasure").disabled=true;
		document.getElementById("btnDelMeasure").disabled=true;
		//document.getElementById("selFactTable").options[0].selected=true;
		borrarAllMeasures()
	}
}

function getSqlViewColumns(from, after){
	if (document.getElementById("txtFactTableView") == null){
		return;
	}
	var sql = document.getElementById("txtFactTableView").value;
	var alias = document.getElementById("txtViewAlias").value;
	if (sql=="" && alias==""){
		return;
	}
	if (sql == ""){
		alert(MSG_MUST_ENT_ONE_VIEW_FIRST);
		return 'NOK';
	}
	if (alias == ""){
		//alert(MSG_MUST_ENT_VW_ALIAS_FIRST);
		return 'NOK';
	}

	testSqlView(from,after);
}

function afterOnLoad(msg){
	var loader=new xmlLoader();
	var xml=loader.loadString(msg);
	if(xml.firstChild.firstChild.nodeValue!="NOK"){
		document.getElementById("viewSQLColumns").value= xml.firstChild.firstChild.nodeValue;
	}else if(xml.firstChild.firstChild.nodeValue == "NOK"){
		alert(MSG_ERROR_FACT_TABLE_VIEW);
	}else{
		alert ("Could not contact the server.");  
	}
}

function afterSQLModify(msg){
	var loader=new xmlLoader();
	var xml=loader.loadString(msg);
	if(xml.firstChild.firstChild.nodeValue=="NOK"){ //Error al recuperar las columnas de la vista
		alert("ERROR RETRIEVING THE COLUMNS OF ACTUAL VIEW");
		return;
	}else{//Se recuperaron las columnas correctamente!
		document.getElementById("viewSQLColumns").value = xml.firstChild.firstChild.nodeValue;
	}
}

function btnTestSqlView(){
	testSqlView('btnTest', 'afterTest');
}

function btnChangeSqlView(){
	if (document.getElementById("gridMeasures").rows.length > 0){
		var msg = confirm("Se eliminaran todas las medidas. ¿Desea continuar?");
		if (msg) {
			borrarAllMeasures();
			document.getElementById("txtFactTableView").disabled = false;
			document.getElementById("btnAddMeasure").disabled = true;
		}
	}
}

//This function returns a message
function testSqlView(from, after){
	document.getElementById("hidFactTableView").value = document.getElementById("txtFactTableView").value;
	var dbConId = document.getElementById("dbConId").value;
	var alias = document.getElementById("txtViewAlias").value;
	var action=document.getElementById("frmMain").action;
	document.getElementById("frmMain").target="testSql";
	document.getElementById("frmMain").action=("biDesigner.CubeAction.do?action=sqlTest"+windowId+"&dbConId="+dbConId+"&alias="+alias+"&from="+from+"&after="+after);
	submitForm(document.getElementById("frmMain"));
	document.getElementById("frmMain").action=action;
	document.getElementById("frmMain").target="_self";
}

function afterTest(msg){
	var loader=new xmlLoader();
	var xml=loader.loadString(msg);
	if(xml.firstChild.firstChild.nodeValue=="OK"){
		document.getElementById("txtFactTableView").disabled = true;
		document.getElementById("btnAddMeasure").disabled = false;
		document.getElementById("btnChangeSql").disabled= false;
		alert("SQL OK!");
	}else{
		alert("SQL ERROR: " + xml.firstChild.firstChild.nodeValue);
	}
}

function afterGetCols(msg){
	var loader=new xmlLoader();
	var xml=loader.loadString(msg);
	if(xml.firstChild.firstChild.nodeValue=="NOK"){ //Error al recuperar las columnas de la vista
		alert("ERROR RETRIEVING THE COLUMNS OF ACTUAL VIEW");
		return;
	}else{//Se recuperaron las columnas correctamente!
		document.getElementById("viewSQLColumns").value = xml.firstChild.firstChild.nodeValue;
		document.getElementById("btnDelMeasure").disabled = false;
		fncAddMeasure();
	}
}

function getXMLHttpRequest(){

		var http_request = null;
		if (window.XMLHttpRequest) {
			// browser has native support for XMLHttpRequest object
			http_request = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			// try XMLHTTP ActiveX (Internet Explorer) version
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


///////////////////////////////////FIN DE FUNCIONES SOLAPA CREAR MEDIDAS //////////////////////////////////////////

//////////////////////////////// FUNCIONES SOLAPA CREAR DIMENSIONES (FLASH) //////////////////////////

function testSqlViewFlash(sql,table){
	if (table == null || table == ""){
		alert(MSG_MUST_SEL_ONE_PKEY_FIRST);
		return false;
	}

	//1. Chequeamos el formato de la vista sea correcto: SELECT * FROM TABLE WHERE ..
	var fromPos = sql.indexOf("FROM");
	var wherePos = sql.indexOf("WHERE");
	
	if (wherePos < 0){
		wherePos = sql.length;
	}
	
	if (sql.substring(fromPos+4,wherePos-1).indexOf(",")>0){ //HAY MAS DE UNA TABLA
		alert(MSG_VW_REF_ONL_ONE_TABLE);
		return false;
	}
	
	//2. Chequeamos que la tabla referenciada por la vista sea igual a la pasada por parametro
	var sqlTable;
	if (sql.indexOf("WHERE") < 0){
		sqlTable = sql.substring(fromPos+5,wherePos);
	}else{
		sqlTable = sql.substring(fromPos+5,wherePos-1);	
	}
	
	if (sqlTable.toLowerCase() != table.toLowerCase()){
		alert(MSG_TBL_REF_BY_VW + " " + table);
		return false;
	}
	
	//3. Chequeamos la correctitud de la vista
	var dbConId = document.getElementById("dbConId").value;
	var loader=new xmlLoader();
	loader.onload=function(xml){
		if(xml.firstChild.nodeValue != "OK"){
           alert("SQL ERROR: " + xml.firstChild.nodeValue);
			return false;
        } else {
           alert("SQL OK!");
			return true;
        }
	}
	var str = "sql=" + encodeURIComponent(sql) + "&dbConId="+dbConId;
	loader.load(URL_ROOT_PATH+"/biDesigner.CubeAction.do?action=sqlTest"+windowId+"&"+str);
	
}

//Usada por el flash: Devuelve las tablas y entidades seleccionadas para el cubo
function getSelectedTables(){
	var str = '';
	var size = tablearr.length;
	var pos = 0;
	while (pos < size){
		if (pos == 0){
			str = tablearr[pos];
		}else {
			str = str + ";" + tablearr[pos];
		}
		pos ++;
	}
	return str;
}

//Usada por el flash: Devuelve string con el sig formato: idTable.idCol-nomTable.nomCol;idTable.idCol-nomTable.nomCol;....
function getSourceColumns(){
	var columns = document.getElementById("txtColumnsSel");
	var result = '';
	if (columns != null){
		for(var i=0;i<columns.options.length;i++){
			var valueNum = columns.options[i].value;//-> contiene algo del sig formato: idTable.idCol
			var valueTxt = columns.options[i].text; //-> contiene algo del sig formato: nomTable.nomCol
			if (valueTxt.indexOf(" (VIEW)")<0 && (document.getElementById("txtViewAlias").value == "" || valueTxt.indexOf(document.getElementById("txtViewAlias").value + ".")<0)){ //No agregamos las col de la vista pues se agregan todas mas adelante
				if (result == ''){
					result = valueNum + "-" + valueTxt;
				}else {
					result = result + ";" + valueNum + "-" + valueTxt;
				}
			}
		}
	}
	//Nos fijamos si se esta usando una vista como fact table
	//if (columns.value!= "" && "2"==document.getElementById("radSelected").value){
	if ("2"==document.getElementById("radSelected").value){
		//Recuperamos las columnas de la vista
		var cols=document.getElementById("viewSQLColumns").value;
		var alias = document.getElementById("txtViewAlias").value;
		var id = 0;
		if (cols == "NOK"){return;}
		while (cols.indexOf(",")>-1){
			if (result == ''){
				//result = "0." + id + "-" + alias + " (VIEW)." + cols.substring(0,cols.indexOf(","));
				result = "0." + id + "-" + alias + "." + cols.substring(0,cols.indexOf(","));
			}else{
				//result = result + ";" + "0." + id + "-" + alias + " (VIEW)." + cols.substring(0,cols.indexOf(","));
				result = result + ";" + "0." + id + "-" + alias + "." + cols.substring(0,cols.indexOf(","));
			}
			id++;
			cols = cols.substring(cols.indexOf(",")+1,cols.length);
		}
		if (result == ''){
			//result = "0." + id + "-" + alias + " (VIEW)." + cols.substring(0,cols.indexOf(","));
			result = "0." + id + "-" + alias + "." + cols.substring(0,cols.indexOf(","));
		}else{
			//result = result + ";" + "0." + id + "-" + alias + " (VIEW)." + cols;
			result = result + ";" + "0." + id + "-" + alias + "." + cols;
		}
	
	}
	return result;
}

//Usada por el flash: Devuelve un string con el siguiente formato: "colId-colName;colId-colName;...."
function getTableCols(tableId, tableName){
	var columns = document.getElementById("txtColumnsSel");
	var result = '';
	if (columns != null){
		for(var i=0;i<columns.options.length;i++){
			var valueNum = columns.options[i].value;//-> contiene algo del sig formato: idTable.idCol
			var valueTxt = columns.options[i].text; //-> contiene algo del sig formato: nomTable.nomCol
			var indTblId = valueNum.indexOf(tableId);
			var indPtoId = valueNum.indexOf(".");
			var indTblNam = valueTxt.indexOf(tableName);
			var indPtoNam = valueTxt.indexOf(".");
			
			if (indTblId != -1 && indTblNam != -1){
				if (indTblId < indPtoId && indTblNam < indPtoNam){
					var colId = valueNum.substring(indPtoId+1, valueNum.length);
					var colName = valueTxt.substring(indPtoNam+1, valueTxt.length);
					result = result + ";" + colId + "-"+ colName;
				}
			}
		}
		if (result.length > 0){
			return result.substring(1,result.length);	
		} else {
			return '';
		}
	}else {
			return '';
	}
}

//Usada por el flash: Devuelve un string con el siguiente formato: "colId-colName;colId-colName;...."
function getFactColumns(){
	var i = 0;
	var result = '';
	//Nos fijamos si se esta usando una tabla como fact table
	if ("1"==document.getElementById("radSelected").value){ //Usa tabla existente
		var tblSel = document.getElementById("selFactTable");
		// Obtener el índice de la opción que se ha seleccionado
		var indiceSeleccionado = tblSel.selectedIndex;
		// Con el índice y el array "options", obtener la opción seleccionada
		if (indiceSeleccionado == -1) return;
		opcionSeleccionada = tblSel.options[indiceSeleccionado];
		// Obtener el valor y el texto de la opción seleccionada
		var tableSelected = opcionSeleccionada.text;
		
		while(i<document.getElementById("txtColumnsSel").options.length){
			var opt=document.getElementById("txtColumnsSel").options[i];
			var column = opt.text;
			pos = column.indexOf(".");
			if (tableSelected == column.substring(0,pos)){
				if (result == ''){
					result = opt.value + "-" + opt.text;
				}else {
					result = result + ";" + opt.value + "-" + opt.text;
				}
			}
			i++;
		}
	//}else if (document.getElementById("txtColumnsSel").value!=""){ //Usa vista
	}else if ("2"==document.getElementById("radSelected").value){
		//Recuperamos las columnas de la vista
		var cols = document.getElementById("viewSQLColumns").value;
		var alias = document.getElementById("txtViewAlias").value;
		if (cols == "NOK"){return;}
		while (cols.indexOf(",")>-1){
			if (result == ''){
				result = "0." + i + "-" + alias + "." + cols.substring(0,cols.indexOf(","));
			}else{
				result = result + ";" + "0." + i + "-" + alias + "." + cols.substring(0,cols.indexOf(","));
			}
			i++;
			cols = cols.substring(cols.indexOf(",")+1,cols.length);
		}
		if (result == ''){
			result = "0." + i + "-" + alias + "." + cols.substring(0,cols.indexOf(","));
		}else{
			result = result + ";" + "0." + i + "-" + alias + "." + cols;
		}
	}
	
	return result;
}

//Usada por el flash: Devuelve un string con el siguiente formato: "dim1;dim2;..;dimX";
function getSharedDimensions(){
	//dimShared --> Ej: "schema1.dim1-dim2-dim3;schema2.dim1-dim2;..."
	var result = "";
	if (document.getElementById("selSch").selectedIndex >= 0){
		var colSel = document.getElementById("selSch");
		// Obtener el índice de la opción que se ha seleccionado
		var indiceSeleccionado = colSel.selectedIndex;
		// Con el índice y el array "options", obtener la opción seleccionada
		var opcionSeleccionada = colSel.options[indiceSeleccionado];
		// Obtener el valor y el texto de la opción seleccionada
		var schName = opcionSeleccionada.text;
		
		var indSch = dimShared.indexOf(schName);
		var substr = dimShared.substring(indSch,dimShared.length);
		var indPtoyC = substr.indexOf(";");
		if (indPtoyC > -1){
			substr = substr.substring(0,indPtoyC);
		}
		var pto = substr.indexOf(".");
		result = substr.substring(pto+1,substr.length);
	}
	return result;
}
//////////////////////////////// FIN FUNCIONES SOLAPA CREAR DIMENSIONES (FLASH) //////////////////////////

///////////////// FUNCIONES DE USO GRAL ////////////////

//Funcion interna para borrar un textArea dado su nombre
function borrarTextArea(name){
	while(document.getElementById(name).options.length>0){
		var opt=document.getElementById(name).options[0];
		if(opt){
			opt.parentNode.removeChild(opt);
		}
	}
}

//verifica que sea un nombre de medida valido
function isValidMeasureName(s){
	var reAlphanumerico = /^[a-z_A-Z0-9 ]*$/;
	var x = reAlphanumerico.test(s);
	if(!x){
		return false;
	}
	return true;
}

//verifica que sea un caption de medida valido
function isValidMeasureCaption(s){
	var reAlphanumerico = /^[a-z_A-Z0-9]*$/;
	var x = reAlphanumerico.test(s);
	if(!x){
		return false;
	}
	return true;
}

function verifyPermissions(){
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