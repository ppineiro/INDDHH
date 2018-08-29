<%@ taglib uri='regions' prefix='region'%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.*"%><%@page import="java.util.*"%><%@include file="../components/scripts/server/startInc.jsp"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><HTML XMLNS:CONTROL><head><%@include file="../components/scripts/server/headInclude.jsp"%><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/tabs.css" rel="styleSheet" type="text/css" media="screen"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/grid.css" rel="styleSheet" type="text/css" media="screen"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/gridContextMenu.css" rel="styleSheet" type="text/css" media="screen"><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/grid/grids.js"></script></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><region:render section='title' /></TD><TD align="right"><button onclick="showDocs_click()"
			accesskey="<%=LabelManager.getAccessKey(labelSet,"sbtEjeDoc")%>"
			title="<%=LabelManager.getToolTip(labelSet,"sbtEjeDoc")%>"><%=LabelManager.getNameWAccess(labelSet, "sbtEjeDoc")%></button></TD></TR></TABLE><div id="divContent" <region:render section='divHeight'/>><form id="frmMain" name="frmMain" target="iframeResult" method="POST"><div type ="tabElement" id="samplesTab" ontabswitched="tabSwitch()" <%if (request.getParameter("selTab") != null) {%> defaultTab="<%=request.getParameter("selTab")%>"<%}%>><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabEjeEnt")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjeEnt")%>"><region:render section='entityMain' /><region:render section='entityRelations' /><DIV class="subTit"><%=LabelManager.getName(labelSet, "sbtEjeDocEnt")%></DIV><region:render section='entityDocuments' /></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabEjePro")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjePro")%>"><region:render section='processMain' /><region:render section='processHistory' /><DIV class="subTit"><%=LabelManager.getName(labelSet, "sbtEjeDocPro")%></DIV><region:render section='processDocuments' /><script src="<%=Parameters.ROOT_PATH%>/programs/documents/documents.js"></script></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabEjeFor")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjeFor")%>"><region:render section='entityForms' /></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabEjeForPro")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjeForPro")%>"><region:render section='processForms' /></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabEjeObs")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjeObs")%>"><region:render section='taskComments' /></div></div></FORM></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><region:render section='buttons' /></TD></TR></TABLE></body></html><script>
function showDocs_click() {
	openModal("/programs/documents/docExecutionModal.jsp?a=a" + windowId,500,300);
}
function showContent(contentNumber){
	hideAllContents();
	document.getElementById("content"+contentNumber).style.display="block";
	document.getElementById("tab"+contentNumber).parentNode.className="here";
	//if(navigator.userAgent.indexOf("MSIE")<0){
		var continer=window.parent.document.getElementById(window.name);
		var width=continer.style.width;
		continer.style.display="none";
		continer.style.display="block";
		sizeMe();
	//}
}
function hideAllContents(){
	for(var i=0;i<5;i++){
		document.getElementById("tab"+i).parentNode.className="";
		document.getElementById("content"+i).style.display="none";
	}
}
</script>

