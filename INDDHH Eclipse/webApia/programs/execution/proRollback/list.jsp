<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.bean.query.MonitorProcessesBean"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@include file="../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><%

String urlAction = request.getParameter("action");
boolean showFilter = urlAction != null && urlAction.length() > 0 && "init".equals(urlAction);

%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body onLoad="onLoadHtml();"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.ProRollbackBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><%if (dBean.TYPE_ADHOC.equals(dBean.getRollbackType())) {%><TD><%=LabelManager.getName(labelSet,"titAdhoc")%></TD><%} else {%><TD><%=LabelManager.getName(labelSet,"titProRol")%></TD><%}%><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><table width="100%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtFil")%></td><td align="right"><button type="button" id="toggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" class="btn" onclick="toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>)"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button></td></tr></table></DIV><DIV id="listFilterArea" style="display:none"><DIV style="OVERFLOW:AUTO;HEIGHT:<%= Parameters.FILTER_LIST_SIZE - 32 %>px;"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblFilProNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblFilProNom")%>:</td><td><input name="txtNam" maxlength="50" type="text" value="<%=dBean.fmtStr(dBean.getFilter().getProName())%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblFilProNom")%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblMonProAct")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonProAct")%></td><td><select name="cmbAct" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonProAct")%>"><option value=""></option><option value="<%=ProcessVo.PROCESS_ACTION_CREATION%>" <%=ProcessVo.PROCESS_ACTION_CREATION.equals(dBean.getFilter().getProAction())?"selected":""%>><%=LabelManager.getName(labelSet,"lblMonProActCre")%></option><%if (envUsesEntities) {%><option value="<%=ProcessVo.PROCESS_ACTION_ALTERATION%>" <%=ProcessVo.PROCESS_ACTION_ALTERATION.equals(dBean.getFilter().getProAction())?"selected":""%>><%=LabelManager.getName(labelSet,"lblMonProActAlt")%></option><%}%><option value="<%=ProcessVo.PROCESS_ACTION_CANCEL%>" <%=ProcessVo.PROCESS_ACTION_CANCEL.equals(dBean.getFilter().getProAction())?"selected":""%>><%=LabelManager.getName(labelSet,"lblMonProActCan")%></option></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProAct")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonInstProAct")%>:</td><td><input type="hidden" name="cmbSta" value="<%=ProInstanceVo.PROC_STATUS_RUNNING%>"><select name="cmbBackLog" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProAct")%>"><option value=""></option><option value="<%=MonitorProcessFilterVo.ESTADO_ACTIVIDAD_ATRASADO%>" <%=MonitorProcessFilterVo.ESTADO_ACTIVIDAD_ATRASADO.equals(dBean.getFilter().getProInstBackLog())?"selected":""%>><%=LabelManager.getName(labelSet,"lblMonInstProActAtr")%></option><option value="<%=MonitorProcessFilterVo.ESTADO_ACTIVIDAD_ALARMA%>" <%=MonitorProcessFilterVo.ESTADO_ACTIVIDAD_ALARMA.equals(dBean.getFilter().getProInstBackLog())?"selected":""%>><%=LabelManager.getName(labelSet,"lblMonInstProActAla")%></option><option value="<%=MonitorProcessFilterVo.ESTADO_ACTIVIDAD_EN_FECHA%>" <%=MonitorProcessFilterVo.ESTADO_ACTIVIDAD_EN_FECHA.equals(dBean.getFilter().getProInstBackLog())?"selected":""%>><%=LabelManager.getName(labelSet,"lblMonInstProActEnFec")%></option></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProNroReg")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonInstProNroReg")%>:</td><td><input name="txtNamPre" maxlength="50" size="5" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProNroReg")%>" type="text" value="<%=dBean.fmtStr(dBean.getFilter().getProInstNamePre())%>"><input name="txtNamNum" maxlength="11" size="7" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProNroReg")%>" type="text" value="<%=dBean.fmtInt(dBean.getFilter().getProInstNameNum())%>" class="txtNumeric"><input name="txtNamPos" maxlength="50" size="5"accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProNroReg")%>" type="text" value="<%=dBean.fmtStr(dBean.getFilter().getProInstNamePos())%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProCreUsu")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonInstProCreUsu")%>:</td><td><input name="txtInstUser" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProCreUsu")%>" maxlength="50" type="text" value="<%=dBean.fmtStr(dBean.getFilter().getProUser())%>"></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProCreDatEnt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonInstProCreDatEnt")%>:</td><td><input name="txtStaSta" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProCreDatEnt")%>" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" type="text" value="<%=dBean.fmtDate(dBean.getFilter().getDateStartFrom())%>">
		   							-
			   						<input name="txtStaEnd" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProCreDatEnt")%>" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" type="text" value="<%=dBean.fmtDate(dBean.getFilter().getDateStartTo())%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProEndDatEnt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMonInstProEndDatEnt")%>:</td><td><input name="txtEndSta" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProEndDatEnt")%>" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" type="text" value="<%=dBean.fmtDate(dBean.getFilter().getDateEndFrom())%>">
		   							-
		   							<input name="txtEndEnd" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMonInstProEndDatEnt")%>" class="txtDate" size="10" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" type="text" value="<%=dBean.fmtDate(dBean.getFilter().getDateEndTo())%>"></td></tr></table></div><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td></td><td colspan=3 align="right"><button type="button" onclick="btnSearch_click()" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></td></tr></table></DIV><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")%></DIV><div type="grid" id="gridList" multiSelect="false" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table width="900px" cellpadding="0" cellspacing="0"><thead><tr><% canOrderBy = dBean.getFilter().getOrderBy() != MonitorProcessFilterVo.ORDER_PRO_NRO_REG; %><th min_width="100px" style="min-width:100px;width:50%<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=MonitorProcessFilterVo.ORDER_PRO_NRO_REG%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProNroReg")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblMonInstProNroReg")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != MonitorProcessFilterVo.ORDER_PRO_NAME; %><th min_width="100px" style="min-width:100px;width:50%<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=MonitorProcessFilterVo.ORDER_PRO_NAME%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblMonProNom")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblMonProNom")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != MonitorProcessFilterVo.ORDER_PRO_ACTION; %><th min_width="100px" style="width:100px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=MonitorProcessFilterVo.ORDER_PRO_ACTION%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblMonProAct")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblMonProAct")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != MonitorProcessFilterVo.ORDER_PRO_STATUS; %><th min_width="100px" style="display:none;width:100px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=MonitorProcessFilterVo.ORDER_PRO_STATUS%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProSta")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblMonInstProSta")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != MonitorProcessFilterVo.ORDER_PRO_CREATE_USER; %><th min_width="100px" style="width:100px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=MonitorProcessFilterVo.ORDER_PRO_CREATE_USER%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProCreUsu")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblMonInstProCreUsu")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != MonitorProcessFilterVo.ORDER_PRO_CREATE_DATE; %><th min_width="120px" style="width:120px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=MonitorProcessFilterVo.ORDER_PRO_CREATE_DATE%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProCreDat")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblMonInstProCreDat")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != MonitorProcessFilterVo.ORDER_PRO_END_DATE; %><th min_width="150px"  style="display:none;width:150px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=MonitorProcessFilterVo.ORDER_PRO_END_DATE%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProEndDat")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblMonInstProEndDat")%><%=canOrderBy?"</u>":""%></th></tr></thead><tbody><%	Collection col = dBean.getList();
							if (col != null) {
								Iterator it = col.iterator();
								int i = 0;
								MonitorProcessVo mPVo = null;
								while (it.hasNext()) {
									mPVo = (MonitorProcessVo) it.next();  %><tr row_id="<%=dBean.fmtStr(mPVo.getReqString())%>" onclick="selectTask(this)" id=LIST><td style="min-width:100px" <%=mPVo.isLate()?"class=\"tdProLat\"":mPVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPVo.getProcessIdentification())%></td><td style="min-width:100px" <%=mPVo.isLate()?"class=\"tdProLat\"":mPVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPVo.getProName())%></td><td <%=mPVo.isLate()?"class=\"tdProLat\"":mPVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=
											ProcessVo.PROCESS_ACTION_CREATION.equals(mPVo.getProAction())?LabelManager.getName(labelSet,"lblMonProActCre"):
											ProcessVo.PROCESS_ACTION_ALTERATION.equals(mPVo.getProAction())?LabelManager.getName(labelSet,"lblMonProActAlt"):
											ProcessVo.PROCESS_ACTION_CANCEL.equals(mPVo.getProAction())?LabelManager.getName(labelSet,"lblMonProActCan"):""
										%></td><td style="display:none;" <%=mPVo.isLate()?"class=\"tdProLat\"":mPVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=
											ProInstanceVo.PROC_STATUS_RUNNING.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,"lblMonInstProStaRun"):
											ProInstanceVo.PROC_STATUS_CANCELLED.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,"lblMonInstProStaCan"):
											ProInstanceVo.PROC_STATUS_FINALIZED.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,"lblMonInstProStaFin"):
											ProInstanceVo.PROC_STATUS_COMPLETED.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,"lblMonInstProStaCom"):""
										%></td><td <%=mPVo.isLate()?"class=\"tdProLat\"":mPVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPVo.getProUserName())%></td><td <%=mPVo.isLate()?"class=\"tdProLat\"":mPVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPVo.getProInstCreateDate())%></td><td style="display:none" <%=mPVo.isLate()?"class=\"tdProLat\"":mPVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPVo.getProInstEndDate())%></td></tr><%i++;%><%}
							}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><%@include file="../../includes/navButtons.jsp" %><td><button type="button" onclick="btnRollback_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMonTsk")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMonTsk")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMonTsk")%></button></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">
function onLoadHtml() {
<% if (showFilter) { %>
	toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>);
<% } %>
}
</script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/execution/proRollback/rollback.js'></script>