function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("repName").value)){
			if (verifyOtherReqObjects() && verifyPermissions()){
				if (checkParNames()){
					document.getElementById("frmMain").action = "administration.ReportAction.do?action=confirm" + windowId;
					submitForm(document.getElementById("frmMain"));
				}else{
					alert(MSG_REP_NAME_UNIQUE);
				}
			}
		}
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
			document.getElementById("frmMain").action = "administration.ReportAction.do?action=backToList" + windowId;
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "administration.ReportAction.do?action=backToList" + windowId;
		submitForm(document.getElementById("frmMain"));
	}
}

function verifyOtherReqObjects(){
	//1. Verificamos que el archivo seleccionado sea *.prpt
	var fileName = document.getElementById("fileName").value;
	if (document.getElementById("repId").value == 0 || fileName != ""){
		if (fileName.indexOf(".prpt") < 0 || fileName.indexOf(".prpt") != fileName.length - 5){
			alert(MSG_MUST_SEL_PRPT_FILE);
			return false;
		}
	}
	//2. Si no se selecciono conexion nativa -> verificamos que la sql ingresada sea valida
	if (document.getElementById("conxSel").value != CON_TYPE_NATIVE){
		if (isSqlOk()){
			return true;
		}else{
			var msg = confirm(MSG_QUERY_WITH_ERRORS);
			if (msg) {
				return true;
			}else{
				return false;
			}
		}
	}
	//3. Verificamos se haya seleccionado un tipo de datos en los parametros que ingresa el usuario en la ejecucion o en los que ingresa en el diseño
	trows=document.getElementById("tblParam").rows;
	for (i=0;i<trows.length;i++) {
		var parIndex = i;
		var parValue = trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
		var parValType = trows[i].getElementsByTagName("TD")[3].getElementsByTagName("SELECT")[0].value;
		var parType = trows[i].getElementsByTagName("TD")[4].getElementsByTagName("SELECT")[0].value;
		if (parType < 1){
			var parName = trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
			if (parValType != null && parValType == 'E'){
				alert(MSG_PAR_WITHOUT_TYPE.replace("<TOK1>", parName));
				return false;
			}
			if (parType == 0 && (parValue == null || parValue == '')){
				alert(MSG_PAR_MISSING_VALUE.replace("<TOK1>", parName));
				return false;
			}
		}
	}
	return true;
}

function btnDownload_click(){
	document.getElementById("frmMain").action = "administration.ReportAction.do?action=download" + windowId;
	document.getElementById("frmMain").target="downloadFrame";
	var downloadFrame=document.getElementById("downloadFrame");
	if(MSIE){
		downloadFrame.onreadystatechange=function(){
			if (document.getElementById("downloadFrame").readyState=="interactive"){
				hideResultFrame();
			}
		}
	}else{
		/*document.getElementById("downloadFrame").onreadystatechange=function(){
			hideResultFrame();
		}*/
		//document.getElementById("downloadFrame").addEventListener('readystatechange', function(){alert("sebadu")}, false);
		
		setTimeout(endDownload,1000);
	}
	submitForm(document.getElementById("frmMain"));
	document.getElementById("frmMain").target="_self";
}

function endDownload(){
	var sXMLSourceUrl = "administration.ReportAction.do?action=checkDownloadFinish";
	var xmlLoad=new xmlLoader();
	xmlLoad.onload=function(xml){
		if ("true" == this.textLoaded){
			hideResultFrame();
		}else {
			setTimeout(endDownload,1000);
		}
	}
	xmlLoad.load(sXMLSourceUrl);
}

