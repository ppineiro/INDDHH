function downloadDocument(docId) {
	openWindow2(URL_ROOT_PATH + "/query.QueryAction.do?action=download&docId="+docId+"&docBean=",700,500,"yes");
}

function btnExport_click(field) {
	var rets = openModal("/programs/modals/export.jsp?hiddeHtml=true&hiddeXPDL=true",500,220);
	var doAfter=function(rets){
		if (rets != null) {
			if (rets[0] == "pdf") {
				btnPDF_click(rets[1]);
			} else if (rets[0] == "excel") {
				btnExcel_click(rets[1]);
			} else if (rets[0] == "csv") {
				btnCSV_click(rets[1]);
			} else if (rets[0] == "html") {
				btnHTML_click(rets[1]);
			} else if (rets[0] == "txt") {
				btnTXT_click(rets[1]);
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnRefresh_click(){
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action="query.QueryAction.do?action=refresh";
	submitForm(document.getElementById("frmMain"));
}

function btnHTML_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.QueryAction.do?action=generateHtml&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnCSV_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.QueryAction.do?action=generateCsv&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnTXT_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.QueryAction.do?action=generateTxt&count=" + count;
	document.getElementById("frmMain").submit();
}


function btnExcel_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="query.QueryAction.do?action=generateExcel&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnPDF_click(count) {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action="query.QueryAction.do?action=generatePdf&count=" + count;
	document.getElementById("frmMain").submit();
}

function btnPrint_click() {

	try {
		if (!beforePrintFormsData_E()) {
			return;
		}
	} catch (e){}
	try {
		if (!beforePrintFormsData_P()) {
			return;
		}
	} catch (e){}
	
	var divContentHeight = document.getElementById("divContent").style.height;
	//document.getElementById("divContent").style.height = "";
	document.getElementById("printForm").body.value = "";
	document.getElementById("printForm").body.value = processBodyToPrint();
   //document.getElementById("divContent").style.height = divContentHeight;

    //styleWin.focus();

	var modal=openModal("/frames/blank.jsp", 680,400);
	document.getElementById("printForm").target=modal.content.name;//"Print";
	function submitPrint(){
		document.getElementById("printForm").submit();
	    document.getElementById("printForm").body.value = "";
    }
    modal.onload=function(){
    	submitPrint();
    }
	var selectedTab = null;
	
	try {
		if (!afterPrintFormsData_E()) {
			return;
		}
	} catch (e){}
	try {
		if (!afterPrintFormsData_P()) {
			return;
		}
	} catch (e){}
}

function parseQueryGrid(){
	var clonedBody=document.body.cloneNode(true);
	var queryGrid;
	var divs=clonedBody.getElementsByTagName("DIV");
	for(var i=0;i<divs.length;i++){
		if(divs[i].id="queryGrid"){
			queryGrid=divs[i];
		}
	}
	queryGrid.innerHTML=queryGrid.getElementsByTagName("TABLE")[0].parentNode.innerHTML;
	return clonedBody.innerHTML;
}

function btnExit_click(){
	if (FROM_URL){
		if (ON_FINISH == "1"){
			window.close();
		}else {
			splash();
		}
	}else{
		splash();
	}
}

function btnAction_click() {
	var lastSelection=document.getElementById("queryGrid").selectedItems[0];
	if (lastSelection != null) {
		
		var selQryAction = document.getElementById("selQryAction");
		var option = selQryAction.options[selQryAction.selectedIndex];
		var allowAutoFilterSelect = (option != null) ? option.getAttribute("allowAutoFilterSelect") : "false";

		if (allowAutoFilterSelect == "true") {
			var rets = openModal("/programs/query/administration/query/avoidFilter.jsp?qryToId=" + option.value,500,300);
			var doAfter=function(rets, selQryActionValue){
				if (rets != null) {
					for (j = 0; j < rets.length; j++) {
						var ret = rets[j];
						var colName = ret[0];
						var colAvoid = ret[1];
						
						var header = document.getElementById("header" + colName);
						header.setAttribute("avoidFilter", colAvoid);
					}
				}
				
				doMenuAction(selQryActionValue);
			}
			rets.onclose=function(){
				doAfter(rets.returnValue, selQryAction.value);
			}
		} else {
			doMenuAction(selQryAction.value);
		}
	}
}

function doMenuAction(value){
	var lastSelection=document.getElementById("queryGrid").selectedItems[0];
	if (lastSelection != null) {
		setSelectedValues(lastSelection);
	    document.getElementById("frmMain").qryAction.value = value;
		document.getElementById("frmMain").target = "";
		document.getElementById("frmMain").action="query.QueryAction.do?action=executeAction";
		submitForm(document.getElementById("frmMain"));
	}
}

function setSelectedValues(tr){
	var headTds=document.getElementById("queryGrid").thead.rows[0].cells;
	var resultHeader = document.getElementById("resultHeader");
 //ATENCION: dado que en las grillas martin marca con valor "on" el primer input del primer TD se agrega un input hidden sin sentido, por lo que aca se hace referencia al input[1] y no de cero
	for (i = 0; i < tr.cells.length; i++) {
		var value="";
		var avoidFilter = resultHeader.cells[i].getAttribute("avoidFilter");

		avoidFilter += "";
		
		if (avoidFilter == "true") {
			value = "";
		} else {
			if(tr.cells[i].getElementsByTagName("INPUT")[1]){
				value = tr.cells[i].getElementsByTagName("INPUT")[1].value;
			}else if(tr.cells[i].getElementsByTagName("SPAN")[0]){
				value = tr.cells[i].getElementsByTagName("SPAN")[0].innerHTML;
			}else{
				value = tr.cells[i].innerHTML;
			}
		}
		headTds[i].getElementsByTagName("INPUT")[0].value = value;
		
		//VER ESTO... por algun motivo cuando la columna es PRO_INST_ID, hay dos inputs ocultos... 
		//uno llamado PRO_INST_ID y otro proInstId, el segundo es el que se usa en java, pero solo se carga el primero. 
		//por eso este codigo le copia el valor
		if(headTds[i].getElementsByTagName("INPUT")[0].name == "PRO_INST_ID"){
			try{
				document.getElementById("proInstId").value = document.getElementById("PRO_INST_ID").value.replace(",","").replace(".","");
			} catch(e){
			}
		}else if(headTds[i].getElementsByTagName("INPUT")[0].name == "PRO_ID"){
			try{
				document.getElementById("txtProId").value = document.getElementById("PRO_ID").value.replace(",","").replace(".","");
			} catch(e){
			}
		}else if(headTds[i].getElementsByTagName("INPUT")[0].name == "BUS_ENT_ADMIN_TYPE"){
			try{
				document.getElementById("busEntAdminType").value = document.getElementById("BUS_ENT_ADMIN_TYPE").value.replace(",","").replace(".","");
			} catch(e){
			}
		}else if(headTds[i].getElementsByTagName("INPUT")[0].name == "BUS_ENT_INST_ID"){
			try{
				document.getElementById("busEntInstId").value = document.getElementById("BUS_ENT_INST_ID").value.replace(",","").replace(".","");
			} catch(e){
			}
		}else if(headTds[i].getElementsByTagName("INPUT")[0].name == "BUS_ENT_ID"){
			try{
				document.getElementById("busEntId").value = document.getElementById("BUS_ENT_ID").value.replace(",","").replace(".","");
			} catch(e){
			}
		}else if(headTds[i].getElementsByTagName("INPUT")[0].name == "PRO_ELE_INST_ID"){
			try{
				document.getElementById("proEleInstId").value = document.getElementById("PRO_ELE_INST_ID").value.replace(",","").replace(".","");
			} catch(e){
			}
		}

	}
 
}

function btnAnt_click() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action="query.QueryAction.do?action=returnAction";
//	submitForm(document.getElementById("frmMain"));
	submitForm(document.getElementById("frmMain"));
}

var lastSelection = null;


//navegation
function first() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.QueryAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.QueryAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.QueryAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.QueryAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action="query.QueryAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}
function setShowRegs(){
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action="query.QueryAction.do?action=showRegs";
	submitForm(document.getElementById("frmMain"));
}
function setGridMenu(){
	if(!document.getElementById("queryGrid")){
		return;
	}
	document.getElementById("queryGrid").gridMenu=function(callerGrid,doc,tempX,tempY,aEvent){
		callerGrid.unselectAll();
		var div=document.createElement("div");
		div.id="contextMenuContainer";
		var items='<table id="contextMenu" width="115" border="0px" cellpadding="0"><tr><td style="padding-left:20px;">'+GRID_SELECTNONE+'</td></tr>';
		if(doc.tagName=="TR" || doc.tagName=="TD"){
			for(var i=0;i<menuActions.length;i++){
				items+="<tr><td style='padding-left:20px;' onclick='doMenuAction(\""+menuActions[i].value+"\")'>"+menuActions[i].text+"</td></tr>";
			}
			while(doc.tagName!="TR"){
				doc=doc.parentNode;
			}
			callerGrid.selectElement(doc);
		}
		items+="</table>";
		div.innerHTML=items;
		div.style.position="absolute";
		div.style.width="115px";
		div.style.zIndex="9999999";
		document.onmousedown=function(e){
			if(navigator.userAgent.indexOf("MSIE")>0){
				e=window.event;
			}
			setTimeout(hideMenu,200);
			e.cancelBubble = true;
			document.oncontextmenu=[];
		}
		div.style.border="1px solid black";
		div.style.left=tempX+"px";
		div.style.top=tempY+"px";
		document.body.appendChild(div);
		var tds=div.getElementsByTagName("TD");
		var table=doc;
		if(table.tagName=="DIV"){
			table=doc.getElementsByTagName("TABLE");
			table=table[0];
		}else{
			while(table.tagName!="TABLE"){
				table=table.parentNode;
			}
		}
		tds[0].onclick=function(){
			//unselect All
			callerGrid.unselectAll();
		}
		
		if(window.navigator.appVersion.indexOf("MSIE")>=0){
			for(var i=0;i<tds.length;i++){
				element=aEvent.srcElement;
				tds[i].onmouseover=function(){
					element=window.event.srcElement;
					element.parentNode.className="hoverEmulate";
				}
				tds[i].onmouseout=function(){
					element=window.event.srcElement;
					element.parentNode.className="";
				}
			}
		}
	}
}

if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", setGridMenu, false);
}else{
	setGridMenu();
}