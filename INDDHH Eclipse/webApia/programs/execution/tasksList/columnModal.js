var lastSelection = null;
var oColumnas=document.getElementById("oColumnas");
function up_click() {
	lastSelection=oColumnas.selectedItems[0];
	if ((lastSelection != null) && (lastSelection.rowIndex > 1)) {
		swapRows(lastSelection.rowIndex-1,lastSelection.rowIndex - 2);
	}
}

function down_click() {
	lastSelection=oColumnas.selectedItems[0];
	if ((lastSelection != null) && ((lastSelection.rowIndex + 1) < document.getElementById("oColumnas").rows.length)) {
		swapRows(lastSelection.rowIndex-1,lastSelection.rowIndex);
	}
}

function swapRows(pos1, pos2) {
	var checked1=oColumnas.rows[pos1].getElementsByTagName("INPUT")[1].checked;
	var checked2=oColumnas.rows[pos2].getElementsByTagName("INPUT")[1].checked;
	for(i=0;i<oColumnas.rows[pos1].childNodes.length;i++){
		var aux=oColumnas.rows[pos1].childNodes[i].cloneNode(true);
		oColumnas.rows[pos1].childNodes[i].innerHTML=oColumnas.rows[pos2].childNodes[i].innerHTML;
		oColumnas.rows[pos2].childNodes[i].innerHTML=aux.innerHTML;
	}
	oColumnas.rows[pos1].getElementsByTagName("INPUT")[1].checked=checked2;
	oColumnas.rows[pos2].getElementsByTagName("INPUT")[1].checked=checked1;
	oColumnas.unselectAll();
	oColumnas.selectElement(oColumnas.rows[pos2]);
//	oColumnas.scrollTop=oColumnas.rows[pos2].offsetTop;
}

function btnConf_click() {
	if (verifyRequiredObjects()) {
		var rows=oColumnas.rows;
		colOrder=rows[0].getElementsByTagName("INPUT")[0].value;
		for(var i=1;i<rows.length;i++){
			colOrder+=";"+rows[i].getElementsByTagName("INPUT")[0].value;
		}
		document.getElementById("colOrden").value=colOrder;
		document.getElementById("frmMain").action = "execution.TasksListAction.do?action=setColumn&workMode=" + WORK_MODE;
		submitFormModal(document.getElementById("frmMain"));
	}
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
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

var lastSelectionClass = null;


