function btnConf_click(){
	var widType = document.getElementById("cmbType").value;
	if (widType==WIDGET_TYPE_KPI_ID){ //Si se cambio el tipo de widget
		btnNext_click();
	}else{
		if (verifyRequiredObjects()) {
			if (verifyBasicObjects() && verifyPermissions()){
				if(isValidName(document.getElementById("widNom").value)){
					document.getElementById("frmMain").action = "biDesigner.WidgetAction.do?action=confirm" + windowId;
					submitForm(document.getElementById("frmMain"));
				}
			}
		}
	}
}

function btnKPIConf_click(){
	if (verifyRequiredObjects()) {
		if (verifyKPIReqObjects()) {
			document.getElementById("frmMain").action = "biDesigner.WidgetAction.do?action=kpiConfirm" + windowId;
			submitForm(document.getElementById("frmMain"));
		}
	}
}

function btnNext_click(){
	var widName = document.getElementById("widNom").value;
	var srcType = document.getElementById("cmbSrcType").value;
	var widType = document.getElementById("cmbType").value;
	
	if(isValidName(widName)){
		if (verifyRequiredObjects()) {
			if (verifyBasicObjects()) {
				if (widType == WIDGET_TYPE_KPI_ID && srcType == WIDGET_SRC_TYPE_QUERY_SQL_ID){ 
					testSql('btnNext', 'afterNext');
				}else {
					document.getElementById("frmMain").action = "biDesigner.WidgetAction.do?action=kpiUpdate";
					submitForm(document.getElementById("frmMain"));
				}
			}
		}
	}
}

function btnBackNext_click() {
	document.getElementById("frmMain").action = "biDesigner.WidgetAction.do?action=backFirst";
	submitForm(document.getElementById("frmMain"));
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
			document.getElementById("frmMain").action = "biDesigner.WidgetAction.do?action=backToList" + windowId;
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "biDesigner.WidgetAction.do?action=backToList" + windowId;
		submitForm(document.getElementById("frmMain"));
	}
}

function verifyBasicObjects(){
	var srcType = document.getElementById("cmbSrcType").value;
	var widType = document.getElementById("cmbType").value;
	var chkActive = document.getElementById("chkWidActive").checked;
	//Verificamos si ingreso refresh time (solo si no esta seleccionada la opcion siempre activo)
	if (!chkActive && (document.getElementById("txtRef").value == null || document.getElementById("txtRef").value == "")){
		alert(MSG_REF_TIME_MISS);
		return false;
	}
	
	//Verificamos que el refresh time sea mayor que cero (solo si no esta seleccionada la opcion siempre activo)
	if (!chkActive && parseInt(document.getElementById("txtRef").value) <= 0){
		alert(MSG_WRNG_REF_TIME);
		return false;
	}
	//Verificamos si se selecciono periodicidad (solo si esta seleccionada la opcion siempre activo)
	if (chkActive && (document.getElementById("cmbRefPeriod").value == "" || document.getElementById("cmbRefPeriod").value == null)){
		alert(MSG_MUS_SEL_ONE_PERI);
		return false;
	}
	
	//Verificamos si ingreso un nodo ((solo si esta seleccionada la opcion siempre activo y la opcion nodo especifico)
	if (chkActive && document.getElementById("radSelected").value == 2 && document.getElementById("txtExeNode").value == ""){
	    alert(MSG_MUS_ENT_NODE_NAME);
		return false;
	}
	
	if (widType != WIDGET_TYPE_CUSTOM_ID){ //Si no se eligio el tipo Custom
		//1. Verificamos si se selecciono algun source
		if (document.getElementById("cmbSrc").value == null || document.getElementById("cmbSrc").value == "" || document.getElementById("cmbSrc").value == "0"){
			if (srcType == "1"){
				alert(MSG_MUS_SEL_ONE_CBE);
				return false;
			}else if (srcType=="2"){
				alert(MSG_MUS_SEL_ONE_BUS_CLA);
				return false;
			}else if (srcType=="3"){
				alert(MSG_MUS_SEL_ONE_QRY);
				return false;
			}
		}	
	}else{
		//2. Verificamos si ingreso algo en el codigo html
		
		if (document.getElementById("txtCustomSrc").value == null || document.getElementById("txtCustomSrc").value == ""){
			if (document.getElementById("chkCustUrl").checked){
				alert(MSG_MUST_ENT_URL);
			}else{
				alert(MSG_MUST_ENT_COD_HTML);
			}
			return false;
		}
	}	
	//Verificamos en el caso que el tipo de fuente sea clase de negocio, se haya seleccionado un parametro para el widget y
	// si tienen parametros de entrada o entrada/salida si se les ingresaron valores
		if (srcType == WIDGET_SRC_TYPE_BUS_CLASS_ID){//Si la fuente de datos es una clase de negocio
			var	http_request = getXMLHttpRequest();
			http_request.open('POST', "biDesigner.WidgetAction.do?action=checkWidgetBusClassParams"+windowId, false);
			http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
			if (document.getElementById("cmbSrc").value == "" || document.getElementById("cmbSrc").value == "0"){
				alert(MSG_MUST_SEL_BUS_CLA_WIDGET);
				return false;
			}
			var str = "busClaId=" + document.getElementById("cmbSrc").value + "&params=" + document.getElementById("txtHidParValues").value;
			http_request.send(str);
				    
			if (http_request.readyState == 4) {
				if (http_request.status == 200) {
					if (http_request.responseText == "-1") {
						alert(MSG_BUS_CLA_NOT_EXIST);
						return false;
					}else if (http_request.responseText == "-2") {
						if (confirm(MSG_PAR_BUS_CLA_NOT_VAL)) {
							return true;
						}else{
							return false;
						}
					}else if (http_request.responseText == "-3") {
						alert(MSG_NOT_PAR_VALUE_FOUND);
						return false;
					}else if(http_request.responseText == "NOK"){
						return alert(http_request.responseText);
						return false; 
					}
			   	} else {
			       	 alert("Could not contact the server.");    
			       	 return false;         
			       }
			}
 		}else if (srcType == WIDGET_SRC_TYPE_QUERY_ID){//Si la fuente de datos es una consulta de usuario
 			var	http_request = getXMLHttpRequest();
			http_request.open('POST', "biDesigner.WidgetAction.do?action=checkWidgetQryFilterValues"+windowId, false);
			http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
			if (document.getElementById("cmbSrc").value == "" || document.getElementById("cmbSrc").value == "0"){
				alert(MSG_MUST_SEL_QUERY_FIRST);
				return false;
			}
			var str = "qryId=" + document.getElementById("cmbSrc").value + "&params=" + document.getElementById("txtHidParValues").value + "&widQryCol=" + document.getElementById("txtHidWidQryColumn").value + "&widType=" + widType;
			http_request.send(str);
				    
			if (http_request.readyState == 4) {
				if (http_request.status == 200) {
					if (http_request.responseText == "-1") {
						alert(MSG_QUERY_NOT_EXIST);
						return false;
					}else if (http_request.responseText == "-2") {
						alert(MSG_FIL_QRY_NOT_VAL);
						return false;
					}else if (http_request.responseText == "-3") {
						alert(MSG_MST_SEL_QRY_COL);
						return false;
					}else if(http_request.responseText == "NOK"){
						return alert(http_request.responseText);
						return false; 
					}
			   	} else {
			       	 alert("Could not contact the server.");    
			       	 return false;        
			       }
			}
 		}else if (srcType == WIDGET_TYPE_CUBE_ID){ //Si la fuente de datos es una vista de un cubo
			//3.1  Verificamos se haya seleccionado una vista
			if(document.getElementById("cmbView").value == null || document.getElementById("cmbView").value == "" || document.getElementById("cmbView").value == "0"){
				alert(MSG_MUS_SEL_ONE_VW);
				return false;
			}
		}
	//Si se ingreso mas de un email, debe utilizarse el separador ';'
	var emails = document.getElementById("txtEmails").value;
	if (emails != "" && emails.indexOf("@")>0){
		emails = emails.substring(emails.indexOf("@")+1, emails.length);
		if (emails!="" && emails.indexOf("@")>0){
			if (emails.indexOf(";")<0){
				alert(MSG_EMAILS_ERROR);
				return false;
			}
		}
	}
		
	//Si se desea ver meta
	if (document.getElementById("chkSeeMeta").checked){
		if (!document.getElementById("chkMetaByYear").checked && !document.getElementById("chkMetaByMonth").checked && !document.getElementById("chkMetaByDay").checked){
			alert(MSG_MUST_SEL_META_BY);
			return false;
		}
	}
	
	return true;
}

function verifyKPIReqObjects(){

	//1.1 Verificamos se haya ingresado un valor mínimo para el kpi
	if (document.getElementById("txtKpiMin").value == ""){
		alert(MSG_MIS_KPI_MIN_VAL);
		return false;
	}		

	//1.2 Verificamos se haya ingresado un valor máximo para el kpi
	if (document.getElementById("txtKpiMax").value == ""){
		alert(MSG_MIS_KPI_MAX_VAL);
		return false;
	}				

	//1.3 Si se definieron zonas
	if (document.getElementById("gridZones").rows.length > 0){
		var minValue = document.getElementById("txtKpiMin").value;
		var maxValue = document.getElementById("txtKpiMax").value;
		var minZne = null;
		var maxZne = null;
		var existMinValue = false;
		var existMaxValue = false;
		var zneMin = null;
		var zneMax = null;
		var antZneMax = null;
		
		trows=document.getElementById("gridZones").rows;
		
		if (trows.length>0){
			//Verificamos que la primer zona empiece con el valor minimo del kpi
			zneMin = trows[0].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value;
			if (zneMin != minValue){
				alert(MSG_LST_ZNE_MIN_VAL_ERROR);
				return false;
			}
		}
		for (i=0;i<trows.length;i++) {
			zneName = trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
			zneMin = trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value;
			zneMax = trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
			
			//1- Verificamos que la zona tenga maximo
			if (zneMax == null || zneMax==""){
				alert(MSG_ALL_ZNE_MUS_HAV_MAX_VAL);
				return false;
			}
			
			//2- Verificamos correctitud de la zona (el minimo de la zona debe ser menor que el maximo de la zona)
			if (parseInt(zneMin) >= parseInt(zneMax)){
				alert(MSG_ZNE_MIN_MAX_VAL_ERROR.replace("<TOK1>",zneName));
				return false;
			}
			
			//3- Verificamos correctitud en la secuencia (el minimo de una zona debe ser el maximo de la zona anterior)
			if (antZneMax!=null && zneMin != antZneMax){
				alert(MSG_WRN_ZNE_SECUENCE);
				return false;
			}
			
			antZneMax = zneMax;
			
			if (minZne == null || zneMin < minZne){
				minZne = zneMin;					
			}
			if (maxZne == null || zneMax > maxZne){
				maxZne = zneMax;
			}
			if (zneMin == minValue){
				existMinValue = true;
			}
			if (zneMax == maxValue){
				existMaxValue =  true;
			}
		}
		//Verificamos haya una zona con el valor mínimo para el kpi
		if (!existMinValue){
			alert(MSG_ONE_ZNE_MUS_STA_MIN_VAL);
			return false;
		}
		//Verificamos haya una zona con el valor máximo para el kpi
		if (!existMaxValue){
			alert(MSG_ONE_ZNE_MUS_STA_MAX_VAL);
			return false;
		}
		//Verificamos que la ultima zona termine con el valor maximo del kpi
		var zRows = document.getElementById("gridZones").rows;
		zneMax = zRows[zRows.length-1].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
		if (zneMax != maxValue){
			alert(MSG_LST_ZNE_MAX_VAL_ERROR);
			return false;
		}
	}
	
	//1.3 Si se definieron acciones para las zonas
	if (document.getElementById("gridZonesActions").rows.length > 0){
		trows=document.getElementById("gridZonesActions").rows;
		
		for (i=0;i<trows.length;i++) {
			var action = trows[i].getElementsByTagName("TD")[2].getElementsByTagName("SELECT")[0].value;
			var busClaId = '';
			var busClaParams = '';
			if (action== WID_KPI_ACTION_SEND_EMAIL || action== WID_KPI_ACTION_SEND_NOTIFICATION || action== WID_KPI_ACTION_SEND_CHAT_MSG){
				busClaId = trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value;	
				busClaParams = trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[1].value;
			}else {
				busClaId = trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[1].value;
				busClaParams = trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[2].value;
			}
			
			if (busClaId == ''){
				if (action == '1'){
					alert(MSG_WID_SEL_BUS_CLA);
				}else if (action == '2'){
					alert(MSG_WID_SEL_PROCESS);
				}
				return false;
			}
			var paramsArr = busClaParams.split("#");
			if (action == WID_KPI_ACTION_SEND_EMAIL){ //Si se debe enviar un email
				if (paramsArr[2] == '' || paramsArr[2] == null){
					alert(MSG_WID_SEL_DESTINATARIOS);
					//Se debe seleccionar destinatarios
					return false;
				}
			}else if (action == WID_KPI_ACTION_SEND_NOTIFICATION || action == WID_KPI_ACTION_SEND_CHAT_MSG){ //Si se debe enviar una notificacion o msg caht
				if (paramsArr[1] == '' || paramsArr[1] == null){
					alert(MSG_WID_SEL_DESTINATARIOS);
					//Se debe seleccionar destinatarios
					return false;
				}
			}
		}
	}
	
	//Si el kpi es de tipo semaforo, verificamos se hayan ingresado 3 zonas
	if (document.getElementById("cmbKpiType").value == WIDGET_KPI_TYPE_TRAFFIC_LIGHT_ID){
		if (document.getElementById("gridZones").rows.length != 3){
			alert(MSG_MST_DEF_THREE_ZONES);
			return false;
		}
	}
	
	return true;
}

