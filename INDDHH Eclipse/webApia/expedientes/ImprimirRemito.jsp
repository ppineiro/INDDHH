<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1);
%>
<%
try {
	UserData uData = ThreadData.getUserData();
	String HTMLRemito = (String)uData.getUserAttributes().get("HTML_REMITO");
	out.print(HTMLRemito);
} catch (Exception e) {
	out.print("ERROR en ImprimirRemito.jsp: " + e.getMessage());
}
%>
<script>
	//setTimeout(function() {	window.focus()}, 3000);
</script>