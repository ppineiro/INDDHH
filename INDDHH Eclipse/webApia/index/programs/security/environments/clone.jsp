<%@page import="com.dogma.bi.BIEngine"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titAmb")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatAmb")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtEnvName" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" ></td><td></td><td></td></tr><tr><td><input type="checkbox" name="cloUseEnv" accessKey="<%=LabelManager.getAccessKey(labelSet,"lblEnvCloEnvUser")%>"></td><td colspan="3" title="<%=LabelManager.getToolTip(labelSet,"lblEnvCloEnvUser")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEnvCloEnvUser")%></td></tr><tr><td><input type="checkbox" name="cloPoolEnv" accessKey="<%=LabelManager.getAccessKey(labelSet,"lblEnvCloPoolEnv")%>"></td><td colspan="3" title="<%=LabelManager.getToolTip(labelSet,"lblEnvCloPoolEnv")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEnvCloPoolEnv")%></td></tr><tr><td><input type="checkbox" onClick="enableCheckBox('cloPrfEnv','cloAllEnvPrf','cloAllEnvCbe')" id="cloPrfEnv" name="cloPrfEnv" accessKey="<%=LabelManager.getAccessKey(labelSet,"lblEnvCloPrfEnv")%>"></td><td colspan="3" title="<%=LabelManager.getToolTip(labelSet,"lblEnvCloPrfEnv")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEnvCloPrfEnv")%></td></tr><tr><td><input type="checkbox" disabled id="cloAllEnvPrf" name="cloAllEnvPrf" accessKey="<%=LabelManager.getAccessKey(labelSet,"lblEnvCloAllEnvPrfFnc")%>"></td><td colspan="3" title="<%=LabelManager.getToolTip(labelSet,"lblEnvCloAllEnvPrfFnc")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEnvCloAllEnvPrfFnc")%></td></tr><%//Se quita la posibilidad de clonado de cubos a partir de las versiones 2.3.0.48, 2.3.1.4 y 2.4.0.5 debido a la complejidad de la tarea, se deja pendiente en caso de ser solicitado por un cliente
		   			//<tr>
		   			//<td><input type="checkbox" onClick="enableCheckBox('cloAllEnvCbe','cloAllEnvEntCbe','cloAllEnvProCbe')" disabled id="cloAllEnvCbe" name="cloAllEnvCbe" accessKey="LabelManager.getAccessKey(labelSet,"lblEnvCloCbeEnv")"></td>
		   			//<td colspan="3" title="LabelManager.getToolTip(labelSet,"lblEnvCloCbeEnv")">LabelManager.getNameWAccess(labelSet,"lblEnvCloCbeEnv")</td>
		   			//</tr>
		   		%></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language='javascript' src='<%=Parameters.ROOT_PATH%>/programs/security/environments/clone.js'></script><script type="text/javascript" defer="true">
var biCorrectlyInstalled = "<%=BIEngine.biCorrectlyInstalled()%>";
</script>