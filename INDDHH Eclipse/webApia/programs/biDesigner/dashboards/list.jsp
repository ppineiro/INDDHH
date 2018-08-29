<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bi.BIEngine"%><%@include file="../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><script type="text/javascript" defer="true">
var biCorrectlyInstalled = "<%=BIEngine.biCorrectlyInstalled()%>";
</script><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.DashboardBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titDashboards")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><table width="100%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtFil")%></td><td align="right"><button type="button" id="toggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" class="btn" onclick="toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>)"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button></td></tr></table></DIV><DIV id="listFilterArea" style="display:none"><DIV style="OVERFLOW:AUTO;HEIGHT:<%= Parameters.FILTER_LIST_SIZE - 32 %>px;"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtName" maxlength="50" type="text" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" value="<%=dBean.fmtStr(dBean.getFilter().getName())%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTit")%>:</td><td><input name="txtTitle" maxlength="50" type="text" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTit")%>" value="<%=dBean.fmtStr(dBean.getFilter().getTitle())%>"></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td><input name="txtDesc" maxlength="50" type="text" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" value="<%=dBean.fmtStr(dBean.getFilter().getDesc())%>"></td></tr></table></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td></td><td colspan=3 align="right"><button type="button" onclick="btnSearch_click()" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></td></tr></table></DIV><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table  width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="24px" style="width:24px" title="<%=LabelManager.getToolTip(labelSet,"lblPerm")%>">&nbsp;</th><% canOrderBy = dBean.getFilter().getOrderBy() != DashboardFilterVo.ORDER_NAME; %><th min_width="210px" style="width:210px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=DashboardFilterVo.ORDER_NAME%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblNom")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != DashboardFilterVo.ORDER_TITLE; %><th min_width="210px" style="width:40%;min-width:210px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=DashboardFilterVo.ORDER_TITLE%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblTit")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblTit")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != DashboardFilterVo.ORDER_DESC; %><th min_width="200px" style="width:60%;min-width:200px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=DashboardFilterVo.ORDER_DESC%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblDes")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != DashboardFilterVo.ORDER_USER; %><th min_width="70px" style="width:70px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=DashboardFilterVo.ORDER_USER%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblLastUsrName")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblLastUsrName")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != DashboardFilterVo.ORDER_DATE; %><th min_width="70px" style="width:70px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=DashboardFilterVo.ORDER_DATE%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblLastActDate")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblLastActDate")%><%=canOrderBy?"</u>":""%></th></tr></thead><tbody><%	
					   		if (BIEngine.biCorrectlyInstalled()){
					   			Collection col = dBean.getList();
					   			String actualUser = dBean.getActualUser(request);
					   			if (col != null) {
									Iterator it = col.iterator();
									int i = 0;
									DashboardVo pVO = null;
									while (it.hasNext()) {
										pVO = (DashboardVo) it.next(); 
										boolean readPerm = dBean.hasReadPermission(request, pVO.getDashboardId(), actualUser);
										boolean writePerm = dBean.hasWritePermission(request, pVO.getDashboardId(), actualUser);
										%><tr><td  style="width:0px;display:none;"><input type="hidden" id="idSel" name="chkSel<%=i%>"><input type="hidden" name="hidDshId<%=i%>" value="<%=dBean.fmtInt(pVO.getDashboardId())%>"></td><td align="center" vAlign="top" style="width:28px;align:center;"><% if (!readPerm) {%><img border=0 src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/noAccess.png' title="<%=LabelManager.getToolTip(labelSet,"msgCantRead")%>"><%}%><input type="hidden" name="hidUsrCanRead" value="<%=readPerm%>"><input type="hidden" name="hidUsrCanWrite" value="<%=writePerm%>"></td><td><%=dBean.fmtHTML(pVO.getDashboardName())%></td><td style="min-width:210px"><%=dBean.fmtHTML(pVO.getDashboardTitle())%></td><td style="min-width:200px"><%=dBean.fmtHTML(pVO.getDashboardDesc())%></td><td><%=dBean.fmtHTML(pVO.getRegUser())%></td><td><%=dBean.fmtHTML(pVO.getRegDate())%></td></tr><%i++;%><%}
					   			}
							}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><%@include file="../../includes/navButtons.jsp" %><td align="right"><button type="button" onclick="btnClo_click()" <%=(!BIEngine.biCorrectlyInstalled())?"disabled":""%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnClo")%>" title="<%=LabelManager.getToolTip(labelSet,"btnClo")%>"><%=LabelManager.getNameWAccess(labelSet,"btnClo")%></button><button type="button" onclick="btnNew_click()" <%=(!BIEngine.biCorrectlyInstalled())?"disabled":""%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCre")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCre")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCre")%></button><button type="button" onclick="btnMod_click()" <%=(!BIEngine.biCorrectlyInstalled())?"disabled":""%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMod")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMod")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMod")%></button><button type="button" onclick="btnDel_click()" <%=(!BIEngine.biCorrectlyInstalled())?"disabled":""%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button><button type="button" onclick="btnDep_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDep")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDep")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDep")%></button></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
var MSG_DSH_ONLY_READ = "<%=LabelManager.getName(labelSet,"msgDshOnlyRead")%>";
var MSG_DSH_CANT_READ = "<%=LabelManager.getName(labelSet,"msgDshNoRead")%>";
var MSG_INSUF_PERMS   = "<%=LabelManager.getName(labelSet,"msgInsufPermissions")%>";
</script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/biDesigner/dashboards/list.js'></script>