<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@ page import="uy.com.st.adoc.expedientes.helper.Helper" %>
<%@page import="uy.com.st.adoc.expedientes.domain.Usr"%>
<%@page import="java.util.ArrayList"%>

<% 
try {

	Helper h = new Helper();
	
	String unidad = request.getParameter("unidad").toString();
	String envId = request.getParameter("envId").toString();
	
	ArrayList<Usr> arrUsr = h.cargarUsuarios(unidad, Integer.valueOf(envId));
	
	out.print("<table>");
	for (int i=0; i<arrUsr.size();i++){		
		
		out.print("<tr>");
		out.print("<td>");
		out.print("<input type='radio' onclick='marcarUsr(this)' id='checkbox2' name='" + arrUsr.get(i).getUsrLogin() + "' value='" + arrUsr.get(i).getUsrLogin() + "'></td><td>");	
		out.print("<font style='FONT-FAMILY: verdana; FONT-SIZE: 8pt;'><img src='images/user.gif' WIDTH='16' HEIGHT='16'>" + arrUsr.get(i).getUsrLogin() + "</font>");
		out.print("</td>");
		out.print("</tr>");
				
	}
	
	out.print("<table>");
		
} catch (Exception e) {
	// TODO Auto-generated catch block
	System.out.println("ERROR: " + e.getMessage());
}		
%>
