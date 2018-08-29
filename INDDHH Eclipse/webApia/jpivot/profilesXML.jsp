<%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.Parameters"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%@page import="com.dogma.EnvParameters"%><%@page import="com.st.util.XMLUtils"%><%@page import="java.net.URL"%><%
out.clear();
if (request.getAttribute("profilesXML")!=null){
	String profilesXML=request.getAttribute("profilesXML").toString();
	out.println(profilesXML);
}
%>