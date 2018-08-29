<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ConnectionsBean"></jsp:useBean><%
DbConnectionVo dbConnVo = dBean.getDbConnectionsVo();
String actualUser = dBean.getActualUser(request);
boolean saveChanges = (dbConnVo.getDbConId()==null)?true:dBean.hasWritePermission(request, dbConnVo.getDbConId(), dbConnVo.getPrjId(), actualUser);

%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titCon")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type ="tabElement" id="samplesTab" ontabswitch="tabSwitch()" <%=(request.getParameter("defaultTab")!=null?(" defaultTab='"+request.getParameter("defaultTab").toString()+"'"):"" )%>><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDatGen")%>" tabText="<%=LabelManager.getName(labelSet,"tabDatGen")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatCon")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><!-- PROYECTOS --><%Collection colProj = dBean.getProjects(request);
   					boolean hasProject = (dbConnVo.getPrjId() != null && dbConnVo.getPrjId().intValue() != 0);%><td title="<%=LabelManager.getToolTip(labelSet,"titPrj")%>"><%=LabelManager.getNameWAccess(labelSet,"titPrj")%>:</td><td colspan=2><input type=hidden name="txtPrj" value=""><select name="selPrj" onchange="cmbProySel()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPrj")%>"><%if (colProj != null && colProj.size()>0) {
			   					Iterator itPrj = colProj.iterator();
			   					ProjectVo prjVo = null;%><option value="0"></option><%while (itPrj.hasNext()) {
		   							prjVo = (ProjectVo) itPrj.next();%><option value="<%=prjVo.getPrjId()%>"
		   							<%if (hasProject) {
											if (prjVo.getPrjId().equals(dbConnVo.getPrjId())) {
												out.print ("selected");
											}%>
											><%=prjVo.getPrjName()%></option><%} else {%>
											><%=prjVo.getPrjName()%></option><%}
			   						}%></select><%}%></select></td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtName" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(dbConnVo!=null) {%>value="<%=dBean.fmtStr(dbConnVo.getDbConName())%>"<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTipCon")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTipCon")%>:</td><td><select name="cmbType" id="cmbType" onchange="chaCmbType()" p_required="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTipCon")%>"><option></option><option value="<%=DbConnectionVo.TYPE_ORACLE%>" 	<%if(dbConnVo!=null && DbConnectionVo.TYPE_ORACLE.equals(dbConnVo.getDbConType())) { out.print("selected"); }%>><%=LabelManager.getName(labelSet,"lblTipConOra")%></option><option value="<%=DbConnectionVo.TYPE_SQLSERVER%>"	<%if(dbConnVo!=null && DbConnectionVo.TYPE_SQLSERVER.equals(dbConnVo.getDbConType())) { out.print("selected"); }%>><%=LabelManager.getName(labelSet,"lblTipConSQL")%></option><option value="<%=DbConnectionVo.TYPE_POSTGRE%>" 	<%if(dbConnVo!=null && DbConnectionVo.TYPE_POSTGRE.equals(dbConnVo.getDbConType())) { out.print("selected"); }%>><%=LabelManager.getName(labelSet,"lblTipConPos")%></option><option value="<%=DbConnectionVo.TYPE_MYSQL%>" 	    <%if(dbConnVo!=null && DbConnectionVo.TYPE_MYSQL.equals(dbConnVo.getDbConType())) { out.print("selected"); }%>><%=LabelManager.getName(labelSet,"lblTipConMySQL")%></option></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td colspan=3><input name="txtDesc" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" <%if(dbConnVo!=null) {%>value="<%=dBean.fmtStr(dbConnVo.getDbConDesc())%>"<%}%> size=70></td></tr><tr></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblConStr")%>"><%=LabelManager.getNameWAccess(labelSet,"lblConStr")%>:</td><td colspan=3><input name="txtConnString" p_required="true" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblConStr")%>" type="text" <%if(dbConnVo!=null) {%>value="<%=dBean.fmtStr(dbConnVo.getDbConString())%>"<%}%> size=70></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblConUsu")%>"><%=LabelManager.getNameWAccess(labelSet,"lblConUsu")%>:</td><td><input name="txtConnUser" p_required="true" maxlength="20" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblConUsu")%>" type="text" <%if(dbConnVo!=null) {%>value="<%=dBean.fmtStr(dbConnVo.getDbConUser())%>"<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblConPas")%>"><%=LabelManager.getNameWAccess(labelSet,"lblConPas")%>:</td><td><input name="txtConnPwd" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblConPas")%>" type="password" <%if(dbConnVo!=null && dbConnVo.getDbConId()!=null) {%>value="<%=dBean.fmtStr("00000000000000000000000000000000000000")%><%//=dBean.fmtStr(dbConnVo.getDbConPassword())%>"<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMinCanCon")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMinCanCon")%>:</td><td><input name="txtConnMin" id="txtConnMin" p_required="true" p_numeric=true maxlength="3" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMinCanCon")%>" type="text" <%if(dbConnVo!=null) {%>value="<%=dBean.fmtInt(dbConnVo.getDbConMinCon())%>"<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblMaxCanCon")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMaxCanCon")%>:</td><td><input name="txtConnMax" id="txtConnMax" p_required="true" p_numeric=true maxlength="3" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMaxCanCon")%>" type="text" <%if(dbConnVo!=null) {%>value="<%=dBean.fmtInt(dbConnVo.getDbConMaxCon())%>"<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblConnMaxIdle")%>"><%=LabelManager.getNameWAccess(labelSet,"lblConnMaxIdle")%>:</td><td><input name="txtConnMaxIdle" id="txtConnMaxIdle" p_required="true" p_numeric=true maxlength="3" accesskey="<%=LabelManager.getAccessKey(labelSet,"txtConnMaxIdle")%>" type="text" <%if(dbConnVo!=null) {%>value="<%=dBean.fmtInt(dbConnVo.getDbConIdleCon())%>"<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblConnMaxWait")%>"><%=LabelManager.getNameWAccess(labelSet,"lblConnMaxWait")%>:</td><td><input name="txtConnMaxWait" id="txtConnMaxWait" p_required="true" p_numeric=true maxlength="8" accesskey="<%=LabelManager.getAccessKey(labelSet,"txtConnMaxWait")%>" type="text" <%if(dbConnVo!=null) {%>value="<%=dBean.fmtInt(dbConnVo.getDbConWaitCon())%>"<%}%>></td></tr><tr><td><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"></td><td></td><td></td><td><button type="button" onclick="btnTest_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnTestDB")%>" title="<%=LabelManager.getToolTip(labelSet,"btnTestDB")%>"><%=LabelManager.getNameWAccess(labelSet,"btnTestDB")%></button></td></tr></table></div><!--      PERMISOS          --><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabConPer")%>" tabText="<%=LabelManager.getName(labelSet,"tabConPer")%>"><%@ include file="permissions.jsp" %></div></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" <%=(!saveChanges)?"disabled":"" %> onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
var TYPE_ORACLE = "<%=DbConnectionVo.TYPE_ORACLE%>";
var TYPE_SQLSERVER = "<%=DbConnectionVo.TYPE_SQLSERVER%>";
var TYPE_POSTGRE = "<%=DbConnectionVo.TYPE_POSTGRE%>";
var TYPE_MYSQL = "<%=DbConnectionVo.TYPE_MYSQL%>";
var MSG_WRNG_VAL = "<%=LabelManager.getName(labelSet,"msgWrngVal")%>";
var MSG_WRNG_MAX_CON = "<%=LabelManager.getName(labelSet,"msgWrngMaxCon")%>";
var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";
var MSG_MUST_SEL_ONE = "<%=LabelManager.getName(labelSet,"msgDebSelUno")%>";
var MSG_PERM_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgPermDefWillBeLost")%>";
var MSG_USE_PROY_PERMS = "<%=LabelManager.getName(labelSet,"msgUseProyPerms")%>";
  
</script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/connections/update.js" ></script>

