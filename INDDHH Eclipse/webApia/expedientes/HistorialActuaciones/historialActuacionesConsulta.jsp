<%@page import="com.dogma.vo.*"%>
<%@page import="com.dogma.vo.filter.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.*"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Historial"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Titulares"%>
<%@page import="uy.com.st.adoc.expedientes.dao.HistorialActuacionDao"%>
<%@page	import="uy.com.st.adoc.expedientes.dao.HistorialActuacionConsultaDao"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@include file="../page/includes/startInc.jsp" %>
<HTML> 
<head>
<!--  <%@include file="../../../components/scripts/server/headInclude.jsp" %>-->
<% boolean canOrderBy = false; %>

<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setDateHeader("Expires",-1); 
	
	String styleDirectory = "default";
	Integer environmentId = null;
	Integer currentLanguage = null;
	MensajeDAO mensajeDao = new MensajeDAO();
	
	UserData uData = ThreadData.getUserData();
	if (uData!=null) {
		environmentId = uData.getEnvironmentId();
		currentLanguage = uData.getLangId();
		styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
	}
	
	String strNroExp = request.getParameter("NroExp");
	String strTabla = "";
	String msgError = "";
	strTabla = "<TR>";
	strTabla = strTabla + "<TD  class='readOnly' rowspan='1' colspan='1' title='' value='' style='color:;'></TD>";
	strTabla = strTabla + "<TD  class='readOnly' rowspan='1' colspan='1' title='' value='' style='color:;'></TD>";
	strTabla = strTabla + "</TR>";
	
	String strAsunto = "";
	
	String strOfiAct = "";
	
	String strTablaTit = "";
	strTablaTit = "<TR>";
	strTablaTit = strTablaTit + "<TD  class='readOnly' rowspan='1' colspan='1' title='' value='' style='color:;'></TD>";
	strTablaTit = strTablaTit + "<TD  class='readOnly' rowspan='1' colspan='1' title='' value='' style='color:;'></TD>";
	strTablaTit = strTablaTit + "</TR>";
	
	String strFchUltPase = "";
	
%>
<head>
<script type="text/javascript">

		function buscar(){			
			var nroExp = document.getElementById("nroExp").value;
			document.getElementById("frmMain").submit();
			return true;
		}
		
		
		
		
		function btnPrint_click() {


			try {
				if (!beforePrintFormsData_E()) {
					return;
				}
			} catch (e){}
			try {
				if (!beforePrintFormsData_P()) {
					return;
				}
			} catch (e){}
			


			var modal=openModal("/frames/blank.jsp", 680,400);
			function submitPrint(){
				document.getElementById("printForm").submit();
			    document.getElementById("printForm").body.value = "";
		    }
		    modal.onload=function(){
		    	submitPrint();
		    }
			var selectedTab = null;
			var divContentHeight = document.getElementById("divContent").style.height;
			//document.getElementById("divContent").style.height = "";
			document.getElementById("printForm").body.value = "";
			document.getElementById("printForm").body.value = processBodyToPrint();
		   //document.getElementById("divContent").style.height = divContentHeight;

		    //styleWin.focus();
			document.getElementById("printForm").target=modal.content.name;//"Print";
			
				
			try {
				if (!afterPrintFormsData_E()) {
					return;
				}
			} catch (e){}
			try {
				if (!afterPrintFormsData_P()) {
					return;
				}
			} catch (e){}
			
		}
		
	</script>

