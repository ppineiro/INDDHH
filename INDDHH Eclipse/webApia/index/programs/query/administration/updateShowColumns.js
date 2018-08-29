//--- Funciones para trabajar con las filas y poderlas cambiar de lugar
function upShowUsu_click() {
	var tblShows = document.getElementById("tblShows");
	upAColumn(tblShows,lastSelectionShowUsu);
	loadShowCols();
}

function downShowUsu_click() {
	var tblShows = document.getElementById("tblShows");
	downAColumn(tblShows,lastSelectionShowUsu);
	loadShowCols();
}

function selectColumnShowUsu() {
	lastSelectionShowUsu = selectAColumn(lastSelectionShowUsu);
}

//---
//--- Funciones de las columnas a ser mostradas
//---
function btnAddShowAtt_click() {
	//var rets = openModal("/programs/modals/dataDictionary.jsp",500,300);
	var rets = openModal("/query.AdministrationAction.do?action=addAttColumn" + windowId,500,300);
	
	if (rets != null) {
		for (j = 0; j < rets.length; j++) {
			var ret = rets[j];
			var addRet = true;
			
			trows=document.getElementById("gridShows").rows;
			for (i=0;i<trows.length && addRet;i++) {
				if (trows[i].childNodes[0].childNodes[2].value == ret[0]) {
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
		
		loadShowCols();
		checkActions();
	}
}

function btnAddShowBusClaPar_click() {
	var rets = openModal("/programs/modals/busClaParameter.jsp?busClaId=" + BUS_CLA_ID + "&notParType=" + PARAM_IO_IN,500,300);

	if (rets != null) {
		for (j = 0; j < rets.length; j++) {
			var ret = rets[j];
			var addRet = true;
			
			trows=document.getElementById("gridShows").rows;
			for (i=0;i<trows.length && addRet;i++) {
				if (trows[i].childNodes[0].childNodes[6].value == ret[0]) {
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
		loadShowCols();
		checkActions();
	}
}


function btnAddShow_click2() {
	//	var rets = openModal("/programs/modals/viewColumns.jsp?viewName=" + QRY_DB_VIEW_NAME,500,300);
	var rets = openModal("/query.AdministrationAction.do?action=addShowColumn&viewName=" + QRY_DB_VIEW_NAME + windowId,500,300);

	if (rets != null) {
		for (j = 0; j < rets.length; j++) {
			var ret = rets[j];
			var addRet = true;

			trows=document.getElementById("gridShows").getRows();
			for (i=0;i<trows.length && addRet;i++) {
				if (trows[i].childNodes[0].childNodes[4].value == ret[0]) {
					addRet = false;
				}
			}

			if (addRet) {
				if (! inNotAllowed(ret[0])) { 
					generateShow('',ret[0],ret[0],ret[1],QRY_DB_TYPE_COL,"");
				} else {
					showMessageOneParam(MSG_COL_NOT_ALLOW,ret[0]);
				}
			}
		}
		loadShowCols();
		checkActions();
	}
}

//Funcion equivalente en update.js
function btnDelShow_click_OLD() {
	var cant=0
	trows = document.getElementById("gridShows").rows;
	for (i = (trows.length - 1); i >= 0; i--) {
		if (trows[i].childNodes[0].childNodes.length > 0) {
			if (trows[i].childNodes[0].childNodes[0].checked) {
				if (trows[i].childNodes[0].childNodes[2].value != "") {
					attInsert --;
				}
				if (insideAtt(trows[i].childNodes[0].childNodes[2].value)) {
					removeAtt(trows[i].childNodes[0].childNodes[2].value);
				}

				if (lastSelectionShowUsu == trows[i]) {
					lastSelectionShowUsu = null;
				}

				trows[i].removeNode(true);
				cant++
			}
		}
	}
	if (cant > 0) {
		loadShowCols();
	}
	
	if (QRY_ALLOW_ATT) {
		if (attInsert == 0) {
			document.getElementById("chkAllAtt").disabled = false;
			if (document.getElementById("chkAllAtt").checked) {
				document.getElementById("selAllAttFrom").style.visibility = 'visible';
			}
		}
	}

	checkActions();

	return cant;
}

function chkAllAtt_click() {
	if (document.getElementById("chkAllAtt").checked) {
			document.getElementById("selAllAttFrom").style.visibility = 'visible';
	} else {
			document.getElementById("selAllAttFrom").style.visibility = 'hidden';
	}
}

function generateShowson(val0, val1, val2, val3,val4,val5) {
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

	var oTd0 = document.createElement("TD"); 
	var oTd1 = document.createElement("TD");
	var oTdh = document.createElement("TD"); 
	var oTd2 = document.createElement("TD");
	var oTd3 = document.createElement("TD");
	var oTd4 = document.createElement("TD");
	var oTd5 = document.createElement("TD");
	var oTd6 = document.createElement("TD");
	var oTd7 = document.createElement("TD");
	var oTd8 = document.createElement("TD");

	//checkbox
	oTd0.innerHTML = "<input type='checkbox' name='chkShowSel'><input type='hidden' name='hidShoColId' value=''><input type='hidden' name='hidShoAttId'><input type='hidden' name='hidShoDatType'><input type='hidden' name='hidShoColName' value=''><input type='hidden' name='hidShoDbType' value=''><input type=hidden name='hidShoParId' value=''>";
	oTd0.childNodes[2].value = val0;
	oTd0.childNodes[3].value = val3;
	oTd0.childNodes[4].value = val1;
	oTd0.childNodes[5].value = val4;
	oTd0.childNodes[6].value = val5;
	oTd0.align="center";
	
	//nombre de la columna
	oTd1.innerText = val1;
	oTdh.innerText = val1;
	oTdh.style.display = "none";
	
	//header de la columna
	oTd2.innerHTML = "<input p_required='true' name='txtShoHeadName' maxlength='50' type='text'>";
	oTd2.childNodes[0].value = val2;
	oTd2.align="center";
	
	//orden
	oTd3.innerHTML = "<select name='cmbShoSort'><option value='' selected></option><option value='" + COLUMN_ORDER_ASC + "'>" + lblQryColOrdAsc + "</option><option value='" + COLUMN_ORDER_DESC + "'>" + lblQryColOrdDesc + "</option></select>";
	if (QRY_TO_PROCEDURE || ! QRY_TO_VIEW) {
		oTd3.style.display = "none";
	} else if (val0 != null && val0 != "") {
		oTd3.childNodes[0].style.display = "none";
	}
	oTd3.align="center";
	
	//ancho de la columna
	oTd4.innerHTML = "<input p_required='true' p_numeric='true' name='txtShowHeadWidth' maxlength='50' type='text' value='100' size='6'>"
	oTd4.align="center";
	
	//ocultar columna
	oTd5.innerHTML = "<input type=\"hidden\" name=\"cmbShoHid\" value=\"false\"><input type=\"checkbox\" onclick=\"showChecked(this);\">";
//	oTd5.innerHTML ="<select name=\"cmbShoHid\"><option value=\"1\">" + lblYes + "</option><option value=\"0\" selected>" + lblNo + "</option></select>";
	oTd5.align = "center";
	if (! showHiddenTd) {
		oTd5.style.display = "none";
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

	oTd6.innerHTML = strCmbAttFrom;
	oTd6.align = "center";

	if (! (addEntAttOpt && addProAttOpt)) {
		oTd6.style.display = "none";
	}
	
	oTd7.innerHTML = "<input name='txtShoTool' maxlength='255' type='text'>";
	oTd7.align="center";
	
	oTd8.innerHTML = "<input type=\"hidden\" name=\"cmbShoTime\" value=\"false\"><input type=\"checkbox\" onclick=\"showChecked(this);\">";
	//oTd8.innerHTML = "<input type='checkbox' name='cmbShoTime' id='cmbShowTime' value='1'>";
	oTd8.align="center";
	if (val3 != COLUMN_DATA_DATE) { 
		oTd8.childNodes[1].style.display = 'none';
	}
	
	
	var oTr = document.createElement("TR");
	oTr.appendChild(oTd0);
	oTr.appendChild(oTd1);
	oTr.appendChild(oTdh);
	oTr.appendChild(oTd2);
	oTr.appendChild(oTd7);
	oTr.appendChild(oTd3);
	oTr.appendChild(oTdh);
	oTr.appendChild(oTd4);
	oTr.appendChild(oTd5);
	oTr.appendChild(oTd6);
	oTr.appendChild(oTd8);
	document.getElementById("gridShows").addRow(oTr);

	addListener(oTd3.childNodes[0],"change",function(evt){sortChange(evt);})

}