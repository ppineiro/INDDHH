<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@page import="com.dogma.ws.*"%>

<html>
<head><title>TestWs</title></head>
<body>

<form>
Address: <input type="text" name="wsAddress">(Example: http://10.4.40.59:8080/Gucoeu/services/ApiaWS)<br>
Service name: <input type="text" name="wsName">(Example: ApiaWS)<br>
Environment: <input type="text" name="envName"><br>
User <input type="text" name="user"><br>
Password <input type="text" name="pwd"><br>
Test <select name="test"><option></option><option value="class">Business Class</option><option value="query">Query</option></select><br>
Name <input type="text" name="toTestName"><br>
<input type="submit" value="test">
</form>
<% 

String wsAddress 	= request.getParameter("wsAddress");
String wsName 		= request.getParameter("wsName");
String test 		= request.getParameter("test");
String envName 		= request.getParameter("envName");
String toTestName 	= request.getParameter("toTestName");
String user 		= request.getParameter("user");
String pwd 			= request.getParameter("pwd");

if (wsAddress != null && ! "".equals(wsAddress)) { %>
	Address: <b><%= wsAddress %></b><br>
	Service name: <b><%= wsName %></b><br>
	Environment: <b><%= envName %></b><br>
	User: <b><%= user %></b><br>
	Password: <b><%= pwd %></b><br>
	Test: <b><%= test %></b><br>
	Name: <b><%= toTestName %></b><br>
	<br>
	Createing object...<br><%
	ApiaWsTester tester = new ApiaWsTester(wsAddress,wsName); 
	try { %>
		Executing test...<br><%
		String result = null;
		if ("class".equals(test)) {
			result = tester.testBusClass(envName,toTestName,user,pwd);
			
		} else if ("query".equals(test)) {
			result = tester.testQuery(envName,toTestName,user,pwd);
		} else {
			result = tester.testBusClass(envName,toTestName,user,pwd);
		} %>
		Result: <br><textarea cols="80" rows="40"><%= result %></textarea><br>
		Aditional message: <%= tester.getAdditionalMessage() %><br><%
	} catch (Exception e) { %>
		<b>Ouch!!! Error:</b><br><%
		java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
		e.printStackTrace(new java.io.PrintStream(bout));
		%><pre><%= bout.toString() %></pre><br>
		Aditional message: <%= tester.getAdditionalMessage() %><%
	}
} %>
</form>

</body>
</html>