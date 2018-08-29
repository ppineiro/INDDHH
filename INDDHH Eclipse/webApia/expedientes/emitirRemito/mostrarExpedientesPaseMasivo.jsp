<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="uy.com.st.adoc.expedientes.domain.LineaGrdExpPaseMasivoDP"%>
<%@page import="uy.com.st.adoc.expedientes.rollback.UtilRollback"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="com.dogma.controller.ThreadData"%>
<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setDateHeader("Expires",-1); 
	
	Integer environmentId = null;
	MensajeDAO mensajeDao = new MensajeDAO();
	int currentLanguage = 1;
	String styleDirectory = "default";

	
	UserData uData = ThreadData.getUserData();
	if (uData!=null) {
		environmentId = uData.getEnvironmentId();
		currentLanguage = uData.getLangId();
		styleDirectory = uData.getUserStyle();//EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
	}
	
	String strNroPaseMasivo = request.getParameter("NroPaseMasivo");
	System.out.println(strNroPaseMasivo);
	String strTabla = "";
	
	strTabla = "<TR>";
	strTabla = strTabla + "<TD  style='width:25%' valign='middle' align='center' class='readOnly' rowspan='1' colspan='1' title='' value='' style='color:;'></TD>";
	strTabla = strTabla + "<TD  style='width:50%' valign='middle' align='center' class='readOnly' rowspan='1' colspan='1' title='' value='' style='color:;'></TD>";
	strTabla = strTabla + "<TD  style='width:25%' valign='middle' align='center' class='readOnly' rowspan='1' colspan='1' title='' value='' style='color:;'></TD>";
/* 	strTabla = strTabla + "<TD  style='width:17%' valign='middle' align='center' class='readOnly' rowspan='1' colspan='1' title='' value='' style='color:;'></TD>";
	strTabla = strTabla + "<TD  style='width:17%' valign='middle' align='center' class='readOnly' rowspan='1' colspan='1' title='' value='' style='color:;'></TD>";
	strTabla = strTabla + "<TD  style='width:12%' valign='middle' align='center' class='readOnly' rowspan='1' colspan='1' title='' value='' style='color:;'></TD>";
 */	strTabla = strTabla + "</TR>";
	
	UtilRollback ur = new UtilRollback();	
	ArrayList<LineaGrdExpPaseMasivoDP> arrExp =  ur.cargarExpedientesDesdePaseMasivo("",environmentId,"",Integer.valueOf(strNroPaseMasivo),"", "", "") ;

	strTabla = "";
	
	for(int i = 0; i < arrExp.size(); i++){
		LineaGrdExpPaseMasivoDP linea = arrExp.get(i);
		strTabla = strTabla + "<TR>";
		strTabla = strTabla + "<TD  style='width:25%' valign='middle' align='center' class='readOnly' rowspan='1' colspan='1' title='' value='" + linea.getNroExpediente() + "' style='color:;'>" + linea.getNroExpediente() + "</TD>";
		strTabla = strTabla + "<TD  style='width:50%' valign='middle' align='center' class='readOnly' rowspan='1' colspan='1' title='' value='" + linea.getAsuntoExpediente() + "' style='color:;'>" + linea.getAsuntoExpediente() + "</TD>";
		strTabla = strTabla + "<TD  style='width:25%' valign='middle' align='center' class='readOnly' rowspan='1' colspan='1' title='' value='" + linea.getTipoExpediente() + "' style='color:;'>" + linea.getTipoExpediente() + "</TD>";
/* 		strTabla = strTabla + "<TD  style='width:17%' valign='middle' align='center' class='readOnly' rowspan='1' colspan='1' title='' value='" + linea.getOficinaDestinoPM() + "' style='color:;'>" + linea.getOficinaDestinoPM() + "</TD>";
		strTabla = strTabla + "<TD  style='width:17%' valign='middle' align='center' class='readOnly' rowspan='1' colspan='1' title='' value='" + linea.getUsuarioDestinoPM() + "' style='color:;'>" + linea.getUsuarioDestinoPM() + "</TD>";
		strTabla = strTabla + "<TD  style='width:17%' valign='middle' align='center' class='readOnly' rowspan='1' colspan='1' title='' value='" + linea.getFechaPase() + "' style='color:;'>" + linea.getFechaPase() + "</TD>";
 */		strTabla = strTabla + "</TR>";
	}

	
%>
<HTML>
<HEAD>
	<title><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TITULO_EXPEDIENTES_PASE_MASIVO_JSP", currentLanguage, environmentId)%><!--Historial de actuaciones--></title>
