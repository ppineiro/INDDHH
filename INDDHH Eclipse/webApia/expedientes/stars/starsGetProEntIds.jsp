<%@page import="uy.com.st.adoc.expedientes.static_values.StaticProIds"%>
<%@page import="uy.com.st.adoc.expedientes.static_values.StaticEntIds"%>

<%
	String pro_name = "PREGUNTAS_A_USUARIOS";
	String ent_name = "PREGUNTAS_A_USUARIOS";
	
	String ids = StaticProIds.getProId(pro_name) + ";" + StaticEntIds.getEntId(ent_name);
	response.getWriter().write(ids);
%>
