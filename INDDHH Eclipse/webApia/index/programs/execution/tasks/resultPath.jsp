<%@ page import="com.dogma.Parameters"%><%@ page import="com.dogma.vo.*"%><%@ page import="com.dogma.bean.execution.TaskBean"%><%@ page import="com.st.util.XMLUtils"%><%@ page import="com.st.util.labels.LabelManager"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><% TaskBean dBean = (TaskBean) session.getAttribute("dBean"); %><%@include file="../../../components/scripts/server/frmTargetStart.jsp" %><script>
var autoClose="false";
<%if(request.getParameter("windowId")!=null){ %>
var windowId        = "&windowId=<%=request.getParameter("windowId")%>";
<%}else{%>
var windowId        = "";
<%}%></script><div id="divMsg"><!--     - RESULT MESSAGE          --><table class="tblTitulo"><tr><td><%=LabelManager.getName(labelSet,langId,"titEvaPath")%></td></tr></table><!--     ----------------------------START CONTENT---------------               --><div class="divContent" id="divContent" style="overflow:auto;height:155px;"><form id="frmMain" name="frmMain" method="POST"><table ><tr id="trPath"><td id="preMsg"></td><%

	String unsortedXML = dBean.getEvalPath().getEvalPathAsXML(labelSet,langId);
	String sortedXML = XMLUtils.transform(dBean.getEnvId(request),unsortedXML,"/programs/execution/tasks/sort.xsl");
	
	out.print(XMLUtils.transform(dBean.getEnvId(request),sortedXML,"/programs/execution/tasks/evalPath.xsl"));
%></tr></table></form></div><!--     -------START BUTTONBAR------------------------               --><table id="btnsBar" class="btnsBar" width="100%"><tr><td></td><td align="right" width="100%"><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnCon")%></button> &nbsp;
					<button type="button" onclick="enableButtons()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnSal")%></button></td></tr></table></div><!--     -------END BUTTONBAR------------------------               --></body></html><%@include file="../../../components/scripts/server/frmTargetEnd.jsp" %><script language="javascript" defer>
//enable first controls
function enableButtons(){
	var win=window.parent.document.getElementById(window.name).submitWindow;
	try{
		win.document.getElementById("btnLast").disabled = false;
	} catch(e){}
	try{
		win.document.getElementById("btnNext").disabled = false;
	} catch(e){}
	try{
		win.document.getElementById("btnConf").disabled = false;
	} catch(e){}
	try{
		win.document.getElementById("btnSave").disabled = false;
	} catch(e){}
	try{
		win.document.getElementById("btnPrint").disabled = false;
	} catch(e){}
	window.parent.document.getElementById('iframeResult').hideResultFrame();
}

enableFirstColumn(document.getElementById("trPath").getElementsByTagName("TD")[1].getElementsByTagName("TBODY")[0]);

function rowHasTable(objTr) {
	return objTr.cells.length == 3 || 
		   (objTr.cells[1].childNodes.length > 0 && 
		   	objTr.cells[1].getElementsByTagName("TABLE")[0]);
}

function getTable(objTr) {
	if (objTr.cells.length == 3) {
		return objTr.cells[2].getElementsByTagName("TABLE")[0];
	} else {
		return objTr.cells[1].getElementsByTagName("TABLE")[0];
	}
}

function enableFirstColumn(obj) {
	var j;
	for (j=0;j<obj.rows.length;j++) {
		if (obj.rows[j].cells[0].getElementsByTagName("INPUT")[0]) {
			obj.rows[j].cells[0].getElementsByTagName("INPUT")[0].disabled=false;
			if (obj.rows[j].cells[0].getElementsByTagName("INPUT")[0].checked) {
				obj.rows[j].cells[1].style.color="black";
			}
		} else {
			obj.rows[j].cells[0].style.color="black";
			obj.rows[j].cells[1].style.color="black";
			if (rowHasTable(obj.rows[j])) {
				enableFirstColumn(getTable(obj.rows[j]));
			}
		}
	}
}

function disableTree(obj) {
	var j;
	for (j=0;j<obj.rows.length;j++) {
		if (obj.rows[j].cells[0].childNodes[0].tagName == "INPUT") {
			obj.rows[j].cells[0].childNodes[0].disabled=true;
			obj.rows[j].cells[1].style.color="gray";
		} else {
			obj.rows[j].cells[0].style.color="gray";
			obj.rows[j].cells[1].style.color="gray";
		} 

		if (rowHasTable(obj.rows[j])) {
			disableTree(getTable(obj.rows[j]));
		}
	}
}

function btnConf_click(){
	if (checkSelection()) {
		document.getElementById("frmMain").action = "execution.TaskAction.do?action=confirmPath"+windowId;
		submitTargetForm();
	} else {
		alert("<%=LabelManager.getName(labelSet,langId,DogmaException.EXE_INCOMPLETE_PATH)%>");
	}
}

function checkRadio(obj) {
	if (obj.checked) {
		table = obj.parentNode.parentNode.parentNode.parentNode;
		tdIndex = obj.parentNode.cellIndex;
		trIndex = obj.parentNode.parentNode.rowIndex;
		for (i=0;i<table.rows.length;i++) {
			if (i != trIndex) {
				table.rows[i].cells[tdIndex].getElementsByTagName("INPUT")[0].checked=false;
				table.rows[i].cells[tdIndex+1].style.color="gray";
				if (rowHasTable(table.rows[i])) {
					disableTree(getTable(table.rows[i]));
				}
			}		
		}
		table.rows[trIndex].cells[tdIndex+1].style.color="black";
		if (rowHasTable(table.rows[trIndex])) {
			enableFirstColumn(getTable(table.rows[trIndex]));
		}
	} 
}

function checkCheckbox(obj) {

	table = obj.parentNode.parentNode.parentNode.parentNode;
	tdIndex = obj.parentNode.cellIndex;
	trIndex = obj.parentNode.parentNode.rowIndex;
	if (rowHasTable(table.rows[trIndex])) {
		if (obj.checked) {
			enableFirstColumn(getTable(table.rows[trIndex]));
		} else {
			disableTree(getTable(table.rows[trIndex]));
		}	
	}
	
	if (obj.checked) {
		table.rows[trIndex].cells[tdIndex+1].style.color="black";
	} else {
		table.rows[trIndex].cells[tdIndex+1].style.color="gray";
	}
}


function checkSelection() {
	var inpCol = document.getElementsByTagName("INPUT");
	for (i=0;i<inpCol.length;i++) {
		if (!inpCol[i].disabled && (inpCol[i].type=="radio" || inpCol[i].type=="checkbox")) {
			if (!checkSingleSelection(inpCol[i])) {
				return false;
			}
		}
	}
	return true;
}

function checkSingleSelection(obj) {
	table = obj.parentNode.parentNode.parentNode;
	tdIndex = obj.parentNode.cellIndex;
	trIndex = obj.parentNode.parentNode.rowIndex;
	for (j=0;j<table.rows.length;j++) {
		if (table.rows[j].cells[tdIndex].getElementsByTagName("INPUT")[0].checked) {
			return true;
		}		
	}
	return false;
}
</script>