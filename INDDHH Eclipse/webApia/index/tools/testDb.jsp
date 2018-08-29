<%@ page contentType="text/html; charset=iso-8859-1" language="java" errorPage="/tiles/errorMain.jsp"%>
<html>
<head><title>TestDb</title></head>
<body>

<form>
Type:<select name="dbType">
	<option value=""></option>
	<option value="oracle">oracle</option>
	<option value="postgresql">postgresql</option>
	<option value="sqlserver">sqlserver</option>
</select><br>
Url:<input type="text" name="dbUrl"><br>
User:<input type="text" name="dbUser"><br>
Password:<input type="text" name="dbPwd"><br>
<input type="submit" value="Test">
</form>
<%
String dbType = request.getParameter("dbType");
String dbUrl  = request.getParameter("dbUrl");
String dbUser = request.getParameter("dbUser");
String dbPwd  = request.getParameter("dbPwd");

if (dbType != null && ! "".equals(dbType)) { %>
	<b>Test start</b><br>
	Type: <b><%=dbType%></b><br>
	Url: <b><%=dbUrl%></b><br>
	User: <b><%=dbUser%></b><br>
	Pwd: <b><%=dbPwd%></b><br>
	<br><%
	try {
		String driverClassName = null;
		
		if ("postgresql".equals(dbType)) { driverClassName = "org.postgresql.Driver";
		} else if ("sqlserver".equals(dbType)) { driverClassName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		} else if ("oracle".equals(dbType)) { driverClassName = "oracle.jdbc.driver.OracleDriver"; } %>
		
		<b>Driver...</b><% java.sql.Driver driver = (java.sql.Driver) Class.forName(driverClassName).newInstance(); %><br>
		<b>Connection...</b><% java.sql.Connection conn = java.sql.DriverManager.getConnection(dbUrl,dbUser,dbPwd); %><br>
		<b>Close...</b><% conn.close(); %><br>
		<b>Test ended ok</b><br><%
	} catch (Exception e) { %>
		<b>Ouch!!! Error:</b><br><%
		java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
		e.printStackTrace(new java.io.PrintStream(bout));
		%><pre><%= bout.toString() %></pre><%
	} 		
} %>


</body>
</html>