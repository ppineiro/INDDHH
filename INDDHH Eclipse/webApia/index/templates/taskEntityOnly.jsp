<%@ taglib uri='regions' prefix='region'%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.*"%><%@page import="java.util.*"%><%@include file="../components/scripts/server/startInc.jsp"%><HTML XMLNS:CONTROL><head><%@include file="../components/scripts/server/headInclude.jsp"%><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/tabs.css" rel="styleSheet" type="text/css" media="screen"></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><region:render section='title' /></TD><TD align="right"><button onclick="showDocs_click()"
			accesskey="<%=LabelManager.getAccessKey(labelSet,"sbtEjeDoc")%>"
			title="<%=LabelManager.getToolTip(labelSet,"sbtEjeDoc")%>"><%=LabelManager.getNameWAccess(labelSet, "sbtEjeDoc")%></button></TD></TR></TABLE><div id="divContent" <region:render section='divHeight'/>><form id="frmMain" name="frmMain" target="iframeResult" method="POST"><div type ="tabElement" id="samplesTab" ontabswitched="tabSwitch()"><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getName(labelSet,"tabEjeFor")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjeFor")%>"><region:render section='entityForms' /></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getName(labelSet,"tabEjeEnt")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjeEnt")%>"><region:render section='entityMain' /><region:render section='entityRelations' /><DIV class="subTit"><%=LabelManager.getName(labelSet, "sbtEjeDocEnt")%></DIV><region:render section='entityDocuments' /></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getName(labelSet,"tabEjeObs")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjeObs")%>"><region:render section='taskComments' /></div></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><region:render section='buttons' /></TD></TR></TABLE></body></html><script>
function showDocs_click() {
	openModal("/programs/documents/docExecutionModal.jsp?a=a" + windowId,500,300);
}
function showContent(contentNumber){
	if(document.getElementById("content"+contentNumber).style.display!="block"){
		hideAllContents();
		document.getElementById("content"+contentNumber).style.display="block";
		document.getElementById("tab"+contentNumber).parentNode.className="here";
	}
	if(navigator.userAgent.indexOf("MSIE")<0){
		var continer=window.parent.document.getElementById(window.name);
		continer.style.display="none";
		continer.style.display="block";
	}
}
function hideAllContents(){
	for(var i=0;i<3;i++){
		document.getElementById("tab"+i).parentNode.className="";
		document.getElementById("content"+i).style.display="none";
	}
}
</script>

