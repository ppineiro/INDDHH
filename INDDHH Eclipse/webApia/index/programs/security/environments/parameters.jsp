<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.configuration.EnvParametersBean"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.EnvironmentsBean"></jsp:useBean><%
EnvironmentVo environmentVo = dBean.getEnvVo();
%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/configuration/envParameters/parameters.js'></script></head><body onload="initChat()"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titParEnv")%>: <%= environmentVo.getEnvName() %></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><%
		
		Integer theEnvId = environmentVo.getEnvId();
		Collection paramsFormat = dBean.getParamsFormat();
		Collection paramsOther = dBean.getParamsOther();
		Collection styles = dBean.getStyles();
		
		%><%@include file="../../configuration/envParameters/common/parameters.jsp" %></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language='javascript' src='<%=Parameters.ROOT_PATH%>/programs/security/environments/parameters.js'></script><script>
function tabSwitch(){
}

</SCRIPT>