function cmbTypeNext_change(){
	//Vaciamos el combo de estilos
	while(document.getElementById("cmbStyle").options.length>0){
		document.getElementById("cmbStyle").removeChild(document.getElementById("cmbStyle").options[0]);
	}
	
	if (document.getElementById("cmbKpiType").value == WIDGET_KPI_TYPE_GAUGE_ID){ /// ---> Tipo de KPI Gauge
		var oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_GAUGE_STYLE_MODERN_ID;
		oOpt.innerHTML = WIDGET_KPI_GAUGE_STYLE_MODERN_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_GAUGE_STYLE_SEMICIRCLE_ID;
		oOpt.innerHTML = WIDGET_KPI_GAUGE_STYLE_SEMICIRCLE_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_GAUGE_STYLE_OXFORD_ID;
		oOpt.innerHTML = WIDGET_KPI_GAUGE_STYLE_OXFORD_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_GAUGE_STYLE_VELOCIMETER_BLUE_ID;
		oOpt.innerHTML = WIDGET_KPI_GAUGE_STYLE_VELOCIMETER_BLUE_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_GAUGE_STYLE_VELOCIMETER_RED_ID;
		oOpt.innerHTML = WIDGET_KPI_GAUGE_STYLE_VELOCIMETER_RED_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_GAUGE_STYLE_VELOCIMETER_GRAY_ID;
		oOpt.innerHTML = WIDGET_KPI_GAUGE_STYLE_VELOCIMETER_GRAY_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_GAUGE_STYLE_METER_RIGHT_BLUE_ID;
		oOpt.innerHTML = WIDGET_KPI_GAUGE_STYLE_METER_RIGHT_BLUE_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_GAUGE_STYLE_METER_RIGHT_RED_ID;
		oOpt.innerHTML = WIDGET_KPI_GAUGE_STYLE_METER_RIGHT_RED_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_GAUGE_STYLE_METER_RIGHT_GRAY_ID;
		oOpt.innerHTML = WIDGET_KPI_GAUGE_STYLE_METER_RIGHT_GRAY_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_GAUGE_STYLE_METER_LEFT_BLUE_ID;
		oOpt.innerHTML = WIDGET_KPI_GAUGE_STYLE_METER_LEFT_BLUE_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_GAUGE_STYLE_METER_LEFT_RED_ID;
		oOpt.innerHTML = WIDGET_KPI_GAUGE_STYLE_METER_LEFT_RED_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_GAUGE_STYLE_METER_LEFT_GRAY_ID;
		oOpt.innerHTML = WIDGET_KPI_GAUGE_STYLE_METER_LEFT_GRAY_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		document.getElementById("indSample").src = GAUGE_IMAGE_MODERN_SRC;
		
	}else if (document.getElementById("cmbKpiType").value == WIDGET_KPI_TYPE_TRAFFIC_LIGHT_ID){ /// ---> Tipo de KPI Semaforo
		var oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_TRAFFIC_LIGHT_STYLE_CLASSIC_ID;
		oOpt.innerHTML = WIDGET_KPI_TRAFFIC_LIGHT_STYLE_CLASSIC_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_TRAFFIC_LIGHT_STYLE_CLASSIC_GRAY_ID;
		oOpt.innerHTML = WIDGET_KPI_TRAFFIC_LIGHT_STYLE_CLASSIC_GRAY_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		document.getElementById("indSample").src = TRAFFIC_LIGHT_IMAGE_CLASSIC_SRC;
	}else{ // --> Tipo de KPI Counter
		var oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_COUNTER_STYLE_1_ID;
		oOpt.innerHTML = WIDGET_KPI_COUNTER_STYLE_1_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		oOpt = document.createElement("OPTION");
		oOpt.value = WIDGET_KPI_COUNTER_STYLE_2_ID;
		oOpt.innerHTML = WIDGET_KPI_COUNTER_STYLE_2_NAME;
		document.getElementById("cmbStyle").appendChild(oOpt);
		
		document.getElementById("indSample").src = COUNTER_IMAGE_1_SRC;
	}
}

function cmbStyle_change(){
	if (document.getElementById("cmbKpiType").value == WIDGET_KPI_TYPE_GAUGE_ID){/// ---> Tipo de KPI Gauge	
		if (document.getElementById("cmbStyle").value == WIDGET_KPI_GAUGE_STYLE_MODERN_ID){	
			document.getElementById("indSample").src = GAUGE_IMAGE_MODERN_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_GAUGE_STYLE_SEMICIRCLE_ID){	
			document.getElementById("indSample").src = GAUGE_IMAGE_SEMICIRCLE_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_GAUGE_STYLE_OXFORD_ID){	
			document.getElementById("indSample").src = GAUGE_IMAGE_OXFORD_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_GAUGE_STYLE_VELOCIMETER_BLUE_ID){	
			document.getElementById("indSample").src = GAUGE_IMAGE_VELOCIMETER_BLUE_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_GAUGE_STYLE_VELOCIMETER_RED_ID){	
			document.getElementById("indSample").src = GAUGE_IMAGE_VELOCIMETER_RED_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_GAUGE_STYLE_VELOCIMETER_GRAY_ID){	
			document.getElementById("indSample").src = GAUGE_IMAGE_VELOCIMETER_GRAY_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_GAUGE_STYLE_METER_RIGHT_BLUE_ID){	
			document.getElementById("indSample").src = GAUGE_IMAGE_METER_RIGHT_BLUE_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_GAUGE_STYLE_METER_RIGHT_RED_ID){	
			document.getElementById("indSample").src = GAUGE_IMAGE_METER_RIGHT_RED_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_GAUGE_STYLE_METER_RIGHT_GRAY_ID){	
			document.getElementById("indSample").src = GAUGE_IMAGE_METER_RIGHT_GRAY_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_GAUGE_STYLE_METER_LEFT_BLUE_ID){	
			document.getElementById("indSample").src = GAUGE_IMAGE_METER_LEFT_BLUE_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_GAUGE_STYLE_METER_LEFT_RED_ID){	
			document.getElementById("indSample").src = GAUGE_IMAGE_METER_LEFT_RED_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_GAUGE_STYLE_METER_LEFT_GRAY_ID){	
			document.getElementById("indSample").src = GAUGE_IMAGE_METER_LEFT_GRAY_SRC;
		}
	}else if (document.getElementById("cmbKpiType").value == WIDGET_KPI_TYPE_TRAFFIC_LIGHT_ID){ //--> Tipo semaforo
		if (document.getElementById("cmbStyle").value == WIDGET_KPI_TRAFFIC_LIGHT_STYLE_CLASSIC_ID){
			document.getElementById("indSample").src = TRAFFIC_LIGHT_IMAGE_CLASSIC_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_TRAFFIC_LIGHT_STYLE_CLASSIC_GRAY_ID){	
			document.getElementById("indSample").src = TRAFFIC_LIGHT_IMAGE_CLASSIC_GRAY_SRC;
		}
	}else{ //--> Tipo COUNTER
		if (document.getElementById("cmbStyle").value == WIDGET_KPI_COUNTER_STYLE_1_ID){
			document.getElementById("indSample").src = COUNTER_IMAGE_1_SRC;
		}else if (document.getElementById("cmbStyle").value == WIDGET_KPI_COUNTER_STYLE_2_ID){	
			document.getElementById("indSample").src = COUNTER_IMAGE_2_SRC;
		}
	}
}

function cmbRefPeriod_change(){
	var period = document.getElementById("cmbRefPeriod").value;
	if (period == SCH_PERIOD_DAY || period == SCH_PERIOD_WEEK || period == SCH_PERIOD_MONTH || period == SCH_PERIOD_YEAR){
		document.getElementById("txtHorIni").disabled= false; //Habilitamos ingreso de hora inicio
		document.getElementById("txtHorIni").value = "00:00";
		setRequiredField(document.getElementById("txtHorIni"));
	}else{
		document.getElementById("txtHorIni").disabled= true; //Deshabilitamos ingreso de hora inicio
		document.getElementById("txtHorIni").value = "__:__";
		unsetRequiredField(document.getElementById("txtHorIni"));
	}
}

