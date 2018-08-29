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
	String envId = request.getParameter("envId").toString();
	
	ArrayList<Usr> arrUsr = h.cargarUsuarios(unidad, Integer.valueOf(envId));
	
	out.print("<table>");
	
	out.print("<tr>");
	out.print("<td>");		
	//if (flag.equals("true")){
		//out.print("<input type='checkbox' onclick='desChequearUsuarios(this)' id='checkbox2' name='gino' value='gino'>");	
	//}		
	//out.print("<font style='FONT-FAMILY: verdana; FONT-SIZE: 8pt;'><img src='images/user.gif' WIDTH='16' HEIGHT='16'>gino</font>");
	//out.print("</td>");
	//out.print("</tr>");
	
	for (int i=0; i<arrUsr.size();i++){		
		
		out.print("<tr>");
		out.print("<td>");		
		if (flag.equals("true")){
			//out.print("<input type='checkbox' onclick='desChequearUsuarios(this)' id='" + arrUsr.get(i).getUsrLogin() + "' name='" + arrUsr.get(i).getUsrLogin() + "' value='" + arrUsr.get(i).getUsrLogin() + "'>");	
			out.print("<input type='checkbox' onclick='desChequearUsuarios(this)' id='" + arrUsr.get(i).getOficina()+ "#" + arrUsr.get(i).getUsrLogin() + "' name='" + arrUsr.get(i).getOficina()+ "#" + arrUsr.get(i).getUsrLogin() + "' value='" + arrUsr.get(i).getOficina()+ "#" + arrUsr.get(i).getUsrLogin() + "'></td><td>");	
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
