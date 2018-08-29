<%@page import="com.st.util.email.EmailQueueSenderWebsphereMQ"%><%@page import="com.st.util.email.EmailData"%><%
EmailData emailData = new EmailData();
%><%
emailData.setMessage("hola");
%><%
emailData.setFrom("yo");
%><%
emailData.setSenderMail("tu@tu.com");
%><%
emailData.setHost("pepe");
%><%
emailData.setSubject("no se");
%><%
EmailQueueSenderWebsphereMQ.sendMesage(emailData);
%>

