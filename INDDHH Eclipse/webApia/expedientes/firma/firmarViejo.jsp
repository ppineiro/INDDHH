<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="java.util.HashMap"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Firma"%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@page import="uy.com.st.adoc.expedientes.helper.HelperFirma"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationApplet"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
%>
<%
UserData uData = ThreadData.getUserData();
/*
HashMap hm = uData.getUserAttributes(); 
hm.put("ASUNTO", "ASUNTO");
hm.put("TMP_NRO_DOC_A_FIRMAR_STR", "TMP_NRO_DOC_A_FIRMAR_STR");
hm.put("JEFATURA", "JEFATURA");
hm.put("TMP_ARCHIVO_A_FIRMAR_1_STR", "TMP_ARCHIVO_A_FIRMAR_1_STR");
hm.put("TMP_NOMBRE_ARCHIVO_A_FIRMAR_1_STR", "TMP_NOMBRE_ARCHIVO_A_FIRMAR_1_STR");
hm.put("CI", "36479710");
uData.setUserAttributes(hm);
*/
String nombreFormulario = "FRM_MAIN";

String ASUNTO = (String)uData.getUserAttributes().get("ASUNTO");
String TMP_NRO_DOC_A_FIRMAR_STR = (String)uData.getUserAttributes().get("TMP_NRO_DOC_A_FIRMAR_STR"); 	
String USUARIO = uData.getUserId();
String JEFATURA = (String)uData.getUserAttributes().get("JEFATURA");
String APIA_SERVIDOR = ConfigurationManager.getServerAddress() + Configuration.ROOT_PATH;
String CI = (String)uData.getUserAttributes().get("CI");

String applet = "<center>\n"+
		"<APPLET " + 
			"id='appletFirma' " + 
			"CODE='" + ConfigurationApplet.APPLET_FIRMA_CODE + "' " +
			"ARCHIVE='" + ConfigurationApplet.APPLET_FIRMA_ARCHIVE + "' " +
			"MAYSCRIPT " + 
			"HEIGH=300 " +  
			"WIDTH=500> \n" +
			"<PARAM name='FILE1' value='" + (String)uData.getUserAttributes().get("TMP_ARCHIVO_A_FIRMAR_1_STR") + "'> \n" + 
			"<PARAM name='FILE2' value=''> \n" +
			"<PARAM name='FILE3' value=''> \n" +
			"<PARAM name='FILE4' value=''> \n" +
			"<PARAM name='FILE5' value=''> \n" +
			"<PARAM name='FILE6' value=''> \n" +
			"<PARAM name='FILE7' value=''> \n" +
			"<PARAM name='FILE8' value=''> \n" +
			"<PARAM name='FILE9' value=''> \n" +
			"<PARAM name='FILE10' value=''> \n" +
			
			"<PARAM name='FILE11' value=''> \n" + 
			"<PARAM name='FILE12' value=''> \n" +
			"<PARAM name='FILE13' value=''> \n" +
			"<PARAM name='FILE14' value=''> \n" +
			"<PARAM name='FILE15' value=''> \n" +
			"<PARAM name='FILE16' value=''> \n" +
			"<PARAM name='FILE17' value=''> \n" +
			"<PARAM name='FILE18' value=''> \n" +
			"<PARAM name='FILE19' value=''> \n" +
			"<PARAM name='FILE20' value=''> \n" +
			
			"<PARAM name='FILE_NAME1' value='" + (String)uData.getUserAttributes().get("TMP_NOMBRE_ARCHIVO_A_FIRMAR_1_STR") + "'> \n" + 
			"<PARAM name='FILE_NAME2' value=''> \n" +
			"<PARAM name='FILE_NAME3' value=''> \n" +
			"<PARAM name='FILE_NAME4' value=''> \n" +
			"<PARAM name='FILE_NAME5' value=''> \n" +
			"<PARAM name='FILE_NAME6' value=''> \n" +
			"<PARAM name='FILE_NAME7' value=''> \n" +
			"<PARAM name='FILE_NAME8' value=''> \n" +
			"<PARAM name='FILE_NAME9' value=''> \n" +
			"<PARAM name='FILE_NAME10' value=''> \n" +
			
			"<PARAM name='FILE_NAME11' value=''> \n" + 
			"<PARAM name='FILE_NAME12' value=''> \n" +
			"<PARAM name='FILE_NAME13' value=''> \n" +
			"<PARAM name='FILE_NAME14' value=''> \n" +
			"<PARAM name='FILE_NAME15' value=''> \n" +
			"<PARAM name='FILE_NAME16' value=''> \n" +
			"<PARAM name='FILE_NAME17' value=''> \n" +
			"<PARAM name='FILE_NAME18' value=''> \n" +
			"<PARAM name='FILE_NAME19' value=''> \n" +
			"<PARAM name='FILE_NAME20' value=''> \n" +
			
			"<PARAM name='NOMBRE_FORMULARIO' value='" + nombreFormulario + "'> \n" +
			"<PARAM name='TIPO_ELEMENTO_A_FIRMAR' value=' la actuación'> \n" +
			"<PARAM name='CLAVE' value='" + CI + "'> \n" +					
			"<PARAM name='NRO_DOCUMENTO' value='" + TMP_NRO_DOC_A_FIRMAR_STR + "'> \n" +
			"<PARAM name='USUARIO' value='" + USUARIO + "'> \n" +
			"<PARAM name='JEFATURA' value='" + JEFATURA + "'> \n" +
			"<PARAM name='APIA_SERVIDOR' value='" + APIA_SERVIDOR + "'> \n" +					
		"</APPLET>\n" + 
		"</center>\n" + 
		"<iframe id='frmResultFirma' name='frmResultFirma' style='display:none'></iframe>";	
