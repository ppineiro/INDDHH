<%@page import="com.dogma.Configuration"%>
<%
String cod_tramite=request.getParameter("cod_tramite").toString();
session.setAttribute("URL_TRAMITE", "/page/externalAccess/open.jsp?logFromSession=true&onFinish=102&env=1&type=P&entCode=1006&proCode=1033&eatt_STR_TRM_COD_TRAMITE_STR="+cod_tramite+"&external=true");
String authType="";
if (request.getParameter("modoAut")!=null){
	
	String modoAut = request.getParameter("modoAut").toString();	
	if(modoAut.equals("2")) {
 		// Solo registro
	  	authType="&authType=";
	} else if (modoAut.equals("3")){
		// Solo cédula
	  	authType="&authType=CI";
	}	
}
System.out.println(Configuration.ROOT_PATH+"/coesys.response"+authType);
//response.sendRedirect(Configuration.ROOT_PATH+"/coesys.response"+authType);
response.sendRedirect(Configuration.ROOT_PATH+"/coesys.response?modoExterno=true" + authType );
 %>