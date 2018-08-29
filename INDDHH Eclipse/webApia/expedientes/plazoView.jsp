<%@page import="com.dogma.vo.*"%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@include file="../../components/scripts/server/startInc.jsp" %>
<%@page import="java.util.ArrayList"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.controller.ThreadData"%>

<HTML>
<head>
<%@include file="../../components/scripts/server/headInclude.jsp" %>
<%
	String indxIdStr = request.getParameter("indxId");
	indxIdStr = indxIdStr.replace(".","");
	Integer indxId = Integer.valueOf(indxIdStr);
	
	String tipoNumStr = request.getParameter("tipoNum");
	tipoNumStr = tipoNumStr.replace(".","");
	Integer tipoNum = Integer.valueOf(tipoNumStr);
	
	String useFor = request.getParameter("for");
	int env_id = 0;
	UserData userData = ThreadData.getUserData();
	if (userData!=null) {
		env_id = userData.getEnvironmentId();
	}
	
	Helper h = new Helper();
	// arr = [Nombre, Dias(s), Horas(s), Notificar por, Notificar a]
	String [] arr = h.getPlazoInformation(tipoNum, indxId, useFor, env_id);
	String nomPlazo;
	String dias;
	String horas;
	String notificarPor;
	String notificarA;
	String grupos;
	if (arr!=null && arr.length > 0){
		nomPlazo = arr[0];
		dias = arr[1];
		horas = arr[2];
		notificarPor = arr[3];
		notificarA = arr[4];
		grupos= arr[5];
	}else {
		return;
	}
      
%>
</head>
<body>
	<TABLE class="pageTop">
		<COL class="col1"><COL class="col2">
		<TR>
			<TD>Plazos y alarmas</TD>
			<TD></TD>
		</TR>
	</TABLE>
	<div id="divContent">
	<DIV class="subTit"><%=LabelManager.getName(labelSet,"txtAnaGenData")%></DIV>
		<table class="tblFormLayout">
			<tr>
				<td width="100px" align="right" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td>
				<td class=readOnly><%out.print(nomPlazo);%></td>
			</tr>
			<tr>
				<td width="100px"  align="right" title="<%=LabelManager.getToolTip(labelSet,"lblDay")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDay")%>:</td>
				<td class=readOnly style="width:600px;"><%out.print(dias);%></td>
			</tr>
			<tr>
				<td width="100px"  align="right" title="<%=LabelManager.getToolTip(labelSet,"lblHour")%>"><%=LabelManager.getNameWAccess(labelSet,"lblHour")%>:</td>
				<td class=readOnly style="width:600px;"><%out.print(horas);%></td>
			</tr>
			<tr>
				<td width="100px"  align="right" title="Método de notificación">Notificar por:</td>
				<td class=readOnly style="width:600px;"><%out.print(notificarPor);%></td>
			</tr>
			<tr>
				<td width="100px"  align="right" title="A quien se debe notificar">Notificar a:</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td class=readOnly style="width:600px;">
					<%if (notificarA.contains("1")){%><li>Usuario actual</li><%}%>
					<%if (notificarA.contains("2")){%><li>Usuario creador del expediente</li><%}%>
					<%if (notificarA.contains("3")){%><li>Oficina actual</li><%}%>
					<%if (notificarA.contains("4")){%><li>Oficina creadora del expediente</li><%}%>
					<%if (grupos!=null && !"".equals(grupos)){
						String gruposArr [] = grupos.split(";");
						for (int i=1;i<gruposArr.length;i=i+2){%>
							<li><%=gruposArr[i] %></li>
						<%}
					} %>
				</td>
			</tr>
		</table>
	</div>
	<TABLE class="pageBottom">
		<COL class="col1"><COL class="col2">
		<TR>
			<!--  
			<TD></TD>
			<TD>
				<button type="button" id="exit" onclick="window.close()" accesskey="S" title="Salir"><U>S</U>alir</button>
			</TD>
			-->
		</TR>
	</TABLE>
	
</body>
</html>
<%@include file="../../components/scripts/server/endInc.jsp" %>