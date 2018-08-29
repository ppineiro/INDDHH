<%@page import="com.dogma.vo.*"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.st.util.labels.LabelManager"%>
<%@page import="java.util.*"%>
<%@page import="com.dogma.vo.custom.ProDefinitionVo"%>
<%@page import="uy.com.st.adoc.expedientes.constantes.Mensajes" %>
<%@include file="../page/includes/startInc.jsp" %>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<HTML> 
<head>
<style type="text/css">
	#defMsgBtn { margin-bottom: 8px; padding-bottom: 1px; height: 29px; width: 120px; color: #000; background-color: #f7f7f7; font-family: Tahoma, Verdana, Arial;	font-size: 8pt; border: 1px solid silver; border-radius: 3px;	margin-left: 0px; margin-right: 0px; }
	#defMsgBtn:active { vertical-align: top; padding: 4px 6px 3px; }
	#defMsgBtn:hover { background-color: #eeeeee; }	
</style>
</head>
<body>
<%
int currentLang = 1;
String forType = request.getParameter("forType"); //TIPO_EXP o TIPO_ACT
String evt = request.getParameter("evt"); //(1) atraso o (2) alerta
if ("1".equals(evt)){
	evt = "atraso";
}else evt = "alarma";

String defaultMessage = Mensajes.getMsgByLenguaje(Mensajes.MSG_PLAZOS_TIPO_EXP_DEFAULT,currentLang);
if (!"TIPO_EXP".equals(forType)){
	defaultMessage = Mensajes.getMsgByLenguaje(Mensajes.MSG_PLAZOS_TIPO_ACT_DEFAULT,currentLang);
}

String msg = request.getParameter("msg");
if (msg==null || "".equals(msg) || "-".equals(msg)) {
	msg = defaultMessage;
}
UserData uData = ThreadData.getUserData();
String labelSet = uData.getStrLabelSetId();
%>
<!--     - USUARIOS A SER NOTIFICADOS          -->
	<TABLE class="pageTop">
		<COL class="col1"><COL class="col2">
		<TR>
			<TD style= "font-size: 18px"><strong>Notificación de <%=evt%></strong></TD>
			<TD></TD>
		</TR>
	</TABLE>
	<DIV id="divContent" class="divContent">
		<form id="frmMain" name="frmMain" method="POST" target="frmSubmit" onSubmit="return false">	
			<IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME>
			<!--  <iframe name="iframeMessages" id="iframeMessages" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" style="display:none"  class="feedBackFrame" frameborder="no"  ></iframe>-->

			Texto del mensaje:<br>
			<textarea cols="55" rows="4" name="txtMes" id="txtMes" accesskey="Texto del mensaje"><%=msg%></textarea><br>
			<br>
			<%=LabelManager.getName(labelSet,"lblProMenTok1") %>
			<%=LabelManager.getName(labelSet,"lblTskMenTok3") %>
			<%=LabelManager.getName(labelSet,"lblProMenTok2") %>
			
		</form>		
	</div>	
	<TABLE class="pageBottom">
	   	<COL class="col1"><COL class="col2">
	   		<tr>
	   			<td>
	   				<button type="button" id="defMsgBtn" style="min-height: 29px; hight:auto; width:100%;" onclick="btnDefMessage_click()" accessKey="<%=LabelManager.getAccessKey(labelSet,"btnDefMes")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDefMes")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDefMes")%></button>
				</td>
				<td>
					<!--  <button type="button" onclick="btnConfMessage_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button>-->
					<!-- <button type="button" onclick="btnExitMessage_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button>-->
	   			</td>
	   		</tr>
   	</table>
</html>

<SCRIPT>
  DEFAULT_MESSAGE = "<%=defaultMessage%>";
  var FORCE_SYNC = true;
  function btnDefMessage_click() {
	document.getElementById("txtMes").value = DEFAULT_MESSAGE;
  }

  /*function btnConfMessage_click() {
  	window.returnValue=document.getElementById("txtMes").value;
	window.close();
  }	

  function btnExitMessage_click() {
	window.returnValue=null;
	window.close();
  }*/
  
  function getModalReturnValue(modal) {
		var texto = document.getElementById("txtMes").value;								
		modal.setearTexto(texto);
		return true;					
	}
</script>