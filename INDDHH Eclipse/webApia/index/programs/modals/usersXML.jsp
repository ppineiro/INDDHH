
<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="gBean" scope="session" class="com.dogma.bean.GenericBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = "";
if(request.getParameter("external")!=null && !"null".equals(request.getParameter("external"))){
	xml = gBean.getExternalUsersXML(request.getParameter("login"));
} else {
	if(request.getParameter("environment")!=null && !"null".equals(request.getParameter("environment"))){
		if("all".equals(request.getParameter("environment"))){
			xml = gBean.getUsersXML(request.getParameter("login"),request.getParameter("name"));
		} else {
			xml = gBean.getUsersXML(request.getParameter("login"),request.getParameter("name"), new Integer(request.getParameter("environment")));
		}
	}
	else if (request.getParameter("currentUser")!=null && !"null".equals(request.getParameter("currentUser"))){ 
		//gets the users in hierarchy for the logged user
		xml = gBean.getUsersByHierarchyXML(request.getParameter("login"),request.getParameter("name"), gBean.getEnvId(request), request.getParameter("currentUser"), request.getParameter("usrLogin"), gBean.getParDate(request, "startDate"), gBean.getParDate(request, "endDate"));
	}
	else if (request.getParameter("usrLogin")!=null && !"null".equals(request.getParameter("usrLogin"))){ 
		xml = gBean.getUsersSubstitutesXML(request.getParameter("login"),request.getParameter("name"), gBean.getEnvId(request), request.getParameter("usrLogin"), gBean.getParDate(request, "startDate"), gBean.getParDate(request, "endDate"));
	} 
	else {
		xml = gBean.getUsersXML(request.getParameter("login"),request.getParameter("name"), gBean.getEnvId(request));
	}
}

out.clear();
out.print(xml);
%>