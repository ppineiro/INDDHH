<%
out.clear();
String t = request.getParameter("token");
if("true".equals(request.getSession().getAttribute(t))) {
	out.print("ok");
} else if("error".equals(request.getSession().getAttribute(t))) {
	String title = (String)request.getSession().getAttribute(t + "Title");
	String message = (String)request.getSession().getAttribute(t + "Message");
	out.print("msg--" + title + "--" + message);
} else {
	out.print("nok");
}

%>