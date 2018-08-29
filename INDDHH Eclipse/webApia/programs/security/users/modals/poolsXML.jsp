<%@page import="java.util.HashMap"%><%@page import="com.dogma.bean.security.UserBean"%><%@page import="com.dogma.Parameters"%><%
try{
UserBean bean = null;
String windowID = request.getParameter("windowId");
System.out.println(windowID);
HashMap beansHash = null;
//obtener el hash de beans
if(windowID!=null){
	if(request.getSession().getAttribute("beansHash")!=null){
		beansHash = (HashMap)request.getSession().getAttribute("beansHash");
	} else {
		beansHash = new HashMap();
		request.getSession().setAttribute("beansHash",beansHash);
	}
}
 

if (request.getSession().getAttribute("dBean") instanceof UserBean) {
	bean = (UserBean) request.getSession().getAttribute("dBean");
}else if(windowID!=null){
	bean = (UserBean)beansHash.get(windowID);
	
}

String desc = null;
if(request.getParameter("desc")!=null && request.getParameter("desc").length() >0){
	desc = request.getParameter("desc");
}

response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml"); 
String xml = bean.getPoolsXML(request.getParameter("name"),request.getParameter("exactMatch"),desc);

out.clear();
out.print(xml);
}catch(Throwable e){
	
	e.printStackTrace();
}
%>