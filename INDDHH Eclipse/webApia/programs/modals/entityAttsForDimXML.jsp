<%@page import="com.dogma.bean.administration.EntitiesBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.EntitiesBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = "";
if ("1".equals(request.getParameter("opt"))){ //Atributos redundantes
	xml = dBean.getRedAttsForTreeXML(request); //Devuelve los atributos redundantes
}else if ("2".equals(request.getParameter("opt"))){//Formularios de la entidad
	xml = dBean.getEntFormsForTreeXML(request);//Devuelve los formularios de la entidad
}else if ("3".equals(request.getParameter("opt"))){//Procesos de la entidad
	xml = dBean.getTskEntFormsForTreeXML(new Integer(request.getParameter("proId")), new Integer(request.getParameter("proEleId")), request);//Devuelve los formularios de entidad
}else if ("6".equals(request.getParameter("opt"))){//Formulario
	xml = dBean.getAttsForTreeXML(new Integer(request.getParameter("frmId")),request);//Devuelve los atributos del formulario (de proceso) pasado por parametro
}else if ("7".equals(request.getParameter("opt"))){ //Formulario
	xml = dBean.getEntFormAttsForTreeXML(new Integer(request.getParameter("frmId")),request);//Devuelve los atributos del formulario (de la entidad) pasado por parametro
}else if ("8".equals(request.getParameter("opt"))){//Procesos de la entidad (en jerarquia)
	xml = dBean.getProFathersForTreeXML(request);//Devuelve solo los procesos padres
}else if ("9".equals(request.getParameter("opt"))){//Procesos de la entidad (en jerarquia)
	xml = dBean.getSubProAndTskForTreeXML(new Integer(request.getParameter("proId")),request);//Devuelve subprocesos y tareas de cierto proceso
}


out.clear();
out.print(xml);
%>