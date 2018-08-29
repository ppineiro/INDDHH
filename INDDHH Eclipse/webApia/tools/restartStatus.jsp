<%@page language="java"%>
<% 
if (request.getParameter("newState") != null && ! "".equals(request.getParameter("newState"))) {
	com.dogma.Parameters.RESTART_IN_PROGRESS = "true".equals(request.getParameter("newState"));
}
%>
<html>
	<body>
		Restart in progress: <b><%= com.dogma.Parameters.RESTART_IN_PROGRESS %></b><br>
		<form method="post" action="restartStatus.jsp">
			New status:
			<select name="newState"><option value="">refresh status</option><option value="true">true</option><option value="false">false</option></select>
			<input type="submit" value="Set new state">
		</form>
		Use with caution.
	</body>
</html>