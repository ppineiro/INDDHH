<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.ReleaseTaskBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titLibTar")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatTar")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><% if (dBean.getTaskLists() != null) {
					for (Iterator it = dBean.getTaskLists().iterator(); it.hasNext(); ) { 
						TasksListVo taskVo = (TasksListVo) it.next(); %><tr><td><%=LabelManager.getName(labelSet,"lblTit")%>:</td><td><%=dBean.fmtStr(taskVo.getTaskTitle())%></td><td><%=LabelManager.getName(labelSet,"lblEjeInsProNum")%>:</td><td><%=dBean.fmtStr(ProInstanceVo.getEntityIdentification(taskVo.getProcInstIdPre(),taskVo.getProcInstIdNum(),taskVo.getProcInstIdPos()))%></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblUsu")%>:</td><td><%=dBean.fmtStr(taskVo.getUserLogin())%></td><td><%=LabelManager.getName(labelSet,"lblEjeFecAdqTar")%></td><td><%=dBean.fmtDateAMPM(taskVo.getTaskAcquired())%></td></tr><tr><td>&nbsp;</td></tr><%	}
				} %></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script src="<%=Parameters.ROOT_PATH%>/programs/execution/taskRelease/confirm.js"></script><%@include file="../../../components/scripts/server/endInc.jsp" %>

