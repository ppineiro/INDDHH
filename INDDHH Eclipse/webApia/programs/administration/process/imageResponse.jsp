<%
String msg = request.getAttribute("msg").toString();
out.clear();
out.print(msg);
%>