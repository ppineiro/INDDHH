<%@page import="java.util.Collection"%>
<%@page import="uy.com.st.adoc.expedientes.vo.TipoExpediente"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Hashtable"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<%

Hashtable<String, Hashtable<String,ArrayList<TipoExpediente>>> att = (Hashtable<String, Hashtable<String,ArrayList<TipoExpediente>>>)request.getSession().getAttribute("TIPO_EXPEDIENTE_OFICINA");

out.write("Tamaño de hash: " + att.size() + "<br/>" );

Collection<Hashtable<String, ArrayList<TipoExpediente>>> valores = att.values();

for(Hashtable<String, ArrayList<TipoExpediente>> value : valores) {
	out.write("\tTamaño de hash interno: " + value.size() + "<br/>" );

	Collection<ArrayList<TipoExpediente>> valores2 = value.values();

	for(ArrayList<TipoExpediente> value2 : valores2) {
		out.write("\t\tTamaño de arraylist: " + value2.size() + "<br/>" );
	}
	
}

%>

</body>
</html>