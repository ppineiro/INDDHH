//-------------------------------
//---- Funciones de solapa de Consultas Analiticas
//-------------------------------

function isValidCubeName(s){
var re = new RegExp("^[a-zA-Z0-9_.]+[^ ]*$");
//	var x = reAlphanumeric.test(s);
//	if(!x){
	if (!s.match(re)) {
		alert(MSG_CUBE_NAME_INVALID);
		return false;
	}
	return true;
}

function verifyCubeData() {
	if(document.getElementById('chkCreateCbe')!=null && document.getElementById('chkCreateCbe').checked){
		//Verificamos si ingreso nombre al cubo
		if (document.getElementById("txtCbeName").value==""){
			alert(MSG_MUST_ENT_CBE_NAME);
			return false;
		}
		if(!isValidCubeName(document.getElementById("txtCbeName").value)){
			return false;
		}
		
		//Verificamos si el nombre del cubo es único
		if (checkExistCubeName(document.getElementById("txtCbeName").value)){
			alert(MSG_CUBE_NAME_ALREADY_EXIST);
			return false;
		}
		
		//Verificamos si ingreso al menos una dimension
		if (document.getElementById("gridDims").rows.length < 1){
			alert(MSG_MUST_ENT_ONE_DIM);
			return false;
		}
		
		//Verificamos todas las dimensiones se llamen distinto
		if (!checkDimNames()){
			alert(MSG_DIM_NAME_UNIQUE);
			return false;
		}
		
		//Verificamos dimensiones
		var dimRows=document.getElementById("gridDims").rows;
		var someAttNoBasic = false;
		for(var i=0;i<dimRows.length;i++){
			var dimName=dimRows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
			var attName = dimRows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
			var attId = dimRows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
			if(attName == ""){//Verificamos que los nombres de los atributos no sean nulos
				alert(MSG_MIS_DIM_ATT);
				return false;
			}
			if (dimName == ""){//Verificamos que los nombres de las dimensiones no sean nulos
				alert(MSG_WRG_DIM_NAME);
				return false;
			}
			if (attId>0){
				someAttNoBasic = true;
			}
		}
		
		//Verificamos se haya ingresado almenos una dimension con un atributo
		//if (someAttNoBasic == false){
		//	alert(MSG_AT_LEAST_ONE_DIM_MUST_USE_ATT);
		//	return false;
		//}
				
		//Verificamos si ingreso al menos una medida
		if (document.getElementById("gridMeasures").rows.length < 1){
			alert(MSG_MUST_ENT_ONE_MEAS);
			return false;
		}
		
		//Verificamos todas las medidas se llamen distinto
		if (!checkMeasureNames()){
			alert(MSG_MEASURE_NAME_UNIQUE);
			return false;
		}
		
		//Verificamos medidas
		var meaRows=document.getElementById("gridMeasures").rows;
		var visible = false;
		for(var i=0;i<meaRows.length;i++){
			var meaName=meaRows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
			if (meaName == ""){//Verificamos que los nombres de las medidas no sean nulos
				alert(MSG_WRG_MEA_NAME);
				return false;
			}
			
			var cmb=meaRows[i].cells[3].getElementsByTagName("SELECT")[0];
			var measType = (cmb.options[cmb.selectedIndex].value);
			if (measType == 1){//Si es medida calculada verificamos la formula
				var measFormula = meaRows[i].getElementsByTagName("TD")[6].getElementsByTagName("INPUT")[0];
				if (!chkFormula(measFormula,meaName)){
					return false;
				}
			}else{
				var attName = meaRows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
				if (attName == ""){
					alert(MSG_MIS_MEA_ATT);
					return false;
				}
			}
			if (meaRows[i].getElementsByTagName("TD")[7].getElementsByTagName("INPUT")[0].checked){
				visible = true;
			}
		}
		
		if (!visible){
			alert(MSG_ATLEAST_ONE_MEAS_VISIBLE);
			return false;
		}
		/*
		//Verificamos si ingreso al menos un perfil
		if (document.getElementById("gridProfiles").rows.length < 1){
			alert(MSG_MUST_ENT_ONE_PRF);
			return false;
		}*/
		
				
		//9. Verificamos que si se agrego algun perfil para restringir sus dimensiones, se haya restringido alguna
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
		
	}	
	return true;
}

function checkExistCubeName(cubeName,cubeId){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.ProcessAction.do?action=checkExistCbeName"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "cubeName=" + cubeName;
	if (cubeId!=null && cubeId!=''){
		str = str + "&cubeId=" + cubeId;
	}
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
}

function checkDimNames(){
	trows=document.getElementById("gridDims").rows;
	for (i=0;i<trows.length;i++) {
		var attId = trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
		var dimName = trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
		for (j=0;j<trows.length;j++){
			var attId2 = trows[j].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
			var dimName2 = trows[j].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
			if (attId != attId2 && dimName == dimName2){
				return false; //se repite el nombre de una dimension
			}
		}
	}
	return true; //no se repite el nombre de ninguna dimension
}

function checkMeasureNames(){
	trows=document.getElementById("gridMeasures").rows;
	for (i=0;i<trows.length;i++) {
		var rowId = i;
		var measName = trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
		for (j=0;j<trows.length;j++){
			var measName2 = trows[j].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
			if (j != rowId && measName == measName2){
				return false; //se repite el nombre de una medida
			}
		}
	}
	return true; //no se repite el nombre de ninguna medida
}

