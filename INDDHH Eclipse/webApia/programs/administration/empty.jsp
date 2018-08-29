<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%
	out.clear();
	String result = request.getParameter("result");
	if (result == null || result.length() == 0) {
		result = (String) request.getAttribute("result");
	}
	out.print(result);
%>