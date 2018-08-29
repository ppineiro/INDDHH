<%
//System.out.println(session.getAttribute("uniqueId"));
String ok = "NO-OK";
if(session.getAttribute("uniqueId")!=null && session.getAttribute("uniqueId").equals(request.getParameter("uniqueId"))){
		ok = "OK";
}
out.clear();
out.print(ok);%>