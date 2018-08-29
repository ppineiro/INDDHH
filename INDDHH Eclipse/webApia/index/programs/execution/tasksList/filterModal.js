function btnConf_click() {
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "execution.TasksListAction.do?action=setFilter&workMode=" + WORK_MODE;
		submitFormModal(document.getElementById("frmMain"));
		//window.returnValue= "OK";
		//window.close();
	}
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}

function btnAdd_onclick(){
	var jX=document.getElementById("gridList").rows.length;
	//alert(jX);
	if(jX==0 && document.getElementById("cmbOperator").value != "") {
		alert(CANT_USE_OP_LOG);
		return;
	}
	if(jX>0 && document.getElementById("cmbOperator").value == "") {
		alert(MISSING_OP_LOG);
		return;
	}

	if(document.getElementById("txtFilterValue").value=="" && !document.getElementById("txtFilterValue").disabled){
		alert(MISSING_VALUE);
		return;
	}
	
	if(!document.getElementById("txtFilterValue").value=="" && !document.getElementById("txtFilterValue").disabled){
		var col = document.getElementById("cmbColNames").options[document.getElementById("cmbColNames").selectedIndex].text;
		if ((col == COL_PROC_NUM) || (col == COL_ENT_NUM)){
			if (!document.getElementById("txtFilterValue").value.match(/^\d+$/)){
				//el valor no es númerico
				alert(NUMBER_EXPECTED);
				return;
			}
		}
	}

	var oTr;

	oTr=document.createElement("TR");
	var oTd0; 
	var oTd1; 
	var oTd2; 
	var oTd3;
	var oTd4; 
	if (window.navigator.appVersion.indexOf("MSIE")>0){
		for(var i=0;i<5;i++){
			oTr.appendChild(document.createElement("TD"));
		}
		var tds=oTr.getElementsByTagName("TD");
		oTd0 = tds[0]; 
		oTd1 = tds[1]; 
		oTd2 = tds[2]; 
		oTd3 = tds[3];
		oTd4 = tds[4]; 
	}else{
		oTd0 = oTr.insertCell(0); 
		oTd1 = oTr.insertCell(1); 
		oTd2 = oTr.insertCell(2); 
		oTd3 = oTr.insertCell(3); 
		oTd4 = oTr.insertCell(4); 
	}
	

	oTd0.innerHTML = "<input type='hidden'  name='chkSel'>";
	oTd0.style.display="none";
	oTd0.style.width="0px";
	if(document.getElementById("cmbOperator").options[document.getElementById("cmbOperator").selectedIndex].text!=""){
		exp=document.getElementById("cmbOperator").value + "'>" + document.getElementById("cmbOperator").options[document.getElementById("cmbOperator").selectedIndex].text;
	}else{
		exp=document.getElementById("cmbOperator").value + "'>\n";
	}
	oTd1.innerHTML = "<input type='hidden' name='hidOpLog'   value='" + exp; 
	oTd2.innerHTML = "<input type='hidden' name='hidColName' value='" + document.getElementById("cmbColNames").value + "'>" + document.getElementById("cmbColNames").options[document.getElementById("cmbColNames").selectedIndex].text; 
	oTd3.innerHTML = "<input type='hidden' name='hidRel'     value='" + numberToOperator(document.getElementById("cmbRel").value) + "'>" + numberToEscOperator(document.getElementById("cmbRel").value); 
	if(!document.getElementById("txtFilterValue").disabled){
		oTd4.innerHTML = "<input type='hidden' name='hidValue'   value='" + document.getElementById("txtFilterValue").value + "'>" + document.getElementById("txtFilterValue").value;
	}else if (!document.getElementById("cmbTaskFilterValue").disabled){
		oTd4.innerHTML = "<input type='hidden' name='hidValue'   value='" + document.getElementById("cmbTaskFilterValue").options[document.getElementById("cmbTaskFilterValue").selectedIndex].value + "'>" + "<input type='hidden' name='hidTaskTransValue'   value='" + document.getElementById("cmbTaskFilterValue").options[document.getElementById("cmbTaskFilterValue").selectedIndex].value + "\u00B7" + document.getElementById("cmbTaskFilterValue").options[document.getElementById("cmbTaskFilterValue").selectedIndex].text + "'>" + document.getElementById("cmbTaskFilterValue").options[document.getElementById("cmbTaskFilterValue").selectedIndex].text;
	}else{
		oTd4.innerHTML = "<input type='hidden' name='hidValue'   value='" + document.getElementById("cmbProcessFilterValue").options[document.getElementById("cmbProcessFilterValue").selectedIndex].value + "'>" + "<input type='hidden' name='hidProcTransValue'   value='" + document.getElementById("cmbProcessFilterValue").options[document.getElementById("cmbProcessFilterValue").selectedIndex].value + "\u00B7" + document.getElementById("cmbProcessFilterValue").options[document.getElementById("cmbProcessFilterValue").selectedIndex].text + "'>" + document.getElementById("cmbProcessFilterValue").options[document.getElementById("cmbProcessFilterValue").selectedIndex].text;
	}
	document.getElementById("gridList").addRow(oTr);
	
}