function cmbType_change(){
	var widType = document.getElementById("cmbType").value;
		
	//Vaciamos el combo de origen
	while(document.getElementById("cmbSrcType").options.length>0){
		document.getElementById("cmbSrcType").removeChild(document.getElementById("cmbSrcType").options[0]);
	}
	
	var rowSrcType = document.getElementById("cmbSrcType").parentNode.parentNode;
	var tdLblSrcType = document.getElementById("cmbSrcType").parentNode.parentNode.cells[0];
	
	var rowSqlType = document.getElementById("txtSqlQuery").parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
	var rowDbCon = document.getElementById("dbConId").parentNode.parentNode;
	
	var rowSrc = document.getElementById("cmbSrc").parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
	var tdLblSrc = rowSrc.cells[0];
	
	var rowVw = document.getElementById("cmbView").parentNode.parentNode;
	var tdLblVw = document.getElementById("cmbView").parentNode.parentNode.cells[0];
	
	var rowChkbox = document.getElementById("chkCustUrl").parentNode.parentNode;
	var tdLblCodHtml = document.getElementById("txtCustomSrc").parentNode.parentNode.cells[0];
	var tdLblUrl = document.getElementById("chkCustUrl").parentNode.parentNode.cells[0];
	var rowTxtArea = document.getElementById("txtCustomSrc").parentNode.parentNode;
	var rowTestButtons = document.getElementById("btnDelHtml").parentNode.parentNode;
	
	if (document.getElementById("txtHidParValues")) document.getElementById("txtHidParValues").value = ""; //borramos los parametros ya que se modifico el tipo del widget

	var allCubes = ALL_CUBES_STR; //recuperamos string con todos los cubos
	var allQuerys = ALL_QRYS_STR; //recuperamos string con todas las consultas
	var allQuerysGraph = ALL_QRYS_GRAPH_STR; //recuperamos string con todas las consultas
	var allClasses = ALL_WID_CLASSES_STR; //recuperamos string con todos las clases de negocio
	
	if (document.getElementById("cmbType").value == WIDGET_TYPE_CUBE_ID){ /// ---> Tipo de Widget CUBO
		document.getElementById("chkWidActive").checked = false; //Desmarcamos checkbox de siempre activo
		document.getElementById("chkWidActive").disabled = true;//Deshabilitamos checkbox de siempre activo
		document.getElementById("cmbRefPeriod").selectedIndex = 0;//Seleccionamos la periodicadad nula
		document.getElementById("cmbRefPeriod").disabled = true;//Deshabilitamos combo de periodicidad
		document.getElementById("txtRef").disabled = false; //Habilitamos el input de tiempo de actualizacion
		document.getElementById("cmbRefType").disabled = false; //Habilitamos el combo de tipo de tiempo
		
		if (rowSrcType.style.display == "none"){
			//Mostramos la fila de fuente de datos(etiqueta y combo)
			rowSrcType.style.display="block";
			//Mostramos la fila de tipo de fuente de datos (etiqueta y combo)
			rowSrc.style.display="block"; 
		}
		
		//Mostramos la fila de tipo de vistas (etiqueta y combo)
		rowVw.style.display="block";
		
		//Ocultamos la fila del checkbox de custom
		rowChkbox.style.display="none";
		
		//Ocultamos la fila del textarea del custom
		rowTxtArea.style.display="none";
		
		//Ocultamos la fila con los botones de test
		rowTestButtons.style.display="none";
		
		rowSqlType.style.display="none";//Ocultamos la fila de consulta sql cmbSrcType_change
		rowDbCon.style.display="none";//Ocultamos la fila con el combo de conexiones
		
		//1- Mostramos etiqueta de fuentes de datos
		//tdLblSrcType.style.display="block";
		tdLblSrcType.innerHTML= LBL_SOURCE + ":";
		tdLblSrcType.title = LBL_SOURCE;
		
		//3- Creamos opciones de fuente de datos
		//3.1- Cubo
		var oOpt1 = document.createElement("OPTION");
		oOpt1.value = WIDGET_SRC_TYPE_CUBE_VIEW_ID;
		oOpt1.innerHTML = WIDGET_SRC_TYPE_CUBE_VIEW_NAME;
		document.getElementById("cmbSrcType").appendChild(oOpt1);
		
		//6- Mostramos y cambiamos la etiqueta del 2° combo de fuente de datos
		tdLblSrc.innerHTML=LBL_CUBE + ":";
		tdLblSrc.title = LBL_CUBE;
	
		//7- Vaciamos el 2° combo de fuente de datos
		
		while(document.getElementById("cmbSrc").options.length>0){
			document.getElementById("cmbSrc").options[0].parentNode.removeChild(document.getElementById("cmbSrc").options[0]);
		}
		
		//8- Agregamos una opcion nula al combo de cubos
		var oOptNull = document.createElement("OPTION");
		oOptNull.value = "";
		oOptNull.innerHTML = "";
		document.getElementById("cmbSrc").appendChild(oOptNull);
		
		//9- Agregamos todos los cubos
		
		while (allCubes.indexOf(",")>-1){
			var cbeId = allCubes.substring(0,allCubes.indexOf(","));
			allCubes = allCubes.substring(allCubes.indexOf(",")+1,allCubes.length);
			if (allCubes.indexOf(",")>-1){
				var cbeName = allCubes.substring(0,allCubes.indexOf(","));
				allCubes = allCubes.substring(allCubes.indexOf(",")+1,allCubes.length);
			}else{
				var cbeName = allCubes;
			}
			
			var oOpt = document.createElement("OPTION");
			oOpt.value = cbeId;
			oOpt.innerHTML = cbeName;
			document.getElementById("cmbSrc").appendChild(oOpt);
		}
		
		document.getElementById("cmbSrc").title = "";
		
		//10- Ocultamos imagenes de carga de parametros
		document.getElementById("imgBusClaParams").style.display="none";
		
		//Ocultamos imagen para seleccionar columna de consulta a utilizar por el widget
		document.getElementById("imgBusClaShowParams").style.display="none";
				
		// Vaciamos el combo de vistas
		while(document.getElementById("cmbView").options.length>0){
			document.getElementById("cmbView").options[0].parentNode.removeChild(document.getElementById("cmbView").options[0]);
		}
				
		//11- Mostramos el combo de vistas 
		tdLblVw.innerHTML = LBL_CUBE_VIEW + ":";
		tdLblVw.title = LBL_CUBE_VIEW;
		
		//13- Seteamos label y accion del botón Confirmar/Siguiente
		document.getElementById("btnConf").title = LBL_BTN_CONF_TITLE;
		document.getElementById("btnConf").accesskey = LBL_BTN_CONF_ACC_KEY;
		document.getElementById("btnConf").innerHTML = LBL_BTN_CONF_NAME;
		document.getElementById("btnConf").onclick = btnConf_click;
			
		//Mostramos imagen de un cubo
		//document.getElementById("indSample").src = CUBE_IMAGE_SRC;
		
		document.getElementById("chkSeeMeta").disabled = true;
		disableMetaParams();
		
	}else if (document.getElementById("cmbType").value == WIDGET_TYPE_QUERY_ID){  /// ---> Tipo de Widget CONSULTA
		document.getElementById("chkWidActive").checked = false; //Desmarcamos checkbos de siempre activo
		document.getElementById("chkWidActive").disabled = true;//Deshabilitamos checkbox de siempre activo
		document.getElementById("cmbRefPeriod").selectedIndex = 0;//Seleccionamos la periodicadad nula
		document.getElementById("cmbRefPeriod").disabled = true;//Deshabilitamos combo de periodicidad
		document.getElementById("txtRef").disabled = false; //Habilitamos el input de tiempo de actualizacion
		document.getElementById("cmbRefType").disabled = false; //Habilitamos el combo de tipo de tiempo

		//Mostramos la fila de fuente de datos(etiqueta y combo)
		rowSrcType.style.display="block";
		
		//Mostramos la fila de tipo de fuente de datos (etiqueta y combo)
		rowSrc.style.display="block"; 

		//Ocultamos la fila de tipo de vistas (etiqueta y combo)
		rowVw.style.display="none";
		
		//Ocultamos la fila del checkbox de custom
		rowChkbox.style.display="none";
		
		//Ocultamos la fila del textarea del custom
		rowTxtArea.style.display="none";
		
		rowSqlType.style.display="none";//Ocultamos la fila de consulta sql cmbSrcType_change
		rowDbCon.style.display="none";//Ocultamos la fila con el combo de conexiones
		
		//Ocultamos la fila con los botones de test
		rowTestButtons.style.display="none";

		//1- Mostramos etiqueta de fuentes de datos
		//tdLblSrcType.style.display="block";
		tdLblSrcType.innerHTML= LBL_SOURCE + ":";
		tdLblSrcType.title = LBL_SOURCE;
		
		//3- Creamos opciones de fuente de datos
		//3.1- Consulta de usuario
		var oOpt1 = document.createElement("OPTION");
		oOpt1.value = WIDGET_SRC_TYPE_QUERY_ID;
		oOpt1.innerHTML = WIDGET_SRC_TYPE_QUERY_NAME;
		document.getElementById("cmbSrcType").appendChild(oOpt1);
		
		//6- Mostramos y cambiamos la etiqueta del 2° combo de fuente de datos
		tdLblSrc.innerHTML=LBL_QUERY + ":";
		tdLblSrc.title = LBL_QUERY;
		
		
		//7- Vaciamos el 2° combo de fuente de datos
		while(document.getElementById("cmbSrc").options.length>0){
			document.getElementById("cmbSrc").options[0].parentNode.removeChild(document.getElementById("cmbSrc").options[0]);
		}
		
		//8- Agregamos una opcion nula al combo de CONSULTAS
		var oOptNull = document.createElement("OPTION");
		oOptNull.value = "";
		oOptNull.innerHTML = "";
		document.getElementById("cmbSrc").appendChild(oOptNull);
		
		//9- Agregamos todas las consultas de usuario
		while (allQuerysGraph.indexOf(",")>-1){
			var qryId = allQuerysGraph.substring(0,allQuerysGraph.indexOf(","));
			allQuerysGraph = allQuerysGraph.substring(allQuerysGraph.indexOf(",")+1,allQuerysGraph.length);
			if (allQuerysGraph.indexOf(",")>-1){
				var qryName = allQuerysGraph.substring(0,allQuerysGraph.indexOf(","));
				allQuerysGraph = allQuerysGraph.substring(allQuerysGraph.indexOf(",")+1,allQuerysGraph.length);
			}else{
				var qryName = allQuerysGraph;
			}
			
			var oOpt = document.createElement("OPTION");
			oOpt.value = qryId;
			oOpt.innerHTML = qryName;
			document.getElementById("cmbSrc").appendChild(oOpt);
		}
		document.getElementById("cmbSrc").title = LBL_USR_QRYS_WITH_GRAPHS;
		
		//10- Mostramos imagenes de carga de parametros
		document.getElementById("imgBusClaParams").style.display="block";
		document.getElementById("imgBusClaParams").title=LBL_SEL_QUERY_FILTERS;
		
		//Ocultamos imagen para seleccionar columna de consulta a utilizar por el widget
		document.getElementById("imgBusClaShowParams").style.display="none";
		
		//13- Seteamos label y accion del botón Confirmar/Siguiente
		document.getElementById("btnConf").title = LBL_BTN_CONF_TITLE;
		document.getElementById("btnConf").accesskey = LBL_BTN_CONF_ACC_KEY;
		document.getElementById("btnConf").innerHTML = LBL_BTN_CONF_NAME;
		document.getElementById("btnConf").onclick = btnConf_click;
		
		//Mostramos imagen de una query
		//document.getElementById("indSample").src = QUERY_IMAGE_SRC;
		
		document.getElementById("chkSeeMeta").disabled = true;
		disableMetaParams();
		
	}else if (document.getElementById("cmbType").value == WIDGET_TYPE_KPI_ID){  /// ---> Tipo de Widget KPI
	
		document.getElementById("chkWidActive").disabled = false;//Habilitamos checkbox de siempre activo
		document.getElementById("cmbRefPeriod").selectedIndex = 0;//Seleccionamos la periodicadad nula
		//document.getElementById("cmbRefPeriod").disabled = false;//Habilitamos combo de periodicidad
		//document.getElementById("txtRef").disabled = false; //Habilitamos el input de tiempo de actualizacion
		//document.getElementById("cmbRefType").disabled = false; //Habilitamos el combo de tipo de tiempo
	
		//- Mostramos imagen de un gauge por defecto
		//document.getElementById("indSample").src = GAUGE_IMAGE_SRC;
		
		//Mostramos la fila de fuente de datos(etiqueta y combo)
		rowSrcType.style.display="block";
		
		//Mostramos la fila de tipo de fuente de datos (etiqueta y combo)
		rowSrc.style.display="block"; 

		//Ocultamos la fila de tipo de vistas (etiqueta y combo)
		rowVw.style.display="none";
		
		//Ocultamos la fila del checkbox de custom
		rowChkbox.style.display="none";
		
		//Ocultamos la fila del textarea del custom
		rowTxtArea.style.display="none";
		
		rowSqlType.style.display="none";//Ocultamos la fila de consulta sql cmbSrcType_change
		rowDbCon.style.display="none";//Ocultamos la fila con el combo de conexiones
		
		//Ocultamos la fila con los botones de test
		rowTestButtons.style.display="none";
		
		//1- Mostramos etiqueta de fuentes de datos
		//tdLblSrcType.style.display="block";
		tdLblSrcType.innerHTML= LBL_SOURCE + ":";
		tdLblSrcType.title = LBL_SOURCE;
		
		//1- Creamos opciones de fuente de datos
		//1.1- Clase de negocio
		//document.getElementById("cmbSrcType").style.visibility="visible";
		var oOpt2 = document.createElement("OPTION");
		oOpt2.value = WIDGET_SRC_TYPE_BUS_CLASS_ID;
		oOpt2.innerHTML = WIDGET_SRC_TYPE_BUS_CLASS_NAME;
		document.getElementById("cmbSrcType").appendChild(oOpt2);
		//1.2- Cubo
		var oOpt1 = document.createElement("OPTION");
		oOpt1.value = WIDGET_SRC_TYPE_CUBE_VIEW_ID;
		oOpt1.innerHTML = WIDGET_SRC_TYPE_CUBE_VIEW_NAME;
		document.getElementById("cmbSrcType").appendChild(oOpt1);
		//1.3- Consulta de usuario
		var oOpt3 = document.createElement("OPTION");
		oOpt3.value = WIDGET_SRC_TYPE_QUERY_ID;
		oOpt3.innerHTML = WIDGET_SRC_TYPE_QUERY_NAME;
		document.getElementById("cmbSrcType").appendChild(oOpt3);
		//1.4- Consulta SQL
		var oOpt4 = document.createElement("OPTION");
		oOpt4.value = WIDGET_SRC_TYPE_QUERY_SQL_ID;
		oOpt4.innerHTML = WIDGET_SRC_TYPE_QUERY_SQL_NAME;
		document.getElementById("cmbSrcType").appendChild(oOpt4);

		//3- Mostramos y cambiamos la etiqueta del 2° combo de fuente de datos
		tdLblSrc.innerHTML=LBL_BUS_CLASS + ":";
		tdLblSrc.title = LBL_BUS_CLASS;
		
		//- Vaciamos el 2° combo de fuente de datos
		while(document.getElementById("cmbSrc").options.length>0){
			document.getElementById("cmbSrc").options[0].parentNode.removeChild(document.getElementById("cmbSrc").options[0]);
		}
		
		//- Agregamos una opcion nula al combo de clases de negocio
		var oOptNull = document.createElement("OPTION");
		oOptNull.value = "";
		oOptNull.innerHTML = "";
		document.getElementById("cmbSrc").appendChild(oOptNull);
		
		//Agregamos todas las clases de negocio
		while (allClasses.indexOf(",")>-1){
			var busClaId = allClasses.substring(0,allClasses.indexOf(","));
			allClasses = allClasses.substring(allClasses.indexOf(",")+1,allClasses.length);
			if (allClasses.indexOf(",")>-1){
				var busClaName = allClasses.substring(0,allClasses.indexOf(","));
				allClasses = allClasses.substring(allClasses.indexOf(",")+1,allClasses.length);
			}else{
				var busClaName = allClasses;
			}
			
			var oOpt = document.createElement("OPTION");
			oOpt.value = busClaId;
			oOpt.innerHTML = busClaName;
			document.getElementById("cmbSrc").appendChild(oOpt);
		}
		
		document.getElementById("cmbSrc").title = "";
		
		//4- Mostramos imagenes de carga de parametros
		document.getElementById("imgBusClaParams").style.display="block";
		document.getElementById("imgBusClaParams").style.visibility="visible";
		document.getElementById("imgBusClaParams").title=LBL_SEL_BUS_CLASS_PARAMS;
		
		//Ocultamos imagen para seleccionar columna de consulta a utilizar por el widget
		document.getElementById("imgBusClaShowParams").style.display="none";
		
		// Vaciamos el combo de vistas
		while(document.getElementById("cmbView").options.length>0){
			document.getElementById("cmbView").options[0].parentNode.removeChild(document.getElementById("cmbView").options[0]);
		}
		
		//9- Seteamos label y accion del botón Confirmar/Siguiente
		document.getElementById("btnConf").title = LBL_BTN_SIG_TITLE;
		document.getElementById("btnConf").accesskey = LBL_BTN_SIG_ACC_KEY;
		document.getElementById("btnConf").innerHTML = LBL_BTN_SIG_NAME;
		//document.getElementById("btnConf").onclick = btnNext_click();
		
		document.getElementById("chkSeeMeta").disabled = false;
		
	}else if (document.getElementById("cmbType").value == WIDGET_TYPE_CUSTOM_ID){   /// ---> Tipo de Widget CUSTOM
		document.getElementById("chkWidActive").checked = false; //Desmarcamos checkbox de siempre activo
		document.getElementById("chkWidActive").disabled = true;//Deshabilitamos checkbox de siempre activo
		document.getElementById("cmbRefPeriod").selectedIndex = 0;//Seleccionamos la periodicadad nula
		document.getElementById("cmbRefPeriod").disabled = true;//Deshabilitamos combo de periodicidad
		document.getElementById("txtRef").disabled = false; //Habilitamos el input de tiempo de actualizacion
		document.getElementById("cmbRefType").disabled = false; //Habilitamos el combo de tipo de tiempo
		
		if (document.getElementById("chkWidActive").value != "on"){
			document.getElementById("cmbRefPeriod").selectedIndex = 0;//Seleccionamos la periodicadad nula
		}				
		//Ocultamos la fila de fuente de datos(etiqueta y combo)
		rowSrcType.style.display="none";
		
		//Ocultamos la fila de tipo de fuente de datos (etiqueta y combo)
		rowSrc.style.display="none"; 

		//Ocultamos la fila de tipo de vistas (etiqueta y combo)
		rowVw.style.display="none";
		
		//Mostramos la fila del checkbox de custom
		rowChkbox.style.display="block";
		
		//Mostramos la fila del textarea del custom
		rowTxtArea.style.display="block";
		
		rowSqlType.style.display="none";//Ocultamos la fila de consulta sql cmbSrcType_change
		rowDbCon.style.display="none";//Ocultamos la fila con el combo de conexiones
		
		//Mostramos la fila con los botones de test
		rowTestButtons.style.display="block";
		
		//2- Mostramos etiqueta de Cod. Html
		tdLblCodHtml.innerHTML = LBL_COD_HTML + ":";
		tdLblUrl.innerHTML = LBL_URL + ":";
						
		//7- Mostramos textArea con ejemplo
		document.getElementById("txtCustomSrc").value = HTML_COD_EXAMPLE + "</script>";
		
		//8- Mostramos boton delHTML y testHTML
		document.getElementById("btnDelHtml").style.visibility="visible";
		document.getElementById("btnTestHtml").style.visibility="visible";
				
		//9- Seteamos label y accion del botón Confirmar/Siguiente
		document.getElementById("btnConf").title = LBL_BTN_CONF_TITLE;
		document.getElementById("btnConf").accesskey = LBL_BTN_CONF_ACC_KEY;
		document.getElementById("btnConf").innerHTML = LBL_BTN_CONF_NAME;
		document.getElementById("btnConf").onclick = btnConf_click;
		
		document.getElementById("chkSeeMeta").disabled = true;
		disableMetaParams();
	}
}

