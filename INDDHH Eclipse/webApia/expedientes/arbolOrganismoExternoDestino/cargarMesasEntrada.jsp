<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@ page import="uy.com.st.adoc.expedientes.helper.Helper" %>
<%@page import="uy.com.st.adoc.expedientes.domain.Nodo"%>
<%@page import="uy.com.st.adoc.log.LogDocumentum"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.dogma.controller.ThreadData"%>

<% 
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

try {
	UserData uData = ThreadData.getUserData();
	int envId = uData.getEnvironmentId();
	int langId = uData.getLangId();
	
	Helper h = new Helper();	
	String orgext = request.getParameter("orgext").toString();	
	String esConf = "0";
	String confidencial = "";
	Boolean viene_pase_masivo = false;
	
	if (uData != null){
		 
		//FIXME: ESTO SE HACE PARA QUE SE LISTEN OK ME SI EXPS SELECCIONADOS SON CONF O NO (HOY ESTA LISTANDO TODAS).
		 confidencial = (String)uData.getUserAttributes().get("EXPEDIENTES_A_PASAR_PM");
		 System.out.println("cargarMesasEntrada: -> "+ confidencial);
		 
		 if(confidencial != null){
			 viene_pase_masivo = true;
			 if(confidencial.equals("true")){
				 esConf = "2";
			 }else if(confidencial.equals("false")){
				 esConf = "1";
			 }
		 }else{
			System.out.println("esConf -------->");
			esConf = (String)uData.getUserAttributes().get("CONFIDENCIAL_EXPEDIENTE");
			System.out.println("esConf "+ esConf);
		 }
		 
		 envId = uData.getEnvironmentId();
		 langId = uData.getLangId();
	}
	
	ArrayList<Nodo> arrMesaEntrada = null;
	if(viene_pase_masivo){
		arrMesaEntrada = h.cargarMesasEntradaPaseMasivo(orgext,esConf,envId,langId);
	}else{
		System.out.println("Entra OK en cargarMesaEntrada!");
		arrMesaEntrada = h.cargarMesasEntrada(orgext,esConf,envId,langId);
	}
		
	Nodo nodo = null;
	out.print("<table>");
	for (int i=0; i < arrMesaEntrada.size();i++){		
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
	e.printStackTrace();
	LogDocumentum.error(e.getMessage(), e);
}		
%>
