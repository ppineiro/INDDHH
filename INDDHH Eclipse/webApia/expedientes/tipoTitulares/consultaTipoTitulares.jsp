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
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="com.dogma.busClass.ApiaAbstractClass" %>
<%@include file="../../../components/scripts/server/startInc.jsp" %>
<HTML> 
<head>
<%@include file="../../../components/scripts/server/headInclude.jsp" %>
<% boolean canOrderBy = false; %>

<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setDateHeader("Expires",-1); 
	
	String tipoTitular = request.getParameter("tipoTitular");
	String strNroExp = request.getParameter("NroExp");
	
	UserData uData = ThreadData.getUserData();
	int environmentId = uData.getEnvironmentId();
	int langId = uData.getLangId();
	String styleDirectory = uData.getUserStyle();
	ApiaAbstractClass aac = (ApiaAbstractClass) uData.getUserAttributes().get("aac");
	
	MensajeDAO mensajeDao = new MensajeDAO();
	
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
<script language="javascript">
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
			
			ArrayList<Historial> arrHistorial = (ArrayList<Historial>) oHAD.obtenerHistorial(nroExp,environmentId,langId);
			Iterator<Historial> ite = arrHistorial.iterator();
			
			strTabla = "";
			
			
			if (nroExp != "" && !ite.hasNext()){
				msgError = mensajeDao.obtenerMensajePorCodigo("MSG_EXPEDIENTE_NO_EXISTE_EN_SISTEMA_JSP", langId, environmentId); //"No existe ese expediente en el sistema.";
			}else{
				
				if (nroExp != "")
				msgError = mensajeDao.obtenerMensajePorCodigo("MSG_EXPEDIENTE_ENCONTRADO_EN_SISTEMA_JSP", langId, environmentId); //"Expediente encontrado.";
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
				<TD><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TITULO_BUSQUEDA_TITULARES_JSP", langId, environmentId)%><!--  Búsqueda de Tipo de Titulares--></TD>
				<TD></TD>
			</TR>
		</TABLE>
		
		<DIV id="divContent" class="divContent">
			<form id="frmMain" name="frmMain" method="POST"><BR>
<table class="frmSubTit">
	<tr>
		<td><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_FILTROS_TITULARES_HIST_JSP", langId, environmentId)%><!--  Filtros para buscar titulares--></td>
	</tr>
</table>
<TABLE width="100%">
	
	
	
	<TD align="RIGHT" width=15%>
		<%="Tipo Titular"%><!--  Nombre Filtro jesimo: -->
		</TD>
		<TD align="left" width=75%>
		<input type="text" id="TipoTitular"
			name="TipoTitular" value=<%=tipoTitular%>>
		</TD>
	
	<% for (int j = 0; j < 10; j++){ %>
	<TR>
		<TD align="RIGHT" width=15%>
		<%="hola"+j%><!--  Nombre Filtro jesimo: -->
		</TD>
		<TD align="left" width=75%>
		<input type="text" id="paramEntrada<%=j%>"
			name="paramEntrada<%=j%>" value=<%=nroExp%>>
		</TD>
	</TR>

	<% } %>

	<TR>
		<TD align="RIGHT">
		<button type="button" value="Buscar expediente" onclick="buscar()">
		<%= mensajeDao.obtenerMensajePorCodigo("MSG_VAL_BTN_BUSCAR_TITULARES_JSP", langId, environmentId)%><!--Buscar titulares--></button>
		<strong> <%=msgError%></strong>
		</TD>
	</TR>
	
	<BR>
	<table class="frmSubTit">
		<tr>
			<td><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_RESULTADO_CONSULTA_TITULARES_JSP", langId, environmentId)%><!--  Filtros para buscar titulares--></td>
		</tr>
	</table>
	<BR>
	
	
	<TR>
		<TD colspan='7' align="left">
		<div type="grid" style="height: 200px;" id="gridListfrm1">
		<table rules="all" cellpadding="0"
			cellspacing="0">
			<thead id="tHeadList">
				<tr>
					<% int cont = 0; for (cont = 0; cont < 5; cont++){ %>
					<th style='width: 250px' title='resultadoTit_<%=cont%>'><%="chau"+cont%><!--Tipo de Titular--></th>
					<% } %>
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
</TABLE>
</form>
		</DIV>
		<form style="display:none" id="printForm" name="printForm" method="post" action="<%=Parameters.ROOT_PATH%>/frames/print.jsp" target="_blank"><input type="hidden" name="body" id="body"></form>
		<TABLE class="pageBottom">
		<COL class="col1"><COL class="col2">
			<TR>
				<TD></TD>
				<TD><button id="btnSeleccionar"  onclick="btnSeleccionar_click()" accesskey="I" title="Seleccionar"><%= mensajeDao.obtenerMensajePorCodigo("MSG_BTN_SELECCIONAR_TITULARES_JSP", langId, environmentId)%><!--<U>I</U>mprimir--></button><button id="btnPrint"  onclick="btnPrint_click()" accesskey="I" title="Imprimir"><%= mensajeDao.obtenerMensajePorCodigo("MSG_BTN_IMPRIMIR_HIST_JSP", langId, environmentId)%><!--<U>I</U>mprimir--></button><button type="button" onclick="splash()" accesskey="S" title="Salir"><%= mensajeDao.obtenerMensajePorCodigo("MSG_BTN_SALIR_HIST_JSP", langId, environmentId)%><!--Salir--></button></TD>
			</TR>
		</TABLE>
</body>
</html>
<%@include file="../../../components/scripts/server/endInc.jsp" %>

<iframe name="iframeMessages" id="iframeMessages" style="display:none"></iframe>
<script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/administration/tasks/list.js'></script>
<script language="javascript" src='<%=Parameters.ROOT_PATH%>/scripts/modalController.js'></script>