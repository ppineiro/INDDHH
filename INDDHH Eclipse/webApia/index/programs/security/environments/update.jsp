<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.EnvironmentsBean"></jsp:useBean><%
EnvironmentVo environmentVo = dBean.getEnvVo();
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titAmb")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatAmb")%></DIV><table class="tblFormLayout"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtName" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(environmentVo!=null) {%>value="<%=dBean.fmtStr(environmentVo.getEnvName())%>"<%}%>></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td colspan=3><input name="txtDesc" maxlength="255" size=80 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" <%if(environmentVo!=null) {%>value="<%=dBean.fmtStr(environmentVo.getEnvDesc())%>"<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEti")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEti")%>:</td><td colspan=3><select name="cmbLbl" p_required=true accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEti")%>" onchange="getLanguages(this)"><option></option><%
		   				Collection col = dBean.getLabelSets();
		   				if (col != null) {
							Iterator it = col.iterator();
							LblSetVo lVO = null;
							while (it.hasNext()) {
								lVO = (LblSetVo) it.next(); 
								%><option value="<%=lVO.getLblSetId()%>" <%if(environmentVo!=null && environmentVo.getLblSetId()!=null && environmentVo.getLblSetId().equals(lVO.getLblSetId())){out.print(" selected ");}%>><%=lVO.getLblSetName()%></option><%
							}
						}
		   				%></select></td></tr><td title="<%=LabelManager.getToolTip(labelSet,"lblLen")%>"><%=LabelManager.getNameWAccess(labelSet,"lblLen")%>:</td><td colspan=3><select name="cmbLan" p_required=true accesskey="<%=LabelManager.getAccessKey(labelSet,"lblLen")%>" ><%
		   				col = dBean.getLanguages();
		   				if (col != null) {
							Iterator it = col.iterator();
							LanguageVo lVO = null;
							while (it.hasNext()) {
								lVO = (LanguageVo) it.next(); 
								%><option value="<%=lVO.getLangId()%>" <%if(environmentVo!=null && environmentVo.getLangId()!=null && environmentVo.getLangId().equals(lVO.getLangId())){out.print(" selected ");}%>><%=lVO.getLangName()%></option><%
							}
						}
		   				%></select></td><tr></tr></table><!--     - DOCUMENTS          --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDoc")%></DIV><jsp:include page="../../documents/documents.jsp" flush="true"><jsp:param name="docBean" value="form"/></jsp:include><script src="<%=Parameters.ROOT_PATH%>/programs/documents/documents.js"></script></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language='javascript' src='<%=Parameters.ROOT_PATH%>/programs/security/environments/update.js'></script>