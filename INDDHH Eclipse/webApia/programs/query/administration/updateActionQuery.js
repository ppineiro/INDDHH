//---
//--- Funciones para trabajar con las columnas del filtro
//---

function chkActVieQry_click() {
	var status = !document.getElementById("chkActVieQry").checked;
	document.getElementById("upActionQuery").disabled = status;
	document.getElementById("downActionQuery").disabled = status;
	document.getElementById("btnAddActionQuery").disabled = status;
	document.getElementById("btnDelActionQuery").disabled = status;
	
	checkActions();
}

function btnAddActionQuery_click() {
	var rets = openModal("/programs/modals/querys.jsp",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				trows=document.getElementById("gridActionQuery").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
	
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					var oTd2 = document.createElement("TD"); 
			
					oTd0.innerHTML = "<input type='checkbox' name='chkactVieQryTo'><input type='hidden' name='actVieQryTo'><input type='hidden' name='actVieQryToName'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.getElementsByTagName("INPUT")[2].value = ret[1];
					oTd0.align="center";
			
					oTd1.innerHTML = ret[1];
					
					oTd2.innerHTML = "<input type='checkbox' name='actVieQryToAllowAutoFilter' id='actVieQryToAllowAutoFilter' value='1'>";
			
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					
					document.getElementById("gridActionQuery").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnDelActionQuery_click() {
	var cant=0

	trows = document.getElementById("gridActionQuery").getRows();
	document.getElementById("gridActionQuery").removeSelected();

	return cant;
}

var lastSelectionActionQuery = null;
function upActionQuery_click() {
	lastSelectionActionQuery=document.getElementById("gridActionQuery").selectedItems[0];
	if (lastSelectionActionQuery!= null && lastSelectionActionQuery.rowIndex > 1) {
		swapActionQuery(lastSelectionActionQuery.rowIndex,lastSelectionActionQuery.rowIndex - 1);
	}
}

function downActionQuery_click() {
	lastSelectionActionQuery=document.getElementById("gridActionQuery").selectedItems[0];
	if (lastSelectionActionQuery != null && lastSelectionActionQuery.rowIndex < document.getElementById("tblActionQuery").rows.length) {
		swapActionQuery(lastSelectionActionQuery.rowIndex,lastSelectionActionQuery.rowIndex + 1);
	}
}

function swapActionQuery(pos1, pos2) {
	pos1--;
	pos2--;
	document.getElementById("gridActionQuery").swapRows(pos1,pos2);
}
