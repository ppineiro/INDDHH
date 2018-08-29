<%@page import="com.dogma.Configuration"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<script type="text/javascript">

var token = '<%=request.getParameter("token")%>';

</script>
</head>
<body>
<%
	String tarea = request.getParameter("tarea");
	String nroDocumento = request.getParameter("nroExp");
%>

<iframe id="frame" scrolling="no" height="200px" src="<%=ConfigurationManager.getServerAddress(1001, 1) + Configuration.ROOT_PATH%>/ServletDescargaFoliadoExpedientes?tipo=FOLIADO&nroExp=<%=nroDocumento%>&tarea=<%=tarea%>&token=<%=request.getParameter("token")%>"style="visibility: hidden"> 
</iframe>

</body>
</html>