function cmbSrcType_change(el){
	
	var rowSrcType = document.getElementById("cmbSrcType").parentNode.parentNode;
	var tdLblSrcType = document.getElementById("cmbSrcType").parentNode.parentNode.cells[0];
	
	var rowSrc = document.getElementById("cmbSrc").parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
	var tdLblSrc = rowSrc.cells[0];
	
	var rowVw = document.getElementById("cmbView").parentNode.parentNode;
	var tdLblVw = document.getElementById("cmbView").parentNode.parentNode.cells[0];
	
	//var rowSqlType = document.getElementById("imgSQLOpenEditor").parentNode.parentNode.parentNode;
	var rowSqlType = document.getElementById("txtSqlQuery").parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
	
	var rowDbCon = document.getElementById("dbConId").parentNode.parentNode;
	
	document.getElementById("txtHidParValues").value = ""; //borramos los parametros ya que se modifico el tipo del widget
	
	//borramos todo lo que habia antes en el combo (clase de negocio/consulta de usuario/cubo)
	while(document.getElementById("cmbSrc").options.length>0){
		document.getElementById("cmbSrc").removeChild(document.getElementById("cmbSrc").options[0]);
	}
	
	if (document.getElementById("cmbSrcType").value == WIDGET_SRC_TYPE_CUBE_VIEW_ID){//Si la fuente de datos es una vista
		var allCubes = ALL_CUBES_STR; //recuperamos string con todos los cubos

		//Agregamos una opcion nula al combo de cubos
		var oOptNull = document.createElement("OPTION");
		oOptNull.value = "";
		oOptNull.innerHTML = "";
		document.getElementById("cmbSrc").appendChild(oOptNull);
		
		//Cambiamos la etiqueta del combo
		tdLblSrc.innerHTML=LBL_CUBE + ":";
		tdLblSrc.title = LBL_CUBE;
		
		//Agregamos todos los cubos
		while (allCubes.indexOf(",")>-1){
			var cbeId = allCubes.substring(0,allCubes.indexOf(","));
			allCubes = allCubes.substring(allCubes.indexOf(",")+1,allCubes.length);
			if (allCubes.indexOf(",")>-1){
				var cbeName = allCubes.substring(0,allCubes.indexOf(","));
				allCubes = allCubes.substring(allCubes.indexOf(",")+1,allCubes.length);
			}else{
				var cbeName = allCubes;
			}
			
			var oOpt = document.createElement("OPTION");
			oOpt.value = cbeId;
			oOpt.innerHTML = cbeName;
			document.getElementById("cmbSrc").appendChild(oOpt);
		}
		document.getElementById("cmbSrc").title = "";
		
		// Vaciamos el combo de vistas
		while(document.getElementById("cmbView").options.length>0){
			document.getElementById("cmbView").options[0].parentNode.removeChild(document.getElementById("cmbView").options[0]);
		}
		
		rowSrc.style.display="block";//Mostramos la fila de Cubo/Consultas del usuario
		rowVw.style.display="block";//Mostramos la fila de tipo de vistas (etiqueta y combo)
		
		rowSqlType.style.display="none";//Ocultamos la fila de consulta sql
		rowDbCon.style.display="none";//Ocultamos la fila con el combo de conexion
		
		//Mostramos el combo de vistas
		//document.getElementById("cmbView").style.display="block";
		//tdLblVw.style.display="block";
		tdLblVw.innerHTML=LBL_CUBE_VIEW + ":";//Agregamos la etiqueta de Vista de un cubo
		tdLblVw.title = LBL_CUBE_VIEW;
		
		//Ocultamos imagen para ingresar parametros
		document.getElementById("imgBusClaParams").style.display="none";
		//Ocultamos imagen para seleccionar columna de consulta a utilizar por el widget
		document.getElementById("imgBusClaShowParams").style.display="none";
		
	}else if (document.getElementById("cmbSrcType").value == WIDGET_SRC_TYPE_BUS_CLASS_ID){//Si la fuente de datos es una clase de negocio
		var allClasses = ALL_WID_CLASSES_STR; //recuperamos string con todos las clases de negocio
		
		//Agregamos una opcion nula al combo de clases de negocio
		var oOptNull = document.createElement("OPTION");
		oOptNull.value = "";
		oOptNull.innerHTML = "";
		document.getElementById("cmbSrc").appendChild(oOptNull);
		
		//Cambiamos la etiqueta del combo
		tdLblSrc.innerHTML=LBL_BUS_CLASS + ":";
		tdLblSrc.title = LBL_BUS_CLASS;
		
		//Agregamos todas las clases de negocio
		while (allClasses.indexOf(",")>-1){
			var busClaId = allClasses.substring(0,allClasses.indexOf(","));
			allClasses = allClasses.substring(allClasses.indexOf(",")+1,allClasses.length);
			if (allClasses.indexOf(",")>-1){
				var busClaName = allClasses.substring(0,allClasses.indexOf(","));
				allClasses = allClasses.substring(allClasses.indexOf(",")+1,allClasses.length);
			}else{
				var busClaName = allClasses;
			}
			
			var oOpt = document.createElement("OPTION");
			oOpt.value = busClaId;
			oOpt.innerHTML = busClaName;
			document.getElementById("cmbSrc").appendChild(oOpt);
		}
		document.getElementById("cmbSrc").title = "";;
		
		//Vaciamos el combo de vistas
		while(document.getElementById("cmbView").options.length>0){
			document.getElementById("cmbView").options[0].parentNode.removeChild(document.getElementById("cmbView").options[0]);
		}
		
		rowSrc.style.display="block";//Mostramos la fila de Cubo/Consultas del usuario
		//Ocultamos la fila de tipo de vistas (etiqueta y combo)
		rowVw.style.display="none";
		//document.getElementById("cmbView").style.display="none";
		//tdLblVw.style.display="none";
		
		rowSqlType.style.display="none";//Ocultamos la fila de consulta sql
		rowDbCon.style.display="none";//Ocultamos la fila con el combo de conexion
		
		//Mostramos imagen para ingresar parametros
		document.getElementById("imgBusClaParams").style.display="block";
		document.getElementById("imgBusClaParams").title=LBL_SEL_BUS_CLASS_PARAMS;
		//Ocultamos imagen para seleccionar columna de consulta a utilizar por el widget
		document.getElementById("imgBusClaShowParams").style.display="none";
		
	}else if (document.getElementById("cmbSrcType").value == WIDGET_SRC_TYPE_QUERY_ID){//Si la fuente de datos es una consulta de usuario
		var allQuerys = "";
		var qryCmbTitle = "";
		if (document.getElementById("cmbType").value == WIDGET_TYPE_KPI_ID){  /// ---> Tipo de Widget KPI
			allQuerys = ALL_QRYS_STR; //recuperamos string con todas las consultas con graficos
			qryCmbTitle = LBL_USR_QRYS;
		}else{
			allQuerys = ALL_QRYS_GRAPH_STR; //recuperamos string con todos las consultas		
			qryCmbTitle = LBL_USR_QRYS_WITH_GRAPHS;
		}
		//Agregamos una opcion nula al combo de consultas de usuario
		var oOptNull = document.createElement("OPTION");
		oOptNull.value = "";
		oOptNull.innerHTML = "";
		document.getElementById("cmbSrc").appendChild(oOptNull);
		
		//Cambiamos la etiqueta del combo
		tdLblSrc.innerHTML=LBL_QUERY + ":";//Cambiamos la etiqueta del combo
		tdLblSrc.title = LBL_QUERY;
		
		//Agregamos todas las consultas de usuario
		while (allQuerys.indexOf(",")>-1){
			var qryId = allQuerys.substring(0,allQuerys.indexOf(","));
			allQuerys = allQuerys.substring(allQuerys.indexOf(",")+1,allQuerys.length);
			if (allQuerys.indexOf(",")>-1){
				var qryName = allQuerys.substring(0,allQuerys.indexOf(","));
				allQuerys = allQuerys.substring(allQuerys.indexOf(",")+1,allQuerys.length);
			}else{
				var qryName = allQuerys;
			}
			
			var oOpt = document.createElement("OPTION");
			oOpt.value = qryId;
			oOpt.innerHTML = qryName;
			document.getElementById("cmbSrc").appendChild(oOpt);
		}
		document.getElementById("cmbSrc").title = qryCmbTitle;
		
		//Vaciamos el combo de vistas
		while(document.getElementById("cmbView").options.length>0){
			document.getElementById("cmbView").options[0].parentNode.removeChild(document.getElementById("cmbView").options[0]);
		}
		
		rowSrc.style.display="block";//Mostramos la fila de Cubo/Consultas del usuario
		//Ocultamos la fila de tipo de vistas (etiqueta y combo)
		rowVw.style.display="none";
		//document.getElementById("cmbView").style.display="none"; 
		//tdLblVw.style.display="none";
		
		rowSqlType.style.display="none";//Ocultamos la fila de consulta sql
		rowDbCon.style.display="none";//Ocultamos la fila con el combo de conexion

		//Mostramos imagen para ingresar parametros
		document.getElementById("imgBusClaParams").style.display="block";
		document.getElementById("imgBusClaParams").title=LBL_SEL_QUERY_FILTERS;
		//Mostramos imagen para seleccionar columna de consulta a utilizar por el widget
		document.getElementById("imgBusClaShowParams").style.display="block";
		
	} else {//Si la fuente de datos es una consulta SQL
		
		rowDbCon.style.display="block";//Mostramos la fila con el combo de conexion
		rowSqlType.style.display="block";//Mostramos la fila con el textarea para ingresar la consulta

		rowSrc.style.display="none";//Ocultamos la fila de fuente (Cubo / Consultas del usuario)
		rowVw.style.display="none";//Ocultamos la fila de tipo de vistas
	
	}
}

