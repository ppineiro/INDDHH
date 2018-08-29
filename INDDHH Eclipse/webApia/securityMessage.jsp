<%@page import="java.util.*"%><%@include file="components/scripts/server/startInc.jsp" %><HTML><head><%@include file="components/scripts/server/headInclude.jsp" %></head><body <% if (request.getParameter("mdlTarget") != null) {%>style="BORDER:2px groove white;"<%}%>><table class="usuMsg" border=0 align="center" valign="middle"><thead><tr><td><%=LabelManager.getName(labelSet,"lblMenUsu")%></td></tr></thead><tr><td align=center><li><!--<U><A style="cursor:hand" onclick="gotoLogin()">--><%=LabelManager.getName(labelSet,com.st.util.StringUtil.escapeHTML(request.getParameter("message")))%><!--</A></U>--></td></tr><tr><td><a href="#nowhere" onclick="gotoLogin()">login</a></td></tr></table></body></HTML><% if (request.getParameter("mdlTarget") == null) {%><%@include file="components/scripts/server/endInc.jsp" %><%}%><script language="javascript" defer="true"><% if (request.getParameter("mdlTarget") != null) {%>
	window.parent.document.getElementById("iframeMessages").hideResulFrame();
    window.parent.document.getElementById("iframeResult").showResultFrame(window.parent.document.getElementById("iframeMessages").getBody());
<%}%>

function gotoLogin(){
	if(window.dialogWidth == undefined){
		if(parent.window.location.href == parent.parent.window.location.href){
			parent.window.location.href = "<%=com.dogma.Parameters.ROOT_PATH%>/programs/login/login.jsp";
		} else {
			parent.parent.window.location.href = "<%=com.dogma.Parameters.ROOT_PATH%>/programs/login/login.jsp";
		}	
	}
}
</script>