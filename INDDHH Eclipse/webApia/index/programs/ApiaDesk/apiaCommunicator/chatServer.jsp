<%
String result = com.dogma.bean.UrlParser.doProcess(request,response,request.getParameter("action"));
if (result != null) {
	response.setContentType("text/xml");
	response.setCharacterEncoding("utf-8");
	out.clear();
	out.print(result);
} %>