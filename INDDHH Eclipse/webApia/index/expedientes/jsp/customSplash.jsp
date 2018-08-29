<%@page import="java.util.*"%>
<%@page import="com.dogma.*"%>
<%@page import="com.dogma.vo.*"%>
<%@include file="../../components/scripts/server/startInc.jsp" %>

<HTML>
<head>
<%@include file="../../components/scripts/server/headInclude.jsp" %>
<script language="javascript" src='<%=Parameters.ROOT_PATH%>/frames/splash.js' defer="true"></script>
<script language="javascript" defer="true">
<%if(request.getParameter("windowId")!=null){ %>
var windowId        = "&windowId=<%=request.getParameter("windowId")%>";
<%}else{%>
var windowId        = "";
<%}%>
function windowClose(){
	window.close();
}
if(windowId!="" && windowId.indexOf("W")<0){
	if (document.addEventListener) {
    	document.addEventListener("DOMContentLoaded", windowClose, false);
	}else{
		windowClose();
	}
}

</script>
</head>

<body>
<jsp:useBean id="messagesBean" scope="session" class="com.dogma.bean.security.MessageBean" />
<jsp:useBean id="notificationsBean" scope="session" class="com.dogma.bean.execution.NotificationBean" />
<div align=right>
<font size='1' color='darkgray'>Build 008	</font>
</div>
<div id="divContent" >
<table class="logoArea" border=0 width="100%">
<tr>
<td class="clsTitle"><%out.println("ApiaDocumentum " + EnvParameters.getEnvParameter(environmentId,EnvParameters.SPLASH_TITLE));%></td>
<td class="clsLogo"><img src="<%=Parameters.ROOT_PATH%><%=EnvParameters.getEnvParameter(environmentId,EnvParameters.SPLASH_IMAGE)%>" border=0></td>
</tr>
<tr>
<!-- <iframe id="bandCustSplash" src="<%=Parameters.ROOT_PATH%>/redirect.jsp?link=query.TaskListAction.do%3Faction=viewList&query=2535" height=460px width=1080px></iframe> -->
<iframe id="extFrame" src="execution.UserWorkResumeAction.do?action=init"  height=640px width=1080px ></iframe> 
</tr>
</table>
<table border=0 align="center" valign="middle"><tr><td><%
				Collection col = messagesBean.getUserMessages(request);
				if (col != null && col.size() > 0) { %><table class="usuMsg" border=0 align="center" valign="middle"><thead><tr><td><%=LabelManager.getName(labelSet,"lblMenUsu")%></td></tr></thead><!--MENSAJES USUARIO---><%
						Iterator it = col.iterator();
	          			while (it.hasNext()) {
	          				String str = (String)it.next(); %><tr><td><li><%=messagesBean.fmtStr(str)%></td></tr><%
          				} %><!--END MENSAJES USUARIO---></table><%
				} 
				
				col = notificationsBean.getUserNotifications(request);
				if (col != null && col.size() > 0) { %><table class="usuMsg" border=0 align="center" valign="middle"><thead><tr><td><%=LabelManager.getName(labelSet,"sbtSplashNot")%></td></tr></thead><tbody><tr><td><%
									if (col != null && col.size() > 0) { %><div style="width:100%;height:200px;overflow:auto"><%
											Iterator it = col.iterator();
											int i = 0;
	    	    			  				while (it.hasNext() && i < Parameters.MAX_RESULT_NOTIFICATION) {
	        									NotificationVo notVo = (NotificationVo) it.next(); %><li><%=messagesBean.fmtStr(notVo.getNotMessage())%></li><%
					    	    		  		i++;
    	    	  							} 
		    	      						if (i >= Parameters.MAX_RESULT_NOTIFICATION) { %><br><br><center><%=LabelManager.getName("lblMoreData")%></center><%
											} %></div><%
									} else { %>
										&nbsp<%
									} %></td></tr></tbody></table><%
				} %></td></tr></table></div><table width=100% nowrap><tr><td class=copyrightTxt width=100% align="left" ></td><td align="right" class=copyrightTxt nowrap><%=com.dogma.DogmaConstants.COPYRIGHT_NOTICE%></td></tr></table><%@include file="../../components/scripts/server/endInc.jsp" %></body></HTML>



