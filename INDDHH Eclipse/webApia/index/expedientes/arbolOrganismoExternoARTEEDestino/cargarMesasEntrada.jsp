<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@ page import="uy.com.st.adoc.expedientes.helper.Helper" %>
<%@page import="uy.com.st.adoc.expedientes.domain.Nodo"%>
<%@page import="uy.com.st.adoc.log.LogDocumentum"%>
<%@page import="java.util.ArrayList;"%>
<%@page import="com.dogma.controller.ThreadData"%>
<% 

response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

try {

	Helper h = new Helper();
	int envId = 1001;
	int langId = 1;
	String orgext = request.getParameter("orgext").toString();
	UserData uData = ThreadData.getUserData();
	String esConf = "0";
	if (uData != null){
		 esConf = (String)uData.getUserAttributes().get("CONFIDENCIAL_EXPEDIENTE");
		 envId = uData.getEnvironmentId();
		 langId = uData.getLangId();
	}
	
	ArrayList<Nodo> arrMesaEntrada = h.cargarMesasEntrada(orgext,esConf,envId,langId);
	Nodo nodo = null;
	out.print("<table>");
	for (int i=0; i<arrMesaEntrada.size();i++){		
		nodo = arrMesaEntrada.get(i);
		out.print("<tr>");
		out.print("<td>");
		out.print("<input type='radio' onclick='desChequearMesa(this)' id='checkbox2' name='" + nodo.getPoolName() + "' value='" + nodo.getPoolDesc()  + "'></td><td>");	
		out.print("<font style='FONT-FAMILY: verdana; FONT-SIZE: 8pt;'><img src='");
		if (nodo.getUsrName().equalsIgnoreCase("CONF")){
			out.print("images/bandeja_conf_small.gif");
		}else{
			out.print("images/bandeja_small.gif");	
		}
		out.print("' WIDTH='16' HEIGHT='16'>" + nodo.getPoolDesc() + "</font>");
		out.print("</td>");
		out.print("</tr>");
				
	}
	
	out.print("<table>");
		
} catch (Exception e) {
	LogDocumentum.error(e.getMessage(), e);
}		
%>
