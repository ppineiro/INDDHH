<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@ page import="uy.com.st.adoc.expedientes.helper.Helper" %>
<%@page import="uy.com.st.adoc.expedientes.domain.Usr"%>
<%@page import="uy.com.st.adoc.log.LogDocumentum"%>
<%@page import="java.util.ArrayList"%>


<% 
try {

	Helper h = new Helper();
	
	String unidad = request.getParameter("unidad").toString();
	String flag = request.getParameter("flag").toString();

	ArrayList<Usr> arrUsr = h.cargarUsuarios(unidad);
	
	out.print("<table>");
	for (int i=0; i<arrUsr.size();i++){		
		
		out.print("<tr>");
		out.print("<td>");		
		if (flag.equals("true")){
			out.print("<input type='checkbox' onclick='desChequearUsuarios(this)' id='checkbox2' name='" + arrUsr.get(i).getUsrLogin() + "' value='" + arrUsr.get(i).getUsrLogin() + "'></td><td>");	
		}		
		out.print("<font style='FONT-FAMILY: verdana; FONT-SIZE: 8pt;'><img src='images/user.gif' WIDTH='16' HEIGHT='16'>" + arrUsr.get(i).getUsrName() + "</font>");
		out.print("</td>");
		out.print("</tr>");
				
	}
	
	out.print("<table>");
		
} catch (Exception e) {	
	LogDocumentum.error(e.getMessage(), e);	
}		
%>
