function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("sceName").value)){
			if (verifyOtherReqObjects() && verifyPermissions()){
				document.getElementById("frmMain").action = "administration.SimScenarioAction.do?action=confirm" + windowId;
				submitForm(document.getElementById("frmMain"));
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
			document.getElementById("frmMain").action = "administration.SimScenarioAction.do?action=backToList" + windowId;
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "administration.SimScenarioAction.do?action=backToList" + windowId;
		submitForm(document.getElementById("frmMain"));
	}
}

function upPro_click() {
	var grid=document.getElementById("gridProcesses");
	grid.moveSelectedUp();
}

function downPro_click() {
	var grid=document.getElementById("gridProcesses");
	grid.moveSelectedDown();
}

function upGru_click() {
	var grid=document.getElementById("gridPools");
	grid.moveSelectedUp();
}

function downGru_click() {
	var grid=document.getElementById("gridPools");
	grid.moveSelectedDown();
}

function fieldReqAlert(msg){
	alert(MSG_REQ.replace("<TOK1>", msg));
}

//Devuelve true si date1 es mayor que date2
function isGrater(date1, date2){
	var dt1  = parseInt(date1.substring(0,2),10); 
	var mon1 = parseInt(date1.substring(3,5),10); 
	var yr1  = parseInt(date1.substring(6,10),10); 
	var dt2  = parseInt(date2.substring(0,2),10); 
	var mon2 = parseInt(date2.substring(3,5),10); 
	var yr2  = parseInt(date2.substring(6,10),10); 
	var dateIni = new Date(yr1, mon1, dt1); 
	var dateFin = new Date(dt2, mon2, yr2); 

	if (yr1 > yr2){
		return true;
	}else if (yr1 == yr2 && mon1 > mon2){
		return true;
	}else if (yr1 == yr2 && mon1 == mon2 && dt1 > dt2){
		return true;
	}
	return false;
}

function verifyOtherReqObjects(){
	//Verificamos si selecciono un calendario
	if (document.getElementById("selCal").selectedIndex == 0){
		fieldReqAlert(LBL_CALENDAR);
		return false;
	}
	if (document.getElementById("endTypeSelected").value == SIMULATION_END_BY_TIME){
		if (document.getElementById("txtSceDatEnd").value == "__/__/____" || document.getElementById("txtSceDatEnd").value == ""){
			fieldReqAlert(LBL_SCE_END_DATE);
			return false;
		}
		if (document.getElementById("txtSceHorEnd").value == "__:__" || document.getElementById("txtSceHorEnd").value == ""){
			fieldReqAlert(LBL_SCE_END_DATE);
			return false;
		}
		
		if (isGrater(document.getElementById("txtSceFchIni").value, document.getElementById("txtSceDatEnd").value)){
			alert(MSG_WRNG_DATES);
			return false;
		}else if (document.getElementById("txtSceFchIni").value == document.getElementById("txtSceDatEnd").value){
			if (document.getElementById("txtSceHorIni").value >= document.getElementById("txtSceHorEnd").value){
				alert(MSG_WRNG_DATES);
				return false;
			}
		}
	}
	if (document.getElementById("useHistChk").checked){ //Si es clickeado usar histórico
		if (document.getElementById("lblSampFrecuency").value ==  ""){
			fieldReqAlert(LBL_SAMP_FREC);
			return false;
		}
		if (document.getElementById("txtHistFrecDatIni").value == "__/__/____" || document.getElementById("txtHistFrecDatIni").value == ""){
			fieldReqAlert(LBL_FCH_INI);
			return false;
		}
		if (document.getElementById("txtHistFrecHorIni").value == "__:__" || document.getElementById("txtHistFrecHorIni").value == ""){
			fieldReqAlert(LBL_FCH_INI);
			return false;
		}
		if (document.getElementById("txtHistFrecDatEnd").value == "__/__/____" || document.getElementById("txtHistFrecDatEnd").value == ""){
			fieldReqAlert(LBL_FCH_END);
			return false;
		}
		if (document.getElementById("txtHistFrecHorEnd").value == "__:__" || document.getElementById("txtHistFrecHorEnd").value == ""){
			fieldReqAlert(LBL_FCH_END);
			return false;
		}
		if (document.getElementById("txtHistFrecDatIni").value > document.getElementById("txtHistFrecDatEnd").value){
			alert(MSG_HIST_WRNG_DATES);
			return false;
		}else if (document.getElementById("txtHistFrecDatIni").value == document.getElementById("txtHistFrecDatEnd").value){
			if (document.getElementById("txtHistFrecHorIni").value >= document.getElementById("txtHistFrecHorEnd").value){
				alert(MSG_HIST_WRNG_DATES);
				return false;
			}
		}
	}
	//Verificamos si ingreso al menos un proceso
	if (!document.getElementById("gridProcesses").rows.length > 0){
		alert(MSG_SCE_MUS_HAV_ONE_PRO);
		return false;
	}
	if (document.getElementById("endTypeSelected").value == SIMULATION_END_BY_AMOUNT_PROCESS){
		//Verificamos si selecciono un proceso
		if (document.getElementById("selEndProcess").selectedIndex == 0){
			fieldReqAlert(LBL_PROCESS);
			return false;
		}
	}
	//Verificamos si se ingreso cant. de recursos, en todos los pooles que se selecciono fijo
	var trows=document.getElementById("gridPools").rows;
	for (i=0;i<trows.length;i++) {
		var td = trows[i].getElementsByTagName("TD")[2];
		var poolName = trows[i].getElementsByTagName("TD")[1].getAttribute("poolname");
		var type = td.getElementsByTagName("SELECT")[0].value;
		if (type>=0 && td.getElementsByTagName("INPUT")[0].value == ""){
			alert(MSG_CANT_RES_NEED.replace("<TOK1>", poolName));
			return false;
		}
	}
	//Verificamos que si no se selecciono Usar historico, en todos los pooles se haya seleccionado fijo o ilimitado
	if (!document.getElementById("useHistChk").checked){
		var trows=document.getElementById("gridPools").rows;
		for (i=0;i<trows.length;i++) {
			var td = trows[i].getElementsByTagName("TD")[2];
			var poolName = trows[i].getElementsByTagName("TD")[1].getAttribute("poolname");
			var typeFixed = (td.getElementsByTagName("SELECT")[0].value == CANT_RES_FIXED);
			var typeUnlim = (td.getElementsByTagName("SELECT")[0].value == CANT_RES_UNLIM);
			if (!typeFixed && !typeUnlim && td.getElementsByTagName("INPUT")[0].value == ""){
				alert(MSG_MUST_SEL_CANT_RES_FIXED.replace("<TOK1>", poolName));
				return false;
			}
		}
	}

	return true;
}

