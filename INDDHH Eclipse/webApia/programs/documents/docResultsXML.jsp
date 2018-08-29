<%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%
response.setContentType("text/xml");
DogmaAbstractBean dBean = (DogmaAbstractBean) session.getAttribute("dBean");
out.clear();
if (dBean != null) {
	out.print(dBean.getMessagesAsXml(request));
	dBean.clearMessages();
}
%>