<%
			Enumeration parNames = request.getParameterNames();
			String result = "";
			String nroExp = request.getParameter("nroExp");
			if(nroExp==null)
				nroExp="";
			
			strTabla = "<TR>";
			strTabla = strTabla + "<TD  class='readOnly' rowspan='1' colspan='1' title='' value='' style='color:;'></TD>";
			strTabla = strTabla + "<TD  class='readOnly' rowspan='1' colspan='1' title='' value='' style='color:;'></TD>";
			strTabla = strTabla + "</TR>";
			
			HistorialActuacionConsultaDao oHAD = new HistorialActuacionConsultaDao();
			
			ArrayList<Historial> arrHistorial = (ArrayList<Historial>) oHAD.obtenerHistorial(nroExp,environmentId,currentLanguage);
			Iterator<Historial> ite = arrHistorial.iterator();
			
			strTabla = "";
			
			
			if (nroExp != "" && !ite.hasNext()){
				msgError = mensajeDao.obtenerMensajePorCodigo("MSG_EXPEDIENTE_NO_EXISTE_EN_SISTEMA_JSP", currentLanguage, environmentId); //"No existe ese expediente en el sistema.";
			}else{
				
				if (nroExp != "")
				msgError = mensajeDao.obtenerMensajePorCodigo("MSG_EXPEDIENTE_ENCONTRADO_EN_SISTEMA_JSP", currentLanguage, environmentId); //"Expediente encontrado.";
				else
					msgError = "";
				
			}
			
			while(ite.hasNext()){
				Historial oHistorial = ite.next();
				strTabla = strTabla + "<TR>";
				strTabla = strTabla + "<TD  class='readOnly' rowspan='1' colspan='1' title='' value='" + oHistorial.getStrOficina() + "' style='color:;'>" + oHistorial.getStrOficina() + "</TD>";
				strTabla = strTabla + "<TD  class='readOnly' rowspan='1' colspan='1' title='' value='" + oHistorial.getStrFecha() + "' style='color:;'>" + oHistorial.getStrFecha() + "</TD>";
				strTabla = strTabla + "</TR>";
				strFchUltPase = oHistorial.getStrFecha();
			}
			
			strAsunto = oHAD.obtenerAsuntoExpediente(nroExp,environmentId);
			strOfiAct = oHAD.obtenerOficinaActualExpediente(nroExp,environmentId);
			
			
			ArrayList<Titulares> arrTits = (ArrayList<Titulares>) oHAD.obtenerTitularesExpediente(nroExp,environmentId);
			Iterator<Titulares> iteTits = arrTits.iterator();
			
			strTablaTit = "";
			
			while(iteTits.hasNext()){
				Titulares oTitular = iteTits.next();
				strTablaTit = strTablaTit + "<TR>";
				strTablaTit = strTablaTit + "<TD  class='readOnly' rowspan='1' colspan='1' title='' value='" + oTitular.getTipo() + "' style='color:;'>" + oTitular.getTipo() + "</TD>";
				strTablaTit = strTablaTit + "<TD  class='readOnly' rowspan='1' colspan='1' title='' value='" + oTitular.getTitular() + "' style='color:;'>" + oTitular.getTitular() + "</TD>";
				strTablaTit = strTablaTit + "<TD  class='readOnly' rowspan='1' colspan='1' title='' value='" + oTitular.getNombre() + "' style='color:;'>" + oTitular.getNombre() + "</TD>";
				strTablaTit = strTablaTit + "<TD  class='readOnly' rowspan='1' colspan='1' title='' value='" + oTitular.getNroDocumento() + "' style='color:;'>" + oTitular.getNroDocumento() + "</TD>";
				strTablaTit = strTablaTit + "</TR>";
			}
			
		%>

</HEAD>
<body class="listBody">
		<TABLE class="pageTop">
		<COL class="col1"><COL class="col2">
			<TR>
				<TD><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TITULO_BUSQUEDA_EXPEDIENTE_HIST_JSP", currentLanguage, environmentId)%><!--  Búsqueda de Expedientes--></TD>
				<TD></TD>
			</TR>
		</TABLE>
		
		<DIV id="divContent" class="divContent">
			<form id="frmMain" name="frmMain" method="POST"><BR>
<table class="frmSubTit">
	<tr>
		<td><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TITULO_INFORMACION_EXPEDIENTE_HIST_JSP", currentLanguage, environmentId)%><!--  Información del Expediente--></td>
	</tr>
