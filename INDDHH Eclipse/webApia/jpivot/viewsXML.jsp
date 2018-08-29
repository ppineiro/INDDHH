<%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.Parameters"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%@page import="com.dogma.EnvParameters"%><%@page import="com.st.util.XMLUtils"%><%@page import="java.net.URL"%><%
out.clear();
if (request.getAttribute("viewXML") != null){
	String viewXML=request.getAttribute("viewXML").toString();
	System.out.println("viewXML \n \n "+viewXML);
	out.println(XMLUtils.transform(new Integer(1),viewXML,"/jpivot/viewsSort.xsl"));
}
%>