</HEAD>
<BODY>
<div id="divContent"  style="height:px" >
<form id="frmMain" name="frmMain" target="iframeResult" method="POST">
	<div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()" >
	<div type="tab" style="visibility:hidden" tabTitle="Formularios de la tarea" tabText="Forms. tarea">
		<script language="javascript" type="text/javascript" src="<%=Parameters.ROOT_PATH%>/scripts/tinymce/javascripts/tiny_mce/tiny_mce.js"></script>
		<script language="javascript" type="text/javascript">tinyMCE.init({mode : "exact",height : "350",width : "600",theme : "advanced",language : "es",plugins : "table,preview,advhr",theme_advanced_layout_manager : "SimpleLayout",theme_advanced_toolbar_location : "top",theme_advanced_buttons1 : "bold,italic,underline,separator,strikethrough,justifyleft,justifycenter,justifyright, justifyfull,separator,styleselect,formatselect,fontselect,fontsizeselect",theme_advanced_buttons2: "forecolor,backcolor,bullist,numlist,undo,redo,separator,preview,separator,table,separator,cut,copy,paste,separator,advhr,code",theme_advanced_buttons3: "",setupcontent_callback : "editor_setup"});</script><BR>
	</div>	
	<div type="tab" tabTitle='Historial de actuaciones' tabText='Historial de actuaciones'>
	<BR>
	<DIV id="divTitFrmNODO_DISTRIBUCION_ALTA" style="padding:0px;border:0px;margin:0px; display:block;" class="subTit">
	<table class="frmSubTit">
	<tr>
	<td><img src="<%=Parameters.ROOT_PATH%>/styles/Kzes_Next/images/plus.gif " auxSrc="<%=Parameters.ROOT_PATH%>/styles/Kzes_Next/images/minus.gif"><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_SUBTITULO_EXPEDIENTES_PASE_MASIVO_JSP", currentLanguage, environmentId)%><!--Historial de Actuaciones del Expediente--> <%=strNroPaseMasivo%></td>
</tr>
</table>

</DIV>

<input type=hidden name='hidFrm1055Closed' id='hidFrm1055Closed' value='false' >

<DIV id='divFrm1055_E' style=' display:block;' >
<DIV style='display:block;  display:block;' id="divFrm1055"  ajaxRefreshable='true'  titleId="divTitFrmNODO_DISTRIBUCION_ALTA" >

<!---------------------------- START FORM ----------------------------> 
<TABLE  class='tblFormLayout' border=0 > 
	<COL class='col1'>
	<COL class='col2'>
	<COL class='col3'>
	<COL class='col4'>
	<COL class='col5'> 
	<COL class='col6'> 
	<COL class='col7'>
	<TR> 
		<TD  colspan='7' align="left">
	
		<div type="grid" id='gridListfrm_E_1055_4' style="height:400px;width:100%"  gridTitle=''>
			<table name='NODO_DISTRIBUCION_ALTA_' class="tblDataGrid Grid" rules="all" cellpadding="0" cellspacing="0" hasFiles='false' isPaged='false' currentPage='1' recordsPerPage='7' totalRecords='3' fldId ='4' frmId ='1055' frmParent ='E' >
				<thead id="tHeadList">
					<tr>
						<th scope="col"  style='display:none;width:0px'></th>
						<th scope="col"  style='width:25%' title='Oficina Actuante'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_NRO_EXPEDIENTE_PM_JSP", currentLanguage, environmentId)%><!--Oficina actuante--></th>
						<th scope="col"  style='width:50%' title='Tipo Actuación'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_ASUNTO_PM_JSP", currentLanguage, environmentId)%><!--Tipo actuación--></th>
						<th scope="col"  style='width:25%' title='Confidencialidad'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TIPO_EXPEDIENTE_PM_JSP", currentLanguage, environmentId)%><!--Conf. o Acceso restringido--></th>
						<!-- <th scope="col"  style='width:17%' title='Nombre Firmante'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_OFICINA_DESTINO_PM_JSP", currentLanguage, environmentId)%></th>
						<th scope="col"  style='width:17%' title='Firmante'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_USUARIO_DESTINO_PM_JSP", currentLanguage, environmentId)%></th>
						<th scope="col"  style='width:12%' title='Fecha Actuación'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_FECHA_PASE_PM_JSP", currentLanguage, environmentId)%></th>  -->
					</tr>
				</thead>
				<tbody id='tblBdyfrm_E_1055_4' isPaged='false' >
					<%=strTabla%>
				</tbody>
			</table>
		</div>
	</TR>
</TABLE>
</BODY>
</HTML>