//Funcion para usar con Ajax
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

function cmbSrc_change(){

	if (document.getElementById("cmbSrcType").value == WIDGET_SRC_TYPE_BUS_CLASS_ID){
		if (document.getElementById("txtHidParVaules")){
			document.getElementById("txtHidParValues").value = ""; //Borramos los parametros ya que se cambio de clase de negocio
		}
	}else if (document.getElementById("cmbSrcType").value == WIDGET_SRC_TYPE_CUBE_VIEW_ID){
		document.getElementById("cmbSrc").title = document.getElementById("cmbSrc").options[document.getElementById("cmbSrc").selectedIndex].innerText;
		
		//Borramos todas las vistas que habian antes
		while(document.getElementById("cmbView").options.length>0){
			document.getElementById("cmbView").options[0].parentNode.removeChild(document.getElementById("cmbView").options[0]);
		}
	
		var cbeId = document.getElementById("cmbSrc").value; //Recuperamos el id del cubo seleccionado
		var	http_request = getXMLHttpRequest();
		http_request.open('POST', "biDesigner.WidgetAction.do?action=getCbeViews"+windowId, false);
		http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
		
		var str = "cbeId=" + cbeId;
		http_request.send(str);
		    
		if (http_request.readyState == 4) {
	   	   if (http_request.status == 200) {
	           if(http_request.responseText != "NOK"){
	              var views = http_request.responseText; //El formato de la respuesta es: 'msr1,msr2,msr3'
	              if (views == "NOK"){return;}
	              var i=0;
				  while (views.indexOf("$")>-1){
						var vwId = views.substring(0,views.indexOf("$"));
						views = views.substring(views.indexOf("$")+1,views.length);
						if (views.indexOf("$")>-1){
							var vwName = views.substring(0,views.indexOf("$"));
							views = views.substring(views.indexOf("$")+1,views.length);
						}else{
							var vwName = views;
						}
						var oOpt = document.createElement("OPTION");
						oOpt.value = vwId;
						oOpt.innerHTML = vwName;
						document.getElementById("cmbView").appendChild(oOpt);
				  }
				}
			} else {
	              return "NOK";
	           }
		}else{
	          return "Could not contact the server.";  
		}
	}
}

function getNextZneMin(){
 var zneMin = document.getElementById("txtKpiMin").value;
 if (document.getElementById("gridZones").rows.length > 0){
	trows=document.getElementById("gridZones").rows;
	for (i=0;i<trows.length;i++) {
		var zneMax = trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
		if (parseInt(zneMax) > parseInt(zneMin)) {
			zneMin = zneMax;
		}
	}
 }
 return zneMin;
}

//verifica si se puede agregar una zona (si a alguna le falta setear el max no se puede)
function incompleteZones(){
	if (document.getElementById("gridZones").rows.length > 0){
		trows=document.getElementById("gridZones").rows;
		for (i=0;i<trows.length;i++) {
			var zneMax = trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
			if (zneMax=="") {
				return true;
			}
		}
	 }
	 return false;
}

//verifica si alguna zona ya llego al maximo valor posible para el kpi
function maxReached(){
	var kpiMax = document.getElementById("txtKpiMax").value;
	if (document.getElementById("gridZones").rows.length > 0){
		trows=document.getElementById("gridZones").rows;
		for (i=0;i<trows.length;i++) {
			var zneMax= trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
			if (parseInt(zneMax) >= parseInt(kpiMax)) {
				return true;
			}
		}
	 }
	 return false;
}

//llamado al insertar en el input de maximo de zona
function zneMaxBeenChange(obj){
	var tr = getParentRow(obj);
	var value = obj.value;
	var nextTr = tr.parentNode.rows(tr.rowIndex);
	if (nextTr != null){ //si no es la ultima fila
		//Actualizamos el minimo de la siguiente fila
		nextTr.getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value = value;
		nextTr.getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[1].value = value;
	}
}

//llamado al borrar en el input de maximo de zona
function zneMaxBeenChange2(obj){
	var tr = getParentRow(obj);
	var value = obj.value;
	var nextTr = tr.parentNode.rows(tr.rowIndex);
	if (nextTr != null){ //si no es la ultima fila
		//Actualizamos el minimo de la siguiente fila
		nextTr.getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value = value;
		nextTr.getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[1].value = value;
	}
}

//llamado al insertar en el input de minimo de zona
function zneMinBeenChange(obj){
	var tr = getParentRow(obj);
	var value = obj.value;
	
	//Actualizamos el input oculto con el valor minimo
	tr.getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[1].value = value;

	if (tr.rowIndex>1){ //Si no es la primer zona
		var prevTr = tr.parentNode.rows(tr.rowIndex-2);
		if (prevTr != null){ 
			//Actualizamos el maximo de la anterior fila
			prevTr.getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value = value;
		}
	}
}

//llamado al borrar en el input de minimo de zona
function zneMinBeenChange2(obj){
	var tr = getParentRow(obj);
	var value = obj.value;
	//Actualizamos el input oculto con el valor minimo
	tr.getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[1].value = value;

	if (tr.rowIndex>1){ //Si no es la primer zona
		var prevTr = tr.parentNode.rows(tr.rowIndex-2);
		if (prevTr != null){
			//Actualizamos el maximo de la anterior fila
			prevTr.getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value = value;
		}
	}
}

function btnAddZone_click(){
	if (incompleteZones()){
		alert(MSG_MUST_COMP_MAX_ZNES);
	}else if (maxReached()){
		alert(MSG_CANT_ADD_NEW_ZNE);
	}else{
		var oTd0 = document.createElement("TD"); 
		var oTd1 = document.createElement("TD");
		var oTd2 = document.createElement("TD");
		var oTd3 = document.createElement("TD");
		var oTd4 = document.createElement("TD");
		var oTd5 = document.createElement("TD");
			
		var zneName = "ZONE" + (document.getElementById("gridZones").rows.length + 1);
		var zneMin = getNextZneMin();
	
		oTd0.innerHTML = "<input type='checkbox' name='chkIndZoneSel'>";
		
		//Nombre de la zona
		oTd1.innerHTML = "<input type='text' name='zneName' maxlength='50' style='width:100px' onchange='chkZneName(this);fncZoneChanged()' value='" + zneName +"'></input><input type='hidden' name='hidZneName' value='" + zneName +"'></input>"; //--> Agregamos el nombre de la zona	y oculto para que si lo modifica por un nombre invalido poder volver a poner el que estaba antes
		//Desc de la zona
		oTd2.innerHTML = "<input type='text' name='zneDesc' maxlength='255' style='width:150px'></input>"; //--> Agregamos el input de descripcion de la zona
		//Min de la zona
		oTd3.innerHTML = "<input type='text' p_numeric='true' style='width:30px' name='zneMin' value='" + zneMin + "' onKeyPress='zneMinBeenChange(this)' onkeyup='zneMinBeenChange2(this)'></input><input type='hidden' name='zneHiddenMin' value='"+zneMin+"'>"; //--> Agregamos el input de mínimo de la zona
		//Max de la zona
		oTd4.innerHTML = "<input type='text' p_numeric='true' style='width:30px' name='zneMax' onKeyPress='zneMaxBeenChange(this)' onkeyup='zneMaxBeenChange2(this)'></input>"; //--> Agregamos el input de máximo de la zona
		//Color de la zona
		var oInputColor = "<input type='input' name='txtColor' style='width:60px' class='txtReadonly' readonly value=''>";
		oInputColor = oInputColor + "<a href='#' onclick='colorPicker(this)'><img width='15' height='13' border='0' src='"+ rootPath + "/styles/" + GNR_CURR_STYLE + "/images/palette.gif'></a>";
		oInputColor = oInputColor + "<input type='text' size='2' readonly style='width:60px;background-color:''; border:0px'>";
		oTd5.innerHTML = oInputColor;
			
		var oSelectColor = "";
		
		var oTr = document.createElement("TR");
		
		oTr.appendChild(oTd0);
		oTr.appendChild(oTd1);
		oTr.appendChild(oTd2);
		oTr.appendChild(oTd3);
		oTr.appendChild(oTd4);
		oTr.appendChild(oTd5);		
		
		document.getElementById("gridZones").addRow(oTr);
	}
}