function btnAdd_click(){
	var trows=document.getElementById("tblParam").rows;
	var oTd0 = document.createElement("TD"); //oculto
	var oTd1 = document.createElement("TD"); //nombre del parametro
	var oTd2 = document.createElement("TD"); //desc del parametro
	var oTd3 = document.createElement("TD"); //tipo
	var oTd4 = document.createElement("TD"); //valor por defecto
	var oTd5 = document.createElement("TD"); //requerido
	
	oTd0.innerHTML = '<input type="hidden" id="idSel" name="chkSel' + trows.length + '">';
	
	//Nombre
	oTd1.innerHTML = '<input p_required="true" id="txtParName" name="txtParName" maxlength="50" size=35 type="text">';
	
	//Descripcion
	oTd2.innerHTML = '<input id="txtParDesc" name="txtParDesc" maxlength="200" size=40 type="text">';
		
	//Tipo de parametro
	var oSelectMed = "";
	oSelectMed = '<select id="cmbParType' + (trows.length) + '" name="cmbParType' + (trows.length) + '" onchange="changeParType(' + (trows.length) + ')" >';
	oSelectMed = oSelectMed + "<option value='E'></option>";
	oSelectMed = oSelectMed + "<option value='S' selected>"+ LBL_PAR_STRING + "</option>";
	oSelectMed = oSelectMed + "<option value='N'>"+ LBL_PAR_NUMERIC + "</option>";
	oSelectMed = oSelectMed + "<option value='D'>"+ LBL_PAR_DATE + "</option>";
	oSelectMed = oSelectMed + "<option value='I'>"+ LBL_PAR_INT + "</option>";
	oSelectMed = oSelectMed + "</select>";
	oTd3.innerHTML = oSelectMed; //--> Agregamos el combo con lo tipos de parametros
	
	//Valor por defecto
	oTd4.innerHTML = '<input grid="true" colLabel="'+LBL_DEF_VALUE+'" id="txtParValue' + (trows.length) + '" disabled name="txtParValue' + (trows.length) + '" title="' + LBL_ENT_DEF_VALUE + '" type="text" maxlength="50" onchange="changeParValue(' + (trows.length) + ')" size=15 value="">';
	var oSelectDefVal = "";
	oSelectDefVal = '<select style="margin-left:3px" id="cmbParValue' + (trows.length) + '" name="cmbParValue' + (trows.length) + '" title="' + LBL_SEL_DEF_VALUE + '" onchange="changeDefValue(' + (trows.length) + ')">';
	oSelectDefVal = oSelectDefVal +	'<option value="' + REP_DEF_VALUE_TYPE_VARIABLE + '" selected></option>';
	oSelectDefVal = oSelectDefVal +	'<option value="' + REP_DEF_VALUE_TYPE_FIXED + '">-' + LBL_ENT_DEF_VALUE + '-</option>';
	oSelectDefVal = oSelectDefVal +	'<option value="' + REP_DEF_VALUE_TYPE_USER_ID + '">' + LBL_REP_USER_ID + '</option>';
	oSelectDefVal = oSelectDefVal +	'<option value="' + REP_DEF_VALUE_TYPE_USER_NAME + '">' + LBL_REP_USER_NAME + '</option>';
	oSelectDefVal = oSelectDefVal +	'<option value="' + REP_DEF_VALUE_TYPE_ENV_ID + '">' + LBL_REP_ENV_ID + '</option>';
	oSelectDefVal = oSelectDefVal +	'<option value="' + REP_DEF_VALUE_TYPE_ENV_NAME + '">' + LBL_REP_ENV_NAME + '</option>';
	oSelectDefVal = oSelectDefVal + "</select>";
	oTd4.innerHTML = oTd4.innerHTML + oSelectDefVal; //--> Agregamos el combo de valor por defecto
	
	//Checkbox de requerido
	oTd5.innerHTML = '<input type="checkbox" id="parReq' + (trows.length) + '" name="parReq' + (trows.length) + '" value="'+ trows.length + '">'; 		
	
	var oTr = document.createElement("TR");
	
	oTr.appendChild(oTd0);
	oTr.appendChild(oTd1);
	oTr.appendChild(oTd2);
	oTr.appendChild(oTd3);
	oTr.appendChild(oTd4);
	oTr.appendChild(oTd5);
	
	document.getElementById("tblParam").addRow(oTr);
}

function changeDefValue(indx){
	if (document.getElementById("cmbParValue" + indx).value > 0 || document.getElementById("cmbParValue" + indx).value < 0){
		document.getElementById("txtParValue" + indx).value = "";
		document.getElementById("txtParValue" + indx).disabled = true;
	}else{
		document.getElementById("txtParValue" + indx).disabled = false;
	}
	
	if (document.getElementById("cmbParValue" + indx).value >= 0){
		document.getElementById("parReq" + indx).checked = false;
		document.getElementById("parReq" + indx).disabled = true;
		if (document.getElementById("cmbParValue" + indx).value > 0){
			document.getElementById("cmbParType" + indx).selectedIndex = 0;
			document.getElementById("cmbParType" + indx).disabled = true;
		}
	}else{
		document.getElementById("parReq" + indx).disabled = false;
		document.getElementById("cmbParType" + indx).disabled = false;
	}
}
function changeParType(indx){
	if (document.getElementById("cmbParType" + indx).value == 'N' || document.getElementById("cmbParType" + indx).value == 'I'){
		//document.getElementById("txtParValue" + indx).value="";
		setNumericField(document.getElementById("txtParValue" + indx));
	}else{ 
		unsetNumericField(document.getElementById("txtParValue" + indx))
	}
}
function changeParValue(indx){
	//document.getElementById("cmbParValue" + indx).selectedIndex = 0;
}

function btnDel_click(){
	if (document.getElementById("tblParam").selectedItems.length > 0){
		var trows=document.getElementById("tblParam").rows;
		var selItem = document.getElementById("tblParam").selectedItems[0].rowIndex-1;
		document.getElementById("tblParam").removeSelected();
	}else{
		alert(MSG_MUST_SEL_PAR_FIRST);
	}
}

