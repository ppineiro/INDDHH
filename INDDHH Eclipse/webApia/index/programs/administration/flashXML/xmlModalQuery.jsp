<%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.st.util.StringUtil"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.FormBean"><%dBean.addMessage(new DogmaException(DogmaException.USR_NOT_LOGGED));%></jsp:useBean><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
response.setContentType("text/xml");
if (!dBean.hasMessages()) {
	out.clear();
	out.print(dBean.getModalQueryXML(request));
} else {
	out.print(dBean.getMessagesAsXml(request));
	dBean.clearMessages();
}
%>