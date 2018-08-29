<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>

<HTML>
<head>
<title>Datos Usuario <%="" %></title>

<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setDateHeader("Expires",-1); 
	
	String usr = request.getParameter("usuario");
	String langIdStr = request.getParameter("langId");
	String environmentIdStr= request.getParameter("environmentId");
	Integer langId = 1;
	Integer environmentId = 1001;
	MensajeDAO mensajeDao = new MensajeDAO();
	
	if (langIdStr != null){
		 langId = Integer.valueOf(langIdStr);
	}
	if (environmentId != null){
		environmentId = Integer.valueOf(environmentIdStr);
	}
	
	Helper h = new Helper();

	String login = h.obtenerValorAttributoNombreImg(usr,"A_LOGIN",environmentId, langId);
	String nombre = h.obtenerValorAttributoNombreImg(usr,"A_NOMBRE",environmentId, langId);
	String email = h.obtenerValorAttributoNombreImg(usr,"A_EMAIL",environmentId, langId);
%>
</head>

<body class="listBody">

<h3>Información Usuario <%=login%></h3>

<div>
	<table width="100%">
		<tr>
		<td width="50%" >
			<table width="100%">
				<tr  height="25%">
				<td width="25%">
				Nombre:
				</td>
				<td>
				<%=nombre%>
				</td>
				</tr>
				<tr  height="25%">
				<td width="25%">
				Email:
				</td>
				<td>
				<%=email %>
				</td>
				</tr>
				<tr  height="25%">
				<td width="25%">
				IdCertificado:
				</td>
				<td>
				10162131
				</td>
				</tr>
			</table>
		</td>
		<td width="50%">
			<table width="100%" border="1">
				<tr>
				<td width="100%">
				<img src="<%=new Helper().getFotoUsr(login,environmentId,langId)%>" width="100%" height=400px>
				</td>
				</tr>
			</table>
		</td>
		</tr>
	</table>
</div>


</body>
</HTML>