function btnDel_onclick(){
	
	for(var i=0;i<document.getElementById("gridList").selectedItems.length;i++){
		//alert(document.getElementById("gridList").selectedItems[i].rowIndex);
		if(document.getElementById("gridList").selectedItems[i].rowIndex==2) {
			//alert("Es el primero");
		}
		if ((document.getElementById("gridList").rows.length)>1){
			//alert("Hay mas de uno");
		}
		if (document.getElementById("gridList").selectedItems.length!=document.getElementById("gridList").rows.length){
			//alert("La cantidad de seleccionados es diferente de la cantidad de filtros que hay");
		}
		if(document.getElementById("gridList").selectedItems[i].rowIndex==1  //Si es el primero el que se quiere borrar
		 &&	(document.getElementById("gridList").rows.length)>1            //y hay mas de uno
		 && document.getElementById("gridList").selectedItems.length!=(document.getElementById("gridList").rows.length)){ //y la cantidad de
		 			//seleccionados es diferente de la cantidad de filtros que hay
			alert(CANT_USE_OP_LOG);
			return;
		}
	}
	var zz = document.getElementById("gridList").removeSelected();
}

function numberToOperator(numOp){
	if (numOp == 0)
		return "=";
	else if (numOp == 1)
		return "<";
	else if (numOp == 2)
		return "<=";
	else if (numOp == 3)
		return ">";
	else if (numOp == 4)
		return ">=";
	else if (numOp == 5)
		return "<>";
	
}
function numberToEscOperator(numOp){
	if (numOp == 0)
		return "=";
	else if (numOp == 1)
		return "&lt;";
	else if (numOp == 2)
		return "&lt;=";
	else if (numOp == 3)
		return "&gt;";
	else if (numOp == 4)
		return "&gt;=";
	else if (numOp == 5)
		return "&lt;&gt;";

}

function cmbColNames_OnChange(){
	if(document.getElementById("cmbColNames").options[document.getElementById("cmbColNames").selectedIndex].value==(TASK_TITLE)){
		document.getElementById("txtFilterValue").style.display="none";
		document.getElementById("txtFilterValue").disabled=true;
		document.getElementById("cmbTaskFilterValue").style.display="block";
		document.getElementById("cmbTaskFilterValue").disabled=false;
		document.getElementById("cmbProcessFilterValue").style.display="none";
		document.getElementById("cmbProcessFilterValue").disabled=true;
	}else if(document.getElementById("cmbColNames").options[document.getElementById("cmbColNames").selectedIndex].value==(PROCESS_TITLE)){
		document.getElementById("txtFilterValue").style.display="none";
		document.getElementById("txtFilterValue").disabled=true;
		document.getElementById("cmbTaskFilterValue").style.display="none";
		document.getElementById("cmbTaskFilterValue").disabled=true;
		document.getElementById("cmbProcessFilterValue").style.display="block";
		document.getElementById("cmbProcessFilterValue").disabled=false;
	}else{
		document.getElementById("txtFilterValue").style.display="block";
		document.getElementById("txtFilterValue").disabled=false;
		document.getElementById("cmbTaskFilterValue").style.display="none";
		document.getElementById("cmbTaskFilterValue").disabled=true;
		document.getElementById("cmbProcessFilterValue").style.display="none";
		document.getElementById("cmbProcessFilterValue").disabled=true;
	}
}