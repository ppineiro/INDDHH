<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="java.util.ArrayList" %>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<HTML> 
<head>
<style type="text/css">
 table { 
    width: 40%; 
    height: 40%; 
    margin-left: 30%; 
    margin-right: 30%; 
    margin-top: 10%; 
    margin-bottom: 10%; 
    font-family: sans-serif; 
    text-align:left;
    color:navy;
    border:thick;
    border-top-style: double;
    border-bottom-style: double;
 } 

</style> 
</head>
<body class="listBody">
<div class="datagrid">

	<table>	
			<%
				response.setHeader("Pragma","no-cache");
				response.setHeader("Cache-Control","no-store");
				response.setDateHeader("Expires",-1); 		
				
				UserData uData = ThreadData.getUserData();
				int envId = uData.getEnvironmentId();
				int langId = uData.getLangId();
				
				String urlImg = ConfigurationManager.getDirGetLogoCaratula(envId, langId, false);
				out.print("<caption><img src="+urlImg+">");
			%>
			<center>
				<a href=<%MensajeDAO.reCargarMensajesEstaticos(envId, langId);%>>Recargar valores mensajes estáticos</a>								
			</center>
		</caption>
		
	</table>
</div>


</body>
</html>

	