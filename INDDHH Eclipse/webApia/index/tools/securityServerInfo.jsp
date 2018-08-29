<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Apia Fast Security Server Information</title>
</head>

<%

String host = request.getParameter("host");
int port = (request.getParameter("port") == null)?-1:Integer.parseInt(request.getParameter("port")); 

if (host == null && port == -1) {
	String hostPort = com.dogma.business.SecurityServerService.getInstance().getHostPort();
	if (hostPort != null && hostPort.indexOf(":") != -1) {
		String[] hostAndPort = com.st.util.StringUtil.split(hostPort,":");
		host = hostAndPort[0];
		port = Integer.parseInt(hostAndPort[1]);
	}
	
}

%>

<form method="post">
	Host: <input type="text" name="host" value="<%= ((host == null)?"":host)%>">
	Port: <input type="text" name="port" value="<%= ((port == -1)?"":Integer.toString(port))%>">
	<input type="submit" value="Query">
</form>

<%
if (host != null && port != -1) {
	String dataXmlUnits = "<request><operation name='getUnits'><data application='APIA' /></operation></request>";
	String dataXmlSessions = "<request><operation name='getSessions'><data application='' host='' port='' sessionid='' login='' module='' functionality='' /></operation></request>";
	
	java.net.Socket cliSocket = new java.net.Socket(host, port);
	java.io.OutputStream outStream = cliSocket.getOutputStream();
	java.io.BufferedOutputStream bos = new java.io.BufferedOutputStream(outStream);
	
	bos.write(dataXmlUnits.getBytes());
	bos.write("\n".getBytes());
	bos.flush();
	
	// Now we wait for an OK, NOK, or an exception from the server
	java.io.InputStream in = cliSocket.getInputStream();
	java.io.BufferedReader is = new java.io.BufferedReader(new java.io.InputStreamReader(in));
	String answer = is.readLine(); 
	
	out.println("<hr>");
	
	if (answer == null || !answer.startsWith("OK")) {
    	if (answer.indexOf("##") == -1) {
            out.print("[ERROR] Error executing operation: " + answer + "<br>");
    	} else {
    		String message = answer.substring(answer.indexOf("##") + 2);
    		
    		out.print("[ERROR] " + message + "<br>"); 
    	}
    } else {
    	String strData = answer.substring(2);
    	Object objData = com.st.util.Base64.decodeToObject(strData);
    	java.util.Collection units = (java.util.Collection) objData;
    	
		java.util.Iterator itun = units.iterator();
		out.print("<table border=\"1\" cellpading=\"0\" cellspacing=\"0\"><tr><td align=\"center\" colspan=\"2\"><b>Units</b></td></tr>");
		out.print("<tr><td align=\"center\"><b>Description</b></td><td><b>Free</b></td></tr>");
		while (itun.hasNext()) {
			String unit  = (String)itun.next();
			String group = unit.substring(0, unit.indexOf("="));
			String size  = unit.substring(unit.indexOf("=") + 1);

			// We tidy the group description
			group = com.st.util.StringUtil.replaceAll(group, "&", ", "); %>
			<tr>
				<td align="center" valign="baseline"><p><%=group%></p></td>
				<td align="center" valign="baseline"><p><%=size%></p></td>
			</tr><%
		}
		out.print("</table>");
    }

	cliSocket.close();

	//------------------------------------------------------------------------
	out.println("<hr>");
	
	cliSocket = new java.net.Socket(host, port);
	outStream = cliSocket.getOutputStream();
	bos = new java.io.BufferedOutputStream(outStream);
	
	bos.write(dataXmlSessions.getBytes());
	bos.write("\n".getBytes());
	bos.flush();
	
	// Now we wait for an OK, NOK, or an exception from the server
	in = cliSocket.getInputStream();
	is = new java.io.BufferedReader(new java.io.InputStreamReader(in));
	answer = is.readLine(); 	
	
	if (answer == null || !answer.startsWith("OK")) {
    	if (answer.indexOf("##") == -1) {
            out.print("[ERROR] Error executing operation: " + answer + "<br>");
    	} else {
    		String message = answer.substring(answer.indexOf("##") + 2);
    		
    		out.print("[ERROR] " + message + "<br>"); 
    	}
    } else {
    	String strData = answer.substring(2);
    	
    	if (! strData.equals("")) {
	    	Object objData = com.st.util.Base64.decodeToObject(strData);
	    	java.util.Collection units = (java.util.Collection) objData;
	    	
			java.util.Iterator itun = units.iterator();
			out.print("<table border=\"1\" cellpading=\"0\" cellspacing=\"0\"><tr><td colspan=\"9\" align=\"center\"><b>Sessions</b></td></tr>"); %>
			<tr>
				<td align="center"><b>Aplication</b></td>
				<td align="center"><b>Host</b></td>
				<td align="center"><b>Port</b></td>
				<td align="center"><b>HTTP Session Id</b></td>
				<td align="center"><b>Module</b></td>
				<td align="center"><b>Functionality</b></td>
				<td align="center"><b>Login</b></td>
				<td align="center"><b>Last update</b></td>
				<td align="center"><b>Time to recycle</b></td>
			</tr>
			 <%
			while (itun.hasNext()) {
				com.dogma.security.business.SessionEntry sesent = (com.dogma.security.business.SessionEntry) itun.next(); 
				long milis = sesent.getMilisToRecycle();
				long days = milis / 86400000;
				milis = milis % 86400000;
				long hours = milis / 3600000;
				milis = milis % 3600000;
				long minutes = milis / 60000;
				milis = milis % 60000;
				long seconds = milis / 1000;
				milis = milis % 1000;
				
				String recyleOn = days + "," + hours + "," + minutes + "," + seconds; %>
				<tr>
					<td align="center" valign="baseline"><%=sesent.getApplication()%></td>
					<td align="center" valign="baseline"><%=sesent.getHost()%></td>
					<td align="center" valign="baseline"><%=sesent.getPort()%></td>
					<td align="center" valign="baseline"><%=sesent.getSessionid()%></td>
					<td align="center" valign="baseline"><%=sesent.getModule()%></td>
					<td align="center" valign="baseline"><%=sesent.getFunctionality()%></td>
					<td align="center" valign="baseline"><%=sesent.getLogin()%></td>
					<td align="center" valign="baseline"><%=sesent.getLastUpdate()%></td>
					<td align="center" valign="baseline"><%=recyleOn%></td>
				</tr><%
			}
			out.print("</table>");
    	} else {
    		out.print("NO SESSOIN DATA");
    	}
    }
	
	cliSocket.close();
}
%>

<body>

</body>
</html>