<%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="java.io.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.BusinessClassesBean"></jsp:useBean><% BusClassVo busClassVo = dBean.getBusinessClassesVo(); 
String actualUser = dBean.getActualUser(request);
boolean usePrjPerms = "true".equals(request.getParameter("usePrjPerms"));
boolean saveChanges = (busClassVo.getBusClaId()==null)?true:dBean.hasWritePermission(request, busClassVo.getBusClaId(), busClassVo.getPrjId(), actualUser);
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titClaNeg")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatBusCla")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><!-- PROYECTOS --><%Collection colProj = dBean.getProjects(request);
   					boolean hasProject = (busClassVo.getPrjId() != null && busClassVo.getPrjId().intValue() != 0);%><td title="<%=LabelManager.getToolTip(labelSet,"titPrj")%>"><%=LabelManager.getNameWAccess(labelSet,"titPrj")%>:</td><td colspan=2><input type=hidden name="txtPrj" value=""><select name="selPrj" id="selPrj" onchange="cmbProySel()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPrj")%>"><%if (colProj != null && colProj.size()>0) {
			   					Iterator itPrj = colProj.iterator();
			   					ProjectVo prjVo = null;%><option value="0"></option><%while (itPrj.hasNext()) {
		   							prjVo = (ProjectVo) itPrj.next();%><option value="<%=prjVo.getPrjId()%>"
		   							<%if (hasProject) {
											if (prjVo.getPrjId().equals(busClassVo.getPrjId())) {
												out.print ("selected");
											}%>
											><%=prjVo.getPrjName()%></option><%} else {%>
											><%=prjVo.getPrjName()%></option><%}
			   						}%></select><%}%></select></td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtName" id="txtName" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(busClassVo!=null) {%>value="<%=dBean.fmtStr(busClassVo.getBusClaName())%>"<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTipCla")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTipCla")%>:</td><%if (busClassVo.getBusClaId() != null) {%><td class="readOnly"><input type="hidden" name="cmbType" id="cmbType" value="<%=busClassVo.getBusClaType()%>"><%if(busClassVo!=null && BusClassVo.TYPE_DATA_BASE.equals(busClassVo.getBusClaType())) { out.print(LabelManager.getName(labelSet,"lblTipClaDB")); }%><%if(busClassVo!=null && BusClassVo.TYPE_DATA_BASE_PROC.equals(busClassVo.getBusClaType())) { out.print(LabelManager.getName(labelSet,"lblTipClaDBProc")); }%><%if(busClassVo!=null && BusClassVo.TYPE_JAVA_PROGRAMMING.equals(busClassVo.getBusClaType())) { out.print(LabelManager.getName(labelSet,"lblTipClaJav")); }%><%if(busClassVo!=null && BusClassVo.TYPE_JSCPT_PROGRAMMING.equals(busClassVo.getBusClaType())) { out.print(LabelManager.getName(labelSet,"lblTipClaScr")); }%><%if(busClassVo!=null && BusClassVo.TYPE_COMPLEX_WEB_SERVICE.equals(busClassVo.getBusClaType())) { out.print(LabelManager.getName(labelSet,"lblTipClaCpxWS")); }%><%if(busClassVo!=null && BusClassVo.TYPE_QRY_FILTER.equals(busClassVo.getBusClaType())) { out.print(LabelManager.getName(labelSet,"lblTipClaQryFil")); }%><%if(busClassVo!=null && BusClassVo.TYPE_BUSINESS_RULE.equals(busClassVo.getBusClaType())) { out.print(LabelManager.getName(labelSet,"lblTipClaBusRul")); }%><%} else {%><td><select name="cmbType" id="cmbType" p_required="true" onchange="cmbType_onchange(this)" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTipCla")%>"><option value="<%=BusClassVo.TYPE_DATA_BASE%>"    	<%if(busClassVo!=null && BusClassVo.TYPE_DATA_BASE.equals(busClassVo.getBusClaType())) { out.print("selected"); }%>		><%=LabelManager.getNameWAccess(labelSet,"lblTipClaDB")%></option><option value="<%=BusClassVo.TYPE_DATA_BASE_PROC%>"    	<%if(busClassVo!=null && BusClassVo.TYPE_DATA_BASE_PROC.equals(busClassVo.getBusClaType())) { out.print("selected"); }%>		><%=LabelManager.getNameWAccess(labelSet,"lblTipClaDBProc")%></option><option value="<%=BusClassVo.TYPE_JAVA_PROGRAMMING%>"  	<%if(busClassVo!=null && BusClassVo.TYPE_JAVA_PROGRAMMING.equals(busClassVo.getBusClaType())) { out.print("selected"); }%>		><%=LabelManager.getNameWAccess(labelSet,"lblTipClaJav")%></option><option value="<%=BusClassVo.TYPE_JSCPT_PROGRAMMING%>"  	<%if(busClassVo!=null && BusClassVo.TYPE_JSCPT_PROGRAMMING.equals(busClassVo.getBusClaType())) { out.print("selected"); }%>		><%=LabelManager.getNameWAccess(labelSet,"lblTipClaScr")%></option><option value="<%=BusClassVo.TYPE_COMPLEX_WEB_SERVICE%>"	<%if(busClassVo!=null && BusClassVo.TYPE_COMPLEX_WEB_SERVICE.equals(busClassVo.getBusClaType())) { out.print("selected"); }%>	><%=LabelManager.getNameWAccess(labelSet,"lblTipClaCpxWS")%></option><option value="<%=BusClassVo.TYPE_QRY_FILTER%>" <%if(busClassVo!=null && BusClassVo.TYPE_QRY_FILTER.equals(busClassVo.getBusClaType())){ out.print("selected"); }%>><%=LabelManager.getName(labelSet,"lblTipClaQryFil")%></option><option value="<%=BusClassVo.TYPE_BUSINESS_RULE%>" <%if(busClassVo!=null && BusClassVo.TYPE_BUSINESS_RULE.equals(busClassVo.getBusClaType())){ out.print("selected"); }%>><%=LabelManager.getName(labelSet,"lblTipClaBusRul")%></option></select><%}%></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td colspan=3><textarea name="txtDesc" p_maxlength="true" maxlength="255" cols=80 rows=3 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>"><%=dBean.fmtStr(busClassVo.getBusClaDesc())%></textarea></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblSchStaDis")%>"><%=LabelManager.getNameWAccess(labelSet,"lblSchStaDis")%>:</td><td><input type="checkbox" name="chkDisabled" <%if(busClassVo.getFlagValue(BusClassVo.FLAG_DISABLED)){out.print(" checked ");} %> ></td></tr><tr><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"><input type="hidden" name="hidUsePrjPerms" value="<%=usePrjPerms%>"></tr></table><BR><DIV id="divSubTit" class="subTit"><%=LabelManager.getName(labelSet,"sbtDatEspBusCla")%></DIV><table class="tblFormLayout"  id="trWS" style="display:none"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblUrl")%>"><%=LabelManager.getNameWAccess(labelSet,"lblUrl")%>:</td><td><input name="txtUrl" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblUrl")%>" type="text" <%if(busClassVo!=null) {%>value="<%=dBean.fmtStr(busClassVo.getBusClaUrl())%>"<%}%>></td><td></td><td></td></tr></table><table class="tblFormLayout"  id="trDB" style="display:none"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblCon")%>"><%=LabelManager.getNameWAccess(labelSet,"lblCon")%>:</td><td colspan=3><select name="cmbConn" p_required="true" onChange="selDbConId_change()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblCon")%>"><option value="null" <%if(busClassVo!=null && busClassVo.getDbConId()==null) {%> selected <%}%>><%=LabelManager.getName(labelSet,"lblLocalDbNom")%></option><%
						if (busClassVo.getBusClaId() == null || BusClassVo.TYPE_DATA_BASE.equals(busClassVo.getBusClaType()) || BusClassVo.TYPE_DATA_BASE_PROC.equals(busClassVo.getBusClaType())) {
							Collection c = dBean.getConnections(request);
		   					if (c!=null) {
		   						Iterator it = c.iterator();
		   						while (it.hasNext()){
		   							DbConnectionVo dbConns = (DbConnectionVo)it.next();
		   							%><option value="<%=dBean.fmtStr(StringUtil.encodeString(new String[] {dbConns.getDbConId().toString(), dbConns.getDbConName()}))%>"  <%if(busClassVo!=null && dbConns.getDbConId().equals(busClassVo.getDbConId())) {%> selected <%}%> ><%=dBean.fmtStr(dbConns.getDbConName())%></option><%
		   						}
		   					}
		   				}  %></select></tr></table><table class="tblFormLayout"  id="trView" style="display:none"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblVism")%>"><%=LabelManager.getNameWAccess(labelSet,"lblVis")%>:</td><td colspan=3><select name="txtView" p_required="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblVis")%>"><%
							String viewName = "";
							Integer curConn = busClassVo != null ? busClassVo.getDbConId() : null;
							//if (curConn != null) {
			   					Collection colViews = dBean.getViews(request, curConn);
			   					if (colViews!=null) {
			   						Iterator it = colViews.iterator();
			   						while (it.hasNext()){
			   							viewName = (String) it.next();
			   							%><option value="<%=dBean.fmtStr(viewName)%>"  <%if(busClassVo!=null && viewName.equals(busClassVo.getBusClaView())) {%> selected <%}%> ><%=dBean.fmtStr(viewName)%></option><%
			   						}
			   					}
			   				//}
		   					%></select></td></tr></table><table class="tblFormLayout"  id="trProc" style="display:none"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblProAlm")%>"><%=LabelManager.getNameWAccess(labelSet,"lblProAlm")%>:</td><td colspan=3><select name="txtProc" p_required="true"  accesskey="<%=LabelManager.getAccessKey(labelSet,"lblProAlm")%>"><option/><%
								if (busClassVo.getBusClaId() == null || BusClassVo.TYPE_DATA_BASE.equals(busClassVo.getBusClaType()) || BusClassVo.TYPE_DATA_BASE_PROC.equals(busClassVo.getBusClaType())) {
									String processName = "";
									curConn = busClassVo != null ? busClassVo.getDbConId() : null;
									//if (curConn != null) {
										Collection colProcs = dBean.getProcedures(request, curConn);
					   					if (colProcs!=null) {
					   						Iterator it = colProcs.iterator();
					   						while (it.hasNext()){
					   							processName = (String) it.next();
					   							%><option value="<%=dBean.fmtStr(processName)%>"  <%if(busClassVo!=null && processName.equals(busClassVo.getBusClaView())) {%> selected <%}%> ><%=dBean.fmtStr(processName)%></option><%
					   						}
					   					}
					   				//}
			   					}%></select></td></tr><tr><td></td><td colspan=3 align="left"><%=LabelManager.getNameWAccess(labelSet,"lblProAlmExe")%></td></tr></table><table class="tblFormLayout" id="trJav" style="display:none"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEje")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEje")%>:</td><td><input name="txtExe" p_required="true" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblVis")%>" type="text" <%if(busClassVo!=null) {%>value="<%=dBean.fmtStr(busClassVo.getBusClaExecutable())%>"<%}%>></td><td><input name="txtUploadedPath" maxlength="255" id="txtUploadedPath" type="text" <%if(busClassVo!=null) {%>value="<%=dBean.fmtStr(busClassVo.getBusClaUploadedFileName())%>"<%}%>></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="btnNext_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSig")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSig")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script language="javascript">
var TYPE_WS  = "<%=BusClassVo.TYPE_WEB_SERVICE%>";
var TYPE_DB  = "<%=BusClassVo.TYPE_DATA_BASE%>";
var TYPE_DB_PROC = "<%=BusClassVo.TYPE_DATA_BASE_PROC%>";
var TYPE_JAV = "<%=BusClassVo.TYPE_JAVA_PROGRAMMING%>";
var TYPE_SCR = "<%=BusClassVo.TYPE_JSCPT_PROGRAMMING%>";
var TYPE_QRY_FIL = "<%=BusClassVo.TYPE_QRY_FILTER%>";
var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";
var MSG_MUST_SEL_ONE = "<%=LabelManager.getName(labelSet,"msgDebSelUno")%>";
var MSG_PERM_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgPermDefWillBeLost")%>";
var MSG_USE_PROY_PERMS = "<%=LabelManager.getName(labelSet,"msgUseProyPerms")%>";

</script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/businessClasses/update.js"></script><script language="javascript" defer=true>
if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", function(){cmbType_onchange(document.getElementById("cmbType"));}, false);
}else{
	cmbType_onchange(document.getElementById("cmbType"));
}
</script><%@include file="../../../components/scripts/server/endInc.jsp" %>	