//--- Funciones para cambiar de lugar las series
function selectColumnSerie() {
	var e, r, c;
   	e = window.event.srcElement;

  	if (e.tagName == "TR") {
    	r = findRow(e);
		if (r != null) {
	      	if (lastSelectionSerie != null) {
	        	deselectRowOrCell(lastSelectionSerie );
	      	}
	      	selectRowOrCell(r);
	      	lastSelectionSerie = r;
    	}
	} else {
		c = findCell(e);
		if (c != null) {
			if (lastSelectionSerie != null) {
				deselectRowOrCell(lastSelectionSerie );
			}
			selectRowOrCell(c);
			lastSelectionSerie = c;
		}
	}

	window.event.cancelBubble = true;
}

var lastSelectionSerie = null;

function upSerie_click() {
	swapGeneric2("gridSerie",-1);
}
function downSerie_click() {
	swapGeneric2("gridSerie",1);
}

function swapGeneric2(gridName, shift) {
	var grid=document.getElementById(gridName);
	var element=grid.selectedItems[0];
	if ((element != null)&&(grid.selectedItems.length == 1)){
		var index = element.rowIndex;
		if((index + shift > 0) && (index + shift <= grid.rows.length)){
			index--;
			document.getElementById(gridName).swapRows(index,index + shift);
		}
	}
}

function swapSerie(pos1, pos2) {
	var tblSerie = document.getElementById("tblSerie");
	var chkChk1 = tblSerie.rows(pos1).cells(0).children(0).checked;
	var chkChk2 = tblSerie.rows(pos2).cells(0).children(0).checked;

	tblSerie.rows(pos1).swapNode(tblSerie.rows(pos2));
	
	tblSerie.rows(pos1).cells(0).children(0).checked = chkChk2;
	tblSerie.rows(pos2).cells(0).children(0).checked = chkChk1;
}

//--- Funciones para el modal del dise?o de la gr?fica
var selectedColor = null;

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

function btnExitChartDesign_click() {
	window.returnValue=null;
	window.close();
}

function btnConfChartDesign_click() {
	if (verifyRequiredObjects()) {
		var elements = document.getElementsByTagName("INPUT");
		var element=new Array();
		for (i=0;i<elements.length;i++) {
			if(elements[i].name=="chkChtSerShow"){
				element.push(elements[i]); 
			}
		}
		var i = 0;
		var cant = 0;
		for (i=0;i<element.length;i++) {
			if (element[i].checked == true){
				cant = cant + 1;
			}
		}
		if (cant>0){
			var frmMain = document.getElementById("frmMain");
			document.getElementById("frmMain").action = "query.AdministrationAction.do?action=confChartDesign";
			submitForm(frmMain);
		}
		else {
			alert(MSG_NO_SERIE);
		}
	}
}

function lockSerie(){
	var id=document.getElementById("chtColX").options[document.getElementById("chtColX").selectedIndex].text;
	var rows=document.getElementById("gridSerie").rows;
	document.getElementById("gridSerie").unselectAll();
	for(var i=0;i<rows.length;i++){
		var rowId=rows[i].getElementsByTagName("INPUT")[1].value;
		if(id==rowId){
			var hidden=rows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0];
			var check=rows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[1];
			var img=rows[i].getElementsByTagName("TD")[1].getElementsByTagName("A")[0];
			hidden.value=false;
			check.checked=false;
			check.disabled=true;
			img.onclick="";
		}else{
			var check=rows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[1];
			var img=rows[i].getElementsByTagName("TD")[1].getElementsByTagName("A")[0];
			check.disabled=false;
			img.onclick=function(){colorPicker(this);};
		}
	}
}

//--- Funciones para el modal de las propiedades de la gr?fica
function btnExitChartProps_click() {
	window.returnValue=null;
	window.close();
}

function btnConfChartProps_click() {
	var frmMain = document.getElementById("frmMain");
	document.getElementById("frmMain").action = "query.AdministrationAction.do?action=confChartProps";
	document.getElementById("frmMain").target="_self";
	document.getElementById("frmMain").submit();
	submitForm(document.getElementById("frmMain"));
}

