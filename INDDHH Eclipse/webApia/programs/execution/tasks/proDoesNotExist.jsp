<%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><table class="usuMsg" border=0 align="center" valign="middle"><thead><tr><td>Apia</td></tr></thead><tr><td align=center ><li><%=LabelManager.getName(labelSet,"lblProNoExi")%></td></tr><tr><td><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></td></tr></table></body></HTML><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" defer="true">
function btnExit_click(){
	gotoLogin();
}

function gotoLogin(){
<%String loginUrl="/programs/login/login.jsp";
if(request.getParameter("windowId")!=null && !("").equals(request.getParameter("windowId"))){
	loginUrl="/programs/ApiaDesk/deskLogin.jsp";
}
%>
	if(window.dialogWidth == undefined){
		if(parent.window.location.href == parent.parent.window.location.href){
			parent.window.location.href = "<%=com.dogma.Parameters.ROOT_PATH+loginUrl%>";
		} else {
			parent.parent.window.location.href = "<%=com.dogma.Parameters.ROOT_PATH+loginUrl%>";
		}	
	}
}

</script>