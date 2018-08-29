<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.expedientes.qrBarcode.ValidadorBarCode"%>
<%@page import="uy.com.st.adoc.expedientes.qrBarcode.ResultadoValidadorBarCode"%>
<%@page import="uy.com.st.adoc.expedientes.util.Digest"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Historial"%>
<%@page import="uy.com.st.adoc.expedientes.dao.HistorialActuacionDao"%>
<%@page import="java.util.ArrayList" %>

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
<div class="datagrid"><table>

<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setDateHeader("Expires",-1); 

	MensajeDAO mensajeDao = new MensajeDAO();	
	
	Digest dgst= new Digest();
	UserData uData = ThreadData.getUserData();
	int envId = uData.getEnvironmentId();
	int langId = uData.getLangId();
	
	String encriptado = request.getParameter("param");
	String param = null;
	if(encriptado!=null){
		param = dgst.decryptBarCode(encriptado);		
	}
	ResultadoValidadorBarCode resultado = null;
	String nroExp = "";
	String actuacion = "";
	String usr = "";
	ValidadorBarCode vbc = new 	ValidadorBarCode();
	if(param!=null){
		
		String[] partido=param.split("#VAR=");	
		System.out.println("------Validación BarCode------");
		nroExp = partido[1];
		System.out.println("nroExp: "+ nroExp);
		actuacion = partido[2];
		System.out.println("actuacion: "+ actuacion);
		usr = partido[3];
		System.out.println("usr: "+ usr);
		
		resultado = vbc.validarBarCodeActuacion(nroExp,actuacion,usr, envId, langId);
		//resultado.setValido(true);		
	}	
	
	//out.print("<caption><img src=../.."+vbc.getImgSplashPath(envId)+" width=75% height='auto' align='middle'>");
	String urlImg = ConfigurationManager.getDirGetLogoCaratula(envId, langId, false);

	out.print("<caption><img src="+urlImg+">");
	
	if (resultado!=null && resultado.esValido() ) {		

		HistorialActuacionDao oHAD = new HistorialActuacionDao();
		ArrayList<Historial> arrHistorial = null;
		String oficina="";
		String fecha="";
		String folios="";
		try{
			arrHistorial = (ArrayList<Historial>) oHAD.obtenerHistorial(nroExp,envId,langId);
			Historial hActual=arrHistorial.get(Integer.parseInt(actuacion));
			oficina=hActual.getStrOficina();
			String ini=hActual.getStrPaginaInicio();
			String fin=hActual.getStrPaginaFin();
			if(ini!=null){
				folios=ini;
				if(fin!=null){
					folios=folios +" - "+fin;
				}
			}
			fecha=arrHistorial.get(Integer.parseInt(actuacion)).getStrFecha();
		}catch(Exception e){
			out.println(e.getMessage());
			e.printStackTrace();
		}		
%>


<!-- <TABLE class="pageTop"> -->
<!-- 	<COL class="col1"><COL class="col2"> -->
<!-- 		<TR> -->
<!-- 			<TD><b>Resultado de QR Correcto</b>< %= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TITULO_BUSQUEDA_EXPEDIENTE_HIST_JSP", langId, environmentId)%>  Búsqueda de Expedientes</TD> -->
<!-- 			<TD></TD> -->
<!-- 		</TR> -->
<!-- </TABLE> -->

		
		</caption>
<tbody>
	<tr class="alt">
	<td>
		Expediente:
				</td>
				<td>
				<%=nroExp%>
				</td>
	</tr>
	<tr class="alt">
		<td>Nro Actuación:</td>
		<td><%=actuacion%></td>
	</tr>
	<tr class="alt">
		<td>Funcionario:</td>
		<td><%=usr%></td>
	</tr>
	
	<tr class="alt">
		<td>Oficina:</td>
		<td><%=oficina%></td>
	</tr>
	<tr class="alt">
		<td>Folios:</td>
		<td><%=folios%></td>
	</tr>
	
	<tr class="alt">
		<td>Fecha:</td>
		<td><%=fecha%></td>
	</tr>
	
	
	<tr>
				<td> </td>
				<td>La actuacion es válida <img src="../validarFirma/img/Certificado-OK.png" width=33px height=33px align="middle"></td>
				<%} else {
					out.println("<tr><td>");
					out.println("<b>Resultado de QR Incorrecto</b> <br><br>");
					out.println("El resultado no concuerda con la validación del sistema. <br>");
				%>
				</td>
				</tr>
				<tr>
				<td>
				<img src="../validarFirma/img/Certificado-Invalido-Modific.png" width=75px height=75px align="right">
				<%} %>
				</td>
				</tr>
	

</tbody>
</table></div>


</body>
</html>

	