%>
<HTML>
<HEAD>
	<script  language="javascript">
		function Confirmar(){			
			window.returnValue = "OK";
			window.close();
		}
		
		function Cancelar(){		
			window.returnValue = "";
			window.close();
		}
		
		function habilitarConfirmar(){
			setTimeout("habilitar()", 5000);
		}
		
		function habilitar(){
			document.getElementById("btnConfirmar").disabled = false;
		}
		
	</script>	
</HEAD>
<BODY onload="habilitarConfirmar()">
<form name="FRM_MAIN" id="FRM_MAIN" method="post">
	<TABLE  class='tblFormLayout' border=0 >  
	<COL class='col1'><COL class='col2'><COL class='col3'><COL class='col4'> 
	<TR><TD></TD><TD></TD><TD></TD><TD></TD></TR> 
	<TR>
		<TD  rowspan='1' title='Asunto' style='color:black'>Asunto:</TD>
		<TD  class='readOnly' rowspan='1' colspan='1' title='' name='frm_E_1129_1530_S_1_F' id='FIRMA_TMP_ASUNTO_STR'  value="<%=ASUNTO%>" style="color:black;">
			<%=ASUNTO%>
		</TD>				
		<TD  rowspan='1' title='Nro Documento' style='color:black'>Nro Documento:</TD>
		<TD  class='readOnly' rowspan='1' colspan='1' title='' name='frm_E_1129_1531_S_1_F' id='FIRMA_TMP_NRO_DOC_A_FIRMAR_STR'  value="<%=TMP_NRO_DOC_A_FIRMAR_STR%>" style="color:black;">
			<%=TMP_NRO_DOC_A_FIRMAR_STR%>
		</TD>
	</TR> 
	<TR>
		<TD colspan='4' title=''>
			<DIV style='color:black' class='subTit' id='tit_FIRMA_0' name='frm_tit_E_1129_0_8_F'>
				<%=applet%>
			</DIV>	
		</TD>
	</TR>
	</TABLE>
	<br>
	<TABLE class="pageBottom">	
		<TR>			
			<TD align="right" width=100%>
				<button id="btnConfirmar" disabled onclick="Confirmar()" title="Aceptar">Aceptar</button>				
				<button id="btnCancelar" onclick="Cancelar()" title="Cancelar">Cancelar</button>
			</TD>	
		</TR>
	</TABLE>	
	
</form>	
</BODY>	
</HTML>
