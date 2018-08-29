<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.configuration.EnvParametersBean"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.configuration.EnvParametersBean"></jsp:useBean><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/configuration/envParameters/parameters.js'></script></head><body onload="initChat()"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titParEnv")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><%
		
		Integer theEnvId = dBean.getEnvironmentId();
		Collection paramsFormat = dBean.getParamsFormat();
		Collection paramsOther = dBean.getParamsOther();
		Collection styles = dBean.getStyles();
		
		%><%@include file="common/parameters.jsp" %></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
function tabSwitch(){
}

var RELOAD_STYLE = <%= dBean.isReloadStyle() %>;
<% dBean.setReloadStyle(false); %></SCRIPT>