//--- Funciones para trabajar con la grilla y sus lineas
function viewDesign(img) {
	var theTr = img.parentNode;
	while(theTr.tagName!="TR"){
		theTr = theTr.parentNode;
	}
	var id = theTr.getElementsByTagName("INPUT")[1].value;
	var inDb = theTr.getElementsByTagName("INPUT")[2].value;
	var selRowNum = document.getElementById("selRowNum");
	var selHidChtId = document.getElementById("selHidChtId");
	var selHidChtIndb = document.getElementById("selHidChtIndb");
	selRowNum.value = theTr.rowIndex;
	selHidChtId.value = id;
	selHidChtIndb.value = inDb;
	var frmMain = document.getElementById("frmMain");

	document.getElementById("frmMain").action = "query.AdministrationAction.do?action=saveColForChart";
	document.getElementById("frmMain").target = "frmSubmit";
	submitForm(frmMain);
	document.getElementById("frmMain").target = "";
}

function viewProps(img) {
	var theTr = img.parentNode;
	while(theTr.tagName!="TR"){
		theTr = theTr.parentNode;
	}
	var id = theTr.getElementsByTagName("INPUT")[1].value;
	var inDb = theTr.getElementsByTagName("INPUT")[2].value;
	openModal("/query.AdministrationAction.do?action=openChartProps&selHidChtId=" + id + "&selHidChtIndb=" + inDb,400,200);
}

var lastNewId = -1;
function findNewId() {
	var newId = lastNewId;
	var trows = document.getElementById("gridChart").rows;
	for (i = (trows.length - 1); i >= 0; i--) {
		if (trows[i].childNodes[0].childNodes.length > 0) {
			var chartId = parseFloat(trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value);
			if (chartId	< newId) {
				newId = chartId;
			}	
		}
	}
	lastNewId = newId - 1;
	return lastNewId;
}

function btnAddChart_click() {
	var oTd0 = document.createElement("TD");
	var oTd1 = document.createElement("TD");
	var oTd2 = document.createElement("TD");
	var oTd3 = document.createElement("TD");
	
	var newId = findNewId();
	oTd0.style.display='none';
	oTd0.innerHTML = "<input type='hidden' id='selector'><input type='hidden' name='hidChtId' value='"+findNewId()+"'><input type='hidden' name='hidChtInDb' value='false'>";
	oTd1.innerHTML = "<input style=\"min-width:100px\" type=\"input\" name=\"txtChtTitle\" size=\"80\" value=\"\" readonly class=\"txtReadOnly\">";
	oTd2.innerHTML = "<img style=\"cursor:hand\" src=\"" + URL_STYLE_PATH + "/images/btn_mod.gif\" onclick=\"viewDesign(this)\">";
	oTd3.innerHTML = "<img style=\"cursor:hand\" src=\"" + URL_STYLE_PATH + "/images/btn_mod.gif\" onclick=\"viewProps(this)\">";
	
	oTd2.align = "center";
	oTd3.align = "center";
	
	oTd2.style.paddingTop = "0px";
	oTd2.style.paddingBottom = "0px";
	
	oTd3.style.paddingTop = "0px";
	oTd3.style.paddingBottom = "0px";

	var oTr = document.createElement("TR");

	oTr.appendChild(oTd0);
	oTr.appendChild(oTd1);
	oTr.appendChild(oTd2);
	oTr.appendChild(oTd3);
	
	document.getElementById("gridChart").addRow(oTr);
	viewDesign(oTd2.getElementsByTagName("IMG")[0]);
}

function btnDelChart_click() {
	document.getElementById("gridChart").removeSelected();
}

//--- Funciones para cambiar los lugares de las gr?ficas

function upChart_click() {
	/*var element=document.getElementById("gridChart").selectedItems[0];
	var index=element.rowIndex;
	if ((element != null) && (index > 1)) {
		index--;
		document.getElementById("gridChart").swapRows(index,index - 1);
	}*/
	swapGeneric2("gridChart",-1);
}

function downChart_click() {
	/*var element=document.getElementById("gridChart").selectedItems[0];
	var index=element.rowIndex;
	var length=document.getElementById("gridChart").getElementsByTagName("TD");
    if ((element != null) && (length > index) && (index != -1)) {
		index--;
		document.getElementById("gridChart").swapRows(element.rowIndex,element.rowIndex + 1);
	}*/
	swapGeneric2("gridChart",1);
}

function swapChart(pos1, pos2) {
	var tblChart = document.getElementById("tblChart");
	var chkChk1 = tblChart.rows(pos1).cells(0).children(0).checked;
	var chkChk2 = tblChart.rows(pos2).cells(0).children(0).checked;

	tblChart.rows(pos1).swapNode(tblChart.rows(pos2));
	
	tblChart.rows(pos1).cells(0).children(0).checked = chkChk2;
	tblChart.rows(pos2).cells(0).children(0).checked = chkChk1;
}