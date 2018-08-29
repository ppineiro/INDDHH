<%@page import="biz.statum.sdk.util.StringUtil"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@include file="_commonValidate.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Security server information</title>
	
	<style type="text/css">
		<%@include file="_commonStyles.jsp" %>
		
		table tr td.header { background-color: black; color: white; font-weight: bold; text-align: center; }
		table tr td.even { background-color: #EBEBEB; }
		table tr td { padding: 2px; }
		table tr td.common { vertical-align: baseline; text-align: center; }
		
		.container { background-color: #FFFFFF; position: fixed; top: 0; width: 100%; margin: 0; border-bottom: 1px solid black; }
		.resultContent { margin-top: 40px; }
		input.small { width: 80; }
	</style>

	<%@include file="_commonInclude.jsp" %>
		
	<script type="text/javascript">
		<%@include file="_commonScript.jsp" %>
	</script>
</head>
<body>

	<%@include file="_commonLogin.jsp" %>

	<% if (_logged) {

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
		
		<div class="container">
			<form method="post">
				Host: <input type="text" name="host" value="<%= ((host == null)?"":host)%>">
				Port: <input type="text" name="port" value="<%= ((port == -1)?"":Integer.toString(port))%>" class="small">
				<input type="submit" value="Query">
				<%@include file="_commonLogout.jsp" %>
			</form>
		</div>
		
		<div class="resultContent"><%
			if (host != null && port != -1) {
				try {
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
						out.print("<table cellpading=\"0\" cellspacing=\"0\">");
						out.print("<tr><td class='header'>Units</td><td class='header'>Free</td></tr>");
						boolean even = true;
						while (itun.hasNext()) {
							String unit  = (String)itun.next();
							String group = unit.substring(0, unit.indexOf("="));
							String size  = unit.substring(unit.indexOf("=") + 1);
				
							// We tidy the group description
							group = com.st.util.StringUtil.replaceAll(group, "&", ", "); %>
							<tr>
								<td class="common <%= even ? "even" : ""%>"><%=group%></td>
								<td class="common <%= even ? "even" : ""%>""><%=size%></td>
							</tr><%
							even = ! even;
						}
						out.print("</table>");
						out.print("<br><br>");
					}
				
					cliSocket.close();
				
					//------------------------------------------------------------------------
					
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
					    	int count = 0;
							java.util.Iterator itun = units.iterator(); %>
							<table cellpadding="0" cellspacing="0">
								<tr><td colspan="9" class="header"><b>Sessions</b></td></tr>
								<tr>
									<td class="header"><b>Aplication</b></td>
									<td class="header"><b>Host</b></td>
									<td class="header"><b>Port</b></td>
									<td class="header"><b>HTTP Session Id</b></td>
									<td class="header"><b>Module</b></td>
									<td class="header"><b>Functionality</b></td>
									<td class="header"><b>Login</b></td>
									<td class="header"><b>Last update</b></td>
									<td class="header"><b>Time to recycle</b></td>
								</tr><%
								boolean even = true;
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
										<td class="common <%= even ? "even" : ""%>"><%=sesent.getApplication()%></td>
										<td class="common <%= even ? "even" : ""%>"><%=sesent.getHost()%></td>
										<td class="common <%= even ? "even" : ""%>"><%=sesent.getPort()%></td>
										<td class="common <%= even ? "even" : ""%>"><%=sesent.getSessionid()%></td>
										<td class="common <%= even ? "even" : ""%>"><%=sesent.getModule()%></td>
										<td class="common <%= even ? "even" : ""%>"><%=sesent.getFunctionality()%></td>
										<td class="common <%= even ? "even" : ""%>"><%=sesent.getLogin()%></td>
										<td class="common <%= even ? "even" : ""%>"><%=sesent.getLastUpdate()%></td>
										<td class="common <%= even ? "even" : ""%>"><%=recyleOn%></td>
									</tr><%
									count ++;
									even = ! even;
								} %>
							</table>
							<br>
							Total users: <b><%= count %></b><br><%
				    	} else {
				    		out.print("NO SESSOIN DATA");
				    	}
				    }
					
					cliSocket.close();
				} catch (Exception e) {
					out.print(StringUtil.toString(e, true));
				}
			} %>
		</div><%
	} %>
</body>
</html>