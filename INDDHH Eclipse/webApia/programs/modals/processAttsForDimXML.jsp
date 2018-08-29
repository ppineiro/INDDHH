<%@page import="com.dogma.bean.administration.ProcessBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ProcessBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = "";
if ("1".equals(request.getParameter("opt"))){ //Atributos redundantes
	xml = dBean.getRedAttsForTreeXML(request); //Devuelve los atributos redundantes del proceso
}else if ("2".equals(request.getParameter("opt"))){//Tareas y subProcesos del proceso
	xml = dBean.getSubProAndTskForTreeXML(new Integer(request.getParameter("proId")), request);//Devuelve tareas y subProcesos del proceso
}else if ("3".equals(request.getParameter("opt"))){//Formularios de entidad
	xml = dBean.getEntFormsForTreeXML(new Integer(request.getParameter("proId")), new Integer(request.getParameter("proEleId")), request);//Devuelve los formularios de entidad
}else if ("4".equals(request.getParameter("opt"))){//Formularios de proceso
	xml = dBean.getProFormsForTreeXML(new Integer(request.getParameter("proId")), new Integer(request.getParameter("proEleId")), request);//Devuelve las formularios de proceso
}else if ("5".equals(request.getParameter("opt"))){//Atributos de un formulario de entidad
	xml = dBean.getAttsForTreeXML(new Integer(request.getParameter("frmId")),request);//Devuelve los formularios de la tarea pasada por parametro
}else if ("6".equals(request.getParameter("opt"))){//Atributos de un formulario de proceso
	xml = dBean.getAttsForTreeXML(new Integer(request.getParameter("frmId")),request);//Devuelve los atributos del formulario (de proceso) pasado por parametro
}else if ("7".equals(request.getParameter("opt"))){ //Formulario
	//xml = dBean.getEntFormAttsForTreeXML(new Integer(request.getParameter("frmId")),request);//Devuelve los atributos del formulario (de la entidad) pasado por parametro
}else if ("8".equals(request.getParameter("opt"))){//Procesos de la entidad (en jerarquia)
	//xml = dBean.getProFathersForTreeXML(request);//Devuelve solo los procesos padres
}else if ("9".equals(request.getParameter("opt"))){//Procesos de la entidad (en jerarquia)
	//xml = dBean.getSubProAndTskForTreeXML(new Integer(request.getParameter("proId")),request);//Devuelve subprocesos y tareas de cierto proceso
}


out.clear();
out.print(xml);
%>