//btn: Agregar Dimensiones --> Agrega una dimension
function btnAddDimension_click() {
	
	var attIds = document.getElementById("txtHidAttIds").value;
	var attEntIds = document.getElementById("txtHidEntAttIds").value;
	var attProIds = document.getElementById("txtHidProAttIds").value;	
	//alert("attIds que debo marcar en el modal:"+attIds);
	//1- Mostramos el tree con formularios y atributos
	var rets = null;
	var rets = openModal("/administration.ProcessAction.do?action=addAttDimension&attIds="+attIds + "&attEntIds="+attEntIds+"&attProIds="+attProIds + windowId,(getStageWidth()*.8),(getStageHeight()*.7));//ancho,largo
	var doLoad=function(rets){
		if (rets != null) {
			if (rets!="NOK"){
				if (rets.length>0){
					var strAttIds = "";
					var strEntAttIds = "";
					var strProAttIds = "";
					
					for (j = 0; j < rets.length; j++) {
						var ret = rets[j];
						if (ret[0] != "skip"){
							var attId = ret[0];
							var attName = ret[1];
							var attLbl = ret[2];
							var attType = ret[3];
							var attMapEntId = ret[4];
							var attMapEntName = ret[5];
							var attFrom = ret[6];
							var addDim = true;
							//Guardamos el attId que se selecciono en el string attIds correspondiente
							if (attFrom == DW_ATT_FROM_ENTITY_FORM){ //Proviene de un formulario de entidad
								if (strEntAttIds == ""){
									strEntAttIds = attId;
								}else{
									strEntAttIds = strEntAttIds + "," + attId;
								}
							}else if (attFrom == DW_ATT_FROM_PROCESS_FORM){//Proviene de un formulario de proceso
								if (strProAttIds == ""){
									strProAttIds = attId;
								}else{
									strProAttIds = strProAttIds + "," + attId;
								}
							}else { //Si no proviene de un formulario de entidad o proceso (proviene de un dato basico de proc o ent o es redundante)
								if (strAttIds == ""){
									strAttIds = attId;
								}else{
									strAttIds = strAttIds + "," + attId;
								}
							}
							
							if (attMapEntId == null || attMapEntId == "null"){
								attMapEntId = "";
							}
							if (attMapEntName == null || attMapEntName == "null"){
								attMapEntName = "";
							}
							
							//2- Nos fijamos si ya no se habia agregado la dimension
							var trows=document.getElementById("gridDims").rows;
							for (i=0;i<trows.length && addDim;i++) {
								if (trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value == attId) {
									addDim = false;
								}
							}
							
							var row = trows.length;
							
							//3- Si no se habia agregado, agregamos el atributo seleccionado como dimension
							if (addDim) {
								var oTd0 = document.createElement("TD"); //oculto
								var oTd1 = document.createElement("TD"); //atributo
								var oTd2 = document.createElement("TD"); //tipo
								var oTd3 = document.createElement("TD"); //props
								var oTd4 = document.createElement("TD"); //Entidad Mapeo o levels de dimension tipo fecha
								
								var dimName = "DIMENSION" + (document.getElementById("gridDims").rows.length + 1);
							
								oTd0.innerHTML='<input type="hidden" name="chkSel" value="">';
								
								//Atributo
								var oInputAtt = "<input name='attDimName' disabled id='attDimName' style='width:90px;' value='"+ attName +"' title='" + attName + "' >";
								oInputAtt = oInputAtt + "<input type='hidden' name='hidAttId' value='"+ attId +"'>";
								oInputAtt = oInputAtt + "<input type='hidden' name='hidAttName' value='"+ attName +"'>";
								oInputAtt = oInputAtt + "<input type='hidden' name='hidAttType' value='"+ attType +"'>";
								oInputAtt = oInputAtt + "<input type='hidden' name='hidAttFrom' value='"+ attFrom +"'>";
								oInputAtt = oInputAtt + "<input type='hidden' name='hidDimEntDwColId' value='0'>";
								oTd1.innerHTML = oInputAtt;
									
								var oSelectMed = "";
								
								if (attType=='S'){
									oTd2.innerHTML="STRING";
								}else if (attType == 'N'){
									oTd2.innerHTML="NUMERIC";
								}else{
									oTd2.innerHTML="DATE";
								}
								
								//Propiedades
								oTd3.innerHTML = "<span style=\"vertical-align;bottom;\">";
								oTd3.innerHTML += "<img title=\""+LBL_CLI_TO_PROPS+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openPropModal(this)\" style=\"cursor:pointer;cursor:hand\">";
								oTd3.innerHTML += "</span>";
								oTd3.innerHTML += "<input type=\"hidden\" id=\"hidDimProp\" name=\"hidDimProp\" value=\""+ "" +"\">";
								
								//Nombre de la dimension
								oTd4.innerHTML = "<input type='text' name='txtDimName' maxlength='50' onchange='chkDimName(this)' value='" + dimName +"'>"; //--> Agregamos el disp name	
								
								if (attType=='S'||attType=='N'){
									oTd4.innerHTML += " <input type=\"hidden\" id=\"txtMapEntityId\" name=\"txtMapEntityId\" value=\""+ attMapEntId +"\">";
									if (attId > 0){
										oTd4.innerHTML += " <input type=\"text\" id=\"txtMapEntityName\" name=\"txtMapEntityName\" title=\""+MAP_ENTITY+ ": " + attMapEntName + "\" disabled value=\""+ attMapEntName +"\">";
										oTd4.innerHTML += "<span style=\"vertical-align:bottom;\">";
										oTd4.innerHTML += " <img title=\""+LBL_SEL_MAP_ENTITY+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openEntModal(this)\" style=\"cursor:pointer;cursor:hand\">";
										oTd4.innerHTML += "<img title=\""+LBL_DEL_MAP_ENTITY+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE + "/images/eraser.gif\" width=\"17\" height=\"16\" onclick=\"btnRemMapEnt_click(this)\" style=\"cursor:pointer;cursor:hand\">";
										oTd4.innerHTML += " <input type=\"hidden\" id=\"hidAttTypeOriginal\" name=\"hidAttTypeOriginal\" value=\"STRING\">";
										oTd4.innerHTML += "</span>";
									}
								}else if (attType == 'D'){
									oTd4.innerHTML += "<span> | </span><span>" + LBL_YEAR + ":</span> <span><input type='checkbox' name='chkYear' checked='true' value=\"" + row + "\"></span>";
									oTd4.innerHTML += "<span> | </span><span>" + LBL_SEMESTER + ":</span> <span><input type='checkbox' name='chkSem' checked='true' value=\"" + row + "\"></span>";
									oTd4.innerHTML += "<span> | </span><span>" + LBL_TRIMESTER + ":</span> <span><input type='checkbox' name='chkTrim' value=\"" + row + "\"></span>";
									oTd4.innerHTML += "<span> | </span><span>" + LBL_MONTH + ":</span> <span><input type='checkbox' name='chkMonth' checked='true' value=\"" + row + "\"></span>";
									oTd4.innerHTML += "<span> | </span><span>" + LBL_WEEKDAY + ":</span> <span><input type='checkbox' name='chkWeekDay' value=\"" + row + "\"></span>";
									oTd4.innerHTML +="<span> | </span><span>" + LBL_DAY + ":</span> <span><input type='checkbox' name='chkDay' value=\"" + row + "\"></span>";
									oTd4.innerHTML +="<span> | </span><span>" + LBL_HOUR + ":</span> <span><input type='checkbox' name='chkHour' value=\"" + row + "\"></span>";
									oTd4.innerHTML +="<span> | </span><span>" + LBL_MINUTE + ":</span> <span><input type='checkbox' name='chkMin' value=\"" + row + "\"></span>";
									oTd4.innerHTML +="<span> | </span><span>" + LBL_SECOND + ":</span> <span><input type='checkbox' name='chkSec' value=\"" + row + "\"></span>";
									oTd4.innerHTML += "<input type=\"hidden\" id=\"txtMapEntityId\" name=\"txtMapEntityId\" value=\""+ attMapEntId +"\">"											
								}
								var oTr = document.createElement("TR");
								
								oTr.appendChild(oTd0);
								oTr.appendChild(oTd1);
								oTr.appendChild(oTd2); //Se inserta este vacio para poner luego de seleccionado un atributo el tipo
								oTr.appendChild(oTd3);
								oTr.appendChild(oTd4);
								document.getElementById("gridDims").addRow(oTr);
								
								cubeChanged();//Marcamos como que el cubo se modifico estructuralmente
							}
						}else{
							//Guardamos el attId que se selecciono en el string attIds
							if (strAttIds == ""){
								strAttIds = ret[1]; //Si el attId es skip, el attId viene en la posicion 1
							}else{
								strAttIds = strAttIds + "," + ret[1];
							}
						}
					}
				}else{//Debemos borrar todas las filas
					trows=document.getElementById("gridDims").rows;
					var i = 0;
					while (i<trows.length) {
						document.getElementById("gridDims").deleteElement(trows[i]);
					}
				}
			}
			if (strAttIds!="" || strEntAttIds!="" || strProAttIds!=""){
				//Verificamos si se des-selecciono algun atributo que antes era dimension
				trows=document.getElementById("gridDims").rows;
				var i = 0;
				while (i<trows.length) {
					var attId = trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
					if (!inAttIds(strAttIds+"",attId) && !inAttIds(strEntAttIds+"",attId) && !inAttIds(strProAttIds+"",attId) ){ //se le agrega "" por si es un  valor solo, para transformarlo a string
						document.getElementById("gridDims").deleteElement(trows[i]);
					}else{
						i++;
					}
				}
			}else{//Debemos borrar todas las filas
				trows=document.getElementById("gridDims").rows;
				var i = 0;
				while (i<trows.length) {
					document.getElementById("gridDims").deleteElement(trows[i]);
				}
			}
			document.getElementById("txtHidAttIds").value = strAttIds;
			document.getElementById("txtHidEntAttIds").value = strEntAttIds;
			document.getElementById("txtHidProAttIds").value = strProAttIds;
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}
//btn: Agregar Medida --> Abrega una medida
function btnAddMeasure_click() {
	var attMsrIds = document.getElementById("txtHidAttMsrIds").value;
	var attEntMsrIds = document.getElementById("txtHidAttEntMsrIds").value;
	var attProMsrIds = document.getElementById("txtHidAttProMsrIds").value;
	
	//1- Mostramos el tree con formularios y atributos
	var rets = null;
	//var rets = openModal("/administration.ProcessAction.do?action=addAttDimension&attIds="+attIds +"&attEntIds="+attEntIds+"&attProIds="+attProIds + windowId,800,700);//ancho,largo
	var rets = openModal("/administration.ProcessAction.do?action=addAttMeasure&attMsrIds="+attMsrIds + "&attEntMsrIds=" + attEntMsrIds + "&attProMsrIds=" + attProMsrIds + windowId,(getStageWidth()*.8),(getStageHeight()*.7));//ancho,largo
	var doLoadMsr=function(rets){
		if (rets != null) {
			if (rets!="NOK"){
				var strAttIds = "";
				var strEntAttIds = "";
				var strProAttIds = "";
				
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];
					if (ret[0] != "skip"){
						var attId = ret[0];
						var attName = ret[1];
						var attLbl = ret[2];
						var attType = ret[3];
						var attMapEntId = ret[4];
						var attMapEntName = ret[5];
						var attFrom = ret[6];
						var addMeas = true;
						
						//Guardamos el attId que se selecciono en el string attIds correspondiente
						if (attFrom == DW_ATT_FROM_ENTITY_FORM){ //Proviene de un formulario de entidad
							if (strEntAttIds == ""){
								strEntAttIds = attId;
							}else{
								strEntAttIds = strEntAttIds + "," + attId;
							}
						}else if (attFrom == DW_ATT_FROM_PROCESS_FORM){//Proviene de un formulario de proceso
							if (strProAttIds == ""){
								strProAttIds = attId;
							}else{
								strProAttIds = strProAttIds + "," + attId;
							}
						}else{//Si no proviene de un formulario de entidad o proceso (es un dato basico de proceso o entidad o redundante)
							if (strAttIds == ""){
								strAttIds = attId;
							}else{
								strAttIds = strAttIds + "," + attId;
							}
						}
						
						//2- Nos fijamos si ya no se agrego una medida con ese atributo (si se desea generar otra medida con ese atributo se debe duplicar)
						trows=document.getElementById("gridMeasures").rows;
						for (i=0;i<trows.length && addMeas;i++) {
							if (trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value == attId) {
								addMeas = false;
							}
						}
						
						//3- Si no se habia agregado, agregamos el atributo seleccionado como dimension
						if (addMeas) {
	
							/*
							Agregado de medidas: Hay dos tipos de medidas: Medidas comunes que utilizan una columna de la tabla de hechos y medidas calculadas que utilzan otras medidas
							*/
							
							// agregamos como tipo Measure por defecto
							
							var oTd0 = document.createElement("TD"); //oculto
							var oTd1 = document.createElement("TD"); //atributo
							var oTd2 = document.createElement("TD"); //nombre de la medida
							var oTd3 = document.createElement("TD"); //tipos de medida
							var oTd4 = document.createElement("TD"); //agregadores
							var oTd5 = document.createElement("TD"); //formato
							var oTd6 = document.createElement("TD"); //formula
							var oTd7 = document.createElement("TD"); //visible
							
							var measureName = "MEASURE" + (document.getElementById("gridMeasures").rows.length + 1);
								
							oTd0.innerHTML='<input type="hidden" name="chkSel" value="">';
						
							//Atributo
							var oInputAtt = "<input name='attMeaName' disabled id='attMeaName' style='width:150px;'  value='"+ attName +"' title='" + attName + "' >";
							oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasId' value='"+ attId +"'>";
							oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasName' value='"+ attName +"'>";
							oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasFrom' value='"+ attFrom +"'>";
							oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasType' value='"+ attType +"'>";
							oInputAtt = oInputAtt + "<input type='hidden' name='hidMeasEntDwColId' value='0'>";
							oTd1.innerHTML = oInputAtt;
									
							//Nombre a mostrar
							oTd2.innerHTML = "<input type='text' name='dispName' maxlength='50' onchange='chkMeasName(this)' value='" + measureName +"'>"; //--> Agregamos el disp name
								
							var oSelectMed = "";
							//Tipo de medida
							oSelectMed = "<select name='selTypeMeasure' onchange='changeMeasureType(this)'>";
							oSelectMed = oSelectMed + "<option value='0' selected>"+ LBL_MEAS_STANDARD + "</option>";
							oSelectMed = oSelectMed + "<option value='1'>"+ LBL_MEAS_CALCULATED + "</option>";
							oSelectMed = oSelectMed + "</select>";
							oTd3.innerHTML = oSelectMed; //--> Agregamos el combo con lo tipos de medidas
							//Opciones de agregador
							var oSelect = "<select name='selAgregator' style='display:block'>";
							if (attType == "S" || attType == "D"){
								oSelect = oSelect + "<option value='2'>COUNT</option>";
								oSelect = oSelect + "<option value='5'>DIST. COUNT</option>";
							}else{
								oSelect = oSelect + "<option value='0'>SUM</option>";
								oSelect = oSelect + "<option value='1'>AVG</option>";
								oSelect = oSelect + "<option value='2'>COUNT</option>";
								oSelect = oSelect + "<option value='3'>MIN</option>";	
								oSelect = oSelect + "<option value='4'>MAX</option>";
								oSelect = oSelect + "<option value='5'>DIST. COUNT</option>";
							}
							oSelect = oSelect + "</select>";
							
							oTd4.innerHTML = oSelect; //--> Agregamos el combo con los agregadores
							//Formato
							oTd5.innerHTML = "<input type='text' name='format' value='#,###.0'>"; //--> Agregamos el input formato
							//Formula
							oTd6.innerHTML = "<input type='text' name='formula'  onchange='chkFormula(this,null)' value='' size=40 style='display:none' title='[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos'>"; //--> Agregamos el input formula
							
							var oTr = document.createElement("TR");
							
							oTr.appendChild(oTd0);
							oTr.appendChild(oTd1);
							oTr.appendChild(oTd2);
							oTr.appendChild(oTd3);
							oTr.appendChild(oTd4);
							oTr.appendChild(oTd5);
							oTr.appendChild(oTd6);
							oTr.appendChild(oTd7);
							
							document.getElementById("gridMeasures").addRow(oTr);
							
							var rowIndx = oTr.rowIndex - 1;
							
							//Visible
							oTd7.innerHTML = "<input type='checkbox' name='visible' value='"+ rowIndx + "' checked='true'>"; //--> Agregamos el checkbox visible
							
							cubeChanged();//Marcamos como que el cubo se modifico estructuralmente
						}
					}else{
						//Guardamos el attId que se selecciono en el string attIds
						if (strAttIds == ""){
							strAttIds = ret[1]; //Si el attId es skip, el attId viene en la posicion 1
						}else{
							strAttIds = strAttIds + "," + ret[1];
						}
					}
				} //end For
				
				document.getElementById("txtHidAttMsrIds").value = strAttIds;
				document.getElementById("txtHidAttEntMsrIds").value = strEntAttIds;
				document.getElementById("txtHidAttProMsrIds").value = strProAttIds;
				
			} //end if (rets!="NOK")
		}// end if (rets != null) 
	}//end doLoad=function
	rets.onclose=function(){
		doLoadMsr(rets.returnValue);
	}
}

