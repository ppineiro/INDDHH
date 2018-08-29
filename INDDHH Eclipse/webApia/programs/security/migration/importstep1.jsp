<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.*"%><%@page import="java.util.*"%><%@page import="com.dogma.migration.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MigrationBean"/><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMigEnv")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST" enctype="MULTIPART/FORM-DATA"><!--     Import file source																         --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtMigImpData")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td align="left" colspan="4"><%=LabelManager.getName(labelSet,"sbtMigImpFile")%></td></tr><tr><td colspan="4"></td></tr><tr><td colspan="4"></td></tr><tr><td title="<%=LabelManager.getName(labelSet,"lblMigImpFile")%>"><%=LabelManager.getName(labelSet,"lblMigImpFile")%>:
						</td><td colspan="3"><input type="file" id="impFile" name="impFile.zip" size="70"></td></tr><tr><td title="<%=LabelManager.getName(labelSet,"lblMigImpIgnEqual")%>"><%=LabelManager.getName(labelSet,"lblMigImpIgnEqual")%>:
						</td><td colspan="3"><input type="checkbox" id="cbxIgnoreIdentical" name="cbxIgnoreIdentical" checked value="true"></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtMigImpTarget")%></DIV><table class="tblFormLayout"><tr><td style="width:20%" title="<%=LabelManager.getName(labelSet,"lblMigImpEnvTarget")%>" valign="top"><%=LabelManager.getName(labelSet,"lblMigImpEnvTarget")%>:
						</td><td style="width:40%" onclick="javascript:radTargetType_Click();"><input type="radio" name="radTargetType" id="radTargetTypeFile" value="File" checked><%=LabelManager.getName(labelSet,"lblMigImpEnvFile")%><br><input type="radio" name="radTargetType" id="radTargetTypeNew" value="New"><%=LabelManager.getName(labelSet,"lblMigImpEnvNew")%><br><input type="radio" name="radTargetType" id="radTargetTypeSystem" value="System"><%=LabelManager.getName(labelSet,"lblMigImpEnvSystem")%><br></td><td style="width:0px;display:none"><%=LabelManager.getName(labelSet,"lblMigEnvName")%></td><td align="left" style="width:40%"><input type="text" name="txtEnvName" id="txtTargetName" style="display:none" size="50" maxlength="50"><select name="cbxEnvName" id="cbxTargetName" style="display:none"><%
			   						Collection envCol = dBean.getAllEnvironments();
			   						if (envCol != null) {
			   							Iterator itEnv = envCol.iterator();
			   							while (itEnv.hasNext()) {
			   								EnvironmentVo envVo = (EnvironmentVo)itEnv.next();
			   					%><option value="<%=envVo.getEnvName()%>"><%=envVo.getEnvName()%><%
			   							}
			   						}
			   					%></select></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnSig_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSig")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSig")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSig")%></button><button type="button" onclick="btnVol_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnSal_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><!--     Auxiliary inclusion end (Constants, parameters, etc)								         --><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/migration/importstep1.js'></script><script language="javascript">

	// Enable or disable the fields for target name
	function radTargetType_Click() {
		var radTypeFile = document.getElementById('radTargetTypeFile');
		var radTypeNew = document.getElementById('radTargetTypeNew');
		var radTypeSystem = document.getElementById('radTargetTypeSystem');

		var txtTargetName = document.getElementById('txtTargetName');
		var cbxTargetName = document.getElementById('cbxTargetName');

		unsetRequiredField(txtTargetName);
		
		if (radTypeFile != null && radTypeFile.checked) {
			txtTargetName.style.display = 'none';
			cbxTargetName.style.display = 'none';
		} else if (radTypeNew != null && radTypeNew.checked) {
			txtTargetName.style.display = 'block';
			setRequiredField(txtTargetName);
			cbxTargetName.style.display = 'none';
		} else if (radTypeSystem != null && radTypeSystem.checked) {
			txtTargetName.style.display = 'none';
			cbxTargetName.style.display = 'block';
		}
		
	}

</script>
