<%@page import="com.dogma.Configuration"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="st.url.TramiteHelper"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.dogma.Parameters"%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-store");
response.setDateHeader("Expires", -1);
%>
<%
String id_tramite=request.getParameter("id_tramite").toString();

String authType="";
if (request.getParameter("modoAut")!=null){
	
	String modoAut = request.getParameter("modoAut").toString();	
	if(modoAut.equals("2")) {
 		// Solo registro
	  	authType="?authType=";
	} else if (modoAut.equals("3")){
		// Solo cédula
	  	authType="?authType=CI";
	}	
}

session.setAttribute("ID_TRAMITE", id_tramite);
session.setAttribute("URL_TRAMITE", "/page/externalAccess/workTask.jsp?logFromSession=true&onFinish=102&&env=1&lang=1&numInst=" + id_tramite + "&eatt_str_TRM_RETOMA_TRAMITE_STR=SI");
//session.setAttribute("URL_TRAMITE",ThreadData.getUserData().getUserAttributes().get("URL_RETOMA").toString());
response.sendRedirect(Configuration.ROOT_PATH+"/coesys.response?modoExterno=true"+authType);
 %>