function enableDisable(){
	cubeChanged(); //Hacemos que se versione el proceso indicando que se modifico el cubo
	if(document.getElementById('chkCreateCbe').checked){
		//Habilitamos todo
		document.getElementById('txtCbeName').p_required=true;
		document.getElementById('txtCbeName').disabled=false;
		document.getElementById('txtCbeTitle').p_required=true;
		document.getElementById('txtCbeTitle').disabled=false;
		document.getElementById('txtCbeDesc').disabled=false;
		document.getElementById('btnAddDim').disabled=false;
		document.getElementById('btnDelDim').disabled=false;
		document.getElementById('btnDupMeas').disabled=false;
		document.getElementById('btnAddMeas').disabled=false;
		document.getElementById('btnDelMeas').disabled=false;
		document.getElementById('btnAddCbePrf').disabled=false;
		document.getElementById('btnDelCbePrf').disabled=false;
		document.getElementById('btnAddNoAccPrf').disabled=false;
		document.getElementById('btnDelNoAccPrf').disabled=false;
		//document.getElementById('chkLodInMemAtStart').disabled=false;
		document.getElementById('btnEstTime').disabled=false;
		document.getElementById('dataLoad1').disabled=false;
		document.getElementById('dataLoad2').disabled=false;
	}else{
		if (confirm(MSG_DELETE_CUBE_CONFIRM)) {
		var widNames = getWidgetDependency();
			if (widNames == null || widNames == "null"){
				var cbeNames = getCubesDependency();
				if (cbeNames == null || cbeNames == "null"){
					document.getElementById('txtCbeName').p_required=false;
					document.getElementById('txtCbeName').disabled=true;
					document.getElementById('txtCbeName').value = "";
					document.getElementById('txtCbeTitle').p_required=false;
					document.getElementById('txtCbeTitle').disabled=true;
					document.getElementById('txtCbeTitle').value = "";
					document.getElementById('txtCbeDesc').disabled=true;
					document.getElementById('txtCbeDesc').value = "";
					document.getElementById('btnAddDim').disabled=true;
					document.getElementById('btnDelDim').disabled=true;
					document.getElementById('btnDupMeas').disabled=true;
					document.getElementById('btnAddMeas').disabled=true;
					document.getElementById('btnDelMeas').disabled=true;
					document.getElementById('btnAddCbePrf').disabled=true;
					document.getElementById('btnDelCbePrf').disabled=true;
					//document.getElementById('chkLodInMemAtStart').checked = false;
					//document.getElementById('chkLodInMemAtStart').disabled=true;
					document.getElementById('btnEstTime').disabled=true;
					document.getElementById('dataLoad1').disabled=true;
					document.getElementById('dataLoad2').disabled=true;
					document.getElementById('txtHidAttIds').value = "";
					document.getElementById('txtHidEntAttIds').value = "";
					document.getElementById('txtHidProAttIds').value = "";
					document.getElementById('txtHidAttMsrIds').value = "";
					document.getElementById('txtHidAttEntMsrIds').value = "";
					document.getElementById('txtHidAttProMsrIds').value = "";
					borrarAllDimensions();
					borrarAllMeasures();
					borrarAllProfiles();
					borrarAllNoAccProfiles();
				}else{
					alert(MSG_CBE_IN_USE_BY_CUBE.replace("<TOK1>", cbeNames));
					document.getElementById('chkCreateCbe').checked = true;
				}
			}else{
				alert(MSG_CBE_IN_USE_BY_WIDGET.replace("<TOK1>",widNames));
				document.getElementById('chkCreateCbe').checked = true;
			}
		}else{
			document.getElementById('chkCreateCbe').checked = true;
		}
	}
}

