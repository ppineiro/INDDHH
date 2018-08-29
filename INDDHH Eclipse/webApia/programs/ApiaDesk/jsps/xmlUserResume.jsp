<%@page import="com.st.util.*"%><%response.setDateHeader("Expires",-1);
response.setContentType( "application/xml" );
response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);
out.print("<?xml version=\"1.0\" encoding=\"utf-8\"?><resume>"+request.getAttribute("xmlUserResume")+"</resume>");%>