function btnAddProcess_click() {
	var rets = openModal("/administration.SimScenarioAction.do?action=openProModal&getAll=true"+windowId,500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				var proId = ret[0];
				
				//Agregamos el proceso a la collection de procesos del bean
				addProcessToBean(proId);
				
				//Obtenemos todos los subprocesos del proceso
				var subPro = getSubProcesses(proId);
				var i = 0;
				if (subPro != null){
					while (i < subPro.length){
						var h=0;
						var found=false;
						while (h < rets.length && !found){
							if (subPro[i][0] == rets[h][0]){
								found = true;
							}
							h++;
						}
						if (!found){
							rets[rets.length] = subPro[i];
						}
						i++;
					}
				}
				//Nos fijamos si ya no lo agregamos
				trows=document.getElementById("gridProcesses").rows;
				for (i=0;i<trows.length & addRet;i++) {
					var td = trows[i].getElementsByTagName("TD")[0];
					var inputPro = td.getElementsByTagName("INPUT")[1];
					var inputSubPro = td.getElementsByTagName("INPUT")[2];
					if (inputPro.value == ret[0]) { //Si ya existe
						addRet = false;
					}
				}
				
			if (addRet) { //si ya no lo agregamos
				var oTd0 = document.createElement("TD"); 
				var oTd1 = document.createElement("TD"); 
				var oTd2 = document.createElement("TD"); 
				var oTd3 = document.createElement("TD"); 				
			
					oTd0.innerHTML = "<input type='checkbox' name='chkProcSel'><input type='hidden' name='chkProc'><input type='hidden' name='chkProcFather'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0]; //proId
					
					//Agregamos el proceso a la collection de procesos del bean
					addProcessToBean(ret[0]);
					
					oTd0.getElementsByTagName("INPUT")[2].value = ret[3]; //father's_id
					oTd0.align="center";
					
					oTd1.innerHTML = ret[1];//pro_name
					
					var genDatDef = "";
					if (ret[3]!=""){
						genDatDef = GEN_DISABLED + ";;;";
					}else{
						genDatDef = GEN_ON_DEMAND + ";;;";
					}	
					
					oTd2.innerHTML += "<span style=\"vertical-align:bottom;\">";
					oTd2.innerHTML += " <img title=\""+LBL_CLI_DEF_GEN+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openGenModal("+ ret[0]+ ", this)\" style=\"cursor:pointer;cursor:hand\">";
					oTd2.innerHTML += " <input type=\"hidden\" id=\"hidGenData\" name=\"hidGenData\" value=\""+genDatDef+"\"></input>";
					oTd2.innerHTML += "</span>";
					
					oTd3.innerHTML += "<span style=\"vertical-align:bottom;\">";
					oTd3.innerHTML += " <img title=\""+LBL_CLI_PRO_MAP+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openProMap(this)\" style=\"cursor:pointer;cursor:hand\">";
					oTd3.innerHTML += " <input type=\"hidden\" id=\"hidMapData\" name=\"hidMapData\" value=\"\"></input>";
					oTd3.innerHTML += "</span>";
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					oTr.appendChild(oTd3);
					document.getElementById("gridProcesses").addRow(oTr);
				}
			}
		}
		loadScePools();
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
		reLoadComboProcess();
	}
}