//btn: Duplicar medida
function btnDupMeasure_click() {
	var trows=document.getElementById("gridMeasures").rows;
	if (trows.length>0 && document.getElementById("gridMeasures").selectedItems.length == 1){
			var selItem = document.getElementById("gridMeasures").selectedItems[0].rowIndex-1;
			if (selItem<0){
				alert(MSG_MUST_SEL_MEAS_FIRST);
				return;
			}
			var cmbMeasType = trows[selItem].getElementsByTagName("TD")[3].getElementsByTagName("SELECT")[0];
			var measType = cmbMeasType.options[cmbMeasType.selectedIndex].value;
			var attId = "";
			var attName = "";
			var attLbl = "";
			var attFrom = "";
			var attType = "";
			var attMapEntId = "";
			if (measType == "0"){ //Si es una medida estandard
				attId = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
				attName = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[2].value;
				attLbl = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[2].value;
				attFrom = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[3].value;
				attType = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[4].value;
				attMapEntId = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[5].value;
			}
			var measureName = trows[selItem].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
			var cmbMeasFunc = trows[selItem].getElementsByTagName("TD")[4].getElementsByTagName("SELECT")[0];
			var measFunc = cmbMeasFunc.options[cmbMeasFunc.selectedIndex].value;
			var measFormat = trows[selItem].getElementsByTagName("TD")[5].getElementsByTagName("INPUT")[0].value;
			var measFormul = trows[selItem].getElementsByTagName("TD")[6].getElementsByTagName("INPUT")[0].value;
			var measVis = trows[selItem].getElementsByTagName("TD")[7].getElementsByTagName("INPUT")[0].checked;
			
			var oTd0 = document.createElement("TD"); //oculto
			var oTd1 = document.createElement("TD"); //atributo
			var oTd2 = document.createElement("TD"); //nombre de la medida
			var oTd3 = document.createElement("TD"); //tipos de medida
			var oTd4 = document.createElement("TD"); //agregadores
			var oTd5 = document.createElement("TD"); //formato
			var oTd6 = document.createElement("TD"); //formula
			var oTd7 = document.createElement("TD"); //visible
			
			oTd0.innerHTML='<input type="hidden" name="chkSel" value="">';
			
			//Atributo
			var oInputAtt = "";
			if (measType == "0"){
				oInputAtt = "<input name='attMeaName' disabled id='attMeaName' style='width:150px;'  value='"+ attName +"' title='" + attName + "' >";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasId' value='"+ attId +"'>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasName' value='"+ attName +"'>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasFrom' value='"+ attFrom +"'>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasType' value='"+ attType +"'>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidMeasEntDwColId' value='0'>";
				oTd1.innerHTML = oInputAtt;
			}else{
				oInputAtt = "<input name='attMeaName' disabled id='attMeaName' style='display:none;width:150px;'  value='' title='' >";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasId' value='"+ attId +"'>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasName' value='"+ attName +"'>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasFrom' value='"+ attFrom +"'>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasType' value='"+ attType +"'>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidMeasEntDwColId' value='0'>";
				oTd1.innerHTML = oInputAtt;
			}
					
			//Nombre a mostrar
			var newMeasureName = "MEASURE" + (document.getElementById("gridMeasures").rows.length + 1);
			oTd2.innerHTML = "<input type='text' name='dispName' maxlength='50' onchange='chkMeasName(this)' value='" + newMeasureName +"'>"; //--> Agregamos el disp name
				
			var oSelectMed = "";
			//Tipo de medida
			oSelectMed = "<select name='selTypeMeasure' onchange='changeMeasureType(this)'>";
			if (measType == "0"){
				oSelectMed = oSelectMed + "<option value='0' selected>"+ LBL_MEAS_STANDARD + "</option>";
				oSelectMed = oSelectMed + "<option value='1'>"+ LBL_MEAS_CALCULATED + "</option>";
			}else{
				oSelectMed = oSelectMed + "<option value='0'>"+ LBL_MEAS_STANDARD + "</option>";
				oSelectMed = oSelectMed + "<option value='1' selected>"+ LBL_MEAS_CALCULATED + "</option>";
			}
			
			oSelectMed = oSelectMed + "</select>";
			oTd3.innerHTML = oSelectMed; //--> Agregamos el combo con lo tipos de medidas
			//Opciones de agregador
			var oSelect = "";
			if (measType == "0"){
				oSelect = "<select name='selAgregator' style='display:block'>";
			}else{
				oSelect = "<select name='selAgregator' style='display:none'>";
			}
			if (measFunc == "0"){
				oSelect = oSelect + "<option value='0' selected>SUM</option>";
			}else if (attType == "N"){
				oSelect = oSelect + "<option value='0'>SUM</option>";
			}
			if (measFunc == "1"){
				oSelect = oSelect + "<option value='1' selected>AVG</option>";
			}else if (attType == "N"){
				oSelect = oSelect + "<option value='1'>AVG</option>";
			}
			if (measFunc == "2"){
				oSelect = oSelect + "<option value='2' selected>COUNT</option>";
			}else{
				oSelect = oSelect + "<option value='2'>COUNT</option>";
			}
			if (measFunc == "3"){
				oSelect = oSelect + "<option value='3' selected>MIN</option>";	
			}else if (attType == "N"){
				oSelect = oSelect + "<option value='3'>MIN</option>";
			}
			if (measFunc == "4"){
				oSelect = oSelect + "<option value='4' selected>MAX</option>";
			}else if (attType == "N"){
				oSelect = oSelect + "<option value='4'>MAX</option>";
			}
			if (measFunc == "4"){
				oSelect = oSelect + "<option value='5' selected>DIST. COUNT</option>";
			}else{
				oSelect = oSelect + "<option value='5'>DIST. COUNT</option>";
			}
			oSelect = oSelect + "</select>";
			oTd4.innerHTML = oSelect; //--> Agregamos el combo con los agregadores
			//Formato
			if (measType == "0"){
				oTd5.innerHTML = "<input type='text' name='format' value='"+ measFormat +"'>"; //--> Agregamos el input formato
			}else{
				oTd5.innerHTML = "<input type='text' name='format' style='display:none' value='"+ measFormat +"'>"; //--> Agregamos el input formato
			}
			//Formula
			if (measType == "0"){
				oTd6.innerHTML = "<input type='text' name='formula'  onchange='chkFormula(this,null)' value='" + measFormul+ "' size=40 style='display:none' title='[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos'>"; //--> Agregamos el input formula
			}else{
				oTd6.innerHTML = "<input type='text' name='formula'  onchange='chkFormula(this,null)' value='" + measFormul+ "' size=40 title='[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos'>"; //--> Agregamos el input formula
			}
			
			var oTr = document.createElement("TR");
			
			oTr.appendChild(oTd0);
			oTr.appendChild(oTd1);
			oTr.appendChild(oTd2);
			oTr.appendChild(oTd3);
			oTr.appendChild(oTd4);
			oTr.appendChild(oTd5);
			oTr.appendChild(oTd6);
			oTr.appendChild(oTd7);
			
			document.getElementById("gridMeasures").addRow(oTr);
			
			var rowIndx = oTr.rowIndex - 1;
			
			//Visible
			if (measVis){
				oTd7.innerHTML = "<input type='checkbox' name='visible' value='"+ rowIndx + "' checked='true'>"; //--> Agregamos el checkbox visible
			}else{
				oTd7.innerHTML = "<input type='checkbox' name='visible' value='"+ rowIndx + "'>"; //--> Agregamos el checkbox visible		
			}
			
			cubeChanged();//Marcamos como que el cubo se modifico estructuralmente
	}else{
		alert(MSG_MUST_SEL_MEAS_FIRST);
	}
}

