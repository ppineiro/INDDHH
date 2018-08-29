<%@page import="com.dogma.bean.query.MonitorBusinessBean"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bean.query.MonitorProcessesBean"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body><%

MonitorBusinessBean monBusMonitorBean = (MonitorBusinessBean) session.getAttribute("dBean");
MonitorProcessesBean dBean = monBusMonitorBean.getMonitorProcessesBean(); 

%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMon")%>: <%= dBean.getMonProInstanceVo().getProTitle() %> (<%= dBean.getMonProInstanceVo().getProcessIdentification() %>)</TD><TD></TD></TR></TABLE><DIV id="divContent" name="divContent" <%=cmp_div_height%> class="divContent"><form id="frmMain" name="frmMain" method="POST"><%	if (dBean.getFilter().getShowTask() == MonitorProcessFilterVo.SHOW_TSK_VISUAL) { %><DIV class="divContent"><TABLE class="tblFormLayout" WIDTH="100%" BORDER=0 cellspacing=0><TR><TD VALIGN="middle" ALIGN="center"><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" WIDTH="100%" HEIGHT="450px" id="shell" ALIGN="center" VALIGN="middle"><param name="allowScriptAccess" value="sameDomain" /><param name="movie" value="<%=Parameters.ROOT_PATH%>/flash/proMon/deploy/shell.swf" /><param name="FlashVars" value="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&definition=query.MonitorProcessesAction.do?xml=true%26action=&IN_APIA=true&SWF_OBJ_PATH=<%=Parameters.ROOT_PATH%>/flash/proMon/deploy/"/><param name="quality" value="high" /><param name="menu" value="false"><param name="wmode" value="transparent" /><embed menu="false" wmode="transparent" allowScriptAccess="sameDomain" src="<%=Parameters.ROOT_PATH%>/flash/proMon/deploy/shell.swf" quality="high" bgcolor="#efefef" width="100%" height="450" swLiveConnect="true" id="shell" name="shell" align="middle" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" flashVars="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&definition=query.MonitorProcessesAction.do?xml=true%26action=&IN_APIA=true&SWF_OBJ_PATH=<%=Parameters.ROOT_PATH%>/flash/proMon/deploy/" /></object></TD></TR></TABLE></DIV><%	} else { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtMonTsk")%></DIV><div type="grid" id="gridList" style="HEIGHT:<%= Parameters.FILTER_LIST_SIZE+100%>px"><table width="900px" cellpadding="0" cellspacing="0"><thead><tr><%
								if (dBean.getFilter().getShowTask() != MonitorProcessFilterVo.SHOW_TSK_GANTT) { %><th style="width:200px" title="<%=LabelManager.getToolTip(labelSet,"lblMonTskPro")%>"><%=LabelManager.getName(labelSet,"lblMonTskPro")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonPoolNom")%>"><%=LabelManager.getName(labelSet,"lblMonPoolNom")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstSta")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstSta")%></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstDatRea")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstDatRea")%></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstDatEnd")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstDatEnd")%></th><%
									if (dBean.getFilter().getShowTask() != MonitorProcessFilterVo.SHOW_TSK_STATE) { %><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstHtyEve")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstHtyEve")%></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstHtyDay")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstHtyDay")%></th><%
									} %><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonUsrLog")%>"><%=LabelManager.getName(labelSet,"lblMonUsrLog")%></th><%
								} %></tr></thead><tbody><%
							if (dBean.getFilter().getShowTask() == MonitorProcessFilterVo.SHOW_TSK_GANTT) { %><tr><td bgcolor="#EAEAEA"><img id="img<%= MonitorProcessesBean.GANTT_REAL_HOPED %>" src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif'><br><br><br><img id="img<%= MonitorProcessesBean.GANTT_REAL %>" src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif'></td></tr><%
							} else {
					   			Collection col = dBean.getProInstTasks();
								if (col != null) {
									Iterator it = col.iterator();
									int i = 0;
									MonitorTaskVo mPITVo;
									boolean salto = dBean.getFilter().getShowTask() == MonitorProcessFilterVo.SHOW_TSK_GROUP;
									Integer oldProEleInstId = null;
									while (it.hasNext()) {
										mPITVo = (MonitorTaskVo) it.next(); 
										if (salto) {
											if (MonitorTaskVo.FOR_PROCESS_ASYNC.equals(mPITVo.getMonFor()) || MonitorTaskVo.FOR_PROCESS_SYNC.equals(mPITVo.getMonFor()) || ! mPITVo.getProEleInstId().equals(oldProEleInstId)) {
												if (oldProEleInstId != null) { %><tr onclick="validateTask()"><td>&nbsp </td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr><%
												}
												i++;
												oldProEleInstId = mPITVo.getProEleInstId();
											}
										} %><tr onclick="validateTask()" row_id="<%=dBean.fmtStr(mPITVo.getReqString())%>" row_for="<%=dBean.fmtStr(mPITVo.getMonFor())%>" id=LIST><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getTskTitle())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getPoolName())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=
												ProEleInstanceVo.ELE_STATUS_WAITING.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaWai"):
												ProEleInstanceVo.ELE_STATUS_READY.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRea"):
												ProEleInstHistoryVo.HTY_EVENT_RELEASE.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRea"):
												ProEleInstanceVo.ELE_STATUS_ACQUIRED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaAcq"):
												ProEleInstanceVo.ELE_STATUS_COMPLETED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaCom"):
												ProEleInstanceVo.ELE_STATUS_UNDO.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRol"):
												ProEleInstanceVo.ELE_STATUS_CANCELLED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaCan"):
												ProInstanceVo.PROC_STATUS_CANCELLED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaCan"):												
												ProInstanceVo.PROC_STATUS_FINALIZED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaFin"):												
												ProEleInstanceVo.ELE_STATUS_SUSPENDED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaSus"):
												ProEleInstanceVo.ELE_STATUS_ROLLBACK.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRol"):												
												ProEleInstanceVo.ELE_STATUS_SKIPPED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaSki"):
													ProEleInstHistoryVo.HTY_EVENT_DEALLOCATE.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRea"):""
											%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPITVo.getProEleInstDateReady())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPITVo.getProEleInstDateEnd())%></td><%
											if (dBean.getFilter().getShowTask() != MonitorProcessFilterVo.SHOW_TSK_STATE) { %><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=
													ProEleInstHistoryVo.HTY_EVENT_CREATED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveCre"):
													ProEleInstHistoryVo.HTY_EVENT_WAITING.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveWai"):
													ProEleInstHistoryVo.HTY_EVENT_READY.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveRea"):
													ProEleInstHistoryVo.HTY_EVENT_ACQUIRED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveAcq"):
													ProEleInstHistoryVo.HTY_EVENT_COMPLETED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveCom"):
													ProEleInstHistoryVo.HTY_EVENT_UNDO.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveRol"):
													ProEleInstHistoryVo.HTY_EVENT_CANCELLED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveCan"):
													ProEleInstHistoryVo.HTY_EVENT_SUSPENDED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveSus"):
													ProEleInstHistoryVo.HTY_EVENT_RESUME.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveRes"):													
													ProEleInstHistoryVo.HTY_EVENT_RELEASE.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveRel"):
													ProEleInstHistoryVo.HTY_EVENT_SKIPPED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveSki"):
													ProEleInstHistoryVo.HTY_EVENT_REASIGNED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveReg"):
													ProEleInstHistoryVo.HTY_EVENT_ELEVATED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveEle"):
													ProEleInstHistoryVo.HTY_EVENT_DELEGATED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveDel"):
													ProEleInstHistoryVo.HTY_EVENT_ROLLBACK.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveRol"):
													ProEleInstHistoryVo.HTY_EVENT_DEALLOCATE.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,"lblMonProEleInstHtyEveDea"):""
												%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPITVo.getHtyDate())%></td><%
											} %><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getUsrLogin())%></td></tr><%
										i++;
									}
								}
							}%></tbody></table></div><%	}%></div></body></html><%@include file="../../../../components/scripts/server/endInc.jsp" %><script language="javascript">
function tabSwitch(){
}

var disableButton = true;
var hasParent = <%= dBean.getParent() != null %>;
var hasQueryProcessMonitor = <%= dBean.isFromQueryProcessMonitor() %>;
var hasQueryTaskMonitor = <%= dBean.isFromQueryTaskMonitor() %>;

window.onload=function(){
<%	if (dBean.getFilter().getShowTask() == MonitorProcessFilterVo.SHOW_TSK_GANTT) { %>
	var width = screen.availWidth-200;
	document.getElementById("img<%= MonitorProcessesBean.GANTT_REAL_HOPED %>").src="<%=Parameters.ROOT_PATH%>/programs/query/monitor/process/gantt.jsp?type=<%= MonitorProcessesBean.GANTT_REAL_HOPED %>&width=" + width;
	document.getElementById("img<%= MonitorProcessesBean.GANTT_REAL %>").src="<%=Parameters.ROOT_PATH%>/programs/query/monitor/process/gantt.jsp?type=<%= MonitorProcessesBean.GANTT_REAL %>&width=" + width;
<% } %>
}

</script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/query/monitor/process/monitor.js'></script>