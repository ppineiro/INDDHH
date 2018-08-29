<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@page import="com.dogma.controller.ThreadData"%>
<% 
try {
	
	com.dogma.UserData uData = ThreadData.getUserData();
	int environmentId = 0;	
	if (uData != null){
		environmentId =uData.getEnvironmentId();
	}
	
	String usr = request.getParameter("usr").toString();	
	Helper h = new Helper();
	h.desactivarLicencia(usr,environmentId);	
	out.print("Fuera de oficina desactivado!");	
	
} catch (Exception e) {
	out.print("Error: " + e.getMessage());	
	System.out.println("ERROR: " + e.getMessage());
}		
%>
