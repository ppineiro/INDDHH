<%@page import="com.dogma.bean.security.UserBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.UserBean"></jsp:useBean><%


try{
String xml = dBean.getProfilesXML(request.getParameter("name"),request.getParameter("exactMatch"));
System.out.println(xml);
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
out.clear();
out.print(xml);

} catch (Exception e) {e.printStackTrace();}
%>