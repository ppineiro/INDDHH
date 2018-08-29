<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ClasificationBean"></jsp:useBean><%
ClaTreeVo claVo = dBean.getClasificationVo();
String actualUser = dBean.getActualUser(request);
boolean saveChanges = (claVo.getClaTreId()==null)?true:dBean.hasWritePermission(request, claVo.getClaTreId(), claVo.getPrjId(), actualUser);

%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titCla")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type ="tabElement" id="samplesTab" ontabswitch="tabSwitch()" <%=(request.getParameter("defaultTab")!=null?(" defaultTab='"+request.getParameter("defaultTab").toString()+"'"):"" )%>><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDatGen")%>" tabText="<%=LabelManager.getName(labelSet,"tabDatGen")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatArbCla")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><!-- PROYECTOS --><%Collection colProj = dBean.getProjects(request);
   						boolean hasProject = (claVo.getPrjId() != null && claVo.getPrjId().intValue() != 0);%><td title="<%=LabelManager.getToolTip(labelSet,"titPrj")%>"><%=LabelManager.getNameWAccess(labelSet,"titPrj")%>:</td><td colspan=2><input type=hidden name="txtPrj" value=""><select name="selPrj" onchange="cmbProySel()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPrj")%>"><%if (colProj != null && colProj.size()>0) {
			   					Iterator itPrj = colProj.iterator();
			   					ProjectVo prjVo = null;%><option value="0"></option><%while (itPrj.hasNext()) {
		   							prjVo = (ProjectVo) itPrj.next();%><option value="<%=prjVo.getPrjId()%>"
		   							<%if (hasProject) {
											if (prjVo.getPrjId().equals(claVo.getPrjId())) {
												out.print ("selected");
											}%>
											><%=prjVo.getPrjName()%></option><%} else {%>
											><%=prjVo.getPrjName()%></option><%}
			   						}%></select><%}%></select></td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtName" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(claVo!=null) {%>value="<%=dBean.fmtStr(claVo.getClaTreName())%>"<%}%>></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td><input name="txtDesc" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" <%if(claVo!=null) {%>value="<%=dBean.fmtStr(claVo.getClaTreDesc())%>"<%}%>></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblPad")%>"><%=LabelManager.getNameWAccess(labelSet,"lblPad")%>:</td><td><select name="cmbFather" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPad")%>"><option value="" <%if(claVo!=null && claVo.getClaTreIdFather() == null){ out.print(" selected "); }%>></option><%
			   						Collection col = dBean.getAllClasifications(request);
			   						if(col!=null) {
			   							Iterator it = col.iterator();
			   							while(it.hasNext()){
			   								ClaTreeVo vo = (ClaTreeVo)it.next();
			   								if (!vo.getClaTreId().equals(claVo.getClaTreId())) {
			   									%><option value="<%=dBean.fmtInt(vo.getClaTreId())%>" <%if(claVo!=null && claVo.getClaTreIdFather()!=null && claVo.getClaTreIdFather().equals(vo.getClaTreId())){ out.print(" selected "); }%>><%=dBean.fmtStr(vo.getClaTreName())%></option><%
			   								}
			   							}
			   						}
			   					%></select></td><td></td><td></td></tr><tr><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"></tr></table></div><!--      PERMISOS          --><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabClaPer")%>" tabText="<%=LabelManager.getName(labelSet,"tabClaPer")%>"><%@ include file="permissions.jsp" %></div></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="btnConf_click()" <%=(!saveChanges)?"disabled":"" %> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";
var MSG_MUST_SEL_ONE = "<%=LabelManager.getName(labelSet,"msgDebSelUno")%>";
var MSG_PERM_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgPermDefWillBeLost")%>";
var MSG_USE_PROY_PERMS = "<%=LabelManager.getName(labelSet,"msgUseProyPerms")%>";

</script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/administration/clasifications/update.js'></script>
		