<%

String SECURITY_USERNAME = "admin";
String SECURITY_PASSWORD = "admin30";

boolean _logged = "true".equals(request.getSession().getAttribute("securityToolsLogged"));
boolean _avoidLogout = "true".equals(request.getParameter("_avoidLogout"));

boolean _exit = "1".equals(request.getParameter("exit"));
if (_exit) {
	_logged = false;
	request.getSession().setAttribute("securityToolsLogged","false");
}

if (! _logged) {
	String user = request.getParameter("_secToolsLogin");
	String pwd = request.getParameter("_secToolsPassword");
	
	if((SECURITY_USERNAME.equals(user) && SECURITY_PASSWORD.equals(pwd))){
		_logged = true;
		request.getSession().setAttribute("securityToolsLogged","true");
	}
}

%>