<% 
	if (request.getParameter("logTime") != null) {
		com.st.util.log.Log.setMinTime(Long.parseLong(request.getParameter("logTime")));
	}%>
	
<H1>Set min time for perf log<H1>
<BR>
<form method="post" action="setMinTime.jsp">
Current Min Time : <input name="logTime" value="<%=com.st.util.log.Log.getMinTime()%>">
<br>
<br>
<input type=submit>
</form>

