function btnConf_click(){
	if (verifyRequiredObjects() && verifyPermissions()) {
		if(isValidName(document.getElementById("txtName").value)){
			document.getElementById("frmMain").action = "administration.MonitorBusinessAction.do?action=confirm";
			submitForm(document.getElementById("frmMain"));
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
			document.getElementById("frmMain").action = "administration.MonitorBusinessAction.do?action=backToList";
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "administration.MonitorBusinessAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnAddProject_click() {
	var rets = openModal("/programs/modals/projects.jsp?envId=" + ENV_ID,500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridSecElement").rows;
				for (i=0;i<trows.length & addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value == ret[0]
					  && trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == TYPE_PROJECT) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					var oTd2 = document.createElement("TD"); 
			
					oTd0.innerHTML = "<input type='hidden'><input type='hidden' name='eleType'><input type='hidden' name='eleName'><input type='hidden' name='eleId'>";
					oTd0.getElementsByTagName("INPUT")[1].value = TYPE_PROJECT;
					oTd0.getElementsByTagName("INPUT")[2].value = ret[1];
					oTd0.getElementsByTagName("INPUT")[3].value = ret[0];
					oTd0.align="center";

					oTd1.innerHTML = TYPE_PROJECT_DESC;
					oTd2.innerHTML = ret[1];
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					document.getElementById("gridSecElement").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}

}

function btnAddEntity_click() {
	var rets = openModal("/programs/modals/entities.jsp?envId=" + ENV_ID,500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridSecElement").rows;
				for (i=0;i<trows.length & addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value == ret[0]
					  && trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == TYPE_BUS_ENTITY) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					var oTd2 = document.createElement("TD"); 
			
					oTd0.innerHTML = "<input type='hidden'><input type='hidden' name='eleType' ><input type='hidden' name='eleName' ><input type='hidden' name='eleId' >";
					oTd0.getElementsByTagName("INPUT")[1].value = TYPE_BUS_ENTITY;
					oTd0.getElementsByTagName("INPUT")[2].value = ret[1];
					oTd0.getElementsByTagName("INPUT")[3].value = ret[0];
					oTd0.align="center";

					oTd1.innerHTML = TYPE_BUS_ENTITY_DESC;
					oTd2.innerHTML = ret[1];
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					document.getElementById("gridSecElement").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}

}

function btnAddProcess_click() {
	var rets = openModal("/programs/modals/processes.jsp?getAll=true",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridSecElement").rows;
				for (i=0;i<trows.length & addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value == ret[0]
					  && trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == TYPE_PROCESS) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					var oTd2 = document.createElement("TD"); 
			
					oTd0.innerHTML = "<input type='hidden'><input type='hidden' name='eleType' ><input type='hidden' name='eleName' ><input type='hidden' name='eleId' >";
					oTd0.getElementsByTagName("INPUT")[1].value = TYPE_PROCESS;
					oTd0.getElementsByTagName("INPUT")[2].value = ret[1];
					oTd0.getElementsByTagName("INPUT")[3].value = ret[0];
					oTd0.align="center";

					oTd1.innerHTML = TYPE_PROCESS_DESC;
					oTd2.innerHTML = ret[1];
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					document.getElementById("gridSecElement").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnDelElement_click() {
	document.getElementById("gridSecElement").removeSelected();
}

function btnAddEntInst_click() {
	var rets = openModal("/programs/modals/entities.jsp?envId=" + ENV_ID,500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridSecEntInst").rows;
				for (i=0;i<trows.length & addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
			
					oTd0.innerHTML = "<input type='hidden'><input type='hidden' name='busEntId'><input type='hidden' name='busEntName'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.getElementsByTagName("INPUT")[2].value = ret[1];
					oTd0.align="center";

					oTd1.innerHTML = ret[1];
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					document.getElementById("gridSecEntInst").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnDelEntInst_click() {
	document.getElementById("gridSecEntInst").removeSelected();
}

function btnAddProInst_click() {
	var rets = openModal("/programs/modals/processes.jsp?getAll=true",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("tblSecProInst").rows;
				for (i=0;i<trows.length & addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
			
					oTd0.innerHTML = "<input type='hidden'><input type='hidden' name='proId'><input type='hidden' name='proName'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.getElementsByTagName("INPUT")[2].value = ret[1];
					oTd0.align="center";

					oTd1.innerHTML = ret[1];
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					document.getElementById("tblSecProInst").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnDelProInst_click() {
	document.getElementById("tblSecProInst").removeSelected();
}

function btnAddViewEntity_click() {
	var rets = openModal("/programs/modals/entities.jsp?envId=" + ENV_ID,500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridSecView").rows;
				for (i=0;i<trows.length & addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value == ret[0]
					  && trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == TYPE_BUS_ENTITY) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					var oTd2 = document.createElement("TD"); 

					var oTd3 = document.createElement("TD"); 
					var oTd4 = document.createElement("TD"); 
					var oTd5 = document.createElement("TD"); 
					var oTd6 = document.createElement("TD"); 
					var oTd7 = document.createElement("TD"); 
					var oTd8 = document.createElement("TD"); 

					oTd0.innerHTML = "<input type='hidden'><input type='hidden' name='eleViewType' ><input type='hidden' name='eleViewName' ><input type='hidden' name='eleViewId' >";
					oTd0.getElementsByTagName("INPUT")[1].value = TYPE_BUS_ENTITY;
					oTd0.getElementsByTagName("INPUT")[2].value = ret[1];
					oTd0.getElementsByTagName("INPUT")[3].value = ret[0];
					oTd0.align="center";

					oTd1.innerHTML = TYPE_BUS_ENTITY_DESC;
					oTd2.innerHTML = ret[1];
					
					oTd3.innerHTML = "<input type='hidden' name='qryIdRelated' value=''><input type='hidden' name='qryNameRelated' value=''><input type='text' name='xxxqryNameProperties' readonly class='txtReadOnly' value=''><img src='" + URL_STYLE_PATH + "/images/btnQuery.gif' onclick='btnLoadQry_click(getParentCell(this), \"" + TYPE_MON_BUS_ELE_RELATED + "\")' style='cursor:hand'><img src='" + URL_STYLE_PATH + "/images/eraser.gif' onclick='btnRemQry_click(getParentCell(this))' title='" + btnRemAtt + "'>";
					oTd4.innerHTML = "<input type='hidden' name='qryIdProperties' value=''><input type='hidden' name='qryNameProperties' value=''><input type='text' name='xxxqryNameProperties' readonly class='txtReadOnly' value=''><img src='" + URL_STYLE_PATH + "/images/btnQuery.gif' onclick='btnLoadQry_click(getParentCell(this), \"" + TYPE_MON_BUS_ELE_PROPERTIES + "\")' style='cursor:hand'><img src='" + URL_STYLE_PATH + "/images/eraser.gif' onclick='btnRemQry_click(getParentCell(this))' title='" + btnRemAtt + "'>";
					oTd5.innerHTML = "<input type='hidden' name='qryIdInstnaces' value=''><input type='hidden' name='qryNameInstnaces' value=''><input type='text' name='xxxqryNameInstnaces' readonly class='txtReadOnly' value=''><img src='" + URL_STYLE_PATH + "/images/btnQuery.gif' onclick='btnLoadQry_click(getParentCell(this), \"" + TYPE_MON_BUS_ELE_INSTANCES + "\")' style='cursor:hand'><img src='" + URL_STYLE_PATH + "/images/eraser.gif' onclick='btnRemQry_click(getParentCell(this))' title='" + btnRemAtt + "'>";
					oTd6.innerHTML = "<input type='hidden' name='qryIdInstRelated' value=''><input type='hidden' name='qryNameInstRelated' value=''><input type='text' name='xxxqryNameInstRelated' readonly class='txtReadOnly' value=''><img src='" + URL_STYLE_PATH + "/images/btnQuery.gif' onclick='btnLoadQry_click(getParentCell(this), \"" + TYPE_MON_BUS_ELE_RELATED + "\")' style='cursor:hand'><img src='" + URL_STYLE_PATH + "/images/eraser.gif' onclick='btnRemQry_click(getParentCell(this))' title='" + btnRemAtt +"'>";
					oTd7.innerHTML = "<input type='hidden' name='qryIdInstProperties' value=''><input type='hidden' name='qryNameInstProperties' value=''><input type='text' name='xxxqryNameInstProperties' readonly class='txtReadOnly' value=''><img src='" + URL_STYLE_PATH + "/images/btnQuery.gif' onclick='btnLoadQry_click(getParentCell(this), \"" + TYPE_MON_BUS_ELE_PROPERTIES + "\")' style='cursor:hand'><img src='" + URL_STYLE_PATH + "/images/eraser.gif' onclick='btnRemQry_click(getParentCell(this))' title='" + btnRemAtt + "'>";
					oTd8.innerHTML = "<input type='hidden' name='qryIdDepProperties' value=''><input type='hidden' name='qryNameDepProperties' value=''><input type='text' name='xxxqryNameDepProperties' readonly class='txtReadOnly' value=''><img src='" + URL_STYLE_PATH + "/images/btnQuery.gif' onclick='btnLoadQry_click(getParentCell(this), \"" + TYPE_MON_BUS_ELE_DEP_PROPERTIES + "\")' style='cursor:hand'><img src='" + URL_STYLE_PATH + "/images/eraser.gif' onclick='btnRemQry_click(getParentCell(this))' title='" + btnRemAtt + "'>";

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
					document.getElementById("gridSecView").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnAddViewProcess_click() {
	var rets = openModal("/programs/modals/processes.jsp?getAll=true",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridSecView").rows;
				for (i=0;i<trows.length & addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value == ret[0]
					  && trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == TYPE_PROCESS) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					var oTd2 = document.createElement("TD"); 
			
					var oTd3 = document.createElement("TD"); 
					var oTd4 = document.createElement("TD"); 
					var oTd5 = document.createElement("TD"); 
					var oTd6 = document.createElement("TD"); 
					var oTd7 = document.createElement("TD"); 
					var oTd8 = document.createElement("TD"); 

					oTd0.innerHTML = "<input type='hidden'><input type='hidden' name='eleViewType' ><input type='hidden' name='eleViewName' ><input type='hidden' name='eleViewId' >";
					oTd0.getElementsByTagName("INPUT")[1].value = TYPE_PROCESS;
					oTd0.getElementsByTagName("INPUT")[2].value = ret[1];
					oTd0.getElementsByTagName("INPUT")[3].value = ret[0];
					oTd0.align="center";

					oTd1.innerHTML = TYPE_PROCESS_DESC;
					oTd2.innerHTML = ret[1];
					
					oTd3.innerHTML = "<input type='hidden' name='qryIdRelated' value=''><input type='hidden' name='qryNameRelated' value=''><input type='text' name='xxxqryNameProperties' readonly class='txtReadOnly' value=''><img src='" + URL_STYLE_PATH + "/images/btnQuery.gif' onclick='btnLoadQry_click(getParentCell(this), \"" + TYPE_MON_BUS_ELE_RELATED + "\")' style='cursor:hand'><img src='" + URL_STYLE_PATH + "/images/eraser.gif' onclick='btnRemQry_click(getParentCell(this))' title='" + btnRemAtt + "'>";
					oTd4.innerHTML = "<input type='hidden' name='qryIdProperties' value=''><input type='hidden' name='qryNameProperties' value=''><input type='text' name='xxxqryNameProperties' readonly class='txtReadOnly' value=''><img src='" + URL_STYLE_PATH + "/images/btnQuery.gif' onclick='btnLoadQry_click(getParentCell(this), \"" + TYPE_MON_BUS_ELE_PROPERTIES + "\")' style='cursor:hand'><img src='" + URL_STYLE_PATH + "/images/eraser.gif' onclick='btnRemQry_click(getParentCell(this))' title='" + btnRemAtt + "'>";
					oTd5.innerHTML = "<input type='hidden' name='qryIdInstnaces' value=''><input type='hidden' name='qryNameInstnaces' value=''><input type='text' name='xxxqryNameInstnaces' readonly class='txtReadOnly' value=''><img src='" + URL_STYLE_PATH + "/images/btnQuery.gif' onclick='btnLoadQry_click(getParentCell(this), \"" + TYPE_MON_BUS_ELE_INSTANCES + "\")' style='cursor:hand'><img src='" + URL_STYLE_PATH + "/images/eraser.gif' onclick='btnRemQry_click(getParentCell(this))' title='" + btnRemAtt + "'>";
					oTd6.innerHTML = "<input type='hidden' name='qryIdInstRelated' value=''><input type='hidden' name='qryNameInstRelated' value=''><input type='text' name='xxxqryNameInstRelated' readonly class='txtReadOnly' value=''><img src='" + URL_STYLE_PATH + "/images/btnQuery.gif' onclick='btnLoadQry_click(getParentCell(this), \"" + TYPE_MON_BUS_ELE_RELATED + "\")' style='cursor:hand'><img src='" + URL_STYLE_PATH + "/images/eraser.gif' onclick='btnRemQry_click(getParentCell(this))' title='" + btnRemAtt +"'>";
					oTd7.innerHTML = "<input type='hidden' name='qryIdInstProperties' value=''><input type='hidden' name='qryNameInstProperties' value=''><input type='text' name='xxxqryNameInstProperties' readonly class='txtReadOnly' value=''><img src='" + URL_STYLE_PATH + "/images/btnQuery.gif' onclick='btnLoadQry_click(getParentCell(this), \"" + TYPE_MON_BUS_ELE_PROPERTIES + "\")' style='cursor:hand'><img src='" + URL_STYLE_PATH + "/images/eraser.gif' onclick='btnRemQry_click(getParentCell(this))' title='" + btnRemAtt + "'>";
					oTd8.innerHTML = "<input type='hidden' name='qryIdDepProperties' value=''><input type='hidden' name='qryNameDepProperties' value=''><input type='text' name='xxxqryNameDepProperties' readonly class='txtReadOnly' value=''><img src='" + URL_STYLE_PATH + "/images/btnQuery.gif' onclick='btnLoadQry_click(getParentCell(this), \"" + TYPE_MON_BUS_ELE_DEP_PROPERTIES + "\")' style='cursor:hand'><img src='" + URL_STYLE_PATH + "/images/eraser.gif' onclick='btnRemQry_click(getParentCell(this))' title='" + btnRemAtt + "'>";

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
					document.getElementById("gridSecView").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnDelViewElement_click() {
	document.getElementById("gridSecView").removeSelected();
}

function btnRemQry_click(cell) {
	cell.getElementsByTagName("INPUT")[0].value = "";
	cell.getElementsByTagName("INPUT")[1].value = "";
	cell.getElementsByTagName("INPUT")[2].value = "";
}

function btnLoadQry_click(cell, type) {
	var rets = openModal("/programs/modals/querys.jsp?onlyOne=true&type=" + type,500,300);
	var doAfter=function(cell, rets){
		if (rets != null) {
			for (var j = 0; j < rets.length; j++) {
				var ret = rets[j];
				cell.getElementsByTagName("INPUT")[0].value = ret[0];
				cell.getElementsByTagName("INPUT")[1].value = ret[1];
				cell.getElementsByTagName("INPUT")[2].value = ret[1];
			}
		}
	}
	rets.onclose=function(){
		doAfter(cell, rets.returnValue);
	}
}

function btnAddFilter_click() {
	var oTd0 = document.createElement("TD"); 
	var oTd1 = document.createElement("TD"); 
	var oTd2 = document.createElement("TD"); 
	var oTd3 = document.createElement("TD"); 
	var oTd4 = document.createElement("TD"); 
	var oTd5 = document.createElement("TD"); 
	var oTd6 = document.createElement("TD"); 

	oTd0.innerHTML = "<input type='hidden'><input type='hidden' name='monBusFilId' >";
	oTd0.align="center";
	
	oTd1.style="min-width:120px";
	oTd2.style="min-width:120px";
	oTd3.style="min-width:120px";
	oTd4.style="min-width:90px";
	
	oTd1.innerHTML = "<input size='30' type='text' name='monBusFilName' p_required=true>";
	oTd2.innerHTML = "<input size='30' type='text' name='monBusFilTitle' p_required=true>";
	oTd3.innerHTML = "<select name='monBusFilType'>" + OPTIONS_TYPE + "</select>";
	oTd4.innerHTML = "<input type='text' name='monBusFilValue'>";
	oTd5.innerHTML = "<select name='monBusFilFlag0'>" + OPTIONS_YES_NO + "</select>";
	oTd6.innerHTML = "<select name='monBusFilFlag1'>" + OPTIONS_YES_NO + "</select>";
	
	var oTr = document.createElement("TR");
	oTr.appendChild(oTd0);
	oTr.appendChild(oTd1);
	oTr.appendChild(oTd2);
	oTr.appendChild(oTd3);
	oTr.appendChild(oTd4);
	oTr.appendChild(oTd5);
	oTr.appendChild(oTd6);
	document.getElementById("gridInitFiltersView").addRow(oTr);
}

function btnDelFilter_click() {
	document.getElementById("gridInitFiltersView").removeSelected();
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
	var sXMLSourceUrl = "administration.MonitorBusinessAction.do?action=getProjPermssions&prjId=" + prjId;
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