function btnAddActionZone_click(){
	if (document.getElementById("gridZones").rows.length == 0){ //Si no se definieron zonas
		alert("No se definió ningúna zona");
		return;
	}
	var oTd0 = document.createElement("TD"); //chekbox
	var oTd1 = document.createElement("TD"); //zone
	var oTd2 = document.createElement("TD"); //action
	var oTd3 = document.createElement("TD"); //execute
	var oTd4 = document.createElement("TD"); //execute after N times
		
	oTd0.innerHTML = "<input type='checkbox' name='chkIndZoneActSel'>";
	
	//-------> Zona
	var oSelZne = "<select name='selZone' onChange='cmbZneAct_change(this);fncZoneChanged()'>";
	trows=document.getElementById("gridZones").rows;
	var firstZne =  trows[0].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
	for (i=0;i<trows.length;i++) {
		zneName = trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
		oSelZne = oSelZne + "<option value='" + i + "'>" + zneName +"</option>";		
	}
	oSelZne = oSelZne + "</select>";
	oSelZne = oSelZne + "<input name='hidZne' type='hidden' size='40' value='" + firstZne + "'/>";
	oTd1.innerHTML = oSelZne;
	
	//-------> Acción de la zona
	var oSelAct = "<select name='selAction' onChange='cmbActZne_change(this); fncZoneChanged()'>";
	oSelAct = oSelAct + "<option value='" + WID_KPI_ACTION_BUS_CLASS_EXECUTION + "'> " + LBL_EXE_BUS_CLASS + "</option>"; //Ejecutar clase de negocio del usuario
	oSelAct = oSelAct + "<option value='" + WID_KPI_ACTION_START_PROCESS + "'> " + LBL_START_PROCESS + "</option>"; //Ejecutar clase de negocio que inicia proceso
	oSelAct = oSelAct + "<option value='" + WID_KPI_ACTION_SEND_EMAIL + "'> " + LBL_SEND_EMAIL + "</option>"; //Ejecutar clase de negocio que envia emails
	oSelAct = oSelAct + "<option value='" + WID_KPI_ACTION_SEND_NOTIFICATION + "'> " + LBL_SEND_NOTIFICATION + "</option>"; //Ejecutar clase de negocio que envia notificaciónes
	
	//Aquí agregar el resto de las acciones que se quiera agregar
	
	oSelAct = oSelAct + "</select>";
	oTd2.innerHTML = oSelAct;
	
	//-------> Ejecutar
	var oInputBusCla = "<input name='busClaName' disabled id='busClaName' style='width:180px;'></input>";
	oInputBusCla = oInputBusCla + "<span style=\"vertical-align:bottom;\">";	
	oInputBusCla = oInputBusCla + "<img title=\""+LBL_SEL_BUS_CLASS+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openBusClaModal(this);fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
	oInputBusCla = oInputBusCla + "<img title=\""+LBL_SEL_BUS_CLASS_PARAMS+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod_red.gif\" width=\"17\" height=\"16\" onclick=\"openZneBusClaParModal(this);fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
	oInputBusCla = oInputBusCla + "</span>";
	oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaId' value=''></input>";
	oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaParams' value=''></input>";
	oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaParBndId' value=''></input>";
	oTd3.innerHTML = oInputBusCla;
		
	//-------> Ejecutar la primera vez y luego de repetirse
	var oRepeatTimes = "<input type='text' name='zneRepTimes'style='width:25px;' onChange='changRepTimes(this); fncZoneChanged()' value='1'></input>";
	oRepeatTimes = oRepeatTimes + LBL_TIMES; 
	oTd4.innerHTML = oRepeatTimes;
	
	var oTr = document.createElement("TR");
	
	oTr.appendChild(oTd0);
	oTr.appendChild(oTd1);
	oTr.appendChild(oTd2);
	oTr.appendChild(oTd3);
	oTr.appendChild(oTd4);
	
	document.getElementById("gridZonesActions").addRow(oTr);
}

//Copia el valor al input oculto de repetidos
// y si el valor es mayor que 1 setea almacenar 10 como minimo en la bd
function changRepTimes(obj){
	var td = obj.parentNode;
	var inputs = td.getElementsByTagName("INPUT");
	var repValue = inputs[0].value;
	if (isNaN(repValue) || parseInt(repValue) < 1){
		alert(MSG_INS_VAL_POSITIVE);
		inputs[0].value = "1";
	}else {
		if (parseInt(repValue) > 1){
			document.getElementById("cmbStoreLast").value = 10;
		}
	}
}

function chkZneName(obj){
	var newName = obj.value;
	var cant = 0;
	var oldName = document.getElementById("gridZones").selectedItems[0].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
	var rowSelected = document.getElementById("gridZones").selectedItems[0].rowIndex-1;
	
	//1- Nos fijamos si no existe una zona con el nuevo nombre
	trows=document.getElementById("gridZones").rows;
	for (i=0;i<trows.length;i++) {
		if (trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value == newName) {
			if (cant==1){
				alert(MSG_ALR_EXI_ZNE);		
				trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value = oldName;
				trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].focus();
				return false;
			}else{
				cant++;
			}
		}
	}
	
	//2- Nos fijamos si la zona no tiene asociada una acción
	trowsAct=document.getElementById("gridZonesActions").rows;
	for (i=0;i<trowsAct.length;i++) {
		if (trowsAct[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value == oldName) {
			alert(MSG_CANT_CHG_ZONE_NAME);		
			trows[rowSelected].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value = oldName;
			trows[rowSelected].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].focus();
			return false;
		}
	}
	
	
	document.getElementById("gridZones").selectedItems[0].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value = newName;
}


//Cuando se modifica la zona de la acción
function cmbZneAct_change(obj){
	//Modificamos el nombre de la zona asociada a la accion que esta en el input oculto
	var indx = obj.selectedIndex;
	var selected_zne = obj.options[indx].text;

	document.getElementById("gridZonesActions").selectedItems[0].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value = selected_zne;
}

//Cuando se modifica la acción de la zona
function cmbActZne_change(obj){
	var indx = obj.selectedIndex;
	var selected_act = obj.options[indx].value;
	
	var tr = obj.parentNode;
	while(tr.tagName!="TR"){
		tr=tr.parentNode;
	}
	
	var td3 = tr.getElementsByTagName("TD")[3];
	
	if (selected_act == WID_KPI_ACTION_BUS_CLASS_EXECUTION){
		var oInputBusCla = "<input name='busClaName' disabled id='busClaName' style='width:180px;'></input>";
		oInputBusCla = oInputBusCla + "<span style=\"vertical-align:bottom;\">";	
		oInputBusCla = oInputBusCla + "<img title=\""+LBL_SEL_BUS_CLASS+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openBusClaModal(this);fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
		oInputBusCla = oInputBusCla + "<img title=\""+LBL_SEL_BUS_CLASS_PARAMS+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod_red.gif\" width=\"17\" height=\"16\" onclick=\"openZneBusClaParModal(this);fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
		oInputBusCla = oInputBusCla + "</span>";
		oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaId' value=''></input>";
		oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaParams' value=''></input>";
		oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaParBndId' value=''></input>";

	}else if (selected_act == WID_KPI_ACTION_START_PROCESS) {
		var oInputBusCla = "<input name='proName' disabled id='proName' style='width:180px;'></input>";
		oInputBusCla = oInputBusCla + "<span style=\"vertical-align:bottom;\">";	
		oInputBusCla = oInputBusCla + "<img title=\""+LBL_SEL_PROCESS+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openProcessModal(this);fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
		oInputBusCla = oInputBusCla + "<img title=\""+LBL_SEL_ATT_WID_VALUE+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod_red.gif\" width=\"17\" height=\"16\" onclick=\"openAttModal(this,'value');fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
		oInputBusCla = oInputBusCla + "<img title=\""+LBL_SEL_ATT_WID_NAME+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod_red.gif\" width=\"17\" height=\"16\" onclick=\"openAttModal(this,'widName');fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
		oInputBusCla = oInputBusCla + "<img title=\""+LBL_SEL_ATT_WID_ZNE_NAME+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod_red.gif\" width=\"17\" height=\"16\" onclick=\"openAttModal(this,'widZneName');fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
		oInputBusCla = oInputBusCla + "</span>";
		oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaId' value=''></input>";
		oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaParams' value=''></input>";
		oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaParBndId' value=''></input>";
		
	}else if (selected_act == WID_KPI_ACTION_SEND_EMAIL) {
		var oInputBusCla = "<span style=\"vertical-align:bottom;\">";	
		oInputBusCla = oInputBusCla + "<img title=\""+LBL_SUBJECT+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openMessageModal(this,'SUBJECT');fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
		oInputBusCla = oInputBusCla + "<img title=\""+LBL_MESSAGE+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openMessageModal(this,'MESSAGE');fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
		oInputBusCla = oInputBusCla + "<img title=\""+LBL_POOLS+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod_red.gif\" width=\"17\" height=\"16\" onclick=\"openPoolsModal(this,'widName');fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
		oInputBusCla = oInputBusCla + "</span>";
		oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaId' value='" + WID_KPI_BUS_CLA_SEND_EMAIL_ID +"'></input>";
		oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaParams' value=''></input>";
		oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaParBndId' value=''></input>";
	}else if (selected_act == WID_KPI_ACTION_SEND_NOTIFICATION) {
		var oInputBusCla = "<span style=\"vertical-align:bottom;\">";	
		oInputBusCla = oInputBusCla + "<img title=\""+LBL_MESSAGE_NOT+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openNotMessageModal(this);fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
		oInputBusCla = oInputBusCla + "<img title=\""+LBL_POOLS+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod_red.gif\" width=\"17\" height=\"16\" onclick=\"openNotPoolsModal(this,'widName');fncZoneChanged()\" style=\"cursor:pointer;cursor:hand\">";
		oInputBusCla = oInputBusCla + "</span>";
		oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaId' value='" + WID_KPI_BUS_CLA_SEND_NOT_ID +"'></input>";
		oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaParams' value=''></input>";
		oInputBusCla = oInputBusCla + "<input type='hidden' name='hidZneBusClaParBndId' value=''></input>";
	}else if (selected_act == WID_KPI_ACTION_SEND_CHAT_MSG) {
		
	}
	
	td3.innerHTML = oInputBusCla;
	td3.setAttribute("style", "min-width: 316px");
}