function getWidgetDependency(){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.ProcessAction.do?action=getWidgetDeps"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "";
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
		     if(http_request.responseText != "NOK"){
		         return http_request.responseText;
		     }else{
				     alert("ERROR");
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
}

function getCubesDependency(){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.ProcessAction.do?action=getCubeDeps"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "";
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
		     if(http_request.responseText != "NOK"){
		         return http_request.responseText;
		     }else{
				     alert("ERROR");
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
}

function inAttIds(attIds, attId){
	if (attIds!=""){
		var posSep = attIds.indexOf(",");
		while (posSep>0){
			var actual = attIds.substring(0,posSep);
			if (actual == attId){
				return true;
			}else{
				attIds = attIds.substring(posSep+1, attIds.length);
			}
			posSep = attIds.indexOf(",");
		}
		if (attIds == attId){
			return true;
		}
	}
	return false;
}

function chkMeasName(obj){
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
			cubeChanged(); //Se deben regenerar las vistas
		}
	}else{
		obj.value = '';
		obj.focus();
		return false;
	}
}

//Verifica si la formula es correcta
// formatos posibles: Measure op Measure, Measure op NUMBER
function chkFormula(obj,measName){
	
	//1. Hallamos la medida 1, el operarador y la medida2 (o number)
	var formula = obj.value;
	if (formula == ""){
		alert(MSG_MUST_ENTER_FORMULA);
		return false;
	}
	var esp1 = formula.indexOf(" ");
	var formula2 = formula.substring(esp1+1, formula.length);
	var meas1 = formula.substring(0,esp1);
	var op = formula2.substring(0,1);
	var meas2 = formula2.substring(2, formula2.length);
	
	//2. Verificamos la medida1 exista
	if (!chkMeasExist(meas1)){
		if (esp1 < 0){
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
	
	//5. Verificamos no se utilice el nombre de la propia medida como un operando de la formula.
	if (measName == meas1 || measName == meas2){
		alert(measName + ": " + MSG_MEAS_NAME_LOOP_INVALID);
		obj.focus();
		return false;
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

function chkDimName(obj){
	var name = obj.value;
	var cant = 0;
	if (isValidDimensionName(name)){
		if (document.getElementById("gridDims").selectedItems.length >= 0){
			trows=document.getElementById("gridDims").rows;
			for (i=0;i<trows.length;i++) {
				if (trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value == name) {
					if (cant==1){
						alert(MSG_ALR_EXI_DIM);		
						trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value = '';
						trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].focus();
						return false;
					}else{
						cant++;
					}
				}
			}
			cubeChanged(); //Se deben regenerar las vistas
		}
	}else{
		obj.value = '';
		obj.focus();
		return false;
	}
}

//btn: Eliminar Medida --> Elimina una medida
function btnDelMeasure_click() {
	if (document.getElementById("gridMeasures").selectedItems.length > 0){
		document.getElementById("gridMeasures").removeSelected();
	}else{
		alert(MSG_MUST_SEL_MEAS_FIRST);
	}
}	

//Elimina el valor pasado por parametro del string pasado por parametro
//Formato del string: valores separados por ;
function remFromString(str, value, all){
	var newStr = "";
	var pos = str.indexOf(",");
	while (pos>0){
		var val = str.substring(0,pos);
		if (val!=value){
			if (newStr == ""){
				newStr=val;
			}else{
				newStr=newStr+","+val;
			}
		}
		if (val==value && all==false){
			str=str.substring(pos+1,str.length);
			newStr = newStr + "," + str;
			return (newStr);
		}
		str=str.substring(pos+1,str.length);
		pos = str.indexOf(",");
	}
	if (str!=value){
		if (newStr == ""){
			newStr=str;
		}else{
			newStr=newStr+","+str;
		}
	}
	return newStr;
}

//btn: Eliminar Dimension --> Elimina una dimension
function btnDelDimension_click() {
	if (document.getElementById("gridDims").selectedItems.length > 0){
		var trows=document.getElementById("gridDims").rows;
		var i=0;
		while (i<document.getElementById("gridDims").selectedItems.length){
			var selItem = document.getElementById("gridDims").selectedItems[i].rowIndex-1;
			updateLvlRowIndex(selItem);
			var attId = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
			document.getElementById("txtHidAttIds").value = remFromString(document.getElementById("txtHidAttIds").value, attId,true);
			document.getElementById("txtHidEntAttIds").value = remFromString(document.getElementById("txtHidEntAttIds").value, attId,true);
			document.getElementById("txtHidProAttIds").value = remFromString(document.getElementById("txtHidProAttIds").value, attId,true);
			i++;
		}
		document.getElementById("gridDims").removeSelected();
	}else{
		alert(MSG_MUST_SEL_DIM_FIRST);
	}
}

//Actualiza el value de todas las dimensiones de tipo fecha posteriores a la row pasada por parametro
function updateLvlRowIndex(rowIni){
	var trows=document.getElementById("gridDims").rows;
	for (var i=rowIni+1;i<trows.length;i++){
		if (trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[3].value == "D"){
			var newRowId = trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[1].value - 1;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[1].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[2].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[3].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[4].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[5].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[6].value = newRowId;															
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[7].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[8].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[9].value = newRowId;
		}
	}
}

//Funcion llamada cuando se cambia el atributo de la grilla de medidas (se cambia el nombre del atributo del input hidAttMeasName)
// y segun el tipo del atributo se filtran los tipos de agregador a mostrar
function changeMeasAtt(object){

//1. Cambiamos el valor del input hidAttMeasName
	var type = object.options[object.selectedIndex].getAttribute("attType");
	var father = object.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	var inputName = cells[1].getElementsByTagName("INPUT")[1]; //input oculto que contiene el name
	var inputType=cells[1].getElementsByTagName("INPUT")[0]; //input oculto que contiene el type
	
	inputName.value=object.options[object.selectedIndex].text;//nombre del atributo
	inputType.value=type;
	
//2. Filtramos los agregadores según el tipo de atributo
	 //Si es numerico --> SUM, AVG, COUNT, MIN , MAX, DIST COUNT
	 //Si es string   --> COUNT, DIST COUNT
	 //Si es date     --> COUNT, DIST COUNT (MIN Y MAX? probar)
	
	var selAgregator=cells[4].getElementsByTagName("SELECT")[0];
	while(selAgregator.options.length>0){
		selAgregator.removeChild(selAgregator.options[0]);
	}
	if ("S" == type){ //Atributo de tipo String
	 	var opt1=document.createElement("OPTION");
	 	opt1.innerHTML="COUNT";
	 	opt1.value="2";
	 	var opt2=document.createElement("OPTION");
	 	opt2.innerHTML="DIST. COUNT";
	 	opt2.value="5";
	 	selAgregator.appendChild(opt1);
	 	selAgregator.appendChild(opt2);
	 }else if ("D" == type){//Atributo de tipo Date
	 	var opt1=document.createElement("OPTION");
	 	opt1.innerHTML="COUNT";
	 	opt1.value="2";
	 	var opt2=document.createElement("OPTION");
	 	opt2.innerHTML="DIST. COUNT";
	 	opt2.value="5";
	 	selAgregator.appendChild(opt1);
	 	selAgregator.appendChild(opt2);
	 }else { //Atributo de tipo Numerico
	    var opt0=document.createElement("OPTION");
	 	opt0.innerHTML="SUM";
	 	opt0.value="0";
	 	
	    var opt1=document.createElement("OPTION");
	 	opt1.innerHTML="AVG";
	 	opt1.value="1";
	 	
	 	var opt2=document.createElement("OPTION");
	 	opt2.innerHTML="COUNT";
	 	opt2.value="2";
	 	
	 	var opt3=document.createElement("OPTION");
	 	opt3.innerHTML="MIN";
	 	opt3.value="3";
	 	
	 	var opt4=document.createElement("OPTION");
	 	opt4.innerHTML="MAX";
	 	opt4.value="4";
	 	
	 	var opt5=document.createElement("OPTION");
	 	opt5.innerHTML="DIST. COUNT";
	 	opt5.value="5";
	 	
	 	selAgregator.appendChild(opt0);
	 	selAgregator.appendChild(opt1);
	 	selAgregator.appendChild(opt2);
	 	selAgregator.appendChild(opt3);
	 	selAgregator.appendChild(opt4);
	 	selAgregator.appendChild(opt5);
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
		cells[6].getElementsByTagName("INPUT")[0].style.display='none'; //ocultamos formula
		cells[1].getElementsByTagName("INPUT")[0].style.visibility='visible'; //mostramos column
		cells[4].getElementsByTagName("SELECT")[0].style.display='block'; //mostramos aggregator
		cells[5].getElementsByTagName("INPUT")[0].style.display='block'; //mostramos formato
		
	}else { //Calculated Member
		var cells=father.cells;
		cells[6].getElementsByTagName("INPUT")[0].style.display='block'; //mostramos formula
		cells[1].getElementsByTagName("INPUT")[0].style.visibility='hidden'; //mostramos column
		cells[4].getElementsByTagName("SELECT")[0].style.display='none'; //ocultamos aggregator
		cells[5].getElementsByTagName("INPUT")[0].style.display='none'; //ocultamos formato
	}
}

//Devuelve un string con el siguiente formato: "1-2-4-45-500" donde cada numero es un attId
function getAttIds(){
  	
	var	http_request = getXMLHttpRequest();
		
	http_request.open('POST', "administration.ProcessAction.do?action=sqlTest"+windowId, false);
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
	return str;
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



//verifica que sea un nombre valido
var reBIAlphanumeric = /^[a-zA-Z0-9_]*$/;
function isValidMeasureName(s){
	var x = reBIAlphanumeric.test(s);
	
	if(!x){
		alert(GNR_INVALID_NAME);
		return false;
	}
	return true;
}
function isValidDimensionName(s){
	var x = reBIAlphanumeric.test(s);
	
	if(!x){
		alert(GNR_INVALID_NAME);
		return false;
	}
	return true;
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

function borrarAllMeasures(){
	trows=document.getElementById("gridMeasures").rows;
	var i = 0;
	while (i<trows.length) {
		document.getElementById("gridMeasures").deleteElement(trows[i]);
	}
}

function borrarAllDimensions(){
	trows=document.getElementById("gridDims").rows;
	var i = 0;
	while (i<trows.length) {
		document.getElementById("gridDims").deleteElement(trows[i]);
	}
}

function borrarAllProfiles(){
	trows=document.getElementById("gridProfiles").rows;
	var i = 0;
	while (i<trows.length) {
		document.getElementById("gridProfiles").deleteElement(trows[i]);
	}
}

function borrarAllNoAccProfiles(){
	trows=document.getElementById("gridNoAccProfiles").rows;
	var i = 0;
	while (i<trows.length) {
		document.getElementById("gridNoAccProfiles").deleteElement(trows[i]);
	}
}

function notInUseDimAtt(attId){
	var selected = document.getElementById("gridDims").selectedItems[0].rowIndex - 1;
	var notIn=true;
	var rows=document.getElementById("gridDims").rows;
	for(var i=0;i<rows.length;i++){
		var actId=rows[i].cells[1].getElementsByTagName("INPUT")[1].value;
		if(actId == attId && i!=selected){
			alert(MSG_ATT_IN_USE);
			return false;
		}
	}
	return notIn;
}

//Devuelve 1 si el atributo es utilizado en una dimension
//Devuelve 2 si el atributo es utilizado en una medida
//Devuelve 0 si el atributo no es utilizado en una dimension ni medida
function notInUseInCube(attId){

	if (document.getElementById("gridDims") != null && document.getElementById("gridMeasures")){
		var dimRows=document.getElementById("gridDims").rows;
		for(var i=0;i<dimRows.length;i++){
			var actAttId=dimRows[i].cells[1].getElementsByTagName("INPUT")[1].value;
			if(actAttId == attId){
				return 1;
			}
		}
		var dimMeas=document.getElementById("gridMeasures").rows;
		for(var i=0;i<dimMeas.length;i++){
			var actAttId=dimMeas[i].cells[1].getElementsByTagName("INPUT")[1].value;
			if(actAttId == attId){
				return 2;
			}
		}
	}
	return 0;
}

//Devuelve 1 si el formulario contiene un atributo utilizado en una dimension
//Devuelve 2 si el formulario contiene un atributo utilizado en una medida
//Devuelve 0 si el formulario no contiene ningun atributo utilizado en una dimension ni medida
function attsFrmInUseInCube(frmId){
	var attributes = getFrmAttributes(frmId);	//attributes = attId1,attId2,..,attIdN
	
	if (attributes!=""){
		var pos = attributes.indexOf(",");
		if (pos > 0){
			while (pos>0){
				var attId = attributes.substring(0,pos);
				var ret = notInUseInCube(attId);
				if (ret==0){
					attributes = attributes.substring(pos, attributes.length);
					pos = attributes.indexOf(",");
				}else{
					return ret;
				}
			}
		}else{
			var ret = notInUseInCube(attributes);
			if (ret!=0){
				return ret;
			}
		}
	}
	return 0;
}

//Limpia todos los atributos del bean (pues se agrego o quito uno)
function clearAttributes(){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.ProcessAction.do?action=clearAtts"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "";
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
		     if(http_request.responseText != "NOK"){
		         return http_request.responseText;
		     }else{
				     alert("ERROR");
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
}

//Devuelve los attributos de un formulario con el siguiente formato:<option value='3033' attType='S'>CLI_NOMBRE</option><option value='3034' attType='N'>CLI_COMPRAS</option><option value='3035' attType='D'>CLI_FECHACOMPRA</option>
function getFrmAttributes(frmId){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.ProcessAction.do?action=getAtts"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "frmId=" + frmId;
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
		     if(http_request.responseText != "NOK"){
		         return http_request.responseText;
		     }else{
				 alert("ERROR");
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
}

function openEntModal(obj) {
	var rets = null;
	rets = openModal("/programs/modals/entities.jsp?envId="+envId,500,400);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	var doLoad=function(rets){
		if (rets != null) {
			var ret = rets[0];
			td.getElementsByTagName("INPUT")[1].value = ret[0];
			td.getElementsByTagName("INPUT")[2].value = ret[1];
			cells[1].getElementsByTagName("INPUT")[3].value="S";
			cells[2].innerHTML = "STRING";
			
			cubeChanged();//Marcamos como que el cubo se modifico estructuralmente
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function openPropModal(obj) {
	
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var rets = null;
	var inptAllMemName = cells[3].getElementsByTagName("input")[0];
	var allMembName = LBL_TOD;
	if (inptAllMemName.value != ""){
		allMembName = inptAllMemName.value;
	}
	
	var props = allMembName;
	//Si hay mas props las separamos por ;
	rets = openModal("/programs/modals/dimProps.jsp?props="+props,500,400);
	
	var doLoad=function(rets){
		if (rets != null) {
			document.getElementById("hidCbeChanged").value = "true"; //Indicamos que se modifico algo del cubo
			
			var prpsArr = rets.split(";");
			inptAllMemName.value = prpsArr[0]; //Nombre de la agrupación
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function btnRemMapEnt_click(obj){
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	td.getElementsByTagName("INPUT")[1].value = "";
	td.getElementsByTagName("INPUT")[2].value = "";
	
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	/*
	var cells = father.cells;
	cells[2].innerHTML = td.getElementsByTagName("INPUT")[2].value;
	if (td.getElementsByTagName("INPUT")[2].value == "NUMERIC"){
		cells[1].getElementsByTagName("INPUT")[2].value="N";
	}else if (td.getElementsByTagName("INPUT")[2].value == "STRING"){
		cells[1].getElementsByTagName("INPUT")[2].value="S";	
	}else{
		cells[1].getElementsByTagName("INPUT")[2].value="D";	
	}*/
	cubeChanged();//Marcamos como que el cubo se modifico estructuralmente
}

function changeRadFact(val){
	if (val == 1){
		document.getElementById("radSelected").value = 1;
		document.getElementById("txtFchIni").disabled=true;
		document.getElementById("txtHorIni").disabled=true;
		document.getElementById("txtFchIni").p_required=false;
		document.getElementById("txtHorIni").p_required=false;
		document.getElementById("btnEstTime").disabled=false;
	}else if (val == 2){
		document.getElementById("radSelected").value = 2;
		document.getElementById("txtFchIni").disabled=false;
		document.getElementById("txtHorIni").disabled=false;
		document.getElementById("txtFchIni").p_required=true;
		document.getElementById("txtHorIni").p_required=true;
		document.getElementById("btnEstTime").disabled=true;
	}
}

function btnEstTime_click(){
	if (verifyCubeDataToEstimateTime()){
		var	http_request = getXMLHttpRequest();
		http_request.open('POST', "administration.ProcessAction.do?action=estimateTime"+windowId, false);
		http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
		var str = getAttIdsSelected();
		if (str == ""){
			alert("Must complete cube first");
		}else{ 
			http_request.send(str);
			    
			if (http_request.readyState == 4) {
				if (http_request.status == 200) {
				     if(http_request.responseText != "NOK"){
				         return alert(http_request.responseText);
				     }else{
						    alert("ERROR");
			         }
		    	} else {
		        	 alert("Could not contact the server.");            
		        }
			}
		}
	}
}

function verifyCubeDataToEstimateTime(){
	//Verificamos si ingreso al menos dos dimensiones
		if (document.getElementById("gridDims").rows.length < 2){
			alert(MSG_MUST_ENT_ONE_DIMS);
			return false;
		}
		
		//Verificamos dimensiones
		var dimRows=document.getElementById("gridDims").rows;
		for(var i=0;i<dimRows.length;i++){
			var dimName=dimRows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
			var attName = dimRows[i].cells[1].getElementsByTagName("INPUT")[0];
			if(attName == ""){//Verificamos que los nombres de los atributos no sean nulos
				alert(MSG_MIS_DIM_ATT);
				return false;
			}
			if (dimName == ""){//Verificamos que los nombres de las dimensiones no sean nulos
				alert(MSG_WRG_DIM_NAME);
				return false;
			}
		}
				
		//Verificamos si ingreso al menos una medida
		if (document.getElementById("gridMeasures").rows.length < 1){
			alert(MSG_MUST_ENT_ONE_MEAS);
			return false;
		}
		
		//Verificamos medidas
		var meaRows=document.getElementById("gridMeasures").rows;
		for(var i=0;i<meaRows.length;i++){
			//Verificamos haya seleccionado atributos en las medidas estandard			
			var cmb=meaRows[i].cells[3].getElementsByTagName("SELECT")[0];
			var measType = (cmb.options[cmb.selectedIndex].value);
			if (measType == 0){//Si es medida calculada verificamos la formula
				var attName = meaRows[i].cells[1].getElementsByTagName("INPUT")[0];
				if(attName == ""){//Verificamos que los nombres de los atributos no sean nulos
					alert(MSG_MIS_MEA_ATT);
					return false;
				}
			}
		}
		return true;
}

function getAttIdsSelected(){
  	var str = "";
  	var mapAtts = 0;
  	if (document.getElementById("gridDims") != null && document.getElementById("gridMeasures")!=null){
		var dimRows=document.getElementById("gridDims").rows;
		for(var i=0;i<dimRows.length;i++){
			var attId = dimRows[i].cells[1].getElementsByTagName("INPUT")[1].value;
			if (str == ""){
	  			str = "attId=" + attId;
		  	}else if (str.indexOf(attId)<0){
		  		str = str + "&attId=" + attId;
	  		}
	  		if (dimRows[i].cells[1].getElementsByTagName("INPUT")[3].value != "D"){
		  		var map=dimRows[i].cells[3].getElementsByTagName("INPUT")[1].value;
		  		
		  	}else{
		  		var map=dimRows[i].cells[3].getElementsByTagName("INPUT")[10].value;
		  	}
	  		if (map != "" && map != "on"){
	  			mapAtts++;
		  	}
		}
		var dimMeas=document.getElementById("gridMeasures").rows;
		for(var i=0;i<dimMeas.length;i++){
			var attId=dimMeas[i].cells[1].getElementsByTagName("INPUT")[1].value;
			if (str == ""){
	  			str = "attId=" + attId;
		  	}else if (str.indexOf(attId)<0){
		  		str = str + "&attId=" + attId;
	  		}
		}
		str = str + "&mapAtts="+mapAtts;
	}
	return str;
}

//Marcamos que el cubo se modifico estructuralmente
function cubeChanged(){
	document.getElementById("hidCbeChanged").value = "true";
}

//// FUNCIONES UTILIZADAS EN LA GRILLA DE PERFILES CON ACCESO RESTRINGIDO EN MODO VISUALIZADOR /////

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
		frm.action="administration.ProcessAction.do?action=removeNoAccProfile"+windowId+"&prfName="+prfName;
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
	if (document.getElementById("txtCbeName")==""){
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
	frm.action="administration.ProcessAction.do?action=loadDims"+windowId+"&after=openNoAccDimsModal&prfName="+prfName;
	frm.target="gridCbePrfNoAcc";
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
		window.parent.parent.parent.frames[ifr.name].setXml(dims,prfName,cbeName,"processCube");
	}
}

//////////// FIN DE FUNCIONES DE PERFILES CON ACCIONES RESTRINGIDOS EN MODO VISUALIZADOR //////////////

