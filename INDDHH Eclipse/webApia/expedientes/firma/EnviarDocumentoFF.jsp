<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="uy.com.st.adoc.expedientes.firmaDSS.Values"%>
<%@page import="uy.com.st.adoc.expedientes.firmaDSS.RequestDSSController"%>
<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%>
<%@page import="com.dogma.controller.ThreadData"%>

<%
//no dejamos que la pagina se cache
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
%>
<%
String targetURL = Values.targetURL;
String requestData = "";

String tipo = request.getParameter("tipo");
String nroExp = request.getParameter("nroExp");
System.out.println("tipo="+ tipo);

String TAB_ID_REQUEST = RequestDSSController.obtenerValueHashTabIdRequestFF(nroExp);


	if (request.getParameter("REQUEST_USR_SIGN_DATA_FF")!=null){
		requestData = TAB_ID_REQUEST;
		RequestDSSController.sacarValueHashTabIdRequestFF(nroExp);
	}else{
		System.out.println( "NO HAY DATOS EN SESSION 3" );
	}


%>
<head>
<title>Servicio de Firma Digital</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<script type="text/javascript">
	function submit() {
		document.form.submit();
	}
	window.onload = submit;
</script>

</head>
<body>
	<form action="<%=targetURL%>" method="post" name="form">
		<input type="hidden" name="SignRequest" value="<%=requestData%>" />
		<noscript>
			<input type="submit" value="Enviar documento para firmar" />
		</noscript>
	</form>
</body>
</html>