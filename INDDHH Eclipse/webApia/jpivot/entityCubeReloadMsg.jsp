<%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.*"%><%@page import="com.dogma.vo.custom.ProAdmResultVo"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="dSBean" scope="session" class="com.dogma.bean.administration.SchemaBean"></jsp:useBean><%  
	StringBuffer message = new StringBuffer();
	message.append("<P><B>" + LabelManager.getName(labelSet,"msgCbeNoUpdated") + "</B>");
	//message.append("<TABLE><tr>");
	//message.append("<br><br>");
	//message.append("<td><button type=\"button\" id=\"btnOK\" onClick=\"btnOK_click()\" title=\""+LabelManager.getToolTip(labelSet,"btnCon")+"\">"+LabelManager.getNameWAccess(labelSet,"btnCon")+"</button></td>");
	//message.append("<td><button type=\"button\" id=\"btnNOK\" onClick=\"btnNOK_click()\" title=\""+LabelManager.getToolTip(labelSet,"btnCan")+"\">"+LabelManager.getNameWAccess(labelSet,"btnCan")+"</button></td>");
	//message.append("</tr></TABLE>");
%><%@include file="../../../components/scripts/server/headInclude.jsp" %><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/util.js"></script><region:render template='/templates/biEntUpdTemplate.jsp'><region:put section='title'><%=LabelManager.getName(labelSet,"lblDwQry")%></region:put><region:put section='message'><%=message.toString()%></region:put></region:render><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">
	function btnConf_click(){
		window.parent.document.getElementById("iframeResult").hideResultFrame()
		var formulario = window.parent.document.getElementById("iframeResult").submitterDoc.getElementById("frmMain");
		formulario.target="_self";
		formulario.action="administration.BIAction.do?action=updateEntityCube&mode=<%=request.getParameter("mode") + "&schemaId=" + request.getParameter("schemaId") + "&cubeId=" + request.getParameter("cubeId") + "&entityCube=" + request.getParameter("entityCube") + "&processCube=" + request.getParameter("processCube") + "&viewId=" + request.getParameter("viewId") + "&envId=" + request.getParameter("envId")%>";
		window.parent.document.getElementById("iframeResult").src="";
		submitForm(formulario);
	}
	function btnCancel(){
		window.parent.document.getElementById("iframeResult").hideResultFrame()
		var formulario = window.parent.document.getElementById("iframeResult").submitterDoc.getElementById("frmMain");
		formulario.target="_self";
		<%if ("viewer".equals(request.getParameter("mode"))){%>
			formulario.action="administration.BIAction.do?action=openViewer&forceOpen=true&schemaId=<%=request.getParameter("schemaId") + "&cubeId=" + request.getParameter("cubeId") + "&entityCube=" + request.getParameter("entityCube") + "&processCube=" + request.getParameter("processCube") + "&viewId=" + request.getParameter("viewId") + "&envId=" + request.getParameter("envId")%>";
		<%}else{%>
			formulario.action="administration.BIAction.do?action=openNavigator&forceOpen=true&schemaId=<%=request.getParameter("schemaId") + "&cubeId=" + request.getParameter("cubeId") + "&entityCube=" + request.getParameter("entityCube") + "&processCube=" + request.getParameter("processCube") + "&viewId=" + request.getParameter("viewId") + "&envId=" + request.getParameter("envId")%>";
		<%}%>
		window.parent.document.getElementById("iframeResult").src="";
		try{
			if(windowId!=undefined && windowId!=null){
				formulario.action = formulario.action+windowId;
			}
		}catch(e){}
		submitForm(formulario);
	}
</script>