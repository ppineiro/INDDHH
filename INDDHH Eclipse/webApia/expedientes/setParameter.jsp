<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="org.apache.axis.session.Session"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.dogma.UserData"%>
<% 
try {	
	//recieve server name from caller
	String serverName = request.getParameter("serverName").toString();	
	//get the session's user data	
	UserData ud = ThreadData.getUserData();
	HashMap<String,Object> p = ud.getUserAttributes();
	if (p == null) {
		p = new HashMap<String,Object>();
		ud.setUserAttributes(p);
	}
	p.put(ConfigurationManager.PARAM_HOST_ADDRESS,serverName);
	//request.getSession().setAttribute(Parameters.SESSION_ATTRIBUTE, ud);
	//System.out.println("saving server name "+serverName+" for session "+ud.getSessionId());
} catch (Exception e) {
	System.out.println( "ERROR en getParameter.jsp: " );	
	e.printStackTrace(); 
}		
%>
