<%@ page language="java" session="false" %><html><head></head><body><script>
	//parent.window.close();
	parent.window.location.href = "<%=com.dogma.Parameters.ROOT_PATH%>/programs/login/login.jsp?langId=<%= request.getParameter("langId") %>";
</script></body></html>

