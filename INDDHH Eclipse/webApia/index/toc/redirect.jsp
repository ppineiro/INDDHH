<%@page import="com.dogma.Parameters"%><%
String requestedUrl=request.getParameter("link");
if(request.getParameter("windowId")!=null){
	requestedUrl+="&windowId="+request.getParameter("windowId");
}
RequestDispatcher dis=request.getRequestDispatcher("/"+Parameters.ROOT_PATH+"/"+requestedUrl);
dis.forward(request,response);
%>
