<%@page language="java"%><% 
if (request.getParameter("newState") != null && ! "".equals(request.getParameter("newState"))) {
	com.dogma.Parameters.SEC_ONLY_ALLOW_MIGRATION_ACTIONS = "true".equals(request.getParameter("newState"));
}
%><html><body>
		Only migration: <b><%= com.dogma.Parameters.SEC_ONLY_ALLOW_MIGRATION_ACTIONS %></b><br><form method="post" action="migrationStatus.jsp">
			New status:
			<select name="newState"><option value="">refresh status</option><option value="true">true</option><option value="false">false</option></select><input type="submit" value="Set new state"></form>
		Use with caution.
	</body></html>