</table>
<TABLE width="100%">
	<TR>
		<TD align="RIGHT" width=15%>
		<%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_NRO_EXPEDIENTE_HIST_JSP", currentLanguage, environmentId)%><!--  Número de expediente: -->
		</TD>
		<TD align="left" width=75%>
		<input type="text" id="nroExp"
			name="nroExp" value=<%=nroExp%>>
		<button type="button" value="Buscar expediente" onclick="buscar()">
		<%= mensajeDao.obtenerMensajePorCodigo("MSG_VAL_BTN_BUSCAR_HIST_JSP", currentLanguage, environmentId)%><!--Buscar expediente--></button>
		<strong> <%=msgError%></strong>
		</TD>
	</TR>

	<TR>
		<TD align="RIGHT">
		<%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_ASUNTO_EXPEDIENTE_HIST_JSP", currentLanguage, environmentId)%><!--Asunto: -->
		</TD>
		<td><textarea rows="5" cols="100" disabled><%=strAsunto%></textarea></td>
	</TR>

	<TR>
		<TD align="RIGHT">
		<%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_OFICINA_ACTUAL_HIST_JSP", currentLanguage, environmentId)%><!--Oficina Actual: -->
		</TD>
		<td>
		<input type="text" disabled id="strOfiAct" style="width:300px" name="strOfiAct" value='<%=strOfiAct%>'>
		</td>
	</TR>
	<TR>
		<TD align="RIGHT">
		<%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_FECHA_ULTIMO_HIST_JSP", currentLanguage, environmentId)%><!--Fecha de último pase: -->
		</TD>
		<td>
		<input type="text"
			disabled id="fchUltPase" style="width:300px" name="fchUltPase"
			value='<%=strFchUltPase%>'>
		</td>
	</TR>

	<TR>
		<TD colspan='7' align="left">
		<div type="grid" style="height: 200px;" id="gridListfrm1">
		<table rules="all" cellpadding="0"
			cellspacing="0">
			<thead id="tHeadList">
				<tr>
					<th style='width: 250px' title='Tipo de titular'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TIPO_TITULAR_HIST_JSP", currentLanguage, environmentId)%><!--Tipo de Titular--></th>
					<th style='width: 250px' title='Titular'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TITULAR_HIST_JSP", currentLanguage, environmentId)%><!--Titular--></th>
					<th style='width: 250px' title='Nombre del titular'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_NOMBRE_TITULAR_HIST_JSP", currentLanguage, environmentId)%><!--Nombre del titular--></th>
					<th style='width: 250px' title='Documento del titular'> <%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_DOCUMENTO_TITULAR_HIST_JSP", currentLanguage, environmentId)%><!--Documento del titular--></th>
				</tr>
			</thead>
			<tbody id='tblBdyfrm_E_1055_4'>
				<%=strTablaTit%>
			</tbody>
		</table>
		</div>
	</TR>

	<COL class='col1'>
	<COL class='col2'>
	<BR>
	<table class="frmSubTit">
		<tr>
			<td><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TITULO_HSTORIAL_EXPEDIENTE_HIST_JSP", currentLanguage, environmentId)%><!--Historial del Expediente--></td>
		</tr>
	</table>
	<BR>
	<TR>
		<TD colspan='7' align="left">
		<div type="grid" id='gridListfrm2' style="height: 200px;" gridTitle=''>
		<table cellpadding="0" cellspacing="0" hasFiles='false'>
			<thead>
				<tr>
					<th style='width: 350px' title='Oficina Actuante'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_OFICINA_ACTUANTE_HIST_JSP", currentLanguage, environmentId)%><!--Oficina Actuante--></th>
					<th style='width: 250px' title='Fecha Actuación'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_FECHA_ACTUACION_HIST_JSP", currentLanguage, environmentId)%><!--Fecha	Actuación--></th>
				</tr>
			</thead>
			<tbody id='tblBdyfrm_E_1055_4' isPaged='false'>
				<%=strTabla%>
			</tbody>
		</table>
		</div>
	</TR>
</TABLE>
</form>
		</DIV>
		<form style="display:none" id="printForm" name="printForm" method="post" action="<%=Parameters.ROOT_PATH%>/frames/print.jsp" target="_blank"><input type="hidden" name="body" id="body"></form>
		<TABLE class="pageBottom">
		<COL class="col1"><COL class="col2">
			<TR>
				<TD></TD>
				<TD><button id="btnPrint"  onclick="btnPrint_click()" accesskey="I" title="Imprimir"><%= mensajeDao.obtenerMensajePorCodigo("MSG_BTN_IMPRIMIR_HIST_JSP", currentLanguage, environmentId)%><!--<U>I</U>mprimir--></button><button type="button" onclick="splash()" accesskey="S" title="Salir"><%= mensajeDao.obtenerMensajePorCodigo("MSG_BTN_SALIR_HIST_JSP", currentLanguage, environmentId)%><!--Salir--></button></TD>
			</TR>
		</TABLE>
</body>
</html>
<%@include file="../../../components/scripts/server/endInc.jsp" %>

<iframe name="iframeMessages" id="iframeMessages" style="display:none"></iframe>
<script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/administration/tasks/list.js'></script>
<script language="javascript" src='<%=Parameters.ROOT_PATH%>/scripts/modalController.js'></script>