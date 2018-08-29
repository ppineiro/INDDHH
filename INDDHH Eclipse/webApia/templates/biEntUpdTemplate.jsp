<%@taglib uri='regions' prefix='region'%><%@page import="com.dogma.vo.*"%><%@page import="com.st.util.StringUtil"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="java.util.*"%><%@include file="../components/scripts/server/frmTargetStart.jsp" %><script language="javascript">
	var closeWindow = "<region:render section='navigate'/>";
	var nextUrl		= "<region:render section='nextUrl'/>";
	var btnSalir	= "<region:render section='btnSalir'/>";
	var autoClose	= false;
	
	if (nextUrl == "") {
		nextUrl = "/FramesAction.do?action=splash";
	}
	
</script><div id="divMsg" style="height:195px;overflow:hidden;"><table class="tblTitulo"><tr><td><region:render section='title'/></td></tr></table><!-----------------------------START CONTENT----------------><div class="divContent" id="divContent" style="width:340px; height:147px;overflow:auto;display:block;"><form id="frmMain" name="frmMain" method="POST"><table><tr><td id="preMsg"><region:render section='message'/></td></tr></table></form></div><!--------START BUTTONBAR-------------------------><table id="btnsBar" class="btnsBar" style="display:block;"><tr><td align="right" width=100% nowrap><button onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnCon")%></button> &nbsp; 
				<button id="btnCancel" onclick="btnCancel()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnCan")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnCan")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnCan")%></button></td></tr></table></div><!--------END BUTTONBAR-------------------------></body></html><%@include file="../components/scripts/server/frmTargetEnd.jsp" %>