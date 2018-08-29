<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.custom.ProDefinitionVo"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><%
String forType = request.getParameter("forType"); //SUBJECT o MESSAGE o NOT_MESSAGE
String mesaggeFormat = request.getParameter("msgFormat"); //Formato del mensaje

if (mesaggeFormat == null || "".equals(mesaggeFormat) || "undefined".equals(mesaggeFormat)){
	if ("SUBJECT".equals(forType)){
		mesaggeFormat = LabelManager.getName(labelSet, "msgWidNotSubject");
	}else  {
		mesaggeFormat = LabelManager.getName(labelSet, "msgWidNotMessage");
	}
}
String titWindow = LabelManager.getName(labelSet, "titMsgSubject");
if (!"SUBJECT".equals(forType)) {
	if ("MESSAGE".equals(forType))	titWindow = LabelManager.getName(labelSet, "titMsgMessage");
	else titWindow = LabelManager.getName(labelSet, "titMsgNotMessage");
}

%><!--     - USUARIOS A SER NOTIFICADOS          --><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=titWindow%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" target="frmSubmit" onSubmit="return false"><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><iframe name="iframeMessages" id="iframeMessages" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" style="display:none"  class="feedBackFrame" frameborder="no"  ></iframe><%if ("SUBJECT".equals(forType)){%><%=LabelManager.getName(labelSet, "lblTexSubj")%>:<br><%}else{ %><%=LabelManager.getName(labelSet, "lblTexMen")%>:<br><%} %><textarea cols="90" rows="4" name="txtMes" id="txtMes"><%=mesaggeFormat%></textarea><br><br><%="&lt;WID_NAME>"%>: <%=LabelManager.getName(labelSet,"lblWidName") %><br><%="&lt;WID_ZNE_NAME"%>>: <%=LabelManager.getName(labelSet,"lblWidZneName")%><br><%="&lt;WID_VALUE>"%>: <%=LabelManager.getName(labelSet,"lblWidValue")%><br><form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><tr><td><button type="button" onclick="btnDefMessage_click()" accessKey="<%=LabelManager.getAccessKey(labelSet,"btnDefMes")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDefMes")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDefMes")%></button></td><td><button type="button" onclick="btnConfMessage_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExitMessage_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></td></tr></table></html><SCRIPT>
  DEFAULT_MESSAGE = "<%=mesaggeFormat%>";

  function btnDefMessage_click() {
	document.getElementById("txtMes").value = DEFAULT_MESSAGE;
  }

  function btnConfMessage_click() {
  	window.returnValue=document.getElementById("txtMes").value;
	window.close();
  }	

  function btnExitMessage_click() {
	window.returnValue=null;
	window.close();
  }
</script>