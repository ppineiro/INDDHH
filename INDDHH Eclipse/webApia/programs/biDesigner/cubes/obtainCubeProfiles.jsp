<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.CubeBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String prfs = dBean.getCubeProfilesStrToEliminate(request);
out.clear();
out.print(prfs);
%>