<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ConnectionsBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titCon")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><table width="100%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtFil")%></td><td align="right"><button type="button" id="toggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" class="btn" onclick="toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>)"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button></td></tr></table></DIV><DIV id="listFilterArea" style="display:none"><DIV style="OVERFLOW:AUTO;HEIGHT:<%= Parameters.FILTER_LIST_SIZE - 32 %>px;"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><!-- PROYECTOS --><%Collection colProj = dBean.getProjects(request);
   						boolean hasProject = (dBean.getFilter().getPrjId() != null && dBean.getFilter().getPrjId().intValue() != 0);%><td title="<%=LabelManager.getToolTip(labelSet,"titPrj")%>"><%=LabelManager.getNameWAccess(labelSet,"titPrj")%>:</td><td><input type=hidden name="txtPrj" value=""><select name="selPrj" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPrj")%>"><%if (colProj != null && colProj.size()>0) {
			   					Iterator itPrj = colProj.iterator();
			   					ProjectVo prjVo = null;%><option value="0"></option><%while (itPrj.hasNext()) {
		   							prjVo = (ProjectVo) itPrj.next();%><option value="<%=prjVo.getPrjId()%>"
									<%if (hasProject) {
										if (prjVo.getPrjId().equals(dBean.getFilter().getPrjId())) {
											out.print ("selected");
										}%>
										><%=prjVo.getPrjName()%></option><%} else {%>
											><%=prjVo.getPrjName()%></option><%}
			   						}%></select><%}%></select></td></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTipCon")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTipCon")%>:</td><td><select name="cmbType" id="cmbType" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTipCon")%>"><option value="" <%=(dBean.getFilter().getType() == null)?"selected":""%>></option><option value="<%=DbConnectionVo.TYPE_ORACLE%>" <%=(DbConnectionVo.TYPE_ORACLE.equals(dBean.getFilter().getType()))?"selected":""%>><%=LabelManager.getName(labelSet,"lblTipConOra")%></option><option value="<%=DbConnectionVo.TYPE_SQLSERVER%>" <%=(DbConnectionVo.TYPE_SQLSERVER.equals(dBean.getFilter().getType()))?"selected":""%>><%=LabelManager.getName(labelSet,"lblTipConSQL")%></option><option value="<%=DbConnectionVo.TYPE_POSTGRE%>" <%=(DbConnectionVo.TYPE_POSTGRE.equals(dBean.getFilter().getType()))?"selected":""%>><%=LabelManager.getName(labelSet,"lblTipConPos")%></option><option value="<%=DbConnectionVo.TYPE_MYSQL%>" <%=(DbConnectionVo.TYPE_MYSQL.equals(dBean.getFilter().getType()))?"selected":""%>><%=LabelManager.getName(labelSet,"lblTipConMySQL")%></option></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtName" maxlength="50" type="text" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" value="<%=dBean.fmtStr(dBean.getFilter().getName())%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td><input name="txtDesc" maxlength="50" type="text" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" value="<%=dBean.fmtStr(dBean.getFilter().getDesc())%>"></td></tr></table></div><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td></td><td colspan=3 align="right"><button type="button" onclick="btnSearch_click()" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></td></tr></table></DIV><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")%></DIV><div class="tableContainerNoHScroll" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px;" type="grid" id="gridList" docBean=""><table width="500px" cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="24px" style="width:24px" title="<%=LabelManager.getToolTip(labelSet,"lblPerm")%>">&nbsp;</th><% canOrderBy = dBean.getFilter().getOrderBy() != DbConnectionFilterVo.ORDER_NAME; %><th min_width="110px" style="min-width:110px;width:30%<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=DbConnectionFilterVo.ORDER_NAME%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblNom")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != DbConnectionFilterVo.ORDER_DESC; %><th min_width="195px" style="min-width:195px;width:40%<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=DbConnectionFilterVo.ORDER_DESC%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblDes")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != DbConnectionFilterVo.ORDER_TYPE; %><th min_width="110px" style="min-width:110px;width:30%<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=DbConnectionFilterVo.ORDER_TYPE%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblTipCon")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblTipCon")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != DbConnectionFilterVo.ORDER_USER; %><th min_width="70px" style="width:70px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=DbConnectionFilterVo.ORDER_USER%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblLastUsrName")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblLastUsrName")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != DbConnectionFilterVo.ORDER_DATE; %><th min_width="70px" style="width:70px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=DbConnectionFilterVo.ORDER_DATE%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblLastActDate")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblLastActDate")%><%=canOrderBy?"</u>":""%></th></tr></thead><tbody class="scrollContent"><%	Collection col = dBean.getList();
				   			String actualUser = dBean.getActualUser(request);

							if (col != null) {
								Iterator it = col.iterator();
								int i = 0;
								DbConnectionVo aVO = null;
								while (it.hasNext()) {
									aVO = (DbConnectionVo) it.next(); 
									boolean readPerm = dBean.hasReadPermission(request, aVO.getDbConId(), aVO.getPrjId(), actualUser);
									boolean writePerm = dBean.hasWritePermission(request, aVO.getDbConId(), aVO.getPrjId(), actualUser);
									%><tr <%if (i % 2 == 0) {%>class="trOdd"<%}%>><td style="width:0px;display:none;"><input type="hidden" id="idSel" name="chkSel<%=i%>"><input type="hidden" name="hidDbConnId<%=i%>" value="<%=dBean.fmtInt(aVO.getDbConId())%>"><input type="hidden" name="hidEnvId<%=i%>" value="<%=dBean.fmtInt(aVO.getEnvId())%>"></td><td align="center" vAlign="top" style="width:28px;align:center;"><% if (!readPerm) {%><img border=0 src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/noAccess.png' title="<%=LabelManager.getToolTip(labelSet,"msgCantRead")%>"><%}%><input type="hidden" name="hidUsrCanRead" value="<%=readPerm%>"><input type="hidden" name="hidUsrCanWrite" value="<%=writePerm%>"></td><td style="min-width:110px;width:30%"><%=dBean.fmtHTML(aVO.getDbConName())%></td><td style="min-width:195px;width:40%"><%=dBean.fmtHTML(aVO.getDbConDesc())%></td><td style="min-width:110px;width:30%"><%
											if(DbConnectionVo.TYPE_ORACLE.equals(aVO.getDbConType())){
												out.print(LabelManager.getName(labelSet,"lblTipConOra"));
											}
											if(DbConnectionVo.TYPE_SQLSERVER.equals(aVO.getDbConType())){
												out.print(LabelManager.getName(labelSet,"lblTipConSQL"));
											}
											if(DbConnectionVo.TYPE_POSTGRE.equals(aVO.getDbConType())){
												out.print(LabelManager.getName(labelSet,"lblTipConPos"));
											}
											if(DbConnectionVo.TYPE_MYSQL.equals(aVO.getDbConType())){
												out.print(LabelManager.getName(labelSet,"lblTipConMySQL"));
											}
											%></td><td><%=dBean.fmtHTML(aVO.getRegUser())%></td><td><%=dBean.fmtHTML(aVO.getRegDate())%></td></tr><%i++;%><%}
							}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><%@include file="../../includes/navButtons.jsp" %><td align="right"><button type="button" onclick="btnClo_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnClo")%>" title="<%=LabelManager.getToolTip(labelSet,"btnClo")%>"><%=LabelManager.getNameWAccess(labelSet,"btnClo")%></button><button type="button" onclick="btnNew_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCre")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCre")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCre")%></button><button type="button" onclick="btnMod_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMod")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMod")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMod")%></button><button type="button" onclick="btnDel_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button><button type="button" onclick="btnDep_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDep")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDep")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDep")%></button></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script src="<%=Parameters.ROOT_PATH%>/programs/administration/connections/list.js"></script><script>
var MSG_CON_ONLY_READ = "<%=LabelManager.getName(labelSet,"msgConOnlyRead")%>";
var MSG_CON_CANT_READ = "<%=LabelManager.getName(labelSet,"msgConNoRead")%>";
var MSG_INSUF_PERMS   = "<%=LabelManager.getName(labelSet,"msgInsufPermissions")%>";
</script><%@include file="../../../components/scripts/server/endInc.jsp" %>