function btnDelZone_click(){
	var zneUsed = '';
	//Verificamos si la zona tiene definida una acción
	if (document.getElementById("gridZones").selectedItems.length >= 0){
		trows=document.getElementById("gridZones").selectedItems;
		for (i=0;i<trows.length;i++) { //para cada una de las zonas seleccionadas
			zneName = trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
			trowsAct=document.getElementById("gridZonesActions").rows;
			for (i=0;i<trowsAct.length;i++) { //para cada una de las acciones
				if (trowsAct[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value == zneName) {
					alert(MSG_CANT_DEL_ZONE);
					return;
				}
			}
		}
	}
	document.getElementById("gridZones").removeSelected();
}

function up_click() {
	var grid=document.getElementById("gridZones");
	grid.moveSelectedUp();
}

function down_click() {
	var grid=document.getElementById("gridZones");
	grid.moveSelectedDown();
}

function upAct_click() {
	var grid=document.getElementById("gridZonesActions");
	grid.moveSelectedUp();
}

function downAct_click() {
	var grid=document.getElementById("gridZonesActions");
	grid.moveSelectedDown();
}

function btnDelActionZone_click(){
	fncZoneChanged();
	document.getElementById("gridZonesActions").removeSelected();
}

function fncZoneChanged() {
	document.getElementById("hidZoneChange").value = 1; //Marcamos que se modificaron las zonas
}

function openParameterModal(obj){
	if (document.getElementById("cmbSrcType").value == WIDGET_SRC_TYPE_BUS_CLASS_ID){//Si la fuente de datos es una clase de negocio
		openBusClaParModal(obj);
	}else if (document.getElementById("cmbSrcType").value == WIDGET_SRC_TYPE_CUBE_VIEW_ID){//Si la fuente de datos es una vista {
		//pendiente para crear dimensiones
	}else { //Es una consulta de usuario
		openQryFilterModal(obj);
	}
}

function openBusClaParModal(obj) {
	
	if (document.getElementById("cmbSrc").value == "" || document.getElementById("cmbSrc").value == "0"){
		alert(MSG_MUST_SEL_BUS_CLA_FIRST);
		return;
	}
	
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var rets = openModal("/biDesigner.WidgetAction.do?action=addBusClaParam&busClaId="+document.getElementById("cmbSrc").value + "&notParType=&busClaParValues=" + document.getElementById("txtHidParValues").value + windowId,550,300);//ancho,largo
	//var rets = openModal("/programs/modals/widgetBusClaParamSet.jsp?busClaId="+document.getElementById("cmbSrc").value + "&notParType=&busClaParValues=" + document.getElementById("txtHidParValues").value,550,300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var busClaParams = "";
	var doLoad=function(rets){
		if (rets != null) {
			if (rets != "-1"){
				for (var i=0;i<rets.length;i++){	
					var ret = rets[i];
					var busClaParId = ret[0];
					var busClaParName = ret[1];
					var busClaParType = ret[2];
					var busClaParForWidget = ret[3];
					var busClaParValue = ret[4];
					if (busClaParams == ""){
						busClaParams = busClaParId + "-" + busClaParName + "-" + busClaParType + "-" + busClaParForWidget + "-" + busClaParValue;
					}else{
						busClaParams = busClaParams + "," + busClaParId + "-" + busClaParName + "-"+ busClaParType + "-" + busClaParForWidget + "-" + busClaParValue;
					}
				}
				document.getElementById("txtHidParValues").value = busClaParams;
			}else{
				alert(MSG_WID_BUS_CLA_ERR);
			}
		}
	}
	
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function openParameterShowModal(obj) {
	
	if (document.getElementById("cmbSrc").value == ""){
		alert(MSG_MUST_SEL_QUERY_FIRST);
		return;
	}
	
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	var rets = openModal("/programs/modals/widgetQuerySelColumn.jsp?qryId="+document.getElementById("cmbSrc").value + "&filterParams=" + document.getElementById("txtHidParValues").value + "&widQryCol=" + document.getElementById("txtHidWidQryColumn").value,600,300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var filterParams = "";
	var doLoad=function(rets){
		if (rets != null) {
			if (rets != "-1"){
				for (var i=0;i<rets.length;i++){	
					var ret = rets[i];
					var qryColName = ret[0];
				}
				document.getElementById("txtHidWidQryColumn").value = qryColName;
			}else{
				alert(MSG_WID_BUS_CLA_ERR);
			}
		}
	}
	
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function openQryFilterModal(obj){
	
	if (document.getElementById("cmbSrc").value == ""){
		alert(MSG_MUST_SEL_QUERY_FIRST);
		return;
	}
	
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	var rets = openModal("/biDesigner.WidgetAction.do?action=addQueryFilters&qryId="+document.getElementById("cmbSrc").value + "&filterParams=" + document.getElementById("txtHidParValues").value + windowId,600,300);//ancho,largo
	//var rets = openModal("/programs/modals/widgetQueryFilterSet.jsp?qryId="+document.getElementById("cmbSrc").value + "&filterParams=" + document.getElementById("txtHidParValues").value,600,300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var filterParams = "";
	var doLoad=function(rets){
		if (rets != null) {
			if (rets != "-1"){
				for (var i=0;i<rets.length;i++){	
					var ret = rets[i];
					var qryColId = ret[0];
					var qryColName = ret[1];
					var qryColType = ret[2];
					var qryColValue = ret[3];
					if (filterParams == ""){
						filterParams = qryColId + "-" + qryColName+ "-" + qryColType + "-" + qryColValue;
					}else{
						filterParams = filterParams + "," + qryColId + "-" + qryColName+ "-" + qryColType + "-" + qryColValue;
					}
				}
				document.getElementById("txtHidParValues").value = filterParams;
			}else{
				alert(MSG_WID_BUS_CLA_ERR);
			}
		}
	}
	
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

//Modal para seleccionar una clase de negocio a ejecutar como acción asociada a una zona
function openBusClaModal(obj) {
	
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var td = obj.parentNode.parentNode;
	var inputs = td.getElementsByTagName("INPUT");
	
	var rets = openModal("/programs/modals/busClass.jsp?",500,300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var doLoad=function(rets){
		if (rets != null) {
			var ret = rets[0];
			var busClaId = ret[0];
			var busClaName = ret[1];
			//document.getElementById("busClaName").value = busClaName;
			//document.getElementById("hidZneBusClaId").value = busClaId;
			inputs[0].value = busClaName;
			if (inputs[1].value != busClaId){ //Si se cambio la clase de negocio
				inputs[2].value = ""; //Borramos todos los parametros que habian antes
			}
			inputs[1].value = busClaId;
		}
	}
	
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

//Modal para seleccionar un proceso a iniciar como acción asociada a una zona
function openProcessModal(obj) {
	
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var td = obj.parentNode.parentNode;
	var inputs = td.getElementsByTagName("INPUT");
	
	var rets = openModal("/programs/modals/processes.jsp?getAll=true",500,300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var doLoad=function(rets){
		if (rets != null) {
			var ret = rets[0];
			var proId = ret[0];
			var proName = ret[1];
			inputs[0].value = proName;
			inputs[1].value = WID_KPI_ZNE_ACT_PROCESS;
			inputs[2].value = proName + ", , , ";
		}
	}
	
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

//Modal para seleccionar los parámetros asociados a una clase de negocio del usuario
function openZneBusClaParModal(obj) {
	var td = obj.parentNode.parentNode;
	var inputs = td.getElementsByTagName("INPUT");
	
	if (inputs[1].value == ""){
		alert(MSG_MUST_SEL_BUS_CLA_FIRST);
		return;
	}
	
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var rets = openModal("/programs/modals/widgetBusClaParamSet.jsp?busClaId="+inputs[1].value + "&notParType=&busClaParValues=" + inputs[2].value+"&forAction=true" + "&forZone=true",500,300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var busClaParams = "";
	var doLoad=function(rets){
		if (rets != null) {
			//if (rets != "-1"){
				for (var i=0;i<rets.length;i++){	
					var ret = rets[i];
					var busClaParId = ret[0];
					var busClaParName = ret[1];
					var busClaParType = ret[2];
					var busClaParForWidget = ret[3];
					var busClaParValue = ret[4];
					if (busClaParams == ""){
						busClaParams = busClaParId + "-" + busClaParName + "-" + busClaParType + "-" + busClaParForWidget + "-" + busClaParValue;
					}else{
						busClaParams = busClaParams + "," + busClaParId + "-" + busClaParName + "-"+ busClaParType + "-" + busClaParForWidget + "-" + busClaParValue;
					}
				}
				//document.getElementById("hidZneBusClaParams").value = busClaParams;
				inputs[2].value = busClaParams;
			//}else{
			//	alert("La clase de negocio seleccionada no tiene parametros");
			//}
		}
	}
	
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

//Modal para seleccionar los parámetros asociados a la clase de negocio que inicia procesos
function openZneProcessParModal(obj) {
	var td = obj.parentNode.parentNode;
	var inputs = td.getElementsByTagName("INPUT");
	
	if (inputs[1].value == ""){
		alert(MSG_MUST_SEL_BUS_CLA_FIRST);
		return;
	}
	
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var rets = openModal("/programs/modals/widgetProcessParamSet.jsp?notParType=&busClaParValues=" + inputs[3].value+"&forAction=true" + "&forZone=true",500,300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var busClaParams = "";
	var doLoad=function(rets){
		if (rets != null) {
			//if (rets != "-1"){
				for (var i=0;i<rets.length;i++){	
					var ret = rets[i];
					var busClaParId = ret[0];
					var busClaParName = ret[1];
					var busClaParType = ret[2];
					var busClaParForWidget = ret[3];
					var busClaParValue = ret[4];
					if (busClaParams == ""){
						busClaParams = busClaParId + "-" + busClaParName + "-" + busClaParType + "-" + busClaParForWidget + "-" + busClaParValue;
					}else{
						busClaParams = busClaParams + "," + busClaParId + "-" + busClaParName + "-"+ busClaParType + "-" + busClaParForWidget + "-" + busClaParValue;
					}
				}
				//document.getElementById("hidZneBusClaParams").value = busClaParams;
				inputs[2].value = busClaParams;
			//}else{
			//	alert("La clase de negocio seleccionada no tiene parametros");
			//}
		}
	}
	
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

//Modal para seleccionar un atributo
function openAttModal(obj, attDest) {
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var td = obj.parentNode.parentNode;
	var inputs = td.getElementsByTagName("INPUT");
	var proName = getValInPos(0, inputs[2].value,",");
	var attNameValue = getValInPos(1, inputs[2].value,",");
	var attNameWidName = getValInPos(2, inputs[2].value,",");
	var attNameWidZneName = getValInPos(3, inputs[2].value,",");
	var filter = "&filter=";
	
	if (attDest=='value'){
		filter = filter + attNameValue;
	}else if (attDest=='widName'){
		filter = filter + attNameWidName;
	}else if (attDest=='widZneName'){
		filter = filter + attNameWidZneName;
	}
	
	var pars = inputs[2];
	var rets = openModal("/programs/modals/atts.jsp?onlyOne=true" + filter,500,300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var doLoad=function(rets){
		if (rets != null) {
			var ret = rets[0];
			var attId = ret[0];
			var attName = ret[1];
			if (attDest=='value'){
				attNameValue = attName;
			}else if (attDest=='widName'){
				attNameWidName = attName;
			}else if (attDest=='widZneName'){
				attNameWidZneName = attName;
			}
			inputs[2].value = proName + "," + attNameValue + "," + attNameWidName + "," + attNameWidZneName;
		}
	}
	
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

//Modal para definir el mensaje de un email
function openMessageModal(obj, type) { //type= 'SUBJECT' o 'MESSAGE' o 'NOT_MESSAGE'
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var td = obj.parentNode.parentNode;
	var inputs = td.getElementsByTagName("INPUT");
	var msgBody = getValInPos(0, inputs[1].value,"#");
	var msgSubj = getValInPos(1, inputs[1].value,"#");
	var poolsIds = getValInPos(2, inputs[1].value,"#");//2312,AAAAA,3242,BBBBB,3432,CCCC..
	var msgFormat = msgSubj;
	
	if (type=='MESSAGE'){
		msgFormat = msgBody;
	}
	
	var pars = inputs[2];
	var rets = openModal("/programs/biDesigner/widgets/notificationMessage.jsp?forType=" + type + "&msgFormat="+ msgFormat, 500, 300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var doLoad=function(rets){
		if (rets != null) {
			rets = rets.replace('#',''); //El # es reservado como separardor
			if (type=='SUBJECT'){
				msgSubj = rets;
			}else{
				msgBody = rets;
			}
			inputs[1].value = msgBody + "#" + msgSubj + "#" + poolsIds;
		}
	}
	
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

//Modal para definir el mensaje de una notificacion
function openNotMessageModal(obj) {
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var td = obj.parentNode.parentNode;
	var inputs = td.getElementsByTagName("INPUT");
	var msg = getValInPos(0, inputs[1].value,"#");
	var poolsIds = getValInPos(1, inputs[1].value,"#");//2312,AAAAA,3242,BBBBB,3432,CCCC..
	
	var pars = inputs[2];
	var rets = openModal("/programs/biDesigner/widgets/notificationMessage.jsp?forType=NOT_MESSAGE&msgFormat="+ msg, 500, 300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var doLoad=function(rets){
		if (rets != null) {
			rets = rets.replace('#',''); //El # es reservado como separardor
			msg = rets;
			inputs[1].value = msg + "#" + poolsIds;
		}
	}
	
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function openPoolsModal(obj) {
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var td = obj.parentNode.parentNode;
	var inputs = td.getElementsByTagName("INPUT");
	var msgBody = getValInPos(0, inputs[1].value,"#");
	var msgSubj = getValInPos(1, inputs[1].value,"#");
	var poolsIds = getValInPos(2, inputs[1].value,"#");//2312,AAAAA,3242,BBBBB,3432,CCCC..
	
	var pars = inputs[2];
	var rets = openModal("/programs/biDesigner/widgets/notificationPools.jsp?pools=" + poolsIds, 500, 300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var doLoad=function(rets){
		if (rets != null) {
			poolsIds = rets;
			inputs[1].value = msgBody + "#" + msgSubj + "#" + poolsIds;
		}
	}
	
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function openNotPoolsModal(obj) {
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var td = obj.parentNode.parentNode;
	var inputs = td.getElementsByTagName("INPUT");
	var msgBody = getValInPos(0, inputs[1].value,"#");
	var poolsIds = getValInPos(1, inputs[1].value,"#");//2312,AAAAA,3242,BBBBB,3432,CCCC..
	
	var pars = inputs[2];
	var rets = openModal("/programs/biDesigner/widgets/notificationPools.jsp?pools=" + poolsIds, 500, 300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var doLoad=function(rets){
		if (rets != null) {
			poolsIds = rets;
			inputs[1].value = msgBody + "#" + poolsIds;
		}
	}
	
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}


//Devuelve uno de los valores de un string separado por comas
function getValInPos(pos, values, separator) { //values: value1,value2,value3,value4
	var valArr = values.split(separator);
	return valArr[pos];
}

function colorPicker(element) {
	var color = element.previousSibling;
	selectedColor = color;
	var doAfter=function(rets){
		if (rets!=undefined){
			setColor(rets);
		}
	}
	var rets=openModal(("/flash/query/deploy/colorpicker.jsp?selectedColor="+color.value),260,160);
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function setColor(aColor) {
	selectedColor.value = aColor;
	selectedColor.nextSibling.nextSibling.style.backgroundColor = aColor;
}

function btnRemZneBusCla_click(obj){
	var td = obj.parentNode.parentNode;
	var inputs = td.getElementsByTagName("INPUT");
	
	td.getElementsByTagName("INPUT")[0].value = "";
	td.getElementsByTagName("INPUT")[1].value = "";
	td.getElementsByTagName("INPUT")[1].disabled = true;
	td.getElementsByTagName("INPUT")[2].value = "";
	td.getElementsByTagName("INPUT")[3].value = "";
	td.getElementsByTagName("INPUT")[3].value = "";
}

function cmbStoLstChange(){
	//if (document.getElementById("widFather").value != ""){
	//	if (document.getElementById("cmbStoreLast").value == 0){
	//		alert(MSG_CHI_WID_MUS_STO_VALUES);
	//		document.getElementById("cmbStoreLast").value = 10;
	//	}
	//}
	if (document.getElementById("zneRepTimes")!=null && document.getElementById("zneRepTimes").value != null){
		var repTimes = document.getElementById("zneRepTimes").value;
		if (parseInt(repTimes)>1 && document.getElementById("cmbStoreLast").value == "0"){
			alert(MSG_MST_STO_LST_IF_CTR_REP);
			document.getElementById("cmbStoreLast").value = 10;
		}
	}
}

function btnTestHtml_click(){
	if (document.getElementById("txtCustomSrc").value != ""){
		openModal("/programs/modals/testHTML.jsp?htmlCode=" + escape(removeComments(document.getElementById("txtCustomSrc").value)) + "&isUrl=" + document.getElementById("chkCustUrl").checked,500,300);
	}
}

function removeComments(cod){ //necesaria cuando se usa firefox
	var startCom = cod.indexOf("<!--");
	while (startCom >= 0){
		var endCom = cod.indexOf("-->");
		cod = cod.substring(0,startCom) + cod.substring(endCom+3,cod.length);
		var startCom = cod.indexOf("<!--");
	}
	return cod;
}

function btnDelHtml_click(){
	document.getElementById("txtCustomSrc").value = "";
}

function clickCustUrl(){
	var tdLblCodHtml = document.getElementById("txtCustomSrc").parentNode.previousSibling;
	var btnTestHtml = document.getElementById("btnTestHtml");
	if(document.getElementById("chkCustUrl").checked){
		//1-Cambiar etiqueta de codigo html por url.
		tdLblCodHtml.innerHTML = LBL_DIR_URL + ":";
 		//2-Cambiar etiqueta de boton testear html por testear url
 		btnTestHtml.innerHTML = LBL_TST_URL;
 		//3-Borramos contenido del textArea
 		document.getElementById("txtCustomSrc").value = "http://";
 		//4-Cambiar tooltipo del textArea
 		document.getElementById("txtCustomSrc").title = LBL_ENT_COD_URL;
	}else{
		//1-Cambiar etiqueta de url por codigo html
		tdLblCodHtml.innerHTML = LBL_COD_HTML + ":";
 		//2-Cambiar etiqueta de boton testear url por testear html
 		btnTestHtml.innerHTML = LBL_TST_HTML;
 		//3-Mostramos ejemplo de html
 		document.getElementById("txtCustomSrc").value = HTML_COD_EXAMPLE + "</script>";
 		//4-Cambiar tooltipo del textArea
 		document.getElementById("txtCustomSrc").title = LBL_ENT_COD_HTML;
	}
}

function enableDisableRefTime(){
	if(document.getElementById('chkWidActive').checked){
		document.getElementById("cmbRefPeriod").disabled = false; //Habilitamos el combo de periodicidad
		document.getElementById("txtRef").value = "";
		document.getElementById("txtRef").disabled = true; //Deshabilitamos el input de tiempo de actualizacion
		document.getElementById("cmbRefType").disabled = true; //Deshabilitamos el combo de tipo de tiempo
		document.getElementById("chkNotify").disabled = false; //Habilitamos el check de notificacion
		//Nodo de ejecucion
		document.getElementById("radExeNode1").disabled = false;
		document.getElementById("radExeNode2").disabled = false;
		document.getElementById("radSelected").value="";
		document.getElementById("txtExeNode").value="";
		document.getElementById("txtExeNode").disabled= false;
		document.getElementById("radExeNode1").checked = true; 
	}else{
		document.getElementById("cmbRefPeriod").selectedIndex = 0;
		document.getElementById("cmbRefPeriod").disabled = true; //Deshabilitamos el combo de periodicidad
		document.getElementById("txtRef").disabled = false; //Habilitamos el input de tiempo de actualizacion
		document.getElementById("cmbRefType").disabled = false; //Habilitamos el combo de tipo de tiempo
		document.getElementById("chkNotify").disabled = true; //Deshabilitamos el check de notificacion
		document.getElementById("chkNotify").checked = false;
		document.getElementById("txtEmails").disabled = true; //Deshabilitamos el input de notificacion
		//Nodo de ejecucion
		document.getElementById("radExeNode1").disabled = true; 
		document.getElementById("radExeNode2").disabled = true; 		
		document.getElementById("radSelected").value="";
		document.getElementById("txtExeNode").value="";
		document.getElementById("txtExeNode").disabled= true;
		document.getElementById("radExeNode1").checked = true; 
		document.getElementById("radExeNode2").checked = false;
	}
}

function borrarAllZones(){
    trows=document.getElementById("gridZones").rows;
	var i = 0;
	while (i<trows.length) {
		document.getElementById("gridZones").deleteElement(trows[i]);
	}
}
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

function chkNotifyClk(){
	if (document.getElementById("chkNotify").checked){
		document.getElementById("txtEmails").disabled = false;
		setRequiredField(document.getElementById("txtEmails"));
	}else{
		document.getElementById("txtEmails").disabled = true;	
		unsetRequiredField(document.getElementById("txtEmails"));
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

function enableMetaParams(){
	document.getElementById("widMetaTable").disabled = false;
	document.getElementById("widMetaColumn").disabled = false;
	document.getElementById("widMetaDteColumn").disabled = false;
	document.getElementById("widMetaCondition").disabled = false;
	document.getElementById("widMetaMultiplier").disabled = false;
	document.getElementById("chkMetaByYear").disabled = false;
	document.getElementById("chkMetaByMonth").disabled = false;
	document.getElementById("chkMetaByDay").disabled = false;
	
	if (document.getElementById("widMetaMultiplier").value == ""){
		document.getElementById("widMetaMultiplier").value = "1";
	}
	
	setRequiredField(document.getElementById("widMetaTable"));
	setRequiredField(document.getElementById("widMetaColumn"));
	setRequiredField(document.getElementById("widMetaDteColumn"));
	setRequiredField(document.getElementById("widMetaMultiplier"));
}

function disableMetaParams(){
	unsetRequiredField(document.getElementById("widMetaTable"));
	unsetRequiredField(document.getElementById("widMetaColumn"));
	unsetRequiredField(document.getElementById("widMetaDteColumn"));
	unsetRequiredField(document.getElementById("widMetaMultiplier"));
	document.getElementById("chkMetaByYear").disabled = true;
	document.getElementById("chkMetaByMonth").disabled = true;
	document.getElementById("chkMetaByDay").disabled = true;
	document.getElementById("widMetaTable").disabled = true;
	document.getElementById("widMetaColumn").disabled = true;
	document.getElementById("widMetaDteColumn").disabled = true;
	document.getElementById("widMetaCondition").disabled = true;
	document.getElementById("widMetaMultiplier").disabled = true;
}

function chkSeeMetaClk(){
	if (document.getElementById("chkSeeMeta").checked){
		enableMetaParams();
	}else {
		disableMetaParams();
	}
}

function btnTestSQL_click (){
	testSql('btnTest', 'afterTest');
}

//This function returns a message
function testSql(from, after){
	var dbConId = document.getElementById("dbConId").value;
	var action=	document.getElementById("frmMain").action;
	document.getElementById("frmMain").target="testSql";
	document.getElementById("frmMain").action=("biDesigner.WidgetAction.do?action=sqlTest"+windowId+"&dbConId="+dbConId+"&from="+from+"&after="+after);
	submitForm(document.getElementById("frmMain"));
	document.getElementById("frmMain").action=action;
	document.getElementById("frmMain").target="_self";
}

function afterTest(msg){
	var loader=new xmlLoader();
	var xml=loader.loadString(msg);
	var result = xml.firstChild.firstChild.nodeValue;
	if(result.indexOf("OK-")==0){
		result = result.substring(3,result.length);
		alert(LBL_RESULT + ": '" + result + "'");
	}else{
		alert("SQL ERROR: " + xml.firstChild.firstChild.nodeValue);
	}
}

function afterNext(msg){
	var loader=new xmlLoader();
	var xml=loader.loadString(msg);
	var result = xml.firstChild.firstChild.nodeValue;
	if(result == "OK"){
		document.getElementById("frmMain").action = "biDesigner.WidgetAction.do?action=kpiUpdate";
		submitForm(document.getElementById("frmMain"));
	}else if(result == "NOK"){
		alert(MSG_SQL_NOT_NUM_RET);
	}else {
		alert("SQL ERROR: " + xml.firstChild.firstChild.nodeValue);
	}
}
