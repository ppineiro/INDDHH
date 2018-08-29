<%@page import="java.util.Date"%><%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><head><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"><title>APIA E-mail configuration test</title></head><body>

Parameters: 
MailHost: <%=com.dogma.Parameters.MAIL_HOST%><br>
MailSmtpHost: <%=com.dogma.Parameters.MAIL_SMTP_HOST%><br>
MailSmtpUser: <%=com.dogma.Parameters.MAIL_SMTP_USER%><br>
MailFrom: <%=com.dogma.Parameters.MAIL_FROM%><br>
MailUser: <%=com.dogma.Parameters.MAIL_USER%><br>
MailRequireAuth: <%=com.dogma.Parameters.MAIL_REQUIERE_AUTH%><br><br>

Sending e-mail to <b><%= request.getParameter("email") %></b>: <%

if (request.getParameter("email") != null) {
	String[] to = {request.getParameter("email")};
	String subject = "APIA E-mail configuration test";
	String message = "This is an e-mail from Apia";
	Date start = new Date();
	Date end;
	try {
	    com.dogma.util.DogmaUtil.sendMail(to,new String[0],new String[0],subject,message,null); %>
	    E-mail send<br><%
	} catch (Exception e) { %><b>error</b><br><pre><%
			java.io.ByteArrayOutputStream byteArrayOut = new java.io.ByteArrayOutputStream();
			java.io.PrintWriter printWriter = new java.io.PrintWriter(byteArrayOut);
			e.printStackTrace(printWriter);
			printWriter.flush();
			out.print(byteArrayOut.toString());%></pre><%
	} finally {
		end = new Date();
	} %>
	Start: <%= start %><br>
	End: <%= end %><br><%
} else { %>
Use ?email=xxxxxxx
<% } %></body></html>