function btnUp_click(){
	var grid=document.getElementById("tblParam");
	var cant=grid.selectedItems.length;
	if(cant != 0) {
		if(cant == 1) {
			grid.moveSelectedUp();
		} else if (cant > 1) {
			alert(GNR_CHK_ONLY_ONE);
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnDown_click(){
	var grid=document.getElementById("tblParam");
	var cant=grid.selectedItems.length;
	if(cant != 0) {
		if(cant == 1) {
			grid.moveSelectedDown();
		} else if (cant > 1) {
			alert(GNR_CHK_ONLY_ONE);
		}
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	}
}

function checkParNames(){
	trows=document.getElementById("tblParam").rows;
	for (i=0;i<trows.length;i++) {
		var parIndex = i;
		var parName = trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
		for (j=0;j<trows.length;j++){
			var parIndex2 = j;
			var parName2 = trows[j].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
			if (parIndex != parIndex2 && parName == parName2){
				return false; //se repite el nombre de un parametro
			}
		}
	}
	return true; //no se repite el nombre de ninguna parametro
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

function cmbSource_refresh(){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.ReportAction.do?action=source"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "";
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
			 var conxs = http_request.responseText;
		     if(conxs != "NOK"){
		         //Vaciamos el combo de conexiones
		         var selConx= document.getElementById("dbConId");
				 while(selConx.options.length>0){
				 	selConx.removeChild(selConx.options[0]);
				 }
				 //Volver a llenar el combo de conexiones
				 while (conxs!=""){
				 	 var conxId = conxs.substring(0,conxs.indexOf(";"));
				 	 conxs = conxs.substring(conxs.indexOf(";")+1, conxs.length);
				 	 var conxName;
				 	 if (conxs.indexOf(";")>0){
				 	 	conxName = conxs.substring(0,conxs.indexOf(";"));
				 	 	conxs = conxs.substring(conxs.indexOf(";")+1, conxs.length);
				 	 }else{
				 	 	conxName = conxs;
				 	 	conxs="";
				 	 }
				 	 var opt=document.createElement("OPTION");
				 	 opt.innerHTML=conxName;
				 	 opt.value=conxId;
				 	 selConx.appendChild(opt);
				 }
				 //habilitamos nombre consulta y text area
				document.getElementById("repQuery").disabled = false;
				document.getElementById("repQryName").disabled = false;
				setRequiredField(document.getElementById("repQuery"));
				document.getElementById("btnTestSql").disabled = false;
				setRequiredField(document.getElementById("repQryName"));
		     }else{
				     alert("ERROR");
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
}

function cmbSource_change(){
	var cmbCnxSel = document.getElementById("dbConId");
	var cnxId = cmbCnxSel.options[cmbCnxSel.selectedIndex].value;
	document.getElementById("conxSel").value = cnxId;
	if (cnxId == CON_TYPE_NATIVE){
		//deshabilitamos nombre consulta y text area 
		document.getElementById("repQuery").value = "";
		document.getElementById("repQryName").value = "";
		document.getElementById("repQuery").disabled = true;
		document.getElementById("repQryName").disabled = true;
		unsetRequiredField(document.getElementById("repQuery"));
		unsetRequiredField(document.getElementById("repQryName"));
		document.getElementById("btnTestSql").disabled = true;
	}else{
		//habilitamos nombre consulta y text area
		document.getElementById("repQuery").disabled = false;
		document.getElementById("repQryName").disabled = false;
		setRequiredField(document.getElementById("repQuery"));
		document.getElementById("btnTestSql").disabled = false;
		setRequiredField(document.getElementById("repQryName"));
	}
}

function testSqlView(){
	var sql = document.getElementById("repQuery").value;
	//Nos fijamos si contiene parámetros
	if (sql.indexOf("${")>0){
		alert(LBL_REP_QRY_TST_PARAMS);
	}else{
		var dbConId = document.getElementById("conxSel").value;
		
		var	http_request = getXMLHttpRequest();
			
		http_request.open('POST', "administration.ReportAction.do?action=sqlTest"+windowId, false);
		http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
		
		var str = "sql=" + sql + "&dbConId="+dbConId;
		http_request.send(str);
		    
		if (http_request.readyState == 4) {
	   	   if (http_request.status == 200) {
	           if(http_request.responseText != "OK"){
	              alert("SQL ERROR: " + http_request.responseText);
	           } else {
	              alert("SQL OK!");
	           }
	       } else {
	               alert("Could not contact the server.");            
	            }
		}
	}
}

function isSqlOk(){
	var sql = document.getElementById("repQuery").value;
	//Nos fijamos si contiene parámetros
	if (sql.indexOf("${")>0){
		return true;
	}else{
		var dbConId = document.getElementById("conxSel").value;
		
		var	http_request = getXMLHttpRequest();
			
		http_request.open('POST', "administration.ReportAction.do?action=sqlTest"+windowId, false);
		http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
		
		var str = "sql=" + sql + "&dbConId="+dbConId;
		http_request.send(str);
		    
		if (http_request.readyState == 4) {
	   	   if (http_request.status == 200) {
	           if(http_request.responseText != "OK"){
	              return false;
	           } else {
	              return true;
	           }
	       } else {
	               alert("Could not contact the server.");            
	            }
		}
	}
}

function setPNumeric(){
	var inputs=document.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].getAttribute("p_numeric")=="true"){
			setNumericField(inputs[i]);
		}
	}

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
