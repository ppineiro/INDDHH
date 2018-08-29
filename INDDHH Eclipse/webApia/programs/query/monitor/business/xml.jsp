<%@page import="java.util.*"%><%@page import="com.apia.query.extractors.ElementVo"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorBusinessBean"></jsp:useBean><%
response.setContentType("xml/text");
String xml=dBean.getXml();
xml="<monitor>"+xml+"</monitor>";
System.out.println("\n \n "+xml+"\n \n");
out.clear();
out.print(xml);
%>