<%@page import="com.dogma.Parameters"%><jsp:useBean id="imagePickerBean" scope="session" class="com.dogma.bean.administration.ImagesBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
String strXml = imagePickerBean.getImagesXML(request);
out.clear();
out.println(strXml);
%>