<%@page import="biz.statum.apia.web.tag.TagUtils"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@ page contentType="text/html; charset=iso-8859-1" language="java"%><%@page import="com.dogma.UserData"%><%@include file="../../components/scripts/server/startInc.jsp" %><%
	UserData usrData = BasicBeanStatic.getUserDataStatic(request);
	Integer ident = usrData.getLangId();
%><script type="text/javascript" defer="defer">
function callService(url,event) {
	var height = (screen.availHeight-30) * 0.85;
	var width = (screen.availWidth-10) * 0.85;
	var top = ((screen.availHeight-30) / 2) - (height / 2);
	var left = ((screen.availWidth-10) / 2) - (width / 2);
	var valores = "height= " + height + " , " + "width= " + width;
	valores = "toolbar=no,location=no,status=no,menubar=no,resizable=no,scrollbars=yes,top=" + top + ",left=" + left + "," + valores;
	x="\"";
	valores = x + valores + x;
	window.open (url,"dogmaApp", valores);
}
</script><table border="0" width="100%"><tr><td valign="top"><% if (ident==1){%><a class="skbServices" href="ViewItemAction.do?action=view&id=901">Descargue Facilis</a><br><a class="skbServices" href="ViewItemAction.do?action=view&id=895">Manual de usuario de Facilis</a><br><a class="skbServices" href="ViewItemAction.do?action=view&id=1542">The BPM Game</a><br><% }else if (ident==3){%><a class="skbServices" href="ViewItemAction.do?action=view&id=901">Download Facilis</a><br><a class="skbServices" href="ViewItemAction.do?action=view&id=895">Facilis user's handbook</a><br><a class="skbServices" href="ViewItemAction.do?action=view&id=1542">The BPM Game</a><br><% }else if (ident==2){%><a class="skbServices" href="ViewItemAction.do?action=view&id=901">Download Facilis</a><br><a class="skbServices" href="ViewItemAction.do?action=view&id=895">Manual do usuário do Facilis</a><br><a class="skbServices" href="ViewItemAction.do?action=view&id=1542">The BPM Game</a><br><% }%></td><td valign="top" align="right"><%String img_src = TagUtils.getContext(new HttpServletRequestResponse(request, response)) + "/panels/partners/facilis.jpg"; %><img src=<%=img_src%>></td></tr></table>