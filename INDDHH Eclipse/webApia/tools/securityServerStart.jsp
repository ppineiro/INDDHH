<%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="com.st.db.dataAccess.DBConnection"%><%@page import="com.dogma.security.manager.ServerStart"%><%@page import="com.dogma.dataAccess.DBManagerUtil"%><%
boolean onlyErrorCode = "true".equals(request.getParameter("onlyErrorCode"));

DBConnection dbConn = null;
boolean serverStarted = false;
String exceptionStackTrace = null;
try {
	dbConn = DBManagerUtil.getApiaConnection();
	ServerStart.start(dbConn);
	serverStarted = true;
} catch (Exception e) {
	exceptionStackTrace = StringUtil.toString(e, true);
} finally {
	DBManagerUtil.close(dbConn);
}

if (onlyErrorCode) {
	response.sendError(serverStarted ? 200 : 500, serverStarted ? "Security Server Running" : "Security Server NOT Running" );
} else { %>
<html>
<head>
	<title>Security Server Start</title>
	<style type="text/css">
		body		{ font-family: verdana; font-size: 10px; }
		a			{ text-decoration: none; color: blue; }
	</style>
</head>

<body>
	<% if (serverStarted) { %>
		Server is running.
	<% } else { %>
		Server is not running.
		<% if (StringUtil.notEmpty(exceptionStackTrace)) { %>
			<%= exceptionStackTrace %>
		<% } %>
	<% } %>
	<br>
	<a href="?">Refresh</a>
</body>
</html><%
} %>