function addProcessToBean(proId){
	var	http_request = getXMLHttpRequest();
	var str = "&proId="+proId;
	http_request.open('POST', "administration.SimScenarioAction.do?action=addProToBean"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	http_request.send(str);
}

function btnDelAll_click(){
	var trows=document.getElementById("gridProcesses").rows;
	if (trows.length>0 && confirm(MSG_DELETE_ALL)){
		//1- Borramos todos los procesos
		var i=0;
		while (i<trows.length){
			document.getElementById("gridProcesses").deleteElement(trows[i])
		}
	}
	//2- Borramos todos los grupos
	refreshPools();
	reLoadComboProcess();
}

//No se pueden borrar subprocesos
//Si se elimina un proceso, se deben eliminar todos los subprocesos (que no son usados por otro proceso que este en la grilla)
function btnDelProcess_click() {
	var cant = chksChecked(document.getElementById("gridProcesses"));
	if(cant == 0) {
		alert(GNR_CHK_AT_LEAST_ONE);
		return;
	}
	
	var grid = document.getElementById("gridProcesses");
	var proToDelete = "";
	if (confirm(MSG_DEL_ALL_SEL)){
		for(var i=0;i<grid.selectedItems.length;i++){
			var trSel = grid.selectedItems[i];
			var td = trSel.getElementsByTagName("TD")[0];
			var proName = trSel.getElementsByTagName("TD")[1].getAttribute("proName");
			var proId = td.getElementsByTagName("INPUT")[1].value;
			var fathersIds = td.getElementsByTagName("INPUT")[2].value;
			if (!inList(proToDelete, proId)){
				//Si el proceso que se quiere eliminar no es subproceso de nadie, o es subproceso pero su proceso padre no esta en la grilla
				if (fathersIds==""){
					grid.deleteElement(grid.selectedItems[i]);
					var subProcs = getAllSubProcsToDelete(proId);
					if (subProcs != ""){
						proToDelete = proToDelete + "," + subProcs;
					}
				}else{
					var fathers = getRealFathers(fathersIds);
					if (fathers==""){//No es subproceso de un proceso de la grilla 
						if (proToDelete == ""){
							proToDelete = proId;
						}else{
							proToDelete = proToDelete + "," + proId;
						}
						var subProcs = getAllSubProcsToDelete(proId);//Eliminamos todos los subprocesos del proId que no son subprocesos de otro proceso de la grilla
						if (subProcs != ""){
							proToDelete = proToDelete + "," + subProcs;
						}
					}else{//Es subproceso de un proceso de la grilla
						alert((MSG_CANT_DEL_SUBPROC.replace("<TOK1>",proName)).replace("<TOK2>", fathers));
					}
				}
			}
		}
	}
	if (proToDelete != ""){
		deleteAllProcess(proToDelete);
	}
	reLoadComboProcess();
	refreshPools()
}
		

//Devuelve true si obj se encuentra en list: "obj1,obj2,obj3,.."
function inList(list, obj){
	while (list.indexOf(",")>0){;
		if (obj == list.substring(0, list.indexOf(","))){
			return true;
		}
		list = list.substring(list.indexOf(",") + 1, list.length);
	}
	if (obj == list){
		return true;
	}
	return false;
}

//Elimina todos los procesos pasados por parametro
function deleteAllProcess(proIds){
	while (proIds.indexOf(",")>0){;
		var proId = proIds.substring(0, proIds.indexOf(","));
		proIds = proIds.substring(proIds.indexOf(",")+1, proIds.length);
		deleteProcess(proId);
	}
	deleteProcess(proIds);
}

//Elimina el proceso pasado por parametro
function deleteProcess(proIdDel){
	trows=document.getElementById("gridProcesses").rows;
	var found = false;
	var i=0;
	while (!found && i<trows.length){
		var td = trows[i].getElementsByTagName("TD")[0];
		var proId = td.getElementsByTagName("INPUT")[1].value;
		if (proId == proIdDel){
			document.getElementById("gridProcesses").deleteElement(trows[i]);
			found = true;
		}
		i++;
	}
}

//Elimina todos los procesos de la grilla que tienen como padre a proId y a ningun otro proceso de la grilla
function getAllSubProcsToDelete(proIdDel){
	var proIds= "";
	trows=document.getElementById("gridProcesses").rows;
	for (var k=0;k<trows.length;k++) {
		var td = trows[k].getElementsByTagName("TD")[0];
		var proId = td.getElementsByTagName("INPUT")[1].value;
		var fathersIds = td.getElementsByTagName("INPUT")[2].value;
		if (proId != proIdDel && canDeleteProcess(fathersIds, proIdDel)){
			if (proIds == ""){
				proIds = proId;
			}else{
				proIds = proIds + "," + proId;
			}
		}
	}
	return proIds;
}

//Verifica si debemos y podemos eliminar el proceso que contiene los fathersIds pasados por parametro
//Debemos si los fathersIds tienen el proIdDel
//Podemos si los fathersIds no tienen otro fatherId existente en la grilla
function canDeleteProcess(fathersIds, proIdDel){
	var fathersIdsAux = fathersIds;
	var debemos = false;
	var podemos = false;
	while (!debemos && fathersIds.indexOf(",")>0){
		var fatherId = fathersIds.substring(0, fathersIds.indexOf(","));
		if (fatherId == proIdDel){
			debemos = true;
		}
		fathersIds = fathersIds.substring(fathersIds.indexOf(",")+1, fathersIds.length);
	}
	if (!debemos){
		if (fathersIds == proIdDel){
			debemos = true;
		}
	}
	if (debemos){
		podemos = !isSubProcess(fathersIdsAux, proIdDel);
	}
	return (debemos && podemos);
}

//Verifica si los proIds son subprocesos de algun proceso distinto del proIdDel
function isSubProcess(proIds, proIdDel){
	while (proIds.indexOf(",")>0){;
		var proId = proIds.substring(0, proIds.indexOf(","));
		proIds = proIds.substring(proIds.indexOf(",")+1, proIds.length);
		if (proId != proIdDel && existOnGrid(proId)){
			return true;
		}
	}
	if (proIds != proIdDel && existOnGrid(proIds)){
		return true;
	}
	return false;
}

//Verifica si existe en la grilla el proceso proId
function existOnGrid(proId){
	trows=document.getElementById("gridProcesses").rows;
	for (i=0;i<trows.length;i++) {
		var td = trows[i].getElementsByTagName("TD")[0];
		if (proId == td.getElementsByTagName("INPUT")[1].value){
			return true;
		}
	}
	return false;
}
//Devuelve nombre de los procesos padres que se encuentran en la grilla
function getRealFathers(fathersIds){
	var fathers = "";
	var found = false;
	if (fathersIds==""){ //Si no es un subproceso de nadie
		return "";
	}
	//Verificamos si es subproceso de algun proceso existente en la grilla
	trows=document.getElementById("gridProcesses").rows;
	while (fathersIds.indexOf(",")>0){
		var fathId = fathersIds.substring(0, fathersIds.indexOf(","));
		found = false;
		for (i=0;(!found && i<trows.length);i++) {
			var td = trows[i].getElementsByTagName("TD")[0];
			var proId = td.getElementsByTagName("INPUT")[1].value;
			if (proId == fathId){
				found = true;
				if (fathers == ""){
					fathers = getProName(fathId);
				}else{
					fathers = fathers + ", " + getProName(fathId);
				}
			}
		}
		fathersIds = fathersIds.substring(fathersIds.indexOf(",")+1,fathersIds.length);
	}
	found = false;
	for (i=0;(!found && i<trows.length);i++) {
		var td = trows[i].getElementsByTagName("TD")[0];
		var proId = td.getElementsByTagName("INPUT")[1].value;
		if (proId == fathersIds){
			found = true;
			if (fathers == ""){
				fathers = getProName(fathersIds);
			}else{
				fathers = fathers + ", " + getProName(fathersIds);
			}
		}
	}
	
	return fathers;
}

function getProName(proId){
	trows=document.getElementById("gridProcesses").rows;
	for (i=0;i<trows.length;i++) {
		var td = trows[i].getElementsByTagName("TD")[0];
		if (proId == td.getElementsByTagName("INPUT")[1].value){
			return proName=trows[i].getElementsByTagName("TD")[1].getAttribute("proName");
		}
	}
	return "<?>";
}
/*
function deleteProPools(proIdDel){
	var trows=document.getElementById("gridPools").rows;
	var i=0;
	while (i<trows.length){
		var td = trows[i].getElementsByTagName("TD")[0];
		var poolId = td.getElementsByTagName("INPUT")[1].value;
		var proList = td.getElementsByTagName("INPUT")[2].value;
		if (proList == proIdDel){ //si la lista es solo el proceso pasado por pararmetro
			deletePool(poolId); //Eliminamos el pool pq fue agregados solo por el proceso proIdDel
		}else{ //No lo podemos eliminar pq fue agregado por otro proceso tambien
			td.getElementsByTagName("INPUT")[2].value = deleteProFromPoolsList(proList, proIdDel);
			i++;
		}
	}
}
*/
/*
function deleteProFromPoolsList(proList, proId){
	var found = false;
	var retList = "";
	var actProId;
	while (proList.indexOf(",")>0){
		actProId = proList.substring(0, proList.indexOf(","));
		if (proId != actProId){
			if (retList == ""){
				retList = actProId;
			}else{
				retList = retList + "," + actProId;
			}
		}
		proList = proList.substring(proList.indexOf(",")+1, proList.length);
	}
	actProId = proList;
	if (proId != actProId){
		if (retList == ""){
			retList = actProId;
		}else{
			retList = retList + "," + actProId;
		}
	}
	return retList;
}
*/
//Elimina el pool pasado por parametro
function deletePool(poolIdDel){
	trows=document.getElementById("gridPools").rows;
	var found = false;
	var i=0;
	while (!found && i<trows.length){
		var td = trows[i].getElementsByTagName("TD")[0];
		var poolId = td.getElementsByTagName("INPUT")[1].value;
		if (poolId == poolIdDel){
			document.getElementById("gridPools").deleteElement(trows[i]);
			found = true;
		}
		i++;
	}
}

function reLoadComboProcess(){
	var combo = document.getElementById("selEndProcess");
	
	var proRows= document.getElementById("gridProcesses").rows;
	var proSel = combo.value; //guardamos el que estaba seleccionado
	
	//Vaciamos el combo de procesos
	while(combo.options.length>0){
		combo.removeChild(combo.options[0]);
	}
	
	//Agregamos opción nula
	var oOptNull = document.createElement("OPTION");
	combo.appendChild(oOptNull);
	
	//Agregamos todos los procesos de la grilla de procesos
	for(var i=0;i<proRows.length;i++){
		var proId=proRows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
		var proName = proRows[i].getElementsByTagName("TD")[1].getAttribute("proName");
		if(!proName) proName = proRows[i].getElementsByTagName("TD")[1].innerHTML;
		
		var oOpt1 = document.createElement("OPTION");
		oOpt1.value = proId;
		oOpt1.innerHTML = proName;
		if (proId == proSel){
			oOpt1.selected = true;
		}
		combo.appendChild(oOpt1);
	}
}

function openProMap(obj){
	var tr = obj.parentNode;
	while(tr.tagName!="TR"){
		tr=tr.parentNode;
	}
	var rets = null;
	var td = tr.getElementsByTagName("TD")[0];
	var proId = td.getElementsByTagName("INPUT")[1].value;
	if (proId==1){
		alert("Can't assign probabilities to Default Process");
		return;
	}
	rets = openModal("/administration.SimScenarioAction.do?action=openProcessMap&proId="+proId+windowId,(getStageWidth()*.8),(getStageHeight()*.8));
	var doLoad=function(rets){
		if (rets != null) {
			if (rets!="NOK"){
				//Actualizamos el xml con las propiedades del mapa del proceso
				var	http_request = getXMLHttpRequest();
				var str = "&xmlSimulator="+rets+"&proId="+proId;
				http_request.open('POST', "administration.SimScenarioAction.do?action=updateSimulatorXML"+windowId, false);
				http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	
				http_request.send(str);
				//if (http_request.readyState == 4) {
			   	//   if (http_request.status == 200) {
			     //      if(http_request.responseText != "NOK"){
			      //        var result = http_request.responseText; 
			      //        alert("result:" + result);
			       //    }
			      // }
			  // }
			 }else{
			 	alert("El mapa del proceso seleccionado no es válido");
			 }
		}
	}
	if (rets!=null){
		rets.onclose=function(){
			doLoad(rets.returnValue);
		}
	}
}

function openGenModal(proId, obj) {
	var tr = obj.parentNode;
	while(tr.tagName!="TR"){
		tr=tr.parentNode;
	}
	var td = obj.parentNode;
	var rets = null;
	rets = openModal("/administration.SimScenarioAction.do?action=openGenModal&proId="+proId+windowId,600,240);
	var doLoad=function(rets){
		hideResultFrame();
	}
	if (rets!=null){
		rets.onclose=function(){
			doLoad(rets.returnValue);
		}
	}
}

function clickUseHist(){
	if (document.getElementById("useHistChk").checked){
		document.getElementById("lblSampFrecuency").disabled=false;
		document.getElementById("txtHistFrecDatIni").disabled=false;
		document.getElementById("txtHistFrecHorIni").disabled=false;
		document.getElementById("txtHistFrecDatEnd").disabled=false;
		document.getElementById("txtHistFrecHorEnd").disabled=false;							
	}else{
		document.getElementById("lblSampFrecuency").disabled=true;
		document.getElementById("lblSampFrecuency").value="";
		document.getElementById("txtHistFrecDatIni").disabled=true;
		document.getElementById("txtHistFrecDatIni").value="";
		document.getElementById("txtHistFrecHorIni").disabled=true;
		document.getElementById("txtHistFrecHorIni").value="";
		document.getElementById("txtHistFrecDatEnd").disabled=true;
		document.getElementById("txtHistFrecDatEnd").value="";
		document.getElementById("txtHistFrecHorEnd").disabled=true;
		document.getElementById("txtHistFrecHorEnd").value="";
	}
}

function changeEndType(val){
	if (val == SIMULATION_END_BY_TIME){
		document.getElementById("endTypeSelected").value = SIMULATION_END_BY_TIME;
		document.getElementById("txtSceDatEnd").disabled=false;
		setRequiredField(document.getElementById("txtSceDatEnd"));
		document.getElementById("txtSceHorEnd").disabled=false;
		setRequiredField(document.getElementById("txtSceHorEnd"));
		document.getElementById("sceEndDays").disabled=true;
		document.getElementById("sceEndDays").value = "";
		unsetRequiredField(document.getElementById("sceEndDays"));
		document.getElementById("sceEndTrans").disabled=true;
		document.getElementById("sceEndTrans").value = "";
		unsetRequiredField(document.getElementById("sceEndTrans"));
		document.getElementById("sceEndProTrans").disabled=true;
		document.getElementById("sceEndProTrans").value = "";
		unsetRequiredField(document.getElementById("sceEndProTrans"));
		document.getElementById("selEndProcess").disabled=true;
		document.getElementById("selEndProcess").selectedIndex=0;
		//unsetRequiredField(document.getElementById("selEndProcess"));
	}else if (val == SIMULATION_END_BY_DATE){
		document.getElementById("endTypeSelected").value = SIMULATION_END_BY_DATE;
		document.getElementById("txtSceDatEnd").value = "__/__/____";
		document.getElementById("txtSceDatEnd").disabled=true;
		unsetRequiredField(document.getElementById("txtSceDatEnd"));
		document.getElementById("txtSceHorEnd").disabled=true;
		document.getElementById("txtSceHorEnd").value = "__:__";
		unsetRequiredField(document.getElementById("txtSceHorEnd"));
		document.getElementById("txtSceDatEnd").value = "";
		document.getElementById("txtSceHorEnd").value = "";
		document.getElementById("sceEndDays").disabled=false;
		setRequiredField(document.getElementById("sceEndDays"));
		document.getElementById("sceEndTrans").disabled=true;
		unsetRequiredField(document.getElementById("sceEndTrans"));
		document.getElementById("sceEndTrans").value = "";
		document.getElementById("sceEndProTrans").disabled=true;
		document.getElementById("sceEndProTrans").value = "";
		unsetRequiredField(document.getElementById("sceEndProTrans"));
		document.getElementById("selEndProcess").disabled=true;
		document.getElementById("selEndProcess").selectedIndex=0;		
		//unsetRequiredField(document.getElementById("selEndProcess"));
	}else if (val == SIMULATION_END_BY_AMOUNT_GLOBAL){
		document.getElementById("endTypeSelected").value = SIMULATION_END_BY_AMOUNT_GLOBAL;
		document.getElementById("txtSceDatEnd").disabled=true;
		document.getElementById("txtSceDatEnd").value = "__/__/____";
		unsetRequiredField(document.getElementById("txtSceDatEnd"));
		document.getElementById("txtSceHorEnd").disabled=true;
		document.getElementById("txtSceHorEnd").value = "__:__";
		unsetRequiredField(document.getElementById("txtSceHorEnd"));
		document.getElementById("txtSceDatEnd").value = "";
		document.getElementById("txtSceHorEnd").value = "";
		document.getElementById("sceEndDays").disabled=true;
		document.getElementById("sceEndDays").value = "";
		unsetRequiredField(document.getElementById("sceEndDays"));
		document.getElementById("sceEndTrans").disabled=false;
		setRequiredField(document.getElementById("sceEndTrans"));
		document.getElementById("sceEndProTrans").disabled=true;
		document.getElementById("sceEndProTrans").value = "";
		unsetRequiredField(document.getElementById("sceEndProTrans"));
		document.getElementById("selEndProcess").disabled=true;
		document.getElementById("selEndProcess").selectedIndex=0;		
		//unsetRequiredField(document.getElementById("selEndProcess"));
	}else if (val == SIMULATION_END_BY_AMOUNT_PROCESS){
		document.getElementById("endTypeSelected").value = SIMULATION_END_BY_AMOUNT_PROCESS;
		document.getElementById("txtSceDatEnd").disabled=true;
		unsetRequiredField(document.getElementById("txtSceDatEnd"));
		document.getElementById("txtSceHorEnd").disabled=true;
		unsetRequiredField(document.getElementById("txtSceHorEnd"));
		document.getElementById("txtSceDatEnd").value = "";
		document.getElementById("txtSceHorEnd").value = "";
		document.getElementById("sceEndDays").disabled=true;
		document.getElementById("sceEndDays").value = "";
		unsetRequiredField(document.getElementById("sceEndDays"));
		document.getElementById("sceEndTrans").disabled=true;
		document.getElementById("sceEndTrans").value = "";
		unsetRequiredField(document.getElementById("sceEndTrans"));
		document.getElementById("sceEndProTrans").disabled=false;
		setRequiredField(document.getElementById("sceEndProTrans"));
		document.getElementById("selEndProcess").disabled=false;
		//setRequiredField(document.getElementById("selEndProcess"));
	}
}

function getSubProcesses(proId){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.SimScenarioAction.do?action=getSubprocess"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "&proId="+proId;
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
			 var resp = http_request.responseText; //formato:"proId, proName, fathId1, fathId2,..,fathIdN;proId, proName, fathId1,.."
		     if(resp != "NOK"){
		         if (resp != null && resp!="null" && resp!= ""){
					var arrResp = new Array();
					var i = 0;
					while (resp.indexOf(";")>0){
						var subPro = new Array();
						subPro[0] = resp.substring(0,resp.indexOf(",")); //proId
						resp = resp.substring(resp.indexOf(",")+1, resp.length);
						subPro[1] = resp.substring(0,resp.indexOf(",")); //proName
						resp = resp.substring(resp.indexOf(",")+1, resp.length);
						subPro[3] = resp.substring(0,resp.indexOf(";")); //proFathers (en posicion 3 pq en la 2 esta la version)
						arrResp[i] = subPro;
						resp = resp.substring(resp.indexOf(";")+1, resp.length);
						i++;
					}
					var subPro = new Array();
					subPro[0] = resp.substring(0,resp.indexOf(",")); //proId
					resp = resp.substring(resp.indexOf(",")+1, resp.length);
					subPro[1] = resp.substring(0,resp.indexOf(",")); //proName
					resp = resp.substring(resp.indexOf(",")+1, resp.length);
					subPro[3] = resp; //proFathers (en posicion 3 pq en la 2 esta la version)
					arrResp[i] = subPro;
					
					return arrResp;	
			     }else {
			     	return null;
			     }
		     }else{
				     alert("ERROR");
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
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

function btnViewCalendar() {
    calId = document.getElementById("selCal").value;
	if (calId != 0){
		openModal("/programs/modals/calendarView.jsp?calendarId="+calId,600,500);
	}
}

function deleteAllPools(){
	trows=document.getElementById("gridPools").rows;
	var i=0;
	while (i<trows.length){
		document.getElementById("gridPools").deleteElement(trows[i])
	}
}

//Esta funcion refresca los pools de la grilla y los pools y procesos de la memoria
function refreshPools(){
	//1- borramos todos los pools
	deleteAllPools();
	//2- armamos un string con todos los procesos que hay actualmente
	var trows=document.getElementById("gridProcesses").rows;
	var i=0;
	var str = "";
	while (i<trows.length){
		var td = trows[i].getElementsByTagName("TD")[0];
		var proId = td.getElementsByTagName("INPUT")[1].value;
		str = str + "&proId="+ proId;	
		i++;
	}
	
	//Si str es "" vamos igual al servidor para que los borre todos de memoria.
	//3- recuperamos todos los pools asociados a los procesos actuales
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.SimScenarioAction.do?action=refreshPools"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	http_request.send(str);
	
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
			 var resp = http_request.responseText; //resp: "poolId,poolName,resCant,queueType,proId1,..,proIdN;poolId,poolName,resCant,queueType,proId1,..,proIdN;..."
		     if(resp != "NOK"){
		         if (resp != null && resp!=""){
		         	 var ret1 = resp.split(";"); //ret1 = ["poolId,poolName,resCant,queueType,proId1,..,proIdN", "poolId,poolName,resCant,queueType,proId1,..,proIdN",..]
				     for (j = 0; j < ret1.length; j++) {
						var ret = ret1[j].split(","); //ret = [poolId,poolName,resCant,queueType,proId1,proId2..,proIdN]
						var poolId = ret[0];
						var poolName = ret[1];
						var resCant = ret[2];
						var queueType = ret[3];
						var proIds = ret[4];
						var r=3;
						while (r<ret.length){
							proIds = proIds + "," + ret[r];
							r++;
						}
						var addRet = true;
		     			//Nos fijamos si ya no lo agregamos
						trows=document.getElementById("gridPools").rows;
						for (i=0;i<trows.length & addRet;i++) {
							var td = trows[i].getElementsByTagName("TD")[0];
							var poolIdGrid = td.getElementsByTagName("INPUT")[1].value;
							if (poolIdGrid == poolId) { //Si ya existe
								addRet = false;
								td.getElementsByTagName("INPUT")[2].value = proIds; //reemplazamos por el ultimo
							}
						}
				
						if (addRet) { //si ya no lo agregamos
							var oTd0 = document.createElement("TD"); 
							var oTd1 = document.createElement("TD"); 
							var oTd2 = document.createElement("TD"); 
							var oTd3 = document.createElement("TD"); 				
						
							oTd0.innerHTML = "<input type='checkbox' name='chkPoolSel'><input type='hidden' name='chkPool'><input type='hidden' name='chkProcs'>";
							oTd0.getElementsByTagName("INPUT")[1].value = poolId;
							oTd0.getElementsByTagName("INPUT")[2].value = proIds;
							
							oTd1.innerHTML = poolName;
							oTd1.setAttribute("poolname",poolName);
							
							var oSelResType = "<select name='selCantResType' onChange='resTypeChanged(this)'>";
							if (""==resCant || parseInt(resCant)>=0){
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_FIXED + "\" selected>" + LBL_FIXED + "</option>";
							}else{
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_FIXED + "\">" + LBL_FIXED + "</option>";
							}
							if (resCant == CANT_RES_UNLIM){
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_UNLIM + "\" selected>" + LBL_UNLIM + "</option>";
							}else{
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_UNLIM + "\" >" + LBL_UNLIM + "</option>";
							}
							if (resCant == CANT_RES_MIN){
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_MIN + "\" selected>" + LBL_MIN + "</option>";
							}else{
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_MIN + "\" >" + LBL_MIN + "</option>";
							}
							if (resCant == CANT_RES_MAX){
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_MAX + "\" selected>" + LBL_MAX + "</option>";
							}else{
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_MAX + "\">" + LBL_MAX + "</option>";
							}
							if (resCant == CANT_RES_AVG){
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_AVG + "\" selected>" + LBL_AVG + "</option>";											  											
							}else{
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_AVG + "\" >" + LBL_AVG + "</option>";
							}
							oSelResType = oSelResType + "</select>";
							oTd2.innerHTML = oSelResType;
							if (parseInt(resCant)>=0){
								oTd2.innerHTML += " <input type=\"text\" id=\"txtCantRes\" p_numeric=\"true\" onChange=\"txtCantResChanged(this)\" name=\"txtCantRes\" value=\"" + resCant + "\"></input>";
								oTd2.innerHTML += " <input type=\"hidden\" id=\"hidTxtCantRes\" name=\"hidTxtCantRes\" value=\"" + resCant + "\"></input>";
							}else{
								oTd2.innerHTML += " <input type=\"text\" id=\"txtCantRes\" p_numeric=\"true\" onChange=\"txtCantResChanged(this)\" name=\"txtCantRes\" value=\"\" disabled></input>";
								oTd2.innerHTML += " <input type=\"hidden\" id=\"hidTxtCantRes\" name=\"hidTxtCantRes\" value=\"\"></input>";
							}
							
							var oSelQueue = "<select name='selQueueType'>";
							if (""==queueType || queueType == FIFO_VALUE){
								oSelQueue = oSelQueue + "<option value='" + FIFO_VALUE + "' selected>"+ LBL_FIFO + "</option>";
							}else{
								oSelQueue = oSelQueue + "<option value='" + FIFO_VALUE + "'>"+ LBL_FIFO + "</option>";
							}
							if (queueType == LIFO_VALUE){
								oSelQueue = oSelQueue + "<option value='" + LIFO_VALUE + "' selected>"+ LBL_LIFO + "</option>";
							}else{
								oSelQueue = oSelQueue + "<option value='" + LIFO_VALUE + "'>"+ LBL_LIFO + "</option>";
							}
							oSelQueue = oSelQueue + "</select>";
							oTd3.innerHTML = oSelQueue; //--> Agregamos el combo con lo tipos de medidas
							
							var oTr = document.createElement("TR");
							oTr.appendChild(oTd0);
							oTr.appendChild(oTd1);
							oTr.appendChild(oTd2);
							oTr.appendChild(oTd3);
							document.getElementById("gridPools").addRow(oTr);
						}
					}
					
					return null;	
			     }else {
			     	return null;
			     }
		     }else{
				     alert("ERROR");
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
}

function loadScePools(){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.SimScenarioAction.do?action=getScePools"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "";
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
			 var resp = http_request.responseText; //resp: "poolId,poolName,proId1,..,proIdN;poolId,poolName,proId1,..,proIdN;..."
		     if (resp!=""){
			     if(resp != "NOK"){
			         if (resp != null){
			         	 var ret1 = resp.split(";"); //ret1 = ["poolId,poolName", "poolId,poolName",..]
					     for (j = 0; j < ret1.length; j++) {
							var ret = ret1[j].split(","); //ret = [poolId,poolName,proId1,proId2..,proIdN]
							var poolId = ret[0];
							var poolName = ret[1];
							var proIds = ret[2];
							var r=3;
							while (r<ret.length){
								proIds = proIds + "," + ret[r];
								r++;
							}
							var addRet = true;
			     			//Nos fijamos si ya no lo agregamos
							trows=document.getElementById("gridPools").rows;
							for (i=0;i<trows.length & addRet;i++) {
								var td = trows[i].getElementsByTagName("TD")[0];
								var poolIdGrid = td.getElementsByTagName("INPUT")[1].value;
								if (poolIdGrid == poolId) { //Si ya existe
									addRet = false;
									td.getElementsByTagName("INPUT")[2].value = proIds; //reemplazamos por el ultimo
								}
							}
					
							if (addRet) { //si ya no lo agregamos
								var oTd0 = document.createElement("TD"); 
								var oTd1 = document.createElement("TD"); 
								var oTd2 = document.createElement("TD"); 
								var oTd3 = document.createElement("TD"); 				
							
								oTd0.innerHTML = "<input type='checkbox' name='chkPoolSel'><input type='hidden' name='chkPool'><input type='hidden' name='chkProcs'>";
								oTd0.getElementsByTagName("INPUT")[1].value = poolId;
								oTd0.getElementsByTagName("INPUT")[2].value = proIds;
								
								oTd1.innerHTML = poolName;
								oTd1.setAttribute("poolname",poolName);
								
								var oSelResType = "<select name='selCantResType' onChange='resTypeChanged(this)'>";
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_FIXED + "\" selected>" + LBL_FIXED + "</option>";
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_UNLIM + "\" >" + LBL_UNLIM + "</option>";
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_MIN + "\" >" + LBL_MIN + "</option>";
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_MAX + "\" >" + LBL_MAX + "</option>";
								oSelResType = oSelResType + "<option value=\"" + CANT_RES_AVG + "\" >" + LBL_AVG + "</option>";											  											
								oSelResType = oSelResType + "</select>";
								oTd2.innerHTML = oSelResType;
								oTd2.innerHTML += " <input type=\"text\" id=\"txtCantRes\" p_numeric=\"true\" onChange=\"txtCantResChanged(this)\" name=\"txtCantRes\" value=\"\"></input>";
								oTd2.innerHTML += " <input type=\"hidden\" id=\"hidTxtCantRes\" name=\"hidTxtCantRes\" value=\"\"></input>";
								
								var oSelQueue = "<select name='selQueueType'>";
								oSelQueue = oSelQueue + "<option value='" + FIFO_VALUE + "' selected>"+ LBL_FIFO + "</option>";
								oSelQueue = oSelQueue + "<option value='" + LIFO_VALUE + "'>"+ LBL_LIFO + "</option>";
								oSelQueue = oSelQueue + "</select>";
								oTd3.innerHTML = oSelQueue; //--> Agregamos el combo con lo tipos de medidas
								
								var oTr = document.createElement("TR");
								oTr.appendChild(oTd0);
								oTr.appendChild(oTd1);
								oTr.appendChild(oTd2);
								oTr.appendChild(oTd3);
								document.getElementById("gridPools").addRow(oTr);
							}
						}
						
						return null;	
				     }else {
				     	return null;
				     }
			     }else{
					     alert("ERROR");
		         }
		     }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
}

function btnSeeAll_click(){
	document.getElementById("gridProcesses").unselectAll();
}

function proSelected(){
	var grid = document.getElementById("gridProcesses");
	for(var i=0;i<grid.selectedItems.length;i++){
		var trSel = grid.selectedItems[i];
		var td = trSel.getElementsByTagName("TD")[0];
		//alert("Fathers:"+td.getElementsByTagName("INPUT")[2].value);
	}
}

function resTypeChanged(obj){
	var td = obj.parentNode;
	var select = td.getElementsByTagName("SELECT")[0];
	var type = select.options[select.selectedIndex].value;
	if (type < 0){
		td.getElementsByTagName("INPUT")[0].disabled = true;
		td.getElementsByTagName("INPUT")[0].value = "";
		td.getElementsByTagName("INPUT")[1].value = "";
	}else{
		td.getElementsByTagName("INPUT")[0].disabled = false;
	}
}

function txtCantResChanged(obj){
	var td = obj.parentNode;
	var input0 = td.getElementsByTagName("INPUT")[0];
	var input1 = td.getElementsByTagName("INPUT")[1];
	input1.value = input0.value;
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