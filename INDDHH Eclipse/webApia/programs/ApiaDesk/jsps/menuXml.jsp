<%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.st.util.StringUtil"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);
response.setContentType("text/xml");%><jsp:useBean id="bLogin" scope="session" class="com.dogma.bean.security.LoginBean"></jsp:useBean><%
String strXml = bLogin.getUserTreeView(request);
out.clear();
out.println(XMLUtils.transform(bLogin.getEnvId(request),strXml,"/programs/ApiaDesk/jsps/tocDesk.xsl"));
%>